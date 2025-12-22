
-> Copyright © 1995, Guichard Damien.

-> Lists of Eiffel entities

-> Lists of Eiffel entities are used as an alternative for trees when
-> entities are ordered such as procedure arguments.

OPT MODULE
OPT EXPORT

MODULE '*entity'
MODULE '*strings'
MODULE '*class'

-> Eiffel entities that are stored in a list
OBJECT listed_entity OF entity
  next:PTR TO listed_entity
ENDOBJECT

-> Add an entity
PROC add(other:PTR TO listed_entity) OF listed_entity
  DEF previous:PTR TO listed_entity
  WHILE self
    previous:=self
    self:=self.next
  ENDWHILE
  previous.next:=other
ENDPROC

-> Find an entity
PROC find(name:PTR TO CHAR) OF listed_entity
  LOOP
    IF self=NIL THEN RETURN NIL
    IF StrCmp(name,self.name,ALL) THEN RETURN self
    self:=self.next
  ENDLOOP
ENDPROC

-> Destructor
PROC end() OF listed_entity
  DisposeLink(self.name)
ENDPROC

