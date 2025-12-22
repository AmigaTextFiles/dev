OPT MODULE

MODULE 'amigaguide'
MODULE 'libraries/amigaguide'
MODULE 'utility/tagitem'

ENUM OLH_NO_ERROR,OLH_CANNOT_OPEN

DEF amigaguidebase

EXPORT OBJECT onlinehelp
PRIVATE
  -> amigaguide database information
  guide:newamigaguide
  -> handle for amigaguide
  handle
  -> current context index number
  context
PUBLIC
  -> signal mask indicates amigaguide messages
  signalmask:LONG
ENDOBJECT

EXPORT PROC new(guidefile,arexxname,basename,contextlist) OF onlinehelp
  self.guide.name:=guidefile
  self.guide.clientport:=arexxname
  self.guide.basename:=basename
  self.guide.flags:=HTF_CACHE_NODE
  self.guide.context:=contextlist
ENDPROC TRUE

EXPORT PROC end() OF onlinehelp
  self.close()
  self.context:=0
  self.signalmask:=0
ENDPROC

PROC close() OF onlinehelp
  -> amigaguide.library open?
  IF amigaguidebase
    -> amigaguide opened?
    IF self.handle
      -> close the amigaguide
      CloseAmigaGuide(self.handle)
      self.handle:=NIL
    ENDIF
    -> close the amigaguide.library
    CloseLibrary(amigaguidebase)
    amigaguidebase:=NIL
  ENDIF
ENDPROC

EXPORT PROC help() OF onlinehelp

  -> amigaguide.library not opened?
  IF amigaguidebase=NIL
    -> try to open amigaguide.library
    amigaguidebase:=OpenLibrary('amigaguide.library',34)
  ENDIF

  -> amigaguide.library open?
  IF amigaguidebase
    -> guide already open?
    IF self.handle
      -> is set context valid?
      IF SetAmigaGuideContextA(self.handle,self.context,NIL)
        -> send valid context to be displayed
        SendAmigaGuideContextA(self.handle,NIL)
      ENDIF
    -> guide is not open yet
    ELSE
      -> open the guide. note that we will be notified by a message
      -> later when the guide is actually displayed
      self.handle:=OpenAmigaGuideAsyncA(self.guide,TAG_DONE)
      -> amigaguide opened?
      IF self.handle
        -> get the signalmask for this amigaguide
        self.signalmask:=AmigaGuideSignal(self.handle)
      ELSE
        -> handle errors here
        PrintF('Could not show the online help guide.\n')
      ENDIF
    ENDIF
  ELSE
    PrintF('The amigaguide.library version 34 is not available.\n',)
  ENDIF
ENDPROC

EXPORT PROC setcontext(contextindex) OF onlinehelp
  -> just store new context
  self.context:=contextindex
ENDPROC

EXPORT PROC signalmask() OF onlinehelp IS self.signalmask

EXPORT PROC handle() OF onlinehelp
  DEF message=NIL:PTR TO amigaguidemsg
  DEF error=OLH_NO_ERROR
  -> check if there is something to handle
  IF (amigaguidebase<>NIL) AND (self.handle<>NIL)
    -> get the next amigaguide message, if any
    WHILE message:=GetAmigaGuideMsg(self.handle)
      -> guide has become active?
      IF (message.type=ACTIVETOOLID)
        -> help must have been wanted before, so call it again
        self.help()
      -> other messages
      ELSEIF (message.type=TOOLSTATUSID) OR
             (message.type=TOOLCMDREPLYID) OR
             (message.type=SHUTDOWNMSGID)
        PrintF('message.type=\d\n',message.type)
        -> primary return value indicates error?
        IF message.pri_ret
          -> you could instruct the user here
          IF message.sec_ret=HTERR_CANT_OPEN_DATABASE
            -> set the error to be acted upon later
            PrintF('setting error.\n')
            error:=OLH_CANNOT_OPEN
          -> other errors, probably just show them
          ELSE
            PrintF('AmigaGuide Error:\n\s\n',GetAmigaGuideString(message.sec_ret))
          ENDIF
        ENDIF
      ENDIF
      -> we are finished with this message, let's reply it
      ReplyAmigaGuideMsg(message)
    ENDWHILE
    -> did an error occur?
    IF error=OLH_CANNOT_OPEN
      PrintF('acting on error.\n')
      self.retry()
    ENDIF
  ENDIF
ENDPROC

PROC retry() OF onlinehelp
  -> close down the faulty amigaguide
  self.close()
  -> ask for the correct filename
  self.guide.name:='dd_onlinehelptest3.guide'
  -> if give, try again
  self.help()
ENDPROC




