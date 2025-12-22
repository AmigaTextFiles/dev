OPT     OSVERSION = 37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'intuition/intuition'

EXPORT  CONST   BUSY = PLUGIN

EXPORT  ENUM    BUSY_STARTLEFT=1,
                BUSY_STARTRIGHT,
                BUSY_BOTH
                

EXPORT OBJECT busy      OF plugin
PRIVATE
 win            :LONG                   -> Window-PTR
 col            :LONG                   -> Nummer der Farbe
 elements       :LONG                   -> Anzahl an Elementen
 doit           :LONG                   ->
 dir            :INT                    -> Direction
 space          :INT                    -> Abstand vom Rand zum Busy-Balken
 height         :INT                    -> Höhe
 active         :INT                    -> Plugin aktiv?
 pos            :INT                    -> (0-10)
 both           :INT                    -> Interner Weg"weise" für BUSY_BOTHWAY
ENDOBJECT

PROC busy(color,height=2,space=0,dir=0,elements=10)    OF busy
 self.pos:=1
  self.height:=height
   self.space:=space
    self.col:=color
     IF dir=BUSY_BOTH
      self.both:=TRUE
       self.dir:=BUSY_STARTLEFT
     ELSE
      self.dir:=dir
     ENDIF
      self.elements:=elements
       self.win:=NIL
ENDPROC

PROC min_size(ta,fh)    OF busy         IS 12,4+self.height

PROC will_resize()      OF busy         IS RESIZEX

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF busy
 DEF    height
  height:=self.height
   IF self.win=NIL THEN self.win:=w
    stdrast:=w.rport
     Line(x+1, y+1,       x+xs-2,y+1       ,1)
     Line(x,   y+2,       x,     y+height+3,1)
     Line(x+1, y+height+4,x+xs-2,y+height+4,2)
     Line(x+xs,y+2,       x+xs,  y+height+3,2)
    clear(w,x,y,xs,height)
ENDPROC

PROC clear(w:PTR TO window,x,y,xs,height)
 SetAPen(w.rport,0)
 SetBPen(w.rport,0)
  RectFill(w.rport,x+1,y+2,x+xs-1,y+height+3)
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF busy 
 IF (imsg.class=IDCMP_INTUITICKS) THEN self.doit:=TRUE ELSE self.doit:=FALSE
ENDPROC FALSE

PROC after_reply()    OF busy
 DEF    pos,dir
  IF self.doit=TRUE
   pos,dir:=move(self.active,self.gh.wnd.rport,self.x,self.y,self.xs,self.pos,self.col,self.dir,self.elements,self.height,self.space,self.both)
    self.pos:=pos
   self.dir:=dir
  ENDIF
ENDPROC

PROC move(active,rport,x,y,xs,pos,col,dir,elements,height,space,both)
 DEF    len,                             -> Länge des Busy-Balkens in Pixel
        realpos
  IF active
   stdrast:=rport
    IF pos<elements
     pos++
    ELSE
     IF both=TRUE
      IF dir=BUSY_STARTRIGHT THEN dir:=BUSY_STARTLEFT ELSE dir:=BUSY_STARTRIGHT
     ENDIF
     pos:=1
    ENDIF
    len:=xs/elements
     IF dir=BUSY_STARTRIGHT
      IF pos=1
       realpos:=0
      ELSE
       realpos:=len*(elements-(pos-1))
      ENDIF
       SetAPen(rport,0)
       SetBPen(rport,0)
        RectFill(rport,x+realpos+1+space,y+2+space,x+realpos+len-1-space,y+height+3-space)
       realpos:=len*(elements-pos)
       SetAPen(rport,col)
       SetBPen(rport,col)
        RectFill(rport,x+realpos+1+space,y+2+space,x+realpos+len-1-space,y+height+3-space)
     ELSE
      IF pos=1
       realpos:=len*(elements-1)
      ELSE
       realpos:=len*(pos-2)
      ENDIF
       SetAPen(rport,0)
       SetBPen(rport,0)
        RectFill(rport,x+realpos+1+space,y+2+space,x+realpos+len-1-space,y+height+3-space)
       realpos:=len*(pos-1)
       SetAPen(rport,col)
       SetBPen(rport,col)
        RectFill(rport,x+realpos+1+space,y+2+space,x+realpos+len-1-space,y+height+3-space)
     ENDIF
   ENDIF
ENDPROC pos,dir

PROC active(value)      OF busy
 self.active:=value
  IF value=FALSE
   clear(self.win,self.x,self.y,self.xs,self.height)
  ENDIF
 self.pos:=1
ENDPROC value
