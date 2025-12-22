/* partially alias module */
OPT NATIVE
PUBLIC MODULE 'targetShared/CPP/pShell', 'targetShared/CPP/Amiga/pShell'
MODULE 'dos', 'utility/tagitem'
MODULE 'std/pStack'

PROC ExecuteCommand(command:ARRAY OF CHAR) RETURNS executed:BOOL REPLACEMENT
	DEF ret
	ret := SystemTagList(command, [
		NP_STACKSIZE, StackSize(),
	TAG_END]:tagitem)
	executed := (ret <> -1)
ENDPROC
