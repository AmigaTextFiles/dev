MODULE 'utility/hooks'

PROC installhook(hook:PTR TO hook, func:PTR)
	hook.entry    := func
	hook.subentry := NIL
	hook.data     := NIL
ENDPROC hook
