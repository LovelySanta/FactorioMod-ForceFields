local settings = require 'src/settings'
require 'src/utilities'
require "__LSlib__/LSlib"


Forcefield = {}


function Forcefield:onForcefieldDamaged(damagedEntity)
  local index = damagedEntity.surface.index
  local pos = damagedEntity.position
  pos.x = math.floor(pos.x)
  pos.y = math.floor(pos.y)

  if global.forcefields.searchDamagedPos == nil then
    global.forcefields.searchDamagedPos = {}
  end
  if global.forcefields.searchDamagedPos[index] == nil then
    global.forcefields.searchDamagedPos[index] = {}
  end
  if global.forcefields.searchDamagedPos[index][pos.x] == nil then
    global.forcefields.searchDamagedPos[index][pos.x] = {}
  end
  global.forcefields.searchDamagedPos[index][pos.x][pos.y] = 1
  Emitter:activateTicker()
end



function Forcefield:onForcefieldDied(field)
  local pos = field.position
  local surface = field.surface
  local index = surface.index

  if global.forcefields.fields ~= nil and global.forcefields.fields[index] ~= nil and global.forcefields.fields[index][pos.x] ~= nil and global.forcefields.fields[index][pos.x][pos.y] ~= nil then
    local emitterID = global.forcefields.fields[index][pos.x][pos.y]
    self:removeForceFieldID(index, pos.x, pos.y)
    if global.forcefields.emitters ~= nil and global.forcefields.emitters[emitterID] ~= nil then
      Emitter:setActive(global.forcefields.emitters[emitterID], true)
    end
    if settings.forcefieldTypes[field.name]["deathEntity"] ~= nil then
      surface.create_entity({name = settings.forcefieldTypes[field.name]["deathEntity"], position = pos, force = field.force})
    end
  end

  -- Coz I don't want a ghost, and Rseding91 likes this, Kappa
  field.destroy()
end



function Forcefield:onForcefieldMined(field, playerIndex)
  if playerIndex ~= nil then
    local player = game.players[playerIndex]
    if player.character ~= nil then
      player.character.damage(settings.forcefieldTypes[field.name]["damageWhenMined"], player.force)
    end
  end

  if global.forcefields.fields ~= nil then
    local pos = field.position
    local index = field.surface.index
    if global.forcefields.fields[index] ~= nil and global.forcefields.fields[index][pos.x] ~= nil and global.forcefields.fields[index][pos.x][pos.y] ~= nil then
      local emitterTable = global.forcefields.emitters[global.forcefields.fields[index][pos.x][pos.y]]
      if emitterTable then
        Emitter:setActive(emitterTable, true)
      end
      self:removeForceFieldID(index, pos.x, pos.y)
    end
  end
end



