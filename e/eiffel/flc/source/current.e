
-> Copyright © 1995, Guichard Damien.

-> Eiffel Current class

-> The 'Current' class is a special class that changes with the current
-> object. There is only one 'Current' class. It is mainly used by
-> 'like Current' anchored type.

OPT MODULE
OPT EXPORT

MODULE '*class'

-> 'Current' class
OBJECT current OF class
PRIVATE
  current:PTR TO class
ENDOBJECT

-> Base class of the class-type
PROC base() OF current IS self.current

-> Set current base class
PROC set(class) OF current
  self.current:=class
ENDPROC

