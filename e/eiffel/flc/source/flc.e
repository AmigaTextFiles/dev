
-> Copyright © 1995, Guichard Damien.

-> Compile an entire Eiffel system defined by its root class and its
-> creation feature (creation feature must not have arguments).

OPT OSVERSION=36

MODULE '*system'

PROC main()
  DEF myargs:PTR TO LONG,rdargs
  myargs:=[NIL,NIL,NIL]
  IF rdargs:=ReadArgs('CLASS/A,CREATION/A,FILE/A',myargs,NIL)
    root(LowerStr(myargs[0]),LowerStr(myargs[1]),myargs[2])
    FreeArgs(rdargs)
  ELSE
    WriteF('Bad Args!\n')
  ENDIF
ENDPROC

