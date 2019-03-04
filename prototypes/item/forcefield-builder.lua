require "lib/prototypes/icons"

function forceFieldWallItem(color)

  local forceFieldWall = util.table.deepcopy(data.raw["item"]["stone-wall"])
  local settings = require("prototypes/settings")[color]

  forceFieldWall.name                   = string.format(settings.name, "wall", color)

  forceFieldWall.icon_size              = nil
  forceFieldWall.icon                   = nil
  forceFieldWall.icons                  = lib.prototypes.icons.getIcons("item", "stone-wall", 1, {0 ,0}, settings.colorTint)

  forceFieldWall.order                  = "a[items]-f[forcefields]"
  forceFieldWall.subgroup               = "forcefield"

  forceFieldWall.place_result           = (settings.manualPlaceable and forceFieldWall.name or nil)


  data:extend{forceFieldWall}

end



function forceFieldGateItem(color)

  local forceFieldGate = util.table.deepcopy(data.raw["item"]["gate"])
  local settings = require("prototypes/settings")[color]

  forceFieldGate.name                   = string.format(settings.name, "gate", color)

  forceFieldGate.icon_size              = nil
  forceFieldGate.icon                   = nil
  forceFieldGate.icons                  = lib.prototypes.icons.getIcons("item", "gate", 1, {0 ,0}, settings.colorTint)

  forceFieldGate.order                  = "a[items]-f[forcefields]"
  forceFieldGate.subgroup               = "forcefield"

  forceFieldGate.place_result           = (settings.manualPlaceable and forceFieldGate.name or nil)


  data:extend{forceFieldGate}

end
