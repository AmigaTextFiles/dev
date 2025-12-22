;APS00000A2E00000A2E00000A2E00000A2E00000A2E00000A2E00000A2E00000A2E00000A2E00000A2E
*****************************************************************************
*									    *
*	PROGRAM: Div0Test.s						    *
*	VERSION: 1.4							    *
*   SOURCE CODE: 20 (10.01.2020)					    *
*      LANGUAGE: Assembler (AsmPro 1.18)				    *
*	 AUTHOR: Holger Hippenstiel/Hauptstr.38/71229 Leonberg/Germany	    *
*	  EMAIL: Holger.Hippenstiel@gmx.de				    *
*									    *
*      FUNCTION: Tries all different div0 with NoMoreDiv0 should catch.	    *
*	   NOTE: No other registers should change, just the "Faulty" one    *
*		 should contain 0.					    *
*									    *
*****************************************************************************
	INCDIR	"A:Include2.0/"
	INCLUDE "lvo/exec_lib.i"
	INCLUDE	"lvo/dos_lib.i"
	INCLUDE	"exec/macros.i"
	INCLUDE	"exec/execbase.i"
	INCLUDE	"exec/memory.i"
	INCLUDE	"dos/dosextens.i"
	INCLUDE	"dos/dos.i"
	INCLUDE	"M68k_exceptions.s"

;DivisionByZero_Vector = $14
;_LVOTaggedOpenLib = -810
;1=Gfx,2=Layer,3=Int,4=Dos,5=Icon,6=Exp,7=Util,8=Keymap,9=Gadt,10=wb

SYS:	MACRO
	jsr	_LVO\1(a6)
	ENDM

Prog:
	move.l	4.w,a6
	moveq	#1+2+4+8,d7		;68010+68020+68030+68040
	and	AttnFlags(a6),d7
	beq.b	TableFound

	lea	GetBase(pc),a5
	SYS	Supervisor

TableFound:
	move.l	d7,a4
	move.l	M68k_DivisionByZero(a4),a2
	move.l	-12(a2),d0	;Div0Value - NewDiv0
	lea	Div0Value(pc),a0
	move.l	d0,(a0)
	;move.l	#$7fffffff,(a0)

.StartedFromCLI
	lea	DosName(pc),a1
	move.l	LibList(a6),a0
	SYS	FindName
	move.l	d0,a5

	clr.l	0.w
	sub.l	a4,a4
	sub.l	a3,a3
	lea	Nullen+4(pc),a1
	bsr.w	LoadRegs

	lea	1.w,a3
	divu	Nullen,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	2.w,a3
	divu	#0,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	3.w,a3
	divu	0.w,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	4.w,a3
	divu	Nullen(pc),d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	5.w,a3
	moveq	#0,d7
	divu	Nullen2(pc,d7.w*4),d7
	bsr.w	TestRegs
	bne.w	Abort
	bra.b	Cont

Nullen2:	dc.l 0
Cont:
	lea	6.w,a3
	divu	4(a1,d7.w*2),d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	7.w,a3
	divu	4(a1),d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	8.w,a3
	moveq	#0,d7
	divu	d7,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	9.w,a3
	divu	(a1),d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	10.w,a3
	divu	(a1)+,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	11.w,a3
	divu	-(a1),d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	12.w,a3
	divul.l	Nullen,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	13.w,a3
	divul.l	#0,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	14.w,a3
	divul.l	0.w,d7
	bsr.w	TestRegs
	bne.w	Abort

	lea	15.w,a3
	divul.l	Nullen(pc),d7
	bsr.w	TestRegs
	bne.b	Abort

	lea	16.w,a3
	moveq	#0,d7
	divul.l	Nullen3(pc,d7.w*4),d7
	bsr.b	TestRegs
	bne.b	Abort
	bra.b	Cont2

