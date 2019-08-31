local settings = require 'src/settings'
require 'src/utilities'
require "__LSlib__/LSlib"

require 'util'


Emitter = {}


function Emitter:onEmitterBuilt(createdEntity)
  local newEmitter = {}
  local surface = createdEntity.surface
  if not global.forcefields then
    global.forcefields = {}
  end
  if global.forcefields.emitters == nil then
    global.forcefields.emitters = {}
    global.forcefields.emitterNEI = 1 -- NextEmitterIndex
  end
  local maxWidth = settings.emitterMaxWidth
  local widthOffset = (maxWidth + 1)/2
  local defaultType = settings.defaultFieldSuffix

  -- emitter data
  newEmitter["emitter-NEI"] = "I" .. global.forcefields.emitterNEI
  newEmitter["entity"] = createdEntity
  -- emitter settings
  newEmitter["type"] = settings.defaultFieldType
  newEmitter["setup"] = settings.defaultFieldSetup
  newEmitter["config"] = {}
  for i=1, maxWidth do
    newEmitter["config"][i-widthOffset] = defaultType
  end
  newEmitter["distance"] = settings.emitterDefaultDistance
  newEmitter["width"] = settings.emitterDefaultWidth
  newEmitter["direction"] = settings.defaultFieldDirection
  newEmitter["width-upgrades"] = 0
  newEmitter["distance-upgrades"] = 0
  -- emitter state
  newEmitter["active"] = false
  newEmitter["disabled"] = true
  newEmitter["build-scan"] = true -- set active for looking to build new fields
  newEmitter["build-tick"] = 0
  newEmitter["generating-fields"] = nil
  newEmitter["damaged-fields"] = nil

  -- Simulates reviving killed emitters => it copies old settings
  if global.forcefields.killedEmitters ~= nil then
    for k,killedEmitter in pairs(global.forcefields.killedEmitters) do
      if killedEmitter["surface"] == surface and killedEmitter["position"].x == createdEntity.position.x and killedEmitter["position"].y == createdEntity.position.y then
        newEmitter["disabled"] = killedEmitter["disabled"]
        newEmitter["type"] = killedEmitter["type"]
        newEmitter["setup"] = killedEmitter["setup"]
        newEmitter["config"] = util.table.deepcopy(killedEmitter["config"])
        newEmitter["distance"] = killedEmitter["distance"]
        newEmitter["width"] = killedEmitter["width"]
        newEmitter["direction"] = killedEmitter["direction"]
        self:removeKilledEmitter(k)
        break
      end
    end
  end

  global.forcefields.emitters["I" .. global.forcefields.emitterNEI] = util.table.deepcopy(newEmitter)
  global.forcefields.emitterNEI = global.forcefields.emitterNEI + 1

  self:setActive(newEmitter, true, true)
end



function Emitter:onEmitterMined(emitter, playerIndex)
  local emitterTable = self:findEmitter(emitter)
  if not emitterTable then return end
  local player = playerIndex and game.players[playerIndex] or nil

  self:removeEmitterID(emitterTable["emitter-NEI"])

  if emitterTable["distance-upgrades"] ~= 0 then
    if player then
      transferToPlayer(player, {name = "advanced-circuit", count = emitterTable["distance-upgrades"]})
    else
      dropOnGround(emitterTable["entity"].surface, emitterTable["entity"].position, {name = "advanced-circuit", count = emitterTable["distance-upgrades"]}, true, emitterTable["entity"].force)
    end
  end
  if emitterTable["width-upgrades"] ~= 0 then
    if player then
      transferToPlayer(player, {name = "processing-unit", count = emitterTable["width-upgrades"]})
    else
      dropOnGround(emitterTable["entity"].surface, emitterTable["entity"].position, {name = "processing-unit", count = emitterTable["width-upgrades"]}, true, emitterTable["entity"].force)
    end
  end
  
end



function Emitter:onEmitterDied(emitter)
  local emitterTable = self:findEmitter(emitter)
  if emitterTable == nil then return end

  self:removeEmitterID(emitterTable["emitter-NEI"])
  self:storeKilledEmitter(emitterTable)
