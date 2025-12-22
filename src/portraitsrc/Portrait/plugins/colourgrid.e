OPT MODULE
OPT OSVERSION=39
MODULE '*work:src/portrait/easygui/easygui','intuition/intuition','graphics/view','intuition/screens','gadtools','libraries/gadtools','utility/tagitem'
CONST ERR_INTERNAL=1
CONST MAXPENS=16
EXPORT OBJECT truecolour
  alpha:CHAR
  red:CHAR
  green:CHAR
  blue:CHAR
ENDOBJECT
EXPORT OBJECT colourgrid OF plugin
PUBLIC
  width,height:CHAR
  sx:CHAR
  sy:CHAR
  palette[MAXPENS]:ARRAY OF truecolour
PRIVATE
  pens[MAXPENS]:ARRAY OF INT
  win:PTR TO window
  vis:LONG
  mousex,mousey:LONG
ENDOBJECT
PROC colgrid(width=4,height=4,pens=NIL:PTR TO truecolour) OF colourgrid
  DEF i
  self.width:=width
  self.height:=height
  FOR i:=0 TO MAXPENS-1
    self.pens[i]:=-1
  ENDFOR
  IF pens=NIL
    self.palette[0].red:=255
    self.palette[0].green:=255
    self.palette[0].blue:=255
    self.palette[0].alpha:=0
    self.palette[1].red:=127
    self.palette[1].green:=127
    self.palette[1].blue:=127
    self.palette[1].alpha:=0
    self.palette[2].red:=0
    self.palette[2].green:=0
    self.palette[2].blue:=0
    self.palette[2].alpha:=0
    self.palette[3].red:=255
    self.palette[3].green:=0
    self.palette[3].blue:=0
    self.palette[3].alpha:=0
    self.palette[4].red:=0
    self.palette[4].green:=255
    self.palette[4].blue:=0
    self.palette[4].alpha:=0
    self.palette[5].red:=0
    self.palette[5].green:=0
    self.palette[5].blue:=255
    self.palette[5].alpha:=0
    self.palette[6].red:=255
    self.palette[6].green:=255
    self.palette[6].blue:=0
    self.palette[6].alpha:=0
    self.palette[7].red:=0
    self.palette[7].green:=255
    self.palette[7].blue:=255
    self.palette[7].alpha:=0
    self.palette[8].red:=255
    self.palette[8].green:=0
    self.palette[8].blue:=255
    self.palette[8].alpha:=0
    self.palette[9].red:=255
    self.palette[9].green:=127
    self.palette[9].blue:=0
    self.palette[9].alpha:=0
    self.palette[10].red:=0
    self.palette[10].green:=255
    self.palette[10].blue:=127
    self.palette[10].alpha:=0
    self.palette[11].red:=127
    self.palette[11].green:=0
    self.palette[11].blue:=255
    self.palette[11].alpha:=0
    self.palette[12].red:=127
    self.palette[12].green:=255
    self.palette[12].blue:=0
    self.palette[12].alpha:=0
    self.palette[13].red:=0
    self.palette[13].green:=127
    self.palette[13].blue:=255
    self.palette[13].alpha:=0
    self.palette[14].red:=255
    self.palette[14].green:=0
    self.palette[14].blue:=127
    self.palette[14].alpha:=0
    self.palette[15].red:=255
    self.palette[15].green:=127
    self.palette[15].blue:=127
    self.palette[15].alpha:=0
  ELSE
    FOR i:=0 TO (width*height)-1
      self.palette[i].alpha:=pens[i].alpha
      self.palette[i].red:=pens[i].red
      self.palette[i].green:=pens[i].green
      self.palette[i].blue:=pens[i].blue
    ENDFOR
  ENDIF
ENDPROC
PROC getnum(x,y) OF colourgrid IS (y*self.width)+x
PROC will_resize() OF colourgrid IS RESIZEX OR RESIZEY
PROC min_size(ta,fh) OF colourgrid IS 12*self.width+(2*(self.width-1)),8*self.height+(self.height-1)
PROC gtrender(gl,vis,ta,x,y,xs,ys,win:PTR TO window) OF colourgrid
  DEF xc,yc,bw,bh,xp,yp,cn
  bw:=(xs-(2*(self.width-1)))/self.width
  bh:=(ys-(self.height-1))/self.height
  FOR xc:=0 TO self.width-1
    FOR yc:=0 TO self.height-1
      xp:=(bw*xc)+(2*xc)+x
      yp:=(bh*yc)+yc+y
      DrawBevelBoxA(win.rport,xp,yp,bw,bh,[IF (self.sx=xc) AND (self.sy=yc)THEN GTBB_RECESSED ELSE TAG_IGNORE,TRUE,GT_VISUALINFO,vis,NIL])
      cn:=self.getnum(xc,yc)
      self.pens[cn]:=ObtainBestPenA(win.wscreen.viewport.colormap,Shl(self.palette[cn].red,24)+Shl(self.palette[cn].red,16)+Shl(self.palette[cn].red,8)+self.palette[cn].red,
                                                                  Shl(self.palette[cn].green,24)+Shl(self.palette[cn].green,16)+Shl(self.palette[cn].green,8)+self.palette[cn].green,
                                                                  Shl(self.palette[cn].blue,24)+Shl(self.palette[cn].blue,16)+Shl(self.palette[cn].blue,8)+self.palette[cn].blue,
                                                                  [OBP_PRECISION, PRECISION_IMAGE,
                                                                   NIL])
      SetAPen(win.rport,self.pens[cn])
      RectFill(win.rport,xp+4,yp+2,xp+bw-5,yp+bh-3)
    ENDFOR
  ENDFOR
  self.win:=win
  self.vis:=vis
