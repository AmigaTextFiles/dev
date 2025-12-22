
-> Copyright © 1995, Guichard Damien.

-> Trees of Eiffel entities are used whenever possible

OPT MODULE
OPT EXPORT

MODULE '*treed_entity'
MODULE '*strings'

-> Tree of Eiffel entities
OBJECT entity_tree
  cells:PTR TO treed_entity
ENDOBJECT

-> Add an entity to the tree
PROC add(e:PTR TO treed_entity) OF entity_tree
  DEF parent:PTR TO treed_entity,cell:PTR TO treed_entity
  cell:=self.cells
  IF cell=NIL
    self.cells:=e
    RETURN
  ENDIF
  WHILE cell
    parent:=cell
    cell:=IF e.int<cell.int THEN cell.left ELSE cell.right
  ENDWHILE
  IF e.int<parent.int
    parent.left:=e
  ELSE
    parent.right:=e
  ENDIF
ENDPROC

-> Find an entity in the tree
PROC find(name:PTR TO CHAR) OF entity_tree
  DEF value:LONG,cell:PTR TO treed_entity
  value:=hash(name)
  cell:=self.cells
  LOOP
    IF cell=NIL THEN RETURN NIL
    IF cell.int=value THEN
      IF StrCmp(name,cell.name,ALL) THEN RETURN cell
    cell:=IF value<cell.int THEN cell.left ELSE cell.right
  ENDLOOP
ENDPROC

-> Continuation
PROC continu(c:PTR TO treed_entity,name) OF entity_tree
  DEF value:LONG,cell:PTR TO treed_entity
  IF c=NIL THEN RETURN NIL
  value:=hash(name)
  cell:=c.right
  LOOP
    IF cell=NIL THEN RETURN NIL
    IF cell.int=value THEN
      IF StrCmp(name,cell.name,ALL) THEN RETURN cell
    cell:=IF value<cell.int THEN cell.left ELSE cell.right
  ENDLOOP
ENDPROC

-> Wipe out.
PROC wipe_out() OF entity_tree
  self.cells:=NIL
ENDPROC

