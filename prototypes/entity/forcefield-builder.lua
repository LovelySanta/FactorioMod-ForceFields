require "__LSlib__/LSlib"


function forceFieldWallEntity(color)

  local settings = require("prototypes/settings")[color]
  local forceFieldWall = util.table.deepcopy(data.raw["wall"]["stone-wall"])

  forceFieldWall.name                   = string.format(settings.name, "wall", color)

  forceFieldWall.icon_size              = nil
  forceFieldWall.icon                   = nil
  forceFieldWall.icons                  = LSlib.entity.getIcons("wall", "stone-wall", nil, nil, settings.colorTint)

  forceFieldWall.flags = forceFieldWall.flags or {}
  table.insert(forceFieldWall.flags, "not-repairable")
  table.insert(forceFieldWall.flags, "not-blueprintable")
  table.insert(forceFieldWall.flags, "not-deconstructable")
  table.insert(forceFieldWall.flags, "hidden")
  table.insert(forceFieldWall.flags, "not-upgradable")
  table.insert(forceFieldWall.flags, "no-copy-paste")
  
  forceFieldWall.placeable_by           = {item = forceFieldWall.name, count = 1}
  forceFieldWall.minable                = {hardness = 0.2, mining_time = 1,
                                           result = (settings.manualPlaceable and forceFieldWall.name or nil),}
  forceFieldWall.mined_sound            = nil
  forceFieldWall.fast_replaceable_group = nil

  forceFieldWall.allow_copy_paste       = false

  forceFieldWall.order                  = string.format("f[forcefields]-b[field]-%s[%s]-a[wall]", settings.order, color)
  forceFieldWall.subgroup               = "forcefield"

  forceFieldWall.max_health             = settings.properties.maxHealth
  forceFieldWall.resistances            = settings.resistances


  local tint = settings.colorTint   -- add tint to wall
  for pictureName,picture in pairs(forceFieldWall.pictures) do
    -- https://wiki.factorio.com/Prototype/Wall#pictures
    if pictureName == "water_connection_patch" or pictureName == "gate_connection_patch" then
      local tempPicture                    = LSlib.entity.addTintToSprite4Way(picture, tint)
      forceFieldWall.pictures[pictureName] = LSlib.entity.removeShadowFromSprite4Way(tempPicture)
    else
      local tempPicture                    = LSlib.entity.addTintToSpriteVariation(picture, tint)
      forceFieldWall.pictures[pictureName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
    end
  end

  data:extend{forceFieldWall}

end



function forceFieldGateEntity(color)

  local settings = require("prototypes/settings")[color]
  local forceFieldGate = util.table.deepcopy(data.raw["gate"]["gate"])

  forceFieldGate.name                   = string.format(settings.name, "gate", color)

  forceFieldGate.icon_size              = nil
  forceFieldGate.icon                   = nil
  forceFieldGate.icons                  = LSlib.entity.getIcons("gate", "gate", nil, nil, settings.colorTint)

  forceFieldGate.flags = forceFieldGate.flags or {}
  table.insert(forceFieldGate.flags, "not-repairable")
  table.insert(forceFieldGate.flags, "not-blueprintable")
  table.insert(forceFieldGate.flags, "not-deconstructable")
  table.insert(forceFieldGate.flags, "hidden")
  table.insert(forceFieldGate.flags, "not-upgradable")
  table.insert(forceFieldGate.flags, "no-copy-paste")

  forceFieldGate.placeable_by           = {item = forceFieldGate.name, count = 1}
  forceFieldGate.minable                = {hardness = 0.2, mining_time = 1,
                                           result = (settings.manualPlaceable and forceFieldGate.name or nil),}
  forceFieldGate.mined_sound            = nil
  forceFieldGate.fast_replaceable_group = nil

  forceFieldGate.allow_copy_paste       = false

  forceFieldGate.order                  = string.format("f[forcefields]-b[field]-%s[%s]-b[gate]", settings.order, color)
  forceFieldGate.subgroup               = "forcefield"

  forceFieldGate.max_health             = settings.properties.maxHealth
  forceFieldGate.resistances            = settings.resistances


    -- color
  local tint = settings.colorTint
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
    local tempPicture             = LSlib.entity.addTintToAnimation(forceFieldGate[animationName], tint)
    forceFieldGate[animationName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
  end
  for _,spriteName in pairs{
    "vertical_rail_base"  ,
    "horizontal_rail_base",
  } do
    local tempPicture          = LSlib.entity.addTintToSprite(forceFieldGate[spriteName], tint)
    forceFieldGate[spriteName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
  end
  for _,sprite4WayName in pairs{
    "wall_patch",
  } do
    local tempPicture              = LSlib.entity.addTintToSprite4Way(forceFieldGate[sprite4WayName], tint)
    forceFieldGate[sprite4WayName] = LSlib.entity.removeShadowsFromSpriteVariation(tempPicture)
  end

  data:extend{forceFieldGate}

end
