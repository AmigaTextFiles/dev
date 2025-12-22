MODULE 'shark/shkzone'      -> for mWinZone() and mScrZone()
MODULE 'shark/shktools'       -> for mBox()
MODULE 'intuition/intuition'

PROC main()
DEF w:PTR TO window,class

w:=OpenW(0,0,200,110,IDCMP_CLOSEWINDOW+IDCMP_INTUITICKS,WFLG_CLOSEGADGET+WFLG_ACTIVATE,'TEST',0,1,0)

mBox(w.rport,20,20,180,100,1,2)
mBox(w.rport,25,30,175,50,2,1)
mBox(w.rport,25,60,175,70,2,1)
mBox(w.rport,25,80,175,90,2,1)
LOOP
class:=WaitIMessage(w)

	SELECT class

	CASE IDCMP_CLOSEWINDOW; JUMP cw
	CASE IDCMP_INTUITICKS;
		IF mWinZone(w,25,60,175,70)=TRUE ; TextF(50,45,'1: Zone One') ; ENDIF
		IF mWinZone(w,25,80,175,90)=TRUE ; TextF(50,45,'2: Zone Two') ; ENDIF
	ENDSELECT

ENDLOOP

cw:
CloseW(w)

ENDPROC
