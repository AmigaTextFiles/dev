OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition',
       'intuition/screens'

PROC mWinZone(w:PTR TO window,x,y,x1,y1)
DEF clik,mx,my
clik:=FALSE
mx:=w.mousex
my:=w.mousey
IF mx>x
IF my>y
IF mx<x1
IF my<y1
	clik:=TRUE
ENDIF
ENDIF
ENDIF
ENDIF
ENDPROC clik

PROC mScrZone(s:PTR TO screen,x,y,x1,y1)
DEF clik,mx,my
clik:=FALSE
mx:=s.mousex
my:=s.mousey
IF mx>x
IF my>y
IF mx<x1
IF my<y1
	clik:=TRUE
ENDIF
ENDIF
ENDIF
ENDIF
ENDPROC clik
