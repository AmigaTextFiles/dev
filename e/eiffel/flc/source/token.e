
-> Copyright © 1995, Guichard Damien.

-> Eiffel 3.0 lexical tokens are Eiffel entities too.
-> They are the language's lowest level construct: the lexical entities.

OPT MODULE
OPT EXPORT

MODULE '*strings','*treed_entity'

-> Eiffel tokens
OBJECT token OF treed_entity
ENDOBJECT

-> Constructor.
PROC create(name,type) OF token
  self.name:=name
  self.int:=hash(name)
  self.type:=type
ENDPROC

