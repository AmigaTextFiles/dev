/* 
 *  Register-Plugin 1.0
 * -===================-
 * 
 * Planned:
 * --------
 *      - Flexible Text-Length (width graphics/textextent-functions...)
 *      - Image-Support (only to see if there is enaugh space to show it in right of the text (right-aligned))
 */

OPT     OSVERSION = 37
OPT     MODULE

MODULE  'intuition/intuition'
MODULE  'graphics/rastport'
MODULE  'newgui/newgui'
MODULE  'tools/textlen'

EXPORT  CONST   REGISTER = PLUGIN

EXPORT  ENUM    REG_ABOVE = 0,
                REG_LEFT

EXPORT OBJECT  register        PRIVATE                                  OF plugin
 list                   :PTR TO LONG
 width                  :INT
 height                 :INT
 fh                     :INT
 num                    :INT
 dir                    :INT
 active                 :INT
 text3d                 :INT
 showbar                :INT
 max                    :INT
ENDOBJECT

PROC register(registerlist,active=0,text3d=TRUE,direction=REG_ABOVE,showbar=TRUE)       OF register
 DEF    item=0
  self.list := registerlist
   WHILE ListItem(registerlist,item*2)
    item:=item+1
   ENDWHILE
    self.num:=item
     self.dir:=direction
    self.active:=1
   self.text3d:=IF text3d=FALSE THEN 0 ELSE 1
  self.active:=active
 self.showbar:=IF showbar=FALSE THEN 0 ELSE 1
ENDPROC

PROC min_size(ta,fh)                                            OF register
 DEF    width=0,
        height=0,
        item=NIL,
        counter,
        buffer=0,
        image=NIL:PTR TO image
  IF self.dir = REG_ABOVE
   height:=fh+6
    FOR counter:=0 TO self.num
     image:=ListItem(self.list,(counter*2)+1)
      item:=ListItem(self.list,counter*2)
       width:=width+textlen(item,ta)+2
     IF (image<>NIL)
      width:=width+image.width+2
      IF (image.height+2>height) THEN height:=image.height+4
     ENDIF
    ENDFOR
   width:=width + (self.num*8)                                  -> 8 = space between the register elements for the box around ect...
  ELSE                                                          -> Find the bigest String and save its length as maxwidth
   FOR counter:=0 TO self.num
    image:=ListItem(self.list,(counter*2)+1)
     item:=ListItem(self.list,counter*2)
      buffer:=textlen(item,ta)+8
       IF (image<>NIL) THEN buffer:=buffer+image.width+4
     IF (buffer>width) THEN width:=buffer
    IF (image<>NIL)
     IF ((image.height+8)>self.max)
      self.max:=image.height+4
     ENDIF
    ENDIF
   ENDFOR
    width:=width + 8
   height:=self.max*counter
  ENDIF
 self.width:=width
 self.height:=height
 self.fh:=fh
 IF self.max=0 THEN self.max:=self.fh+6
ENDPROC width,height

PROC will_resize()                                              OF register
 DEF    resizemode=0
  IF self.dir=REG_ABOVE
   resizemode:=RESIZEX
  ELSE
   resizemode:=RESIZEY
  ENDIF
ENDPROC resizemode

PROC render(ta,x,y,xs,ys,w:PTR TO window)                       OF register
 DEF    item=0,
        text=NIL,
        width=0,
        height=0,
        rport=NIL,
        pos=0,
        actpos=0,
        image=NIL:PTR TO image
  IF ta=NIL
   x:=self.x
    y:=self.y
     xs:=self.xs
     ys:=self.ys
    w:=self.gh.wnd
   ta:=self.gh.tattr
  ENDIF
  actpos:=x
  rport:=w.rport
   WHILE (text:=ListItem(self.list,item*2))
    image:=ListItem(self.list,(item*2)+1)
     IF (self.dir = REG_ABOVE)
      width:=textlen(text,ta)+8
       width:=IF (xs>self.width) THEN width+((xs-self.width)/self.num) ELSE width
      IF (image<>NIL) THEN width:=width+image.width+2
      IF (item = self.active)
