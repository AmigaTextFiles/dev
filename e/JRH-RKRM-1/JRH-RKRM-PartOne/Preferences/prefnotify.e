-> prefnotify.e - Notified if serial prefs change
OPT PREPROCESS

MODULE 'dos/dos',
       'dos/notify'

ENUM ERR_NONE, ERR_KICK, ERR_NOTIFY, ERR_SIGNAL

RAISE ERR_NOTIFY IF StartNotify()<>DOSTRUE,
      ERR_SIGNAL IF AllocSignal()=255

#define PREFSFILENAME 'ENV:sys/serial.prefs'

PROC main() HANDLE
  DEF done=FALSE, notifyrequest=NIL:PTR TO notifyrequest,
      signum=255, signals
  -> We need at least V37 for notification
  IF KickVersion(37)=FALSE THEN Raise(ERR_KICK)
  -> Allocate a NotifyRequest structure
  NEW notifyrequest
  -> And allocate signalsbit
  signum:=AllocSignal(-1)
  -> Initialise notification request
  notifyrequest.name:=PREFSFILENAME
  notifyrequest.flags:=NRF_SEND_SIGNAL
  -> Signal this task...
  notifyrequest.task:=FindTask(NIL)

  -> ... with this signals bit
  notifyrequest.signalnum:=signum

  StartNotify(notifyrequest)
  WriteF('Select Serial Prefs SAVE or USE to notify this program\n')
  WriteF('CTRL-C to exit\n\n')
  -> Loop until Ctrl-C to exit
  REPEAT
    signals:=Wait(Shl(1, signum) OR SIGBREAKF_CTRL_C)
    IF signals AND Shl(1, signum)
      WriteF('Notification signal received.\n')
    ENDIF
    IF signals AND SIGBREAKF_CTRL_C
      EndNotify(notifyrequest)
      done:=TRUE
    ENDIF
  UNTIL done
EXCEPT DO
  IF signum<>255 THEN FreeSignal(signum)
  IF notifyrequest THEN END notifyrequest -> E-Note: not really necessary...
  SELECT exception
  CASE ERR_KICK;   WriteF('Requires at least V37\n')
  CASE ERR_NOTIFY; WriteF('Can''t start notification\n')
  CASE ERR_SIGNAL; WriteF('No signals available\n')
  CASE "MEM";      WriteF('Not enough memory for NotifyRequest.\n')
  ENDSELECT
ENDPROC

verstag: CHAR 0, '$VER: prefnot 37.1 (09.07.91)', 0