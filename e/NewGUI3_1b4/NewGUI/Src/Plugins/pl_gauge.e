/* 
 *  Gauge-Plugin 1.2   © 1997/1998 THE DARK FRONTIER (Grundler Mathias)
 * -================-
 * 
 * Changes:
 * --------
 * 0.5: = First functionable Version (fixed width and height)
 *
 * 0.8: = Minor Bugfixes inside render() (wrong coordinates at the Border-Drawing!)
 *
 * 0.9: = BETA-Release
 *      - Gauge is now resizeable!
 *
 * 1.0: = First Realease as "useful" Plugin
 *      - Added Direction-Flag (now you are able to choose between Vertiacal and Horizontal Gauge)
 *      - Gauge-state now no longer in Pixel (this could destroy the GUI at some reasons!),
 *        now only percents (0-100) allowed!!
 *
 * 1.1: = New Features added
 *      - User definable colors for the Gaugebar and the Text inside
 *      - Now you cold turn on/off the text inside!
 *
 * 1.2: = New Features added
 *      - smooth scrolling, now only the really unneeded Area are cleared (filled in Backcolor)
 * 
 * 
 */

OPT     OSVERSION = 37
OPT     PREPROCESS
OPT     MODULE

MODULE  'graphics/rastport'
MODULE  'graphics/gfx'
MODULE  'graphics/gfxmacros'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'tools/textlen'

EXPORT  CONST   GAUGE = PLUGIN

EXPORT  CONST   GAUGE_HOR  = RESIZEX,
                GAUGE_VERT = RESIZEY

EXPORT OBJECT   gauge   OF plugin
PRIVATE
 wnd            :LONG                   -> WindowPTR
 ta             :LONG                   -> Textattr - BackUP
 showtext       :LONG                   -> Text anzeigen?
 dir            :INT                    -> Lage (Direction)
 space          :INT                    -> Abstand zwischen dem Rand und dem ausgefüllten
 color          :INT                    -> Stiftfarbe
 pen            :INT                    -> Farbe des Zeichenstiftes
 state          :INT                    -> Status (Wieviel % gefüllt?)
 len            :INT                    -> Länge des Textes
ENDOBJECT

PROC gauge(backcolor=3,frontcolor=2,space=0,dir=GAUGE_HOR,initstate=0,showtext=TRUE) OF gauge
 self.color:=backcolor
  self.pen:=frontcolor
   self.space:=space
    self.dir:=dir
     self.state:=initstate
      self.showtext:=showtext
ENDPROC

PROC min_size(ta,fh)                            OF gauge
 DEF    xs,
        ys
  IF self.dir=GAUGE_HOR
   ys:=fh+4
    xs:=textlen('100 %',ta)+4
  ELSE
   ys:=fh*4
    IF self.showtext=TRUE
     xs:=textlen('100 %',ta)+4
    ELSE
     xs:=fh+4
    ENDIF
 ENDIF
  self.len:=xs
   self.ta:=ta
ENDPROC xs,ys

PROC will_resize()                              OF gauge IS self.dir

PROC render(ta,x,y,xs,ys,w:PTR TO window)       OF gauge
 DEF    str[6]:STRING,                          -> xxx %\0
        rport=0,                                -> RastPort-Adresse
        width=0,                                -> Länge des Gauge-Balkens (innen)
        ox=0,oy=0                               -> Offsetx, offsety
 IF self.wnd=NIL THEN self.wnd:=w
  rport:=w.rport
   stdrast:=rport
      SetAPen(rport,1)                          -> schwart
       Move(rport,x,y+ys)                       -> x----------x <- Ende                 -.
       Draw(rport,x,y)                          -> |                                      \
       Draw(rport,x+xs,y)                       -> x <- Start                             (
      SetAPen(rport,2)                          ->     weiß                                > Rahmen zeichnen
       Move(rport,x+xs,y+1)                     -> Ende       x <- Start (+1 Pixel!)      (
       Draw(rport,x+xs,y+ys)                    -> \/         |                           /
       Draw(rport,x+1,y+ys)                     -> x----------x                         -'
      SetBPen(rport,self.color)
      SetAPen(rport,self.color)
       IF self.dir=GAUGE_VERT
        width:=(ys*self.state)/100
         RectFill(rport,x+1+self.space,y+1+ys+self.space-width,x+xs-self.space-1,y+ys-self.space-1)
        SetAPen(rport,0)
        SetBPen(rport,0)
         RectFill(rport,x+1,y+1,x+xs-1,y+ys-width-1)            -> Sanftes Scrolling, weil nur der "überflüssige" Bereich gelöscht wird
          ox:=x+2
           oy:=y+(ys/2)                         ->x+2,y+(ys/2))
       ELSE
        width:=((xs*self.state)/100)-self.space
         RectFill(rport,x+1+self.space,y+1+self.space,x+width-1,y+ys-self.space-1)
        SetAPen(rport,0)
        SetBPen(rport,0)
         RectFill(rport,x+width+1+self.space,y+1,x+xs-1,y+ys-1) -> Sanftes Scrolling, weil nur der "überflüssige" Bereich gelöscht wird
          ox:=x+((xs-self.len)/2)
           oy:=y+ys-4
       ENDIF      
        IF self.showtext
         stdrast:=rport
          SetABPenDrMd(rport,self.pen,0,RP_JAM1)
           TextF(ox,oy,'\d[3] %',self.state)
          SetDrMd(rport,RP_JAM2)
        ENDIF
ENDPROC

PROC set(state)                                 OF gauge
 IF state<0
  state:=0
 ELSEIF state>100
  state:=100
 ELSE
  self.state:=state
 ENDIF
  ng_setattrsA([
        NG_GUI,         self.gh,
        NG_REDRAW,      self,
        NIL,            NIL])
ENDPROC 

