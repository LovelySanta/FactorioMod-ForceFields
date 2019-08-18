require "__LSlib__/LSlib"
local settings = require("prototypes/settings")
local guiSettings = settings["gui"]
local guiNames = require("prototypes/gui/layout/guiElementNames")



-- EMITTER GUI
local guiLayout = LSlib.gui.layout.create("center")



-- gui base
local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", guiNames.guiFrame, "vertical", {
  style = "frame_without_footer",
})
local guiFrameHeaderFlow = LSlib.gui.layout.addFlow(guiLayout, guiFrame, guiNames.guiFrame.."-header-flow", "horizontal", {
  style = "LSlib_default_header",
})
local guiFrameContent = LSlib.gui.layout.addTable(guiLayout, guiFrame, guiNames.guiContentTable, 2)
local guiFrameFooterFlow = LSlib.gui.layout.addFlow(guiLayout, guiFrame, guiNames.guiFrame.."-footer-flow", "horizontal", {
  style = "LSlib_default_footer",
})



-- gui header
LSlib.gui.layout.addLabel(guiLayout, guiFrameHeaderFlow, guiNames.guiFrame.."-header-title", {
  caption = {"entity-name."..settings["emitter"]["emitterName"]},
  style   = "LSlib_default_frame_title",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameHeaderFlow, guiNames.guiFrame.."-header-filler", "vertical", {
  style = "LSlib_default_header_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFrameHeaderFlow, guiNames.guiHeaderButton_ConfigureWall, {
  sprite = guiSettings["configWallSprite"],
  style = "LSlib_default_header_button",
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFrameHeaderFlow, guiNames.guiHeaderButton_Help, {
  sprite = "utility/questionmark"      ,
  style = "LSlib_default_header_button",
})




-- Direction of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.directionLabel, {
  caption = "Direction:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})  
local guiFieldDirection = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.directionTable, 4)
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionN, {
  sprite = "virtual-signal/signal-N",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionS, {
  sprite = "virtual-signal/signal-S",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionE, {
  sprite = "virtual-signal/signal-E",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionW, {
  sprite = "virtual-signal/signal-W",
  style = guiSettings["guiSelectButtonStyle"],
})



-- Type of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.fieldTypeLabel, {
  caption = "Field type:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiFieldType = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.fieldTypeTable, 4)
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionB, {
  sprite = "item/"..string.format(settings["blue"].name, "wall", "blue"),
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionG, {
  sprite = "item/"..string.format(settings["green"].name, "wall", "green"),
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionR, {
  sprite = "item/"..string.format(settings["red"].name, "wall", "red"),
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionP, {
  sprite = "item/"..string.format(settings["purple"].name, "wall", "purple"),
  style = guiSettings["guiSelectButtonStyle"],
})



-- Distance of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.distanceLabel, {
  caption = "Emitter distance:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiEmitterDistance = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.distanceTable, 2)
LSlib.gui.layout.addTextfield(guiLayout, guiEmitterDistance, guiNames.distanceInput, {
  numeric = true, allow_decimal = false,
  style = guiSettings["guiTextfieldStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiEmitterDistance, guiNames.distanceMaxInput, {
  ignored_by_interaction = true,
})



-- Width of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.widthLabel, {
  caption = "Emitter width:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiEmitterWidth = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.widthTable, 2)
LSlib.gui.layout.addTextfield(guiLayout, guiEmitterWidth, guiNames.widthInput, {
  numeric = true, allow_decimal = false,
  style = guiSettings["guiTextfieldStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiEmitterWidth, guiNames.widthMaxInput, {
  ignored_by_interaction = true,
})



-- Upgrades of emitter
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.upgradesLabel, {
  caption = "Upgrades applied:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiEmitterUpgrades = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.upgradesTable, 3)
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, guiNames.upgradesDistance, {
  number = 0, show_percent_for_small_numbers = false,
  sprite = "item/advanced-circuit",
  style = guiSettings["guiItemSlotStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, guiNames.upgradesWidth, {
  number = 0, show_percent_for_small_numbers = false,
  sprite = "item/processing-unit",
  style = guiSettings["guiItemSlotStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, guiNames.buttonRemoveUpgrades, {
  tooltip = "Remove all upgrades",
  sprite  = "utility/reset",
  style   = guiSettings["guiItemSlotStyle"],
})



-- Footer buttons
LSlib.gui.layout.addButton(guiLayout, guiFrameFooterFlow, guiNames.buttonDiscardSettings, {
  caption = "Discard",
  style = "red_back_button",
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameFooterFlow, guiNames.guiFrame.."-footer-filler", "vertical", {
  style = "LSlib_default_footer_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addButton(guiLayout, guiFrameFooterFlow, guiNames.buttonApplySettings, {
  caption = "Apply changes",
  style = "confirm_button",
})



return guiLayout