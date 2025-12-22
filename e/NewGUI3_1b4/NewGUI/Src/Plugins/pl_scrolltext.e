OPT     OSVERSION = 37
OPT     MODULE

MODULE  'graphics/rastport'
MODULE  'graphics/gfx'
MODULE  'graphics/text'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'

OBJECT   scrollline
 succ           :PTR TO scrollline
 pred           :PTR TO scrollline
 text           :PTR TO CHAR
 color          :INT
 mode           :INT
ENDOBJECT

EXPORT OBJECT scrolltext OF plugin
PRIVATE
 textlist       :PTR TO scrollline
 lastline       :PTR TO scrollline
 actline        :PTR TO scrollline
 doit           :LONG
 fh             :INT
 speed          :INT
 counter        :INT
 minx           :INT
 miny           :INT
 lines          :INT
ENDOBJECT

EXPORT  CONST   SCROLLTEXT = PLUGIN

EXPORT  ENUM    SCRTXT_LEFT=1,
                SCRTXT_CENTER,
                SCRTXT_RIGHT,
                SCRTXT_SPACE,
                SCRTXT_BAR

ENUM    LIST_COLOR=1,                           -> Anzahl der Items in einer Liste die zusammengehören (derzeit: COLOR,MODE,STR)
        LIST_MODE,
        LIST_STR,
        LIST_ITEMS

PROC addline(str,color,mode,pos=-1) OF scrolltext
 DEF    list   :PTR TO scrollline,
        newline:PTR TO scrollline,
        counter=0
  list:=self.textlist
   NEW newline
    newline.text:=str
    newline.color:=color
    newline.mode:=mode
     IF self.textlist=NIL
      self.textlist:=newline
      self.lastline:=newline
     ELSE
      IF pos=-1                          -> Am Ende hinzufügen
        IF (self.lastline<>NIL) THEN self.lastline.succ:=newline
         newline.pred:=self.lastline
        self.lastline:=newline
      ELSE
       WHILE (list<>NIL)
        EXIT (counter=pos)
         list:=list.succ
       counter++
       ENDWHILE
        IF (counter=pos) OR (pos=-1)
         list.pred.succ:=newline
          newline.pred:=list.pred
           newline.succ:=list
          list.pred:=newline
          IF self.lastline=NIL THEN self.lastline:=newline
        ELSE                             -> Position ungültig!
         END newline
          RETURN FALSE
        ENDIF
      ENDIF
     ENDIF
ENDPROC TRUE

PROC remline(pos=-1) OF scrolltext
 DEF    list:PTR TO scrollline,
        counter=0
  list:=self.textlist
   WHILE (list<>NIL)
    IF counter=pos
     list.succ.pred:=list.pred
      list.pred.succ:=list.succ
     END list
    ENDIF
      EXIT counter=pos
     list:=list.succ
    counter++
   ENDWHILE
  IF counter<>pos THEN RETURN FALSE
ENDPROC TRUE

PROC setspeed(spd)      OF scrolltext
 IF spd>self.fh THEN self.speed:=self.fh ELSE self.speed:=spd
ENDPROC 

PROC jumpline(pos)      OF scrolltext
 DEF    list:PTR TO scrollline,
        counter=0
  list:=self.textlist
   WHILE (list<>NIL)
    EXIT counter=pos
     counter++
    list:=list.succ
   ENDWHILE
    IF counter=pos
     self.actline:=list
    ELSE
     RETURN FALSE
    ENDIF
ENDPROC TRUE

PROC scrolltext(text,speed,minx,miny) OF scrolltext
 DEF    str,
        mode=0,
        color=1,
        counter=-1
  IF speed>self.fh THEN self.speed:=self.fh ELSE self.speed:=speed
   WHILE (color:=ListItem(text,counter+LIST_COLOR))
     mode:=ListItem(text,counter+LIST_MODE)
     str:=ListItem(text,counter+LIST_STR)
    self.addline(str,color,mode,-1)
     counter:=counter+(LIST_ITEMS-1)
   ENDWHILE
  self.actline:=self.textlist
  self.minx:=minx
   self.miny:=miny
ENDPROC

PROC end() OF scrolltext
 DEF    list:PTR TO scrollline,
        next=NIL
  list:=self.textlist
   WHILE (list<>NIL)
    next:=list.succ
     END list
    list:=next
   ENDWHILE
ENDPROC

