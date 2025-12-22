
-> sortedTree is an efficient data structure for comparable objects.
-> Time complexity for data adding is O(log n).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT
OPT NOWARN

MODULE 'fw/comparable'

OBJECT sortedTree OF comparable
  left:PTR TO sortedTree
  right:PTR TO sortedTree
ENDOBJECT

-> Count nodes.
PROC nodes() OF sortedTree
  DEF tot=1
  IF self.left  THEN tot:=tot+self.left.nodes()
  IF self.right THEN tot:=tot+self.right.nodes()
ENDPROC tot

-> Count leaves.
PROC leaves() OF sortedTree
  DEF tot=0
  IF self.left THEN tot:=tot+self.left.leaves()
  IF self.right
    tot:=tot+self.right.leaves()
  ELSEIF self.left=NIL  -> Both NIL, so a leaf
    tot++
  ENDIF
ENDPROC tot

-> Add an element to the tree.
PROC add(e:PTR TO sortedTree) OF sortedTree
  DEF parent:PTR TO sortedTree
  WHILE self
    parent:=self
    self:=IF e.isLessThan(self) THEN self.left ELSE self.right
  ENDWHILE
  IF e.isLessThan(parent)
    parent.left:=e
  ELSE
    parent.right:=e
  ENDIF
ENDPROC

-> Print the tree in infix order.
PROC printNodes() OF sortedTree
  IF self.left  THEN self.left.printNodes()
  self.out()
  IF self.right THEN self.right.printNodes()
ENDPROC

-> Print tree leaves from left to right.
PROC printLeaves() OF sortedTree
  IF self.left THEN self.left.printLeaves()
  IF self.right
    self.right.printLeaves()
  ELSEIF self.left=NIL  -> Both NIL, so a leaf
    self.out()
  ENDIF
ENDPROC

-> Tree performance expressed in percentage of the 
-> performance of a perfectly balanced binary tree.
PROC performance() OF sortedTree
  DEF count,weight=0,number=1
  DEF best=0,actual
  count:=self.nodes()
  WHILE count>number
    best:=number*weight+best
    count:=count-number
    INC weight
    number:=number*2
  ENDWHILE
  best:=count*weight+best     -> Length of a walk in a perfect tree
  actual:=self.walkLength(0)  -> Length of a walk in the real tree
ENDPROC best*100/actual       -> performance in %

-> Lenght of a walk in the tree.
PROC walkLength(depth) OF sortedTree
  DEF tot=0
  IF self.left  THEN tot:=tot+self.left.walkLength(depth+1)
  IF self.right THEN tot:=tot+self.right.walkLength(depth+1)
ENDPROC depth+tot

-> Prefix walk through the tree.
PROC prefix(proc) OF sortedTree
  proc(self)
  IF self.left  THEN self.left.prefix(proc)
  IF self.right THEN self.right.prefix(proc)
ENDPROC

-> Infix walk through the tree.
PROC infix(proc) OF sortedTree
  proc(self)
  IF self.left  THEN self.left.infix(proc)
  IF self.right THEN self.right.infix(proc)
ENDPROC

-> Postfix walk through the tree.
PROC postfix(proc) OF sortedTree
  proc(self)
  IF self.left  THEN self.left.postfix(proc)
  IF self.right THEN self.right.postfix(proc)
ENDPROC

-> NEVER call this method. Use loadObject() instead.
PROC load() OF sortedTree
  IF self.left  THEN self.left :=self.loadObject()
  IF self.right THEN self.right:=self.loadObject()
ENDPROC

-> NEVER call this method. Use storeObject() instead.
PROC store() OF sortedTree
  IF self.left  THEN self.left.storeObject()
  IF self.right THEN self.right.storeObject()
ENDPROC

