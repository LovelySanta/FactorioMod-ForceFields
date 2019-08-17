require "__LSlib__/LSlib"
local settings = require("prototypes/settings")
local guiSettings = settings["gui"]



-- EMITTER GUI
local guiLayout = LSlib.gui.layout.create("center")



-- gui base
local guiFrame = LSlib.gui.layout.addFrame(guiLayout, "root", "emitterConfig", "vertical", {
  style = "frame_without_footer",
})
local guiFrameHeaderFlow = LSlib.gui.layout.addFlow(guiLayout, guiFrame, "emitterConfigHeaderFlow", "horizontal", {
  style = "LSlib_default_header",
})
LSlib.gui.layout.addLabel(guiLayout, guiFrameHeaderFlow, "emitterConfigHeaderTitle", {
  caption = {"entity-name."..settings["emitter"]["emitterName"]},
  style   = "LSlib_default_frame_title",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameHeaderFlow, "emitterConfigHeaderFiller", "vertical", {
  style = "LSlib_default_header_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFrameHeaderFlow, "configureWallButton", {
  sprite = guiSettings["configWallSprite"],
  style = "LSlib_default_header_button",
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFrameHeaderFlow, "emitterHelpButton", {
  sprite = "utility/questionmark"      ,
  style = "LSlib_default_header_button",
})

local guiBase = LSlib.gui.layout.addTable(guiLayout, guiFrame, "emitterConfigTable", 2)



-- Direction of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiBase, "directionLabel", {
  caption = "Direction:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})  
local guiFieldDirection = LSlib.gui.layout.addTable(guiLayout, guiBase, "directions", 4)
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, "directionN", {
  sprite = "virtual-signal/signal-N",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, "directionS", {
  sprite = "virtual-signal/signal-S",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, "directionE", {
  sprite = "virtual-signal/signal-E",
  style = guiSettings["guiSelectButtonStyle"],
})  
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldDirection, "directionW", {
  sprite = "virtual-signal/signal-W",
  style = guiSettings["guiSelectButtonStyle"],
})



-- Type of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiBase, "fieldTypeLabel", {
  caption = "Field type:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiFieldType = LSlib.gui.layout.addTable(guiLayout, guiBase, "fields", 4)
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, "fieldB", {
  sprite = "item/"..string.format(settings["blue"].name, "wall", "blue"),
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, "fieldG", {
  sprite = "item/"..string.format(settings["green"].name, "wall", "green"),
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, "fieldR", {
  sprite = "item/"..string.format(settings["red"].name, "wall", "red"),
  style = guiSettings["guiSelectButtonStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiFieldType, "fieldP", {
  sprite = "item/"..string.format(settings["purple"].name, "wall", "purple"),
  style = guiSettings["guiSelectButtonStyle"],
})



-- Distance of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiBase, "distanceLabel", {
  caption = "Emitter distance:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiEmitterDistance = LSlib.gui.layout.addTable(guiLayout, guiBase, "distance", 2)
LSlib.gui.layout.addTextfield(guiLayout, guiEmitterDistance, "emitterDistance", {
  numeric = true, allow_decimal = false,
  style = guiSettings["guiTextfieldStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiEmitterDistance, "emitterMaxDistance", {
  ignored_by_interaction = true,
})



-- Width of forcefield
LSlib.gui.layout.addLabel(guiLayout, guiBase, "currentWidthLabel", {
  caption = "Emitter width:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiEmitterWidth = LSlib.gui.layout.addTable(guiLayout, guiBase, "width", 2)
LSlib.gui.layout.addTextfield(guiLayout, guiEmitterWidth, "emitterWidth", {
  numeric = true, allow_decimal = false,
  style = guiSettings["guiTextfieldStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiEmitterWidth, "emitterMaxWidth", {
  ignored_by_interaction = true,
})



-- Upgrades of emitter
LSlib.gui.layout.addLabel(guiLayout, guiBase, "upgradesLabel", {
  caption = "Upgrades applied:",
  style = guiSettings["guiLabelStyle"],
  ignored_by_interaction = true,
})
local guiEmitterUpgrades = LSlib.gui.layout.addTable(guiLayout, guiBase, "upgrades", 3)
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, "distanceUpgrades", {
  number = 0, show_percent_for_small_numbers = false,
  sprite = "item/advanced-circuit",
  style = guiSettings["guiItemSlotStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, "widthUpgrades", {
  number = 0, show_percent_for_small_numbers = false,
  sprite = "item/processing-unit",
  style = guiSettings["guiItemSlotStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiEmitterUpgrades, "removeAllUpgrades", {
  tooltip = "Remove all upgrades",
  sprite  = "utility/reset",
  style   = guiSettings["guiItemSlotStyle"],
})



-- Footer buttons
local guiFrameFooterFlow = LSlib.gui.layout.addFlow(guiLayout, guiFrame, "emitterConfigFooterFlow", "horizontal", {
  style = "LSlib_default_footer",
})
LSlib.gui.layout.addFrame(guiLayout, guiFrameFooterFlow, "emitterConfigFooterFiller", "vertical", {
  style = "LSlib_default_footer_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addButton(guiLayout, guiFrameFooterFlow, "applyButton", {
  caption = "Apply changes",
  style = "confirm_button",
})



return guiLayout