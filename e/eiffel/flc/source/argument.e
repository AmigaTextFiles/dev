
-> Copyright © 1995, Guichard Damien.

-> Eiffel routine arguments

OPT MODULE
OPT EXPORT

MODULE '*strings'
MODULE '*ame'
MODULE '*listed_entity'
MODULE '*class'

-> argument
OBJECT argument OF listed_entity
  count:INT
ENDOBJECT

-> Create an argument.
PROC create(name) OF argument
  self.name:=name
  self.count:=1
ENDPROC

-> Add an entity
PROC add(other:PTR TO argument) OF argument
  DEF previous:PTR TO argument
  WHILE self
    previous:=self
    self:=self.next
  ENDWHILE
  previous.next:=other
  other.set_count(previous.count+1)
ENDPROC

-> Set argument type.
PROC set_type(type) OF argument
  self.type:=type
ENDPROC

-> Set count of the local (used only by procedure)
PROC set_count(count) OF argument
  self.count:=count
ENDPROC

-> Argument value access mode
PROC access() OF argument IS M_ARG

-> Index for access to argument value
PROC index() OF argument IS self.count

