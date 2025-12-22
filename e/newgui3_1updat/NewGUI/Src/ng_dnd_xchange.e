OPT     MODULE
OPT     OSVERSION = 37

MODULE  'newgui/newgui'

EXPORT PROC ng_dnd_xchange(self:PTR TO plugin,called=FALSE,action=DND_ACT_NONE) -> Data-Exchange-Procedure
 DEF    buffer=NIL,
        delete=FALSE
  IF called=FALSE                                               -> IF we were NOT called by an other dnd_xchange()-Procedure
   action:=self.dnd_dest.dnd_xchange(self,TRUE)                 -> then call the dnd_xchange()-Procedure from the other Plugin
    IF Odd(action)                                              -> If action-value is odd then Delete should be active!
     action:=action-1                                           -> Sub 1 (for delete) to get the right Value
      delete:=TRUE                                              -> Set the delete-Flag to TRUE
    ENDIF
    IF (action=DND_ACT_TAKE)                                    -> We should take all Data from the other Plugin...
     self.dnd_info:=self.dnd_dest.dnd_info
      self.dnd_text:=self.dnd_dest.dnd_text
       self.dnd_textlen:=self.dnd_dest.dnd_textlen
       self.dnd_selectimage:=self.dnd_dest.dnd_selectimage
      self.dnd_image:=self.dnd_dest.dnd_image
     self.dnd_data:=self.dnd_dest.dnd_data
    ELSEIF (action=DND_ACT_PUT)                                 -> The other Plugin wants our Data
     self.dnd_dest.dnd_info:=self.dnd_info
      self.dnd_dest.dnd_text:=self.dnd_text
       self.dnd_dest.dnd_textlen:=self.dnd_textlen
       self.dnd_dest.dnd_selectimage:=self.dnd_selectimage
      self.dnd_dest.dnd_image:=self.dnd_image
     self.dnd_dest.dnd_data:=self.dnd_data
    ELSEIF (action=DND_ACT_XCHANGE)                             -> The Datas should been exchanged by another
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
    ELSEIF (action=DND_ACT_RUNPROC)                             -> We should call the Procedure from the other plugin (maybe a drop-Call!)
     IF (buffer:=self.dnd_dest.dnd_proc)
      buffer(self)                                              -> We give a PTR to our Plugin as argument (the procedure could get the PTR to his plugin by self.dnd_dest)
     ENDIF
    ENDIF
    IF delete                                                   -> If delete-Flag is set...
     self.dnd_info:=DND_INFO_NODATA                             -> Set the NO-DATA Flag and clear all Data-Variables!
      self.dnd_text:=NIL
       self.dnd_textlen:=0
       self.dnd_selectimage:=NIL
      self.dnd_image:=NIL
     self.dnd_data:=NIL
    ENDIF
  ENDIF
ENDPROC action                                                  -> Our own Action-Code (DND_ACT_xxx) as return code (IMPORTANT!)

