local settings = require("prototypes/settings")


data:extend{
  {
    type = "sprite",
    name = settings.gui["configWallSprite"],
    filename = settings.modName .. "/graphics/gui/config-tool.png",
    size = 32,
  },
  {
    type = "sprite",
    name = settings.gui["configSetupStraightSprite"],
    filename = settings.modName .. "/graphics/gui/setup-straight.png",
    size = 64,
  },
  {
    type = "sprite",
    name = settings.gui["configSetupCornerSprite"],
    filename = settings.modName .. "/graphics/gui/setup-corner.png",
    size = 64,
  },
  {
    type = "sprite",
    name = settings.gui["configDirectionNESprite"],
    filename = settings.modName .. "/graphics/gui/signal-NE.png",
    size = 32,
  },
  {
    type = "sprite",
    name = settings.gui["configDirectionNWSprite"],
    filename = settings.modName .. "/graphics/gui/signal-NW.png",
    size = 32,
  },
  {
    type = "sprite",
    name = settings.gui["configDirectionSESprite"],
    filename = settings.modName .. "/graphics/gui/signal-SE.png",
    size = 32,
  },
  {
    type = "sprite",
    name = settings.gui["configDirectionSWSprite"],
    filename = settings.modName .. "/graphics/gui/signal-SW.png",
    size = 32,
  },
}