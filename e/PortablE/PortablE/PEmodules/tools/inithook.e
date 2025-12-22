->wrapper
MODULE 'tools/installhook', 'target/utility/hooks', 'target/exec/types'

PROC inithook(hook:PTR TO hook, func:PTR, data:APTR2)
	installhook(hook, func)
	hook.data := data
ENDPROC
