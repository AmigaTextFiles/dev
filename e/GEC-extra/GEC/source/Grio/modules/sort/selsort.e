OPT MODULE


EXPORT PROC selectsort(base,low,high,comp,swap)
DEF min,x,y
  min:=low
  FOR x:=low+1 TO high DO IF comp(base,min,x)<0 THEN min:=x
  swap(base,min,low)
  FOR y:=low+1 TO high-1
    min:=y
    FOR x:=y+1 TO high
      IF comp(base,min,x)<=0
        min:=x
        IF comp(base,min,y-1)=0 THEN x:=high
      ENDIF
    ENDFOR
    swap(base,y,min)
  ENDFOR
ENDPROC

