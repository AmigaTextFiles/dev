OPT AMIGAOS4, MODULE

-> amigalib/tasks.e by LS 2008

MODULE 'exec/tasks'


EXPORT PROC createTask(name, pri, initPC, stackSize, data=NIL)
ENDPROC CreateTask(name, pri, {entry}, stackSize,
   [AT_Param1, initPC, AT_Param2, data, AT_Param3, execiface, NIL])

EXPORT PROC deleteTask(tc) IS RemTask(tc)

-> we need this to put in tc.userdata
PROC entry(initPC, data, execiface)
   DEF thistask:PTR TO tc
   thistask := FindTask(NIL)
   thistask.userdata := data
ENDPROC initPC()







