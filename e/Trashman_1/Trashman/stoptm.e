MODULE 'dos/dos'
MODULE 'exec/nodes','exec/ports'

PROC main()
	DEF task
	IF (task:=FindTask('Trashman'))
		Signal(task,SIGBREAKF_CTRL_C)
	ENDIF
ENDPROC
