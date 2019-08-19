require "__LSlib__/LSlib"

function forcefieldWallEntity(color)

  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")
  local forcefieldWall = util.table.deepcopy(data.raw["wall"]["stone-wall"])

  forcefieldWall.name                   = string.format(settings.name, "wall", color)
  forcefieldWall.localised_description  = {"",
    {"entity-description.forcefield-wall"},
    fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=false}),
  }

  forcefieldWall.icon_size              = nil
  forcefieldWall.icon                   = nil
  forcefieldWall.icons                  = LSlib.entity.getIcons("wall", "stone-wall", nil, nil, settings.colorTint)

  forcefieldWall.flags = forcefieldWall.flags or {}
  table.insert(forcefieldWall.flags, "not-repairable")
  table.insert(forcefieldWall.flags, "not-blueprintable")
  table.insert(forcefieldWall.flags, "not-deconstructable")
  table.insert(forcefieldWall.flags, "hidden")
  table.insert(forcefieldWall.flags, "not-upgradable")
  table.insert(forcefieldWall.flags, "no-copy-paste")
  
  forcefieldWall.placeable_by           = {item = forcefieldWall.name, count = 1}
  forcefieldWall.minable                = {hardness = 0.2, mining_time = 1,
                                           result = (settings.manualPlaceable and forcefieldWall.name or nil),}
  forcefieldWall.mined_sound            = nil
  forcefieldWall.fast_replaceable_group = nil

  forcefieldWall.allow_copy_paste       = false

  forcefieldWall.order                  = string.format("f[forcefields]-b[field]-%s[%s]-a[wall]", settings.order, color)
  forcefieldWall.subgroup               = "forcefield"

  forcefieldWall.max_health             = settings.properties.maxHealth
  forcefieldWall.resistances            = settings.resistances

  if settings.properties["reflectDamage"] and settings.properties["reflectDamage"] > 0 then
    forcefieldWall.attack_reaction = {
      range = settings.properties["reflectRange"],
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "damage",
              damage = {amount = settings.properties["reflectDamage"], type = "laser"}
            }
          }
        }
      }
    }
  end

  local tint = settings.colorTint   -- add tint to wall
  for pictureName,picture in pairs(forcefieldWall.pictures) do
    -- https://wiki.factorio.com/Prototype/Wall#pictures
    if pictureName == "water_connection_patch" or pictureName == "gate_connection_patch" then
      local tempPicture                    = LSlib.entity.addTintToSprite4Way(picture, tint)
      forcefieldWall.pictures[pictureName] = LSlib.entity.removeShadowFromSprite4Way(tempPicture)
    else
      local tempPicture                    = LSlib.entity.addTintToSpriteVariation(picture, tint)
      forcefieldWall.pictures[pictureName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
    end
  end

  data:extend{forcefieldWall}

end



function forcefieldGateEntity(color)

  local settings = require("prototypes/settings")[color]
  local fieldProperties = require("prototypes/entity/forcefield-properties")
  local forcefieldGate = util.table.deepcopy(data.raw["gate"]["gate"])

  forcefieldGate.name                   = string.format(settings.name, "gate", color)
  forcefieldGate.localised_description  = {"",
    {"entity-description.forcefield-gate"},
    fieldProperties:generate_properties(color, {damage=true, respawn=true, repair=true, max_health=false}),
  }

  forcefieldGate.icon_size              = nil
  forcefieldGate.icon                   = nil
  forcefieldGate.icons                  = LSlib.entity.getIcons("gate", "gate", nil, nil, settings.colorTint)

  forcefieldGate.flags = forcefieldGate.flags or {}
  table.insert(forcefieldGate.flags, "not-repairable")
  table.insert(forcefieldGate.flags, "not-blueprintable")
  table.insert(forcefieldGate.flags, "not-deconstructable")
  table.insert(forcefieldGate.flags, "hidden")
  table.insert(forcefieldGate.flags, "not-upgradable")
  table.insert(forcefieldGate.flags, "no-copy-paste")

  forcefieldGate.placeable_by           = {item = forcefieldGate.name, count = 1}
  forcefieldGate.minable                = {hardness = 0.2, mining_time = 1,
                                           result = (settings.manualPlaceable and forcefieldGate.name or nil),}
  forcefieldGate.mined_sound            = nil
  forcefieldGate.fast_replaceable_group = nil

  forcefieldGate.allow_copy_paste       = false

  forcefieldGate.order                  = string.format("f[forcefields]-b[field]-%s[%s]-b[gate]", settings.order, color)
  forcefieldGate.subgroup               = "forcefield"

  forcefieldGate.max_health             = settings.properties.maxHealth
  forcefieldGate.resistances            = settings.resistances

  if settings.properties["reflectDamage"] and settings.properties["reflectDamage"] > 0 then
    forcefieldGate.attack_reaction = {
      range = settings.properties["reflectRange"],
      action =
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "damage",
              damage = {amount = settings.properties["reflectDamage"], type = "laser"}
            }
          }
        }
      }
    }
  end

  local tint = settings.colorTint   -- add tint to wall
  for _,animationName in pairs{
    "vertical_animation"             ,
    "horizontal_animation"           ,

    "vertical_rail_base"             ,
    --"vertical_rail_base_mask"        ,
    "horizontal_rail_base"           ,
    --"horizontal_rail_base_mask"      ,

    "horizontal_rail_animation_left" ,
    "horizontal_rail_animation_right",
    "vertical_rail_animation_left"   ,
    "vertical_rail_animation_right"  ,
  } do
    local tempPicture             = LSlib.entity.addTintToAnimation(forcefieldGate[animationName], tint)
    forcefieldGate[animationName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
  end
  for _,spriteName in pairs{
    "vertical_rail_base"  ,
    "horizontal_rail_base",
  } do
    local tempPicture          = LSlib.entity.addTintToSprite(forcefieldGate[spriteName], tint)
    forcefieldGate[spriteName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
  end
  for _,sprite4WayName in pairs{
    "wall_patch",
  } do
    local tempPicture              = LSlib.entity.addTintToSprite4Way(forcefieldGate[sprite4WayName], tint)
    forcefieldGate[sprite4WayName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
  end

  data:extend{forcefieldGate}

end