function Forcefield:scanAndBuildFields(emitterTable)
  local buildField

  if emitterTable["build-tick"] == 0 then
    local energyBefore = emitterTable["entity"].energy
    -- Check to make sure there is enough energy
    if emitterTable["entity"].energy >= (settings.tickRate * settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["energyPerRespawn"] + settings.tickRate * settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["energyPerCharge"]) then
      local pos, xInc, yInc, incTimes = self:getFieldsArea(emitterTable)
      local fieldConfigOffset = (incTimes + 1)/2
      local blockingFields = 0
      local blockingFieldsBefore = 0
      local direction
      local force = emitterTable["entity"].force
      local surface = emitterTable["entity"].surface
      local index = surface.index

      -- Check the direction of the wall
      if emitterTable["direction"] == defines.direction.north or emitterTable["direction"] == defines.direction.south then
        direction = defines.direction.east -- horizontal
      else
        direction = defines.direction.north -- vertical
      end

      -- Check if table for that surface exist, if not, make it
      local fields = global.forcefields.fields
      if fields == nil then
        fields = {}
      end
      if fields[index] == nil then
        fields[index] = {}
      end

      for n=1,incTimes do
        -- If another emitter (or even this one previously) has built a field at this location, skip trying to build there, same if we don't have to build here
        if (fields[index][pos.x] == nil or fields[index][pos.x][pos.y] == nil) and emitterTable["config"][n-fieldConfigOffset] ~= settings.fieldEmptySuffix then
          -- If that spot has no field, we need to try and build one
          local fieldEntityName = (emitterTable["setup"] == "straight" and emitterTable["config"][n-fieldConfigOffset] or settings.fieldSuffix) .. emitterTable["type"]
          -- check if we can build the field
          if surface.can_place_entity({name = fieldEntityName, position = pos, force = force, direction = direction}) then
            local newField = surface.create_entity({name = fieldEntityName, position = pos, force = force, direction = direction})

            -- This new entity will have 0 health on creation + one load of recharge this tick
            newField.health = settings.forcefieldTypes[fieldEntityName]["chargeRate"]
            if emitterTable["generating-fields"] == nil then
              emitterTable["generating-fields"] = {}
            end
            table.insert(emitterTable["generating-fields"], newField)

            if fields[index][pos.x] == nil then
              fields[index][pos.x] = {}
            end
            fields[index][pos.x][pos.y] = emitterTable["emitter-NEI"]

            -- We have build a new field, congratz
            buildField = true
            -- Remove the power consumption for this tick
            emitterTable["entity"].energy = emitterTable["entity"].energy -  (settings.tickRate * settings.forcefieldTypes[fieldEntityName]["energyPerRespawn"])
            -- If we can't get to the end, we need to degrade as we have no power to maintain the full field
            if n ~= incTimes and emitterTable["entity"].energy == 0 then
              emitterTable["build-tick"] = settings.forcefieldTypes[fieldEntityName]["respawnRate"] * 10
              self:degradeLinkedFields(emitterTable)
              break
            end
            blockingFields = blockingFields + 1
          else -- If we can't place the field
            local blockingField = self:findForcefieldsRadius(surface, pos, 0.4, true)
            if blockingField ~= nil then
              if global.forcefields.degradingFields ~= nil then
                -- Prevents the emitter from going into extended sleep from "can't build" due to degrading fields (happens most when switching field types)
                local fpos = blockingField[1].position
                for _,field in pairs(global.forcefields.degradingFields) do
                  if field["fieldEntity"].valid and field["fieldEntity"].position.x == pos.x and field["fieldEntity"].position.y == pos.y then
                    builtField = true
                    break
                  end
                end
              end
            else
              -- Some other entity (other than a force field) is standing in the way, so we need to destroy it
              surface.create_entity({name = settings.forcefieldBuildDamageName, position = pos, force = force})
            end
          end
        else -- There is already some field here, by this or an previous field
          blockingFields = blockingFields + 1
        end

        -- onto the next field section of this field
        pos.x = pos.x + (xInc[n] or 0)
        pos.y = pos.y + (yInc[n] or 0)
      end

      -- full field is build
      if fields then
        if LSlib.utils.table.isEmpty(fields[index]) then
          fields[index] = nil
        end

        if LSlib.utils.table.isEmpty(fields) then
          fields = nil
        end
      end
      global.forcefields.fields = fields

      -- check if the whole field is blocked
      if blockingFields == incTimes then
        emitterTable["build-scan"] = nil
        return false
      else
        -- if the field is partialy blocked, we need to keep building it
        if not builtField then
          emitterTable["build-tick"] = settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["respawnRate"] * 3 + math.random(settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["respawnRate"])
        else
          emitterTable["build-tick"] = settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["respawnRate"]
        end
      end
    else -- If there is not enough energy, time to degrade
      emitterTable["build-tick"] = settings.forcefieldTypes[settings.defaultFieldSuffix .. emitterTable["type"]]["respawnRate"] * 5
      self:degradeLinkedFields(emitterTable)
    end

  else -- If its not time to build yet, decriment
    emitterTable["build-tick"] = emitterTable["build-tick"] - 1
  end

  return true
end



