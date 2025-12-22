OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'graphics/gfxmacros', 'graphics/rastport',
       'intuition/intuition', 'intuition/gadgetclass'

PROC ghost(win:PTR TO window,x,y,xs,ys)
  DEF apen, afpt, afptsz, drmd, r:PTR TO rastport
  r:=win.rport
  apen:=r.fgpen
  SetAPen(r,1)
  afpt:=r.areaptrn;  afptsz:=r.areaptsz
  SetAfPt(r,[$1111,$4444]:INT,1)
  drmd:=r.drawmode
  SetDrMd(r,RP_JAM1)
  RectFill(r,x,y,x+xs-1,y+ys-1)
  SetAPen(r,apen)
  SetAfPt(r,afpt,afptsz)
  SetDrMd(r,drmd)
ENDPROC

PROC unghost(gad,win) IS RefreshGList(gad,win,NIL,1)

PROC unghost_clear(gad,win,x,y,xs,ys)
  clear(win,x,y,xs,ys)
  unghost(gad,win)
ENDPROC

PROC clear(win:PTR TO window,x,y,xs,ys)
  SetAPen(win.rport,0)
  RectFill(win.rport,x,y,x+xs-1,y+ys-1)
ENDPROC
