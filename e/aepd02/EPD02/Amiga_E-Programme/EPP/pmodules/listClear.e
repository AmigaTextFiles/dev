OPT TURBO

PROC listClear (theList)
  DEF listCurrent
  listCurrent := ^theList
  WHILE listCurrent <> NIL
    Dispose (listCurrent)
    listCurrent := Next (listCurrent)
  ENDWHILE
  DisposeLink (^theList)
ENDPROC
  /* listClear */

