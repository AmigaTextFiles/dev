OPT MODULE, PREPROCESS
OPT EXPORT
OPT POINTER

MODULE 'graphics/gfxmacros', 'graphics/rastport',
       'intuition/intuition', 'intuition/gadgetclass'
MODULE 'intuition', 'graphics', 'exec/types'

PROC ghost(win:PTR TO window,x,y,xs,ys)
  DEF apen, afpt:PTR TO UINT, afptsz:BYTE, drmd, r:PTR TO rastport
  r:=win.rport
  apen:=r.fgpen
  SetAPen(r,1)
  afpt:=r.areaptrn;  afptsz:=r.areaptsz
  SetAfPt(r,[$1111,$4444]:UINT,1)
  drmd:=r.drawmode
  SetDrMd(r,RP_JAM1)
  RectFill(r,x,y,x+xs-1,y+ys-1)
  SetAPen(r,apen!!BIGVALUE!!ULONG)
  SetAfPt(r,afpt,afptsz)
  SetDrMd(r,drmd!!BIGVALUE!!ULONG)
ENDPROC

PROC unghost(gad:PTR TO gadget,win:PTR TO window) IS RefreshGList(gad,win,NIL,1)

PROC unghost_clear(gad:PTR TO gadget,win:PTR TO window,x,y,xs,ys)
  clear(win,x,y,xs,ys)
  unghost(gad,win)
ENDPROC

PROC clear(win:PTR TO window,x,y,xs,ys)
  SetAPen(win.rport,0)
  RectFill(win.rport,x,y,x+xs-1,y+ys-1)
ENDPROC
