require "__LSlib__/LSlib"
local protoSettings = require("prototypes/settings")
local runSettings = require("src/settings")
local guiSettings = protoSettings["gui"]
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
  caption = {"entity-name."..protoSettings["emitter"]["emitterName"]},
  style   = "LSlib_default_frame_title",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameHeaderFlow, guiNames.guiFrame.."-header-filler", "vertical", {
  style = "LSlib_default_header_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFrameHeaderFlow, guiNames.guiButtonHelp, {
  sprite = "utility/questionmark"      ,
  style = "LSlib_default_header_button",
})



-- Type of forcefield
local fieldProperties = require("prototypes/entity/forcefield-properties")
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.fieldTypeLabel, {
  caption = {"", {"forcefields-gui-name.emitter-field-type"}, ": [img=info]"},
  tooltip = {"forcefields-gui-description.emitter-field-type"},
  style = guiSettings["guiLabelStyle"],
})
local guiFieldType = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.fieldTypeTable, 4)
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionB, {
  sprite = "item/"..string.format(protoSettings["blue"].name, "wall", "blue"),
  tooltip = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties("blue", {damage=true, respawn=true, repair=true, max_health=true}),
  },
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionG, {
  sprite = "item/"..string.format(protoSettings["green"].name, "wall", "green"),
  tooltip = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties("green", {damage=true, respawn=true, repair=true, max_health=true}),
  },
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionR, {
  sprite = "item/"..string.format(protoSettings["red"].name, "wall", "red"),
  tooltip = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties("red", {damage=true, respawn=true, repair=true, max_health=true}),
  },
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, guiNames.fieldTypeOptionP, {
  sprite = "item/"..string.format(protoSettings["purple"].name, "wall", "purple"),
  tooltip = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties("purple", {damage=true, respawn=true, repair=true, max_health=true}),
  },
  style = guiSettings["guiSelectButtonStyle"],
})



-- Setup of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.fieldSetupLabel, {
  caption = {"", {"forcefields-gui-name.emitter-field-configuration"}, ": [img=info]"},
  tooltip = {"forcefields-gui-description.emitter-field-configuration"},
  style = guiSettings["guiLabelStyle"],
})
local guifieldSetup = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.fieldSetupTable, 3)
LSlib.gui.layout.addSpriteButton(guiLayout, guifieldSetup, guiNames.fieldSetupOptionS, {
  sprite = guiSettings["configSetupStraightSprite"],
  tooltip = {"forcefields-gui-description.emitter-field-configuration-straight"},
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guifieldSetup, guiNames.fieldSetupOptionC, {
  sprite = guiSettings["configSetupCornerSprite"],
  tooltip = {"forcefields-gui-description.emitter-field-configuration-corner"},
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guifieldSetup, guiNames.fieldSetupOptionA, {
  sprite = guiSettings["configWallSprite"],
  tooltip = {"forcefields-gui-description.emitter-field-configuration-advanced"},
  style = guiSettings["guiSelectButtonStyle"],
})



-- Direction of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.directionLabel, {
  caption = {"", {"forcefields-gui-name.emitter-field-direction"}, ": [img=info]"},
  tooltip = {"forcefields-gui-description.emitter-field-direction"},
  style = guiSettings["guiLabelStyle"],
})  
local guiFieldDirection = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.directionTable, 4)
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionN, {
  sprite = "virtual-signal/signal-N",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionE, {
  sprite = "virtual-signal/signal-E",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionS, {
  sprite = "virtual-signal/signal-S",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, guiNames.directionOptionW, {
  sprite = "virtual-signal/signal-W",
  style = guiSettings["guiSelectButtonStyle"],
})



-- Distance of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiFrameContent, guiNames.distanceLabel, {
  caption = {"", {"forcefields-gui-name.emitter-distance"}, ": [img=info]"},
  tooltip = {"forcefields-gui-description.emitter-distance"},
  style = guiSettings["guiLabelStyle"],
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
  caption = {"", {"forcefields-gui-name.emitter-width"}, ": [img=info]"},
  tooltip = {"forcefields-gui-description.emitter-width"},
  style = guiSettings["guiLabelStyle"],
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
  caption = {"", {"forcefields-gui-name.emitter-upgrades"}, ": [img=info]"},
  tooltip = {"forcefields-gui-description.emitter-upgrades"},
  style = guiSettings["guiLabelStyle"],
})
local guiEmitterUpgrades = LSlib.gui.layout.addTable(guiLayout, guiFrameContent, guiNames.upgradesTable, 3)
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, guiNames.upgradesDistance, {
  number = 0, show_percent_for_small_numbers = false,
  sprite = "item/advanced-circuit",
  tooltip = {"forcefields-gui-description.emitter-upgrades-distance", string.format("+%i", 1)},
  style = guiSettings["guiItemSlotStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, guiNames.upgradesWidth, {
  number = 0, show_percent_for_small_numbers = false,
  sprite = "item/processing-unit",
  tooltip = {"forcefields-gui-description.emitter-upgrades-width", string.format("+%i", runSettings.widthUpgradeMultiplier)},
  style = guiSettings["guiItemSlotStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, guiNames.buttonRemoveUpgrades, {
  tooltip = {"forcefields-gui-description.emitter-upgrades-remove"},
  sprite  = "utility/reset",
  style   = guiSettings["guiItemSlotStyle"],
})



-- Footer buttons
LSlib.gui.layout.addButton(guiLayout, guiFrameFooterFlow, guiNames.buttonDiscardSettings, {
  caption = {"forcefields-gui-name.discard"},
  style = "red_back_button",
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameFooterFlow, guiNames.guiFrame.."-footer-filler", "vertical", {
  style = "LSlib_default_footer_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addButton(guiLayout, guiFrameFooterFlow, guiNames.buttonApplySettings, {
  caption = {"forcefields-gui-name.apply"},
  style = "confirm_button",
})



return guiLayout