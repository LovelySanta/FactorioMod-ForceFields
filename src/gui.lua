require "__LSlib__/LSlib"
local settings = require 'src/settings'
require 'src/utilities'

require 'src/forcefield'
require 'src/emitter'


Gui = {}


Gui.guiEmitterLayout = require("prototypes/gui/layout/emitter")
Gui.guiForcefieldLayout = require("prototypes/gui/layout/forcefield")
Gui.guiElementNames = util.table.deepcopy(require("prototypes/gui/layout/guiElementNames"))
-- keep backwards compatibility
for oldName, newName in pairs{
  ["buttonConfigure"] = "guiHeaderButton_ConfigureWall",
  ["buttonHelp"     ] = "guiHeaderButton_Help"         ,
  ["configTable"    ] = "guiContentTable"              ,
} do
  if Gui.guiElementNames[oldName] ~= nil then
    log(("guiElementName %q is already taken!"):format(oldName))
  else
    Gui.guiElementNames[oldName] = Gui.guiElementNames[newName]
  end
end

Gui.guiElementPaths = {}
for guiElement, guiElementName in pairs(Gui.guiElementNames) do
  local emitterPath = LSlib.gui.layout.getElementPath(Gui.guiEmitterLayout, guiElementName)
  local forcefieldPath = LSlib.gui.layout.getElementPath(Gui.guiForcefieldLayout, guiElementName)

  if emitterPath and forcefieldPath then
    log("ERROR: multiple paths found")
  else
    Gui.guiElementPaths[guiElement] = emitterPath or forcefieldPath or nil
  end
end



function Gui:onOpenGui(emitter, playerIndex)
  local emitterTable = Emitter:findEmitter(emitter)
  if emitterTable ~= nil then
    game.players[playerIndex].opened = self:showEmitterGui(emitterTable, playerIndex)
  end
end



function Gui:onCloseGui(guiElement, playerIndex)
  if guiElement and guiElement.valid and guiElement.name == self.guiElementNames.guiFrame then
    if global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil then
      -- Check the upgrade items
      if global.forcefields.emitterConfigGuis["I" .. playerIndex][1]["entity"].valid then
        local emitterTable = global.forcefields.emitterConfigGuis["I" .. playerIndex][1]
        --local upgrades = guiElement[self.guiElementNames.configTable][self.guiElementNames.upgradesTable]
        local upgrades = LSlib.gui.getElement(playerIndex, self.guiElementPaths.upgradesTable)

        -- Distance upgrades
        local oldDistanceUpgrades = emitterTable["distance-upgrades"]
        local newDistanceUpgrades = upgrades[self.guiElementNames.upgradesDistance].number
        if newDistanceUpgrades ~= oldDistanceUpgrades then
          if newDistanceUpgrades > oldDistanceUpgrades then
            transferToPlayer(game.players[playerIndex], {name = "advanced-circuit", count = newDistanceUpgrades - oldDistanceUpgrades})
          else
            takeFromPlayer(game.players[playerIndex], {name = "advanced-circuit", count = oldDistanceUpgrades - newDistanceUpgrades})
          end
        end

        -- Width upgrades
        local oldWidthUpgrades = emitterTable["width-upgrades"]
        local newWidthUpgrades = upgrades[self.guiElementNames.upgradesWidth].number
        if newWidthUpgrades ~= oldWidthUpgrades then
          if newWidthUpgrades > oldWidthUpgrades then
            transferToPlayer(game.players[playerIndex], {name = "processing-unit", count = newWidthUpgrades - oldWidthUpgrades})
          else
            takeFromPlayer(game.players[playerIndex], {name = "processing-unit", count = oldWidthUpgrades - newWidthUpgrades})
          end
        end
      end

      -- Delete the gui data now...
      global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
    end
    if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
      global.forcefields.emitterConfigGuis = nil
    end
    if game.players[playerIndex].gui.center[self.guiElementNames.configFrame] then
      game.players[playerIndex].gui.center[self.guiElementNames.configFrame].destroy()
    end
    guiElement.destroy()
  end
end



