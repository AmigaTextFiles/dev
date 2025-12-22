->
-> dd_windowcontrol.e - window control class
->
-> Copyrights © 1995 by Leon `LikeWise' Woestenberg, Digital Disturbance.
-> All Rights Reserved
->
-> FOLDER opts
OPT MODULE
-> ENDFOLDER
-> FOLDER modules
MODULE 'intuition/intuition'
MODULE '*dd_busypointer'
-> ENDFOLDER
-> FOLDER classes
-> window control class definition
EXPORT OBJECT dd_windowcontrol
  PRIVATE
  window:PTR TO window
  idcmpflags:LONG
  disablecount:LONG
  blockrequester:PTR TO requester
  busypointer:PTR TO busypointer
ENDOBJECT
-> ENDFOLDER

-> FOLDER new
-> constructor
EXPORT PROC new(window=NIL) OF dd_windowcontrol
  -> Remember the window this object must act on.
  self.window:=window
  -> Counter to keep the number of nested disable calls.
  self.disablecount:=0
  -> Get ourselves a busypointer object.
  NEW self.busypointer.new(self.window)
ENDPROC
-> ENDFOLDER
-> FOLDER end
-> destructor
EXPORT PROC end() OF dd_windowcontrol
  -> If the program exits prematurely, we call enable here for each
  -> outstanding disable call. This should never occur (!).
  WHILE self.disablecount DO self.enable()
  END self.busypointer
ENDPROC
-> ENDFOLDER
-> FOLDER disable
EXPORT PROC disable(disableidcmpflags=IDCMP_REFRESHWINDOW) OF dd_windowcontrol
  -> Only act if this is a valid instance. This makes it safe to invoke
  -> this method on a NIL pointer.
  IF self

    -> valid window?
    IF self.window

      -> We keep a disable count, to allow nested calls.
      self.disablecount:=self.disablecount+1
      -> We only have to act if the window first enters busy state, i.e. when
      -> the count becomes 1. If the count was higher, the window already is
      -> in disabled state, and we just skip.
      IF self.disablecount=1

        -> Remember the IDCMP flags of the enabled window.
        self.idcmpflags:=self.window.idcmpflags
        -> Now clear some IDCMP flags.
        ModifyIDCMP(self.window,disableidcmpflags AND self.idcmpflags)

        -> Attach an invisible requester, that blocks user input.
        InitRequester(NEW self.blockrequester)
        Request(self.blockrequester,self.window)

        -> Put the busypointer object into busy state.
        self.busypointer.busy()
      ENDIF
    ENDIF
  ENDIF
ENDPROC
-> ENDFOLDERER
-> FOLDER enable
EXPORT PROC enable() OF dd_windowcontrol

  -> Only act if this is a valid instance. This makes it safe to invoke
  -> this method on a NIL pointer.
  IF self

    -> valid window?
    IF self.window

      -> We decrease the disable count by one. If this window is going into
      -> disable state now, we act. Otherwise, the window still has a nested
      -> disable call pending.
      self.disablecount:=self.disablecount-1
      IF self.disablecount=0

        -> Get busypointer object out of busy state.
        self.busypointer.unbusy()

        -> We detach the block requester.
        EndRequest(self.blockrequester,self.window)
        END self.blockrequester

        -> Restore the IDCMP flags to those prior to disable.
        ModifyIDCMP(self.window,self.idcmpflags)

      ENDIF
    ENDIF
  ENDIF
ENDPROC
-> ENDFOLDER

