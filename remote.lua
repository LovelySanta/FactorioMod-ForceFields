require '__LSlib__/LSlib'
require 'src/utilities'
local settings = require 'src/settings'

-- execute functions with remote.call("forcefields", "fuction_name")

remote.add_interface("forcefields", {
  -- test gives debug items to the player
  test = function()
    for _,player in pairs(game.players) do
      transferToPlayer(player, {name = "forcefield-emitter", count = 50})
      transferToPlayer(player, {name = "processing-unit", count = 50})
      transferToPlayer(player, {name = "advanced-circuit", count = 50})
    end
  end,


  -- reset removes all entities from the surface and re-init
  reset = function()
    global.forcefields.emitters = nil
    global.forcefields.fields = nil
    global.forcefields.searchDamagedPos = nil
    global.forcefields.activeEmitters = nil
    global.forcefields.degradingFields = nil
    global.forcefields.ticking = nil
    global.forcefields.emitterConfigGUIs = nil
    script.on_event(defines.events.on_tick, nil)

    for k,surface in pairs(game.surfaces) do
      local minx = 0
      local miny = 0
      local maxx = 0
      local maxy = 0
      for coord in surface.get_chunks() do
        if coord.x < minx then
          minx = coord.x
        end
        if coord.x > maxx then
          maxx = coord.x
        end
        if coord.y < miny then
          miny = coord.y
        end
        if coord.y > maxy then
          maxy = coord.y
        end
      end
      minx = minx * 32
      maxx = maxx * 32
      miny = miny * 32
      maxy = maxy * 32

      for name,_ in pairs(settings.forcefieldTypes) do
        for _,v in pairs(surface.find_entities_filtered({area = {{minx, miny}, {maxx, maxy}}, name = name})) do
          v.destroy()
        end
      end
      for _,v in pairs(surface.find_entities_filtered({area = {{minx, miny}, {maxx, maxy}}, name = settings.emitterName})) do
        v.destroy()
      end
    end
    for _,player in pairs(game.players) do
      if player.gui.center.emitterConfig ~= nil then
        player.gui.center.emitterConfig.destroy()
      end
    end
  end,


  -- test circle logic
  circle = function(radius)
    -- reset area
    local resetRange = 50
    local tilesToReset = {}
    for x = -resetRange, resetRange do
      for y = -resetRange, resetRange do
        tilesToReset[#tilesToReset + 1] = {
          name = "grass-1",
          position = {x = x, y = y},
        }
      end
    end
    game.surfaces["nauvis"].set_tiles(tilesToReset, true)

    -- draw circle
    tilesToReset = {}
    local circle = LSlib.utils.shapes.getCircleContour({x = 0, y = 0}, radius)
    for _,circlePos in pairs(circle) do
      tilesToReset[#tilesToReset + 1] = {
        name = "concrete",
        position = circlePos,
      }
    end
    game.surfaces["nauvis"].set_tiles(tilesToReset, false)
  end,

})
