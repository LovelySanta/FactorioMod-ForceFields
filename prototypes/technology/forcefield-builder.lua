require 'prototypes/item/forcefield-builder'
require 'prototypes/recipe/forcefield-builder'
require "__LSlib__/LSlib"

function forceFieldWallTech(color)

  --required for technology effect
  forceFieldWallItem(color)
  forceFieldWallRecipe(color)

  local forceFieldWallTech = util.table.deepcopy(data.raw["technology"]["stone-walls"])
  local settings = require("prototypes/settings")[color]

  forceFieldWallTech.name             = string.format(settings.name, "wall", color)

  forceFieldWallTech.icon             = nil
  forceFieldWallTech.icon_size        = nil
  forceFieldWallTech.icons            = LSlib.technology.getIcons("stone-walls", nil, nil, settings.colorTint)

  forceFieldWallTech.prerequisites    = util.table.deepcopy(settings["wallTechnology"]["additionalPrerequisites"])
  forceFieldWallTech.effects          = util.table.deepcopy(settings["wallTechnology"]["additionalEffects"])
  table.insert(forceFieldWallTech.effects, {type = "unlock-recipe", recipe = forceFieldWallTech.name})

  forceFieldWallTech.unit             = util.table.deepcopy(settings["wallTechnology"]["technologyRecipe"])

  forceFieldWallTech.order            = "f-f-e"

  data:extend{forceFieldWallTech}

end



function forceFieldGateTech(color)

  --required for technology effect
  forceFieldGateItem(color)
  forceFieldGateRecipe(color)

  local forceFieldGateTech = util.table.deepcopy(data.raw["technology"]["gates"])
  local settings = require("prototypes/settings")[color]

  forceFieldGateTech.name             = string.format(settings.name, "gate", color)

  forceFieldGateTech.icon             = nil
  forceFieldGateTech.icon_size        = nil
  forceFieldGateTech.icons            = LSlib.technology.getIcons("gates", nil, nil, settings.colorTint)

  forceFieldGateTech.prerequisites    = util.table.deepcopy(settings["gateTechnology"]["additionalPrerequisites"])
  table.insert(forceFieldGateTech.prerequisites, string.format(settings.name, "wall", color))
  forceFieldGateTech.effects          = util.table.deepcopy(settings["gateTechnology"]["additionalEffects"])
  table.insert(forceFieldGateTech.effects, {type = "unlock-recipe", recipe = forceFieldGateTech.name})

  forceFieldGateTech.unit             = util.table.deepcopy(settings["gateTechnology"]["technologyRecipe"])

  forceFieldGateTech.order            = "f-f-e"

  data:extend{forceFieldGateTech}

end
