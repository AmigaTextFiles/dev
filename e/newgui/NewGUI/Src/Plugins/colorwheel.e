OPT     OSVERSION=37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'tools/ghost'
MODULE  'intuition/intuition'
MODULE  'intuition/gadgetclass'
MODULE  'intuition/screens'
MODULE  'gadgets/colorwheel'

EXPORT  CONST   COLORWHEEL = PLUGIN

EXPORT OBJECT colorwheel OF plugin
  rgb:PTR TO colorwheelrgb
  hsb:PTR TO colorwheelhsb
  disabled
PRIVATE
  colorwheel:PTR TO gadget
  colorwheelbase
  box
ENDOBJECT

PROC colorwheel(rgb,hsb=NIL,box=FALSE,disabled=FALSE) OF colorwheel
  self.colorwheelbase:=OpenLibrary('gadgets/colorwheel.gadget',39)
  IF self.colorwheelbase=NIL THEN Raise("colw")
  IF rgb
    self.rgb:=rgb
    self.hsb:=NIL
  ELSE
    self.rgb:=NIL
    self.hsb:=hsb
  ENDIF
  self.box:=box
  self.disabled:=disabled
ENDPROC

PROC end() OF colorwheel
  IF self.colorwheelbase THEN CloseLibrary(self.colorwheelbase)
ENDPROC

PROC min_size(ta,fh) OF colorwheel
ENDPROC 50,50

PROC will_resize() OF colorwheel IS RESIZEX OR RESIZEY

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF colorwheel
  self.colorwheel:=NewObjectA(NIL,'colorwheel.gadget',
                         [GA_TOP,y+IF self.box THEN 0 ELSE 2,
                          GA_LEFT,x+IF self.box THEN 0 ELSE 2,
                          GA_WIDTH,xs-IF self.box THEN 0 ELSE 4,
                          GA_HEIGHT,ys-IF self.box THEN 0 ELSE 4,
                          IF self.hsb THEN WHEEL_HSB ELSE WHEEL_RGB,
                            IF self.hsb THEN self.hsb ELSE self.rgb,
                          GA_RELVERIFY,TRUE, WHEEL_SCREEN,w.wscreen,
                          WHEEL_BEVELBOX,self.box, GA_DISABLED,self.disabled,
                          NIL])
  IF self.colorwheel=NIL THEN Raise("colw")
  AddGList(w,self.colorwheel,-1,1,NIL)
  RefreshGList(self.colorwheel,w,NIL,1)
  IF self.disabled THEN IF self.box=FALSE THEN ghost(w,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC clear_render(win:PTR TO window) OF colorwheel
  IF self.colorwheel
    RemoveGList(win,self.colorwheel,1)
    DisposeObject(self.colorwheel)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF colorwheel
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.colorwheel
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF colorwheel
  IF self.rgb
    GetAttr(WHEEL_RGB,self.colorwheel,self.rgb)
  ELSE
    GetAttr(WHEEL_HSB,self.colorwheel,self.hsb)
  ENDIF
ENDPROC TRUE

PROC getrgb(rgb) OF colorwheel
  GetAttr(WHEEL_RGB,self.colorwheel,rgb)
ENDPROC rgb

PROC gethsb(hsb) OF colorwheel
  GetAttr(WHEEL_HSB,self.colorwheel,hsb)
ENDPROC hsb

PROC setrgb(rgb=NIL) OF colorwheel
  IF rgb
    self.rgb:=rgb
    self.hsb:=NIL
  ENDIF
  IF self.rgb THEN SetGadgetAttrsA(self.colorwheel,self.gh.wnd,NIL,
                                  [WHEEL_RGB,self.rgb,NIL])
ENDPROC

PROC sethsb(hsb) OF colorwheel
  IF hsb
    self.rgb:=NIL
    self.hsb:=hsb
  ENDIF
  IF self.hsb THEN SetGadgetAttrsA(self.colorwheel,self.gh.wnd,NIL,
                                  [WHEEL_HSB,self.hsb,NIL])
ENDPROC

PROC setdisabled(disabled=TRUE) OF colorwheel
  SetGadgetAttrsA(self.colorwheel,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  IF disabled
    IF self.box=FALSE
      ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
    ELSE
      unghost(self.colorwheel,self.gh.wnd)
    ENDIF
  ELSE
    unghost_clear(self.colorwheel,self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ENDIF
  self.disabled:=disabled
ENDPROC
