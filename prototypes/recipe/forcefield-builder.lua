function forcefieldWallRecipe(color)

  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")
  local emitter  = require("prototypes/settings")["emitter"]

  data:extend{{
    type = "recipe",
    name = string.format(settings.name, "wall", color),
    localised_description = (not settings.manualPlaceable) and {"",
      {"entity-description.forcefield-wall"} or "",
      fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=true}),
    } or nil,
    energy_required = math.floor(settings.properties.respawnRate * emitter.tickRate / 60 * 100)/100,
    category = emitter["crafting-category"],
    ingredients = {{emitter["emitterName"], 1}},
    result = string.format(settings.name, "wall", color),
    enabled = "false",
    always_show_made_in = "true",
    allow_decomposition = "false",
    allow_as_intermediate = "false",
    hide_from_stats = "true",
  }}

end



function forcefieldGateRecipe(color)

  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")
  local emitter  = require("prototypes/settings")["emitter"]

  data:extend{{
    type = "recipe",
    name = string.format(settings.name, "gate", color),
    localised_description = (not settings.manualPlaceable) and {"",
      {"entity-description.forcefield-wall"} or "",
      fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=true}),
    } or nil,
    energy_required = math.floor(settings.properties.respawnRate * emitter.tickRate / 60 * 100)/100,
    category = emitter["crafting-category"],
    ingredients = {{emitter["emitterName"], 1}},
    result = string.format(settings.name, "gate", color),
    enabled = "false",
    always_show_made_in = "true",
    allow_decomposition = "false",
    allow_as_intermediate = "false",
    hide_from_stats = "true",
  }}

end
