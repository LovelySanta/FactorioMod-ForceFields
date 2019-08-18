require "__LSlib__/LSlib"

function forceFieldWallItem(color)

  local forceFieldWall = util.table.deepcopy(data.raw["item"]["stone-wall"])
  local settings = require("prototypes/settings")[color]

  forceFieldWall.name                   = string.format(settings.name, "wall", color)

  forceFieldWall.icon_size              = nil
  forceFieldWall.icon                   = nil
  forceFieldWall.icons                  = LSlib.item.getIcons("item", "stone-wall", nil, nil, settings.colorTint)

  forceFieldWall.order                  = string.format("f[forcefields]-b[field]-%s[%s]-a[wall]", settings.order, color)
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
  forceFieldGate.icons                  = LSlib.item.getIcons("item", "gate", nil, nil, settings.colorTint)

  forceFieldGate.order                  = string.format("f[forcefields]-b[field]-%s[%s]-b[gate]", settings.order, color)
  forceFieldGate.subgroup               = "forcefield"

  forceFieldGate.place_result           = (settings.manualPlaceable and forceFieldGate.name or nil)

  data:extend{forceFieldGate}

end
