require 'src/utilities'
local prototypeSettings = require('prototypes/settings')

Settings = {}


Settings.modName = "__ForceFields2__"



-- gui settings
Settings.configWallIconName = "forcefield-config-tool"

--Settings.guiSelectButtonStyle = "selectbuttons"
--Settings.guiSelectButtonSelectedStyle = "selectbuttonsselected"
--Settings.guiSmallSelectButtonStyle = "smallselectbuttons"
--Settings.guiSmallSelectButtonSelectedStyle = "smallselectbuttonsselected"
Settings.guiSelectButtonStyle = "button"
Settings.guiSelectButtonSelectedStyle = "button"
Settings.guiSmallSelectButtonStyle = "small_slot_button"
Settings.guiSmallSelectButtonSelectedStyle = "small_slot_button"

-- builder settings
Settings.forcefieldBuildDamageName = "forcefield-build-damage"
Settings.forcefieldDeathDamageName = "forcefield-death-damage"



-- emitter settings
Settings.emitterName = "forcefield-emitter"
Settings.tickRate = 20

Settings.emitterDefaultDistance = 10
Settings.maxRangeUpgrades = 23
Settings.emitterMaxDistance = Settings.emitterDefaultDistance + Settings.maxRangeUpgrades

Settings.emitterDefaultWidth = 25
Settings.maxWidthUpgrades = 10
Settings.widthUpgradeMultiplier = 4
Settings.emitterMaxWidth = Settings.emitterDefaultWidth + (Settings.maxWidthUpgrades * Settings.widthUpgradeMultiplier)

Settings.maxFieldDistance = math.max(Settings.emitterMaxDistance, Settings.emitterMaxWidth)



-- forcefields settings
Settings.fieldSuffix      = string.format(prototypeSettings["blue"].name, "wall", "")
Settings.fieldGateSuffix  = string.format(prototypeSettings["blue"].name, "gate", "")
Settings.fieldEmptySuffix = string.format(prototypeSettings["blue"].name, "empty", "")
Settings.defaultFieldSuffix = Settings.fieldSuffix

Settings.defaultFieldType = "blue"
Settings.defaultFieldDirection = defines.direction.north
Settings.forcefieldTypes =
{
  [Settings.fieldSuffix .. "blue"  ] = prototypeSettings["blue"  ].properties,
  [Settings.fieldSuffix .. "green" ] = prototypeSettings["green" ].properties,
  [Settings.fieldSuffix .. "purple"] = prototypeSettings["purple"].properties,
  [Settings.fieldSuffix .. "red"   ] = prototypeSettings["red"   ].properties,
}
Settings.forcefieldTypes[Settings.fieldGateSuffix .. "blue"  ] = Settings.forcefieldTypes[Settings.fieldSuffix .. "blue"  ]
Settings.forcefieldTypes[Settings.fieldGateSuffix .. "green" ] = Settings.forcefieldTypes[Settings.fieldSuffix .. "green" ]
Settings.forcefieldTypes[Settings.fieldGateSuffix .. "purple"] = Settings.forcefieldTypes[Settings.fieldSuffix .. "purple"]
Settings.forcefieldTypes[Settings.fieldGateSuffix .. "red"   ] = Settings.forcefieldTypes[Settings.fieldSuffix .. "red"   ]

--Settings.fieldEmptySetting = 0
--Settings.fieldWallSetting = 1
--Settings.fieldGateSetting = 2



function Settings:verifySettings()
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