function Forcefield:generateFields(emitterTable)
  local availableEnergy = emitterTable["entity"].energy
  local tickRate = settings.tickRate

  -- Generate each field
  for k,field in pairs(emitterTable["generating-fields"]) do
    if field.valid then
      -- Generate field if enough energy
      if availableEnergy >= (settings.forcefieldTypes[field.name]["energyPerCharge"] * tickRate) then
        field.health = field.health + (settings.forcefieldTypes[field.name]["chargeRate"] * tickRate)
        availableEnergy = availableEnergy - (settings.forcefieldTypes[field.name]["energyPerCharge"] * tickRate)
        -- If field is fully generated, remove out of the table
        if field.health >= settings.forcefieldTypes[field.name]["maxHealth"] then
          table.remove(emitterTable["generating-fields"], k)
        end
      else -- If not enough energy
        self:degradeLinkedFields(emitterTable)
        emitterTable["generating-fields"] = {}
        emitterTable["build-tick"] = settings.forcefieldTypes[field.name]["respawnRate"] * 10
        Emitter:setActive(emitterTable, true, true)
      end
    else -- If invalid for some reason, delete it
      table.remove(emitterTable["generating-fields"], k)
    end
  end

  -- update energy of emitter
  emitterTable["entity"].energy = availableEnergy

  if #emitterTable["generating-fields"] == 0 then
    emitterTable["generating-fields"] = nil
  else
    return true
  end
end



function Forcefield:regenerateFields(emitterTable)
  local availableEnergy = emitterTable["entity"].energy
  local neededEnergy

  for k,field in pairs(emitterTable["damaged-fields"]) do
    if field.valid then
      local lostHealth = settings.forcefieldTypes[field.name]["maxHealth"] - field.health

      -- Check so we dont go over our charge rate
      local maxHealthRecharge = settings.forcefieldTypes[field.name]["chargeRate"] * settings.tickRate
      if lostHealth > maxHealthRecharge then
        lostHealth = maxHealthRecharge
      end

      -- If enough energy, we repair
      neededEnergy = settings.forcefieldTypes[field.name]["energyPerHealthLost"] * lostHealth
      if availableEnergy >= neededEnergy then
        field.health = field.health + lostHealth
        availableEnergy = availableEnergy - neededEnergy
        if field.health == settings.forcefieldTypes[field.name]["maxHealth"] then
          table.remove(emitterTable["damaged-fields"], k)
        end


      else -- Not enough energy, degrade the wall
        self:degradeLinkedFields(emitterTable)
        emitterTable["damaged-fields"] = {}
        emitterTable["build-tick"] = settings.forcefieldTypes[field.name]["respawnRate"] * 10
        Emitter:setActive(emitterTable, true, true)
      end
    else -- Remove if invalid
      table.remove(emitterTable["damaged-fields"], k)
    end
  end

  emitterTable["entity"].energy = availableEnergy
  if #emitterTable["damaged-fields"] == 0 then
    emitterTable["damaged-fields"] = nil
  else
    return true
  end
end



function Forcefield:handleDamagedFields(forceFields)
  local emitters = global.forcefields.emitters
  local fields = global.forcefields.fields
  local pos
  local surface
  local index
  local fieldShouldBeAdded
  local addedFields
  local fieldID

  if fields ~= nil and emitters ~= nil then
    -- For each possibly damaged forcefield found
    for k,field in pairs(forceFields) do
      pos = field.position
      surface = field.surface
      index = surface.index
      fieldShouldBeAdded = true

      -- If the field is known to the mod
      if fields[index] ~= nil and fields[index][pos.x] ~= nil and fields[index][pos.x][pos.y] ~= nil then
        fieldID = fields[index][pos.x][pos.y]
        -- If the field has a valid linked emitter
        if emitters[fieldID] ~= nil then
          if emitters[fieldID]["generating-fields"] ~= nil then
            for _,generatingField in pairs(emitters[fieldID]["generating-fields"]) do
              if generatingField == field then
                fieldShouldBeAdded = false
                break
              end
            end
          end

          -- Add the damaged field to the emitter damaged field table if it isn't already in it
          if fieldShouldBeAdded then
            if emitters[fieldID]["damaged-fields"] == nil then
              emitters[fieldID]["damaged-fields"] = {}
            end
            table.insert(emitters[fieldID]["damaged-fields"], field)
            Emitter:setActive(emitters[fieldID])
            addedFields = true
          end
        end
      end
    end
  end

  global.forcefields.emitters = emitters
end



