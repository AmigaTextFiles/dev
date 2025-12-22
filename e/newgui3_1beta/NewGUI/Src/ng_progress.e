OPT     OSVERSION = 37
OPT     MODULE

MODULE  'graphics/text'
MODULE  'graphics/gfx'
MODULE  'graphics/gfxmacros'
MODULE  'graphics/rastport'
MODULE  'intuition/screens'
MODULE  'intuition/intuition'
MODULE  'tools/textlen'

EXPORT OBJECT  progresswin

PRIVATE
 scr    :PTR TO screen
 wnd    :PTR TO window
 tattr  :PTR TO textattr
 title  :PTR TO CHAR
 action :PTR TO CHAR
 status :PTR TO CHAR
 iswb   :INT
 bpen   :INT
 fpen   :INT
 space  :INT
 value  :INT
 text   :INT
 x      :INT
 y      :INT
 xs     :INT
 ys     :INT
 update :INT
ENDOBJECT

PROC progresswin(title,action,status,back,front,space,initvalue,screen=NIL,textattr=NIL) OF progresswin
  self.title    :=title
  self.bpen     :=back
  self.fpen     :=front
  self.space    :=space
  self.value    :=initvalue
  self.status   :=status
  self.action   :=action
    self.tattr  :=textattr
     IF (screen<>NIL)
      self.scr  :=screen
     ELSE
      self.scr  :=LockPubScreen(NIL)
      self.iswb  :=1
     ENDIF
       IF (self.tattr=NIL) THEN self.tattr:=self.scr.font

    self.xs:=(textlen('100 %',self.tattr)+10)*3
    IF (self.action<>NIL) THEN self.xs:=textlen(self.action,self.tattr)+30
   self.ys:=self.tattr.ysize+4
    self.x:=15
    self.y:=(40+self.tattr.ysize+3)-(self.ys/2)
     self.wnd:=OpenWindowTagList(NIL,[
        WA_LEFT,        (self.scr.width-(self.xs+30))/2,
        WA_TOP,         (self.scr.height-(((self.y-self.tattr.ysize+3)*2)+self.ys))/2,
        WA_WIDTH,       self.xs+30,
        WA_HEIGHT,      ((self.y-self.tattr.ysize+3)*2)+self.ys,
        WA_TITLE,       self.title,
        WA_CUSTOMSCREEN,self.scr,
        WA_AUTOADJUST,  TRUE,
        WA_FLAGS,       IF title=NIL THEN WFLG_NOCAREREFRESH ELSE WFLG_NOCAREREFRESH OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_DRAGBAR ,
        NIL,            NIL])

     IF self.wnd=NIL THEN RETURN NIL
      self.update:=1
       self.render()
ENDPROC TRUE

PROC end()      OF progresswin
  IF (self.wnd<>NIL)    THEN CloseWindow(self.wnd)
 IF (self.iswb=1)       THEN UnlockPubScreen(NIL,self.scr)
ENDPROC

PROC set(val,status=NIL,action=NIL)     OF progresswin
 IF (val>=0) AND (val<=100)
  self.value:=val
   IF (status<>NIL)
    self.status:=status
    self.update:=1
   ENDIF
   IF (action<>NIL)
    self.action:=action
    self.update:=1
   ENDIF
  RETURN self.render()
 ENDIF
ENDPROC NIL

PROC get()      OF progresswin          IS self.value

PROC render()   OF progresswin
 DEF    rport=0,                                -> RastPort-Adresse
        width=0,                                -> Länge des Gauge-Balkens (innen)
        ox=0,oy=0                               -> Offsetx, offsety
  IF (self.wnd<>NIL)
   rport:=self.wnd.rport
    stdrast:=rport
      SetAPen(rport,1)                          -> schwarz
       Move(rport,self.x,self.y+self.ys)                        -> x----------x <- Ende                 -.
       Draw(rport,self.x,self.y)                                -> |                                      \
       Draw(rport,self.x+self.xs,self.y)                        -> x <- Start                             (
      SetAPen(rport,2)                                          ->     weiß                                > Rahmen zeichnen
       Move(rport,self.x+self.xs,self.y+1)                      -> Ende       x <- Start (+1 Pixel!)      (
       Draw(rport,self.x+self.xs,self.y+self.ys)                -> \/         |                           /
       Draw(rport,self.x+1,self.y+self.ys)                      -> x----------x                         -'
      SetBPen(rport,self.bpen)
      SetAPen(rport,self.bpen)
        width:=((self.xs*self.value)/100)-self.space
         RectFill(rport,self.x+1+self.space,self.y+1+self.space,self.x+width-1,self.y+self.ys-self.space-1)
        SetAPen(rport,0)
        SetBPen(rport,0)
         RectFill(rport,self.x+width+1+self.space,self.y+1,self.x+self.xs-1,self.y+self.ys-1) -> Sanftes Scrolling, weil nur der "überflüssige" Bereich gelöscht wird
          ox:=self.x+((self.xs-(self.xs/3))/2)
           oy:=self.y+self.ys-6
        stdrast:=rport
         SetABPenDrMd(rport,self.fpen,0,RP_JAM1)
          TextF(ox,oy,'\d[3] %',self.value)

       IF self.update=1
        SetAPen(rport,0)
        RectFill(rport,9,(self.tattr.ysize*2)+(self.tattr.ysize/2),self.wnd.width-22,(self.tattr.ysize)+(self.tattr.ysize/2))
        RectFill(rport,9,self.wnd.height-(self.tattr.ysize*2)+2,self.wnd.width-22,self.wnd.height-self.tattr.ysize+2)
         SetAPen(rport,1)
          TextF(10,(self.tattr.ysize*2)+(self.tattr.ysize/2),'\s',self.action)
          TextF(10,self.wnd.height-self.tattr.ysize,'\s',self.status)
         SetAPen(rport,2)
          TextF( 9,(self.tattr.ysize*2)+(self.tattr.ysize/2)-1,'\s',self.action)
         SetDrMd(rport,RP_JAM2)
       ENDIF
      self.update:=0
  ELSE
   RETURN NIL
  ENDIF
ENDPROC TRUE
