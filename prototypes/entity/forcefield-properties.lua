-- Functions to generate the properties of the forcefields
-- this is used to display the properties in the localised
-- description of the fields. These are purly cosmetic and
-- have no other purpose than giving basic information.
local settings = require("prototypes/settings")

local fieldProperties = {}

fieldProperties.respawn_rate = function(color)
  local ticksToRespawn = settings["emitter"]["tickRate"] * settings[color]["properties"]["respawnRate"]
  return {"time-symbol-seconds", string.format("%.2f", ticksToRespawn/60)}
end

fieldProperties.respawn_cost = function(color)
  local costPerWall = settings["emitter"]["tickRate"] * settings[color]["properties"]["energyPerRespawn"]
  local healthPerTick = settings[color]["properties"]["chargeRate"]
  local energyPerTick = settings[color]["properties"]["energyPerCharge"]
  return {"",
    LSlib.utils.units.getLocalisedUnit(costPerWall, {"si-unit-symbol-joule"}),
    " + ",
    LSlib.utils.units.getLocalisedUnit(energyPerTick/healthPerTick, {"", {"si-unit-symbol-joule"}, "/", {"forcefield-parameter-unit.health"}}),
  }
end

fieldProperties.repair_rate = function(color)
  local healthPerTick = settings[color]["properties"]["chargeRate"]
  return {"", string.format("%.2f ", healthPerTick*60), {"forcefield-parameter-unit.health"}, {"per-second-suffix"}}
end

fieldProperties.repair_cost = function(color)
  local energyPerHealth = settings[color]["properties"]["energyPerHealthLost"]
  return LSlib.utils.units.getLocalisedUnit(energyPerHealth, {"", {"si-unit-symbol-joule"}, "/", {"forcefield-parameter-unit.health"}})
end

fieldProperties.max_health = function(color)
  local maxHealth = settings[color]["properties"]["maxHealth"]
  return {"", string.format("%i", maxHealth)}
end

fieldProperties.has_damage_reflect = function(color)
  local damageReflect = settings[color]["properties"]["reflectDamage"] or 0
  return damageReflect > 0 and damageReflect or false
end

fieldProperties.damage_reflect_amount = function(color)
  local damageReflect = fieldProperties.has_damage_reflect(color)
  return damageReflect and {"", string.format("%i ", damageReflect), {"damage-type-name.laser"}} or ""
end

fieldProperties.damage_reflect_range = function(color)
  local damageRange = fieldProperties.has_damage_reflect(color) and settings[color]["properties"]["reflectRange"]
  return damageRange and {"", string.format("%i ", damageRange)} or ""
end

fieldProperties.has_damage_death = function(color)
  local damageDeath = settings[color]["properties"]["deathDamage"] or 0
  return damageDeath > 0 and damageDeath or false
end

fieldProperties.damage_death_amount = function(color)
  local damageDeath = fieldProperties.has_damage_death(color)
  return damageDeath and {"", string.format("%i ", damageDeath), {"damage-type-name.poison"}} or ""
end

fieldProperties.damage_death_range = function(color)
  local damageRange = fieldProperties.has_damage_death(color) and settings[color]["properties"]["deathRange"]
  return damageRange and {"", string.format("%i", damageRange)} or ""
end

fieldProperties.generate_properties = function(self, color, options)
  -- options: + damage : show damage statistics
  --          + respawn: show respawn statistics
  --          + repair : show repair statistics
  options = options or {}

  options.damage_reflect = options.damage and self.has_damage_reflect(color) and true or false
  options.damage_death   = options.damage and self.has_damage_death  (color) and true or false
  options.damage         = options.damage_reflect or options.damage_death
  options.max_health     = options.repair and options.max_health

  return {"",
    options.damage_reflect and {"", " ", {"forcefield-parameter-description.reflect-damage"}}                                                            or "",
    options.damage_death   and {"", " ", {"forcefield-parameter-description.death-damage"  }}                                                            or "",
    options.damage_reflect and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.reflect-range" }, self.damage_reflect_range (color)} or "",
    options.damage_reflect and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.reflect-damage"}, self.damage_reflect_amount(color)} or "",
    options.damage_death   and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.death-range"   }, self.damage_death_range   (color)} or "",
    options.damage_death   and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.death-damage"  }, self.damage_death_amount  (color)} or "",
    options.respawn        and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.respawn-rate"  }, self.respawn_rate         (color)} or "",
    options.respawn        and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.respawn-cost"  }, self.respawn_cost         (color)} or "",
    options.repair         and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.repair-cost"   }, self.repair_cost          (color)} or "",
    options.repair         and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.repair-rate"   }, self.repair_rate          (color)} or "",
    options.max_health     and {"tooltip-description.custom-parameter", {"description.max-health"                  }, self.max_health           (color)} or "",
  }
end

return fieldProperties