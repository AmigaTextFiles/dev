OPT MODULE
OPT REG=5




EXPORT OBJECT larray
  PRIVATE
  uBound             : LONG
  numberOfDimensions : LONG
  sizeOfDimension    : LONG
  elements           : LONG
ENDOBJECT




PROC make(indexList:PTR TO LONG) OF larray
  DEF numberOfElements = 1 , i , j , numberOfDimensions ,
      sizeOfDimension : PTR TO LONG , uBounds : PTR TO LONG

  self.numberOfDimensions := numberOfDimensions := ListLen(indexList)

  IF (uBounds := List(numberOfDimensions)) = NIL
     RETURN D0
  ENDIF

  self.uBound := uBounds

  FOR i := 0 TO (numberOfDimensions - 1)
     numberOfElements := Mul(numberOfElements, indexList[i])
  ENDFOR

  IF (i := New( Shl(numberOfElements, 2) ))
     self.elements:=i
  ELSE
     RETURN D0
  ENDIF

  ListCopy(uBounds , indexList, ALL)
  MapList({j}, uBounds , uBounds , `j - 1)


  IF (sizeOfDimension := List(numberOfDimensions))
     self.sizeOfDimension := sizeOfDimension
  ELSE
     RETURN D0
  ENDIF

  SetList(sizeOfDimension, numberOfDimensions)
  MapList({j}, sizeOfDimension, sizeOfDimension, `1)

  FOR i := 0 TO (numberOfDimensions - 1)
    FOR j := (i + 1) TO (numberOfDimensions - 1)
      sizeOfDimension[i] := Mul(sizeOfDimension[i], indexList[j])
    ENDFOR
  ENDFOR

ENDPROC TRUE




PROC set(indexList : PTR TO LONG,value) OF larray
  DEF ptr : PTR TO LONG 

  IF self.within(indexList)
     ptr := self.elements + self.offset(indexList)
     ptr[] := value
     RETURN TRUE
  ENDIF

ENDPROC FALSE



PROC get(indexList : PTR TO LONG,saveptr) OF larray
  DEF ptr : PTR TO LONG

  IF self.within(indexList)
     ptr := self.elements + self.offset(indexList)
     ^saveptr := ptr[]
     RETURN TRUE
  ENDIF
ENDPROC FALSE




PROC within(indexList : PTR TO LONG) OF larray
  DEF i
  FOR i := 0 TO (self.numberOfDimensions - 1)
      IF (0 > indexList[i]) OR (indexList[i] > ListItem(self.uBound, i))
	 RETURN FALSE
      ENDIF
  ENDFOR
ENDPROC  TRUE



PROC offset(indexList : PTR TO LONG) OF larray
  DEF offset = 0 , i
  FOR i := 0 TO (self.numberOfDimensions - 1)
     offset := offset + Mul(indexList[i], ListItem(self.sizeOfDimension, i))
  ENDFOR
ENDPROC  Shl(offset, 2)



PROC end() OF larray
  DisposeLink(self.sizeOfDimension)
  Dispose(self.elements)
  DisposeLink(self.uBound)
ENDPROC NIL






