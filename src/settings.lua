require 'src/utilities'
require "__LSlib__/LSlib"
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
settings.emitterName = prototypeSettings["emitter"]["emitterName"]
settings.tickRate = prototypeSettings["emitter"]["tickRate"]

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
settings.defaultFieldSetup = "straight" -- options: "straight", "corner"
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

local function createFieldCircleData()
  -- STEP 1: get the circles
  local circles = {}
  for radius = 1, settings.emitterMaxDistance do
    circles[radius] = LSlib.utils.shapes.getCircleContour({0, 0}, radius)
  end

  -- STEP 2: split the circles into segments
  local circleSegments = {}
  for radius,circleContour in pairs(circles) do
    circleSegments[radius] = {}
    local numberOfPoints = #circleContour
    for index,direction in pairs{
      -- iterating in CCW starting from x-axis
      defines.direction.south, -- SE
      defines.direction.west , -- SW
      defines.direction.north, -- NW
      defines.direction.east , -- NE
    } do
      circleSegments[radius][direction] = {}

      local startPoint = 1 + ((index - 1) * numberOfPoints/4)
      local pointsToAdd = numberOfPoints/4 + 1
      for pointIndex = 1, pointsToAdd do
        local contourIndex = startPoint + (pointIndex - 1)
        contourIndex = contourIndex <= numberOfPoints and contourIndex or contourIndex - numberOfPoints
        circleSegments[radius][direction][pointIndex] = util.table.deepcopy(circleContour[contourIndex])
      end
    end
  end

  -- STEP 3: create incremental data for these circles
  local fieldCircleData = {}
  for radius, circleSegment in pairs(circleSegments) do
    fieldCircleData[radius] = {}
    for direction, circleSegmentContour in pairs(circleSegment) do
      local prevPos = circleSegmentContour[1] -- start point

      fieldCircleData[radius][direction] = {
        pos = util.table.deepcopy(prevPos),
        xInc = {},
        yInc = {},
        incTimes = 1,
      }

      for contourIndex = 2, #circleSegmentContour do
        fieldCircleData[radius][direction].xInc[contourIndex - 1] = circleSegmentContour[contourIndex].x - prevPos.x
        fieldCircleData[radius][direction].yInc[contourIndex - 1] = circleSegmentContour[contourIndex].y - prevPos.y
        fieldCircleData[radius][direction].incTimes = fieldCircleData[radius][direction].incTimes + 1
        prevPos = circleSegmentContour[contourIndex]
      end
    end
  end

  return util.table.deepcopy(fieldCircleData)
end
settings.forcefieldCircleData = createFieldCircleData()

--settings.fieldEmptySetting = 0
--settings.fieldWallSetting = 1
--settings.fieldGateSetting = 2



function settings:verifyRemoteSettings()
  local modName = string.sub(settings.modName, 3, -3)

  if game.active_mods["warptorio2"] then
    LSlib.utils.log.log("Verify remote settings for warptorio2")

    local interfaceName = "warptorio2"
    if remote.interfaces[interfaceName] then
      for fieldName,_ in pairs(self.forcefieldTypes) do
        if not remote.call(interfaceName, "is_warp_blacklisted", modName, fieldName) then
          remote.call(interfaceName, "insert_warp_blacklist", modName, fieldName)
        end
      end
    end
  end
end



function settings:verifySettings()
  local loggingDisabled = not LSlib.utils.log.isEnabled()
  if loggingDisabled then LSlib.utils.log.enable() end
  LSlib.utils.log.log(("Verify mod settings for %s"):format(string.sub(settings.modName, 3, -3)))

  if self.tickRate < 0 then
    self.tickRate = 0
    LSlib.utils.log.log("Tick rate must be >= 0.")
  end

  if self.emitterDefaultDistance < 1 then
    self.emitterDefaultDistance = 1
    self.emitterMaxDistance = self.emitterDefaultDistance + self.maxRangeUpgrades
    self.maxFieldDistance = math.max(self.emitterMaxDistance, self.emitterMaxWidth)
    LSlib.utils.log.log("Emitter default distance must be >= 1.")
  end

  if self.emitterDefaultWidth < 1 then
    self.emitterDefaultWidth = 1
    LSlib.utils.log.log("Emitter default width must be >= 1.")
    self.emitterMaxWidth = self.emitterDefaultWidth + (self.maxWidthUpgrades * self.widthUpgradeMultiplier)
    self.maxFieldDistance = math.max(self.emitterMaxDistance, self.emitterMaxWidth)
  elseif (math.floor((self.emitterDefaultWidth - 1) / 2) * 2) + 1 ~= self.emitterDefaultWidth then
    self.emitterDefaultWidth = 25
    LSlib.utils.log.log("Emitter default width must be an odd number (or one).")
    self.emitterMaxWidth = self.emitterDefaultWidth + (self.maxWidthUpgrades * self.widthUpgradeMultiplier)
    self.maxFieldDistance = math.max(self.emitterMaxDistance, self.emitterMaxWidth)
  end

  if not self.forcefieldTypes[self.defaultFieldSuffix .. self.defaultFieldType] then
    self.defaultFieldType = "blue"
    self.defaultFieldSuffix = self.fieldSuffix
    LSlib.utils.log.log("Emitter default field type isn't known.")
  end

  self:verifyRemoteSettings()
  if loggingDisabled then LSlib.utils.log.disable() end
end

return settings