end



function Emitter:onEntitySettingsPasted(event)
  local playerIndex = event.player_index
  local player = playerIndex and game.players[playerIndex] or nil
  local sourceEmitterTable = self:findEmitter(event.source)
  local destinationEmitterTable = self:findEmitter(event.destination)

  if sourceEmitterTable["disabled"] == true then
    if playerIndex then
      player.print("You cannot paste settings from a disabled emitter. Please reconfigure that one first.")
    end
    return
  end

  if not playerIndex then
    -- assume this is not done by a player, we don't care about taking/giving upgrades
    destinationEmitterTable["distance-upgrades"] = sourceEmitterTable["distance-upgrades"]
    destinationEmitterTable["width-upgrades"] = sourceEmitterTable["width-upgrades"]
  else
    -- Check distance upgrades
    if destinationEmitterTable["distance-upgrades"] ~= sourceEmitterTable["distance-upgrades"] then
      if destinationEmitterTable["distance-upgrades"] < sourceEmitterTable["distance-upgrades"] then
        -- Not enough distanceUpgrades, try take some from the player
        local missingAmount = takeFromPlayer(player, {name = "advanced-circuit", count = sourceEmitterTable["distance-upgrades"] - destinationEmitterTable["distance-upgrades"]})
        destinationEmitterTable["distance-upgrades"] = sourceEmitterTable["distance-upgrades"] - missingAmount
      else -- too many distanceUpgrades, give some back to the player
        transferToPlayer(player, {name = "advanced-circuit", count = destinationEmitterTable["distance-upgrades"] - sourceEmitterTable["distance-upgrades"]})
        destinationEmitterTable["distance-upgrades"] = sourceEmitterTable["distance-upgrades"]
      end
    end
    -- Check width upgrades
    if destinationEmitterTable["width-upgrades"] ~= sourceEmitterTable["width-upgrades"] then
      if destinationEmitterTable["width-upgrades"] < sourceEmitterTable["width-upgrades"] then
        -- Not enough distanceUpgrades, try take some from the player
        local missingAmount = takeFromPlayer(game.players[playerIndex], {name = "processing-unit", count = sourceEmitterTable["width-upgrades"] - destinationEmitterTable["width-upgrades"]})
        destinationEmitterTable["width-upgrades"] = sourceEmitterTable["width-upgrades"] - missingAmount
      else -- too many distanceUpgrades, give some back to the player
        transferToPlayer(game.players[playerIndex], {name = "processing-unit", count = destinationEmitterTable["width-upgrades"] - sourceEmitterTable["width-upgrades"]})
        destinationEmitterTable["width-upgrades"] = sourceEmitterTable["width-upgrades"]
      end
    end
  end

  -- If any changes on the forcefield, we need to rebuild it
  local hasEnoughUpgrades = true
  local maxWidth = settings.emitterDefaultWidth + (destinationEmitterTable["width-upgrades"] * settings.widthUpgradeMultiplier)
  local maxDistance = settings.emitterDefaultDistance + destinationEmitterTable["distance-upgrades"]
  if destinationEmitterTable["disabled"] ~= false
    or destinationEmitterTable["distance"] ~= sourceEmitterTable["distance"]
    or destinationEmitterTable["width"] ~= sourceEmitterTable["width"]
    or destinationEmitterTable["type"] ~= sourceEmitterTable["type"]
    or destinationEmitterTable["setup"] ~= sourceEmitterTable["setup"]
    or destinationEmitterTable["direction"] ~= sourceEmitterTable["direction"]
    or not LSlib.utils.table.areEqual(destinationEmitterTable["config"], sourceEmitterTable["config"]) then --TODO config setting

    Forcefield:degradeLinkedFields(destinationEmitterTable)
    destinationEmitterTable["damaged-fields"] = nil
    -- For the width check if there are enough upgrades
    if sourceEmitterTable["width"] > maxWidth then
      destinationEmitterTable["width"] = maxWidth
      hasEnoughUpgrades = false
    else
      destinationEmitterTable["width"] = sourceEmitterTable["width"]
    end
    -- For the distance check if there are enough upgrades
    if sourceEmitterTable["distance"] > maxWidth then
      destinationEmitterTable["distance"] = maxWidth
      hasEnoughUpgrades = false
    else
      destinationEmitterTable["distance"] = sourceEmitterTable["distance"]
    end

    destinationEmitterTable["type"] = sourceEmitterTable["type"]
    destinationEmitterTable["setup"] = sourceEmitterTable["setup"]
    destinationEmitterTable["direction"] = sourceEmitterTable["direction"]
    destinationEmitterTable["config"] = util.table.deepcopy(sourceEmitterTable["config"])
    destinationEmitterTable["generating-fields"] = nil
    destinationEmitterTable["disabled"] = sourceEmitterTable["disabled"]

    if not hasEnoughUpgrades then
      if playerIndex then
        player.print("Could not paste all settings becose you don't have enough upgrades for it.")
      end
    end

    self:setActive(destinationEmitterTable, true, false)
  end
