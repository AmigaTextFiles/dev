
OPT MODULE
OPT EXPORT

-> Eiffel local entities

-> Copyright (c) 1995, Guichard Damien.

MODULE '*treed_entity'
MODULE '*strings'
MODULE '*class'
MODULE '*ame'

OBJECT local OF treed_entity
  count:INT
ENDOBJECT

-> Create a local variable.
PROC create(name) OF local
  self.int:=hash(name)
  self.name:=clone(name)
ENDPROC

-> Set local variable type.
PROC set_type(type) OF local
  self.type:=type
ENDPROC

-> Set count of the local (used only by procedure)
PROC set_count(count) OF local
  self.count:=count
ENDPROC

-> Local value access mode
PROC access() OF local IS M_LOCAL

-> Index for access to local value
PROC index() OF local IS self.count

