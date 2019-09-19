local emitterSettings = require("prototypes/settings")["emitter"]

local forcefieldCrafter = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])

forcefieldCrafter.name = emitterSettings.emitterName .. "-crafter"
forcefieldCrafter.localised_name = {"entity-name."..emitterSettings.emitterName}
forcefieldCrafter.localised_description = {"",
  {"entity-description."..emitterSettings.emitterName},
  {"tooltip-description.unobtainable", {"mod-name.ForceFields2"}},
}

forcefieldCrafter.minable.result = nil
forcefieldCrafter.order = data.raw["item"][emitterSettings.emitterName].order
forcefieldCrafter.subgroup = data.raw["item"][emitterSettings.emitterName].subgroup

forcefieldCrafter.next_upgrade = nil
forcefieldCrafter.crafting_categories = {emitterSettings["crafting-category"]}

forcefieldCrafter.icon = data.raw["item"][emitterSettings.emitterName].icon
forcefieldCrafter.icon_size = data.raw["item"][emitterSettings.emitterName].icon_size
forcefieldCrafter.icons = util.table.deepcopy(data.raw["item"][emitterSettings.emitterName].icons)

data:extend{forcefieldCrafter}
