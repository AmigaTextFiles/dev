
MODULE 'grio/gadtools','intuition/intuition'
MODULE 'graphics/rastport','graphics/text'

PROC main()
DEF win:PTR TO gadtools,wnd:PTR TO window
NEW win.new()
wnd:=win.openWin(100,200,150,150,IDCMP_CLOSEWINDOW,WFLG_CLOSEGADGET,0)
SetAPen(stdrast,0)
SetBPen(stdrast,1)
SetDrMd(stdrast,RP_JAM2)
wnd.rport.areaptrn:=[$5555,$5555]:INT
wnd.rport.areaptsz:=1
RectFill(stdrast,win.calcXX(5),win.calcYY(5),win.calcXX(140),win.calcYY(140))
WaitIMessage(wnd)
CloseW(wnd)
END win
ENDPROC

