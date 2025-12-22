/*
*/
OPT NOHEAD,NOEXE,CPU='WUP'
MODULE 'graphics'
IMPORT DEF coloura
PROC Plot(x,y,c)
  IF stdrast
    IF c<0 THEN c:=coloura
    SetAPen(stdrast,c)
    WritePixel(stdrast,x,y)
  ENDIF
ENDPROC
