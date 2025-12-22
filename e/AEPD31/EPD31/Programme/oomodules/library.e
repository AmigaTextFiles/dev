/*


NOTA BENE:

The base attribute must contain the *address* of the library's base, so
every object inheriting from this has to do a

  self.base := {<libname>base}

Note that this is not the case for devices etc.
*/


OPT MODULE
OPT EXPORT

MODULE 'oomodules/object'

OBJECT library OF object
  base  -> contains a pointer to the base !!!
  name
  version
ENDOBJECT

PROC select(optionlist,index) OF library
DEF item

  item := ListItem(optionlist, index)

  SELECT item
    CASE "name"
      INC index
      self.name := ListItem(optionlist,index)
    CASE "vers"
      INC index
      self.version := ListItem(optionlist,index)
  ENDSELECT

  IF index = ListLen(optionlist)-1 THEN self.open(self.name,self.version)

ENDPROC index

PROC name() OF library IS 'Library'

PROC open(name,version=NIL,dummy=NIL) OF library
/*
 * Just opens a library and fills the entries. the dummy argument is needed for
 * open OF device uses three vars
 */

DEF base,address

  address := self.base
  base := OpenLibrary(name,version)

  IF base = NIL
    Raise("LIB")
  ELSE
    ^address := base
    RETURN base
  ENDIF
ENDPROC

PROC close() OF library
  IF self.base THEN CloseLibrary(self.base)
ENDPROC

PROC end() OF library
  self.close()
ENDPROC

PROC update(anything) OF library
/* not tested */

  self.close()
  self.open(self.name, self.version)

ENDPROC
