OPT     OSVERSION=37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'tools/textlen'
MODULE  'intuition/intuition'
MODULE  'intuition/gadgetclass'
MODULE  'gadgets/button'

EXPORT  CONST   NEWBUTTON = PLUGIN

EXPORT OBJECT button OF plugin
  selected
  disabled
PRIVATE
  button:PTR TO gadget
  buttonbase
  text
  toggle, push, resize
ENDOBJECT

PROC button(text,resizex=FALSE,resizey=FALSE,disabled=FALSE) OF button
  self.buttonbase:=OpenLibrary('gadgets/button.gadget',37)
  IF self.buttonbase=NIL THEN Raise("butt")
  self.text:=text
  self.toggle:=FALSE
  self.push:=FALSE
  self.selected:=FALSE
  self.resize:=(IF resizex THEN RESIZEX ELSE 0) OR
               (IF resizey THEN RESIZEY ELSE 0)
  self.disabled:=disabled
ENDPROC

PROC togglebutton(text,selected=FALSE,resizex=FALSE,resizey=FALSE,disabled=FALSE) OF button
  self.button(text,resizex,resizey)
  self.toggle:=TRUE
  self.selected:=selected
ENDPROC

PROC pushbutton(text,selected=FALSE,resizex=FALSE,resizey=FALSE,disabled=FALSE) OF button
  self.button(text,resizex,resizey)
  self.push:=TRUE
  self.selected:=selected
ENDPROC

PROC end() OF button
  IF self.buttonbase THEN CloseLibrary(self.buttonbase)
ENDPROC

PROC min_size(ta,fh) OF button
ENDPROC textlen(self.text,ta)+16,fh+6

PROC will_resize() OF button IS self.resize

PROC render(ta,x,y,xs,ys,w) OF button
  self.button:=NewObjectA(NIL,'button.gadget',
                         [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                          GA_TEXT,self.text, GA_TOGGLESELECT,self.toggle,
                          BUTTON_PUSHBUTTON,self.push, GA_TEXTATTR,ta,
                          GA_DISABLED,self.disabled, GA_SELECTED,self.selected,
                          GA_RELVERIFY,TRUE, NIL])
  IF self.button=NIL THEN Raise("butt")
  AddGList(w,self.button,-1,1,NIL)
  RefreshGList(self.button,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF button
  IF self.button
    RemoveGList(win,self.button,1)
    DisposeObject(self.button)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF button
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.button
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF button
  self.selected:=code
ENDPROC TRUE

PROC setselected(selected=TRUE) OF button
  IF self.toggle OR self.push
    SetGadgetAttrsA(self.button,self.gh.wnd,NIL,[GA_SELECTED,selected,NIL])
    self.selected:=selected
  ENDIF
ENDPROC

PROC settext(text) OF button
  SetGadgetAttrsA(self.button,self.gh.wnd,NIL,[GA_TEXT,text,NIL])
  self.text:=text
ENDPROC

PROC setdisabled(disabled=TRUE) OF button
  SetGadgetAttrsA(self.button,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.disabled:=disabled
ENDPROC
