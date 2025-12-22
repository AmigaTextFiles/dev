OPT MODULE

MODULE 'tools/EasyGUI', 'tools/ghost',
       'intuition/intuition', 'intuition/gadgetclass',
       'gadgets/tapedeck'

EXPORT OBJECT tapedeck OF plugin
  mode
  paused
  disabled
PRIVATE
  tapedeck:PTR TO gadget
  tapedeckbase
ENDOBJECT

PROC tapedeck(mode=BUT_STOP,paused=FALSE,disabled=FALSE) OF tapedeck
  self.tapedeckbase:=OpenLibrary('gadgets/tapedeck.gadget',39)
  IF self.tapedeckbase=NIL THEN Raise("tape")
  self.mode:=mode
  self.paused:=paused
  self.disabled:=disabled
ENDPROC

PROC end() OF tapedeck
  IF self.tapedeckbase THEN CloseLibrary(self.tapedeckbase)
ENDPROC

PROC min_size(ta,fh) OF tapedeck
ENDPROC 201,15

PROC will_resize() OF tapedeck IS 0

PROC render(ta,x,y,xs,ys,w) OF tapedeck
  self.tapedeck:=NewObjectA(NIL,'tapedeck.gadget',
                     [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                      TDECK_MODE,self.mode, TDECK_PAUSED,self.paused,
                      TDECK_TAPE,TRUE, GA_DISABLED,self.disabled,
                      GA_RELVERIFY,TRUE, NIL])
  IF self.tapedeck=NIL THEN Raise("tape")
  AddGList(w,self.tapedeck,-1,1,NIL)
  RefreshGList(self.tapedeck,w,NIL,1)
  IF self.disabled THEN ghost(w,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC clear_render(win:PTR TO window) OF tapedeck
  IF self.tapedeck
    RemoveGList(win,self.tapedeck,1)
    DisposeObject(self.tapedeck)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF tapedeck
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.tapedeck
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF tapedeck
  DEF x
  GetAttr(TDECK_MODE,self.tapedeck,{x})
  self.mode:=x
  GetAttr(TDECK_PAUSED,self.tapedeck,{x})
  self.paused:=IF x THEN TRUE ELSE FALSE
ENDPROC TRUE

PROC setmode(mode=BUT_STOP) OF tapedeck
  self.mode:=mode
  IF mode=BUT_PAUSE THEN self.paused:=self.paused=FALSE
  SetGadgetAttrsA(self.tapedeck,self.gh.wnd,NIL,[TDECK_MODE,mode,NIL])
  IF self.disabled THEN ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
ENDPROC

PROC setpaused(paused=TRUE) OF tapedeck
  IF self.paused<>paused
    SetGadgetAttrsA(self.tapedeck,self.gh.wnd,NIL,[TDECK_MODE,BUT_PAUSE,NIL])
    IF self.disabled THEN ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ENDIF
  self.paused:=paused
ENDPROC

PROC setdisabled(disabled=TRUE) OF tapedeck
  SetGadgetAttrsA(self.tapedeck,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  IF disabled
    ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ELSE
    unghost_clear(self.tapedeck,self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ENDIF
  self.disabled:=disabled
ENDPROC
