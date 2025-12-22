OPT POINTER
MODULE 'target/amigalib', 'utility/hooks'

PROC installhook(hook:PTR TO hook, func:PTR)
	hook.entry    := CALLBACK hookEntry()
	hook.subentry := func
	hook.data     := NIL
ENDPROC hook
