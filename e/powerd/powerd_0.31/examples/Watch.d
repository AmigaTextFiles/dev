
OPT OSVERSION=37

MODULE 'dos/notify'

PROC main()(INT)                       /* make sure file is there: else we'll */
  DEF nreq:PTR TO NotifyRequest,sig,task
  IF (FileLength(arg)=-1) OR (arg[0]=0)     /* never be notified */
    PrintF('file "\s" does not exist\n',arg)
    Exit(10)
  ENDIF
  nreq:=New(SIZEOF_NotifyRequest)     /* memory is cleared */
  IF nreq=NIL THEN RETURN 20
  sig:=AllocSignal(-1)                /* we want to be signalled */
  IF sig=-1 THEN RETURN 10
  task:=FindTask(0)
  nreq.Name:=arg                      /* fill in structure */
  nreq.Flags:=NRF_SEND_SIGNAL
  nreq.Port:=task                     /* union port/task */
  nreq.SignalNum:=sig
  IF StartNotify(nreq)
    PrintF('Now watching: "\s"\n',arg)
    Wait(Shl(1,sig))
    EasyRequestArgs(0,[20,0,0,'File "\s" modified!','Damn!'],0,[arg])
    EndNotify(nreq)
  ELSE
    PrintF('Could not watch "\s".\n',arg)
  ENDIF
  FreeSignal(sig)
ENDPROC
