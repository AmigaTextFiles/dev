OPT     MODULE
OPT     OSVERSION = 37

MODULE  'newgui/newgui'

EXPORT PROC ng_dnd_xchange(self:PTR TO plugin,called=FALSE,action=DND_ACT_NONE) -> Datenaustausch-Prozedur...
 DEF    buffer=NIL,
        delete=FALSE
  IF called=FALSE                                               -> Wenn wir nicht von einem anderen dnd_xchange() aufgerufen wurden...
   action:=self.dnd_dest.dnd_xchange(self,TRUE)                 -> Das Exchange der gegenstelle aufrufen... und eigenen PTR (Plugin) übergeben
    IF Odd(action)                                              -> Wenn action ungerade ist (dann muß DELETE dabei sein!)
     action:=action-1                                           -> DND_ACT_DELETE abziehen!
      delete:=TRUE
    ENDIF
    IF (action=DND_ACT_TAKE)                                    -> Wir sollen Daten übernehmen...
     self.dnd_info:=self.dnd_dest.dnd_info
      self.dnd_text:=self.dnd_dest.dnd_text
       self.dnd_textlen:=self.dnd_dest.dnd_textlen
       self.dnd_selectimage:=self.dnd_dest.dnd_selectimage
      self.dnd_image:=self.dnd_dest.dnd_image
     self.dnd_data:=self.dnd_dest.dnd_data
    ELSEIF (action=DND_ACT_PUT)                                 -> Wir übergeben unsere Daten!
     self.dnd_dest.dnd_info:=self.dnd_info
      self.dnd_dest.dnd_text:=self.dnd_text
       self.dnd_dest.dnd_textlen:=self.dnd_textlen
       self.dnd_dest.dnd_selectimage:=self.dnd_selectimage
      self.dnd_dest.dnd_image:=self.dnd_image
     self.dnd_dest.dnd_data:=self.dnd_data
    ELSEIF (action=DND_ACT_XCHANGE)                             -> Daten austauschen...
     buffer:=self.dnd_info
     self.dnd_info:=self.dnd_dest.dnd_info
     self.dnd_dest.dnd_info:=buffer
      buffer:=self.dnd_text
      self.dnd_text:=self.dnd_dest.dnd_text
      self.dnd_dest.dnd_text:=buffer
       buffer:=self.dnd_textlen
       self.dnd_textlen:=self.dnd_dest.dnd_textlen
       self.dnd_dest.dnd_textlen:=buffer
      buffer:=self.dnd_selectimage
      self.dnd_selectimage:=self.dnd_dest.dnd_selectimage
      self.dnd_dest.dnd_selectimage:=buffer

      buffer:=self.dnd_image
      self.dnd_image:=self.dnd_dest.dnd_image
      self.dnd_dest.dnd_image:=buffer
     buffer:=self.dnd_data
     self.dnd_data:=self.dnd_dest.dnd_data
     self.dnd_dest.dnd_data:=buffer
    ELSEIF (action=DND_ACT_RUNPROC)                             -> Prozedur des Destination-Plugins aufrufen (meistens eine Dropbox!)
     IF (buffer:=self.dnd_dest.dnd_proc)
      buffer(self)                                              -> PTR auf unser Plugin als Argument (self.dnd_dest = eigener PTR der Prozedur zum Plugin!)
     ENDIF
    ENDIF
    IF delete                                                   -> DND_ACT_DELETE = 1 !!!
     self.dnd_info:=DND_INFO_NODATA
      self.dnd_text:=NIL
       self.dnd_textlen:=0
       self.dnd_selectimage:=NIL
      self.dnd_image:=NIL
     self.dnd_data:=NIL
    ENDIF
  ENDIF
ENDPROC action                                                  -> Unbedingt action zurückgeben!

