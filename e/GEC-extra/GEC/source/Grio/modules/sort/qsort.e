
OPT MODULE

DEF bs,cmp,swp


EXPORT PROC qsort(base,low,high,comp,swap)
  bs:=base
  cmp:=comp 
  swp:=swap
ENDPROC sort(low,high)


PROC sort(low,high)
 DEF a,b,c
  WHILE ((high-low)>0)
    a:=low  ;  b:=high  ;  c:=(a+b)/2
    LOOP
      WHILE cmp(bs,c,a)<0 DO INC a
      WHILE cmp(bs,c,b)>0 DO DEC b
->      IF (a>=b) THEN JUMP break
      EXIT a>=b
      swp(bs,a,b)
      IF (c=a)
	c:=b
      ELSE
	IF (c=b) THEN c:=a
      ENDIF
      INC a  ;  DEC b
    ENDLOOP
->    break:
    IF (b<(high-b))
      sort(low,b)
      low:=b+1
    ELSE
      sort(b+1,high)
      high:=b
    ENDIF
  ENDWHILE
ENDPROC

