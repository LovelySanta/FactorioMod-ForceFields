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





--------------------------------------------------------------------------------
-----                          Red forceField                               ----
--------------------------------------------------------------------------------



return prototypeSettings
