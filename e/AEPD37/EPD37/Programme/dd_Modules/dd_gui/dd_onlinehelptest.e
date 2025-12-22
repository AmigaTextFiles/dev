MODULE '*dd_onlinehelp'
MODULE 'dos/dos'

PROC main()
  DEF help:PTR TO onlinehelp
  DEF signals

  NEW help.new('dd_onlinehelptest2.guide','ONLINEHELPTEST_HELP','OnlineHelpTest',['main','node1','node2',0])

  PrintF('Use CTRL-D and CTRL-E to simulate user contexts. See doc.\n')
  PrintF('Use CTRL-F to call for help, CTRL-C to quit.\n')

  -> main program loop
  WHILE TRUE
    -> wait for user input
    signals:=Wait(help.signalmask OR
                  SIGBREAKF_CTRL_C OR
                  SIGBREAKF_CTRL_D OR
                  SIGBREAKF_CTRL_E OR
                  SIGBREAKF_CTRL_F)

    -> handle arrived guide messages
    IF signals AND help.signalmask THEN help.handle()

    -> Ctrl-D is a 'user context' here. In full blown applications, this
    -> is actually the user activating a window etc. See docs.
    IF signals AND SIGBREAKF_CTRL_D
      help.setcontext(1)
    ENDIF

    -> Ctrl-E is another 'user context' here.
    IF signals AND SIGBREAKF_CTRL_E
      help.setcontext(2)
    ENDIF

    -> Ctrl-F calls for help, and thus simulates the HELP key here
    IF signals AND SIGBREAKF_CTRL_F
      -> this should be called when the user pressed 'help' or similar
      help.help()
    ENDIF

    -> Ctrl-C quits
    EXIT (signals AND SIGBREAKF_CTRL_C)
  ENDWHILE
  help.close()
  END help
ENDPROC
