/*ORIGINALE in " C "  1992 (C) Matthias Zepf für Amiga Plus 11/92    */
/* Umsetzung auf AmigaE   FB  1994 */


DEF feld[110]:ARRAY OF LONG,anzahle 

/* "feld[]" enthält die zu sortierenden Zahlen
   "anzahle" die anzahl der zu sortierenden zahlen*/


PROC main()


WriteF('\n\n')

zufall()  /* Erzeugung der Zufallszahlen*/
WriteF('Zufall:\n')
zeigen() /* Zahlen zeigen*/
shellsort()
WriteF('shellsort \n')
zeigen()
WriteF('\n\n')

zufall() 
WriteF('Zufall:\n')
zeigen()
rhepsort()
WriteF('hepsort recursiv\n')
zeigen()

WriteF('\n\n')
zufall() 
WriteF('Zufall:\n')
zeigen()
ihepsort()
WriteF('hepsort interactiv\n')
zeigen()

WriteF('\n')

ENDPROC



PROC zeigen()
 DEF i,j
  i:=0
  REPEAT
    j:=0
    REPEAT
      WriteF ('\d[4]',feld[(i*15)+j])
      INC j
    UNTIL j=15
    WriteF('\n')
    INC i
  UNTIL i=7
ENDPROC

/* shellsort--------------------------------------------*/
PROC shellsort ()
DEF i,j,k,l,m,wert

l:=41
WHILE l>0
  m:=0
 WHILE m<l
  i:=m+l
  WHILE i< anzahle 
   wert:=feld[i]
   j:=i
   WHILE ((j-l)>=0) AND (feld[j-l]>wert)
    j:=j-l
   ENDWHILE
   IF j<>i
     k:=i 
     WHILE  k>j 
      feld[k]:=feld[k-l]
      k:=k-l
    ENDWHILE
    ENDIF
    i:=i+l
    feld[j]:=wert
 ENDWHILE
  INC m
  ENDWHILE
l:=l-5
ENDWHILE  

ENDPROC
/*------------------------------------------------------*/

/* hepsort recursiv-------------------------------------*/
PROC rhepsort()
 DEF j,hilfe

FOR j:=anzahle/2 TO 0 STEP -1
 rkorrect(j,(anzahle-1)) 
ENDFOR
FOR j:=anzahle-1 TO 1 STEP-1
 hilfe:=feld[0]
  feld[0]:=feld[j]
  feld[j]:=hilfe
  rkorrect(0,(j-1))
ENDFOR
ENDPROC


PROC rkorrect(i,n)
DEF j,hilfe

j:=i*2
IF (j<=n)
 IF ((j+1)<=n) AND (feld[j+1]>feld[j])
  INC j
 ENDIF
 IF (feld[j]>feld[i])
  hilfe:=feld[i]
  feld[i]:=feld[j]
  feld[j]:=hilfe
  rkorrect(j,n)
 ENDIF
ENDIF
ENDPROC
/*------------------------------------------------------*/

/*hepsort interactiv------------------------------------*/
PROC ihepsort()
 DEF j,hilfe

FOR j:=anzahle/2 TO 0 STEP -1
 ikorrect(j,(anzahle-1)) 
ENDFOR
FOR j:=anzahle-1 TO 1 STEP-1
 hilfe:=feld[0]
  feld[0]:=feld[j]
  feld[j]:=hilfe
  ikorrect(0,(j-1))
ENDFOR
ENDPROC


PROC ikorrect(i,n)
DEF j,hilfe,weiter
weiter:=TRUE
WHILE weiter=TRUE
 j:=i*2
 IF (j>n)
  weiter:=FALSE 
 ELSE
  IF ((j+1)<=n) AND (feld[j+1]>feld[j])
   INC j
  ENDIF
  IF (feld[j]<=feld[i])
   weiter:=FALSE
  ELSE
   hilfe:=feld[i]
   feld[i]:=feld[j]
   feld[j]:=hilfe
   i:=j
  ENDIF
 ENDIF
ENDWHILE
ENDPROC
/*--------------------------------------------------------*/

PROC zufall()
DEF i
anzahle:=105
  i:=0
  REPEAT  
    feld[i]:=Rnd(1000)
    INC i
  UNTIL i=anzahle
ENDPROC