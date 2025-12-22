
-> Copyright © 1995, Guichard Damien.

-> Eiffel constants

-> TO DO :
->   unique constants

OPT MODULE
OPT EXPORT

MODULE '*strings'
MODULE '*ame'
MODULE '*attribut'

OBJECT constant OF attribut
PRIVATE
  value:LONG
ENDOBJECT

-> Set constant value.
PROC set_value(value) OF constant
  self.value:=value
ENDPROC

-> Is feature a constant attribute?
PROC is_constant() OF constant IS TRUE

-> Feature value access mode
PROC access() OF constant IS M_IMMEDIATE

-> Index for access to feature value
PROC index() OF constant IS self.value

-> Make a copy renamed with 'name'
PROC rename(name) OF constant
  DEF other:PTR TO constant
  NEW other
  other.name:=clone(name)
  other.client:=self.client
  other.type:=self.type
  other.value:=self.value
ENDPROC other

-> Make a copy exported to 'client'
PROC new_exports(client) OF constant
  DEF other:PTR TO constant
  NEW other
  other.name:=self.name
  other.client:=client
  other.type:=self.type
  other.value:=self.value
ENDPROC other

