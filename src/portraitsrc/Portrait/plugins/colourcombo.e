OPT MODULE

MODULE '*work:src/portrait/easygui/EasyGUI', 'tools/ghost',
       'intuition/intuition', 'intuition/gadgetclass', 'intuition/screens',
       'gadgets/colorwheel', 'colorwheel', 'gadgets/gradientslider',
       'graphics/text','graphics/view'

EXPORT OBJECT truecolour
  alpha:CHAR
  red:CHAR
  green:CHAR
  blue:CHAR
ENDOBJECT

EXPORT OBJECT colourcombo OF plugin
  argb:PTR TO truecolour
  disabled
PRIVATE
  rgb:PTR TO colorwheelrgb
  hsb:PTR TO colorwheelhsb
  colorwheel:PTR TO gadget
  colorwheelbase
  pens:PTR TO INT
  grad:PTR TO gadget
  gradbase
  blackpen
  colourpen
ENDOBJECT

PROC colcombo(argb:PTR TO truecolour) OF colourcombo
  self.colorwheelbase:=OpenLibrary('gadgets/colorwheel.gadget',39)
  IF self.colorwheelbase=NIL THEN Raise("colw")
  colorwheelbase:=self.colorwheelbase
  self.gradbase:=OpenLibrary('gadgets/gradientslider.gadget', 39)
  IF self.gradbase=NIL
    CloseLibrary(self.colorwheelbase)
    self.colorwheelbase:=NIL
    Raise("grad")
  ENDIF
  self.argb:=argb
  NEW self.rgb
  self.rgb.red:=Mul(argb.red,$01010101)
  self.rgb.green:=Mul(argb.green,$01010101)
  self.rgb.blue:=Mul(argb.blue,$01010101)
  NEW self.hsb
  ConvertRGBToHSB(self.rgb,self.hsb)
ENDPROC

PROC end() OF colourcombo
  IF self.colorwheelbase THEN CloseLibrary(self.colorwheelbase)
  IF self.gradbase THEN CloseLibrary(self.gradbase)
ENDPROC

PROC min_size(ta,fh) OF colourcombo
ENDPROC 50+(fh+6)+6,50

PROC will_resize() OF colourcombo IS RESIZEX OR RESIZEY

PROC render(ta:PTR TO textattr,x,y,xs,ys,w:PTR TO window) OF colourcombo
  DEF fh,rgb:colorwheelrgb
  fh:=ta.ysize
  ConvertHSBToRGB([self.hsb.hue,self.hsb.saturation,-1]:colorwheelhsb,rgb)
  self.blackpen:=ObtainBestPenA(w.wscreen.viewport.colormap,0,0,0,[OBP_PRECISION,PRECISION_GUI,NIL])
  self.colourpen:=ObtainBestPenA(w.wscreen.viewport.colormap,rgb.red,rgb.green,rgb.blue,[OBP_PRECISION,PRECISION_GUI,NIL])
  self.pens:=[self.colourpen,self.blackpen,-1]:INT
  self.grad:=NewObjectA(NIL,'gradientslider.gadget',
                       [GA_TOP,y, GA_LEFT,x+xs-4-(fh+6), GA_WIDTH,(fh+6), GA_HEIGHT,ys,
                        GRAD_CURVAL,Div(self.hsb.brightness,$1000), GRAD_PENARRAY,self.pens,
                        PGA_FREEDOM,LORIENT_VERT,
                        GA_RELVERIFY,TRUE, NIL])
  IF self.grad=NIL THEN Raise("grad")
  self.colorwheel:=NewObjectA(NIL,'colorwheel.gadget',
                         [GA_TOP,y+2,
                          GA_LEFT,x+2,
                          GA_WIDTH,xs-4-(fh+6)-6,
                          GA_HEIGHT,ys-4,
                          WHEEL_RGB,self.rgb,
                          GA_RELVERIFY,TRUE, WHEEL_SCREEN,w.wscreen,
                          WHEEL_GRADIENTSLIDER, self.grad,
                          GA_PREVIOUS, self.grad,
                          NIL])
  IF self.colorwheel=NIL
    DisposeObject(self.grad)
    self.grad:=NIL
    Raise("colw")
  ENDIF
  AddGList(w,self.grad,-1,2,NIL)
  RefreshGList(self.grad,w,NIL,2)
ENDPROC

PROC clear_render(win:PTR TO window) OF colourcombo
  DEF penptr:PTR TO INT
  IF self.grad
    RemoveGList(win,self.grad,1)
    DisposeObject(self.grad)
  ENDIF
  IF self.colorwheel
    RemoveGList(win,self.colorwheel,1)
    DisposeObject(self.colorwheel)
  ENDIF
  IF self.pens
    penptr:=self.pens
    WHILE (penptr[]<>-1)
      ReleasePen(win.wscreen.viewport.colormap,penptr[])
      penptr++
    ENDWHILE
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF colourcombo
  IF imsg.class=IDCMP_GADGETUP THEN RETURN (imsg.iaddress=self.colorwheel) OR (imsg.iaddress=self.grad)
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF colourcombo
  self.getargb()
  self.rerender()
