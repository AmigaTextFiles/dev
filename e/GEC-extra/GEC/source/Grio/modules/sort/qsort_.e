
OPT MODULE


EXPORT PROC qsort(base,lo,hi,comp,swap)
 DEF si:PTR TO LONG , sj:PTR TO LONG
 DEF i , j , ps=0 , p , size

 size:=((hi-lo+1) AND (-2))*4
 IF (si:=AllocMem(size,0))=NIL THEN RETURN FALSE
 sj:=si+(size/2)
 si[ps]:=lo  ;  sj[ps]:=hi
 WHILE (ps>=0)
     lo:=si[ps]   ;   hi:=sj[ps]   ;  DEC ps
     WHILE (hi>lo)
         p:=0 ; i:=lo ; j:=hi
         REPEAT
             IF comp(base,i,j)<0
                p:=1-p
                swap(base,i,j)
             ENDIF
             IF p=0 THEN INC i ELSE DEC j
         UNTIL (j<=i)
         IF (i<hi)
            INC ps   ;  si[ps]:=i+1   ;  sj[ps]:=hi
         ENDIF
         hi:=i-1
    ENDWHILE
 ENDWHILE
 FreeMem(si,size)

ENDPROC TRUE




