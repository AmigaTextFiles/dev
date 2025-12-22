MODULE 'mathffp'

PROC main()
 IF mathbase:=OpenLibrary('mathffp.library',37)
  SpDiv(0,0)
  CloseLibrary(mathbase)
 ENDIF
ENDPROC
