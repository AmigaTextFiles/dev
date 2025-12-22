MODULE 'shark/shkbitmap',
       'intuition/screens',
       'intuition/intuitionbase',
       'graphics/rastport',
       'graphics/gfx'

DEF s:PTR TO screen,ib:PTR TO intuitionbase,depth:PTR TO LONG,bitmap:PTR TO bitmap,bm:PTR TO bitmap
PROC main()
ib:=intuitionbase
bm:=ib.activescreen.rastport.bitmap
WriteF('bytesperrow: \d\nrows: \d\nflags: \d\ndepth: \d\npad: \d\nplanes: \d\n\n',bm.bytesperrow,bm.rows,bm.flags,bm.depth,bm.pad,bm.planes)
WriteF('width: \d\nheight: \d\n',ib.activescreen.width,ib.activescreen.height)
depth:=mBitMapDepth(bm)

bitmap:=mCreateBitMap(640,512,depth,0,bm)

s:=OpenS(320,256,depth,0,'Low-Resolution')
LOOP
BltBitMapRastPort(bitmap,s.mousex,s.mousey,s.rastport,0,0,320,256,$C0)
IF Mouse()=2 THEN JUMP here
ENDLOOP
here:
CloseS(s)

mDeleteBitMap(bitmap);

ENDPROC
