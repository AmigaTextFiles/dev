OPT MODULE

MODULE 'tools/EasyGUI', 'graphics/rastport',
       'intuition/intuition', 'intuition/imageclass',
       'images/led', 'utility/tagitem'

EXPORT OBJECT led OF plugin
  pairs
  values:PTR TO INT
  colon
  signed
  negative
  pen
PRIVATE
  ledbase
ENDOBJECT

PROC led(pairs=2,values=NIL,colon=FALSE,signed=FALSE,negative=FALSE,pen=1) OF led
  self.ledbase:=OpenLibrary('images/led.image',37)
  IF self.ledbase=NIL THEN Raise("led")
  self.pairs:=pairs
  self.values:=values
  self.colon:=colon
  self.signed:=signed
  self.negative:=negative
  self.pen:=pen
ENDPROC

PROC end() OF led
  IF self.ledbase THEN CloseLibrary(self.ledbase)
ENDPROC

PROC min_size(ta,fh) OF led
ENDPROC self.pairs*19-IF self.signed THEN 0 ELSE 5,12

PROC will_resize() OF led IS RESIZEX OR RESIZEY

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF led
  DEF led
  IF (led:=NewObjectA(NIL,'led.image',
           [IA_FGPEN,self.pen, IA_WIDTH,xs-1, IA_HEIGHT,ys,
            IF self.values THEN LED_VALUES ELSE TAG_IGNORE,self.values,
            LED_PAIRS,self.pairs, LED_COLON,self.colon,
            LED_SIGNED,self.signed, LED_NEGATIVE,self.negative,
            NIL]))=NIL THEN Raise("led")
  DrawImage(w.rport,led,x,y)
  DisposeObject(led)
ENDPROC

PROC redisplay() OF led
  IF self.gh.wnd THEN self.render(NIL,self.x,self.y,self.xs,self.ys,self.gh.wnd)
ENDPROC
