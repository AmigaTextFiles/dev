 IFND	CPU_I
CPU_I = 1
;*---------------------------------------------------------------------------
;  :Author.	Bert Jahn
;  :Contens.	macros cpu related
;  :EMail.	wepl@kagi.com
;  :Address.	Franz-Liszt-Straﬂe 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: cpu.i 1.2 1998/12/06 13:39:15 jah Exp wepl $
;  :History.	02.03.97 separated from whdload.asm
;		12.04.97 some texts changed
;			 .fudt added
;		09.05.97 _GetCPU implemented
;		17.05.97 #60 added; #13-#15 corrected
;		27.06.98 cleanup for use with "HrtMon"
;		06.12.98 _GetCPU removed because buggy
;  :Copyright.	© 1997,1998 Bert Jahn, All Rights Reserved
;  :Language.	68000 Assembler
;  :Translator.	Barfly 2.9 and others
;---------------------------------------------------------------------------*
*##
*##	cpu.i
*##
*##	_exceptionnames	names of exception vectors

	dc.b	"$Id: cpu.i 1.2 1998/12/06 13:39:15 jah Exp wepl $"
	EVEN

;----------------------------------------
; names of exception/interrupt vectors
; for using with "Sources:strings.i" _DoString

exceptionnames	MACRO
	IFND	EXCEPTIONNAMES
EXCEPTIONNAMES = 1

_exceptionnames
.exlist		dc.w	2		;first
		dc.w	61		;last
		dc.l	0		;next list
		dc.w	.buserr-.exlist		;#2
		dc.w	.adderr-.exlist
		dc.w	.illinst-.exlist
		dc.w	.div-.exlist
		dc.w	.chk-.exlist
		dc.w	.trapv-.exlist
		dc.w	.priv-.exlist
		dc.w	.trace-.exlist
		dc.w	.linea-.exlist		;#10
		dc.w	.linef-.exlist		;#11
		dc.w	.emu-.exlist
		dc.w	.co-.exlist		;#13
		dc.w	.fmt-.exlist
		dc.w	.nii-.exlist
		ds.w	8
		dc.w	.spi-.exlist		;#24
		dc.w	.au1-.exlist
		dc.w	.au2-.exlist
		dc.w	.au3-.exlist
		dc.w	.au4-.exlist
		dc.w	.au5-.exlist
		dc.w	.au6-.exlist
		dc.w	.nmi-.exlist
		dc.w	.t0-.exlist		;#32
		dc.w	.t1-.exlist
		dc.w	.t2-.exlist
		dc.w	.t3-.exlist
		dc.w	.t4-.exlist
		dc.w	.t5-.exlist
		dc.w	.t6-.exlist
		dc.w	.t7-.exlist
		dc.w	.t8-.exlist
		dc.w	.t9-.exlist
		dc.w	.t10-.exlist
		dc.w	.t11-.exlist
		dc.w	.t12-.exlist
		dc.w	.t13-.exlist
		dc.w	.t14-.exlist
		dc.w	.t15-.exlist
		dc.w	.fbra-.exlist
		dc.w	.fir-.exlist
		dc.w	.fdiv-.exlist
		dc.w	.fuf-.exlist
		dc.w	.foe-.exlist
		dc.w	.fof-.exlist
		dc.w	.fnan-.exlist
		dc.w	.fudt-.exlist
		dc.w	.mmucfg-.exlist
		dc.w	.51io-.exlist
		dc.w	.51alv-.exlist
		dc.w	0
		dc.w	.uea-.exlist		;#60
		dc.w	.ui-.exlist		;#61
.buserr		dc.b	"Access Fault",0
.adderr		dc.b	"Address Error",0
.illinst	dc.b	"Illegal Instruction",0
.div		dc.b	"Integer Divide by Zero",0
.chk		dc.b	"CHK,CHK2 Instruction",0
.trapv		dc.b	"TRAPV,TRAPcc,cpTRAPcc Instruction",0
.priv		dc.b	"Privilege Violation",0
.trace		dc.b	"Trace",0
.linea		dc.b	"Line 1010 Emulator",0
.linef		dc.b	"Line 1111 Emulator",0
.emu		dc.b	"Emulator Interrupt",0			;68060
.co		dc.b	"Coprocessor Protocol Violation",0	;68020/68030
.fmt		dc.b	"Stackframe Format Error",0
.nii		dc.b	"Uninitialized Interrupt",0
.spi		dc.b	"Spurious Interrupt",0
.au1		dc.b	"Level 1 Autovector (TBE/DSKBLK/SOFT)",0
.au2		dc.b	"Level 2 Autovector (CIA-A/EXT)",0
.au3		dc.b	"Level 3 Autovector (COPPER/VBLANK/BLITTER)",0
.au4		dc.b	"Level 4 Autovector (AUDIO0-3)",0
.au5		dc.b	"Level 5 Autovector (RBF/DSKSYNC)",0
.au6		dc.b	"Level 6 Autovector (CIA-B/EXT)",0
.nmi		dc.b	"NMI Autovector",0
.t0		dc.b	"TRAP #0",0
.t1		dc.b	"TRAP #1",0
.t2		dc.b	"TRAP #2",0
.t3		dc.b	"TRAP #3",0
.t4		dc.b	"TRAP #4",0
.t5		dc.b	"TRAP #5",0
.t6		dc.b	"TRAP #6",0
.t7		dc.b	"TRAP #7",0
.t8		dc.b	"TRAP #8",0
.t9		dc.b	"TRAP #9",0
.t10		dc.b	"TRAP #10",0
.t11		dc.b	"TRAP #11",0
.t12		dc.b	"TRAP #12",0
.t13		dc.b	"TRAP #13",0
.t14		dc.b	"TRAP #14",0
.t15		dc.b	"TRAP #15",0
.fbra		dc.b	"FP Branch or Set on Unordered Condition",0
.fir		dc.b	"FP Inexact Result",0
.fdiv		dc.b	"FP Divide by Zero",0
.fuf		dc.b	"FP Underflow",0
.foe		dc.b	"FP Operand Error",0
.fof		dc.b	"FP Overflow",0
.fnan		dc.b	"FP Signaling NAN",0
.fudt		dc.b	"FP Unimplemented Datatype",0		;68040
.mmucfg		dc.b	"MMU Configuration Error",0		;68030/68851
.51io		dc.b	"MMU Illegal Operation Error",0		;68851
.51alv		dc.b	"MMU Access Level Violation Error",0	;68851
.uea		dc.b	"Unimplemented Effective Address",0	;68060
.ui		dc.b	"Unimplemented Integer Instruction",0	;68060

		EVEN
	ENDC
		ENDM

;---------------------------------------------------------------------------

	ENDC

