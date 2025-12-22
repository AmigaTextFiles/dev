
OPT MODULE




EXPORT PROC gPrevius(complex,index) IS
 IF index>0 THEN Forward(complex,index-1) ELSE 0



EXPORT PROC gRemove(complex,index)
 DEF el,rem=0
 IF complex
    IF index
       IF (el:=gPrevius(complex,index))
          rem:=Next(el)
          Link(el,Next(rem))
          Link(rem,0)
       ENDIF
    ELSE
       el:=Next(complex)
       rem:=Link(complex,0)
       complex:=el
    ENDIF
 ENDIF
 MOVE.L  rem,D1
ENDPROC complex



EXPORT PROC gRemoveComplex(complex,index,size)
 DEF el,rem,prev,next
 prev:=rem:=0
 IF complex
    IF size>0
       IF index
          IF (prev:=gPrevius(complex,index)) THEN rem:=Next(prev)
       ELSE
          rem:=complex
       ENDIF
       IF rem
          el:=Forward(complex,size)
          IF (next:=Next(el)) THEN Link(el,0)
          IF prev
             Link(prev,next)
          ELSE
             complex:=next
          ENDIF
       ENDIF
    ENDIF
 ENDIF
 MOVE.L  rem,D1
ENDPROC complex



EXPORT PROC gInsert(complex,element,index)
 DEF el,next
 IF complex
    IF index
       IF (el:=gPrevius(complex,index))
          IF (next:=Next(el))<>element
             Link(el,element)
             Link(element,next)
          ENDIF
       ENDIF
    ELSE
       IF element<>complex
          Link(element,complex)
          RETURN element
       ENDIF
    ENDIF
 ENDIF
ENDPROC complex



EXPORT PROC gInsertComplex(complex1,complex2,index)
 DEF el1,next,el2
 IF complex1
    IF (el2:=complex2)
       WHILE (el1:=Next(el2)) DO el2:=el1
       IF index
          IF (el1:=gPrevius(complex1,index))
             IF (next:=Next(el1))<>complex2
                Link(el1,complex2)
                Link(el2,next)
             ENDIF
          ENDIF
       ELSE
          IF complex1<>complex2
             Link(el2,complex1)
             complex1:=complex2
          ENDIF
       ENDIF
    ENDIF
 ENDIF
ENDPROC complex1



EXPORT PROC gSwapItems(complex,index1,index2)
 DEF rem1,rem2
 IF complex
    IF index1>index2
       rem1:=index1
       index1:=index2
       index2:=rem1
    ENDIF
    IF index2>index1
       complex,rem1:=gRemove(complex,index1)
       IF rem1
           complex,rem2:=gRemove(complex,index2-1)
           IF rem2
              gInsert(gInsert(complex,rem2,index1),rem1,index2)
              MOVEQ  #TRUE,D1
              RETURN D0
           ENDIF
           complex:=gInsert(complex,rem1,index1)
       ENDIF
    ENDIF
 ENDIF
 MOVEQ  #FALSE,D1
ENDPROC complex



