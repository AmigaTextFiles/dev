#include <exec/execbase.h>
#include <exec/tasks.h>

/* This one's really machine dependant ;-) */

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FD1(122,VOID,StackSwap,struct StackSwapStruct *newStack,A0)
; /* For generating headers and fd-file, etc. */

asm("
	.globl ___StackSwap
___StackSwap:
	jbsr	a6@(120:W)		| Disable
	movel	sp@+,d0			| pop returnaddress
	movel	a6@(276:W),a1		| get task address
	addaw	#58,a1
	movel	a0@,d1			| swap stk_Lower
	movel	a1@,a0@+
	movel	d1,a1@+
	movel	a0@,d1			| swap stk_Upper
	movel	a1@,a0@+
	movel	d1,a1@
	movel	a0@,d1			| swap stk_Pointer
	movel	sp,a0@
	movel	d1,sp
	movel	d0,sp@-			| push returnaddress
	jbsr	a6@(126:W)		| Enable
	rts				| ciao

	.globl _stuffChar
_stuffChar:
	movel	a3,a7@-
	movel	a7@(16:W),a3
	movel	a7@(12:W),d0
	movel	a7@(8:W),a0
	jsr	a0@
	movel	a3,d0
	movel	a7@+,a3
	rts

	.globl	_putChar
_putChar:
	moveb	d0,a3@+
	rts

	.globl _DivMod10
_DivMod10:
	clrl	d1
	movew	a7@(4:W),d1
	divu	#10:W,d1
	movew	d1,d0
	swap	d0
	movew	a7@(6:W),d1
	divu	#10:W,d1
	movew	d1,d0
	clrw	d1
	swap	d1
	rts
");
