OPT MODULE
OPT REG=5



EXPORT OBJECT array PRIVATE
  uBound             : LONG
  elementSize        : LONG
  numberOfDimensions : LONG
  sizeOfDimension    : LONG
  elements           : LONG
ENDOBJECT





PROC make(indexList:PTR TO LONG,elementSize) OF array
  DEF numberOfElements = 1 , i , j , numberOfDimensions ,
      sizeOfDimension : PTR TO LONG , uBounds : PTR TO LONG
      
  self.numberOfDimensions := numberOfDimensions := ListLen(indexList)

  IF (uBounds := List(numberOfDimensions)) = NIL
     RETURN D0
  ENDIF

  self.uBound := uBounds

  self.elementSize := elementSize

  FOR i := 0 TO (numberOfDimensions - 1)
     numberOfElements := Mul(numberOfElements, indexList[i])
  ENDFOR

  IF (i := New( Mul(numberOfElements, elementSize) ))
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




PROC swap(indexList1:PTR TO LONG,indexList2:PTR TO LONG) OF array
  DEF ptr1 : PTR TO CHAR, ptr2 : PTR TO CHAR , x , val

  IF self.within(indexList1)
     IF self.within(indexList2)
	ptr1 := self.elements + self.offset(indexList1)
	ptr2 := self.elements + self.offset(indexList2)
	FOR  x:=1  TO  self.elementSize
	     val := ptr1[]
	     ptr1[]++ := ptr2[]
	     ptr2[]++ := val
	ENDFOR
	RETURN TRUE
     ENDIF
  ENDIF
ENDPROC FALSE




PROC copy(indexList1:PTR TO LONG,indexList2:PTR TO LONG) OF array
  DEF ptr1 : PTR TO CHAR, ptr2 : PTR TO CHAR , x

  IF self.within(indexList1)
     IF self.within(indexList2)
	ptr1 := self.elements + self.offset(indexList1)
	ptr2 := self.elements + self.offset(indexList2)
	FOR  x:=1  TO  self.elementSize
	     ptr1[]++ := ptr2[]++
	ENDFOR
	RETURN TRUE
     ENDIF
  ENDIF
ENDPROC FALSE




PROC set(indexList : PTR TO LONG,value_ptr:PTR TO CHAR) OF array
  DEF eptr : PTR TO CHAR, x

  IF self.within(indexList)
     eptr := self.elements + self.offset(indexList)
     FOR  x:=1  TO  self.elementSize
	  eptr[]++ := value_ptr[]++
     ENDFOR
     RETURN TRUE
  ENDIF
ENDPROC FALSE




PROC get(indexList : PTR TO LONG,ptr:PTR TO CHAR) OF array
  DEF eptr : PTR TO CHAR, x

  IF self.within(indexList)
     eptr := self.elements + self.offset(indexList)
     FOR  x:=1  TO  self.elementSize
	  ptr[]++ := eptr[]++
     ENDFOR
     RETURN TRUE
  ENDIF
ENDPROC FALSE




PROC within(indexList : PTR TO LONG) OF array
  DEF i
  FOR i := 0 TO (self.numberOfDimensions - 1)
      IF (0 > indexList[i]) OR (indexList[i] > ListItem(self.uBound, i))
	 RETURN FALSE
      ENDIF
  ENDFOR
ENDPROC  TRUE




PROC offset(indexList : PTR TO LONG) OF array
  DEF offset = 0  , i
  FOR i := 0 TO (self.numberOfDimensions - 1)
     offset := offset + Mul(indexList[i], ListItem(self.sizeOfDimension, i))
  ENDFOR
ENDPROC  Mul(offset, self.elementSize)



PROC end() OF array
  DisposeLink(self.sizeOfDimension)
  Dispose(self.elements)
  DisposeLink(self.uBound)
ENDPROC NIL





