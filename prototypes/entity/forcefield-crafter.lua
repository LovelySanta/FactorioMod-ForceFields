local emitterSettings = require("prototypes/settings")["emitter"]

local forceFieldCrafter = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])

forceFieldCrafter.name = emitterSettings.emitterName .. "-crafter"

forceFieldCrafter.minable.result = nil
forceFieldCrafter.order = data.raw["item"][emitterSettings.emitterName].order
forceFieldCrafter.subgroup = data.raw["item"][emitterSettings.emitterName].subgroup

forceFieldCrafter.crafting_categories = {emitterSettings["crafting-category"]}

forceFieldCrafter.icon = data.raw["item"][emitterSettings.emitterName].icon
forceFieldCrafter.icon_size = data.raw["item"][emitterSettings.emitterName].icon_size
forceFieldCrafter.icons = util.table.deepcopy(data.raw["item"][emitterSettings.emitterName].icons)


data:extend{forceFieldCrafter}
