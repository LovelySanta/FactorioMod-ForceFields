local prototypeSettings = {}
prototypeSettings["modName"] = "__ForceFields2__"

local prototyping = data and data.raw or false


--------------------------------------------------------------------------------
-----                             Emitter                                   ----
--------------------------------------------------------------------------------

prototypeSettings["emitter"] =
{
  ["emitterName"] = "forcefield-emitter",
  ["tickRate"] = 20,
  ["crafting-category"] = "forcefield-crafter",
}

-- builder settings
prototypeSettings["forcefieldBuildDamageName"   ] = "forcefield-build-damage"

prototypeSettings["forcefieldDeathDamageName"   ] = "forcefield-death-damage"
prototypeSettings["forcefieldDeathDamageAmount" ] = 280
prototypeSettings["forcefieldDeathDamageRange"  ] = 4

--------------------------------------------------------------------------------
-----                               Gui                                     ----
--------------------------------------------------------------------------------

prototypeSettings["gui"] =
{
  ["guiLabelStyle"] = "emitter_label",
  
  ["guiSelectButtonStyle"             ] = "emitter_select_button",
  ["guiSelectButtonSelectedStyle"     ] = "emitter_select_button_selected",
  ["guiSmallSelectButtonStyle"        ] = "emitter_small_select_button",
  ["guiSmallSelectButtonSelectedStyle"] = "emitter_small_select_button_selected",
  
  ["guiTextfieldStyle"] = "short_number_textfield",
  ["guiItemSlotStyle" ] = "emitter_item_slot_button",
  
  ["configWallSprite"] = "forcefield_config_tool",

  ["guiTableRowHeaderStyle"     ] = "forcefield_config_tableRowHeader_table",
  ["guiTableRowHeaderLabelStyle"] = "forcefield_config_tableRowHeader_label",
}


--------------------------------------------------------------------------------
-----                          Blue Forcefield                              ----
--------------------------------------------------------------------------------

prototypeSettings["blue"] =
{
  ["name"]              = "forcefield-%s-%s",
  ["colorTint"]         = { r = 32/255, g = 82/255, b = 188/255, a = 0.80},
  ["order"]             = "a",
  ["resistances"]       = {
    {type = "physical"  , decrease = 3  ,  percent = 20  },
    {type = "impact"    , decrease = 45 ,  percent = 100 },
    {type = "explosion" , decrease = 10 ,  percent = 40  },
    {type = "fire"      , decrease = nil,  percent = 95  },
    {type = "acid"      , decrease = nil,  percent = 80  },
    {type = "laser"     , decrease = nil,  percent = 70  },
  },
  ["properties"]        = {
    --chargeRate = 0.2036111111111111, -- hp/tick
    chargeRate = 0.2083333333333334, -- hp/tick
    degradeRate = 2.777777777777778,
    respawnRate = 15,                -- ticks/tickRate/section
    energyPerCharge = 4200,          -- energy/tick
    energyPerRespawn = 5000,         -- energy/tickRate/section
    energyPerHealthLost = 17000,     -- energy/hp
    damageWhenMined = 20,
    maxHealth = 300,
  },
  ["manualPlaceable"]   = false,
  ["wallTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                         "optics",
                         "stone-walls",
                         "military-2",
                         "advanced-electronics",
                         "battery",
                        },
                        ["additionalEffects"] = {
                          {type = "unlock-recipe", recipe = prototypeSettings["emitter"].emitterName}
                        },
                        ["technologyRecipe"] = {
                          ["count"]       = math.floor( 0.5 + 2.5 * data.raw["technology"]["advanced-electronics"].unit.count),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["advanced-electronics"].unit.ingredients),
                          ["time"]        = 2 * data.raw["technology"]["advanced-electronics"].unit.time,
                        },
    },
  ["gateTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          "gates",
                        },
                        ["additionalEffects"] = {

                        },
                        ["technologyRecipe"] = {
                          ["count"]       = math.floor( 0.5 + 0.5 * (2.5 * data.raw["technology"]["advanced-electronics"].unit.count)),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["advanced-electronics"].unit.ingredients),
                          ["time"]        = 2 * data.raw["technology"]["advanced-electronics"].unit.time,
                        },
    },
}



--------------------------------------------------------------------------------
-----                          Green Forcefield                             ----
--------------------------------------------------------------------------------

