local emitterSettings = require("prototypes/settings")["emitter"]
local modName         = require("prototypes/settings")["modName"]

data:extend(
{
  {
    type = "electric-energy-interface",
    name = emitterSettings.emitterName,
    icon = data.raw["item"][emitterSettings.emitterName].icon,
    icon_size = data.raw["item"][emitterSettings.emitterName].icon_size,
    icons = util.table.deepcopy(data.raw["item"][emitterSettings.emitterName].icons),
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    enable_gui = true,
    gui_mode = "all",
    allow_copy_paste = true,
    minable = {hardness = 0.2, mining_time = 1, result = emitterSettings.emitterName},
    max_health = 50,
    corpse = "small-remnants",
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    energy_source =
    {
      type = "electric",
      buffer_capacity = "100MJ",
      usage_priority = "primary-input",
      input_flow_limit = "100MW",
      output_flow_limit = "0kW",
      drain = "100kW"
    },
    energy_production = "0kW",
    energy_consumption = "100MW",
    picture =
    {
      filename = modName .. "/graphics/" .. emitterSettings.emitterName .. "-active.png",
      priority = "extra-high",
      width = 72,
      height = 62,
      shift = {0.49145, -0.25}
    },
    working_sound =
    {
      idle_sound =
      {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0.4
      },
      sound =
      {
        filename = "__base__/sound/accumulator-idle.ogg",
        volume = 0.4
      },
      max_sounds_per_type = 5
    },
    --order="f[forcefield]-a[emitter]",
    --subgroup = "forcefield"
  },
})
