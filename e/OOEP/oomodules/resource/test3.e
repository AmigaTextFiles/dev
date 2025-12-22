MODULE  'oomodules/resource',
        'oomodules/object',
        'oomodules/file/textfile/programsource'

PROC main()
DEF resource1:PTR TO resource,
    resource2:PTR TO resource,
    object1:PTR TO object,
    object2:PTR TO object,

    ps:PTR TO programSource

 /*
  * Allocating the objects that willbe owners
  */

  NEW object1.new()
  NEW object2.new()


 /*
  * another owner :-)
  */

  NEW ps.new()


 /*
  * Allocating the resources. Set the owners and the like.
  */

  NEW resource1.new([object1,FindTask(NIL),0])
  NEW resource2.new([ps,FindTask(NIL),0])


 /*
  * Try to get the resource which is owned by object1
  */

  WriteF('Now trying to get the resource of an object from\n')
  WriteF('the master. It should give me this value: \d\n', resource1)


  resource2.sendMessageToMaster(RCMD_GETRESOURCE, object1)


  WriteF('Got this value: \d.\n', resource2.getLastData())


->  resource2.sendMessageToMaster(RCMD_INFO)


 /*
  * External ending.
  */

  resource2.sendMessageToMaster(RCMD_END,resource1)
  resource2.sendMessageToMaster(RCMD_END,resource2)


ENDPROC

