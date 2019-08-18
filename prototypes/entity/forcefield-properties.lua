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

fieldProperties.generate_properties = function(self, color, options)
  options = options or {}

  return {"", (not LSlib.utils.table.isEmpty(options)) and "\n" or nil,
    options.respawn                       and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.respawn-rate" }, self.respawn_rate (color)} or nil,
    options.respawn                       and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.respawn-cost" }, self.respawn_cost (color)} or nil,
    options.repair                        and "\n"                                                                                                             or nil,
    options.repair                        and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.repair-rate"  }, self.repair_rate  (color)} or nil,
    options.repair                        and {"tooltip-description.custom-parameter", {"forcefield-parameter-name.repair-cost"  }, self.repair_cost  (color)} or nil,
    options.repair and options.max_health and {"tooltip-description.custom-parameter", {"description.max-health"                 }, self.max_health   (color)} or nil,
  }
end

return fieldProperties