function Gui:showEmitterGui(emitterTable, playerIndex)
  local guiCenter = game.players[playerIndex].gui.center
  local canOpenGui = true

  -- Check if someone else has this gui open at this moment
  if global.forcefields.emitterConfigGuis ~= nil then
    for index,player in pairs(game.players) do
      --if index ~= playerIndex then
        if global.forcefields.emitterConfigGuis["I" .. index] ~= nil and global.forcefields.emitterConfigGuis["I" .. index][1] == emitterTable then
          if index ~= playerIndex then
            game.players[playerIndex].print(player.name .. " (player " .. index .. ") has the GUI for this emitter open right now.")
          end
          canOpenGui = false
          break
        end
      --end
    end
  end

  -- Create the gui
  if canOpenGui and guiCenter and guiCenter.emitterConfig == nil then
    local createdGui = LSlib.gui.create(playerIndex, self.guiEmitterLayout)
    
    -- Type of forcefield
    if emitterTable["type"] == "blue" then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.fieldTypeOptionB).style = settings.guiSelectButtonSelectedStyle
    elseif emitterTable["type"] == "green" then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.fieldTypeOptionG).style = settings.guiSelectButtonSelectedStyle
    elseif emitterTable["type"] == "red" then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.fieldTypeOptionR).style = settings.guiSelectButtonSelectedStyle
    elseif emitterTable["type"] == "purple" then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.fieldTypeOptionP).style = settings.guiSelectButtonSelectedStyle
    end

    -- Direction of forcefield
    if emitterTable["direction"] == defines.direction.north then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.directionOptionN).style = settings.guiSelectButtonSelectedStyle
    elseif emitterTable["direction"] == defines.direction.south then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.directionOptionS).style = settings.guiSelectButtonSelectedStyle
    elseif emitterTable["direction"] == defines.direction.east then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.directionOptionE).style = settings.guiSelectButtonSelectedStyle
    elseif emitterTable["direction"] == defines.direction.west then
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.directionOptionW).style = settings.guiSelectButtonSelectedStyle
    end

    -- Distance of forcefield
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceInput).text = emitterTable["distance"]
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceMaxInput).caption = "Max: " .. tostring(settings.emitterDefaultDistance + emitterTable["distance-upgrades"])

    -- Width of forcefield
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = emitterTable["width"]
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthMaxInput).caption = "Max: " .. tostring(settings.emitterDefaultWidth + emitterTable["width-upgrades"] * settings.widthUpgradeMultiplier)

    -- Upgrades of emitter
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.upgradesDistance).number = emitterTable["distance-upgrades"]
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.upgradesWidth).number = emitterTable["width-upgrades"]

    -- Save gui
    if global.forcefields.emitterConfigGuis == nil then
      global.forcefields.emitterConfigGuis = {}
    end
    global.forcefields.emitterConfigGuis["I" .. playerIndex] = {}
    global.forcefields.emitterConfigGuis["I" .. playerIndex][1] = emitterTable

    return createdGui
  else
    return nil
  end
end



