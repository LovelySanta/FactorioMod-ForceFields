local settings = require("prototypes/settings")

data:extend{
  {
    type = "smoke-with-trigger",
    name = settings.forcefieldBuildDamageName,
    flags = {"not-on-map", "placeable-off-grid"},
    show_when_smoke_off = false,
    animation =
    {
      filename = settings.modName .. "/graphics/null.png",
      priority = "low",
      width = 32,
      height = 32,
      frame_count = 1,
      width = 32,
      height = 32,
      animation_speed = 1,
      line_length = 1,
      scale = 1,
    },
    slow_down_factor = 0,
    wind_speed_factor = 0,
    cyclic = true,
    duration = 2,
    fade_away_duration =  1,
    spread_duration = 1,
    color = { r = 0, g = 0, b = 0, a = 1 },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = 1,
            entity_flags = {"breaths-air"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = {amount = 20, type = "poison"}
              }
            }
          }
        }
      }
    },
    action_cooldown = 60
  },

  {
    type = "smoke-with-trigger",
    name = settings.forcefieldDeathDamageName,
    flags = {"not-on-map", "placeable-off-grid"},
    show_when_smoke_off = false,
    animation =
    {
      filename = settings.modName .. "/graphics/null.png",
      priority = "low",
      width = 32,
      height = 32,
      frame_count = 1,
      animation_speed = 1,
      line_length = 1,
      scale = 1,
    },
    slow_down_factor = 0,
    wind_speed_factor = 0,
    cyclic = true,
    duration = 2,
    fade_away_duration =  1,
    spread_duration = 1,
    color = { r = 0, g = 0, b = 0, a = 1 },
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "nested-result",
          action =
          {
            type = "area",
            radius = settings.forcefieldDeathDamageRange,
            entity_flags = {"breaths-air"},
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                type = "damage",
                damage = {amount = settings.forcefieldDeathDamageAmount, type = "poison"}
              }
            }
          }
        }
      }
    },
    action_cooldown = 60
  },
}