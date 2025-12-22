MODULE  'oomodules/resource',
        'oomodules/object'


PROC main()
DEF resource1:PTR TO resource,
    resource2:PTR TO resource,
    object1:PTR TO object,
    object2:PTR TO object


  NEW resource1.new([object1,0,0])
  NEW resource2.new([object2,0,0])


  Delay(50)

  resource2.sendMessageToMaster(RCMD_END,resource1)

  IF resource1
    WriteF('Ending resource 1.\n')
->    END resource1
  ENDIF

  IF resource2
    WriteF('Ending resource 2.\n')
    END resource2
    WriteF('YAK!')
  ENDIF

  WriteF('YAK!')
ENDPROC
