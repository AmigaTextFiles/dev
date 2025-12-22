;Global include file needed for almost all other PowerVisor sources

 * Part of PowerVisor source   Copyright © 1992   Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH

;			MACLIB	"AllSyms.mac"

	addsym
	debug
	newsyntax
	strict
	times


 IFND D13
D20			SET	1
 ENDC

	;DEBUGGING :
	;DEBUGNORM	= normal debugging with DEBUGP, DEBUGI, DEBUGL, DEBUGS
	;DEBUGSUSP	= suspicion macro with CHECK
	;DEBUGMEM	= memory corruption checks with MEMCHECK and MEMWATCH
	;DEBUGFOUR	= DEBUGPC check for easy 4 character keywords
	;any combination is allowed
;DEBUGGING	SET	1
;DEBUGNORM	SET	1
;DEBUGMEM	SET	1
;DEBUGFOUR	SET	1

	if1
		ifnd	D20
			printx	*** Assembling for AmigaDOS 1.3! ***
		endc
		ifd	DEBUGGING
			printx	*** Assembling with debug information! ***
		endc
	endc

SysBase			equ	4
_SysBase			equ	4

	XREF		KPutChar,KPutStr,KPrintF,KGetChar


;EXEC_LISTS_I		SET	1
;EXEC_LIBRARIES_I	SET	1
;GRAPHICS_TEXT_I	SET	1
;UTILITY_TAGITEM_I	SET	1


	include "reqtools.i"


	;Macro to get the following argument if it is there
NEXTARG	macro		*
				NEXTTYPE
				beq.b		\1
				EVALE
			endm


SZ_	equ	0
SZb	equ	1
SZw	equ	2
SZl	equ	3

GETFMT	macro		*
			move.l	#((((((SZ\7+4*\8)<<8)+SZ\5+4*\6)<<8)+SZ\3+4*\4)<<8)+SZ\1+4*\2,d2
			endm

FMT_		equ	0
FMTd		equ	0
FMTld		equ	1
FMT04x	equ	2
FMT08lx	equ	3
FMTs		equ	4

AFT_		equ	0
AFTspc	equ	0
AFTcol	equ	1
AFTnl		equ	2
AFTsep	equ	3

FMTSTR	macro		*
			move.l	#((((((FMT\7+16*AFT\8)<<8)+FMT\5+16*AFT\6)<<8)+FMT\3+16*AFT\4)<<8)+FMT\1+16*AFT\2,d3
			endm

	;Macros for 'ForPrint' and 'ForPrintQ'

	;A string. This is the same as PFLONG except that a 0 value is replaced
	;by 'EmptyString'
PFSTRING	macro
			dc.w		512+256+\1
			endm

	;An immediate long value
PFLIMM	macro
			dc.w		512+255
			dc.l		\1
			endm

	;An immediate word value
PFWIMM	macro
			dc.w		256+255
			dc.w		\1
			dc.w		0
			endm

	;An immediate byte value
PFBIMM	macro
			dc.w		255
			dc.b		\1
			dc.b		0
			dc.w		0
			endm

	;An immediate string
PFSIMM	macro
			dc.w		512+256+255
			dc.l		\1
			endm

	;A long
PFLONG	macro
			dc.w		512+\1
			endm

	;A word
PFWORD	macro
			dc.w		256+\1
			endm

	;A byte
PFBYTE	macro
			dc.w		\1
			endm

	;The pointer to the structure
PFSTRUCT	macro
			dc.w		-1
			endm

	;The end
PFEND		macro
			dc.w		-2
			endm


	;Macros for 'FastFPrint'
	;
	;Example usage :
	;
	;	FF		ls,40,str,":",spc,1,X_,0
	;	FF		s_,6,D_,8,D,8,end,0
	;
	;is equivalent to :
	;
	;	dc.b	"%a",40,":",32,"%d",32,"%b",6,32,"%h",8,32,"%h",8,0
	;
	;which is in fact equivalent to (after 'FastFPrint' interpretation) :
	;
	;	dc.b	"%-40.40s: %08lx %6.6s %8.ld %8.ld",0 (in RawDoFmt format)
	;
	;
FFls		macro
				dc.b	"%a",\1
			endm

FFs		macro
				dc.b	"%b",\1
			endm

FFx		macro
				dc.b	"%c"
			endm

FFX		macro
				dc.b	"%d"
			endm

FFld		macro
				dc.b	"%e",\1
			endm

FFlD		macro
				dc.b	"%f",\1
			endm