function Forcefield:getFieldsArea(emitterTable)
  local pos = {}
  local xInc = {}
  local yInc = {}
  local incTimes = nil

  if emitterTable["setup"] == "straight" then
    local scanDirection = emitterTable["direction"]
    incTimes = emitterTable["width"]

    if scanDirection == defines.direction.north then
      pos.x = emitterTable["entity"].position.x - (incTimes - 1) / 2
      pos.y = emitterTable["entity"].position.y - emitterTable["distance"]
      for n=1,incTimes do xInc[n] = 1 end
    elseif scanDirection == defines.direction.east then
      pos.x = emitterTable["entity"].position.x + emitterTable["distance"]
      pos.y = emitterTable["entity"].position.y - (incTimes - 1) / 2
      for n=1,incTimes do yInc[n] = 1 end
    elseif scanDirection == defines.direction.south then
      pos.x = emitterTable["entity"].position.x + (incTimes - 1) / 2
      pos.y = emitterTable["entity"].position.y + emitterTable["distance"]
      for n=1,incTimes do xInc[n] = -1 end
    else
      pos.x = emitterTable["entity"].position.x - emitterTable["distance"]
      pos.y = emitterTable["entity"].position.y + (incTimes - 1) / 2
      for n=1,incTimes do yInc[n] = -1 end
    end

  elseif emitterTable["setup"] == "corner" then
    local radius = emitterTable["distance"]
    local direction = emitterTable["direction"]
    local fieldPosData = settings.forcefieldCircleData[radius][direction]

    pos = {
      x = emitterTable["entity"].position.x + fieldPosData.pos.x,
      y = emitterTable["entity"].position.y + fieldPosData.pos.y,
    }
    xInc = util.table.deepcopy(fieldPosData.xInc)
    yInc = util.table.deepcopy(fieldPosData.yInc)
    incTimes = fieldPosData.incTimes

  else -- something is wrong...
    error("invalid emitterTable setup")
  end

  return pos, xInc, yInc, incTimes
end



function Forcefield:findForcefieldsArea(surface, area, includeFullHealth)
  local walls = surface.find_entities_filtered({area = area, type = "wall"})
  local gates = surface.find_entities_filtered({area = area, type = "gate"})
  local foundFields = {}

  if #walls ~= 0 then
    for i,wall in pairs(walls) do
      if settings.forcefieldTypes[wall.name] ~= nil and (includeFullHealth or wall.health ~= settings.forcefieldTypes[wall.name]["maxHealth"]) then
        table.insert(foundFields, wall)
      end
    end
  end

  if #gates ~= 0 then
    for i,gate in pairs(gates) do
      if settings.forcefieldTypes[gate.name] ~= nil and (includeFullHealth or gate.health ~= settings.forcefieldTypes[gate.name]["maxHealth"]) then
        table.insert(foundFields, gate)
      end
    end
  end

  if #foundFields ~= 0 then
    return foundFields
  end
end



function Forcefield:findForcefieldsRadius(surface, position, radius, includeFullHealth)
  if (not surface) or (not surface.valid) then return end
  if (not radius) or (radius < 0) then return end
  
  local walls = surface.find_entities_filtered({area = {{x = position.x - radius, y = position.y - radius}, {x = position.x + radius, y = position.y + radius}}, type = "wall"})
  local gates = surface.find_entities_filtered({area = {{x = position.x - radius, y = position.y - radius}, {x = position.x + radius, y = position.y + radius}}, type = "gate"})
  local foundFields = {}

  if #walls ~= 0 then
    for i,wall in pairs(walls) do
      if settings.forcefieldTypes[wall.name] ~= nil and (includeFullHealth or wall.health ~= settings.forcefieldTypes[wall.name]["maxHealth"]) then
        table.insert(foundFields, wall)
      end
    end
  end

  if #gates ~= 0 then
    for i,gate in pairs(gates) do
      if settings.forcefieldTypes[gate.name] ~= nil and (includeFullHealth or gate.health ~= settings.forcefieldTypes[gate.name]["maxHealth"]) then
        table.insert(foundFields, gate)
      end
    end
  end

  if #foundFields ~= 0 then
    return foundFields
  end
end



