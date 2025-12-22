OPT MODULE

MODULE 'dos/dos',
       'dos/notify'

ENUM EXC_SIGNAL,EXC_FILENOTIFY

RAISE EXC_SIGNAL IF AllocSignal()=-1

EXPORT OBJECT filenotify PRIVATE
  notifyrequest:notifyrequest
  signalmask:LONG
ENDOBJECT

EXPORT PROC new(name) OF filenotify HANDLE
  self.notifyrequest.signalnum:=AllocSignal(-1)
  self.notifyrequest.name:=name
  self.notifyrequest.flags:=NRF_SEND_SIGNAL
  self.notifyrequest.task:=FindTask(0)
  self.signalmask:=Shl(1,self.notifyrequest.signalnum)
  StartNotify(self.notifyrequest)
EXCEPT
  -> some allocation failed
  Raise(EXC_FILENOTIFY)
ENDPROC self.signalmask()

EXPORT PROC signalmask() OF filenotify IS self.signalmask

EXPORT PROC end() OF filenotify
  EndNotify(self.notifyrequest)
  IF self.notifyrequest.signalnum<>-1
    FreeSignal(self.notifyrequest.signalnum)
    self.signalmask:=0
  ENDIF
ENDPROC
