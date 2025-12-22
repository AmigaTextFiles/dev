MODULE 'intuition/intuition','shark/shktools'
DEF w:PTR TO window,click
PROC main()
w:=OpenW(0,0,300,300,0,WFLG_DRAGBAR+WFLG_DEPTHGADGET,'Tests',0,1,0)

click:=mRequest('Test','EasyRequestArgs - in Shark Modules..\n','YES|YEEEESSSS')
SELECT click
	CASE 1; WriteF('CLICK: YES\n')
	CASE 0; WriteF('CLICK: YEEEESSSS\n')
       DEFAULT; WriteF('ERROR: YES & YEEEESSSS\n')
ENDSELECT

mTextOne(w.rport,30,30,'Effects on Text part One - mTextOne()')
mTextTwo(w.rport,30,50,'Effects on Text part Two - mTextTwo()',2,1,3)

mBox(w.rport,50,90,80,120,2,1)

mTextOne(w.rport,30,70,'LEFT - EXIT   RIGHT - RESET')
IF mClick()=2 THEN mReset('Bye Bye!!!')
CloseW(w)
ENDPROC