FFd		macro
				dc.b	"%g",\1
			endm

FFD		macro
				dc.b	"%h",\1
			endm

FFper		macro
				dc.b	"%i"
			endm

FFbx		macro
				dc.b	"%j"
			endm

FFc		macro
				dc.b	"%k"
			endm

FFls_		macro
				dc.b	"%a",\1,32
			endm

FFs_		macro
				dc.b	"%b",\1,32
			endm

FFx_		macro
				dc.b	"%c",32
			endm

FFX_		macro
				dc.b	"%d",32
			endm

FFld_		macro
				dc.b	"%e",\1,32
			endm

FFlD_		macro
				dc.b	"%f",\1,32
			endm

FFd_		macro
				dc.b	"%g",\1,32
			endm

FFD_		macro
				dc.b	"%h",\1,32
			endm

FFper_	macro
				dc.b	"%i",32
			endm

FFbx_		macro
				dc.b	"%j",32
			endm

FFc_		macro
				dc.b	"%k",32
			endm

FFstr		macro
				dc.b	\1
			endm

FFstr_	macro
				dc.b	\1,32
			endm

FFspc		macro
				repeat	\1
					dc.b	32
				endr
			endm

FFnl		macro
				dc.b		10
			endm

FFend		macro
				dc.b		0
			endm

FFnlend	macro
				dc.b		10,0
			endm

FF		macro
			ifnc	'\1',''
				FF\1	\2
			endc
			ifnc	'\3',''
				FF\3	\4
			endc
			ifnc	'\5',''
				FF\5	\6
			endc
			ifnc	'\7',''
				FF\7	\8
			endc
			ifnc	'\9',''
				printx	Too many arguments for macro 'FF'!
				fail
			endc
		endm



;_LVOofs	set	-30
;
;LIBFN		macro
;_LVO\1	equ	_LVOofs
;_LVOofs	set	_LVOofs-6
;			endm
;
;	;ReqTools routines
;	LIBFN rtAllocRequestA
;	LIBFN rtFreeRequest
;	LIBFN rtFreeReqBuffer
;	LIBFN rtChangeReqAttrA
;	LIBFN rtFileRequestA
;	LIBFN rtFreeFileList
;	LIBFN rtEZRequestA
;	LIBFN rtGetStringA
;	LIBFN rtGetLongA
;	LIBFN rtInternalGetPasswordA	; private!
;	LIBFN rtInternalEnterPasswordA	; private!
;	LIBFN rtFontRequestA
;	LIBFN rtPaletteRequestA
;	LIBFN rtReqHandlerA
;	LIBFN rtSetWaitPointer
;	LIBFN rtGetVScreenSize
;	LIBFN rtSetReqPosition
;	LIBFN rtSpread
;	LIBFN rtScreenToFrontSafely

;	;Input device routines
;_LVOPeekQualifier		equ	-42

;	;PowerVisor routines
;_LVOPP_InitPortPrint	equ	-30 
;_LVOPP_StopPortPrint	equ	-36 
;_LVOPP_ExecCommand	equ	-42 
;_LVOPP_DumpRegs		equ	-48 
;_LVOPP_Print			equ	-54 
;_LVOPP_PrintNum		equ	-60 
_LVOPP_SignalPowerVisor	equ	-66 
	;ExpansionBase routines
;_LVOFindConfigDev		equ	-72
	;ExecBase routines
;_LVOSupervisor			equ	-30
;_LVOFindTask			equ	-294
;_LVOOldOpenLibrary	equ	-408
;_LVOCloseLibrary		equ	-414
;_LVOForbid				equ	-132
;_LVOPermit				equ	-138
;_LVOAllocMem			equ	-198
;_LVOAllocEntry			equ	-222
;_LVOFreeMem				equ	-210
;_LVOWait					equ	-318
;_LVOSumLibrary			equ	-426
;_LVOGetMsg				equ	-372
;_LVOReplyMsg			equ	-378
;_LVOSetFunction		equ	-420
;_LVOSwitch				equ	-54
;_LVOAllocSignal		equ	-330
;_LVOFreeSignal			equ	-336
;_LVOSignal				equ	-324
;_LVOAddTask				equ	-282
;_LVORemTask				equ	-288
;_LVOFindPort			equ	-390
;_LVORemove				equ	-252
;_LVOAddHead				equ	-240
;_LVOAddTail				equ	-246
;_LVODisable				equ	-10000
;_LVOEnable				equ	-10000
;_LVOAlert				equ	-108
;_LVOAddPort				equ	-354
;_LVORemPort				equ	-360
;_LVOOpenDevice			equ	-444
;_LVOCloseDevice		equ	-450
;_LVODoIO					equ	-456
;_LVOSetTaskPri			equ	-300
;_LVOTypeOfMem			equ	-534
;_LVOAllocAbs			equ	-204
;_LVOCopyMem				equ	-624
;_LVOReschedule			equ	-48
;_LVOSetSR				equ	-144
;_LVOCreateMsgPort		equ	-666
;_LVODeleteMsgPort		equ	-672
;_LVORawDoFmt			equ	-522
;_LVOEnqueue				equ	-270
	;UtilityBase routines
