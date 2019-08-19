require 'prototypes/item/forcefield-builder'
require 'prototypes/recipe/forcefield-builder'
require "__LSlib__/LSlib"

function forcefieldWallTech(color)

  --required for technology effect
  forcefieldWallItem(color)
  forcefieldWallRecipe(color)

  local forcefieldWallTech = util.table.deepcopy(data.raw["technology"]["stone-walls"])
  local settings = require("prototypes/settings")[color]

  forcefieldWallTech.name             = string.format(settings.name, "wall", color)

  forcefieldWallTech.icon             = nil
  forcefieldWallTech.icon_size        = nil
  forcefieldWallTech.icons            = LSlib.technology.getIcons("stone-walls", nil, nil, settings.colorTint)

  forcefieldWallTech.prerequisites    = util.table.deepcopy(settings["wallTechnology"]["additionalPrerequisites"])
  forcefieldWallTech.effects          = util.table.deepcopy(settings["wallTechnology"]["additionalEffects"])
  table.insert(forcefieldWallTech.effects, {type = "unlock-recipe", recipe = forcefieldWallTech.name})

  forcefieldWallTech.unit             = util.table.deepcopy(settings["wallTechnology"]["technologyRecipe"])

  forcefieldWallTech.order            = "f-f-e"

  data:extend{forcefieldWallTech}

end



function forcefieldGateTech(color)

  --required for technology effect
  forcefieldGateItem(color)
  forcefieldGateRecipe(color)

  local forcefieldGateTech = util.table.deepcopy(data.raw["technology"]["gates"])
  local settings = require("prototypes/settings")[color]

  forcefieldGateTech.name             = string.format(settings.name, "gate", color)

  forcefieldGateTech.icon             = nil
  forcefieldGateTech.icon_size        = nil
  forcefieldGateTech.icons            = LSlib.technology.getIcons("gates", nil, nil, settings.colorTint)

  forcefieldGateTech.prerequisites    = util.table.deepcopy(settings["gateTechnology"]["additionalPrerequisites"])
  table.insert(forcefieldGateTech.prerequisites, string.format(settings.name, "wall", color))
  forcefieldGateTech.effects          = util.table.deepcopy(settings["gateTechnology"]["additionalEffects"])
  table.insert(forcefieldGateTech.effects, {type = "unlock-recipe", recipe = forcefieldGateTech.name})

  forcefieldGateTech.unit             = util.table.deepcopy(settings["gateTechnology"]["technologyRecipe"])

  forcefieldGateTech.order            = "f-f-e"

  data:extend{forcefieldGateTech}

end
