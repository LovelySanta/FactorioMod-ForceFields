local emitterSettings = require("prototypes/settings")["emitter"]


data:extend{
  {
    type = "recipe",
    name = emitterSettings.emitterName,
    energy_required = 5,
    ingredients = {
      {"steel-plate", 50},
      {"battery", 200},
      {"advanced-circuit", 20},
      {"small-lamp", 4},
    },
    result = emitterSettings.emitterName,
    enabled = "false",
    always_show_made_in = "true",
    allow_decomposition = "false",
  }
}