-> active Box
        SetAPen(rport,1)
         pos:=actpos+1
          Move(rport, pos,  y+ys)
           Draw(rport,pos,  y+2)
          Move(rport, pos+1,y+1)
           Draw(rport,pos+1,y+1)
        SetAPen(rport,2)
         pos:=actpos-2
          Move(rport, pos+4,y)
         pos:=pos+width
           Draw(rport,pos-2,y)
          Move(rport, pos-1,y+1)
           Draw(rport,pos-1,y+1)
          Move(rport, pos,  y+2)
           Draw(rport,pos,  y+ys)
-> Print the Text
         SetDrMd(rport,RP_JAM1)
          SetAPen(rport,1)
           Move(rport,pos-width+5, y+ys-((ys-self.fh)/2)+1)
            Text(rport,text,StrLen(text))

        IF (self.text3d=1)
-> Change the Frontpen to white and Print the text one pixel upper and 1 pixel right over the "old" text
         SetAPen(rport,2)
          Move(rport,pos-width+6, y+ys-((ys-self.fh)/2))
         Text(rport,text,StrLen(text))
        ENDIF
       IF (image<>NIL) THEN DrawImage(rport,image,pos-image.width-2,((ys-image.height)/2)+y)+1
      ELSE
-> inactive Box
       IF (self.showbar=1)
        SetAPen(rport,2)
         Move(rport, actpos,y+ys)
          Draw(rport,actpos+width,y+ys)
       ENDIF  
        SetAPen(rport,1)
       IF (self.showbar=1)
        Move(rport, actpos,y+ys-1)
         Draw(rport,actpos+width,y+ys-1)
       ENDIF
        pos:=actpos+1
         Move(rport, pos,  y+ys-2)
          Draw(rport,pos,  y+3)
         Move(rport, pos+1,y+2)
          Draw(rport,pos+1,y+2)
       SetAPen(rport,2)
        pos:=actpos-2
         Move(rport, pos+4,y+1)
        pos:=pos+width
          Draw(rport,pos-2,y+1)
         Move(rport, pos-1,y+2)
          Draw(rport,pos-1,y+2)
         Move(rport, pos,  y+3)
          Draw(rport,pos,  y+ys-2)
-> print the Text
         SetDrMd(rport,RP_JAM1)
          SetAPen(rport,1)
           Move(rport,pos-width+4, y+ys-((ys-self.fh)/2)+1)
            Text(rport,text,StrLen(text))
       IF (image<>NIL) THEN DrawImage(rport,image,pos-image.width-2,((ys-image.height)/2)+y+1)
      ENDIF
     ELSE
->
      width:=IF (self.height<ys) THEN ((ys-self.height)/self.num) ELSE 0
       height:=self.max+4
      IF (item = self.active)

       SetAPen(rport,1)
        pos:=((item)*(height))+y+(width*item)
         Move(rport, x+self.width-2,pos+self.max+2)
          Draw(rport,x+3,           pos+self.max+2)
         Move(rport, x+2,pos+self.max+1)
          Draw(rport,x+2,pos+self.max+1)
         Move(rport, x+1,pos+self.max)
          Draw(rport,x+1,pos+2)
       SetAPen(rport,2)
         Move(rport, x+2,pos+1)
          Draw(rport,x+2,pos+1)
         Move(rport, x+3,pos)
          Draw(rport,x+self.width-2,pos)
