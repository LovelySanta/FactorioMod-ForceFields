require 'src/utilities'
local settings = require 'src/settings'

require 'src/forcefield'
require 'src/emitter'
require 'src/gui'

require 'src/config-changes'
require 'src/testing'



-- on load game for first time or when settings change
function init()
  if not global.forcefields then
    global.forcefields = {}
  end
  global.forcefields.version = ConfigChanges.currentVersion
end

script.on_init(function(_)
  settings:verifySettings()
  init()
end)

script.on_configuration_changed(function (data)
  if data.mod_changes and data.mod_changes.ForceFields2 and data.mod_changes.ForceFields2.old_version then
    ConfigChanges:onConfigurationChanged()
    settings:verifySettings()
  end
end)



-- on loading the map
script.on_event(defines.events.on_tick, nil)
script.on_load(function(event)
  if global.forcefields and global.forcefields.ticking then
    script.on_event(defines.events.on_tick, function(_) Emitter:onTick() end)
  end
end)



-- When the player quick paste settings
local onEntitySettingsPasted = function(event)
  if event.source.name == settings.emitterName and event.destination.name == settings.emitterName then
    Emitter:onEntitySettingsPasted(event)
  end
end
script.on_event(defines.events.on_entity_settings_pasted, onEntitySettingsPasted)



-- When entities get created
local onEntityCreated = function(event)
  local createdEntity = event.created_entity or event.entity
  if (not createdEntity) or (not createdEntity.valid) then return end
  if createdEntity.name == settings.emitterName then
    Emitter:onEmitterBuilt(createdEntity)
  end
end
script.on_event({defines.events.on_built_entity      ,
                 defines.events.on_robot_built_entity,
                 defines.events.script_raised_built  }, onEntityCreated)

script.on_event(defines.events.on_entity_cloned, function(event)
  if event.destination.name == settings.emitterName then
    -- Step 1: simulate the create event for the destination
    onEntityCreated{
      entity = event.destination,
    }
    -- Step 2: simulate copy pasting without a player
    onEntitySettingsPasted{
      player_index = nil,
      source       = event.source,
      destination  = event.destination,
    }
  elseif settings.forcefieldTypes[event.destination.name] ~= nil then
    -- Field walls cannot be cloned, they are generated by the emitter
    log("ERROR: Something tried cloning a forcefield wall!")
    event.destination.destroy{raise_destroy = true}
  end
end)



-- When entities get damaged (creates a trigger entity)
script.on_event(defines.events.on_entity_damaged, function(event)
  -- Check if a forcefield is damaged
  if settings.forcefieldTypes[event.entity.name] ~= nil then
    Forcefield:onForcefieldDamaged(event.entity)
  end
end)

-- When entities get destroyed
script.on_event({defines.events.on_entity_died       ,
                 defines.events.script_raised_destroy}, function(event)
  if not event.entity then return end
  if settings.forcefieldTypes[event.entity.name] ~= nil then
    Forcefield:onForcefieldDied(event.entity)
  elseif event.entity.name == settings.emitterName then
    Emitter:onEmitterDied(event.entity)
  end
end)

script.on_event({defines.events.on_pre_surface_cleared,
                 defines.events.on_pre_surface_deleted}, function(event)
  local surface = game.surfaces[event.surface_index]

  -- Step 1: delete all emitters
  for _,emitter in pairs(surface.find_entities_filtered{
    name = settings.emitterName,
  }) do
    emitter.destroy{raise_destroy = true}
  end

  -- Step 2: delete all forcefields
  local forcefieldNames = {}
  for forcefieldType,_ in pairs(settings.forcefieldTypes) do
    forcefieldNames[#forcefieldNames + 1] = forcefieldType
  end
  for _,forcefield in pairs(surface.find_entities_filtered{
    name = forcefieldNames,
  }) do
    forcefield.destroy{raise_destroy = true}
  end
end)



-- When entities get mined/deconstructed
script.on_event(defines.events.on_pre_player_mined_item, function(event)
  if settings.forcefieldTypes[event.entity.name] ~= nil then
    Forcefield:onForcefieldMined(event.entity, event.player_index)
  elseif event.entity.name == settings.emitterName then
    Emitter:onEmitterMined(event.entity, event.player_index)
  end
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
  if event.entity.name == settings.emitterName then
    Emitter:onEmitterMined(event.entity)
  end
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
  if settings.forcefieldTypes[event.entity.name] ~= nil then
    -- Forcefields itself can't be deconstructed
    event.entity.cancel_deconstruction(game.players[event.player_index].force)
  elseif event.entity.name == settings.emitterName then
    local emitterTable = Emitter:findEmitter(event.entity)
    if emitterTable ~= nil then
      emitterTable["disabled"] = true
      Forcefield:degradeLinkedFields(emitterTable)
    end
  end
end)

script.on_event(defines.events.on_cancelled_deconstruction, function(event)
  if event.entity.name == settings.emitterName then
    local emitterTable = Emitter:findEmitter(event.entity)
    if emitterTable ~= nil then
      emitterTable["disabled"] = false
      Emitter:setActive(emitterTable, true)
    end
  end
end)



-- When the player clicks on the emitter to open the gui
script.on_event(defines.events.on_gui_opened, function(event)
  if event.gui_type == defines.gui_type.entity and event.entity.name == settings.emitterName then
    Gui:onOpenGui(event.entity, event.player_index)
  end
end)

-- When the player wants to close the gui
script.on_event(defines.events.on_gui_closed, function(event)
  Gui:onCloseGui(event.element, event.player_index)
end)

-- When the player clicks on a button
script.on_event(defines.events.on_gui_click, function(event)
  if Gui.guiButtonHandlers[event.element.name] then
    Gui.guiButtonHandlers[event.element.name](Gui, event)
  -- Check for wall config button pressed
  elseif string.find(event.element.name, Gui.guiElementNames.configOption) then
    Gui.guiButtonHandlers[Gui.guiElementNames.configOption](Gui, event)
  elseif string.find(event.element.name, Gui.guiElementNames.configRowOption) then
    Gui.guiButtonHandlers[Gui.guiElementNames.configRowOption](Gui, event)
  end
end)
