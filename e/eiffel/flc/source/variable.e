
-> Copyright © 1995, Guichard Damien.

-> Eiffel variable attributes (field components of run-time objects)

OPT MODULE
OPT EXPORT

MODULE '*strings'
MODULE '*ame'
MODULE '*attribut'

OBJECT variable OF attribut
PRIVATE
  frozen:INT
  count:INT
ENDOBJECT

-> Freeze this feature.
PROC freeze() OF variable
  self.frozen:=TRUE
ENDPROC

-> Is feature frozen?
PROC is_frozen() OF variable IS self.frozen

-> Set count of the feature
PROC set_count(count) OF variable
  self.count:=count
ENDPROC

-> Is feature a variable attribute?
PROC is_variable() OF variable IS TRUE

-> Feature value access mode
PROC access() OF variable IS M_ATTRIBUT

-> Index for access to feature value
PROC index() OF variable IS self.count

-> Make a copy renamed with 'name'
PROC rename(name) OF variable
  DEF other:PTR TO variable
  NEW other
  other.name:=clone(name)
  other.client:=self.client
  other.type:=self.type
  other.frozen:=self.frozen
  other.count:=self.count
ENDPROC other

-> Make a copy exported to 'client'
PROC new_exports(client) OF variable
  DEF other:PTR TO variable
  NEW other
  other.name:=self.name
  other.client:=client
  other.type:=self.type
  other.frozen:=self.frozen
  other.count:=self.count
ENDPROC other

-> Make a copy redefined with 'client','arguments','type'
PROC redefine(client,arguments,type) OF variable
  DEF other:PTR TO variable
  NEW other
  other.name:=self.name
  other.client:=client
  other.type:=self.type
  other.count:=self.count
ENDPROC other

