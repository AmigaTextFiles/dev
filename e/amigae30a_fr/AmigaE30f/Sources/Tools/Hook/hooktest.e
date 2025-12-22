-> test hooks

MODULE 'utility', 'utility/hooks', 'tools/installhook'

PROC main()
  DEF myhook:hook
  IF utilitybase:=OpenLibrary('utility.library',37)
    installhook(myhook,{myfunction})
    CallHookPkt(myhook,1,2)
    CloseLibrary(utilitybase)
  ENDIF
ENDPROC

PROC myfunction(hook,obj,msg)
  WriteF('hook: $\h, obj: \d, msg: \d\n',hook,obj,msg)
ENDPROC