end



function Emitter:findEmitter(emitter)
  if global.forcefields.emitters ~= nil then
    for k,v in pairs(global.forcefields.emitters) do
      if v["entity"] == emitter then
        return v
      end
    end
  end
end



function Emitter:setActive(emitterTable, enableCheckBuildingFields, skipResetTimer)
  if emitterTable["disabled"] == true then
    return
  end

  if enableCheckBuildingFields then
    emitterTable["build-scan"] = true
    if not skipResetTimer and emitterTable["build-tick"] > settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["respawnRate"] or not emitterTable["active"] then
      emitterTable["build-tick"] = settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["respawnRate"]
    end
  end

  if not emitterTable["active"] then
    emitterTable["active"] = true
    if global.forcefields.activeEmitters == nil then
      global.forcefields.activeEmitters = {}
    end
    table.insert(global.forcefields.activeEmitters, emitterTable)
    self:activateTicker()
  end
end



function Emitter:activateTicker()
  if not global.forcefields.ticking then
    global.forcefields.ticking = settings.tickRate
    script.on_event(defines.events.on_tick, function(_) Emitter:onTick() end)
  end
end



function Emitter:onTick()
  if global.forcefields.ticking == 0 then
    global.forcefields.ticking = settings.tickRate - 1
    self:updateTick()
  else
    global.forcefields.ticking = global.forcefields.ticking - 1
  end
end



