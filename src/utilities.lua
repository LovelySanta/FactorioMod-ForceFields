
function throwError(what)
    game.print(what)
end



function tableIsEmpty(t)
  return not next(t)
end



function tablesAreEqual(t1, t2)
  if type(t1) ~= 'table' or type(t2) ~= 'table' then
    return t1 == t2
  end
  for k,v in pairs(t1) do
    if not tablesAreEqual(v, t2[k]) then
      return false
    end
  end
  for k,v in pairs(t2) do
    if not tablesAreEqual(v, t1[k]) then
      return false
    end
  end
  return true
end



function directionToString(direction)
  if direction == defines.direction.north then
    return "north"
  end
  if direction == defines.direction.south then
    return "south"
  end
  if direction == defines.direction.east then
    return "east"
  end
  if direction == defines.direction.west then
    return "west"
  end
end



function transferToPlayer(player, dropStack)
  local countInserted = player.insert(dropStack)
  if countInserted < dropStack.count then
    dropOnGround(player.surface, player.position, {name = dropStack.name, count = dropStack.count - countInserted})
  end
end



function takeFromPlayer(player, dropStack)
  local countRemoved = player.remove_item(dropStack)
  return dropStack.count - countRemoved
end



function dropOnGround(surface, position, dropStack, markForDeconstruction, force)
  local dropPos
  local entity
  for n=1,dropStack.count do
    dropPos = surface.find_non_colliding_position("item-on-ground", position, 50, 0.5)
    if dropPos then
      entity = surface.create_entity({name = "item-on-ground", position = dropPos, stack = {name = dropStack.name, count = 1}})
      if entity.valid and markForDeconstruction then
        entity.order_deconstruction(force)
      end
    end
  end
end
