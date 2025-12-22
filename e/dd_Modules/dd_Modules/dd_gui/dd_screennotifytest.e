MODULE 'dos/dos'
MODULE '*dd_screennotify'

PROC main()
  DEF screen,signals
  DEF screennotify:PTR TO dd_screennotify
  IF screen:=LockPubScreen(arg)
    NEW screennotify.new(screen)
    UnlockPubScreen(0,screen)
    signals:=Wait(screennotify.signalmask OR SIGBREAKF_CTRL_C)
    IF signals AND screennotify.signalmask
      screennotify.handle()
    ENDIF
    END screennotify
  ENDIF
ENDPROC
