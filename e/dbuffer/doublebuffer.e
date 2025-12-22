/*my attempt at double buffering made easy*/
OPT MODULE
OPT EXPORT
MODULE 'intuition/screens',  -> Screen data structures
       'graphics/rastport',  -> RastPort and other structures
       'graphics/view',      -> ViewPort and other structures
       'graphics/gfx'        -> BitMap and other structures

OBJECT dscreen
 screen:PTR TO screen
 bm1:PTR TO bitmap
 bm2:PTR TO bitmap
ENDOBJECT

PROC opendscreen(ns:PTR TO ns)
DEF p:PTR TO dscreen
DEF plane_num, planes:PTR TO LONG
p:=New(SIZEOF dscreen)
p.bm1:=New(SIZEOF bitmap)
p.bm2:=New(SIZEOF bitmap)
InitBitMap(p.bm1,ns.depth,ns.width,ns.height)
InitBitMap(p.bm2,ns.depth,ns.width,ns.height)
  planes:=p.bm1.planes
  FOR plane_num:=0 TO ns.depth-1
    planes[plane_num]:=AllocRaster(ns.width, ns.height)
    BltClear(planes[plane_num], (ns.width/8)*ns.height, 1)
  ENDFOR
  planes:=p.bm2.planes
  FOR plane_num:=0 TO ns.depth-1
    planes[plane_num]:=AllocRaster(ns.width, ns.height)
    BltClear(planes[plane_num], (ns.width/8)*ns.height, 1)
  ENDFOR
ns.custombitmap:=p.bm1
ns.type:=ns.type OR $155
p.screen:=OpenScreen(ns)
p.screen.rastport.flags:=p.screen.rastport.flags OR RPF_DBUFFER
SetStdRast(p.screen.rastport)
dswitch(p)
ENDPROC p

PROC dswitch(p:PTR TO dscreen)
DEF t
t:=p.bm1
p.bm1:=p.bm2
p.bm2:=t
MakeScreen(p.screen)
RethinkDisplay()
p.screen.rastport.bitmap:=p.bm1
p.screen.viewport.rasinfo.bitmap:=p.bm1
ENDPROC

PROC closedscreen(p:PTR TO dscreen)
DEF plane_num, planes:PTR TO LONG
CloseScreen(p.screen)
  planes:=p.bm1.planes
  FOR plane_num:=0 TO p.bm1.depth-1
    IF planes[plane_num] THEN FreeRaster(planes[plane_num], p.screen.width, p.screen.height)
  ENDFOR
  planes:=p.bm2.planes
  FOR plane_num:=0 TO p.bm2.depth-1
    IF planes[plane_num] THEN FreeRaster(planes[plane_num], p.screen.width, p.screen.height)
  ENDFOR
stdrast:=NIL
ENDPROC
