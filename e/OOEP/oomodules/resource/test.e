MODULE  'oomodules/resource',
        'oomodules/object',
        'oomodules/file/textfile/programsource'

PROC main()
/****** /main ******************************

    NAME
        main() --

    SYNOPSIS
        main()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO

********/
DEF resource1:PTR TO resource,
    resource2:PTR TO resource,
    object1:PTR TO object,
    object2:PTR TO object,

    ps:PTR TO programSource

  NEW object1.new()
  NEW object2.new()

  NEW ps.new()

  NEW resource1.new([object1,FindTask(NIL),0])
  NEW resource2.new([ps,FindTask(NIL),0])

  resource2.sendMessageToMaster(RCMD_INFO)

  resource2.sendMessageToMaster(RCMD_END,resource1)

  resource2.sendMessageToMaster(RCMD_END,resource2)

ENDPROC

