OPT MODULE
OPT EXPORT

OBJECT library
  base
ENDOBJECT

PROC open(name,version=NIL,dummy=NIL) OF library
/*
 * Just opens a library and fills the entries. the dummy argument is needed for
 * opne OF device uses three vars
 */

DEF base
  IF(base := OpenLibrary(name,version))=NIL THEN Raise("LIB")
  self.base := base
ENDPROC base

PROC close() OF library
  IF self.base THEN CloseLibrary(self.base)
ENDPROC