;_LVOSMult32				equ	-138
;_LVOSDivMod32			equ	-150
	;DosBase routines
;_LVOOutput				equ	-60
;_LVORead					equ	-42
;_LVOWrite				equ	-48
;_LVOOpen					equ	-30
;_LVOClose				equ	-36
;_LVOUnLoadSeg			equ	-156
;_LVOSeek					equ	-66
;_LVOLoadSeg				equ	-150
;_LVOCreateProc			equ	-138
;_LVOExit					equ	-144
;_LVOLock					equ	-84
;_LVOUnLock				equ	-90
;_LVOExamine				equ	-102
;_LVOParentDir			equ	-210
;_LVODelay				equ	-198
	;IntuitionBase routines
;_LVOCloseScreen		equ	-66
;_LVOCloseWindow		equ	-72
;_LVOOpenScreen			equ	-198
;_LVOOpenWindow			equ	-204
;_LVOModifyIDCMP		equ	-150
;_LVOScreenToFront		equ	-252
;_LVOAutoRequest		equ	-348
;_LVORefreshGadgets	equ	-222
;_LVOActivateGadget	equ	-462
;_LVOActivateWindow	equ	-450
;_LVOClearDMRequest	equ	-48
;_LVOClearMenuStrip	equ	-54
;_LVOClearPointer		equ	-60
;_LVOEndRequest			equ	-120
;_LVODisplayBeep		equ	-96
;_LVOLockPubScreenList	equ	-522
;_LVOUnlockPubScreenList	equ	-528
;_LVOMoveWindow			equ	-168
;_LVOSizeWindow			equ	-288
;_LVOAddGadget			equ	-42
;_LVORemoveGadget		equ	-228
;_LVOReportMouse		equ	-234
;_LVOOnGadget			equ	-186
;_LVOOffGadget			equ	-174
	;GfxBase routines
;_LVOText					equ	-60
;_LVOMove					equ	-240
;_LVODraw					equ	-246
;_LVOScrollRaster		equ	-396
;_LVORectFill			equ	-306
;_LVOSetAPen				equ	-342
;_LVOSetBPen				equ	-348
;_LVOSetDrMd				equ	-354
;_LVOSetRGB4				equ	-288
;_LVOSetFont				equ	-66
;_LVOOpenFont			equ	-72
;_LVOCloseFont			equ	-78
	;ArpBase routines
_LVOLMult				equ	-$258
_LVOLDiv					equ	-$25e
_LVOLMod					equ	-$264
_LVOSPrintf				equ	-$282
_LVOCreatePort			equ	-$132
_LVODeletePort			equ	-$138
	;DiskFont routines
;_LVOOpenDiskFont		equ	-30

	;***
	;Macros for library calling
	;***

CALL		macro
			jsr		(_LVO\1,a6)
			endm

