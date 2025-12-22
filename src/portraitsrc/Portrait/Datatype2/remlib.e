MODULE 'exec/libraries'
PROC main()
  DEF lib:PTR TO lib
IF lib:=OpenLibrary(arg,0)
  lib.opencnt:=0
  RemLibrary(lib)
ENDIF
ENDPROC
