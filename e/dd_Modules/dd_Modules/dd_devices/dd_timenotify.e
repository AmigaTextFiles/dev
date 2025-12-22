OPT MODULE

MODULE 'exec/io'
MODULE 'exec/ports'
MODULE 'exec/nodes'
MODULE 'devices/timer'

ENUM EXC_MSGPORT,EXC_TIMEREQUEST,EXC_TIMERDEVICE,EXC_SIGNAL
EXPORT ENUM EXC_TIMENOTIFY

RAISE EXC_MSGPORT IF CreateMsgPort()=NIL,
      EXC_TIMEREQUEST IF CreateIORequest()=NIL,
      EXC_TIMERDEVICE IF OpenDevice()<>NIL,
      EXC_SIGNAL IF AllocSignal()=-1

-> private timerbase
DEF timerbase

EXPORT OBJECT timenotify PRIVATE
  port:PTR TO mp
  timerequest:PTR TO timerequest
ENDOBJECT

EXPORT PROC new() OF timenotify HANDLE
  -> create a port used to talk with the device
  self.port:=CreateMsgPort()
  -> create an i/o request, the message we talk with to the device
  self.timerequest:=CreateIORequest(self.port,SIZEOF timerequest)
  -> and open the device we want to use
  OpenDevice('timer.device',UNIT_VBLANK,self.timerequest,0)
  -> set the device base for extended functions
  timerbase:=self.timerequest.io.device
EXCEPT
  -> some allocation failed
  self.end()
  Raise(EXC_TIMENOTIFY)
ENDPROC

EXPORT PROC end() OF timenotify
  -> timerequest opened?
  IF self.timerequest
    -> request not yet completed?
    IF CheckIO(self.timerequest)=0
      -> abort request
      AbortIO(self.timerequest)
      -> and wait for it to finish
      WaitIO(self.timerequest)
    ENDIF
    -> timer.device open?
    IF timerbase
      -> close timer.device
      CloseDevice(self.timerequest)
      timerbase:=NIL
    ENDIF
    -> delete request
    DeleteIORequest(self.timerequest)
    self.timerequest:=NIL
  ENDIF
  -> message port open?
  IF self.port
    -> delete message port
    DeleteMsgPort(self.port)
    self.port:=NIL
  ENDIF
ENDPROC

EXPORT PROC request(secs,micro) OF timenotify
  -> current request not finished?
  IF CheckIO(self.timerequest)=0
    -> abort request
    AbortIO(self.timerequest)
    -> and wait for it to finish
    WaitIO(self.timerequest)
  ENDIF
  self.timerequest.io.command:=TR_ADDREQUEST
  self.timerequest.time.secs:=secs
  self.timerequest.time.micro:=micro
  -> send request
  SendIO(self.timerequest)
ENDPROC self.signalmask()

EXPORT PROC signalmask() OF timenotify IS Shl(1,self.port.sigbit)