prototypeSettings["green"] =
{
  ["name"]              = prototypeSettings["blue"]["name"],
  ["colorTint"]         = { r = 62/255, g = 221/255, b = 88/255, a = prototypeSettings["blue"]["colorTint"].a},
  ["order"]             = "b",
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
  ["wallTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "wall", "blue"),
                          "explosives",
                          "laser",
                        },
                        ["additionalEffects"] = {
                          
                        },
                        ["technologyRecipe"] = {
                          ["count"]       = 2 * prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["count"],
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["flamethrower"].unit.ingredients),
                          ["time"]        = prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
  ["gateTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "gate", "blue"),
                        },
                        ["additionalEffects"] = {

                        },
                        ["technologyRecipe"] = {
                          ["count"]       = math.floor( 0.5 + 0.5 * ( 2 * prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["count"])),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["flamethrower"].unit.ingredients),
                          ["time"]        = prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
}



--------------------------------------------------------------------------------
-----                          Purple Forcefield                            ----
--------------------------------------------------------------------------------

prototypeSettings["purple"] =
{
  ["name"]              = prototypeSettings["blue"]["name"],
  ["colorTint"]         = { r = 89/255, g = 66/255, b = 206/255, a = prototypeSettings["blue"]["colorTint"].a},
  ["order"]             = "c",
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
    deathEntity = prototypeSettings.forcefieldDeathDamageName,
    deathDamage = prototypeSettings.forcefieldDeathDamageAmount,
    deathRange  = prototypeSettings.forcefieldDeathDamageRange,
    maxHealth = 150
  },
  ["manualPlaceable"] = prototypeSettings["blue"]["manualPlaceable"],
  --["upgrade"] = true,
  ["wallTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "wall", "green"),
                          "military-3",
                        },
                        ["additionalEffects"] = {
                          
                        },
                        ["technologyRecipe"] = {
                          ["count"]       = 2 * prototypeSettings["green"]["wallTechnology"]["technologyRecipe"]["count"],
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["military-3"].unit.ingredients),
                          ["time"]        = prototypeSettings["green"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
  ["gateTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "gate", "green"),
                        },
                        ["additionalEffects"] = {

                        },
                        ["technologyRecipe"] = {
                          ["count"]       = math.floor( 0.5 + 0.5 * ( 2 * prototypeSettings["green"]["wallTechnology"]["technologyRecipe"]["count"])),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["military-3"].unit.ingredients),
                          ["time"]        = prototypeSettings["green"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
}



--------------------------------------------------------------------------------
-----                          Red Forcefield                               ----
--------------------------------------------------------------------------------

prototypeSettings["red"] =
{
  ["name"]              = prototypeSettings["blue"]["name"],
  ["colorTint"]         = { r = 219/255, g = 30/255, b = 30/255, a = prototypeSettings["blue"]["colorTint"].a},
  ["order"]             = "d",
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
    reflectDamage = 5,
    reflectRange = 2,
    maxHealth = 300
  },
  ["manualPlaceable"] = prototypeSettings["blue"]["manualPlaceable"],
  --["upgrade"] = true,
  ["wallTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "wall", "purple"),
                          "military-4",
                        },
                        ["additionalEffects"] = {
                          
                        },
                        ["technologyRecipe"] = {
                          ["count"]       = 2 * (prototypeSettings["purple"]["wallTechnology"]["technologyRecipe"]["count"] + prototypeSettings["blue"]["wallTechnology"]["technologyRecipe"]["count"]),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["military-4"].unit.ingredients),
                          ["time"]        = prototypeSettings["purple"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
  ["gateTechnology"] = prototyping and {
                        ["additionalPrerequisites"] = {
                          string.format(prototypeSettings["blue"]["name"], "gate", "purple"),
                        },
                        ["additionalEffects"] = {

                        },
                        ["technologyRecipe"] = {
                          ["count"]       = math.floor( 0.5 + 0.5 * ( 2 * prototypeSettings["purple"]["wallTechnology"]["technologyRecipe"]["count"])),
                          ["ingredients"] = util.table.deepcopy(data.raw["technology"]["military-4"].unit.ingredients),
                          ["time"]        = prototypeSettings["purple"]["wallTechnology"]["technologyRecipe"]["time"],
                        },
  },
}

return prototypeSettings
