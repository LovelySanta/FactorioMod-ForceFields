require 'util'
require "__LSlib__/LSlib"


ConfigChanges = {}

ConfigChanges.currentVersion = 1.5



function ConfigChanges:onConfigurationChanged()
  log("Updating ForceFields to the new version, thanks for using this mod.")
  if global.forcefields and global.forcefields.version then
    if global.forcefields.version == 1.0 then
      log("Updating ForceFields from version 1.0 to version 1.1")
      self:updateToVersion_1_1()
    end
    if global.forcefields.version == 1.1 then
      log("Updating ForceFields from version 1.1 to version 1.2")
      self:updateToVersion_1_2()
    end
    if global.forcefields.version == 1.2 then
      log("Updating ForceFields from version 1.2 to version 1.3")
      self:updateToVersion_1_3()
    end
    if global.forcefields.version == 1.3 then
      log("Updating ForceFields from version 1.3 to version 1.4")
      self:updateToVersion_1_4()
    end
    if global.forcefields.version == 1.4 then
      log("Updating ForceFields from version 1.4 to version 1.5")
      self:updateToVersion_1_5()
    end
  end
  log("ForceFields are updated! Have a nice gaming session!")
end



function ConfigChanges:updateToVersion_1_1()
  -- this is just for a test
  global.forcefields.version = 1.1
end



function ConfigChanges:updateToVersion_1_2()
  -- close all gui's
  if global.forcefields.emitterConfigGuis ~= nil then
    for playerIndex,  player in pairs(game.players) do
      local guiCenter = player.gui.center
      if global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil then
        guiCenter["emitterConfig"].destroy()
        global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
        if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
          global.forcefields.emitterConfigGuis = nil
          break
        end
      end
    end
  end

  -- add config to all emitter tables (emitterConfig)
  -- update types of emitters (updateEmitterType)
  local emitterConfig = {}
  for i=-32, 32 do
    emitterConfig[i] = "-forcefield"
  end
  local updateEmitterType = {
    ["blue-forcefield"] = "blue",
    ["blue"] = "blue",
    ["green-forcefield"] = "green",
    ["green"] = "green",
    ["purple-forcefield"] = "purple",
    ["purple"] = "purple",
    ["red-forcefield"] = "red",
    ["red"] = "red",
  }
  if global.forcefields.killedEmitters ~= nil then
    local killedEmitters = global.forcefields.killedEmitters
    for k,_ in pairs(killedEmitters) do
      killedEmitters[k]["config"] = util.table.deepcopy(emitterConfig)
      killedEmitters[k]["type"] = updateEmitterType[killedEmitters[k]["type"]]
    end
    global.forcefields.killedEmitters = killedEmitters
  end
  if global.forcefields.emitters ~= nil then
    local emitters = global.forcefields.emitters
    for k,_ in pairs(emitters) do
      emitters[k]["config"] = util.table.deepcopy(emitterConfig)
      emitters[k]["type"] = updateEmitterType[emitters[k]["type"]]
    end
    global.forcefields.emitters = emitters
  end
  if global.forcefields.activeEmitters ~= nil then
    local activeEmitters = global.forcefields.activeEmitters
    for k,_ in pairs(activeEmitters) do
      activeEmitters[k]["config"] = util.table.deepcopy(emitterConfig)
      activeEmitters[k]["type"] = updateEmitterType[activeEmitters[k]["type"]]
    end
    global.forcefields.activeEmitters = activeEmitters
  end

  -- change forcefield entity to emitter
  if global.forcefields.degradingFields ~= nil then
    local degradingFields = global.forcefields.degradingFields
    for k,v in pairs(degradingFields) do
      if v["entity"] ~= nil then
        if v["fieldEntity"] == nil then
          v["fieldEntity"] = util.table.deepcopy(v["entity"])
        end
        v["entity"] = nil
      end
    end
  end

  -- now we are up to date to this version
  global.forcefields.version = 1.2
end



