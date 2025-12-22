*
* Test of the assembler macros for use with FarCom16.o or FarCom.o
*

	INCLUDE	<exec/types.i>
	INCLUDE	<exec/memory.i>
	INCLUDE	<farprint.i>

FARPRINT	EQU	1
MEMWATCH	EQU	1

start:
	move.l	a6,-(sp)
	move.l	4,a6				; a6 : = exec base

	SendText <'FarTest2'>

	move.l	#12345,d0
	move.l	#$54321,d1
	SendText <'d0=%ld   d1=$%lx'>,d0,d1

	RequestNumber <'FarTest2'>
	SendText <'requested number=%ld'>,d0

	RequestString <'FarTest2'>,#buffer
	SendText <'requested string="%s"'>,#buffer

	move.l	#100,d0				; size
	move.l	#MEMF_PUBLIC,d1			; attr
	AllocMem <'FarTest2'>
	move.l	d0,a1				; ptr
	move.l	#100,d0				; size
	FreeMem <'FarTest2'>

	move.l	#20000,d0			; size
	move.l	#MEMF_PUBLIC|MEMF_CLEAR,d1	; attr
	AllocMem <'FarTest2'>
	move.l	d0,a1				; ptr
	move.l	#20000,d0			; size
	FreeMem <'FarTest2'>

	moveq	#0,d0		; return code
	move.l	(sp)+,a6
	rts
buffer:
	ds.b	512
