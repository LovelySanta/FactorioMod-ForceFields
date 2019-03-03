if not lib then lib = {} end
if not lib.prototypes then lib.prototypes = {} end
if not lib.prototypes.sprites then lib.prototypes.sprites = {} end

--------------------------------------------------------------------------------
-----                         Add tint to sprites                           ----
--------------------------------------------------------------------------------

function lib.prototypes.sprites.addTintToAnimation(animation, tintToAdd)
  -- https://wiki.factorio.com/Types/Animation
  return lib.prototypes.sprites.addTintToSprite(animation, tintToAdd)
end



function lib.prototypes.sprites.addTintToSprite(sprite, tintToAdd)
  -- https://wiki.factorio.com/Types/Sprite

  if sprite.layers then
    -- https://wiki.factorio.com/Types/Sprite#layers
    for layerIndex,layerSprite in pairs(sprite.layers) do
      sprite.layers[layerIndex] = lib.prototypes.sprites.addTintToSprite(layerSprite, tintToAdd)
    end

  else
    if not sprite.draw_as_shadow then
      -- it has no effect, adding a tint to a shadow
      sprite.tint = util.table.deepcopy(tintToAdd)
    end
    if sprite.hr_version and (not sprite.hr_version.draw_as_shadow) then
      sprite.hr_version.tint = util.table.deepcopy(tintToAdd)
    end
  end

  return sprite
end



function lib.prototypes.sprites.addTintToSpriteVariation(spriteVariation, tintToAdd)
  -- https://wiki.factorio.com/Types/SpriteVariations

  if spriteVariation.layers or spriteVariation.filename then
    spriteVariation = lib.prototypes.sprites.addTintToSprite(spriteVariation, tintToAdd)

  else
    for variationIndex, variation in pairs(spriteVariation) do
      spriteVariation[variationIndex] = lib.prototypes.sprites.addTintToSprite(variation, tintToAdd)
    end
  end

  return spriteVariation
end



function lib.prototypes.sprites.addTintToSprite4Way(sprite4Way, tintToAdd)
  -- https://wiki.factorio.com/Types/Sprite4Way

  if sprite4Way.sheet then
    -- https://wiki.factorio.com/Types/Sprite4Way#sheet
    sprite4Way.sheet = lib.prototypes.sprites.addTintToSprite(sprite4Way.sheet, tintToAdd)

  elseif sprite4Way.sheets then
    -- https://wiki.factorio.com/Types/Sprite4Way#sheets
    for sheetIndex,sheet in pairs(sprite4Way.sheets) do
      sprite4Way.sheets[sheetIndex] = lib.prototypes.sprites.addTintToSprite(sheet, tintToAdd)
    end

  elseif not sprite4Way.north then
    -- https://wiki.factorio.com/Types/Sprite4Way#north
    sprite4Way = lib.prototypes.sprites.addTintToSprite(sprite4Way, tintToAdd)

  else
    for direction,sprite in pairs(sprite4Way) do
      sprite4Way[direction] = lib.prototypes.sprites.addTintToSprite(sprite, tintToAdd)
    end
  end

  return sprite4Way
end

--------------------------------------------------------------------------------
-----                 Remove shadows from sprite                            ----
--------------------------------------------------------------------------------



function lib.prototypes.sprites.removeShadowsFromSprite(sprite)
  -- https://wiki.factorio.com/Types/Sprite
  if sprite.layers then
    -- https://wiki.factorio.com/Types/Sprite#layers
    for layerIndex, layerSprite in pairs(sprite.layers) do
      sprite.layers[layerIndex] = lib.prototypes.sprites.removeShadowsFromSprite(layerSprite)
    end

  elseif sprite.draw_as_shadow then
    return nil
  end

  return sprite
end



function lib.prototypes.sprites.removeShadowsFromSpriteVariation(spriteVariation)
  -- https://wiki.factorio.com/Types/SpriteVariations

  if spriteVariation.layers or spriteVariation.filename then
    spriteVariation = lib.prototypes.sprites.removeShadowsFromSprite(spriteVariation)

  else
    for variationIndex, variation in pairs(spriteVariation) do
      spriteVariation[variationIndex] = lib.prototypes.sprites.removeShadowsFromSprite(variation)
    end
  end

  return spriteVariation

end



function lib.prototypes.sprites.removeShadowFromSprite4Way(sprite4Way)
  -- https://wiki.factorio.com/Types/Sprite4Way

  if sprite4Way.sheet then
    -- https://wiki.factorio.com/Types/Sprite4Way#sheet
    sprite4Way.sheet = lib.prototypes.sprites.removeShadowsFromSprite(sprite4Way.sheet)

  elseif sprite4Way.sheets then
    -- https://wiki.factorio.com/Types/Sprite4Way#sheets
    for sheetIndex,sheet in pairs(sprite4Way.sheets) do
      sprite4Way.sheets[sheetIndex] = lib.prototypes.sprites.removeShadowsFromSprite(sheet)
    end

  elseif not sprite4Way.north then
    -- https://wiki.factorio.com/Types/Sprite4Way#north
    sprite4Way = lib.prototypes.sprites.removeShadowsFromSprite(sprite4Way)

  else
    for direction, sprite in pairs(sprite4Way) do
      sprite4Way[direction] = lib.prototypes.sprites.removeShadowsFromSprite(sprite)
    end
  end

  return sprite4Way

end
