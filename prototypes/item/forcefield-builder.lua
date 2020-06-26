require "__LSlib__/LSlib"

function forcefieldWallItem(color)

  local forcefieldWall = util.table.deepcopy(data.raw["item"]["stone-wall"])
  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")

  local colorTint = util.table.deepcopy(settings.colorTint)
  colorTint.a = math.min(1, colorTint.a + .1)

  forcefieldWall.name                   = string.format(settings.name, "wall", color)
  forcefieldWall.localised_name         = {"entity-name."..forcefieldWall.name}
  forcefieldWall.localised_description  = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=true}),
    (not settings.manualPlaceable) and {"tooltip-description.unobtainable", {"mod-name.ForceFields2"}} or "",
  }

  forcefieldWall.icon_size              = nil
  forcefieldWall.icon                   = nil
  forcefieldWall.icons                  = LSlib.item.getIcons("item", "stone-wall", nil, nil, colorTint)

  if forcefieldWall.flags then
    table.insert(forcefieldWall.flags, "hidden")
  else
    forcefieldWall.flags = { "hidden" }
  end

  forcefieldWall.order                  = string.format("f[forcefields]-b[field]-%s[%s]-a[wall]", settings.order, color)
  forcefieldWall.subgroup               = "forcefield"

  forcefieldWall.place_result           = (settings.manualPlaceable and forcefieldWall.name or nil)

  data:extend{forcefieldWall}

end



function forcefieldGateItem(color)

  local forcefieldGate = util.table.deepcopy(data.raw["item"]["gate"])
  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")

  local colorTint = util.table.deepcopy(settings.colorTint)
  colorTint.a = math.min(1, colorTint.a + .1)

  forcefieldGate.name                   = string.format(settings.name, "gate", color)
  forcefieldGate.localised_name         = {"entity-name."..forcefieldGate.name}
  forcefieldGate.localised_description  = {"",
    {"entity-description.forcefield-gate"},
    fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=true}),
    (not settings.manualPlaceable) and {"tooltip-description.unobtainable", {"mod-name.ForceFields2"}} or "",
  }

  forcefieldGate.icon_size              = nil
  forcefieldGate.icon                   = nil
  forcefieldGate.icons                  = LSlib.item.getIcons("item", "gate", nil, nil, colorTint)

  if forcefieldGate.flags then
    table.insert(forcefieldGate.flags, "hidden")
  else
    forcefieldGate.flags = { "hidden" }
  end

  forcefieldGate.order                  = string.format("f[forcefields]-b[field]-%s[%s]-b[gate]", settings.order, color)
  forcefieldGate.subgroup               = "forcefield"

  forcefieldGate.place_result           = (settings.manualPlaceable and forcefieldGate.name or nil)

  data:extend{forcefieldGate}

end
