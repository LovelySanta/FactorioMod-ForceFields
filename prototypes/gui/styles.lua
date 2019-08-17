local guiSettings = require("prototypes/settings")["gui"]

LSlib.styles.addFillerFrameStyles()

LSlib.styles.addLabelStyle{
  name = guiSettings["guiLabelStyle"],
  parent = "label",

  minimal_width = 130,
}

LSlib.styles.addButtonStyle{
  name = guiSettings["guiSelectButtonStyle"],
  parent = "button",
  
  size = 36,
  padding = 0,
  
  createSelectedStyle = true,
  selected_graphical_set         = data.raw["gui-style"]["default"].button.selected_graphical_set        ,
  selected_hovered_graphical_set = data.raw["gui-style"]["default"].button.selected_hovered_graphical_set,
  selected_clicked_graphical_set = data.raw["gui-style"]["default"].button.selected_clicked_graphical_set,
}

LSlib.styles.addButtonStyle{
  name = guiSettings["guiItemSlotStyle"],
  parent = "slot_button",
}

LSlib.styles.addButtonStyle{
  name = guiSettings["guiSmallSelectButtonStyle"],
  parent = "mini_button",
  
  size = 20,
  
  createSelectedStyle = true,
  selected_graphical_set         = data.raw["gui-style"]["default"].button.selected_graphical_set        ,
  selected_hovered_graphical_set = data.raw["gui-style"]["default"].button.selected_hovered_graphical_set,
  selected_clicked_graphical_set = data.raw["gui-style"]["default"].button.selected_clicked_graphical_set,
}
