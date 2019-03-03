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
