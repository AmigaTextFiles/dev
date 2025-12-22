MODULE 'dos/dos'
MODULE '*dd_timenotify'

PROC main() HANDLE
  DEF timenot:PTR TO timenotify
  DEF mask
  NEW timenot.new()
  timenot.request(5,0)
  PrintF('Press CTRL-C or just wait 5 seconds.\n')
  mask:=Wait(SIGBREAKF_CTRL_C OR timenot.signalmask())
  IF mask AND SIGBREAKF_CTRL_C
    PrintF('You breaked me.\n')
  ENDIF
  IF mask AND timenot.signalmask()
    PrintF('5 seconds timeout.\n')
  ENDIF
  END timenot
EXCEPT
  PrintF('exception was raised\n')
ENDPROC


