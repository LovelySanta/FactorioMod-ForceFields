if not lib then lib = {} end
if not lib.prototypes then lib.prototypes = {} end
if not lib.prototypes.icons then lib.prototypes.icons = {} end

function lib.prototypes.icons.getIcons(prototypeType, prototypeName, layerScale, layerShift, layerTint)
  local prototypeIcon = data.raw[prototypeType][prototypeName].icon

  if prototypeIcon then
    return { -- icons table
      { -- single layer
        ["icon"     ] = prototypeIcon,
        ["icon_size"] = data.raw[prototypeType][prototypeName].icon_size,
        ["tint"     ] = layerTint,
        ["scale"    ] = layerScale,
        ["shift"    ] = layerShift,
      }
    }
  else

    local prototypeIconSize = data.raw[prototypeType][prototypeName].icon_size

    local prototypeIcons = {}
    for iconLayerIndex, iconLayer in pairs(data.raw[prototypeType][prototypeName].icons) do
      prototypeIcons[iconLayerIndex] = {
        ["icon"     ] = iconLayer.icon,
        ["icon_size"] = iconLayer.icon_size or prototypeIconSize, -- prototypeIconSize if not icon_size specified in layer
        ["tint"     ] = {
          r = (iconLayer.tint.r or iconLayer.tint[1] or 1) * (layerTint.r or layerTint[1] or 1),
          g = (iconLayer.tint.g or iconLayer.tint[2] or 1) * (layerTint.g or layerTint[2] or 1),
          b = (iconLayer.tint.b or iconLayer.tint[3] or 1) * (layerTint.b or layerTint[3] or 1),
          a = (iconLayer.tint.a or iconLayer.tint[4] or 1) * (layerTint.a or layerTint[4] or 1),
        },
        ["scale"    ] = (iconLayer.scale or 1) * layerScale, -- 1            if not scale     specified in layer
        ["shift"    ] = {
          (iconLayer.shift or {0, 0})[1] * layerShift[1],    -- {0,0}        if not shift     specified in layer
          (iconLayer.shift or {0, 0})[2] * layerShift[2],
        },
      }
    end
    return prototypeIcons

  end
end
