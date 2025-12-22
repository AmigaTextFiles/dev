
OPT MODULE
OPT REG=5



EXPORT PROC gPrevius(complex,index) IS
 IF index>0 THEN Forward(complex,index-1) ELSE 0



EXPORT PROC gRemove(complex_addr,index)
 DEF el,rem=0
 IF complex_addr
    IF (el:=^complex_addr)
       IF index
          IF (el:=gPrevius(el,index))
             rem:=Next(el)
             Link(el,Next(rem))
             Link(rem,0)
          ENDIF
       ELSE
          ^complex_addr:=Next(el)
          rem:=Link(el,0)
       ENDIF
    ENDIF
 ENDIF
ENDPROC rem



EXPORT PROC gRemoveComplex(complex_addr,index,size)
 DEF el,rem,prev,next
 prev:=rem:=0
 IF complex_addr
    IF (el:=^complex_addr)
       IF size>0
          IF index
             IF (prev:=gPrevius(el,index)) THEN rem:=Next(prev)
          ELSE
             rem:=el
          ENDIF
          IF rem
             el:=Forward(el,size)
             IF (next:=Next(el)) THEN Link(el,0)
             IF prev
                Link(prev,next)
             ELSE
                ^complex_addr:=next
             ENDIF
          ENDIF
       ENDIF
    ENDIF
 ENDIF
ENDPROC rem



EXPORT PROC gInsert(complex_addr,element,index)
 DEF el,next
 IF complex_addr
    IF (el:=^complex_addr)
       IF index
          IF (el:=gPrevius(el,index))
             IF (next:=Next(el))<>element
                Link(el,element)
                Link(element,next)
                RETURN TRUE
             ENDIF
          ENDIF
       ELSE
          IF element<>el
             Link(element,el)
             ^complex_addr:=element
             RETURN TRUE
          ENDIF
       ENDIF
    ENDIF
 ENDIF
ENDPROC FALSE



EXPORT PROC gInsertComplex(complex1_addr,complex2,index)
 DEF el1,next,el2,complex1
 IF complex1_addr
    IF (complex1:=^complex1_addr)
       IF (el2:=complex2)
          WHILE (el1:=Next(el2)) DO el2:=el1
          IF index
             IF (el1:=gPrevius(complex1,index))
                IF (next:=Next(el1))<>complex2
                   Link(el1,complex2)
                   Link(el2,next)
                   RETURN TRUE
                ENDIF
             ENDIF
          ELSE
             IF complex1<>complex2
                Link(el2,complex1)
                ^complex1_addr:=complex2
                RETURN TRUE
             ENDIF
          ENDIF
       ENDIF
    ENDIF
 ENDIF
ENDPROC FALSE



EXPORT PROC gSwapItems(complex_addr,index1,index2)
 DEF rem1,rem2
 IF index1>index2
    rem1:=index1
    index1:=index2
    index2:=rem1
 ENDIF
 IF index2>index1
    IF (rem1:=gRemove(complex_addr,index1))
       IF (rem2:=gRemove(complex_addr,index2-1))
           gInsert(complex_addr,rem2,index1)
           gInsert(complex_addr,rem1,index2)
           RETURN TRUE
       ENDIF
       gInsert(complex_addr,rem1,index1)
    ENDIF
 ENDIF
ENDPROC FALSE



