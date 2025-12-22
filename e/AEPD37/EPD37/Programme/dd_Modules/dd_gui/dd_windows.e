OPT MODULE

MODULE 'intuition/intuition','dos/dos','utility/tagitem'

-> FOLD dd_window
EXPORT OBJECT dd_window
PUBLIC -> accessable from the outside
  window:PTR TO window
PRIVATE -> accessable by methods only
  idcmp:LONG
  busycount:CHAR
  busyreq:PTR TO requester
ENDOBJECT
-> ENDFOLD

-> FOLD .open(newwindow,tagitems)
->
-> dd_window.open(newwindow,tagitems)
->
EXPORT PROC open(newwindow:PTR TO nw,tagitems:PTR TO tagitem) OF dd_window
  -> temporary window
  DEF window:PTR TO window

  -> window opened?
  IF window:=OpenWindowTagList(newwindow,tagitems)

    -> set window pointer
    self.window:=window

    -> initialize private info
    self.idcmp:=self.window.idcmpflags
    self.busycount:=0
    self.busyreq:=NIL
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD busy
EXPORT PROC busy() OF dd_window
  DEF requester:PTR TO requester

  -> are we a valid instance?
  IF self

    -> window was not yet in busy state?
    IF self.busycount++=1

      -> clear all IDCMP flags, except refresh
      ModifyIDCMP(self.window,self.window.idcmpflags AND IDCMP_REFRESHWINDOW)

      -> allocate a blocking requester
      NEW self.busyreq

      -> initialize requester
      InitRequester(self.busyreq)

      -> link in the requester
      Request(self.busyreq,self.window)
    ENDIF
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD unbusy
EXPORT PROC unbusy() OF dd_window
  DEF requester:PTR TO requester

  -> are we a valid instance?
  IF self

    -> decrease busycount
    -> self.busycount:=self.busycount-1

    -> window no longer busy?
    IF self.busycount--=0

      -> unattach requester
      EndRequest(self.busyreq,self.window)

      -> deallocate requester
      END self.busyreq

      -> reset original IDCMP flags
      ModifyIDCMP(self.window,self.idcmp)

    ENDIF
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD isbusy
PROC isbusy() OF dd_window IS (self.busycount>0)
-> ENDFOLD
-> FOLD end
PROC end() OF dd_window

  -> are we a valid instance?
  IF self

    -> unbusy window if still busy
    WHILE self.isbusy() DO self.unbusy()

    -> close window
    CloseWindow(self.window)
  ENDIF
ENDPROC
-> ENDFOLD
