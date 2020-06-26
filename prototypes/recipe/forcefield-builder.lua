function forcefieldWallRecipe(color)

  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")
  local emitter  = require("prototypes/settings")["emitter"]

  data:extend{{
    type    = "recipe",
    name    = string.format(settings.name, "wall", color),
    enabled = "false",

    localised_name        = {"entity-name."..string.format(settings.name, "wall", color)},
    localised_description = (not settings.manualPlaceable) and {"",
      {"entity-description.forcefield-wall"} or "",
      fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=true}),
    } or nil,

    icon      = data.raw["item"][string.format(settings.name, "wall", color)].icon,
    icon_size = data.raw["item"][string.format(settings.name, "wall", color)].icon_size,
    icons     = util.table.deepcopy(data.raw["item"][string.format(settings.name, "wall", color)].icons),

    subgroup = data.raw["item"][string.format(settings.name, "wall", color)].subgroup,
    order    = data.raw["item"][string.format(settings.name, "wall", color)].order,

    ingredients     = {},
    energy_required = math.floor(settings.properties.respawnRate * emitter.tickRate / 60 * 100)/100,

    allow_decomposition   = "false",
    allow_as_intermediate = "false",
    hide_from_stats       = "true",

    results              = {},
    always_show_products = "false",

    category            = emitter["crafting-category"],
    always_show_made_in = "true",
  }}

end



function forcefieldGateRecipe(color)

  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")
  local emitter  = require("prototypes/settings")["emitter"]

  data:extend{{
    type    = "recipe",
    name    = string.format(settings.name, "gate", color),
    enabled = "false",

    localised_name        = {"entity-name."..string.format(settings.name, "gate", color)},
    localised_description = (not settings.manualPlaceable) and {"",
      {"entity-description.forcefield-wall"} or "",
      fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=true}),
    } or nil,

    icon      = data.raw["item"][string.format(settings.name, "gate", color)].icon,
    icon_size = data.raw["item"][string.format(settings.name, "gate", color)].icon_size,
    icons     = util.table.deepcopy(data.raw["item"][string.format(settings.name, "gate", color)].icons),

    subgroup = data.raw["item"][string.format(settings.name, "gate", color)].subgroup,
    order    = data.raw["item"][string.format(settings.name, "gate", color)].order,

    ingredients = {},
    energy_required = math.floor(settings.properties.respawnRate * emitter.tickRate / 60 * 100)/100,

    allow_decomposition   = "false",
    allow_as_intermediate = "false",
    hide_from_stats       = "true",

    results             = {},
    always_show_made_in = "true",

    category            = emitter["crafting-category"],
    always_show_made_in = "true",
  }}

end
