OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition'

DEF mSX:PTR TO LONG
DEF mSY:PTR TO LONG
DEF mEX:PTR TO LONG
DEF mEY:PTR TO LONG

PROC mReserveZone(maxzone)
DEF a
mSX:=AllocMem(10*maxzone,0)
mSY:=AllocMem(10*maxzone,0)
mEX:=AllocMem(10*maxzone,0)
mEY:=AllocMem(10*maxzone,0)
FOR a:=1 TO maxzone
mSX[a]:=-1 ; mSY[a]:=-1
mEX[a]:=-1 ; mEY[a]:=-1
ENDFOR
mSX[0]:=maxzone ; mEX[0]:=maxzone
mSY[0]:=maxzone ; mEY[0]:=maxzone
ENDPROC

PROC mFreeZone(maxzone)
FreeMem(mSX,10*maxzone)
FreeMem(mSY,10*maxzone)
FreeMem(mEX,10*maxzone)
FreeMem(mEY,10*maxzone)
ENDPROC

PROC mCheckZone(win:PTR TO window)
DEF m,searched=-1:PTR TO LONG
FOR m:=1 TO mSX[0]
IF mSX[m]<win.mousex
	IF mSY[m]<win.mousey
		IF mEX[m]>win.mousex
			IF mEY[m]>win.mousey
				searched:=m
			ENDIF
		ENDIF
	ENDIF
ENDIF
ENDFOR
ENDPROC searched

PROC mCheck(win:PTR TO window,sx,sy,ex,ey)
DEF searched=FALSE:PTR TO LONG
IF sx<win.mousex
	IF sy<win.mousey
		IF ex>win.mousex
			IF ey>win.mousey
				searched:=TRUE
			ENDIF
		ENDIF
	ENDIF
ENDIF
ENDPROC searched

PROC mSetZone(nr,sx,sy,ex,ey)
mSX[nr]:=sx
mSY[nr]:=sy
mEX[nr]:=ex
mEY[nr]:=ey
ENDPROC
