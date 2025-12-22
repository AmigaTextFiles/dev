MODULE 'intuition/intuition',
	'tools/ilbm',
	'tools/ilbmdefs',
	'intuition/screens',
	'graphics/gfx',
	'shark/ShkPointers',
	'intuition/intuitionbase',
	'graphics/view'

DEF ilbm,p:PTR TO bitmap,scr:PTR TO screen,win:PTR TO window,mask,x,y,pointer,
	int:PTR TO intuitionbase,act:PTR TO screen,bgro:PTR TO bitmap
PROC main()
int:=intuitionbase
act:=int.activescreen
scr:=OpenS(act.width,act.height,6,act.viewport.modes,NIL)
win:=OpenW(0,0,act.width,act.height,0,WFLG_ACTIVATE+WFLG_BORDERLESS+WFLG_NOCAREREFRESH,0,scr,$F,0)

ilbm:=ilbm_New('pointer.pic',0)
	ilbm_LoadPicture(ilbm,[ILBML_GETBITMAP,{p},0])
	ilbm_Dispose(ilbm)
mask:=p.planes
mask:=^mask

pointer:=mAllocPointer()
mChangePointer(pointer,win,HIDEPOINTER)

WriteF('\s\n',act.title)
BltBitMapRastPort(act.bitmap,0,0,win.rport,0,0,act.width,act.height,$c0)
bgro:=act.bitmap

REPEAT
x:=win.mousex
y:=win.mousey
BltMaskBitMapRastPort(p,0,0,win.rport,x,y,10,10,$E0,mask)
WaitTOF()
BltBitMapRastPort(bgro,x,y,win.rport,x,y,10,10,$C0)
UNTIL Mouse()=1

mFreePointer(pointer,win)
ilbm_FreeBitMap(p)
CloseW(win)
CloseS(scr)
ENDPROC
