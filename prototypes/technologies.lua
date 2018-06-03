require 'util'
require 'src/settings'
require 'prototypes/defines/forcefield-tech-effect'



-- WALLS
local blueWall =
 {
  type = "technology",
  name = "force-fields",
  icon = Settings.modName .. "/graphics/walls/blue/wall-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "optics",
    "stone-walls",
    "military-2",
    "advanced-electronics",
    "battery",
  },
  effects =
  {
    {
      type = "unlock-recipe",
      recipe = Settings.emitterName
    },
    createTechWallEffect("blue")
  },
  unit =
  {
    count = math.floor(.5 + 2.5 * util.table.deepcopy(data.raw["technology"]["advanced-electronics"].unit.count)),
    ingredients = util.table.deepcopy(data.raw["technology"]["advanced-electronics"].unit.ingredients),
    time = util.table.deepcopy(data.raw["technology"]["battery"].unit.time),

  },
  order = "f-f-" .. "e",
}

local greenWall =
{
  type = "technology",
  name = "green-fields",
  icon = Settings.modName .. "/graphics/walls/green/wall-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "force-fields",
    "laser",
    "explosives",
  },
  effects =
  {
    createTechWallEffect("green")
  },
  unit =
  {
    count = 2 * util.table.deepcopy(blueWall.unit.count),
    ingredients = util.table.deepcopy(data.raw["technology"]["explosives"].unit.ingredients),
    time = util.table.deepcopy(blueWall.unit.time),
  },
  order = blueWall.order,
}

local purpleWall =
{
  type = "technology",
  name = "purple-fields",
  icon = Settings.modName .. "/graphics/walls/purple/wall-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "green-fields",
    "military-3"
  },
  effects =
  {
    createTechWallEffect("purple")
  },
  unit =
  {
    count = 2 * util.table.deepcopy(greenWall.unit.count),
    ingredients = util.table.deepcopy(data.raw["technology"]["military-3"].unit.ingredients),
    time = util.table.deepcopy(greenWall.unit.time),
  },
  upgrade = true,
  order = greenWall.order,
}

local redWall =
{
  type = "technology",
  name = "red-fields",
  icon = Settings.modName .. "/graphics/walls/red/wall-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "purple-fields",
    "military-4"
  },
  effects =
  {
    createTechWallEffect("red")
  },
  unit =
  {
    count = 2 * util.table.deepcopy(purpleWall.unit.count + blueWall.unit.count),
    ingredients = util.table.deepcopy(data.raw["technology"]["military-3"].unit.ingredients),
    time = util.table.deepcopy(purpleWall.unit.time),
  },
  upgrade = true,
  order = purpleWall.order,
}



-- GATE
local blueGate =
{
  type = "technology",
  name = "force-field-gates",
  icon = Settings.modName .. "/graphics/gates/blue/gate-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "gates",
    "force-fields"
  },
  effects =
  {
    createTechGateEffect("blue")
  },
  unit =
  {
    count = math.floor(.5 + .5 * util.table.deepcopy(blueWall.unit.count)),
    ingredients = util.table.deepcopy(blueWall.unit.ingredients),
    time = util.table.deepcopy(blueWall.unit.time),
  },
  upgrade = true,
  order = blueWall.order:sub(0, -1) .. "f",
}

local greenGate =
{
  type = "technology",
  name = "green-field-gates",
  icon = Settings.modName .. "/graphics/gates/green/gate-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "gates",
    "green-fields"
  },
  effects =
  {
    createTechGateEffect("green")
  },
  unit =
  {
    count = math.floor(.5 + .5 * util.table.deepcopy(greenWall.unit.count)),
    ingredients = util.table.deepcopy(greenWall.unit.ingredients),
    time = util.table.deepcopy(greenWall.unit.time),
  },
  upgrade = true,
  order = blueGate.order,
}

local purpleGate =
{
  type = "technology",
  name = "purple-field-gates",
  icon = Settings.modName .. "/graphics/gates/purple/gate-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "gates",
    "purple-fields"
  },
  effects =
  {
    createTechGateEffect("purple")
  },
  unit =
  {
    count = math.floor(.5 + .5 * util.table.deepcopy(purpleWall.unit.count)),
    ingredients = util.table.deepcopy(purpleWall.unit.ingredients),
    time = util.table.deepcopy(purpleWall.unit.time),
  },
  upgrade = true,
  order = greenGate.order,
}

local redGate =
{
  type = "technology",
  name = "red-field-gates",
  icon = Settings.modName .. "/graphics/gates/red/gate-technology.png",
  icon_size = 128,
  prerequisites =
  {
    "gates",
    "red-fields"
  },
  effects =
  {
    createTechGateEffect("red")
  },
  unit =
  {
    count = math.floor(.5 + .5 * util.table.deepcopy(redWall.unit.count)),
    ingredients = util.table.deepcopy(redWall.unit.ingredients),
    time = util.table.deepcopy(redWall.unit.time),
  },
  upgrade = true,
  order = purpleGate.order
}



data:extend({
  -- walls
  blueWall,
  greenWall,
  purpleWall,
  redWall,

  -- gates
  blueGate,
  greenGate,
  purpleGate,
  redGate,
})
