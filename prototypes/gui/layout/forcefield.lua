require "__LSlib__/LSlib"
local settings = require("prototypes/settings")
local guiSettings = settings["gui"]
local guiNames = require("prototypes/gui/layout/guiElementNames")

  -- FORCEFIELD GUI --
local guiLayout = LSlib.gui.layout.create("center")



-- gui base
local guiConfigFrame = LSlib.gui.layout.addFrame(guiLayout, "root", guiNames.configFrame, "vertical", {
  style = "frame_without_footer",
})
local guiConfigFrameHeaderFlow = LSlib.gui.layout.addFlow(guiLayout, guiConfigFrame, guiNames.configFrame.."-header-flow", "horizontal", {
  style = "LSlib_default_header",
})
local guiConfigFrameContent = LSlib.gui.layout.addFlow(guiLayout, guiConfigFrame, guiNames.configTableFrame, "horizontal")
local guiConfigFrameFooterFlow = LSlib.gui.layout.addFlow(guiLayout, guiConfigFrame, guiNames.configFrame.."-footer-flow", "horizontal", {
  style = "LSlib_default_footer",
})



-- gui header
LSlib.gui.layout.addLabel(guiLayout, guiConfigFrameHeaderFlow, guiNames.configFrame.."-header-title", {
  caption = {"entity-name."..settings["emitter"]["emitterName"]},
  style   = "LSlib_default_frame_title",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addFrame(guiLayout, guiConfigFrameHeaderFlow, guiNames.configFrame.."-header-filler", "vertical", {
  style = "LSlib_default_header_filler",
  ignored_by_interaction = true,
})



-- Wall table row header
local guiConfigTable = LSlib.gui.layout.addTable(guiLayout, guiConfigFrameContent, guiNames.configTableHeader, 2, {
  style = guiSettings["guiTableRowHeaderStyle"]
})
LSlib.gui.layout.addLabel(guiLayout, guiConfigTable, guiNames.configRowOptionLabel, {
  caption = "All",
  ignored_by_interaction = true,
})
local guiRowDescriptionTable = LSlib.gui.layout.addTable(guiLayout, guiConfigTable, guiNames.configRowDescriptionLabel.."-table", 2)
LSlib.gui.layout.addFlow(guiLayout, guiRowDescriptionTable, guiNames.configRowDescriptionLabel.."-flow", "horizontal", {
  style = guiSettings["guiTableRowHeaderFlowStyle"],
  ignored_by_interaction = true,
})
LSlib.gui.layout.addLabel(guiLayout, guiRowDescriptionTable, guiNames.configRowDescriptionLabel, {
  caption = "[img=info]",
  tooltip = {"forcefields-gui-description.forcefield-configure-segments"},
  style = guiSettings["guiTableRowHeaderIconStyle"],
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiConfigTable, guiNames.configRowOption.."E", {
  tooltip = {"forcefields-gui-description.forcefield-configure-all-empty"},
  sprite  = "utility/set_bar_slot",
  style   = guiSettings["guiSmallSelectButtonStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiConfigTable, guiNames.configRowOptionLabel.."E", {
  caption = {"forcefields-gui-name.forcefield-configure-empty"},
  style = guiSettings["guiTableRowHeaderLabelStyle"],
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiConfigTable, guiNames.configRowOption.."W", {
  tooltip = {"forcefields-gui-description.forcefield-configure-all-wall"},
  sprite  = "item/stone-wall",
  style   = guiSettings["guiSmallSelectButtonStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiConfigTable, guiNames.configRowOptionLabel.."W", {
  caption = {"forcefields-gui-name.forcefield-configure-wall"},
  style = guiSettings["guiTableRowHeaderLabelStyle"],
  ignored_by_interaction = true,
})
LSlib.gui.layout.addSpriteButton(guiLayout, guiConfigTable, guiNames.configRowOption.."G", {
  tooltip = {"forcefields-gui-description.forcefield-configure-all-gate"},
  sprite  = "item/gate",
  style   = guiSettings["guiSmallSelectButtonStyle"],
})
LSlib.gui.layout.addLabel(guiLayout, guiConfigTable, guiNames.configRowOptionLabel.."G", {
  caption = {"forcefields-gui-name.forcefield-configure-gate"},
  style = guiSettings["guiTableRowHeaderLabelStyle"],
  ignored_by_interaction = true,
})



-- Wall table row data
LSlib.gui.layout.addScrollPane(guiLayout, guiConfigFrameContent, guiNames.configTableSlider, {
  horizontal_scroll_policy = "auto",
  vertical_scroll_policy   = "never",
})



-- Footer buttons
LSlib.gui.layout.addButton(guiLayout, guiConfigFrameFooterFlow, guiNames.configCancelButton, {
  caption = {"forcefields-gui-name.discard"},
  tooltip = {"forcefields-gui-description.forcefield-configure-discard"},
  style = "red_back_button",
})
LSlib.gui.layout.addFrame(guiLayout, guiConfigFrameFooterFlow, guiNames.guiFrame.."-footer-filler", "vertical", {
  style = "LSlib_default_footer_filler",
  ignored_by_interaction = true,
})
LSlib.gui.layout.addButton(guiLayout, guiConfigFrameFooterFlow, guiNames.configApplyButton, {
  caption = {"forcefields-gui-name.apply"},
  tooltip = {"forcefields-gui-description.forcefield-configure-apply"},
  style = "confirm_button",
})

return guiLayout