-> print the Text
         SetDrMd(rport,RP_JAM1)
          SetAPen(rport,1)
           Move(rport,x+4, pos+self.max-((self.max-self.fh)/2)-2)
            Text(rport,text,StrLen(text))
       IF (self.text3d=1)
          SetAPen(rport,2)
           Move(rport,x+5, pos+self.max-((self.max-self.fh)/2)-3)
            Text(rport,text,StrLen(text))
       ENDIF

        IF (image<>NIL) THEN DrawImage(rport,image,x+xs-image.width-3,((self.max-image.height)/2)+pos+2)

       IF (self.showbar=1)
         Move(rport, x+self.width-2,pos+self.max+4)
          Draw(rport,x+self.width-2,pos+self.max+2+width)
        SetAPen(rport,1)
         Move(rport, x+self.width-3,pos+self.max+4)
          Draw(rport,x+self.width-3,pos+self.max+2+width)
       ENDIF
      ELSE

       SetAPen(rport,1)
        pos:=((item)*(height))+y+(width*item)
        width:=IF (self.height<ys) THEN ((ys-self.height)/self.num) ELSE 0
         Move(rport, x+self.width-4,pos+self.max+2)
          Draw(rport,x+3,           pos+self.max+2)
         Move(rport, x+2,pos+self.max+1)
          Draw(rport,x+2,pos+self.max+1)
         Move(rport, x+1,pos+self.max)
          Draw(rport,x+1,pos+2)
       SetAPen(rport,2)
         Move(rport, x+2,pos+1)
          Draw(rport,x+2,pos+1)
         Move(rport, x+3,pos)
          Draw(rport,x+self.width-4,pos)

       IF (self.showbar=1)
         Move(rport, x+self.width-2,pos-2)
          Draw(rport,x+self.width-2,pos+self.max+2+width)
        SetAPen(rport,1)
         Move(rport, x+self.width-3,pos-2)
          Draw(rport,x+self.width-3,pos+self.max+2+width)
       ENDIF

-> print the Text
         SetDrMd(rport,RP_JAM1)
          SetAPen(rport,1)
           Move(rport,x+3, pos+self.max-((self.max-self.fh)/2)-2)
            Text(rport,text,StrLen(text))
        IF (image<>NIL) THEN DrawImage(rport,image,x+xs-image.width-3,((self.max-image.height)/2)+pos+2)

      ENDIF
     ENDIF
    actpos:=actpos+width
    item++
   ENDWHILE
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,w:PTR TO window)     OF register
 DEF    item=0,
        text=NIL,
        width=0,
        image=NIL:PTR TO image,
        actpos=0,
        height=0
  IF (imsg.code=SELECTDOWN) AND (imsg.class=IDCMP_MOUSEBUTTONS)
   IF (imsg.mousex>=self.x) AND (imsg.mousey>self.y) 
    IF (imsg.mousey<(self.y+self.ys)) AND ((imsg.mousex<self.x+self.xs))
     IF self.dir=REG_ABOVE
      actpos:=self.x
       WHILE (text:=ListItem(self.list,item*2))
        image:=ListItem(self.list,(item*2)+1)
         width:=textlen(text,self.gh.tattr)+8
          width:=IF (self.xs>self.width) THEN width+((self.xs-self.width)/self.num) ELSE width
           IF (image<>NIL) THEN width:=width+image.width+2
          IF (imsg.mousex>=actpos) AND (imsg.mousex<=(actpos+width) )
           IF (imsg.mousey>self.y) AND (imsg.mousey<(self.y+self.xs))
            self.set(item)
             RETURN TRUE
           ENDIF
          ENDIF
         actpos:=actpos+width
        item:=item+1
       ENDWHILE
     ELSE
      WHILE (text:=ListItem(self.list,item*2))
       image:=ListItem(self.list,(item*2)+1)
        height:=self.max+4
        actpos:=((item)*(height))+self.y+(((self.ys-self.height)/self.num)*item)
        IF (imsg.mousey>=actpos) AND (imsg.mousey<=(actpos+self.max))
         IF (imsg.mousex>self.x) AND (imsg.mousex<(self.x+self.xs))
          self.set(item)
           RETURN TRUE
         ENDIF
        ENDIF
       item:=item+1
      ENDWHILE
     ENDIF
    ENDIF
   ENDIF
  ENDIF
ENDPROC FALSE

PROC clear_render(w:PTR TO window)                              OF register
 DEF    rport=NIL
  rport:=w.rport
   SetAPen(rport,0)
    SetBPen(rport,0)
     RectFill(rport,self.x,self.y,self.x+self.xs,self.y+self.ys)
ENDPROC

PROC set(num)                                                   OF register
 IF (num>=0) AND (num<self.num) THEN self.active:=num ELSE RETURN FALSE
ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
ENDPROC TRUE

PROC get()                                                      OF register IS self.active
