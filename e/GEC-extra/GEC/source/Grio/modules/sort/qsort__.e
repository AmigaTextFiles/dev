
OPT MODULE


DEF bs,cmp,swp


EXPORT PROC qsort(base,low,high,comp,swap)
  bs:=base
  cmp:=comp
  swp:=swap
ENDPROC sort(low,high)


PROC sort(lo,hi)
 DEF i , j , e
 e:=i:=lo   ;   j:=hi+1
 WHILE (i<j)
     REPEAT
        INC i
     UNTIL cmp(bs,i,e)<=0
     REPEAT
        DEC j
     UNTIL cmp(bs,j,e)>=0
     IF (i<j) THEN swp(bs,i,j)
 ENDWHILE
 swp(bs,lo,j)
 i:=j+1   ;  DEC j
 IF (lo<j) THEN sort(lo,j)
 IF (i<hi) THEN sort(i,hi)
ENDPROC