Nullen3:	dc.l 0
Cont2:
	lea	17.w,a3
	moveq	#0,d7
	divul.l	4(a1,d7.w*4),d7
	bsr.b	TestRegs
	bne.b	Abort

	lea	18.w,a3
	divul.l	4(a1),d7
	bsr.b	TestRegs
	bne.b	Abort

	lea	19.w,a3
	moveq	#0,d7
	divul.l	d7,d7
	bsr.b	TestRegs
	bne.b	Abort

	lea	20.w,a3
	divul.l	(a1),d7
	bsr.b	TestRegs
	bne.b	Abort

	lea	21.w,a3
	divul.l	(a1)+,d7
	bsr.b	TestRegs
	bne.b	Abort

	lea	22.w,a3
	divul.l	-(a1),d7
	bsr.b	TestRegs
	bne.b	Abort

	lea	TestNr(pc),a1
	move.l	a3,(a1)
	lea	AllTestsOk(pc),a0
	bsr.b	PrintFmt
	moveq	#0,d0
	rts

Abort:
	lea	TestNr(pc),a1
	move.l	a3,(a1)
	lea	TestNrFail(pc),a0
	bsr.b	PrintFmt

	move.l	a3,d0
	rts

******************************************************************************

TestRegs:
	cmp.l	(a0)+,d0
	bne.b	Failed
	cmp.l	(a0)+,d1
	bne.b	Failed
	cmp.l	(a0)+,d2
	bne.b	Failed
	cmp.l	(a0)+,d3
	bne.b	Failed
	cmp.l	(a0)+,d4
	bne.b	Failed
	cmp.l	(a0)+,d5
	bne.b	Failed
	cmp.l	(a0)+,d6
	bne.b	Failed
	cmp.l	(a0),d7
	beq.b	LoadRegs
Failed:	lea	-1.w,a4
	cmp	#0,a4
	rts

******************************************************************************

LoadRegs:
	lea	Regs(pc),a0
	movem.l	(a0),d0-d6
	moveq	#-1,d7
	cmp	#0,a4
	rts

******************************************************************************
;a0 = Text
;a1 = Datafield
PrintFmt:
	movem.l	d0-d7/a0-a6,-(a7)
PrintDebugFmt:
	lea	PutChProc(pc),a2
	lea	-1024(a7),a3
	SYS	RawDoFmt

	lea	-1024(a7),a0
	bra.b	PrintIt
	
******************************************************************************
;a0 = Text
Print:
	movem.l	d0-d7/a0-a6,-(a7)
PrintIt:
	move.l	a0,d2
.FindLen:
	tst.b	(a0)+
	bne.b	.FindLen
	move.l	a0,d3
	sub.l	d2,d3
	subq.l	#1,d3
	move.l	a5,a6
	SYS	Output
	move.l	d0,d1
	SYS	Write
NoOutput:
	movem.l	(a7)+,d0-d7/a0-a6
	rts

******************************************************************************

;Put one char for RawDoFmt() in Buffer
PutChProc:
	move.b	d0,(a3)+
	clr.b	(a3)
	rts

******************************************************************************

GetBase:movec	vbr,d7
	rte

	dc.b	"$VER: DivTest 1.4 ("
	%getdate 3
	dc.b	") by Holger 'Lynxx' Hippenstiel",0
DosName: dc.b "dos.library",0
AllTestsOk:
	dc.b	"DivTest 1.4 completed all %ld tests succesfully !",10,0
TestNrFail:
	dc.b	"DivTest 1.4 failed at Test %ld. :(",10,0
	cnop	0,4
	
TestNr:	dc.l	0

Regs:	dc.l	$d0d0d0d0
	dc.l	$d1d1d1d1
	dc.l	$d2d2d2d2
	dc.l	$d3d3d3d3
	dc.l	$d4d4d4d4
	dc.l	$d5d5d5d5
	dc.l	$d6d6d6d6
Div0Value:
	dc.l	$d7d7d7d7

Nullen:	dc.l	0
	dc.l	0
	dc.l	0
	dc.l	0
