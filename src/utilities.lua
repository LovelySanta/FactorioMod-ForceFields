
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
