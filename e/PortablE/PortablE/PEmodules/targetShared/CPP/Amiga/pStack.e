OPT NATIVE, POINTER
MODULE 'target/exec', 'target/exec/tasks'

PROC FreeStack() RETURNS bytes
	DEF task:PTR TO tc, size
	task := FindTask(NILA)
	size := task.spupper - task.splower
	
	bytes := ADDRESSOF bytes !!ARRAY - task.splower
	IF (bytes < 0) OR (bytes > size)
		bytes := task.spreg - task.splower
		IF (bytes < 0) OR (bytes > size)
			bytes := size
		ENDIF
	ENDIF
ENDPROC

PROC StackSize() RETURNS bytes
	DEF task:PTR TO tc
	task := FindTask(NILA)
	bytes := task.spupper - task.splower
ENDPROC
