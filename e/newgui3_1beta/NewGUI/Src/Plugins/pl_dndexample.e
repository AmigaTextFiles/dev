OPT     OSVERSION = 37
OPT     MODULE

MODULE  'graphics/rastport'
MODULE  'graphics/text'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'newgui/ng_dnd_xchange'
MODULE  'newgui/ng_performdnd'
MODULE  'tools/ghost'
MODULE  'tools/textlen'

EXPORT OBJECT  dndplug OF plugin
 dnd_act:INT
 minwidth:INT
 minheight:INT
ENDOBJECT

PROC min_size(ta,fh)                            OF dndplug      IS self.minwidth,self.minheight

PROC will_resize()                              OF dndplug      IS FALSE

PROC render(ta:PTR TO textattr,x,y,xs,ys,win:PTR TO window)     OF dndplug
 DEF    len=0,
        tex:textextent
  IF (ta=NIL)                                                           -> Wenn der Aufruf von unserer eigenen Prozedur erfolgte!
   ta:=self.gh.tattr
   x:=self.x
   y:=self.y
   xs:=self.xs
   ys:=self.ys
   win:=self.gh.wnd
  ENDIF
   IF (self.dnd_image<>NIL) 
    DrawImage(win.rport,self.dnd_image,x,y)                             -> Image rendern
   ELSEIF (self.dnd_text<>NIL)
    SetABPenDrMd(win.rport,1,0,RP_JAM2)
     Move(win.rport,x,y+ta.ysize-3)
      TextExtent(win.rport,self.dnd_text,self.dnd_textlen,tex)
     len:=TextFit(win.rport,self.dnd_text,self.dnd_textlen,tex,NIL,1,xs,256)
    Text(win.rport,self.dnd_text,len)
   ENDIF
  IF self.dis=TRUE THEN ghost(win,x,y,xs,ys)
ENDPROC

PROC clear_render(win:PTR TO window)            OF dndplug               -> Unser Image lˆschen (z.B bei Window-Resizeing!
 SetABPenDrMd(win.rport,0,0,RP_JAM1)
  RectFill(win.rport,self.x,self.y,(self.x+self.xs),(self.y+self.ys))   -> Hintergrund lˆschen
ENDPROC

PROC disable(bool)                              OF dndplug               -> Unser Plugin soll disabled werden!
 DEF    len=0,
        tex:PTR TO textextent
  self.dis:=bool
   IF self.dis=TRUE
    ghost(self.gh.wnd,self.x,self.y,self.xs,self.ys)
   ELSE
    IF (self.dnd_image<>NIL)
     DrawImage(self.gh.wnd.rport,self.dnd_image,self.x,self.y)
    ELSE
     SetABPenDrMd(self.gh.wnd.rport,1,0,RP_JAM2)
      Move(self.gh.wnd.rport,self.x,self.y+self.gh.tattr.ysize-3)
       TextExtent(self.gh.wnd.rport,self.dnd_text,self.dnd_textlen,tex)
      len:=TextFit(self.gh.wnd.rport,self.dnd_text,self.dnd_textlen,tex,NIL,1,self.xs,256)
     Text(self.gh.wnd.rport,self.dnd_text,len)
    ENDIF
   ENDIF
ENDPROC

-> Drag 'N'†Drop-Spezifische Prozeduren
PROC dnd(type,img,selimg,minwidth,minheight,str,act,proc) OF dndplug    -> Dient nur zur veranschaulichung!
 self.type:=type                                                        -> Der Typ der Box (Dragbox, dropbox, drag&drop-box) MUﬂ IMMER gesetzt werden!
  self.dnd_info:=DND_INFO_NODATA                                        -> Standarttyp setzen
   IF (img<>NIL)                                                        -> Wenn ein Image ¸bergeben wurde
    self.dnd_image:=img                                                 -> Dieses ins Plugin speichern
     self.dnd_info:=DND_INFO_IMAGE                                      -> Zeigt an, daﬂ wir ein Image zum Anzeigen haben!
    IF (selimg<>NIL)
     self.dnd_selectimage:=selimg
    ELSE
     self.dnd_selectimage:=img
    ENDIF
   ENDIF
    IF (str<>NIL)                                                       -> Wenn ein String/Text angegeben wurde
     self.dnd_text:=str                                                 -> Diesen Speichern
      self.dnd_info:=self.dnd_info + DND_INFO_TEXT                      -> Und zur Info hinzuf¸gen, daﬂ ein String verf¸gbar ist!
     self.dnd_textlen:=StrLen(str)
    ENDIF
     self.dnd_proc:=proc
    self.dnd_act:=act
   self.minwidth:=minwidth
  self.minheight:=minheight
ENDPROC

PROC dnd_xchange(plug,called)      OF dndplug
 DEF    action
  action:=ng_dnd_xchange(self,called,self.dnd_act)
   IF called=FALSE
    self.clear_render(self.gh.wnd)
    self.render(NIL,0,0,0,0,NIL)                                        -> Unser Image neu rendern lassen
    self.dnd_dest.clear_render(self.dnd_dest.gh.wnd)
    self.dnd_dest.render(NIL,0,0,0,0,NIL)                               -> Anderes Image neu rendern lassen
   ENDIF
ENDPROC action

PROC  performdnd(win:PTR TO window)     OF dndplug       IS ng_performdnd(win,self)
