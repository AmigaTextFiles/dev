MODULE 'ptreplay', 'libraries/ptreplay','dos/dos'

DEF mod:PTR TO module
DEF sigbit[1]:ARRAY OF CHAR
DEF sigmask:LONG
DEF signals:LONG

PROC main()

IF arg[]<1
  WriteF('no module specified\n')
  RETURN
ENDIF

IF ptreplaybase:=OpenLibrary('ptreplay.library',0)

  mod:=PtLoadModule('dh1:mod.axelf')
  IF mod=0
    WriteF('couldnt open module\n')
    CloseLibrary(ptreplaybase)
    RETURN
  ELSE
    sigbit:=AllocSignal(-1)
    IF sigbit=-1
      WriteF('unable to allocate signal\n')
      CloseLibrary(ptreplaybase)
      RETURN
    ENDIF
    
    PtInstallBits(mod,sigbit,-1,-1,-1)
  
    PtPlay(mod)
    
    signals:=Shl(1,sigbit)
    WriteF('CTRL C to finish\n')
    sigmask:=Wait(SIGBREAKF_CTRL_C OR signals)

    PtStop(mod)
    PtUnloadModule(mod)
    FreeSignal(sigbit)
  ENDIF
  CloseLibrary(ptreplaybase)
ELSE
  WriteF('couldnt open library\n')
ENDIF

ENDPROC