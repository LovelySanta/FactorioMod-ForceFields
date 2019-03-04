local prototypeSettings = {}
prototypeSettings["modName"] = "__ForceFields2__"


--------------------------------------------------------------------------------
-----                             Emitter                                   ----
--------------------------------------------------------------------------------

prototypeSettings["emitter"] =
{
  ["emitterName"] = "forcefield-emitter",
  ["tickRate"] = 20,
  ["crafting-category"] = "forcefield-crafter",
}


--------------------------------------------------------------------------------
-----                          Blue forceField                              ----
--------------------------------------------------------------------------------

prototypeSettings["blue"] =
{
  ["name"]              = "forcefield-%s-%s",
  ["colorTint"]         = { r = 0, g = 0, b = 1, a = 0.5},
  ["resistances"]       = {
    {type = "physical"  , decrease = 3  ,  percent = 20  },
    {type = "impact"    , decrease = 45 ,  percent = 100 },
    {type = "explosion" , decrease = 10 ,  percent = 40  },
    {type = "fire"      , decrease = nil,  percent = 95  },
    {type = "acid"      , decrease = nil,  percent = 80  },
    {type = "laser"     , decrease = nil,  percent = 70  },
  },
  ["properties"]        = {
    chargeRate = 0.2036111111111111,
    degradeRate = 2.777777777777778,
    respawnRate = 15,
    energyPerCharge = 4200,
    energyPerRespawn = 5000,
    energyPerHealthLost = 17000,
    damageWhenMined = 20,
    maxHealth = 300,
  },
  ["manualPlaceable"]   = true,
  ["wallTechnology"] = {["additionalPrerequisites"] = {
                         "optics",
                         "stone-walls",
                         "military-2",
                         "advanced-electronics",
                         "battery",
                        },
                        ["additionalEffects"] = {{type = "unlock-recipe", recipe = prototypeSettings["emitter"].emitterName}},
                        ["technologyRecipe"] = {
                          ["count"]       = math.floor(.5 + 2.5 * data.raw["technology"]["advanced-electronics"].unit.count),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["advanced-electronics"].unit.ingredients),
                          ["time"]        = 2 * data.raw["technology"]["advanced-electronics"].unit.time,
                        },
    },
  ["gateTechnology"] = {["additionalPrerequisites"] = {
                          "gates",
                        },
                        ["additionalEffects"] = {

                        },
    },
}



--------------------------------------------------------------------------------
-----                          Green forceField                             ----
--------------------------------------------------------------------------------

prototypeSettings["green"] =
{
  ["name"]              = prototypeSettings["blue"]["name"],
  ["colorTint"]         = { r = 0, g = 1, b = 0, a = prototypeSettings["blue"]["colorTint"].a},
  ["resistances"]       = {
    {type = "physical"  , decrease = 3  ,  percent = 20  },
    {type = "impact"    , decrease = 45 ,  percent = 100 },
    {type = "explosion" , decrease = 10 ,  percent = 40  },
    {type = "fire"      , decrease = nil,  percent = 95  },
    {type = "acid"      , decrease = nil,  percent = 80  },
    {type = "laser"     , decrease = nil,  percent = 70  },
  },
  ["properties"]        = {
    chargeRate = 0.175,
    degradeRate = 2,
    respawnRate = 50,
    energyPerCharge = 4000,
    energyPerRespawn = 20000,
    energyPerHealthLost = 16000,
    damageWhenMined = 30,
    maxHealth = 700,
  },
  ["manualPlaceable"] = prototypeSettings["blue"]["manualPlaceable"],
  ["wallTechnology"] = {["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "wall", "blue"),
                          "explosives",
                          "laser",
                        },
                        ["additionalEffects"] = {},
                        ["technologyRecipe"] = {
                          ["count"]       = 2 * prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["count"],
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["explosives"].unit.ingredients),
                          ["time"]        = prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
  ["gateTechnology"] = {["additionalPrerequisites"] = {

                        },
                        ["additionalEffects"] = {

                        },
  },
}



--------------------------------------------------------------------------------
-----                          Purple forceField                            ----
--------------------------------------------------------------------------------

prototypeSettings["purple"] =
{
  ["name"]              = prototypeSettings["blue"]["name"],
  ["colorTint"]         = { r = 1, g = 0, b = 1, a = prototypeSettings["blue"]["colorTint"].a},
  ["resistances"]       = {
    {type = "physical"  , decrease = 3  ,  percent = 20  },
    {type = "impact"    , decrease = 45 ,  percent = 100 },
    {type = "explosion" , decrease = 10 ,  percent = 40  },
    {type = "fire"      , decrease = nil,  percent = 95  },
    {type = "acid"      , decrease = nil,  percent = 80  },
    {type = "laser"     , decrease = nil,  percent = 70  },
  },
  ["properties"]        = {
    chargeRate = 0.2083333333333334,
    degradeRate = 3.333333333333333,
    respawnRate = 100,
    energyPerCharge = 7000,
    energyPerRespawn = 10000,
    energyPerHealthLost = 25000,
    damageWhenMined = 15,
    --deathEntity = Settings.forcefieldDeathDamageName,
    maxHealth = 150
  },
  ["manualPlaceable"] = prototypeSettings["blue"]["manualPlaceable"],
  --["upgrade"] = true,
  ["wallTechnology"] = {["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "wall", "green"),
                          "military-3",
                        },
                        ["additionalEffects"] = {},
                        ["technologyRecipe"] = {
                          ["count"]       = 2 * prototypeSettings["green"]["wallTechnology"]["technologyRecipe"]["count"],
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["military-3"].unit.ingredients),
                          ["time"]        = prototypeSettings["green"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
  ["gateTechnology"] = {["additionalPrerequisites"] = {

                        },
                        ["additionalEffects"] = {

                        },
  },
}



--------------------------------------------------------------------------------
-----                          Red forceField                               ----
--------------------------------------------------------------------------------

prototypeSettings["red"] =
{
  ["name"]              = prototypeSettings["blue"]["name"],
  ["colorTint"]         = { r = 1, g = 0, b = 0, a = prototypeSettings["blue"]["colorTint"].a},
  ["resistances"]       = {
    {type = "physical"  , decrease = 3  ,  percent = 20  },
    {type = "impact"    , decrease = 45 ,  percent = 100 },
    {type = "explosion" , decrease = 10 ,  percent = 40  },
    {type = "fire"      , decrease = nil,  percent = 95  },
    {type = "acid"      , decrease = nil,  percent = 80  },
    {type = "laser"     , decrease = nil,  percent = 70  },
  },
  ["properties"]        = {
    chargeRate = 0.175,
    degradeRate = 4.333333333333333,
    respawnRate = 30,
    energyPerCharge = 10000,
    energyPerRespawn = 50000,
    energyPerHealthLost = 40000,
    damageWhenMined = 99,
    maxHealth = 300
  },
  ["manualPlaceable"] = prototypeSettings["blue"]["manualPlaceable"],
  --["upgrade"] = true,
  ["wallTechnology"] = {["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "wall", "purple"),
                          "military-4",
                        },
                        ["additionalEffects"] = {},
                        ["technologyRecipe"] = {
                          ["count"]       = 2 * (prototypeSettings["purple"]["wallTechnology"]["technologyRecipe"]["count"] + prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["count"]),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["military-3"].unit.ingredients),
                          ["time"]        = prototypeSettings["purple"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
  ["gateTechnology"] = {["additionalPrerequisites"] = {

                        },
                        ["additionalEffects"] = {

                        },
  },
}

return prototypeSettings
