ENUM FRED, BARNEY

PROC main()
  WriteF('Ciao da main\n')
  fred()
  barney()
  WriteF('Arrivederci da main\n')
ENDPROC

PROC fred() HANDLE
  WriteF(' Ciao da fred\n')
  Raise(FRED)
  WriteF(' Arrivederci da fred\n')
EXCEPT
  WriteF(' Handler fred: \d\n', exception)
ENDPROC

PROC barney()
  WriteF('  Ciao da barney\n')
  Raise(BARNEY)
  WriteF('  Arrivederci da barney\n')
ENDPROC
