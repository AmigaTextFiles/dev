
OPT MODULE


EXPORT PROC qsort(base,numel,size,compar)
 DEF i,a,b,c,cm
  WHILE (numel>1)
    a:=0  ;  b:=numel-1  ;  c:=(a+b)/2
    LOOP
      cm:=Mul(c,size)
      WHILE compar(base+cm,base+Mul(size,a))>0 DO INC a
      WHILE compar(base+cm,base+Mul(size,b))<0 DO DEC b
      IF (a>=b) THEN JUMP break
      FOR i:=0 TO size-1
         VOID     Mul(size,a)
         MOVE.L   D0,-(A7)
         VOID     Mul(size,b)
         MOVE.L   D0,A1
         MOVEA.L  (A7)+,A0
         MOVE.L   base,D1
         ADD.L    i,D1
         ADDA.L   D1,A0
         ADDA.L   D1,A1
         MOVE.B   (A0),D0
         MOVE.B   (A1),(A0)
         MOVE.B   D0,(A1)
      ENDFOR
      IF (c=a)
        c:=b
      ELSE
        IF (c=b) THEN c:=a
      ENDIF
      INC a  ;  DEC b
    ENDLOOP
    break:
    INC b  ;  cm:=Mul(size,b)
    IF (b<(numel-b))
      qsort(base,b,size,compar)
      base:=base+cm
      numel:=numel-b
    ELSE
      qsort(base+cm,numel-b,size,compar)
      numel:=b
    ENDIF
  ENDWHILE
ENDPROC

