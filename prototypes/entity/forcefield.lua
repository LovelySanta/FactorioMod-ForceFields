require 'prototypes/entity/forcefield-builder'
require 'prototypes/technology/forcefield-builder'

function addForcefield(color)
  forcefieldWallEntity(color)
  forcefieldWallTech(color)
  forcefieldGateEntity(color)
  forcefieldGateTech(color)
end

addForcefield("blue")
addForcefield("green")
addForcefield("purple")
addForcefield("red")