function Gui:createForcefieldGui(playerIndex, fieldWidth)
  local player = game.players[playerIndex]
  local emitterTable = global.forcefields.emitterConfigGuis["I" .. playerIndex][1]
  local guiCenter = player.gui.center
  if guiCenter and guiCenter[self.guiElementNames.guiFrame] then
    if not guiCenter[self.guiElementNames.configFrame] then
      -- If config gui doesn't exist yet we have to make it
      LSlib.gui.create(playerIndex, self.guiForcefieldLayout)
    else
      -- Config gui does exist, we just make it visible
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.configFrame).visible = true
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.configTableSlider)[self.guiElementNames.configTableData].destroy()
    end

    -- now add the configuration
    local configTableSlider = LSlib.gui.getElement(playerIndex, self.guiElementPaths.configTableSlider)
    configTableSlider.style.maximal_width = math.floor(player.display_resolution.width/player.display_scale/2)

    local configTableData = configTableSlider.add{type ="table", name = self.guiElementNames.configTableData, column_count = fieldWidth}
    for fieldIndex=1, fieldWidth do
      configTableData.style.column_alignments[fieldIndex] = "center"
    end
    for fieldIndex=1, fieldWidth do
      configTableData.add{type = "label", name = self.guiElementNames.configOptionLabel ..string.format("%02d", fieldIndex), caption = string.format("%02d", fieldIndex), ignored_by_interaction = true}
    end
    for fieldIndex=1, fieldWidth do
      configTableData.add{type = "sprite-button", name = self.guiElementNames.configOption .. "E" .. string.format("%02d", fieldIndex), sprite = "utility/pump_cannot_connect_icon", style = settings.guiSmallSelectButtonStyle}
    end
    for fieldIndex=1, fieldWidth do
      configTableData.add{type = "sprite-button", name = self.guiElementNames.configOption .. "W" .. string.format("%02d", fieldIndex), sprite = "utility/pump_cannot_connect_icon", style = settings.guiSmallSelectButtonStyle}
    end
    for fieldIndex=1, fieldWidth do
      configTableData.add{type = "sprite-button", name = self.guiElementNames.configOption .. "G" .. string.format("%02d", fieldIndex), sprite = "utility/pump_cannot_connect_icon", style = settings.guiSmallSelectButtonStyle}
    end
    
    -- Select the correct setting for each wall
    local fieldOffset = (fieldWidth + 1)/2
    local emitterWallConfigTable = emitterTable["config"]
    for fieldIndex = 1, fieldWidth do
      local type = emitterWallConfigTable[fieldIndex-fieldOffset]
      if type == settings.fieldSuffix then
        configTableData[self.guiElementNames.configOption .. "W" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonSelectedStyle
      elseif type == settings.fieldGateSuffix then
        configTableData[self.guiElementNames.configOption .. "G" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonSelectedStyle
      else
        configTableData[self.guiElementNames.configOption .. "E" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonSelectedStyle
      end
    end
  end
end



function Gui:handleGuiDirectionButtons(event)
  local playerIndex = event.element.player_index
  local player = game.players[playerIndex]
  local nameToDirection =
  {
    [self.guiElementNames.directionOptionN] = defines.direction.north,
    [self.guiElementNames.directionOptionS] = defines.direction.south,
    [self.guiElementNames.directionOptionE] = defines.direction.east,
    [self.guiElementNames.directionOptionW] = defines.direction.west
  }

  if LSlib.gui.getElement(playerIndex, self.guiElementPaths.guiFrame) ~= nil then
    local directions = LSlib.gui.getElement(playerIndex, self.guiElementPaths.directionTable)

    -- Save the newly selected direction
    global.forcefields.emitterConfigGuis["I" .. playerIndex][2] = nameToDirection[event.element.name]

    -- Set the buttons accordingly to pressed selection
    directions[self.guiElementNames.directionOptionN].style = settings.guiSelectButtonStyle
    directions[self.guiElementNames.directionOptionS].style = settings.guiSelectButtonStyle
    directions[self.guiElementNames.directionOptionE].style = settings.guiSelectButtonStyle
    directions[self.guiElementNames.directionOptionW].style = settings.guiSelectButtonStyle
    directions[event.element.name].style = settings.guiSelectButtonSelectedStyle
  end
end



function Gui:handleGuiFieldTypeButtons(event)
  local playerIndex = event.element.player_index
  local player = game.players[playerIndex]
  local force = player.force
  local nameToFieldName =
  {
    [self.guiElementNames.fieldTypeOptionB] = "blue",
    [self.guiElementNames.fieldTypeOptionG] = "green",
    [self.guiElementNames.fieldTypeOptionR] = "red",
    [self.guiElementNames.fieldTypeOptionP] = "purple"
  }

  if LSlib.gui.getElement(playerIndex, self.guiElementPaths.guiFrame) ~= nil then
    -- Current fieldtype
    local fields = LSlib.gui.getElement(playerIndex, self.guiElementPaths.fieldTypeTable)
    local selectedButtonName = event.element.name

    -- Check if the force of that player has the required researched
    local shouldSwitch = true
    if selectedButtonName == self.guiElementNames.fieldTypeOptionG then
      shouldSwitch = force.technologies[settings.fieldSuffix.."green"].researched
    elseif selectedButtonName == self.guiElementNames.fieldTypeOptionR then
      shouldSwitch = force.technologies[settings.fieldSuffix.."red"].researched
    elseif selectedButtonName == self.guiElementNames.fieldTypeOptionP then
      shouldSwitch = force.technologies[settings.fieldSuffix.."purple"].researched
    end

    if shouldSwitch then
      -- Save the newly selected direction
      global.forcefields.emitterConfigGuis["I" .. playerIndex][3] = nameToFieldName[selectedButtonName]

      -- Set the buttons accordingly to pressed selection
      fields[self.guiElementNames.fieldTypeOptionB].style = settings.guiSelectButtonStyle
      fields[self.guiElementNames.fieldTypeOptionG].style = settings.guiSelectButtonStyle
      fields[self.guiElementNames.fieldTypeOptionR].style = settings.guiSelectButtonStyle
      fields[self.guiElementNames.fieldTypeOptionP].style = settings.guiSelectButtonStyle
      fields[selectedButtonName].style = settings.guiSelectButtonSelectedStyle
    else
      player.print("You need to complete the required research before this field type can be used.")
    end
  end
end



function Gui:handleGuiUpgradeButtons(event)
  local playerIndex = event.element.player_index
  local player = game.players[playerIndex]
  local frame = LSlib.gui.getElement(playerIndex, self.guiElementPaths.guiFrame)
  local nameToUpgradeLimit =
  {
    [self.guiElementNames.upgradesDistance] = settings.maxRangeUpgrades,
    [self.guiElementNames.upgradesWidth] = settings.maxWidthUpgrades
  }
  local nameToUpgradeItem =
  {
    [self.guiElementNames.upgradesDistance] = "advanced-circuit",
    [self.guiElementNames.upgradesWidth] = "processing-unit"
  }
  local UpgradeItemsToName = {}
  for k,v in pairs(nameToUpgradeItem) do
    UpgradeItemsToName[v] = k
  end

  if frame ~= nil then
    local upgrades = LSlib.gui.getElement(playerIndex, self.guiElementPaths.upgradesTable)
    local upgradeButton
    local count

    -- Check if the player has items on his cursor => increase upgrades
    local stack = player.cursor_stack
    if stack.valid_for_read then
      if UpgradeItemsToName[stack.name] ~= nil then
        upgradeButton = upgrades[UpgradeItemsToName[stack.name]]
        -- Add one to the upgrades
        count = upgradeButton.number + 1

        -- Update the gui if it didn't exceeded the max limit
        if count <= nameToUpgradeLimit[upgradeButton.name] then
          upgradeButton.number = count
          self:updateMaxLabel(frame, upgradeButton)

          -- Remove one item from the players cursor
          stack.count = stack.count - 1
        else
          player.print("Maximum upgrades of this type already installed.")
        end
      end
    else -- player has an empty cursor => decrease upgrades
      upgradeButton = upgrades[event.element.name]

      count = upgradeButton.number
      if count > 0 then
        upgradeButton.number = count - 1
        self:updateMaxLabel(frame, upgradeButton)
        transferToPlayer(player, {name = nameToUpgradeItem[upgradeButton.name], count = 1})
      end
    end
  end
end



function Gui:handleConfigureButton(event)
  -- get the width of the emitter, needed for the gui...
  local playerIndex = event.player_index
  local player = game.players[event.player_index]

  local width = tonumber(LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text)
  local maxWidth = tonumber(string.sub(LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthMaxInput).caption, 6))
  local settingsAreGood = true

  if not width then
    player.print("New Width is not a valid number.")
    settingsAreGood = false
  elseif width > maxWidth then
    player.print(string.format("New Width is larger than the allowed maximum (%i).", maxWidth))
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring(maxWidth)
    settingsAreGood = false
  elseif width < 1 then
    player.print("New Width is smaller than the allowed minimum (1).")
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring(1)
    settingsAreGood = false
  elseif math.floor(width) ~= width then
    player.print("New Width is not a valid number (can't have decimals).")
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring(math.min(maxWidth, math.max(1, math.floor(width + .5))))
    settingsAreGood = false
  elseif (math.floor((width - 1) / 2) * 2) + 1 ~= width then
    player.print("New Width has to be an odd number.")
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring((math.floor((width - 1) / 2) * 2) + 1)
    settingsAreGood = false
  end

  if settingsAreGood then
    -- We need to configure the wall/gates for this wall, depending on the current settings in the gui
    self:createForcefieldGui(event.player_index, width)
    -- It opened the configGui, now make the emitterGui invisible
    LSlib.gui.getElement(playerIndex, self.guiElementPaths.guiFrame).visible = false
  end
end



function Gui:handleGuiMenuButtons(event)
  local playerIndex = event.player_index
  local player = game.players[playerIndex]
  local guiCenter = player.gui.center
  local frame = LSlib.gui.getElement(playerIndex, self.guiElementPaths.guiFrame)
  if frame ~= nil then
    -- Apply button
    if event.element.name == self.guiElementNames.buttonApplySettings then
      if self:verifyAndSetFromGui(playerIndex) then
        -- Close the gui in the data
        global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
        if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
          global.forcefields.emitterConfigGuis = nil
        end
        -- Close the gui visualy
        if guiCenter[self.guiElementNames.configFrame] then
          guiCenter[self.guiElementNames.configFrame].destroy()
        end
        frame.destroy()
      end
    -- Discard button
    elseif event.element.name == self.guiElementNames.buttonDiscardSettings then
      self:onCloseGui(frame, playerIndex)
    -- Help button
    elseif event.element.name == self.guiElementNames.buttonHelp then
      self:printGuiHelp(player)
    -- Remove upgrades buttons
    elseif event.element.name == self.guiElementNames.buttonRemoveUpgrades then
      self:removeAllUpgrades(playerIndex)
    end
  end
end



function Gui:handleGuiConfigWallChange(event)
  -- Get the button info
  local buttonId = string.sub(event.element.name, -3)
  local fieldConfig = string.sub(buttonId,1,1)
  local fieldIndex = string.sub(buttonId, -2)

  -- If its a gate, check if we have the required research
  if fieldConfig == "G" then
    local playerIndex = event.player_index
    local player = game.players[playerIndex]
    local force = player.force
    local fieldType
    if global.forcefields.emitterConfigGuis["I" .. playerIndex][3] ~= nil then
      fieldType = global.forcefields.emitterConfigGuis["I" .. playerIndex][3]
    else
      fieldType = global.forcefields.emitterConfigGuis["I" .. playerIndex][1]["type"]
    end

    if not force.technologies[settings.fieldSuffix..fieldType].researched then
      player.print("You need to complete the required research before gates of this field type can be used.")
      return
    end
  end

  -- Change to new selection
  local configTableData = event.element.parent
  configTableData[self.guiElementNames.configOption .. "E" .. fieldIndex].style = settings.guiSmallSelectButtonStyle
  configTableData[self.guiElementNames.configOption .. "W" .. fieldIndex].style = settings.guiSmallSelectButtonStyle
  configTableData[self.guiElementNames.configOption .. "G" .. fieldIndex].style = settings.guiSmallSelectButtonStyle
  configTableData[self.guiElementNames.configOption .. fieldConfig .. fieldIndex].style = settings.guiSmallSelectButtonSelectedStyle
end



function Gui:handleGuiConfigWallRowChange(event)
  -- Select the correct styles for each row
  local playerIndex = event.player_index
  local fieldConfig = string.sub(event.element.name, -1)
  local StyleE, styleW, styleG

  if fieldConfig == "E" then
    styleE = settings.guiSmallSelectButtonSelectedStyle
    styleW = settings.guiSmallSelectButtonStyle
    styleG = settings.guiSmallSelectButtonStyle

  elseif fieldConfig == "G" then
    -- If its a gate, check if we have the required research
    local player = game.players[playerIndex]
    local force = player.force
    local fieldType
    if global.forcefields.emitterConfigGuis["I" .. playerIndex][3] ~= nil then
      fieldType = global.forcefields.emitterConfigGuis["I" .. playerIndex][3]
    else
      fieldType = global.forcefields.emitterConfigGuis["I" .. playerIndex][1]["type"]
    end

    if not force.technologies[settings.fieldSuffix..fieldType].researched then
      player.print("You need to complete the required research before gates of this field type can be used.")
      return
    end

    styleE = settings.guiSmallSelectButtonStyle
    styleW = settings.guiSmallSelectButtonStyle
    styleG = settings.guiSmallSelectButtonSelectedStyle

  else -- default == "W"
    styleE = settings.guiSmallSelectButtonStyle
    styleW = settings.guiSmallSelectButtonSelectedStyle
    styleG = settings.guiSmallSelectButtonStyle
  end

  -- Now change all the buttons
  local guiCenter = game.players[playerIndex].gui.center
  local emitterConfigTable = guiCenter[self.guiElementNames.guiFrame][self.guiElementNames.configTable]
  local fieldWidth = tonumber(emitterConfigTable[self.guiElementNames.widthTable][self.guiElementNames.widthInput].text)
  local configTableData = LSlib.gui.getElement(playerIndex, self.guiElementPaths.configTableSlider)[self.guiElementNames.configTableData]
  for fieldIndex = 1, fieldWidth do
    configTableData[self.guiElementNames.configOption .. "E" .. string.format("%02d", fieldIndex)].style = styleE
    configTableData[self.guiElementNames.configOption .. "W" .. string.format("%02d", fieldIndex)].style = styleW
    configTableData[self.guiElementNames.configOption .. "G" .. string.format("%02d", fieldIndex)].style = styleG
  end
end



function Gui:handleGuiConfigWallClose(event)
  local playerIndex = event.player_index
  local guiCenter = game.players[playerIndex].gui.center

  local fieldWidth = tonumber(LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text)
  local fieldOffset = (fieldWidth + 1)/2
  local configTableData = LSlib.gui.getElement(playerIndex, self.guiElementPaths.configTableSlider)[self.guiElementNames.configTableData]

  local configTable -- Undo all the changes that has been done
  if not global.forcefields.emitterConfigGuis["I" .. playerIndex][4] then
    -- No previous settings, still using the settings from the emitterTable
    configTable = util.table.deepcopy(global.forcefields.emitterConfigGuis["I" .. playerIndex][1]["config"])
  else
    -- There where settings when opened, lets use these
    configTable = global.forcefields.emitterConfigGuis["I" .. playerIndex][4]
  end

  -- First we need to save the data
  if event.element.name == self.guiElementNames.configCancelButton then
    -- Redo the the correct setting for each wall
    for fieldIndex = 1, fieldWidth do
      -- Default back to not selected
      configTableData[self.guiElementNames.configOption .. "E" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonStyle
      configTableData[self.guiElementNames.configOption .. "W" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonStyle
      configTableData[self.guiElementNames.configOption .. "G" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonStyle

      -- Now select the correct setting
      local type = configTable[fieldIndex-fieldOffset]
      if type == settings.fieldSuffix then
        configTableData[self.guiElementNames.configOption .. "W" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonSelectedStyle
      elseif type == settings.fieldGateSuffix then
        configTableData[self.guiElementNames.configOption .. "G" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonSelectedStyle
      else
        configTableData[self.guiElementNames.configOption .. "E" .. string.format("%02d", fieldIndex)].style = settings.guiSmallSelectButtonSelectedStyle
      end
    end

  elseif event.element.name == self.guiElementNames.configApplyButton then
    -- Extract info out of the gui
    for fieldIndex = 1, fieldWidth do
      if configTableData[self.guiElementNames.configOption .. "W" .. string.format("%02d", fieldIndex)].style.name == settings.guiSmallSelectButtonSelectedStyle then
        configTable[fieldIndex-fieldOffset] = settings.fieldSuffix
      elseif configTableData[self.guiElementNames.configOption .. "G" .. string.format("%02d", fieldIndex)].style.name == settings.guiSmallSelectButtonSelectedStyle then
        configTable[fieldIndex-fieldOffset] = settings.fieldGateSuffix
      else
        configTable[fieldIndex-fieldOffset] = settings.fieldEmptySuffix
      end
    end
    global.forcefields.emitterConfigGuis["I" .. playerIndex][4] = configTable
  end

  -- Now we need to change the guis back
  guiCenter[self.guiElementNames.guiFrame].visible = true
  guiCenter[self.guiElementNames.configFrame].visible = false
end



Gui.guiButtonHandlers =
{
  -- Emitter gui
  [Gui.guiElementNames.directionOptionN] = Gui.handleGuiDirectionButtons,
  [Gui.guiElementNames.directionOptionS] = Gui.handleGuiDirectionButtons,
  [Gui.guiElementNames.directionOptionE] = Gui.handleGuiDirectionButtons,
  [Gui.guiElementNames.directionOptionW] = Gui.handleGuiDirectionButtons,

  [Gui.guiElementNames.fieldTypeOptionB] = Gui.handleGuiFieldTypeButtons,
  [Gui.guiElementNames.fieldTypeOptionG] = Gui.handleGuiFieldTypeButtons,
  [Gui.guiElementNames.fieldTypeOptionR] = Gui.handleGuiFieldTypeButtons,
  [Gui.guiElementNames.fieldTypeOptionP] = Gui.handleGuiFieldTypeButtons,

  [Gui.guiElementNames.upgradesDistance] = Gui.handleGuiUpgradeButtons,
  [Gui.guiElementNames.upgradesWidth] = Gui.handleGuiUpgradeButtons,
  
  [Gui.guiElementNames.buttonHelp] = Gui.handleGuiMenuButtons,
  [Gui.guiElementNames.buttonConfigure] = Gui.handleConfigureButton,
  [Gui.guiElementNames.buttonRemoveUpgrades] = Gui.handleGuiMenuButtons,
  [Gui.guiElementNames.buttonApplySettings] = Gui.handleGuiMenuButtons,
  [Gui.guiElementNames.buttonDiscardSettings] = Gui.handleGuiMenuButtons,

  -- Forcefield gui
  [Gui.guiElementNames.configOption] = Gui.handleGuiConfigWallChange,
  [Gui.guiElementNames.configRowOption] = Gui.handleGuiConfigWallRowChange,
  [Gui.guiElementNames.configCancelButton] = Gui.handleGuiConfigWallClose,
  [Gui.guiElementNames.configApplyButton] = Gui.handleGuiConfigWallClose,
}



function Gui:printGuiHelp(player)
  player.print("Direction: the direction the emitter projects the forcefields in.")
  player.print("Field type: the type of forcefield the emitter projects:")
  player.print("    [B]lue: normal health, normal re-spawn, normal power usage.")
  player.print("    [G]reen: higher health, very slow re-spawn, below-normal power usage.")
  player.print("    [R]ed: normal health, slow re-spawn, very high power usage. Damages living things that directly attack them.")
  player.print("    [P]urple: low health, very slow re-spawn, high power usage. On death, heavily damages living things nearby.")
  player.print("Emitter distance: the distance from the emitter in the configured direction the fields are constructed.")
  player.print("Emitter width: the width of the field constructed by the emitter.")
  player.print("Upgrades applied: the distance (advanced circuit) and width (processing unit) upgrades applied to the emitter.")
  player.print("Help button: displays this information.")
  player.print("Remove all upgrades: removes all upgrades from the emitter.")
  player.print("Apply: saves and applies the settings to the emitter.")
end



function Gui:verifyAndSetFromGui(playerIndex)
  -- emitter settings
  local newDirection
  local newFieldType
  local newFieldConfig
  local newDistance
  local newWidth
  local maxDistance
  local maxWidth
  local newWidthUpgrades
  local newDistanceUpgrades
  local player = game.players[playerIndex]
  local settingsAreGood = true
  local settingsChanged = false
  --local frame = player.gui.center[self.guiElementNames.guiFrame]
  --local emitterConfigTable = frame[self.guiElementNames.configTable]
  --local upgrades = emitterConfigTable[self.guiElementNames.upgradesTable]

  if global.forcefields.emitterConfigGuis ~= nil
    and global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil
    and global.forcefields.emitterConfigGuis["I" .. playerIndex][1]["entity"].valid then

    -- Check if settings have changed
    local emitterTable = global.forcefields.emitterConfigGuis["I" .. playerIndex][1]

    -- Direction of the forcefield
    if global.forcefields.emitterConfigGuis["I" .. playerIndex][2] ~= nil then
      newDirection = global.forcefields.emitterConfigGuis["I" .. playerIndex][2]
    elseif emitterTable["direction"] == nil then
      player.print("No wall direction selected.")
      settingsAreGood = false
    else
      newDirection = emitterTable["direction"]
    end

    -- Type of forcefield
    if global.forcefields.emitterConfigGuis["I" .. playerIndex][3] ~= nil then
      newFieldType = global.forcefields.emitterConfigGuis["I" .. playerIndex][3]
    elseif emitterTable["type"] == nil then
      player.print("No wall type selected.")
      settingsAreGood = false
    else
      newFieldType = emitterTable["type"]
    end

    -- Distance of forcefield
    newDistance = tonumber(LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceInput).text)
    maxDistance = tonumber(string.sub(LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceMaxInput).caption, 6))
    newDistanceUpgrades = LSlib.gui.getElement(playerIndex, self.guiElementPaths.upgradesDistance).number
    if not newDistance then
      player.print("New Distance is not a valid number.")
      settingsAreGood = false
    elseif newDistance > maxDistance then
      player.print(string.format("New Distance is larger than the allowed maximum (%i).", maxDistance))
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceInput).text = tostring(maxDistance)
      settingsAreGood = false
    elseif newDistance < 1 then
      player.print("New Distance is smaller than the allowed minimum (1).")
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceInput).text = tostring(1)
      settingsAreGood = false
    elseif math.floor(newDistance) ~= newDistance then
      player.print("New Distance is not a valid number (can't have decimals).")
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.distanceInput).text = tostring(math.min(maxWidth, math.max(1, math.floor(newDistance + .5))))
      settingsAreGood = false
    end

    -- Width of forcefield
    newWidth = tonumber(LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text)
    maxWidth = tonumber(string.sub(LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthMaxInput).caption, 6))
    newWidthUpgrades = LSlib.gui.getElement(playerIndex, self.guiElementPaths.upgradesWidth).number
    if not newWidth then
      player.print("New Width is not a valid number.")
      settingsAreGood = false
    elseif newWidth > maxWidth then
      player.print(string.format("New Width is larger than the allowed maximum (%i).", maxWidth))
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring(maxWidth)
      settingsAreGood = false
    elseif newWidth < 1 then
      player.print("New Width is smaller than the allowed minimum (1).")
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring(1)
      settingsAreGood = false
    elseif math.floor(newWidth) ~= newWidth then
      player.print("New Width is not a valid number (can't have decimals).")
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring(math.min(maxWidth, math.max(1, math.floor(newWidth + .5))))
      settingsAreGood = false
    elseif (math.floor((newWidth - 1) / 2) * 2) + 1 ~= newWidth then
      player.print("New Width has to be an odd number.")
      LSlib.gui.getElement(playerIndex, self.guiElementPaths.widthInput).text = tostring((math.floor((newWidth - 1) / 2) * 2) + 1)
      settingsAreGood = false
    end

    -- New field configuration
    if global.forcefields.emitterConfigGuis["I" .. playerIndex][4] ~= nil then
      newFieldConfig = global.forcefields.emitterConfigGuis["I" .. playerIndex][4]
    else
      newFieldConfig = util.table.deepcopy(emitterTable["config"])
    end

    -- If settings are all checked and correct, we can update the emitterTable
    if settingsAreGood then
      -- If any changes on the forcefield, we need to rebuild it
      if emitterTable["disabled"] == true
        or emitterTable["width"] ~= newWidth
        or emitterTable["distance"] ~= newDistance
        or emitterTable["type"] ~= newFieldType
        or emitterTable["direction"] ~= newDirection
        or not LSlib.utils.table.areEqual(emitterTable["config"], newFieldConfig) then

        Forcefield:degradeLinkedFields(emitterTable)

        emitterTable["disabled"] = false
        emitterTable["damaged-fields"] = nil
        emitterTable["width"] = newWidth
        emitterTable["distance"] = newDistance
        emitterTable["type"] = newFieldType
        emitterTable["config"] = newFieldConfig
        emitterTable["direction"] = newDirection
        emitterTable["generating-fields"] = nil

        Emitter:setActive(emitterTable, true, false)
      end

      -- If the upgrades changed we have to update that too, but no need to rebuild
      emitterTable["distance-upgrades"] = newDistanceUpgrades
      emitterTable["width-upgrades"] = newWidthUpgrades

      -- Return true to close the UI
      return true
    else
      -- Not closing UI yet (settingsAreGood == false)
      return false
    end
  else
    -- Invalid entity, close this UI
    return true
  end
end



function Gui:removeAllUpgrades(playerIndex)
  local frame = game.players[playerIndex].gui.center[self.guiElementNames.guiFrame]

  if frame then -- This shouldn't ever be required but won't hurt to check
    if global.forcefields.emitterConfigGuis ~= nil
      and global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil
      and global.forcefields.emitterConfigGuis["I" .. playerIndex][1]["entity"].valid then
      local upgrades = frame[self.guiElementNames.configTable][self.guiElementNames.upgradesTable]
      local count
      --local buttonName
      for upgradeItemName, button in pairs({
        ["advanced-circuit"] = upgrades[self.guiElementNames.upgradesDistance],
        ["processing-unit"] = upgrades[self.guiElementNames.upgradesWidth]
      }) do
        count = button.number
        if count > 0 then
          button.number = 0
          self:updateMaxLabel(frame, button)
          transferToPlayer(game.players[playerIndex], {name = upgradeItemName, count = count})
        end
      end
    else -- invalid emitter entity (for example when someone destroys the emitter while another person is viewing the gui)
      if global.forcefields.emitterConfigGuis ~= nil and global.forcefields.emitterConfigGuis["I" .. playerIndex] ~= nil then
        global.forcefields.emitterConfigGuis["I" .. playerIndex] = nil
        if LSlib.utils.table.isEmpty(global.forcefields.emitterConfigGuis) then
          global.forcefields.emitterConfigGuis = nil
        end
      end
      -- close the gui
      frame.destroy()
    end
  end
end



function Gui:updateMaxLabel(frame, upgradeButton)
  local count = upgradeButton.number
  if upgradeButton.name == self.guiElementNames.upgradesDistance then
    -- Distance upgrade button
    frame[self.guiElementNames.configTable][self.guiElementNames.distanceTable][self.guiElementNames.distanceMaxInput].caption = "Max: " .. tostring(settings.emitterDefaultDistance + count)
  else
    -- Width upgrade button
    frame[self.guiElementNames.configTable][self.guiElementNames.widthTable][self.guiElementNames.widthMaxInput].caption = "Max: " .. tostring(settings.emitterDefaultWidth + (count * settings.widthUpgradeMultiplier))
  end
end
