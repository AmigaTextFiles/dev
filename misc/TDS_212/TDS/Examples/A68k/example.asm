; example.asm

_SysBase		equ	4

_LVOOpenLibrary		equ	-552
_LVOCloseLibrary	equ	-414 

_LVOWrite		equ	-48
_LVOOutput		equ	-60

CALL	MACRO
	jsr	_LVO\1(a6)
	ENDM

start
	lea	dosName(pc),a1
	moveq	#33,d0
	move.l	_SysBase,a6
	CALL	OpenLibrary
	tst.l	d0
	beq.s	noLib

	move.l	d0,DOSBase

	move.l	DOSBase(pc),a6
	CALL	Output

	move.l	d0,d1
	lea	helloStr(pc),a0
	move.l	a0,d2
	moveq	#helloEnd-helloStr,d3
	CALL	Write

	move.l	DOSBase(pc),a1
	move.l	_SysBase,a6
	CALL	CloseLibrary
noLib
	moveq	#0,d0
	rts

helloStr
	dc.b	"Hello World",10
helloEnd

DOSBase
	dc.l	0
dosName
	dc.b	"dos.library",0
	
	end
