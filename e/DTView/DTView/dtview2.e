MODULE 'amigaguide','libraries/amigaguide'
DEF guide,rdargs,myargs:PTR TO LONG
PROC main()
  myargs:=[0]
  IF rdargs:=ReadArgs('FILE/A',myargs,NIL)
    PrintF('myargs[0]=%s',myargs[0])
    IF amigaguidebase:=OpenLibrary('amigaguide.library',39)
      IF guide:=OpenAmigaGuideA([0,myargs[0],NIL,NIL,NIL,NIL,NIL,0/*flags*/,NIL,NIL,0,NIL,0]:newamigaguide,NIL)
        CloseAmigaGuide(guide)
      ENDIF
      CloseLibrary(amigaguidebase)
    ENDIF
    FreeArgs(rdargs)
  ENDIF
ENDPROC
version:
CHAR '$VER: DTView 0.2 (18.01.01) (©2001 Jean Holzammer/Development@Holzammer.net)',0
