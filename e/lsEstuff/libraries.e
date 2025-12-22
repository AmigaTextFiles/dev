OPT MODULE

MODULE '*xli'

OBJECT lib OF xni
ENDOBJECT

EXPORT OBJECT libraries
   PRIVATE
   liblist:PTR TO xli
ENDOBJECT

PROC libraries() OF libraries IS NEW self.liblist

PROC open(name, rev) OF libraries
   DEF lib:PTR TO lib
   NEW lib
   lib.id := OpenLibrary(name, rev)
   IF lib.id = NIL THEN RETURN NIL
   self.liblist.addFirst(lib)
ENDPROC lib.id

PROC close(base) OF libraries
   DEF lib:PTR TO lib
   lib := self.liblist.find(base)
   IF lib = NIL THEN RETURN NIL
   CloseLibrary(lib.id)
   self.liblist.remove(lib)
   END lib
ENDPROC


PROC end() OF libraries
   self.clear()
   END self.liblist
ENDPROC

PROC clear() OF libraries
   DEF cpobj:xli_CPObj
   self.liblist.forEachCallProc({closeProc}, cpobj)
ENDPROC

PROC closeProc(cpobj:PTR TO xli_CPObj)
   DEF lib:PTR TO lib
   lib := cpobj.node
   CloseLibrary(lib.id)
   cpobj.xli.remove(lib)
   END lib
ENDPROC
