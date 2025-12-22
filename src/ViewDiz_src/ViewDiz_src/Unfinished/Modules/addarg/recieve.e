OBJECT modarg
  abe
  kat
ENDOBJECT

PROC main()
  DEF longval:PTR TO LONG, ma:PTR TO modarg

  StrToLong( arg, {ma} )

  PrintF('abe:  \s\n', ma.abe)
  PrintF('kat:  \d\n', ma.kat)
ENDPROC