function Emitter:updateTick()
  local shouldKeepTicking
  -- Active emitters tick
  if global.forcefields.activeEmitters ~= nil then
    local shouldRemainActive
    local emitterTable
    shouldKeepTicking = true

    -- For each active emitter check if they have fields to repair or fields to build
    for k,emitterTable in pairs(global.forcefields.activeEmitters) do
      if emitterTable["entity"].valid then
        -- By default let us not keep it active, if its needed we re-activate it
        shouldRemainActive = false

        -- Building new forcefields (newly build or destroyed)
        if emitterTable["disabled"] == false then
          if emitterTable["build-scan"] ~= nil then
            -- The function will toggle index 4 (build-scan) if it finishes building fields.
            if Forcefield:scanAndBuildFields(emitterTable) then
              shouldRemainActive = true
            end
          end
        end

        -- Generate health afther a field has been build
        if emitterTable["generating-fields"] then
          -- The function will toggle index 11 (generating-fields) if it finishes generating fields.
          if Forcefield:generateFields(emitterTable) then
            shouldRemainActive = true
          end
        end

        -- Regenerate health when damaged
        if emitterTable["damaged-fields"] then
          -- The function will toggle index 3 (emitterTable) if it finishes repairing fields.
          if Forcefield:regenerateFields(emitterTable) then
            shouldRemainActive = true
          end
        end

        if not shouldRemainActive then
          -- Index 2 (active) is the active state of the emitter
          emitterTable["active"] = false
          if not self:removeActiveEmitterID(k) then
            break
          end
        end
      else
        self:removeEmitterID(emitterTable["emitter-NEI"])
        if not self:removeActiveEmitterID(k) then
          break
        end
      end
    end
  end

  -- Degrading force fields tick - happens when a emitter dies or is mined.
  if global.forcefields.degradingFields ~= nil then
    shouldKeepTicking = true
    for k,v in pairs(global.forcefields.degradingFields) do
      -- TODO change v[entity] in config change + add position and surface
      --if not v["fieldEntity"] and v["entity"] then
      --  v["fieldEntity"] = v["entity"]
      --end
      if v["fieldEntity"].valid then
        v["fieldEntity"].health = v["fieldEntity"].health - (settings.forcefieldTypes[v["fieldEntity"].name]["degradeRate"] * settings.tickRate)
        if v["fieldEntity"].health == 0 then
          v["fieldEntity"].destroy()
          if not Forcefield:removeDegradingFieldID(k) then
            break
          end
        end
      else
        if not Forcefield:removeDegradingFieldID(k) then
          break
        end
      end
    end
  end

  if global.forcefields.searchDamagedPos ~= nil then
    local searchDamagedPos = global.forcefields.searchDamagedPos
    shouldKeepTicking = true
    -- for each damages position
    for index,xs in pairs (searchDamagedPos) do
      local surface = game.surfaces[index]

      -- for each sy location in each sx location
      for sx,ys in pairs(xs) do
        for sy in pairs(ys) do

          local foundFields = Forcefield:findForcefieldsRadius(surface, {x = sx + 0.5, y = sy + 0.5}, 1)
          if foundFields ~= nil then
            Forcefield:handleDamagedFields(foundFields)
          end
          table.remove(ys, sy)
        end
        table.remove(searchDamagedPos, sx)
      end
      table.remove(searchDamagedPos, index)
    end

    if #searchDamagedPos == 0 then
      searchDamagedPos = nil
    end

    global.forcefields.searchDamagedPos = searchDamagedPos
  end

  if not shouldKeepTicking then
    global.forcefields.ticking = nil
    script.on_event(defines.events.on_tick, nil)
  end
end



function Emitter:removeEmitterID(emitterID)
  if global.forcefields.emitters ~= nil then
    if global.forcefields.emitters[emitterID] ~= nil then
      Forcefield:degradeLinkedFields(global.forcefields.emitters[emitterID])
      global.forcefields.emitters[emitterID] = nil
      if LSlib.utils.table.isEmpty(global.forcefields.emitters) then
        global.forcefields.emitters = nil
        global.forcefields.emitterNEI = nil
      else
        return true
      end
    end
  end
end



function Emitter:removeActiveEmitterID(activeEmitterID)
  -- Returns true if the global.forcefields.activeEmitters table isn't empty
  if global.forcefields.activeEmitters ~= nil and global.forcefields.activeEmitters[activeEmitterID] ~= nil then
    table.remove(global.forcefields.activeEmitters, activeEmitterID)
    if #global.forcefields.activeEmitters == 0 then
      global.forcefields.activeEmitters = nil
    else
      return true
    end
  end
end



function Emitter:removeKilledEmitter(killedEmittersIndex)
  table.remove(global.forcefields.killedEmitters, killedEmittersIndex)
  if #global.forcefields.killedEmitters == 0 then
    global.forcefields.killedEmitters = nil
  end
end



function Emitter:storeKilledEmitter(emitterTable)
  local newKilledEmitter = {}
  if global.forcefields.killedEmitters == nil then
    global.forcefields.killedEmitters = {}
  end
  newKilledEmitter["disabled"] = emitterTable["disabled"]
  newKilledEmitter["surface"] = emitterTable["entity"].surface
  newKilledEmitter["position"] = emitterTable["entity"].position
  newKilledEmitter["width"] = emitterTable["width"]
  newKilledEmitter["distance"] = emitterTable["distance"]
  newKilledEmitter["type"] = emitterTable["type"]
  newKilledEmitter["config"] = emitterTable["config"]
  newKilledEmitter["direction"] = emitterTable["direction"]
  table.insert(global.forcefields.killedEmitters, newKilledEmitter)
end