ENDPROC TRUE

/*PROC setpens(pens=NIL) OF colourcombo
  IF pens THEN self.pens:=pens
  self.clear_render(self.gh.wnd)
  self.render(NIL,self.x,self.y,self.xs,self.ys,self.gh.wnd)
ENDPROC*/

PROC setargb(argb:PTR TO truecolour) OF colourcombo
  IF argb<>self.argb
    self.argb.alpha:=argb.alpha
    self.argb.red:=argb.red
    self.argb.green:=argb.green
    self.argb.blue:=argb.blue
  ENDIF
  self.rgb.red:=Mul(argb.red, $01010101)
  self.rgb.green:=Mul(argb.green, $01010101)
  self.rgb.blue:=Mul(argb.blue, $01010101)
  ConvertRGBToHSB(self.rgb,self.hsb)
  IF self.colorwheel
    SetGadgetAttrsA(self.colorwheel,self.gh.wnd,NIL,
                                  [  WHEEL_RGB,self.rgb,NIL])
    self.rerender()
  ENDIF
ENDPROC

PROC rerender() OF colourcombo
  DEF win:PTR TO window
  DEF penptr:PTR TO INT,x,y,xs,ys,curval,rgb:colorwheelrgb
  win:=self.gh.wnd
  ConvertHSBToRGB([self.hsb.hue,self.hsb.saturation,-1]:colorwheelhsb,rgb)
  self.blackpen:=ObtainBestPenA(win.wscreen.viewport.colormap,0,0,0,[OBP_PRECISION,PRECISION_GUI,NIL])
  self.colourpen:=ObtainBestPenA(win.wscreen.viewport.colormap,rgb.red,rgb.green,rgb.blue,[OBP_PRECISION,PRECISION_GUI,NIL])
  IF self.pens
    penptr:=self.pens
    WHILE (penptr[]<>-1)
      ReleasePen(win.wscreen.viewport.colormap,penptr[])
      penptr++
    ENDWHILE
  ENDIF
  self.pens:=[self.colourpen,self.blackpen,-1]:INT
  /*GetAttr(GA_TOP,self.grad,{y})
  GetAttr(GA_LEFT,self.grad,{x})
  GetAttr(GA_WIDTH,self.grad,{xs})
  GetAttr(GA_HEIGHT,self.grad,{ys})*/
  y:=self.grad.topedge
  x:=self.grad.leftedge
  xs:=self.grad.width
  ys:=self.grad.height
  GetAttr(GRAD_CURVAL,self.grad,{curval})
  RemoveGList(win,self.grad,1)
  DisposeObject(self.grad)
  self.grad:=NewObjectA(NIL,'gradientslider.gadget',
                       [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                        GRAD_CURVAL,curval, GRAD_PENARRAY,self.pens,
                        PGA_FREEDOM,LORIENT_VERT,
                        GA_RELVERIFY,TRUE, NIL])
  IF self.grad=NIL THEN Raise("grad")
  AddGList(win,self.grad,-1,1,NIL)
  RefreshGList(self.grad,win,NIL,1)
ENDPROC
PROC getargb() OF colourcombo
  GetAttr(WHEEL_RGB,self.colorwheel,self.rgb)
  GetAttr(WHEEL_HSB,self.colorwheel,self.hsb)
  self.argb.red:=Shr(self.rgb.red,6)
  self.argb.green:=Shr(self.rgb.green,6)
  self.argb.blue:=Shr(self.rgb.blue,6)
ENDPROC self.argb

/*
PROC getrgb(rgb) OF colourcombo
  GetAttr(WHEEL_RGB,self.colorwheel,rgb)
ENDPROC rgb

PROC gethsb(hsb) OF colourcombo
  GetAttr(WHEEL_HSB,self.colorwheel,hsb)
ENDPROC hsb

PROC setrgb(rgb=NIL) OF colourcombo
  IF rgb
    self.rgb:=rgb
    self.hsb:=NIL
  ENDIF
  IF self.rgb THEN SetGadgetAttrsA(self.colorwheel,self.gh.wnd,NIL,
                                  [WHEEL_RGB,self.rgb,NIL])
ENDPROC

PROC sethsb(hsb) OF colourcombo
  IF hsb
    self.rgb:=NIL
    self.hsb:=hsb
  ENDIF
  IF self.hsb THEN SetGadgetAttrsA(self.colorwheel,self.gh.wnd,NIL,
                                  [WHEEL_HSB,self.hsb,NIL])
ENDPROC
*/
