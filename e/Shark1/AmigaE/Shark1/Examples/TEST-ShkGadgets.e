MODULE 'intuition/intuition'
MODULE 'shark/shkgadgets'

/* --------------------- przyklad ------------------------ */

PROC main()
DEF win:PTR TO window,msg

mReserveZone(3) -> <<< Rezerwujesz pamiec na 3 gadzety.
win:=OpenW(0,0,320,200,IDCMP_MOUSEBUTTONS+IDCMP_CLOSEWINDOW,WFLG_CLOSEGADGET+WFLG_DRAGBAR+WFLG_DEPTHGADGET,'Test...',0,1,0)
Colour(2,1)
TextF(50,50,'No system gadgets              ') ; mSetZone(1,50,38,280,53) -> <<< Ustawianie strefy 1-wszej
TextF(50,70,'Shark Gadget by K. "SHARK" Cmok') ; mSetZone(2,50,58,280,73) -> <<< ---------- ------ 2-iej
TextF(50,90,'CLOSEWINDOW - zamkniecie okna  ') ; mSetZone(3,50,78,280,93) -> <<< ---------- ------ 3-iej
LOOP
msg:=WaitIMessage(win)
SELECT msg
	CASE IDCMP_CLOSEWINDOW;
             JUMP end
	CASE IDCMP_MOUSEBUTTONS;
             TextF(60,120,'Gadget number: \d ',mCheckZone(win))
             IF mCheck(win,60,108,280,123) THEN TextF(60,120,'All gadgets:   \d ',mSX[0])
ENDSELECT
ENDLOOP
end:
CloseW(win)

mFreeZone(3)   -> <<< Usuwasz miejsce w pamieci na 3 gadzety.
ENDPROC
