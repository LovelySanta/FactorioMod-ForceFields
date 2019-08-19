local forceField = util.table.deepcopy(data.raw["item-subgroup"]["defensive-structure"])

  forceField.name   = "forcefield"
  forceField.order  = forceField.order .. "-a[" .. forceField.name .. "]"

data:extend{forceField}
