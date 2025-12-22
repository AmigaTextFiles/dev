MODULE '*dd_filenotify'
MODULE 'dos/dos'

PROC main()
  DEF prefsnotify:PTR TO filenotify
  DEF mask
  NEW prefsnotify.new('SYS:')
  mask:=Wait(SIGBREAKF_CTRL_C OR
       prefsnotify.signalmask())
  IF mask AND SIGBREAKF_CTRL_C
    PrintF('quit.\n')
    CleanUp()
  ENDIF
  IF mask AND prefsnotify.signalmask()
    PrintF('notification.\n')
  ENDIF
  END prefsnotify
ENDPROC
