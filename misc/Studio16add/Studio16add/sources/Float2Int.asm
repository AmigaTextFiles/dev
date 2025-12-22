*>b:Float2Int

	*«««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*
	*   Copyright © 1997 by Kenneth "Kenny" Nilsen.  E-Mail: kenny@bgnett.no		      *
	*   Source viewed in 800x600 with mallx.font (11) in CED				      *
	*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
	*
	*   Name
	*	Float 2 Integer (double and single)
	*
	*   Function
	*	converts a double to integer pluss decimal
	*
	*   Inputs
	*	<hi float 1> <lo float 2>
	*
	*   Notes
	*	
	*   Bugs
	*	
	*   Created	: 01.12.97
	*   Changes	: 
	*««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««*


;StartSkip	SET	1
;DODUMP		SET	1

CheckCPU	set	1
Processor	=	68020

		Incdir	inc:

		include	lvo/exec_lib.i
		include	lvo/dos_lib.i
		include	lvo/mathieeedoubbas_lib.i
		include	lvo/mathieeesingbas_lib.i

		include	digital.macs
		include	digital.i

		include	dos/dos.i
		include	exec/types.i

		include	startup.asm

		Incdir	""

		dc.b	"$VER: DFloat2Int 1.1 (01.12.97)",10
		dc.b	"Copyright © 1997 Digital Surface. All rights reserved. ",0
		even
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Dump	macro
Error\1	move.l	#Err\1,d1
	bra	Print
	endm
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Init		DefLib	dos,37
		DefLib	mathieeedoubbas,37
		DefLib	mathieeesingbas,37
		DefEnd

Start	NextArg
	beq	About
	move.l	d0,a0
	bsr	CalcArg
	move.l	d0,Float1

	NextArg
	beq	.single
	move.l	d0,a0
	bsr	CalcArg
	move.l	d0,Float2

	bsr	DoubleF
	bra	.done

.single	bsr	SingleF

.done	LibBase	exec
	lea	String(pc),a0
	lea	IntExp(pc),a1
	lea	Proc(pc),a2
	lea	Buff(pc),a3
	Call	RawDoFmt

	LibBase	dos
	move.l	#Buff,d1
	Call	PutStr
*------------------------------------------------------------------------------------------------------------*
Close	Return	0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
DoubleF	LibBase	mathieeedoubbas

	move.l	Float1(pc),d0
	move.l	Float2(pc),d1

	Call	IEEEDPFloor

	move.l	d0,d2
	move.l	d1,d3

	Call	IEEEDPFix		;convert number to integer
	move.l	d0,IntExp		;store

	move.l	Float1(pc),d0		;get original number again
	move.l	Float2(pc),d1
	Call	IEEEDPSub		;subtract no dec. number from original number

	move.l	d0,d6			;=decimal only
	move.l	d1,d7

	move.l	#10000,d0
	Call	IEEEDPFlt		;convert to float = max number of decimal (4)

	move.l	d6,d2			;get decimal
	move.l	d7,d3
	Call	IEEEDPMul		;multiply

	Call	IEEEDPFix		;convert to integer
	move.l	d0,IntMan		;decimal as integer

	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
SingleF	LibBase	mathieeesingbas

	move.l	Float1(pc),d0

	Call	IEEESPFix		;convert number to integer
	move.l	d0,IntExp		;store
	Call	IEEESPFlt		;convert back to float wo/Float2
	move.l	d0,d1			;move as substrator
	move.l	Float1(pc),d0		;get original number again
	Call	IEEESPSub		;subtract no dec. number from original number

	move.l	d0,d6			;=decimal only

	move.l	#10000,d0
	Call	IEEESPFlt		;convert to float = max number of decimal (4)

	move.l	d6,d1			;get decimal
	Call	IEEESPMul		;multiply

	Call	IEEESPFix		;convert to integer
	move.l	d0,IntMan		;decimal as integer

	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
CalcArg	StackOn				;CalcArg(string) (a0)

	lea	(a0),a5

	cmp.b	#'$',(a0)		;only have to parse thrue the
	beq.b	CalcHex			;arg.list 'till we find no more.

CalcDec	bsr.w	ArgLen
	move.l	d0,d7
	beq.w	PErrS
	moveq	#0,d0
	moveq	#0,d1
	subq	#1,d7
	lea	(a5),a0
.CDec	mulu	#10,d1
	move.b	(a0)+,d0
	cmp.b	#'0',d0
	blo.w	PErrS
	cmp.b	#'9',d0
	bgt.w	PErrS
	sub.w	#48,d0
	add.w	d0,d1
	dbra	d7,.CDec
	bra.b	Value

CalcHex	lea	1(a0),a0		;recalculate hex-asc value num
	bsr.w	ArgLen
	move.l	d0,d7
	beq.w	PErrS
	moveq	#0,d0
	moveq	#0,d1
	subq	#1,d7
	lea	1(a5),a0
.CHex	rol.l	#4,d1
	move.b	(a0)+,d0
	cmp.b	#'0',d0
	blo.w	PErrS
	cmp.b	#'9',d0
	bgt.w	.chHex
.chOk	sub.w	#48,d0
	add.w	d0,d1
	dbra	d7,.CHex
	bra.b	Value
.chHex	cmp.b	#'a',d0
	blo.w	.Big
	cmp.b	#'f',d0
	bgt.w	PErrS
	sub.l	#39,d0
	bra.b	.small
.Big	cmp.b	#'A',d0
	blo.w	PErrS
	cmp.b	#'F',d0
	bgt.w	PErrS
	subq	#7,d0
.small	bra.b	.chOk

Value	move.l	d1,d0			;copy value

.ok	StackOff
	rts

PErrS	moveq	#0,d0

	StackOff
	rts

ArgLen	move.l	a0,-(sp)
	moveq	#0,d0
.loop	move.b	(a0)+,d1
	beq.b	.end
	cmp.b	#32,d1
	beq.b	.end
	cmp.b	#10,d1
	beq.b	.end
	addq.w	#1,d0
	bra.b	.loop
.end	move.l	(sp)+,a0
	rts
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Proc	move.b	d0,(a3)+
	rts

About	move.l	#AboutTxt,d1

Print	LibBase	dos
	Call	PutStr
	bra	Close
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
Float1		dc.l	0
Float2		dc.l	0

IntExp		dc.l	0
IntMan		dc.l	0

Buff		dcb.b	80,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
String		dc.b	"%ld.%04.lu",10,0
AboutTxt	dc.b	10,"Float2Int 1.0 by Kenneth 'Kenny' Nilsen (kenny@bgnett.no)",10,"USAGE: <hifloat> [<lofloat>]",10
		dc.b	"Both = DOUBLE",10
		dc.b	"One  = FLOAT",10,10,0
*»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»*
