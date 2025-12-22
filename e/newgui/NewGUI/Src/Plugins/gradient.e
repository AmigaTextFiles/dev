OPT     OSVERSION=37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'tools/ghost'
MODULE  'intuition/gadgetclass'
MODULE  'intuition/intuition'
MODULE  'gadgets/gradientslider'

EXPORT  CONST   GRADIENT = PLUGIN

EXPORT OBJECT gradient OF plugin
  curval
  pens:PTR TO INT
  disabled
PRIVATE
  grad:PTR TO gadget
  gradbase
  vert
  rel
ENDOBJECT

PROC gradient(vert=FALSE,curval=0,rel=5,pens=NIL,disabled=FALSE) OF gradient
  self.gradbase:=OpenLibrary('gadgets/gradientslider.gadget',39)
  IF self.gradbase=NIL THEN Raise("grad")
  self.curval:=curval
  self.vert:=vert
  self.rel:=rel
  self.pens:=pens
  self.disabled:=disabled
ENDPROC

PROC end() OF gradient
  IF self.gradbase THEN CloseLibrary(self.gradbase)
ENDPROC

PROC min_size(ta,fh) OF gradient IS
  IF self.vert THEN (fh+6) ELSE (fh*self.rel),
  IF self.vert THEN (fh*self.rel) ELSE (fh+6)

PROC will_resize() OF gradient IS IF self.vert THEN RESIZEY ELSE RESIZEX

PROC render(ta,x,y,xs,ys,w) OF gradient
  self.grad:=NewObjectA(NIL,'gradientslider.gadget',
                       [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                        GRAD_CURVAL,self.curval, GRAD_PENARRAY,self.pens,
                        PGA_FREEDOM,IF self.vert THEN LORIENT_VERT ELSE LORIENT_HORIZ,
                        GA_RELVERIFY,TRUE, GA_DISABLED,self.disabled, NIL])
  IF self.grad=NIL THEN Raise("grad")
  AddGList(w,self.grad,-1,1,NIL)
  RefreshGList(self.grad,w,NIL,1)
  IF self.disabled THEN ghost(w,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC clear_render(win:PTR TO window) OF gradient
  IF self.grad
    RemoveGList(win,self.grad,1)
    DisposeObject(self.grad)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF gradient
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.grad
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF gradient
  DEF val=0
  GetAttr(GRAD_CURVAL,self.grad,{val})
  self.curval:=val
ENDPROC TRUE

PROC setcurval(x) OF gradient
  self.curval:=x
  SetGadgetAttrsA(self.grad,self.gh.wnd,NIL,[GRAD_CURVAL,x,NIL])
ENDPROC

PROC setpens(pens=NIL) OF gradient
  IF pens THEN self.pens:=pens
  self.clear_render(self.gh.wnd)
  self.render(NIL,self.x,self.y,self.xs,self.ys,self.gh.wnd)
ENDPROC

PROC setdisabled(disabled=TRUE) OF gradient
  SetGadgetAttrsA(self.grad,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  IF disabled
    ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ELSE
    unghost(self.grad,self.gh.wnd)
  ENDIF
  self.disabled:=disabled
ENDPROC
