OPT	NOEXE,NOHEAD,CPU='WUP'

MODULE	'intuition','intuition/intuition'

PROC CloseW(window:PTR TO Window)
  IF stdrast=window.RPort THEN stdrast:=NIL
  CloseWindow(window)
ENDPROC
