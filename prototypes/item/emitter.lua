local emitterSettings = require("prototypes/settings")["emitter"]
local modName         = require("prototypes/settings")["modName"]

data:extend{
    {
      type = "item",
      name = emitterSettings.emitterName,
      icon = modName .. "/graphics/" .. emitterSettings.emitterName .. "-icon.png",
      icon_size = 32,
      icons = nil,
      subgroup = "forcefield",
      order = "f[forcefield-emitter]",
      place_result = emitterSettings.emitterName,
      stack_size = 50
    }
  }
