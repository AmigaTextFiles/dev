OPT TURBO

PROC listAppend (theElement, theList)
  DEF listCurrent

  /* NOTE:  both theElement and theList must be passed by reference. */
  /* Appends theElement onto the end of theList.                     */

  listCurrent := ^theList
  WHILE Next (listCurrent) <> NIL
    listCurrent := Next (listCurrent)
  ENDWHILE
  IF ^theList = NIL
    ^theList := ^theElement
  ELSE
    Link (listCurrent, ^theElement)
  ENDIF
  ^theElement := NIL
ENDPROC TRUE
  /* listAppend */

