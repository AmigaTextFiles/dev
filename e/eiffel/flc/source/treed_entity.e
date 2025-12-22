
OPT MODULE
OPT EXPORT

MODULE '*entity','*class'

-> Eiffel entities that are stored in a tree
OBJECT treed_entity OF entity
  left:PTR TO treed_entity
  right:PTR TO treed_entity
  int:LONG
ENDOBJECT

-> Folds proc through the tree.
PROC traverse(proc) OF treed_entity
  proc(self)
  IF self.left THEN self.left.traverse(proc)
  IF self.right THEN self.right.traverse(proc)
ENDPROC

-> Destructor
PROC end() OF treed_entity
  DisposeLink(self.name)
ENDPROC