PROC disable(bool)      OF scrolltext 
 self.dis:=bool
ENDPROC
PROC min_size(ta,fh)    OF scrolltext
 self.fh:=fh
ENDPROC self.minx,(fh*self.miny+4)

PROC will_resize()      OF scrolltext IS RESIZEXANDY

PROC render(ta:PTR TO textattr,x,y,xs,ys,w:PTR TO window)     OF scrolltext
 DEF    rport=NIL,
        line:PTR TO scrollline,
        counter=0
  rport:=w.rport
   SetDrMd(rport,RP_JAM1)
    SetAPen(rport,0)
     SetBPen(rport,0)
     RectFill(rport,x+1,y+1,(x+xs-1),(y+ys-1))
    line:=self.actline
     self.lines:=(ys-4)/self.fh

       WHILE counter<self.lines
        counter++
         drawline(rport,line,counter,self)
         line:=line.succ
        IF line=NIL THEN line:=self.textlist 
       ENDWHILE
      IF self.dis=FALSE
       self.actline:=self.actline.succ
       IF self.actline=NIL THEN self.actline:=self.textlist
      ENDIF
     self.counter:=0
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF scrolltext
 IF self.dis=FALSE
  IF self.counter>=self.fh
   self.doit:=1
  ELSE
   self.doit:=2
  ENDIF
 ELSE
  self.doit:=0
 ENDIF
ENDPROC FALSE

PROC drawline(rport,line:PTR TO scrollline,counter,self:PTR TO scrolltext)
 DEF    len=0,                          -> ACHTUNG!!! Länge nicht (!) in Pixel sondern in Zeichen (Bytes/Chars!)
        tex:textextent                  -> ACHTUNG!!! Nicht Dynamisch sondern fester Speicher!!!

  IF line.mode=SCRTXT_BAR
   SetAPen(rport,1)
    Move(rport,self.x+2,self.y+(self.fh*counter)-(self.fh/2))
    Draw(rport,self.x+self.xs-2,self.y+(self.fh*counter)-(self.fh/2))
   SetAPen(rport,2)
    Move(rport,self.x+2,self.y+(self.fh*counter)-(self.fh/2)+1)
    Draw(rport,self.x+self.xs-2,self.y+(self.fh*counter)-(self.fh/2)+1)
  ELSE
   TextExtent(rport,line.text,StrLen(line.text),tex)
    len:=TextFit(rport,line.text,StrLen(line.text),tex,NIL,1,self.xs-2,256)
      IF line.mode=SCRTXT_CENTER
       Move(rport,self.x+2+((self.xs-tex.width)/2),self.y+(self.fh*counter))
      ELSEIF line.mode=SCRTXT_RIGHT
       Move(rport,self.x+self.xs-2-(tex.width),self.y+(self.fh*counter))
      ELSEIF line.mode=SCRTXT_LEFT
       Move(rport,self.x+2,self.y+(self.fh*counter))
      ENDIF
     SetBPen(rport,0)
    SetAPen(rport,line.color)
   Text(rport,line.text,len)
  ENDIF
ENDPROC

PROC after_reply()      OF scrolltext
 DEF    a=0,
        line:PTR TO scrollline,
        counter=0,
        rport=NIL

  IF self.doit>0
   rport:=self.gh.wnd.rport
    IF (self.doit=1)
     line:=self.actline
      self.actline:=self.actline.succ
       IF self.actline=NIL THEN self.actline:=self.textlist
        IF self.lines<=1
         SetDrMd(rport,RP_JAM1)
          SetAPen(rport,0)
          SetBPen(rport,0)
         RectFill(rport,self.x+1,self.y+1,(self.x+self.xs-1),(self.y+self.ys-1))
        ELSE
         WHILE counter<(self.lines-1)
          line:=line.succ
           IF line=NIL THEN line:=self.textlist 
          counter++
         ENDWHILE
        ENDIF
       drawline(rport,line,counter+1,self)
      self.counter:=0
    ENDIF
    FOR a:=0 TO self.speed
     IF self.lines>1 THEN ScrollRasterBF(rport,0,1,self.x+1,(self.y+2),(self.x+self.xs-2),(self.y+self.ys-2))     -> NOTE! ScrollWindowRaster() produces Trash!!
      self.counter:=self.counter+1
     EXIT self.counter=self.fh
    ENDFOR
  ENDIF
ENDPROC

