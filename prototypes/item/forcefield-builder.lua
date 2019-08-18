require "__LSlib__/LSlib"

function forceFieldWallItem(color)

  local forceFieldWall = util.table.deepcopy(data.raw["item"]["stone-wall"])
  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")

  local colorTint = util.table.deepcopy(settings.colorTint)
  colorTint.a = math.min(1, colorTint.a + .1)

  forceFieldWall.name                   = string.format(settings.name, "wall", color)
  forceFieldWall.localised_name         = {"entity-name."..forceFieldWall.name}
  forceFieldWall.localised_description  = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties(color, {respawn=true, repair=true, max_health=true}),
  }

  forceFieldWall.icon_size              = nil
  forceFieldWall.icon                   = nil
  forceFieldWall.icons                  = LSlib.item.getIcons("item", "stone-wall", nil, nil, colorTint)

  forceFieldWall.order                  = string.format("f[forcefields]-b[field]-%s[%s]-a[wall]", settings.order, color)
  forceFieldWall.subgroup               = "forcefield"

  forceFieldWall.place_result           = (settings.manualPlaceable and forceFieldWall.name or nil)

  data:extend{forceFieldWall}

end



function forceFieldGateItem(color)

  local forceFieldGate = util.table.deepcopy(data.raw["item"]["gate"])
  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")

  local colorTint = util.table.deepcopy(settings.colorTint)
  colorTint.a = math.min(1, colorTint.a + .1)

  forceFieldGate.name                   = string.format(settings.name, "gate", color)
  forceFieldGate.localised_name         = {"entity-name."..forceFieldGate.name}
  forceFieldGate.localised_description  = {"",
    {"entity-description.forcefield-gate"},
    fieldProperties:generate_properties(color, {respawn=true, repair=true, max_health=true}),
  }

  forceFieldGate.icon_size              = nil
  forceFieldGate.icon                   = nil
  forceFieldGate.icons                  = LSlib.item.getIcons("item", "gate", nil, nil, colorTint)

  forceFieldGate.order                  = string.format("f[forcefields]-b[field]-%s[%s]-b[gate]", settings.order, color)
  forceFieldGate.subgroup               = "forcefield"

  forceFieldGate.place_result           = (settings.manualPlaceable and forceFieldGate.name or nil)

  data:extend{forceFieldGate}

end
