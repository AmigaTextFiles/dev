| Startup code.
| Doesn't do anything; your program is responsible for
| everything, including the workbench-message and opening
| dos.library.

|************************************************

	.text
	.globl _exit

	movel 4:W,_SysBase
	movel SP,StackPointer
	jsr _Main
	jra exit
_exit:	movel SP@(4),d0
exit:	movel StackPointer,SP
	rts

|************************************************

	.data
	.globl	_SysBase

	.comm StackPointer,4
	.comm _SysBase,4
