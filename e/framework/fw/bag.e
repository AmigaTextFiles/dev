
-> a bag is an unordered collection of elements.
-> Elements can occur any number of times.
-> Time complexity for data adding is O(1).
-> Time complexity for data searching is O(n).
-> Space complexity is O(n).

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT NOWARN

MODULE 'fw/comparable'

EXPORT OBJECT bag OF comparable
  next:PTR TO bag
ENDOBJECT

-> Count elements.
PROC count() OF bag
  DEF n=0
  LOOP
    self:=self.next
    IF self=NIL THEN RETURN n
    INC n
  ENDLOOP
ENDPROC

-> Is bag empty?
PROC empty() OF bag IS self.next=NIL

-> Add an element to the bag.
PROC add(e:PTR TO bag) OF bag
  e.next:=self.next
  self.next:=e
ENDPROC

-> Find an element in the bag.
PROC find(e:PTR TO bag) OF bag
  LOOP
    self:=self.next
    IF self=NIL THEN RETURN NIL
    IF e.isEqualTo(self) THEN RETURN self
  ENDLOOP
ENDPROC

-> Print elements.
PROC print() OF bag
  LOOP
    self:=self.next
    IF self=NIL THEN RETURN
    self.out()
  ENDLOOP
ENDPROC

-> Walk through the bag.
PROC traverse(proc) OF bag
  LOOP
    self:=self.next
    IF self=NIL THEN RETURN
    proc(self)
  ENDLOOP
ENDPROC

-> NEVER call this method. Use loadObject() instead.
PROC load() OF bag
  IF self.next THEN self.next:=self.loadObject()
ENDPROC

-> NEVER call this method. Use storeObject() instead.
PROC store() OF bag
  IF self.next THEN self.next.storeObject()
ENDPROC