function ConfigChanges:updateToVersion_1_3()
  -- close all gui's
  if global.forcefields.emitterConfigGuis ~= nil then
    for playerIndex,  player in pairs(game.players) do
      local guiCenter = player.gui.center
      if global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil then
        guiCenter["emitterConfig"].destroy()
        if guiCenter["fieldConfig"] then guiCenter["fieldConfig"].destroy() end
        global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
        if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
          global.forcefields.emitterConfigGuis = nil
          break
        end
      end
    end
  end

  -- add setup to all emitter tables (emitterConfig)
  if global.forcefields.killedEmitters ~= nil then
    local killedEmitters = global.forcefields.killedEmitters
    for k,_ in pairs(killedEmitters) do
      killedEmitters[k]["setup"] = "straight"
    end
    global.forcefields.killedEmitters = killedEmitters
  end
  if global.forcefields.emitters ~= nil then
    local emitters = global.forcefields.emitters
    for k,_ in pairs(emitters) do
      emitters[k]["setup"] = "straight"
    end
    global.forcefields.emitters = emitters
  end
  if global.forcefields.activeEmitters ~= nil then
    local activeEmitters = global.forcefields.activeEmitters
    for k,_ in pairs(activeEmitters) do
      activeEmitters[k]["setup"] = "straight"
    end
    global.forcefields.activeEmitters = activeEmitters
  end

  -- now we are up to date to this version
  global.forcefields.version = 1.3
end



function ConfigChanges:updateToVersion_1_4()
  -- close all gui's
  if global.forcefields.emitterConfigGuis ~= nil then
    for playerIndex,  player in pairs(game.players) do
      local guiCenter = player.gui.center
      if global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil then
        guiCenter["emitterConfig"].destroy()
        if guiCenter["fieldConfig"] then guiCenter["fieldConfig"].destroy() end
        global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
        if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
          global.forcefields.emitterConfigGuis = nil
          break
        end
      end
    end
  end

  -- add config to all emitter tables (emitterConfig)
  local getConfigName = function(oldConfig)
    if not oldConfig then
      return "forcefield-wall-"
    elseif oldConfig == "-forcefield" then
      return "forcefield-wall-"
    elseif config == "-forcefield-gate" then
      return "forcefield-gate-"
    end
  end
  if global.forcefields.killedEmitters ~= nil then
    local killedEmitters = global.forcefields.killedEmitters
    for k,emitterTable in pairs(killedEmitters) do
      for index, emitterConfig in pairs(emitterTable["config"] or {}) do
        killedEmitters[k]["config"][index] = getConfigName(killedEmitters[k]["config"][index])
      end
    end
    global.forcefields.killedEmitters = killedEmitters
  end
  if global.forcefields.emitters ~= nil then
    local emitters = global.forcefields.emitters
    for k,emitterTable in pairs(emitters) do
      for index, emitterConfig in pairs(emitterTable["config"] or {}) do
      emitters[k]["config"][index] = getConfigName(emitters[k]["config"][index])
      end
    end
    global.forcefields.emitters = emitters
  end
  if global.forcefields.activeEmitters ~= nil then
    local activeEmitters = global.forcefields.activeEmitters
    for k,emitterTable in pairs(activeEmitters) do
      for index, emitterConfig in pairs(emitterTable["config"] or {}) do
      activeEmitters[k]["config"][index] = getConfigName(activeEmitters[k]["config"][index])
      end
    end
    global.forcefields.activeEmitters = activeEmitters
  end

  -- now we are up to date to this version
  global.forcefields.version = 1.4
end



function ConfigChanges:updateToVersion_1_5()
  -- close all gui's
  if global.forcefields.emitterConfigGuis ~= nil then
    for playerIndex,  player in pairs(game.players) do
      local guiCenter = player.gui.center
      if global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil then
        guiCenter["emitterConfig"].destroy()
        if guiCenter["fieldConfig"] then guiCenter["fieldConfig"].destroy() end
        global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
        if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
          global.forcefields.emitterConfigGuis = nil
          break
        end
      end
    end
  end

  -- add setup to fix errors in emitter table
  if global.forcefields.killedEmitters ~= nil then
    local killedEmitters = global.forcefields.killedEmitters
    for k,_ in pairs(killedEmitters) do
      killedEmitters[k]["setup"] = killedEmitters[k]["setup"] or "straight"
    end
    global.forcefields.killedEmitters = killedEmitters
  end
  if global.forcefields.emitters ~= nil then
    local emitters = global.forcefields.emitters
    for k,_ in pairs(emitters) do
      emitters[k]["setup"] = emitters[k]["setup"] or "straight"
    end
    global.forcefields.emitters = emitters
  end
  if global.forcefields.activeEmitters ~= nil then
    local activeEmitters = global.forcefields.activeEmitters
    for k,_ in pairs(activeEmitters) do
      activeEmitters[k]["setup"] = activeEmitters[k]["setup"] or "straight"
    end
    global.forcefields.activeEmitters = activeEmitters
  end

  -- now we are up to date to this version
  global.forcefields.version = 1.5
end
