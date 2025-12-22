MODULE 'intuition/intuition',
	'shark/shkfonts',
	'graphics/text'

DEF w:PTR TO window,tfont:PTR TO textfont
PROC main()

IF mOpenDiskFont(0)=NIL THEN CleanUp(10)

w:=OpenW(0,0,640,200,IDCMP_CLOSEWINDOW,WFLG_CLOSEGADGET+WFLG_DRAGBAR+WFLG_DEPTHGADGET,
		'TEST - ShkFonts module',0,1,0)

tfont:=mChangeFont(w.rport,'E.font',11)
IF tfont=NIL THEN WriteF('Can''t open E.font\n')
Move(w.rport,30,30)
Text(w.rport,'TEST - Font E.font',13)
CloseFont(tfont)
WaitIMessage(w)
CloseW(w)

mCloseDiskFont()

ENDPROC
