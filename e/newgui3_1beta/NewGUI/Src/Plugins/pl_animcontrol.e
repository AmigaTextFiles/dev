OPT     OSVERSION=37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'tools/ghost'
MODULE  'intuition/intuition'
MODULE  'intuition/gadgetclass'
MODULE  'gadgets/tapedeck'

EXPORT  CONST   ANIMCTRL = PLUGIN

EXPORT OBJECT animcontrol OF plugin
  frame
  mode
PRIVATE
  animcontrol:PTR TO gadget
  animcontrolbase
  frames
  downmode
ENDOBJECT

PROC animcontrol(frame=0,frames=8,play=FALSE,disabled=FALSE) OF animcontrol
  self.animcontrolbase:=OpenLibrary('gadgets/tapedeck.gadget',39)
  IF self.animcontrolbase=NIL THEN Raise("anim")
  self.frame:=frame
  self.frames:=frames
  self.mode:=IF play THEN BUT_PLAY ELSE BUT_STOP
  self.dis:=disabled
ENDPROC

PROC end() OF animcontrol
  IF self.animcontrolbase THEN CloseLibrary(self.animcontrolbase)
ENDPROC

PROC min_size(ta,fh) OF animcontrol
ENDPROC 203,15

PROC will_resize() OF animcontrol IS 0

PROC render(ta,x,y,xs,ys,w) OF animcontrol
  self.animcontrol:=NewObjectA(NIL,'tapedeck.gadget',
                     [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                      TDECK_MODE,self.mode, TDECK_FRAMES,self.frames,
                      TDECK_CURRENTFRAME,self.frame, TDECK_TAPE,FALSE,
                      GA_DISABLED,self.dis,
                      GA_RELVERIFY,TRUE, GA_IMMEDIATE,TRUE, NIL])
  IF self.animcontrol=NIL THEN Raise("anim")
  AddGList(w,self.animcontrol,-1,1,NIL)
  RefreshGList(self.animcontrol,w,NIL,1)
  IF self.dis THEN ghost(w,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC clear_render(win:PTR TO window) OF animcontrol
  IF self.animcontrol
    RemoveGList(win,self.animcontrol,1)
    DisposeObject(self.animcontrol)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF animcontrol
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.animcontrol
  IF imsg.class=IDCMP_GADGETDOWN THEN RETURN imsg.iaddress=self.animcontrol
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF animcontrol
  DEF mode, frame
  GetAttr(TDECK_MODE,self.animcontrol,{mode})
  GetAttr(TDECK_CURRENTFRAME,self.animcontrol,{frame})
  IF class=IDCMP_GADGETDOWN
    self.downmode:=mode
    IF mode=BUT_FRAME THEN mode:=BUT_STOP
    self.mode:=mode
    IF (mode<>BUT_REWIND) AND (mode<>BUT_FORWARD) THEN RETURN FALSE
  ELSE
    IF self.downmode=BUT_FRAME
      mode:=BUT_STOP
      self.downmode:=BUT_STOP
    ENDIF
    self.mode:=mode
  ENDIF
  self.frame:=frame
ENDPROC TRUE

PROC setframe(n) OF animcontrol
  self.frame:=n
  SetGadgetAttrsA(self.animcontrol,self.gh.wnd,NIL,[TDECK_CURRENTFRAME,n,NIL])
  IF self.dis THEN ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC setplay(play=TRUE) OF animcontrol
  self.mode:=IF play THEN BUT_PLAY ELSE BUT_STOP
  SetGadgetAttrsA(self.animcontrol,self.gh.wnd,NIL,[TDECK_MODE,self.mode,NIL])
  IF self.dis THEN ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC disable(disabled=TRUE) OF animcontrol
  SetGadgetAttrsA(self.animcontrol,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  IF disabled
    ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ELSE
    unghost(self.animcontrol,self.gh.wnd)
  ENDIF
  self.dis:=disabled
ENDPROC
