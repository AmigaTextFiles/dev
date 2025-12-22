/*
*/

MODULE '*simple.library'

PROC main()
  IF SimpleBase:=OpenLibrary('re:src/simple.library')
    PrintF('3+2=\d,3-2=\d\n',MyAdd(3,2),MySub(3,2))
    CloseLibrary(SimpleBase)
  ELSE
    PrintF('Library not loaded!\n')
  ENDIF
ENDPROC
