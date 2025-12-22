/* $VER: insertinorder 1.0 (30.9.97) © Frédéric Rodrigues
   Inserts elements in order in an array
*/

OPT MODULE

CONST DATASIZE=4 /* array of LONG */

EXPORT PROC insertinorder(array:PTR TO LONG,len,element,comparisonfunction,userdata)
  DEF bornea:PTR TO LONG,borneb:PTR TO LONG,milieu:PTR TO LONG
  array:=array-DATASIZE
  bornea:=0
  INC len
  borneb:=len
  /* positionnement */
  WHILE (bornea+1)<>borneb
    IF comparisonfunction(array[milieu:=(bornea+borneb)/2],element,userdata)
      borneb:=milieu
    ELSE
      bornea:=milieu
    ENDIF
  ENDWHILE
  /* insertion */
  milieu:=array+(borneb*DATASIZE)
  borneb:=array+(len*DATASIZE)
  WHILE borneb>milieu
    bornea:=borneb
    bornea[]:=borneb[]--
  ENDWHILE
  milieu[]:=element
ENDPROC
