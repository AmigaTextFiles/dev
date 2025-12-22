
-> test a libraryfunction in bla.library

MODULE '*bla_lib'

DEF blabase

RAISE "LIB" IF OpenLibrary()=NIL

PROC main()
   blabase := OpenLibrary('e:examples/bla.library', 0)
   Func3() -> call a function
EXCEPT DO
   IF blabase THEN CloseLibrary(blabase)
ENDPROC

