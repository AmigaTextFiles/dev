MODULE 'amigaguide','libraries/amigaguide'
DEF guide
PROC main()
  IF amigaguidebase:=OpenLibrary('amigaguide.library',39)
    IF guide:=OpenAmigaGuideA([0,arg,NIL,NIL,NIL,NIL,NIL,0/*flags*/,NIL,NIL,0,NIL,0]:newamigaguide,NIL)
      CloseAmigaGuide(guide)
    ENDIF
    CloseLibrary(amigaguidebase)
  ENDIF
ENDPROC