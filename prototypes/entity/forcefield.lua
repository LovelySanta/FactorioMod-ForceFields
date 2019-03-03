require 'prototypes/entity/forcefield-builder'
require 'prototypes/technology/forcefield-builder'

function addForceField(color)
  forceFieldWallEntity(color)
  forceFieldWallTech(color)
  --forceFieldGateEntity(color)

end

addForceField("blue")
