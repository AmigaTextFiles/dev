/* 
 *  Bitmap-Plugin
 * -=============-
 * 
 * Zeigt eine Bitmap in einem NewGUI-Fenster an!
 * 
 * 
 */

OPT MODULE
OPT OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'intuition/intuition'

EXPORT  CONST   BITMAP = PLUGIN

EXPORT  OBJECT  bitmap  OF plugin
 PRIVATE
  win           :PTR TO window                  /* PTR des Windows...                           */
  bitmap        :LONG                           /* Zu blittende Bitmap                          */
  minx          :INT                            /* Minimale Größe (Breite)                      */
  miny          :INT                            /* Minimale Größe (Höhe)                        */
  bx            :INT
  by            :INT
  resize
ENDOBJECT

PROC bitmap(x,y,bitmap,resize,bx=0,by=0) OF bitmap
 self.minx:=x
 self.miny:=y
 self.bitmap:=bitmap
 IF resize=TRUE THEN self.resize:=RESIZEXANDY ELSE 0
 self.bx:=bx
 self.by:=by
ENDPROC

PROC will_resize()               OF bitmap IS self.resize     -> In alle richtungen Vergrößerbar!

PROC min_size(x,y)               OF bitmap IS self.minx,self.miny

PROC render(a,x,y,xs,ys,win:PTR TO window)      OF bitmap 
 IF self.win=NIL
  self.win:=win
 ENDIF
  BltBitMapRastPort(self.bitmap,self.bx,self.by,win.rport,x,y,xs,ys,$c0)
ENDPROC TRUE

PROC message_test(msg:PTR TO intuimessage,win)   OF bitmap

ENDPROC FALSE                                   /* Standart -> Keine Msg für uns!               */

PROC message_action(a,b,c,win)          OF bitmap     IS TRUE

EXPORT PROC jump(x,y)                   OF bitmap
 DEF    oldx=0,
        oldy=0
  oldx:=self.bx
   oldy:=self.by
    IF x>0 THEN self.bx:=x
     IF y>0 THEN self.by:=y
      BltBitMapRastPort(self.bitmap,self.bx,self.by,self.win.rport,self.x,self.y,self.xs,self.ys,$c0)
ENDPROC oldx,oldy
