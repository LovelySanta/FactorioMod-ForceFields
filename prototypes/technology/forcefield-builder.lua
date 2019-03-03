require 'prototypes/item/forcefield-builder'
require 'prototypes/recipe/forcefield-builder'
require 'lib/prototypes/icons'

function forceFieldWallTech(color)

  --required for technology effect
  forceFieldWallItem(color)
  forceFieldWallRecipe(color)

  local forceFieldWallTech = util.table.deepcopy(data.raw["technology"]["stone-walls"])
  local settings = require("prototypes/settings")[color]

  forceFieldWallTech.name             = string.format(settings.name, "wall", color)

  forceFieldWallTech.icon             = nil
  forceFieldWallTech.icon_size        = nil
  forceFieldWallTech.icons            = lib.prototypes.icons.getIcons("technology", "stone-walls", 1, {0 ,0}, settings.colorTint)

  forceFieldWallTech.prerequisites    = util.table.deepcopy(settings["wallTechnology"]["additionalPrerequisites"])
  forceFieldWallTech.effects          = util.table.deepcopy(settings["wallTechnology"]["additionalEffects"])
  table.insert(forceFieldWallTech.effects, {type = "unlock-recipe", recipe = forceFieldWallTech.name})

  forceFieldWallTech.unit             = util.table.deepcopy(settings["wallTechnology"]["technologyRecipe"])

  forceFieldWallTech.order            = "f-f-e"



  data:extend{forceFieldWallTech}

end
