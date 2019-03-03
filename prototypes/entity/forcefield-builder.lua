require "lib/prototypes/icons"
require "lib/prototypes/sprites"



function forceFieldWallEntity(color)

  local settings = require("prototypes/settings")[color]
  local forceFieldWall = util.table.deepcopy(data.raw["wall"]["stone-wall"])

  forceFieldWall.name                   = string.format(settings.name, "wall", color)

  forceFieldWall.icon_size              = nil
  forceFieldWall.icon                   = nil
  forceFieldWall.icons                  = lib.prototypes.icons.getIcons("wall", "stone-wall", 1, {0 ,0}, settings.colorTint)

  table.insert(forceFieldWall.flags, "not-repairable")

  forceFieldWall.minable                = {hardness = 0.2, mining_time = 1,
                                           result = (settings.manualPlaceable and forceFieldWall.name or nil),}
  forceFieldWall.mised_sound            = nil
  forceFieldWall.fast_replaceable_group = nil

  forceFieldWall.order                  = "a[items]-f[forcefields]"
  forceFieldWall.subgroup               = "forcefield"

  forceFieldWall.max_health             = settings.properties.maxHealth
  forceFieldWall.resistances            = settings.resistances


  local tint = settings.colorTint   -- add tint to wall
  for pictureName,picture in pairs(forceFieldWall.pictures) do
    -- https://wiki.factorio.com/Prototype/Wall#pictures
    if pictureName == "water_connection_patch" or pictureName == "gate_connection_patch" then
      local tempPicture                    = lib.prototypes.sprites.addTintToSprite4Way(picture, tint)
      forceFieldWall.pictures[pictureName] = lib.prototypes.sprites.removeShadowFromSprite4Way(tempPicture)
    else
      local tempPicture                    = lib.prototypes.sprites.addTintToSpriteVariation(picture, tint)
      forceFieldWall.pictures[pictureName] = lib.prototypes.sprites.removeShadowsFromSpriteVariation(tempPicture)
    end
  end

  data:extend{forceFieldWall}

end


-- function forceFieldGateEntity(color)
--
--   local settings = require("prototypes/settings")[color]
--   local forceFieldGate = util.table.deepcopy(data.raw["gate"]["gate"])
--
--   forceFIeldGate.name       = string.forward(settings.name, "gate", color)
--   forceFieldGate.max_health = settings.maxHealth
--
--   forceFieldWall.icon       = lib.prototypes.icons.getIcons("gate", "gate", 1, {0 ,0}, settings.colorTint)
--
--
-- end