CALLMATD	macro
			movea.l	(MathDPBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLDF	macro
			movea.l	(DFBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLINP	macro
			movea.l	(InputRequestB),a6
			movea.l	(IO_DEVICE,a6),a6
			jsr		(_LVO\1,a6)
			endm

CALLPV	macro
			movea.l	(PVBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLGT	macro
			movea.l	(GTBase,pc),a6
			jsr		(_LVO\1,a6)
			endm

CALLREQ	macro
			movea.l	(ReqBase,pc),a6
			jsr		(_LVO\1,a6)
			endm

CALLEXEC	macro
			movea.l	(SysBase).w,a6
			jsr		(_LVO\1,a6)
			endm

CALLUTIL	macro
			movea.l	(UtilBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLLAY	macro
			movea.l	(LayersBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLGRAF	macro
			movea.l	(Gfxbase),a6
			jsr		(_LVO\1,a6)
			endm

CALLDOS	macro
			movea.l	(DosBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLINT	macro
			movea.l	(IntBase),a6
			jsr		(_LVO\1,a6)
			endm

CALLARP	macro
			movea.l	(ArpBase),a6
			jsr		(_LVO\1,a6)
			endm

disable	macro
			move.w	#$4000,($dff09a)
			endm

enable	macro
			move.w	#$c000,($dff09a)
			endm

	;***
	;Debugging on the serial port
	;***

	;Watch routines
MEMWATCH	macro		*
	IFD	DEBUGMEM
MEMW\1:
			dc.l		$12345678
	ENDC
			endm


MEMCHECK	macro		*
	IFD	DEBUGMEM
			bra.b		.MMC\@
			move.l	d0,-(a7)
			move.l	(MEMW\1,pc),d0
			cmp.l		#$12345678,d0
			movem.l	(a7)+,d0
			beq.b		.MMC\@
		;Error !
			movem.l	d0-d1/a0-a1/a6,-(a7)
			lea		(.MMCS\@,pc),a0
			bsr		KPutStr
			movem.l	(a7)+,d0-d1/a0-a1/a6
			bra.b		.MMC\@
.MMCS\@:	dc.b		10,0
			EVEN
.MMC\@:
	ENDC
			endm

	;Print a character on the serial port
DEBUGC	macro		*
	IFD	DEBUGNORM
			movem.l	d0-d1/a0-a1/a6,-(a7)
			move.l	\1,d0
			bsr		KPutChar
			movem.l	(a7)+,d0-d1/a0-a1/a6
	ENDC
			endm

	;Print two characters on the serial port
DEBUGC2	macro		*
			DEBUGC	\1
			DEBUGC	\2
			endm

	;Print one, two, three or four integers on the serial port (or newline)
DEBUGI	macro		*
	IFD	DEBUGNORM
	ifnc	'\1',''
			movem.l	d0-d1/a0-a1/a6,-(a7)
			movea.l	\1,a0
			move.l	a0,-(a7)
			movea.l	a7,a1
			lea		(DebugLongNNLFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
			movem.l	(a7)+,d0-d1/a0-a1/a6
	endc

	ifnc	'\2',''
			movem.l	d0-d1/a0-a1/a6,-(a7)
			movea.l	\2,a0
			move.l	a0,-(a7)
			movea.l	a7,a1
			lea		(DebugLongNNLFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
			movem.l	(a7)+,d0-d1/a0-a1/a6
	endc

	ifnc	'\3',''
			movem.l	d0-d1/a0-a1/a6,-(a7)
			movea.l	\3,a0
			move.l	a0,-(a7)
			movea.l	a7,a1
			lea		(DebugLongNNLFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
			movem.l	(a7)+,d0-d1/a0-a1/a6
	endc

	ifnc	'\4',''
			movem.l	d0-d1/a0-a1/a6,-(a7)
			movea.l	\4,a0
			move.l	a0,-(a7)
			movea.l	a7,a1
			lea		(DebugLongNNLFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
			movem.l	(a7)+,d0-d1/a0-a1/a6
	endc
	ENDC
			endm

	;Print one integer (optionally with string) on serial port
DEBUGL	macro		*
	IFD	DEBUGNORM
			movem.l	d0-d1/a0-a1/a6,-(a7)
	ifc	'\2',''
			movea.l	\1,a0
			move.l	a0,-(a7)
			movea.l	a7,a1
			lea		(DebugLongFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
	endc
	ifnc	'\2',''
			movea.l	\2,a0
			move.l	a0,-(a7)
			lea		(.DL\@,pc),a0
			move.l	a0,-(a7)
			movea.l	a7,a1
			lea		(DebugLong2Format,pc),a0
			bsr		KPrintF
			lea		(8,a7),a7
			bra.b		.DLE\@
.DL\@:	dc.b		\1,0
			EVEN
.DLE\@:
	endc
			movem.l	(a7)+,d0-d1/a0-a1/a6
	ENDC
			endm

	;Print one word (optionally with string) on serial port
DEBUGW	macro		*
	IFD	DEBUGNORM
			movem.l	d0-d1/a0-a1/a6,-(a7)
	ifc	'\2',''
			sub.l		a0,a0
			move.w	\1,a0
			move.l	a0,-(a7)
			move.l	a7,a1
			lea		(DebugLongFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
	endc
	ifnc	'\2',''
			sub.l		a0,a0
			move.w	\2,a0
			move.l	a0,-(a7)
			lea		(.DL\@,pc),a0
			move.l	a0,-(a7)
			move.l	a7,a1
			lea		(DebugLong2Format,pc),a0
			bsr		KPrintF
			lea		(8,a7),a7
			bra.b		.DLE\@
.DL\@:	dc.b		\1,0
			EVEN
.DLE\@:
	endc
			movem.l	(a7)+,d0-d1/a0-a1/a6
	ENDC
			endm

	;Print constant string on serial port
DEBUGP	macro		*
	IFD	DEBUGNORM
			movem.l	d0-d1/a0-a1/a6,-(a7)
			lea		(.DP\@,pc),a0
			bsr		KPutStr
			movem.l	(a7)+,d0-d1/a0-a1/a6
			bra.b		.DPE\@
.DP\@:	dc.b		\1,10,0
			EVEN
.DPE\@:
	ENDC
			endm

	;Print constant string on serial port (no newline)
DEBUGPC	macro		*
	IFD	DEBUGFOUR
			movem.l	d0-d1/a0-a1/a6,-(a7)
			lea		(.DC\@,pc),a0
			bsr		KPutStr
			movem.l	(a7)+,d0-d1/a0-a1/a6
			bra.b		.DCE\@
.DC\@:	dc.b		\1,32,0
			EVEN
.DCE\@:
	ENDC
			endm

	;Print variable string on serial port
DEBUGS	macro		*
	IFD	DEBUGNORM
			movem.l	d0-d1/a0-a1/a6,-(a7)
			move.l	\1,a0
			bsr		KPutStr
			lea		(.DS\@,pc),a0
			bsr		KPutStr
			movem.l	(a7)+,d0-d1/a0-a1/a6
			bra.b		.DSE\@
.DS\@:	dc.b		10,0
.DSE\@:
	ENDC
			endm

	;***
	;Debugging on the PowerVisor window
	;***

	;Print hex number on powervisor window
IDEBUG	macro	*
			movem.l	d0-d7/a0-a6,-(a7)
			move.l	\1,d0
			bsr		PrintHex
			movem.l	(a7)+,d0-d7/a0-a6
			endm

	;Print char
CDEBUG	macro	*
			movem.l	d0-d7/a0-a6,-(a7)
			move.b	\1,d0
			bsr		PrintChar
			movem.l	(a7)+,d0-d7/a0-a6
			endm

DBUG		macro	*
		IFD	DEBUGNORM
Dbug\1:	dc.l	$ABCD0000+\1
		ENDC
			endm

PDBUG	macro	*
	IFD		DEBUGNORM
		move.l	(Dbug\1),d0
		bsr		PrintHex
	ENDC
		endm

	;***
	;Suspicion !!!
	;***

CHECK		macro	*
	IFD		DEBUGSUSP
		ifc	'\3','even'
			move.l	d0,-(a7)
			move.l	\2,d0
			btst\0	#0,d0
			movem.l	(a7)+,d0			;For flags
			beq.b		.SUCCESS\@
		endc
		ifc	'\3','in'
			cmp\0		\4,\2
			blt.b		.FAIL\@
			cmp\0		\5,\2
			ble.b		.SUCCESS\@
		endc
		ifc	'\3','nin'
			cmp\0		\4,\2
			blt.b		.SUCCESS\@
			cmp\0		\5,\2
			bgt.b		.SUCCESS\@
		endc
		ifc	'\3','eq'
			cmp\0		\4,\2
			beq.b		.SUCCESS\@
		endc
		ifc	'\3','ne'
			cmp\0		\4,\2
			bne.b		.SUCCESS\@
		endc
		ifc	'\3','gt'
			cmp\0		\4,\2
			bgt.b		.SUCCESS\@
		endc
		ifc	'\3','ge'
			cmp\0		\4,\2
			bge.b		.SUCCESS\@
		endc
		ifc	'\3','lt'
			cmp\0		\4,\2
			blt.b		.SUCCESS\@
		endc
		ifc	'\3','le'
			cmp\0		\4,\2
			ble.b		.SUCCESS\@
		endc
.FAIL\@:
			movem.l	a0-a1/d0-d1/a6,-(a7)
			lea		(.LAB\@,pc),a0
			bsr		KPutStr
			movem.l	(a7)+,a0-a1/d0-d1/a6
			movem.l	a0-a1/d0-d1/a6,-(a7)
			move.l	\2,a0
			move.l	a0,-(a7)
			move.l	a7,a1
			lea		(DebugLongFormat,pc),a0
			bsr		KPrintF
			lea		(4,a7),a7
			bsr		KGetChar
			movem.l	(a7)+,a0-a1/d0-d1/a6
			bra.b		.SUCCESS\@
.LAB\@:	dc.b		'\1',32,32,32,32
			dc.b		'\2',32,'is',32,0
			EVEN
.SUCCESS\@:
	ENDC
			endm

	;***
	;Macros for more high level features in assembler
	;***

	;convert a condition to a number
	;\1 = condition (eq, ne, lt, ge, ...)
	;-> _result = number
c2n		macro
			ifc	'\1','eq'
_result	set	1
			endc
			ifc	'\1','ne'
_result	set	2
			endc
			ifc	'\1','gt'
_result	set	3
			endc
			ifc	'\1','le'
_result	set	4
			endc
			ifc	'\1','lt'
_result	set	5
			endc
			ifc	'\1','ge'
_result	set	6
			endc
			endm

	;negative branch
	;\0 = .b or not
	;\1 = label
	;\2 = condition number (made by c2n macro)
nbran		macro
			ifc	\2,1
				bne\0		\1
			endc
			ifc	\2,2
				beq\0		\1
			endc
			ifc	\2,3
				ble\0		\1
			endc
			ifc	\2,4
				bgt\0		\1
			endc
			ifc	\2,5
				bge\0		\1
			endc
			ifc	\2,6
				blt\0		\1
			endc
			endm

	;positive branch
	;\0 = .b or not
	;\1 = label
	;\2 = condition number (made by c2n macro)
pbran		macro
			ifc	\2,1
				beq\0		\1
			endc
			ifc	\2,2
				bne\0		\1
			endc
			ifc	\2,3
				bgt\0		\1
			endc
			ifc	\2,4
				ble\0		\1
			endc
			ifc	\2,5
				blt\0		\1
			endc
			ifc	\2,6
				bge\0		\1
			endc
			endm

	;negative branch
	;\0 = .b or not
	;\1 = label
	;\2 = condition
nbra		macro
			ifc	'\2','eq'
				bne\0		\1
			endc
			ifc	'\2','ne'
				beq\0		\1
			endc
			ifc	'\2','gt'
				ble\0		\1
			endc
			ifc	'\2','le'
				bgt\0		\1
			endc
			ifc	'\2','lt'
				bge\0		\1
			endc
			ifc	'\2','ge'
				blt\0		\1
			endc
			ifc	'\2','cs'
				bcc\0		\1
			endc
			ifc	'\2','cc'
				bcs\0		\1
			endc
			endm

	;positive branch
	;\0 = .b or not
	;\1 = label
	;\2 = condition
pbra		macro
				b\2\0		\1
			endm

	;example:
	;			tst.l		d0
	;			while.b	ne
	;				...
	;				tst.l		d0
	;			endw
	;
	;example:
	;			whiletst
	;			tst.l		d0
	;			while.b	ne
	;				...
	;			endw
	;
_wh_LAB		set	0

whiletst	macro
.whiletst\*VALOF(_wh_LAB):
			endm

while		macro
				ifnd		.whiletst\*VALOF(_wh_LAB)
					bra\0		.endw\*VALOF(_wh_LAB)
.while\*VALOF(_wh_LAB):
				endc
				ifd		.whiletst\*VALOF(_wh_LAB)
					nbra\0	.endw\*VALOF(_wh_LAB),\1
				endc

				c2n		\1
_wh_cond		set		_result
				ifc		'\0','.b'
_wh_shbr			set		1
				endc
				ifnc		'\0','.b'
_wh_shbr			set		0
				endc
			endm


endw		macro
				ifnd		.whiletst\*VALOF(_wh_LAB)
.endw\*VALOF(_wh_LAB):
					ifc	'\*VALOF(_wh_shbr)','1'
						pbran.b	.while\*VALOF(_wh_LAB),\*VALOF(_wh_cond)
					endc
					ifnc	'\*VALOF(_wh_shbr)','1'
						pbran		.while\*VALOF(_wh_LAB),\*VALOF(_wh_cond)
					endc
				endc
				ifd		.whiletst\*VALOF(_wh_LAB)
					ifc	'\*VALOF(_wh_shbr)','1'
						bra.b		.whiletst\*VALOF(_wh_LAB)
					endc
					ifnc	'\*VALOF(_wh_shbr)','1'
						bra		.whiletst\*VALOF(_wh_LAB)
					endc
.endw\*VALOF(_wh_LAB):
				endc
_wh_LAB		set	_wh_LAB+1
			endm

	;example:
	;			do.b
	;				...
	;				tst.l		d0
	;			until eq
	;
_do_LAB		set	0

do			macro
.do\*VALOF(_do_LAB):
				ifc	'\0','.b'
_do_shbr			set	1
				endc
				ifnc	'\0','.b'
_do_shbr			set	0
				endc
			endm

until		macro
				ifc	'\*VALOF(_do_shbr)','1'
					nbra.b	.do\*VALOF(_do_LAB),\1
				endc
				ifnc	'\*VALOF(_do_shbr)','1'
					nbra		.do\*VALOF(_do_LAB),\1
				endc
_do_LAB		set	_do_LAB+1
			endm

	;example:
	;			tst.l		d0
	;			if.b		eq
	;				...
	;			else
	;				...
	;			endif
	;
_if_LAB		set	0

if			macro
				nbra\0	.else\*VALOF(_if_LAB),\1
				ifc	'\0','.b'
_if_shbr			set	1
				endc
				ifnc	'\0','.b'
_if_shbr			set	0
				endc
			endm

else		macro
				ifc	'\*VALOF(_if_shbr)','1'
					bra.b		.endif\*VALOF(_if_LAB)
				endc
				ifnc	'\*VALOF(_if_shbr)','1'
					bra		.endif\*VALOF(_if_LAB)
				endc
.else\*VALOF(_if_LAB):
			endm

endif		macro
			ifnd	.else\*VALOF(_if_LAB)
.else\*VALOF(_if_LAB):
			endc
.endif\*VALOF(_if_LAB):
_if_LAB		set	_if_LAB+1
			endm

	;example:
	;			loop		d0,100        (max word)
	;				...
	;			endloop
	;
_loop_LAB	set	0

loop		macro
				ifge	\2-128
					move.w	#\2-1,\1
				endc
				iflt	\2-128
					moveq		#\2-1,\1
				endc
.loop\*VALOF(_loop_LAB):
				ifc	'd0',\1
_lp_reg			set	0
				endc
				ifc	'd1',\1
_lp_reg			set	1
				endc
				ifc	'd2',\1
_lp_reg			set	2
				endc
				ifc	'd3',\1
_lp_reg			set	3
				endc
				ifc	'd4',\1
_lp_reg			set	4
				endc
				ifc	'd5',\1
_lp_reg			set	5
				endc
				ifc	'd6',\1
_lp_reg			set	6
				endc
				ifc	'd7',\1
_lp_reg			set	7
				endc
			endm

endloop	macro
				ifc	\*VALOF(_lp_reg),0
					dbra		d0,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),1
					dbra		d1,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),2
					dbra		d2,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),3
					dbra		d3,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),4
					dbra		d4,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),5
					dbra		d5,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),6
					dbra		d6,.loop\*VALOF(_loop_LAB)
				endc
				ifc	\*VALOF(_lp_reg),7
					dbra		d7,.loop\*VALOF(_loop_LAB)
				endc
_loop_LAB	set	_loop_LAB+1
			endm


	;Simple types
t_INTEGER		equ	1
t_NAME			equ	2
t_STRING			equ	3
t_STROP			equ	4
t_EOL				equ	5

	;Itemnumbers we can go to
I_EXECBASE		equ	2
I_INTBASE		equ	3
I_TASK			equ	4
I_LIBS			equ	5
I_DEVS			equ	6
I_RESO			equ	7
I_MEMORY			equ	8
I_INTERR			equ	9
I_PORT			equ	10
I_WINDOW			equ	11
I_SCREEN			equ	12
I_FONT			equ	13
I_DOSDEV			equ	14
I_FUNCMON		equ	15
I_SEMAPH			equ	16
I_RESMOD			equ	17
I_FILES			equ	18
I_LOCKS			equ	19
I_INPUTH			equ	20
I_FDFILES		equ	21
I_ATTACH			equ	22
I_CRASH			equ	23
I_GRAFBASE		equ	24
I_DEBUG			equ	25
I_STRUCT			equ	26
 IFD	D20
I_PUBSCR			equ	27
I_MONITOR		equ	28
I_LAST1			equ	28
 ENDC
 IFND	D20
I_LAST1			equ	26
 ENDC
I_CONFIG			equ	I_LAST1+1
I_LWIN			equ	I_LAST1+2
I_PWIN			equ	I_LAST1+3
I_LAST			equ	I_PWIN


SYSLASTNODE		equ	16				;Last valid system node at the moment
MYFIRSTNODE		equ	17				;First valid node for PowerVisor
MYLASTNODE		equ	22				;Last valid node for PowerVisor
NT_FUNCMON		equ	17
NT_FDFILE		equ	18
NT_KEYATT		equ	19
NT_CRASH			equ	20
NT_DEBUG			equ	21
NT_STRUCT		equ	22
NT_STRUCT2		equ	23

	;***
	;Structure definition for our port
	;***
 STRUCTURE myPort,MP_SIZE
	APTR		mp_CallTable			;Pointer to the PV Call Table
	UWORD		mp_BreakWanted			;If TRUE PowerVisor must stop
	LABEL		mp_SIZE

	;Execution levels for ExecuteInvisible
EXEC_CMDLINE	equ	0
EXEC_SCRIPT		equ	1
EXEC_ATTACH		equ	2
EXEC_FOR			equ	3
EXEC_TO			equ	4
EXEC_WITH		equ	5
EXEC_TG			equ	6
EXEC_ON			equ	7
EXEC_REFRESH	equ	8
EXEC_GROUP		equ	9
EXEC_SNAP		equ	10
EXEC_INTUITION	equ	11
EXEC_QUIT		equ	12
EXEC_SIGNAL		equ	13
EXEC_REOPEN		equ	14
EXEC_PPEXEC		equ	15
EXEC_ENTER		equ	16
EXEC_AFTER		equ	17
EXEC_MENU		equ	18
EXEC_WHILE		equ	19

ERROR_LIBRARY		equ	1
ERROR_SCREEN		equ	2
ERROR_MEMORY		equ	3
ERROR_FONT			equ	4
ERROR_MENU			equ	5
ERROR_OS				equ	6

REG_NONE				equ	0
REG_D0				equ	1
REG_D1				equ	2
REG_D2				equ	3
REG_D3				equ	4
REG_D4				equ	5
REG_D5				equ	6
REG_D6				equ	7
REG_D7				equ	8
REG_A0				equ	9
REG_A1				equ	10
REG_A2				equ	11
REG_A3				equ	12
REG_A4				equ	13
REG_A5				equ	14
REG_A6				equ	15
REG_A7				equ	16
REG_PC				equ	17
REG_SP				equ	18
REG_SR				equ	19


	;Special constants for the PP_SignalPowerVisor routine in the
	;powervisor.library
SIGNAL_BUSERR		equ	1
SIGNAL_BUSERRF		equ	2


	;Mode bits
mo_MemorySize	equ	0
mo_DispType		equ	2
mo_Lace			equ	4
mo_Super			equ	5
mo_FeedBack		equ	6
mo_More			equ	8
mo_List			equ	9
mo_Screen		equ	10
mo_SHex			equ	13
mo_Space			equ	14
mo_SBottom		equ	15
mo_LoneSpc		equ	16
mo_Fancy			equ	17
mo_Patch			equ	18
mo_IntuiWin		equ	19
mo_SBar			equ	20
mo_Dirty			equ	21

mof_MemorySize	equ	3
mof_DispType	equ	3
mof_Lace			equ	1
mof_Super		equ	1
mof_FeedBack	equ	3
mof_More			equ	1
mof_List			equ	1
mof_Screen		equ	7
mof_SHex			equ	1
mof_Space		equ	1
mof_SBottom		equ	1
mof_LoneSpc		equ	1
mof_Fancy		equ	1
mof_Patch		equ	1
mof_IntuiWin	equ	1
mof_SBar			equ	1
mof_Dirty		equ	1

moF_MemorySize	equ	mof_MemorySize<<mo_MemorySize
moF_DispType	equ	mof_DispType<<mo_DispType
moF_Lace			equ	mof_Lace<<mo_Lace
moF_Super		equ	mof_Super<<mo_Super
moF_FeedBack	equ	mof_FeedBack<<mo_FeedBack
moF_More			equ	mof_More<<mo_More
moF_List			equ	mof_List<<mo_List
moF_Screen		equ	mof_Screen<<mo_Screen
moF_SHex			equ	mof_SHex<<mo_SHex
moF_Space		equ	mof_Space<<mo_Space
moF_SBottom		equ	mof_SBottom<<mo_SBottom
moF_LoneSpc		equ	mof_LoneSpc<<mo_LoneSpc
moF_Fancy		equ	mof_Fancy<<mo_Fancy
moF_Patch		equ	mof_Patch<<mo_Patch
moF_IntuiWin	equ	mof_IntuiWin<<mo_IntuiWin
moF_SBar			equ	mof_SBar<<mo_SBar
moF_Dirty		equ	mof_Dirty<<mo_Dirty


	;***
	;End of include file
	;***
