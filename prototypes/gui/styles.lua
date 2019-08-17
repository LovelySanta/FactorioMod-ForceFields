local guiSettings = require("prototypes/settings")["gui"]

LSlib.styles.addButtonStyle{
  name = guiSettings["guiSelectButtonStyle"],
  createSelectedStyle = true,

  parent = "button",
}

LSlib.styles.addButtonStyle{
  name = guiSettings["guiSmallSelectButtonStyle"],
  createSelectedStyle = true,
  
  parent = "button",
}

LSlib.styles.addButtonStyle{
  name = guiSettings["guiItemSlotStyle"],

  parent = "slot_button",
}