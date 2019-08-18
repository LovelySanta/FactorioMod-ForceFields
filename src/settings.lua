require 'src/utilities'
local prototypeSettings = require('prototypes/settings')

local settings = {}


settings.modName = prototypeSettings.modName



-- gui settings
settings.configWallSprite = prototypeSettings.gui.configWallSprite

settings.guiLabelStyle                     = prototypeSettings.gui.guiLabelStyle
settings.guiSelectButtonStyle              = prototypeSettings.gui.guiSelectButtonStyle
settings.guiSelectButtonSelectedStyle      = prototypeSettings.gui.guiSelectButtonSelectedStyle
settings.guiSmallSelectButtonStyle         = prototypeSettings.gui.guiSmallSelectButtonStyle
settings.guiSmallSelectButtonSelectedStyle = prototypeSettings.gui.guiSmallSelectButtonSelectedStyle
settings.guiTextfieldStyle                 = prototypeSettings.gui.guiTextfieldStyle
settings.guiItemSlotStyle                  = prototypeSettings.gui.guiItemSlotStyle

-- builder settings
settings.forcefieldBuildDamageName = prototypeSettings.forcefieldBuildDamageName
settings.forcefieldDeathDamageName = prototypeSettings.forcefieldBuildDamageName



-- emitter settings
settings.emitterName = "forcefield-emitter"
settings.tickRate = 20

settings.emitterDefaultDistance = 10
settings.maxRangeUpgrades = 23
settings.emitterMaxDistance = settings.emitterDefaultDistance + settings.maxRangeUpgrades

settings.emitterDefaultWidth = 25
settings.maxWidthUpgrades = 10
settings.widthUpgradeMultiplier = 4
settings.emitterMaxWidth = settings.emitterDefaultWidth + (settings.maxWidthUpgrades * settings.widthUpgradeMultiplier)

settings.maxFieldDistance = math.max(settings.emitterMaxDistance, settings.emitterMaxWidth)



-- forcefields settings
settings.fieldSuffix      = string.format(prototypeSettings["blue"].name, "wall", "")
settings.fieldGateSuffix  = string.format(prototypeSettings["blue"].name, "gate", "")
settings.fieldEmptySuffix = string.format(prototypeSettings["blue"].name, "empty", "")
settings.defaultFieldSuffix = settings.fieldSuffix

settings.defaultFieldType = "blue"
settings.defaultFieldDirection = defines.direction.north
settings.forcefieldTypes =
{
  [settings.fieldSuffix .. "blue"  ] = prototypeSettings["blue"  ].properties,
  [settings.fieldSuffix .. "green" ] = prototypeSettings["green" ].properties,
  [settings.fieldSuffix .. "purple"] = prototypeSettings["purple"].properties,
  [settings.fieldSuffix .. "red"   ] = prototypeSettings["red"   ].properties,
}
settings.forcefieldTypes[settings.fieldGateSuffix .. "blue"  ] = settings.forcefieldTypes[settings.fieldSuffix .. "blue"  ]
settings.forcefieldTypes[settings.fieldGateSuffix .. "green" ] = settings.forcefieldTypes[settings.fieldSuffix .. "green" ]
settings.forcefieldTypes[settings.fieldGateSuffix .. "purple"] = settings.forcefieldTypes[settings.fieldSuffix .. "purple"]
settings.forcefieldTypes[settings.fieldGateSuffix .. "red"   ] = settings.forcefieldTypes[settings.fieldSuffix .. "red"   ]

--settings.fieldEmptySetting = 0
--settings.fieldWallSetting = 1
--settings.fieldGateSetting = 2



function settings:verifySettings()
  if self.tickRate < 0 then
    self.tickRate = 0
    throwError("Tick rate must be >= 0.")
  end

  if self.emitterDefaultDistance < 1 then
    self.emitterDefaultDistance = 1
    self.emitterMaxDistance = self.emitterDefaultDistance + self.maxRangeUpgrades
    self.maxFieldDistance = math.max(self.emitterMaxDistance, self.emitterMaxWidth)
    throwError("Emitter default distance must be >= 1.")
  end

  if self.emitterDefaultWidth < 1 then
    self.emitterDefaultWidth = 1
    throwError("Emitter default width must be >= 1.")
    self.emitterMaxWidth = self.emitterDefaultWidth + (self.maxWidthUpgrades * self.widthUpgradeMultiplier)
    self.maxFieldDistance = math.max(self.emitterMaxDistance, self.emitterMaxWidth)
  elseif (math.floor((self.emitterDefaultWidth - 1) / 2) * 2) + 1 ~= self.emitterDefaultWidth then
    self.emitterDefaultWidth = 25
    throwError("Emitter default width must be an odd number (or one).")
    self.emitterMaxWidth = self.emitterDefaultWidth + (self.maxWidthUpgrades * self.widthUpgradeMultiplier)
    self.maxFieldDistance = math.max(self.emitterMaxDistance, self.emitterMaxWidth)
  end

  if not self.forcefieldTypes[self.defaultFieldType .. self.defaultFieldSuffix] then
    self.defaultFieldType = "blue"
    self.defaultFieldSuffix = self.fieldSuffix
    throwError("Emitter default field type isn't known.")
  end
end

return settings
