-> signals.e

-> E-Note: eCodeTask() protects an E function so you can call it from other
->         tasks and have access to the global variables of this program
MODULE 'amigalib/tasks',
       'other/ecode',
       'dos/dos'

ENUM ERR_NONE, ERR_ECODE, ERR_SIG, ERR_TASK

RAISE ERR_SIG IF AllocSignal()=-1

DEF mainsignum=-1, mainsig, wakeupsigs, maintask=NIL, subtask=NIL

PROC main() HANDLE
  DEF done=FALSE, waitingForSubtask=TRUE, ecode, subtaskname
  subtaskname:='RKM_signal_subtask'

  -> We must allocate any special signals we want to receive.
  mainsignum:=AllocSignal(-1)

  mainsig:=Shl(1, mainsignum)  -> subtask can access this global
  maintask:=FindTask(NIL)      -> subtask can access this global

  WriteF('We alloc a signal, create a task, wait for signals\n')
  IF NIL=(ecode:=eCodeTask({subtaskcode})) THEN Raise(ERR_ECODE)
  IF NIL=(subtask:=createTask(subtaskname, 0, ecode, 2000)) THEN Raise(ERR_TASK)

  WriteF('After subtask signals, press CTRL-C or CTRL-D to exit\n')

  REPEAT
    -> Wait on the combined mask for all of the signals we are interested in.
    -> All processes have the CTRL_C thru CTRL_F signals.  We're also Waiting
    -> on the mainsig we allocated for our subtask to signal us with.  We could
    -> also Wait on the signals of any ports/windows our main task created...
    wakeupsigs:=Wait(mainsig OR SIGBREAKF_CTRL_C OR SIGBREAKF_CTRL_D)

    -> Deal with all signals that woke us up - may be more than one
    IF wakeupsigs AND mainsig
      WriteF('Signalled by subtask\n')
      waitingForSubtask:=FALSE  -> OK to kill subtask now
    ENDIF
    IF wakeupsigs AND SIGBREAKF_CTRL_C
      WriteF('Got CTRL-C signal\n')
      done:=TRUE
    ENDIF
    IF wakeupsigs AND SIGBREAKF_CTRL_D
      WriteF('Got CTRL-D signal\n')
      done:=TRUE
    ENDIF
  UNTIL done AND (waitingForSubtask=FALSE)
EXCEPT DO
  IF subtask
    Forbid()
    deleteTask(subtask)
    Permit()
  ENDIF
  IF mainsignum<>-1 THEN FreeSignal(mainsignum)
  SELECT exception
  CASE ERR_SIG;   WriteF('No signals available\n')
  CASE ERR_TASK;  WriteF('Can''t create subtask\n')
  CASE ERR_ECODE; WriteF('Ran out of memory in eCodeTask()\n')
  ENDSELECT
ENDPROC

PROC subtaskcode()
  Signal(maintask, mainsig)
  Wait(NIL)  -> Safe state in which this subtask can be deleted
ENDPROC

verstag: CHAR 0, '$VER: signals 37.1 (28.3.91)', 0
