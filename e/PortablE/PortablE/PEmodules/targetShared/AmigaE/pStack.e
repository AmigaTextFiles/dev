OPT NATIVE, POINTER
MODULE 'target/exec', 'target/exec/tasks'

PROC FreeStack() IS NATIVE {FreeStack()} ENDNATIVE !!VALUE

PROC StackSize()
	DEF bytes
	DEF task:PTR TO tc
	task := FindTask(NILA)
	bytes := task.spupper - task.splower
ENDPROC bytes
