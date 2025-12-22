
-> Object persistency in E 3.1a  (may be crash with higher versions!!)
-> It is quite limited but it works!!
-> Persistency is usefull and allows you to dynamically store and load
-> entire polymorphic object structures. It can be used in OO databases
-> or OO compilers in which it provides a lazy way for module precompilation.
-> It will often avoid the need to write these ugly load/save procedures.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT
OPT NOWARN

MODULE 'fw/any'

DEF file

-> A storable object without memory space penalty.
-> All collection classes inherit from it so all collections are persistent.
OBJECT storable OF any
ENDOBJECT

-> Set storage file for persistency.
-> storage MUST be a valid file-handle.
PROC setStorage(storage) OF storable
  file:=storage
ENDPROC

-> Get the storage file.
-> setStorage MUST have been called before.
PROC storage() OF storable IS file

-> Load an entire polymorphic structure from storage file.
-> setStorage MUST have been called before with a READ mode file
-> which has been previously produced by a VALID storeObject() call.
PROC loadObject() OF storable
  DEF class=0
  Fread(file,{class},SIZEOF LONG,1)
  MOVE.L  A4, D0
  ADD.L   D0, class
  self:=FastNew(^class)
  ^self:=class
  Fread(file,self+SIZEOF LONG,^class-SIZEOF LONG,1)
  self.load()
ENDPROC self

-> Store an entire polymorphic structure to storage file.
-> setStorage MUST have been called before with a WRITE mode file.
-> Currently there is strong limitations about object structures that
-> can be stored: there MUST be no cycles and multi-pointed object
-> will be duplicated as no mark is left on objects. Moreover object MUST not
-> be CHIP-RAM-only as there is no guarantee that it will re-loaded in CHIP.
PROC storeObject() OF storable
  DEF class
  MOVE.L  A4, class
  class:=^self-class
  Fwrite(file,{class},4,1)
  Fwrite(file,self+SIZEOF LONG,Long(^self)-SIZEOF LONG,1)
  self.store()
ENDPROC

-> Load a string from storage file.
PROC loadString() OF storable
  DEF size=0
  DEF str
  Fread(file,{size},SIZEOF LONG,1)
  str:=New(size+1)
  Fread(file,str,size,1)
ENDPROC str

-> Store a string to storage file.
-> BEWARE, E strings are turned into simple strings.
PROC storeString(str:PTR TO CHAR) OF storable
  DEF size
  size:=StrLen(str)
  Fwrite(file,{size},SIZEOF LONG,1)
  Fwrite(file,str,size,1)
ENDPROC

-> Explain how to load this object.
PROC load() OF storable IS EMPTY

-> Explain how to store this object.
PROC store() OF storable IS EMPTY

