require 'prototypes/entity/forcefield-builder'
require 'prototypes/technology/forcefield-builder'

function addForceField(color)
  forceFieldWallEntity(color)
  forceFieldWallTech(color)
  forceFieldGateEntity(color)
  forceFieldGateTech(color)

end

addForceField("blue")
addForceField("green")
addForceField("purple")
addForceField("red")
