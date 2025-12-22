
OPT OSVERSION=37

MODULE 'dos/notify'

PROC main()
  DEF nreq:PTR TO notifyrequest,sig,task
  IF (FileLength(arg)=-1) OR (arg[0]=0)     /* never be notified */
    WriteF('file \"\s\" does not exist\n',arg)
    Raise(10) ->CleanUp(10)
  ENDIF
  NEW nreq    /* memory is cleared */
  sig:=AllocSignal(-1)                /* we want to be signalled */
  IF sig=-1 THEN RETURN 10
  task:=FindTask(0)
  nreq.name:=arg                      /* fill in structure */
  nreq.flags:=NRF_SEND_SIGNAL
  nreq.port:=task                     /* union port/task */
  nreq.signalnum:=sig
  IF StartNotify(nreq)
    WriteF('Now watching: \"\s\"\n',arg)
    Wait(Shl(1,sig))
    EasyRequestArgs(0,[20,0,0,'File %s modified!','Damn!'],0,[arg])
    EndNotify(nreq)
  ELSE
    WriteF('Could not watch \"\s\".\n',arg)
  ENDIF
  FreeSignal(sig)
ENDPROC
