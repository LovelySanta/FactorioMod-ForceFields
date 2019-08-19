local emitterSettings = require("prototypes/settings")["emitter"]
local modName         = require("prototypes/settings")["modName"]

data:extend{
  {
    type = "item",
    name = emitterSettings.emitterName,
    localised_name = {"entity-name."..emitterSettings.emitterName},
    localised_description = {"entity-description."..emitterSettings.emitterName},
    icon = modName .. "/graphics/" .. emitterSettings.emitterName .. "-icon.png",
    icon_size = 32,
    icons = nil,
    subgroup = "forcefield",
    order = "f[forcefield]-a[emitter]",
    place_result = emitterSettings.emitterName,
    stack_size = 50
  }
}