ENDPROC
PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF colourgrid
  self.mousex:=imsg.mousex
  self.mousey:=imsg.mousey
  IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.mousex>=self.x) AND (imsg.mousey>=self.y) AND (imsg.mousex<(self.x+self.xs)) AND (imsg.mousey<(self.y+self.ys)) THEN RETURN TRUE
ENDPROC FALSE
PROC message_action(class,qual,code,win:PTR TO window) OF colourgrid
  DEF bw,bh,xc,yc,xp,yp
  IF code=SELECTDOWN
    bw:=(self.xs-(2*(self.width-1)))/self.width
    bh:=(self.ys-(self.height-1))/self.height
    FOR xc:=0 TO self.width-1
      FOR yc:=0 TO self.height-1
        xp:=(bw*xc)+(2*xc)+self.x
        yp:=(bh*yc)+yc+self.y
        IF (self.mousex>=xp) AND (self.mousey>=yp) AND (self.mousex<(xp+bw)) AND (self.mousey<(yp+bh))
          self.setselected(xc,yc)
        ENDIF
      ENDFOR
    ENDFOR
    RETURN TRUE
  ENDIF
ENDPROC FALSE
PROC clear_render(win:PTR TO window) OF colourgrid
  DEF xc,yc,cn
  FOR xc:=0 TO self.width-1
    FOR yc:=0 TO self.height-1
      cn:=self.getnum(xc,yc)
      ReleasePen(win.wscreen.viewport.colormap,self.pens[cn])
    ENDFOR
  ENDFOR
  self.win:=NIL
ENDPROC
PROC setcurrentcolour(a,r,g,b) OF colourgrid RETURN self.setcolour(self.sx,self.sy,a,r,g,b)
PROC setcolour(x,y,a,r,g,b) OF colourgrid
  DEF cn,xp,yp,bw,bh
  cn:=self.getnum(x,y)
  IF (cn<0) OR (cn>=MAXPENS) THEN Throw(ERR_INTERNAL, 101)
  IF self.pens[cn]<>-1
    ReleasePen(self.win.wscreen.viewport.colormap,self.pens[cn])
    self.pens[cn]:=-1
  ENDIF
  self.palette[cn].alpha:=a
  self.palette[cn].red:=r
  self.palette[cn].green:=g
  self.palette[cn].blue:=b
  IF self.win
    self.pens[cn]:=ObtainBestPenA(self.win.wscreen.viewport.colormap,Shl(self.palette[cn].red,24)+Shl(self.palette[cn].red,16)+Shl(self.palette[cn].red,8)+self.palette[cn].red,
                                                                     Shl(self.palette[cn].green,24)+Shl(self.palette[cn].green,16)+Shl(self.palette[cn].green,8)+self.palette[cn].green,
                                                                     Shl(self.palette[cn].blue,24)+Shl(self.palette[cn].blue,16)+Shl(self.palette[cn].blue,8)+self.palette[cn].blue,
                                                                     [OBP_PRECISION, PRECISION_IMAGE,
                                                                      NIL])
    bw:=(self.xs-(2*(self.width-1)))/self.width
    bh:=(self.ys-(self.height-1))/self.height
    xp:=(bw*x)+(2*x)+self.x
    yp:=(bh*y)+y+self.y
    SetAPen(self.win.rport,self.pens[cn])
    RectFill(self.win.rport,xp+4,yp+2,xp+bw-5,yp+bh-3)
  ENDIF
ENDPROC
PROC getcurrentcolour(argb:PTR TO truecolour) OF colourgrid
  DEF cn
  cn:=self.getnum(self.sx,self.sy)
  argb.alpha:=self.palette[cn].alpha
  argb.red:=self.palette[cn].red
  argb.green:=self.palette[cn].green
  argb.blue:=self.palette[cn].blue
ENDPROC
PROC setselected(x,y) OF colourgrid
  DEF xc,yc,bw,bh,xp,yp
  IF self.win
    bw:=(self.xs-(2*(self.width-1)))/self.width
    bh:=(self.ys-(self.height-1))/self.height
    xp:=(bw*self.sx)+(2*self.sx)+self.x
    yp:=(bh*self.sy)+self.sy+self.y
    DrawBevelBoxA(self.win.rport,xp,yp,bw,bh,[GT_VISUALINFO,self.vis,NIL])
  ENDIF
  self.sx:=x
  self.sy:=y
  IF self.win
    bw:=(self.xs-(2*(self.width-1)))/self.width
    bh:=(self.ys-(self.height-1))/self.height
    xp:=(bw*self.sx)+(2*self.sx)+self.x
    yp:=(bh*self.sy)+self.sy+self.y
    DrawBevelBoxA(self.win.rport,xp,yp,bw,bh,[GTBB_RECESSED,TRUE,GT_VISUALINFO,self.vis,NIL])
  ENDIF
ENDPROC