function Forcefield:degradeLinkedFields(emitterTable)
  if global.forcefields.fields ~= nil and emitterTable["entity"].valid then
    local fields
    local surface = emitterTable["entity"].surface
    local pos1, xInc, yInc, incTimes = self:getFieldsArea(emitterTable)
    if emitterTable["setup"] == "straight" then
      xInc = xInc[1] or 0
      yInc = yInc[1] or 0
      local pos2 = {x = pos1.x + (xInc * incTimes), y = pos1.y + (yInc * incTimes)}
      if xInc == -1 or yInc == -1 then
        fields = self:findForcefieldsArea(surface, {pos2, pos1}, true)
      else
        fields = self:findForcefieldsArea(surface, {pos1, pos2}, true)
      end
    else -- emitterTable["setup"] == "corner"
      fields = {}
      local pos2 = pos1
      for n=1, incTimes do
        local field = self:findForcefieldsArea(surface, {pos2, pos2}, true)
        for _,f in pairs(field or {}) do
          table.insert(fields, f)
        end
        pos2 = {
          x = pos2.x + (xInc[n] or 0),
          y = pos2.y + (yInc[n] or 0),
        }
      end
      if LSlib.utils.table.isEmpty(fields) then fields = nil end
    end

    --we need to degrade all found fields
    if fields then
      if global.forcefields.degradingFields == nil then
        global.forcefields.degradingFields = {}
      end
      local index = surface.index
      for k,field in pairs(fields) do
        pos = field.position
        -- make sure the field is controlled by this emitter, if not, we don't need to degrade it
        if global.forcefields.fields[index] ~= nil and global.forcefields.fields[index][pos.x] ~= nil and global.forcefields.fields[index][pos.x][pos.y] == emitterTable["emitter-NEI"] then
          -- adds the forcefield entity to the degrading list
          table.insert(global.forcefields.degradingFields, {["fieldEntity"] = field, ["emitter-NEI"] = emitterTable["emitter-NEI"], ["position"] = field.position, ["surface"] = field.surface})
          self:removeForceField(field)

          if global.forcefields.fields == nil then
            break
          end
        end
      end

      if #global.forcefields.degradingFields == 0 then
        global.forcefields.degradingFields = nil
      else
        Emitter:activateTicker()
      end
    end
  end
end



function Forcefield:removeDegradingFieldID(fieldID)
  -- Returns true if the global.forcefields.degradingFields table isn't empty
  if global.forcefields.degradingFields ~= nil then
    local emitterTable
    if global.forcefields.emitters then
      local emitterIndex = global.forcefields.degradingFields[fieldID]["emitter-NEI"]
      local emitterTable = global.forcefields.emitters[emitterIndex]
    end

    if emitterTable ~= nil then
      table.remove(global.forcefields.degradingFields, fieldID)
      Emitter:setActive(emitterTable, true)
    else
      local pos = global.forcefields.degradingFields[fieldID].position
      local surface = global.forcefields.degradingFields[fieldID].surface
      table.remove(global.forcefields.degradingFields, fieldID)

      -- check if this field could be part of any emitter
      if surface and surface.valid then
        local emitters = surface.find_entities_filtered({area = {{x = pos.x - settings.maxFieldDistance, y = pos.y - settings.maxFieldDistance}, {x = pos.x + settings.maxFieldDistance, y = pos.y + settings.maxFieldDistance}}, name = settings.emitterName})
        for _,emitter in pairs(emitters) do
          emitterTable = Emitter:findEmitter(emitter)
          if emitterTable then
            Emitter:setActive(emitterTable, true)
          end
        end
      end
    end

    if #global.forcefields.degradingFields == 0 then
      global.forcefields.degradingFields = nil
    else
      return true
    end
  end
end



function Forcefield:removeForceField(field)
  -- removes a forcefield from the active fields list (glovel.forcefields.fields)
  if global.forcefields.fields ~= nil then
    local pos = field.position
    local index = field.surface.index
    if global.forcefields.fields[index] ~= nil and global.forcefields.fields[index][pos.x] ~= nil and global.forcefields.fields[index][pos.x][pos.y] ~= nil then
      self:removeForceFieldID(index, pos.x, pos.y)
    end
  end
end



function Forcefield:removeForceFieldID(index, x, y)
  -- Does no checking, make sure its a valid table index
  global.forcefields.fields[index][x][y] = nil
  if LSlib.utils.table.isEmpty(global.forcefields.fields[index][x]) then
    global.forcefields.fields[index][x] = nil
    if LSlib.utils.table.isEmpty(global.forcefields.fields[index]) then
      global.forcefields.fields[index] = nil
    end
    if LSlib.utils.table.isEmpty(global.forcefields.fields) then
      global.forcefields.fields = nil
    end
  end
end
