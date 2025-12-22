OPT NOHEAD,NOEXE,CPU='WUP'
MODULE 'graphics'
IMPORT DEF coloura
PROC Colour(a,b)
  IF stdrast
    SetAPen(stdrast,a)
    SetBPen(stdrast,b)
  ENDIF
ENDPROC
