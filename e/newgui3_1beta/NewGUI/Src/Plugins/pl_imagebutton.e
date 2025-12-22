OPT     OSVERSION=37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'graphics/rastport'
MODULE  'intuition/intuition'
MODULE  'intuition/gadgetclass'
MODULE  'gadgets/button'

EXPORT  CONST   IMGBUTTON = PLUGIN

EXPORT OBJECT imagebutton OF plugin
  selected
PRIVATE
  button:PTR TO gadget
  buttonbase
  image:PTR TO image
  toggle, push, resize
  width, height
ENDOBJECT

PROC imagebutton(image:PTR TO image,width=0,height=0,resizex=FALSE,
                 resizey=FALSE,disabled=FALSE) OF imagebutton
  self.buttonbase:=OpenLibrary('gadgets/button.gadget',37)
  IF self.buttonbase=NIL THEN Raise("butt")
  self.image:=image
  self.toggle:=FALSE
  self.push:=FALSE
  self.selected:=FALSE
  self.resize:=(IF resizex THEN RESIZEX ELSE 0) OR
               (IF resizey THEN RESIZEY ELSE 0)
  self.dis:=disabled
  self.width:=Max(width,image.width)
  self.height:=Max(height,image.height)
ENDPROC

PROC toggleimagebutton(image,width=0,height=0,selected=FALSE,resizex=FALSE,
                       resizey=FALSE,disabled=FALSE) OF imagebutton
  self.imagebutton(image,width,height,resizex,resizey)
  self.toggle:=TRUE
  self.selected:=selected
ENDPROC

PROC pushimagebutton(image,width=0,height=0,selected=FALSE,resizex=FALSE,
                     resizey=FALSE,disabled=FALSE) OF imagebutton
  self.imagebutton(image,width,height,resizex,resizey)
  self.push:=TRUE
  self.selected:=selected
ENDPROC

PROC end() OF imagebutton
  IF self.buttonbase THEN CloseLibrary(self.buttonbase)
ENDPROC

PROC min_size(ta,fh) OF imagebutton
ENDPROC self.width+4, self.height+2

PROC will_resize() OF imagebutton IS self.resize

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF imagebutton
  self.button:=NewObjectA(NIL,'button.gadget',
                         [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                          GA_IMAGE,self.image, GA_TOGGLESELECT,self.toggle,
                          BUTTON_PUSHBUTTON,self.push,
                          GA_DISABLED,self.dis, GA_SELECTED,self.selected,
                          GA_RELVERIFY,TRUE, BUTTON_FILLPEN,w.rport.bgpen, NIL])
  IF self.button=NIL THEN Raise("butt")
  AddGList(w,self.button,-1,1,NIL)
  RefreshGList(self.button,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF imagebutton
  IF self.button
    RemoveGList(win,self.button,1)
    DisposeObject(self.button)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win) OF imagebutton
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.button
ENDPROC FALSE

PROC message_action(class,qual,code,win) OF imagebutton
  self.selected:=code
ENDPROC TRUE

PROC setselected(selected=TRUE) OF imagebutton
  IF self.toggle OR self.push
    SetGadgetAttrsA(self.button,self.gh.wnd,NIL,[GA_SELECTED,selected,NIL])
    self.selected:=selected
  ENDIF
ENDPROC

PROC setimage(image:PTR TO image) OF imagebutton
  IF (image.width<=self.width) AND (image.height<=self.height)
    SetGadgetAttrsA(self.button,self.gh.wnd,NIL,[GA_IMAGE,image,NIL])
    self.image:=image
  ENDIF
ENDPROC

PROC disable(disabled=TRUE) OF imagebutton
  SetGadgetAttrsA(self.button,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.dis:=disabled
ENDPROC
