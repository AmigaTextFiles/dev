OPT NATIVE
MODULE 'target/amigalib', 'utility/hooks'

PROC installhook(hook:PTR TO hook, func:PTR)
	hook.entry    := NATIVE {(ULONG (*)()) (long) (void*) &HookEntry} ENDNATIVE !!PTR		->we should use := CALLBACK hookEntry(), but that requires hookEntry() is declared without "IS", which causes many problems with AmiDevCpp
	hook.subentry := func
	hook.data     := NIL
ENDPROC hook
