*****
****
***			M M U   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Sun Mar  7 14:04:28 1993
***			© Jorrit Tyberghein
****
*****

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


			INCLUDE	"pv.i"
			INCLUDE	"pv.memory.i"
			INCLUDE	"pv.mmu.i"

			INCLUDE	"pv.errors.i"


	super
	mc68851
	mc68881
	mc68000

	XDEF		RoutMMUTree,RoutSpecRegs,RoutMMURegs
	XDEF		RoutSPoke,RoutSPeek,RoutMMUReset,GetVBR
	XDEF		FlushCache,FlushCacheSuper,GetMMUType
	XDEF		MMUConstructor,MMUDestructor,RoutWatch,OriginalPC
	XDEF		FuncGetMMUEntry,RoutProtect,DumpBERRs,RoutTagType
	XDEF		FAsc2Ext,FExt2Asc

	;eval
	XREF		ParseDec,SkipSpace
	;screen
	XREF		PrintRealHex,PrintRealHexNL,PrintChar
	;general
	XREF		MMUType,InstallDevice,RemoveDevice,GetTaskE,RealThisTask
	;main
	XREF		LastError,CheckOption,PVBase,PrintFor
	XREF		Storage
	;memory
	XREF		ApplyCommandOnTags,CheckTagAddress,AllocClear,UseTag,TagNum
	XREF		CheckTagListRange
	XREF		AllocMem,FreeMem,ReAlloc
	;list
	XREF		ApplyCommandOnList
	;68030
	XREF		GetMMUState
	XREF		UpdateMMUState
	XREF		FreeMMUState
	XREF		GetURP
	XREF		GetPageSize
	XREF		TestMMUTranslation
	XREF		ScanMMUTree
	XREF		GetTreeDescriptor
	XREF		GetTreeLogical
	XREF		GetTreePhysical
	XREF		GetTreeType
	XREF		GetTreeFlagsS
	XREF		GetTreeEntryS
	XREF		GetTreeLevel
	XREF		GetTreeBytes
	XREF		GetEntryInMMUTree

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	section MMUCode,code

	;***
	;Constructor: initialize everything for mmu
	;-> d0 = 0 if success (flags) else errorcode
	;***
MMUConstructor:
		jsr		(GetMMUState)
		lea		(MMUState,pc),a0
		move.l	d0,(a0)
		moveq		#0,d0
		rts

	;***
	;Destructor: remove everything for mmu
	;***
MMUDestructor:
		bsr		RemWatch
		movea.l	(MMUState,pc),a0
		jmp		(FreeMMUState)

;---------------------------------------------------------------------------
;Commands
;---------------------------------------------------------------------------

	;***
	;Command: install protected memory manager
	;***
RoutWatch:
		bsr		UpdateMMU
		move.l	(MMUType),d0
		ERROReq	YouNeedMMU

		move.w	(MyMMUInst,pc),d0
		bne.b		1$

	;Install
		bsr.w		MoveVBR
		bsr.w		RemoveMMUTree
		bsr.w		MakeMMUTree
		bsr.w		InstallMMUTree
		bsr.w		InstallTrapBus
		bsr.w		InstallResetHandler
		lea		(MsgWatchOn,pc),a0
2$		PRINT
		bra		UpdateMMU

	;Remove
1$		bsr.b		RemWatch
		lea		(MsgWatchOff,pc),a0
		bra.b		2$

	;***
	;Remove the memory protection system
	;***
RemWatch:
		bsr.w		RemoveResetHandler
		bsr.w		RemoveMMUTree
		bsr.w		RemoveTrapBus
		bsr.w		FreeMMUTree
		bra.w		RestoreVBR

	;***
	;Command: Reset all USED and MODIFIED flags in the MMU table
	;***
RoutMMUReset:
		moveq		#0,d0					;Reset them
		moveq		#16+8,d1				;USED and MODIFIED
		moveq		#0,d2					;All PAGE entries
		bra		SetAttrInMMUTree

RegTableSREG:
		dc.l		MsgMSP,RegMSP
		dc.l		MsgISP,RegISP
		dc.l		MsgUSP,RegUSP
		dc.l		MsgSFC,RegSFC
		dc.l		MsgDFC,RegDFC
		dc.l		MsgVBR,RegVBR
		dc.l		MsgCACR,RegCACR

RegTableCAAR:
		dc.l		MsgCAAR,RegCAAR

	;***
	;Command: show all special registers
	;***
RoutSpecRegs:
		lea		(SuperSREG,pc),a5
		CALLEXEC	Supervisor

		lea		(RegTableSREG,pc),a2
		moveq		#6,d2					;Loop 7 times
1$		bsr		PReg
		dbra		d2,1$

		lea		(RegCACR,pc),a2
		bsr.w		DescribeCACR

	;CAAR is not supported on the 68040
		move.l	(MMUType),d0
		cmp.l		#68040,d0
		bne.b		2$
		rts

2$		lea		(RegTableCAAR,pc),a2
		bra		PReg

SuperSREG:
		CALLEXEC	Disable
		lea		(RegMSP,pc),a0
	mc68030
		movec		msp,d0
		move.l	d0,(a0)+
		movec		isp,d0
		move.l	d0,(a0)+
		movec		usp,d0
		move.l	d0,(a0)+
		movec		sfc,d0
		move.l	d0,(a0)+
		movec		dfc,d0
		move.l	d0,(a0)+
		movec		vbr,d0
		move.l	d0,(a0)+
		movec		cacr,d0
		move.l	d0,(a0)+
	mc68000
	;CAAR is not supported on the 68040
		move.l	(MMUType),d0
		cmp.l		#68040,d0
		beq.b		1$
	mc68030
		movec		caar,d0
		move.l	d0,(a0)+
	mc68000
1$		CALL		Enable
		rte

	;***
	;Command: poke value in memory (long) using supervisor
	;***
RoutSPoke:
		EVALE								;Get address
		movea.l	d0,a2
		EVALE								;Get long value
		move.l	d0,d2

		move.l	(MMUType),d0
		ERROReq	YouNeedMMU

		lea		(SuperPoke,pc),a5
		CALLEXEC	Supervisor
		rts

	;This routine could fail if there are translations from logical
	;addresses to different physical addresses and this routine just
	;falls in such a trap. As far as I know these translations currently
	;do not happen, so this should not be a problem in the near future
SuperPoke:
		CALLEXEC	Disable

		lea		(-4,a7),a7			;Allocate room on stack
		pmove.l	tc,(a7)				;Remember old TC register
		pea		(0).w
		pmove.l	(a7),tc				;Disable MMU translation
		move.l	d2,(a2)
		pmove.l	(4,a7),tc			;Restore old TC register
		lea		(8,a7),a7			;Clean stack

		CALL		Enable
		rte

	;***
	;Command: peek value from memory (long) using supervisor
	;***
RoutSPeek:
		EVALE								;Get address
		movea.l	d0,a2

		move.l	(MMUType),d0
		ERROReq	YouNeedMMU

		lea		(SuperPeek,pc),a5
		CALLEXEC	Supervisor
		move.l	d2,d0
		PRINTHEX
		rts

	;This routine could fail if there are translations from logical
	;addresses to different physical addresses and this routine just
	;falls in such a trap. As far as I know these translations currently
	;do not happen, so this should not be a problem in the near future
SuperPeek:
		CALLEXEC	Disable

		lea		(-4,a7),a7
		pmove.l	tc,(a7)				;Remember old TC register
		pea		(0).w
		pmove.l	(a7),tc				;Disable MMU translation
		move.l	(a2),d2
		pmove.l	(4,a7),tc			;Restore old TC register
		lea		(8,a7),a7			;Clean stack

		CALL		Enable
		rte

	;***
	;Command: show or set the use of each tag list for the memory
	;protection system
	;***
RoutTagType:
		move.l	(MMUType),d0
		ERROReq	YouNeedMMU

		NEXTTYPE
		bne.b		1$

	;Show all tag lists and there use
		moveq		#0,d2
		lea		(TldTable,pc),a2
	mc68030
2$		move.l	(tld_Task,a2,d2.w*8),d0
	mc68000
		addq.l	#1,d0					;If -1 it will be zero now
		beq.b		3$
		subq.l	#1,d0

	;Yes, this tag list is used
		lea		(FormatTld,pc),a0
		move.l	d0,-(a7)
		move.w	d2,-(a7)
		movea.l	a7,a1
		jsr		(PrintFor)
		PFLONG	2
		PFWORD	0
		PFEND
		lea		(6,a7),a7


3$		addq.w	#1,d2
		cmp.w		#16,d2
		blt.b		2$

		rts

	;Set the use for a tag list
1$		EVALE
		jsr		(CheckTagListRange)
		move.l	d0,d2					;Remember tag list number
		ERROReq	CantChangeTagList0
		lea		(TldTable,pc),a2
	mc68030
		lea		(tld_Task,a2,d2.w*8),a2
	mc68000
		NEXTTYPE
		beq.b		5$

	;There is an extra argument (task)
		jsr		(GetTaskE)
		move.l	d0,(a2)				;Fill in
4$		ERROReq	BadArgValue
		addq.l	#1,d0					;Test for -1
		beq.b		4$
		rts

	;There is no extra argument, so this tag list is no longer
	;used for memory protection purposes
5$		moveq		#-1,d0
		move.l	d0,(a2)
		rts

	;***
	;Command: protect memory according to all the tag lists. This
	;routine uses the 'TldTable' to see which tag lists are used
	;and which not.
	;Tag list 0 is always used for global memory protection
	;Note! We make the following assumptions:
	;	- We assume that the page size is larger than 256 bytes. In this
	;	  case we can use some bits of the page address for our own
	;	  purposes. We only need one bit (the least significant bit,
	;	  from the 24 bit page address). This bit is set for all pages
	;	  that we are allowed to protect (set to invalid or WP)
	;	- We also assume that all 'INV' entries in the MMU table have
	;	  a correct physical address. When this assumption is true we
	;	  can also use the above bit for the same purpose
	;	- These bits are set by the 'MakeMMUTree' function
	;***
RoutProtect:
		move.w	(MyMMUInst,pc),d0
		ERROReq	FirstInstallWatch

		moveq		#%00000001,d0
		moveq		#%00000111,d1		;Set to PAGE and not WP
		moveq		#1,d2					;Only entries with special bit set
		bsr.w		SetAttrInMMUTree

		bsr.w		ComputeMMU

		move.l	(TagNum),-(a7)		;Remember current tag list
		moveq		#15,d2				;Loop 16 times
		lea		(TldTable,pc),a2
	mc68030
1$		move.l	(tld_Task,a2,d2.w*8),d0
	mc68000
		addq.l	#1,d0					;If -1 it will be zero now
		beq.b		2$

	;Protect for the ranges in this tag list
		move.l	d2,d0
		jsr		(UseTag)
		lea		(ProtectTag,pc),a5
		CALLEXEC	Disable
		jsr		(ApplyCommandOnTags)
		CALLEXEC	Enable

2$		dbra		d2,1$

		move.l	(a7)+,d0				;Restore old current tag list
		jmp		(UseTag)

	;---
	;a0 = pointer to tag
	;---
ProtectTag:
		move.l	d2,-(a7)
		move.w	(tag_Flags,a0),d0
		btst.l	#BTAG_RPROTECT,d0
		beq.b		1$

	;Read protect this range (write will be allowed by simulation)
		move.l	(tag_Size,a0),d0
		movea.l	(tag_Address,a0),a0
		moveq		#%0000,d1			;Bits
		moveq		#%0011,d2			;Mask (set invalid)
		bsr		ProtectRange
		bra.b		2$

1$		btst.l	#BTAG_WPROTECT,d0
		beq.b		2$

	;Write protect this range
		move.l	(tag_Size,a0),d0
		movea.l	(tag_Address,a0),a0
		moveq		#%0100,d1			;Bits
		moveq		#%0100,d2			;Mask (set WP)
		bsr		ProtectRange

2$		move.l	(a7)+,d2
		rts

	;***
	;Command: show MMU tree (DEBUG: FC tree not supported yet)
	;This command supports the 68020, 68030 and 68040
	;***
RoutMMUTree:
		bsr		UpdateMMU
		lea		(PrintMMUTree,pc),a2
		jmp		(ScanMMUTree)		;No UserData

	;***
	;Update the processor state, this function does not return if there is an error
	;-> a0 = MMU State
	;***
UpdateMMU:
		move.l	(MMUState,pc),d0
		ERROReq	YouNeedMMU
		movea.l	d0,a0
		jmp		(UpdateMMUState)

	;***
	;Print an entry from the MMU tree (called from within ScanMMUTree)
	;a0 = private MMU state pointer
	;***
PrintMMUTree:
		movea.l	a0,a2
		jsr		(GetTreeDescriptor)
		jsr		(PrintRealHexNL)
		movea.l	a2,a0
		jsr		(GetTreeLevel)
		bsr.w		Print3Spaces

		lea		(PrintSpace,pc),a1
		move.l	#$20202020,(a1)
		move.l	#$20202000,(4,a1)
		movea.l	a2,a0
		jsr		(GetTreeEntryS)
		lea		(PrintSpace,pc),a0
		PRINT

		moveq		#'(',d0
		jsr		(PrintChar)
		lea		(PrintSpace,pc),a1
		move.l	#$20202020,(a1)
		move.l	#')  '<<8,(4,a1)
		movea.l	a2,a0
		jsr		(GetTreeFlagsS)
		lea		(PrintSpace,pc),a0
		PRINT

		lea		(MsgLog,pc),a0
		PRINT

		movea.l	a2,a0
		jsr		(GetTreeLogical)
		jsr		(PrintRealHexNL)

		lea		(MsgBytesTree,pc),a0
		PRINT

		movea.l	a2,a0
		jsr		(GetTreeBytes)
		jsr		(PrintRealHexNL)

		movea.l	a2,a0
		jsr		(GetTreeType)
		cmp.b		#1,d0
		bne.b		1$

	;It is a page
		lea		(MsgPhysicalTree,pc),a0
		PRINT

		movea.l	a2,a0
		jsr		(GetTreePhysical)
		jsr		(PrintRealHexNL)

1$		NEWLINE
		rts

	;***
	;Command: show all special registers
	;***
RoutMMURegs:
		bsr.w		GetMMURegisters

		lea		(ExistsTable,pc),a3

	;Describe DRP
		lea		(MsgDRP,pc),a0
		move.b	(a3)+,d0
		beq.b		1$
		lea		(RegDRP,pc),a2
		bsr.w		PrintRP
		bsr.w		DescribeRP
	;Describe CRP
1$		lea		(MsgCRP,pc),a0
		move.b	(a3)+,d0
		beq.b		2$
		lea		(RegCRP,pc),a2
		bsr.w		PrintRP
		bsr.w		DescribeRP
	;Describe SRP
2$		lea		(MsgSRP,pc),a0
		move.b	(a3)+,d0
		beq.b		3$
		lea		(RegSRP,pc),a2
		bsr.w		PrintRP
		bsr.w		DescribeRP
	;Describe TC
3$		lea		(MsgTC,pc),a0
		move.b	(a3)+,d0
		beq.b		4$
		lea		(RegTC,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTC
	;Describe TT0
4$		lea		(MsgTT0,pc),a0
		move.b	(a3)+,d0
		beq.b		5$
		lea		(RegTT0,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTT
	;Describe TT1
5$		lea		(MsgTT1,pc),a0
		move.b	(a3)+,d0
		beq.b		6$
		lea		(RegTT1,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTT
	;Describe URP for 68040
6$		lea		(MsgURP40,pc),a0
		move.b	(a3)+,d0
		beq.b		7$
		lea		(RegURP40,pc),a2
		bsr.w		PrintReg
	;Describe SRP for 68040
7$		lea		(MsgSRP40,pc),a0
		move.b	(a3)+,d0
		beq.b		8$
		lea		(RegSRP40,pc),a2
		bsr.w		PrintReg
	;Describe TC for 68040
8$		lea		(MsgTC40,pc),a0
		move.b	(a3)+,d0
		beq.b		9$
		lea		(RegTC40,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTC40
	;Describe DTT0 for 68040
9$		lea		(MsgDTT040,pc),a0
		move.b	(a3)+,d0
		beq.b		10$
		lea		(RegDTT040,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTT40
	;Describe DTT1 for 68040
10$	lea		(MsgDTT140,pc),a0
		move.b	(a3)+,d0
		beq.b		11$
		lea		(RegDTT140,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTT40
	;Describe ITT0 for 68040
11$	lea		(MsgITT040,pc),a0
		move.b	(a3)+,d0
		beq.b		12$
		lea		(RegITT040,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTT40
	;Describe ITT0 for 68040
12$	lea		(MsgITT140,pc),a0
		move.b	(a3)+,d0
		beq.b		13$
		lea		(RegITT140,pc),a2
		bsr.w		PrintReg
		bsr.w		DescribeTT40
13$	rts

;---------------------------------------------------------------------------
;The Memory Protection System
;---------------------------------------------------------------------------

	;***
	;Install the bus error trap handler
	;***
InstallTrapBus:
		move.l	(PBusT,pc),d0
		bne.b		1$

	;Install it
		bsr.w		GetVBR
		movea.l	d0,a1
		lea		(8,a1),a1			;Bus error vector
		lea		(PBusT,pc),a0
		move.l	(a1),(a0)
		lea		(BusJumpAddress+2,pc),a0
		move.l	(a1),(a0)
		lea		(BusHandler,pc),a0
		move.l	a0,(a1)

	;Install the bus error table
		move.l	(BusErrTable,pc),d0
		bne.b		1$
		move.l	#MAXBERR*berr_SIZE,d0
		jsr		(AllocClear)
		lea		(BusErrTable,pc),a0
		move.l	d0,(a0)+
		clr.l		(a0)					;Also install the number of the last
											;bus error entry here
1$		rts

	;***
	;Remove the bus error trap handler
	;***
RemoveTrapBus:
		move.l	(PBusT,pc),d0
		beq.b		1$

	;Remove it
		bsr.w		GetVBR
		movea.l	d0,a1
		lea		(8,a1),a1			;Bus error vector
		lea		(PBusT,pc),a0
		move.l	(a0),(a1)
		clr.l		(a0)

	;Remove the bus error table
		move.l	(BusErrTable,pc),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	#MAXBERR*berr_SIZE,d0
		jsr		(FreeMem)
		lea		(BusErrTable,pc),a0
		clr.l		(a0)

1$		rts

	;***
	;Show all bus errors recorded in the bus error table and make
	;the table empty afterwards. Please not that this table may grow
	;while we are looking at it. So we should always look back at the
	;total number of recorded bus errors
	;d0 = signal number
	;***
DumpBERRs:
		movem.l	a0-a2/d1-d4,-(a7)
		cmp.l		#SIGNAL_BUSERRF,d0
		bne.b		4$
		lea		(MsgFrozenTask,pc),a0
		PRINT

4$		moveq		#0,d2					;Current entry we are looking at
		move.w	(MissedBusError,pc),d4

1$		cmp.l		(BusErrNum,pc),d2
		bge.b		3$

		move.l	d2,d0
		lsl.l		#5,d0					;Multiply by 32 (berr_SIZE)
		movea.l	(BusErrTable,pc),a2
		adda.l	d0,a2					;Point to entry

	;Print entry
		lea		(FormatBusErr,pc),a0
		movea.l	a2,a1
		jsr		(PrintFor)
		PFLONG	berr_Flags
		PFLONG	berr_Value
		PFLONG	berr_SP
		PFLONG	berr_PC
		PFLONG	berr_Task
		PFLONG	berr_FaultAddress
		PFEND

		addq.l	#1,d2					;Next entry
		bra.b		1$

3$		add.w		(MissedBusError,pc),d4
		beq.b		2$
		lea		(MsgMissedBERR,pc),a0
		PRINT

	;Make table empty
2$		CALLEXEC	Disable
		lea		(MissedBusError,pc),a0
		clr.w		(a0)+
		lea		(4,a0),a0
		clr.l		(a0)
		CALL		Enable
		movem.l	(a7)+,a0-a2/d1-d4
		rts

	;***
	;Stop the offending bus error task but not if this task is equal
	;to PowerVisor
	;a7+28 = bus error stack frame
	;-> d0 is preserved
	;***
FreezeBERRtask:
		move.l	d0,-(a7)

	;Don't stop PowerVisor
		movea.l	(SysBase).w,a6
		move.l	(ThisTask,a6),d0
		cmp.l		(RealThisTask),d0
		beq.b		1$

	;Yes, we can stop
		moveq		#SIGNAL_BUSERRF,d0
		suba.l	a0,a0					;No replyport
		CALLPV	PP_SignalPowerVisor

		move.l	(32+2,a7),d0		;PC
		lea		(OriginalPC,pc),a1
		move.l	d0,(a1)

		ori.w		#$8000,(32,a7)		;Enable trace mode

1$		move.l	(a7)+,d0
		rts

	;To stop the offending bus error task we use the trace exception.
	;The crash handler (and 'CrashSignal') will take care of all
	;crash specific handling (such as the adding of the crash node
	;and the printing of the message).
OriginalPC:
		dc.l		0						;Pointer to original program counter

	;***
	;Add a bus error specification to the bus error table if this table
	;is not full. If this table is full, we will miss some bus errors
	;This routine also sends a signal to PowerVisor
	;a7+28 = bus error stack frame
	;-> d0 is preserved
	;***
AddBERRspec:
		move.l	d0,-(a7)
		move.l	(BusErrTable,pc),d0
		bne.b		1$
		move.l	(a7)+,d0
		rts

1$		lea		(MissedBusError,pc),a1
		move.w	#1,(a1)				;It is possible that we miss a bus error

		movea.l	d0,a0
		lea		(BusErrNum,pc),a1
		move.l	(a1),d0
		cmp.l		#MAXBERR,d0
		bge.b		4$

	;There is a table and it is not full
		addq.l	#1,(a1)
		lea		(MissedBusError,pc),a1
		clr.w		(a1)					;We don't miss this bus error
		lsl.l		#5,d0					;Multiply with 32 == berr_SIZE
		lea		(0,a0,d0.l),a0		;Pointer to bus error entry (berr)
		move.l	(32+16,a7),(berr_FaultAddress,a0)
		movea.l	(SysBase).w,a6
		move.l	(ThisTask,a6),(berr_Task,a0)
		move.l	(32+2,a7),(berr_PC,a0)
		move.l	usp,a1
		move.l	a1,(berr_SP,a0)

	;Get value to write and Read/Write flags
		moveq		#0,d0					;Value to write
		moveq		#0,d1					;Flags

		btst.b	#6,(32+11,a7)		;RW (Read Write)
		bne.b		3$
	;Write
		bset.l	#berrB_Write,d1
		move.l	(32+$18,a7),d0		;Data output buffer
		bra.b		2$
	;Read
3$		bset.l	#berrB_Read,d1
2$		move.l	d0,(berr_Value,a0)

	;Get size of offense (SIZE field in SSW)
	mc68030
		bfextu	(32+10,a7){10:2},d0
		bfins		d0,d1{31-berrB_Size2:2}
	mc68000

		move.l	d1,(berr_Flags,a0)

4$		moveq		#SIGNAL_BUSERR,d0
		suba.l	a0,a0					;No replyport
		CALLPV	PP_SignalPowerVisor
		move.l	(a7)+,d0
		rts

	;***
	;Bus error handler. This routine is called whenever a bus error occurs.
	;This routine will simulate the failed read or write if it is not in
	;one of our protected tags. Otherwise the powerled is blinked and the
	;action is ignored
	;***

	;***
	;Check if an address is in the tag lists and if we are the correct
	;task
	;a0 = address
	;-> d0 = 0 if not in one of the tag lists (flags)
	;-> a1 = pointer to tag
	;***
CheckAddressInTags:
		movem.l	d2/a2-a3,-(a7)
		move.l	(TagNum),-(a7)		;Remember current tag list
		movea.l	a0,a3
		moveq		#15,d2				;Loop 16 times (once for each tag list)
		lea		(TldTable,pc),a2

	mc68030
1$		move.l	(tld_Task,a2,d2.w*8),d0
	mc68000
		addq.l	#1,d0					;If -1 it will be zero now
		beq.b		2$
		subq.l	#1,d0					;Restore
		beq.b		3$						;If global, we always check

	;Not global
		movea.l	(SysBase).w,a6
		cmp.l		(ThisTask,a6),d0
		bne.b		2$						;Not this task

3$		move.l	d2,d0
		jsr		(UseTag)
		movea.l	a3,a0
		jsr		(CheckTagAddress)	;Check if we must recover or ignore
		beq.b		2$

	;It is in the list, first check if it is a tag which has something to
	;do with memory protection
	;a1 = pointer to tag
	mc68030
		bftst		(tag_Flags,a1){13:3}	;WRITE, READ or IGNORE bits
	mc68000
		bne.b		4$						;If not zero, it is a protection tag

2$		dbra		d2,1$

		moveq		#0,d0					;Not in one of the lists

4$		move.l	d0,d2
		movea.l	a1,a2					;Remember tag
		move.l	(a7)+,d0				;Restore old current tag list
		jsr		(UseTag)
		movea.l	a2,a1					;Restore tag
		move.l	d2,d0					;Flags
		movem.l	(a7)+,d2/a2-a3
		rts

	;This label is called whenever there is a bus error failure and
	;this failure is in a tag range
	;a1 = pointer to tag list
ShowFailure:
		move.w	(tag_Flags,a1),d0
		btst.l	#BTAG_PPRINT,d0
		beq.b		1$

	;Yes, we use the portprint library to show that there was a
	;problem
		bsr.w		AddBERRspec
		bra.b		2$

1$		bchg.b	#1,($bfe001)		;Toggle the power LED

	;Check if the task should be frozen
2$		btst.l	#BTAG_FREEZE,d0
		beq.b		3$

	;Yes! Freeze it
		bsr.w		FreezeBERRtask

3$		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

	;***
	;Start entry for the bus handler
	;***
BusHandler:
		btst.b	#0,(10,a7)			;DF (Data Fault) Bit 8 of SSW
		beq.w		SingleStepInst		;No data fault

	;Data Fault
		bclr.b	#0,(10,a7)			;Clear DF (Data Fault)
		btst.b	#6,(11,a7)			;RW (Read Write)
		beq.b		2$
		clr.l		($2c,a7)				;Set data input buffer to 0

	;There was a data fault (read or write) bus error
2$		movem.l	d0-d1/a0-a2/a6,-(a7)
		bsr.w		GetCRPandTCsuper
		movea.l	(24+16,a7),a1		;Fault address
		movea.l	(MMUState,pc),a0
		jsr		(GetEntryInMMUTree)
		tst.l		d0
		beq.b		3$						;It is not our concern!
		movea.l	d0,a2

		btst.b	#6,(24+11,a7)		;RW (Read Write) Bit 6 of SSW
		bne.b		1$						;Read

	;There was a write data fault bus error
	;We will recover if needed
		movea.l	(24+16,a7),a0		;Fault address
		bsr.w		CheckAddressInTags
		beq.b		SimulateWrite
		move.w	(tag_Flags,a1),d0
		and.w		#FTAG_WPROTECT,d0
		beq.b		SimulateWrite

		bra.b		ShowFailure

3$		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

	;There was a read data fault bus error
	;We will recover if needed
1$		movea.l	(24+16,a7),a0		;Fault address
		bsr.w		CheckAddressInTags
		beq.b		SimulateRead
		move.w	(tag_Flags,a1),d0
		and.w		#FTAG_RPROTECT,d0
		beq.b		SimulateRead

		bra.w		ShowFailure

	;***
	;We had a write data fault bus error, but the address was not in
	;a protected range. So we should simulate the write on behalf of
	;the failing program
	;a2 = pointer to MMU entry
	;***
SimulateWrite:
		move.l	(a2),d0
		btst.l	#8,d0					;Test special bit
		beq.b		2$						;It is not one of our own entries
											;Do not simulate the write because this
											;could be harmful. We simply ignore the
											;write action (no message, no simulation)

	;It is one of our own entries
		move.l	(a2),d0
		move.l	d0,d1					;Remember this entry contents
		andi.b	#~%111,d0			;Clear WP
		ori.b		#%001,d0				;Set to valid PAGE
		move.l	d0,(a2)
		bsr.w		FlushCacheSuper

	;Simulate the write
		movea.l	(24+16,a7),a0		;Fault address
		move.l	(24+$18,a7),d0		;Data to write
		btst.b	#4,(24+11,a7)		;One of the two SIZE bits
		beq.b		3$
	;byte
		move.b	d0,(a0)
		bra.b		5$

3$		btst.b	#5,(24+11,a7)		;One of the two SIZE bits
		beq.b		4$
	;word
		move.w	d0,(a0)
		bra.b		5$

	;long
4$		move.l	d0,(a0)

5$		move.l	d1,(a2)				;Restore entry contents
		bsr.w		FlushCacheSuper

2$		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

	;***
	;We had a read data fault bus error, but the address was not in
	;a protected range. So we should simulate the read on behalf of
	;the failing program
	;a2 = pointer to MMU entry
	;***
SimulateRead:
		move.l	(a2),d0
		move.l	d0,d1					;Remember this entry contents
		andi.b	#~%11,d0
		ori.b		#%01,d0				;Set to valid PAGE
		move.l	d0,(a2)
		bsr.w		FlushCacheSuper

	;Simulate the read
		movea.l	(24+16,a7),a0		;Fault address
		moveq		#0,d0
		btst.b	#4,(24+11,a7)		;One of the two SIZE bits
		beq.b		3$
	;byte
		move.b	(a0),d0
		bra.b		5$

3$		btst.b	#5,(24+11,a7)		;One of the two SIZE bits
		beq.b		4$
	;word
		move.w	(a0),d0
		bra.b		5$

	;long
4$		move.l	(a0),d0

5$		move.l	d0,(24+$2c,a7)		;Data input buffer
		move.l	d1,(a2)				;Restore entry contents
		bsr.w		FlushCacheSuper

		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

BusJumpAddress:
		jmp		($00000000).l

	;***
	;Simulate all other unrecognized bus errors by single-stepping the
	;instruction
	;***
SingleStepInst:
		movem.l	d0-d1/a0-a2/a6,-(a7)

		bsr.w		GetCRPandTCsuper
		movea.l	(24+16,a7),a1		;Fault address
		movea.l	(MMUState,pc),a0
		jsr		(GetEntryInMMUTree)
		tst.l		d0
		beq.b		1$						;It is not our concern!
		movea.l	d0,a2

		movea.l	(24+16,a7),a0		;Fault address
		bsr.w		CheckAddressInTags
		beq.b		RecoverBUSERR
		move.w	(tag_Flags,a1),d0
		and.w		#FTAG_WPROTECT+FTAG_RPROTECT,d0
		beq.b		RecoverBUSERR

	;BUG
	;We should freeze here, because we can't simply let the program
	;continue executing. We would get continious bus errors
		bra.w		ShowFailure

1$		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

	;Recover from a bus error (write data fault only at this moment)
RecoverBUSERR:
		lea		(RememberInt,pc),a1
		move.w	($dff01c),(a1)+
	mc68030
		movec		vbr,a0
	mc68000
		lea		(9*4,a0),a0			;Trace vector
		move.l	(a0),(a1)+			;Remember original trace vector
		ori.w		#$8000,(24,a7)		;Enable trace mode

		move.l	a2,(a1)+				;Remember entry
		move.l	(a2),d0
		move.l	d0,(a1)				;Remember entry contents
		andi.b	#~%111,d0			;Clear WP
		ori.b		#%001,d0				;Set to valid PAGE
		move.l	d0,(a2)				;Store new entry contents

		lea		(TraceRoutine,pc),a1
		move.l	a1,(a0)				;Install new trace vector

		bsr.w		FlushCacheSuper

		move.w	#$4000,($dff09a)
		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

RememberInt:	dc.w	0
OrigTraceVec:	dc.l	0
RememberEntry:	dc.l	0
RememberVal:	dc.l	0

	;Trace routine to solve a bus error
TraceRoutine:
		movem.l	d0-d1/a0-a2/a6,-(a7)

		andi.w	#$3fff,(24,a7)		;Disable trace mode
	mc68030
		movec		vbr,a0
	mc68000
		lea		(9*4,a0),a0			;Trace vector
		lea		(OrigTraceVec,pc),a1
		move.l	(a1)+,(a0)			;Restore trace vector

		move.l	(RememberVal,pc),(a1)

		bsr.w		FlushCacheSuper

		move.w	(RememberInt,pc),d0
		btst		#14,d0
		beq.b		1$
		move.w	#$C000,($dff09a)
1$		movem.l	(a7)+,d0-d1/a0-a2/a6
		rte

	;***
	;Set protection for range
	;Only PAGE entries are changed, and only entries are changed with
	;the special bit set (the least significant bit of the 24 bit page
	;address, we assume here that the page size is more than 256 bytes so
	;that we can effectively use this bit)
	;WARNING! You must call 'ComputeMMU' before you call this routine
	;Note that this routine will never lower the level of protection for
	;a certain range: if a range is already read/write protected (INV)
	;it will not be put back to write protect (WP)
	;a0 = start address
	;d0 = number of bytes to protect
	;d1 = protection bits (u, wp, dt)
	;d2 = protection mask
	;***
ProtectRange:
		movem.l	a2/d3-d5,-(a7)
		movea.l	a0,a2					;Start address
		move.l	d0,d4					;Number of bytes
		move.l	d1,d3					;Protection bits
		and.l		d2,d3					;Mask out all bits that need not be changed
		not.l		d2						;Invert mask

		moveq		#0,d5
		move.w	(TSize,pc),d5

	;Change last entry
		movea.l	a2,a1
		adda.l	d4,a1
		subq.l	#1,a1
		movea.l	(MMUState,pc),a0
		jsr		(GetEntryInMMUTree)
		tst.l		d0
		beq.b		2$
		bsr.b		3$						;Change entry

	;Change all other entries
2$		movea.l	a2,a1
		movea.l	(MMUState,pc),a0
		jsr		(GetEntryInMMUTree)
		tst.l		d0
		beq.b		1$
		bsr.b		3$						;Change entry
		adda.l	d5,a2
		sub.l		d5,d4
		bge.b		2$

1$		bsr.w		FlushCache
		movem.l	(a7)+,a2/d3-d5
		rts

	;Change entry. This routine checks if the entry is a PAGE entry
	;before changing it. If it is INV the entry is already protected
	;enough
	;d0 = pointer to entry
	;d2 = mask
	;d3 = bits
3$		movea.l	d0,a0
	mc68030
		bfextu	(a0){30:2},d1
	mc68000
		subq.b	#1,d1
		bne.b		4$						;If not zero we don't have a PAGE entry

		move.l	(a0),d0
		btst.l	#8,d0					;Test our special bit
		beq.b		4$						;If 0 we do not change this entry

		and.l		d2,d0
		or.l		d3,d0
		move.l	d0,(a0)
4$		rts

	;***
	;Return an estimate of the required size of the PowerVisor MMU table
	;This function looks at the 'memr' list to determine all
	;memory in the system
	;
	;1024 = size of root table (4*256)
	;256  = size of second level table (4*64)
	;256  = size of third level table (4*64)
	;1024 = extra for the right allignment
	;
	;-> d0 = number of second level tables
	;-> d1 = number of third level tables
	;-> d2 = size of MMU table
	;***
GetMMUTreeSize:
		move.l	d4,-(a7)
		moveq		#0,d4
		moveq		#I_MEMORY,d0
		lea		(GetSizeSub,pc),a0
		jsr		(ApplyCommandOnList)

	;d4 is now the number of bytes available as normal RAM
	;We will now estimate the size of the MMU table using this
	;parameter. This estimate in fact slightly overestimates
	;the really needed size, but this is no big deal since the table
	;is not very large anyway
		bsr.w		Count2ndLevelTables

		move.l	d4,d1
		lsr.l		#8,d1					;6 bits for level C and 12 bits for page
		lsr.l		#8,d1
		lsr.l		#2,d1					;Divide by 256K (the size represented
											;by a third level table)
											;d1 = number of third level tables needed

		move.l	#1024*2,d2			;Size of root table (4*256) and size
											;for the right allignment
		move.l	d0,d4
		lsl.l		#6+2,d4				;6 bits for level B (4 bytes per entry)
		add.l		d4,d2

		move.l	d1,d4
		lsl.l		#6+2,d4				;6 bits for level C (4 bytes per entry)
		add.l		d4,d2

		move.l	(a7)+,d4
		rts

	;***
	;Subroutine called by 'ApplyCommandOnList' to compute the total
	;size for all memory
	;a2 = address to memory region header
	;a3 = ptr to InfoBlock
	;d4 = current size
	;-> d4 = new size
	;***
GetSizeSub:
		move.l	(MH_LOWER,a2),d0
		and.l		#-65536,d0			;Allign to get real start of region
		move.l	(MH_UPPER,a2),d1
		sub.l		d0,d1					;Size of this region
		add.l		d1,d4
		moveq		#1,d1
		rts

	;***
	;Little subroutine used by 'MakeMMUTree' to quickly calculate
	;the offset in the MMU tree for a second level table
	;d0 = number of the required second level table
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d0 = offset
	;-> all other registers are preserved
	;***
Get2nd:
		lsl.l		#6+2,d0				;6 bits for level B (4 bytes per entry)
		add.l		#1024,d0				;Skip root entry
		rts

	;***
	;Little subroutine used by 'MakeMMUTree' to quickly calculate
	;the offset in the MMU tree for a third level table
	;d0 = number of the required third level table
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d0 = offset
	;-> all other registers are preserved
	;***
Get3th:
		add.l		d3,d0					;Little trick that works because the number
											;of bits in level B and C are the same (6)
		lsl.l		#6+2,d0				;6 bits for level B and C (4 bytes per entry)
		add.l		#1024,d0
		rts

	;***
	;Check if an integer is in a region
	;a0 = integer to check
	;d0,d1 = low/high of region
	;-> flags NE if integer in region
	;-> all registers are unchanged
	;***
InRegion:
		move.l	d2,-(a7)
		moveq		#0,d2
		cmp.l		a0,d0
		bgt.b		1$
		cmp.l		a0,d1
		ble.b		1$
		moveq		#1,d2
1$		tst.l		d2
		movem.l	(a7)+,d2				;For flags
		rts

	;***
	;Check if one region overlaps another region. Use this function twice
	;to make sure all possible size differences are accounted for
	;d0,d1 = low/high of region 1 (must be larger than region 2)
	;d2,d3 = low/high of region 2
	;-> flags NE if region 2 overlaps region 1
	;-> all registers are unchanged
	;***
CheckOverlap:
		move.l	a0,-(a7)

		movea.l	d2,a0
		bsr.b		InRegion
		bne.b		1$
		movea.l	d3,a0
		subq.l	#1,a0
		bsr.b		InRegion

1$		movea.l	(a7)+,a0
		rts

	;***
	;Check if there is a memory header region that overlaps with this
	;16 Megabytes page in physical memory
	;d0 = address (multiple of 16 Megabytes)
	;-> flags NE if there is an overlap somewhere
	;-> all registers are preserved
	;***
CheckHeaderIn16M:
		movem.l	d0-d3/a1,-(a7)

		move.l	d0,d2
		move.l	d0,d3
		add.l		#$01000000,d3

In16MCheck:
		movea.l	(SysBase).w,a6
		movea.l	(MemList,a6),a1

	;For each memory header
1$		tst.l		(a1)					;Succ
		beq.b		2$

		move.l	(MH_LOWER,a1),d0
		and.l		#-65536,d0			;Allign to get real start of region
		move.l	(MH_UPPER,a1),d1
		bsr.w		CheckOverlap
		bne.b		3$

		exg		d0,d2
		exg		d1,d3
		bsr.w		CheckOverlap
		bne.b		3$
		exg		d0,d2
		exg		d1,d3

		movea.l	(a1),a1				;Succ
		bra.b		1$

	;No
2$		moveq		#0,d1					;For flags
4$		movem.l	(a7)+,d0-d3/a1
		rts

	;Yes
3$		moveq		#1,d1					;For flags
		bra.b		4$

	;***
	;Check if there is a memory header region that overlaps with this
	;256 KByte page in physical memory
	;d0 = address (multiple of 256 Kbytes)
	;-> flags NE if there is an overlap somewhere
	;-> all registers are preserved
	;***
CheckHeaderIn256K:
		movem.l	d0-d3/a1,-(a7)
		move.l	d0,d2
		move.l	d0,d3
		add.l		#$00040000,d3
		bra.b		In16MCheck

	;***
	;Count all needed 2nd level tables
	;-> d0 = number of needed 2nd level tables
	;***
Count2ndLevelTables:
		movem.l	d1-d2,-(a7)

		moveq		#0,d0					;First physical address to start
		moveq		#127,d1				;Loop 128 times (2 gigabytes)
		moveq		#0,d2

1$		bsr.w		CheckHeaderIn16M
		beq.b		2$
	;There is an overlap
		addq.l	#1,d2
2$		add.l		#$01000000,d0		;Next 16 Megabytes
		dbra		d1,1$

		move.l	d2,d0
		movem.l	(a7)+,d1-d2
		rts

	;***
	;Init all second level tables for MMU tree.
	;This routine also initialized the root table to point to these
	;2nd level tables. The physical address are also filled in
	;For each second level table only the first physical address
	;is initialized. 'Init3thLevel' will do the rest
	;a2 = pointer to root
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d2 = scratch
	;***
Init2ndLevel:
		movea.l	a2,a0					;Pointer to root

		moveq		#0,d0
		bsr.w		Get2nd
		lea		(0,a2,d0.l),a1		;Pointer to first 2nd level table

	;Check all 16Meg entries in root table
		moveq		#0,d0					;First physical address to start
		move.l	#255,d1				;Loop 256 times (4 gigabytes)

1$		move.l	d0,d2
		or.b		#1,d2					;Set to valid PAGE descriptor
		move.l	d2,(a0)				;Fill in right physical address in root
											;table
		tst.l		d0
		bmi.b		2$						;More than 2 Gigabytes
		bsr.w		CheckHeaderIn16M
		beq.b		2$
	;There is an overlap
		move.l	a1,d2
		or.b		#2,d2					;Set valid 4 BYTE
		move.l	d2,(a0)				;Pointer to 2nd level table
		move.l	d0,(a1)				;Fill in physical address
		lea		(64*4,a1),a1		;Next 2nd level table

2$		add.l		#$01000000,d0		;Next 16 Megabytes
		lea		(4,a0),a0			;Next entry in root table
		dbra		d1,1$
		rts

	;***
	;Init all third level tables for MMU tree
	;All 2nd level tables must be initialized with 'Init2ndLevel'
	;This routine will complete the initialization of the 2nd level
	;tables by filling in the other physical addresses (the first
	;physical address is already provided by 'Init2ndLevel' for each
	;2nd level table)
	;For each third level table only the first physical address
	;is initialized. 'InitPages' will do the rest
	;a2 = pointer to root
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d2 = scratch
	;***
Init3thLevel:
		moveq		#0,d0
		bsr.w		Get3th
		lea		(0,a2,d0.l),a1		;Pointer to first 3th level table

		moveq		#0,d0
		bsr.w		Get2nd
		lea		(0,a2,d0.l),a0		;Pointer to first 2nd level table

	;Loop for each second level table
		move.l	d3,d1
		subq.w	#1,d1

1$		move.l	(a0),d0				;Physical address for this 2nd level table

	;Check all 256Kbyte entries in this 2nd level table
		move.l	d1,-(a7)
		moveq		#63,d1				;Loop 64 times (16 megabytes)

2$		move.l	d0,d2
		or.b		#1,d2					;Set to valid PAGE descriptor
		move.l	d2,(a0)				;Fill in right physical address in 2nd
											;level table
		bsr.w		CheckHeaderIn256K
		beq.b		3$
	;There is an overlap
		move.l	a1,d2
		or.b		#2,d2					;Set valid 4 BYTE
		move.l	d2,(a0)				;Pointer to 3th level table
		move.l	d0,(a1)				;Fill in physical address
		lea		(64*4,a1),a1		;Next 3th level table

3$		add.l		#$00040000,d0		;Next 256 Kbytes
		lea		(4,a0),a0			;Next entry in 2nd level table
		dbra		d1,2$

		move.l	(a7)+,d1
	;a0 already points to the next 2nd level table
		dbra		d1,1$
		rts

	;***
	;Init all pages in the 3th level tables for the MMU tree
	;For each 3th level table the first entry is already initialized
	;We only need to initialized the rest.
	;This routine also checks if the page is for chip ram. In that
	;case the cache should be inhibited (CI flag should be set).
	;Also all special bits (the least significant bit of the 24 bit
	;page address) should be set
	;a2 = pointer to root
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d2 = scratch
	;***
InitPages:
		moveq		#0,d0
		bsr.w		Get3th
		lea		(0,a2,d0.l),a0		;Pointer to first 3th level table

	;Loop for each 3th level table
		move.l	d4,d1
		subq.w	#1,d1

1$		move.l	(a0),d0				;First physical address is already
											;initialized by 'Init3thLevel'
		move.l	d1,-(a7)
		moveq		#63,d1				;Loop 64 times (256 Kbytes)

2$		move.l	d0,d2

		movem.l	d0-d1/a0-a1,-(a7)
		movea.l	d0,a1
		lea		(4090,a1),a1		;To skip the first possible memory header
		CALLEXEC	TypeOfMem
		btst		#MEMB_CHIP,d0
		beq.b		3$
	;Yes, it is chip ram. Set the CI bit
		or.b		#%01000000,d2

3$		movem.l	(a7)+,d0-d1/a0-a1

		or.w		#%100000001,d2		;Set to valid PAGE descriptor and special bit
		move.l	d2,(a0)				;Fill in right physical address in 3th
											;level table
		add.l		#$00001000,d0		;Next 4096 bytes
		lea		(4,a0),a0			;Next entry in 3th level table
		dbra		d1,2$

		move.l	(a7)+,d1
	;a0 already points to the next 3th level table
		dbra		d1,1$
		rts

	;***
	;Make the PowerVisor MMU table
	;	There are three levels in the table
	;	The A level uses 8 bits
	;	The B level uses 6 bits
	;	The C level uses 6 bits
	;	The page size is 12 bits
	;Note that this routine also sets the least significant bit of all
	;24 page addresses of pages belonging to normal memory. These pages
	;can be protected by later operations
	;***
MakeMMUTree:
		movem.l	d2-d4/a2-a3,-(a7)

		bsr.w		FreeMMUTree

		bsr.w		GetMMUTreeSize		;d2 = size, d0 = #2nd level, d1 = #3th level
		lea		(MyMMUTableSize,pc),a0
		move.l	d2,(a0)				;(Over)estimated size
		move.l	d0,d3					;Number of second level tables
		move.l	d1,d4					;Number of third level tables

		move.l	d2,d0
		jsr		(AllocClear)
		ERROReq	NotEnoughMemory
		lea		(MyMMUTable,pc),a0
		move.l	d0,(a0)
		add.l		#1023,d0
		and.l		#-1024,d0
		lea		(MyRoot,pc),a0
		move.l	d0,(a0)
		movea.l	d0,a2					;Pointer to the root

		bsr.w		Init2ndLevel
		bsr.w		Init3thLevel
		bsr.w		InitPages

	;Set all cache inhibit (CI) flags for custom chips (chip ram is already
	;done)
		moveq		#0,d0
		bsr.w		Get2nd
		lea		(0,a2,d0.l),a3		;Pointer to first 2nd level table (chip ram
											;and custom chips)
		moveq		#$00b00000/$00040000,d0
		moveq		#3,d2					;Loop 4 times (1 Megabyte)

2$		bsr.b		1$
		addq.l	#1,d0
		dbra		d2,2$

		moveq		#$00d00000/$00040000,d0
		moveq		#7,d2					;Loop 8 times (2 Megabyte)

3$		bsr.b		1$
		addq.l	#1,d0
		dbra		d2,3$

	;See where the ROM is located and adapt our MMU tree if needed
		bsr.w		ComputeMMU

		movea.l	#$00f00000,a1
		moveq		#$00f00000/$00040000,d2
		bsr.b		5$
		movea.l	#$00f40000,a1
		addq.l	#1,d2
		bsr.b		5$
		movea.l	#$00f80000,a1
		addq.l	#1,d2
		bsr.b		5$
		movea.l	#$00fc0000,a1
		addq.l	#1,d2
		bsr.b		5$

		movem.l	(a7)+,d2-d4/a2-a3
		rts

	;Little subroutine to set CI for a 256K page
	mc68030
1$		move.l	(0,a3,d0.l*4),d1
		or.b		#%01000000,d1		;Set CI
		move.l	d1,(0,a3,d0.l*4)
	mc68000
		rts

	;Little subroutine to check a possible ROM address
	;a1 = ROM address
	;d2 = number of corresponding entry in 2nd level table
5$		move.l	(RegTC,pc),d0
		btst.l	#31,d0				;Check if MMU translation enabled
		beq.b		4$						;No, ROM is real

		movea.l	(MMUState,pc),a0
		jsr		(GetEntryInMMUTree)
		tst.l		d0
		beq.b		4$
		movea.l	d0,a0					;Entry
		move.l	(a0),d1				;Contents of entry
		move.b	d1,d0
		and.b		#3,d0					;Extract dt field
		cmp.b		#1,d0					;Equal to PAGE descriptor?
		bne.b		4$
	;It is a PAGE descriptor, we extract the physical address that we
	;can use in our own table
		move.b	#1,d1					;Clear eight least significant bits (set to PAGE)
6$		or.b		#%00000100,d1		;Set WP
	mc68030
		move.l	d1,(0,a3,d2.l*4)
	mc68000
		rts

	;It is not a PAGE descriptor of the entry is not in the existing
	;MMU tree. Set the page to WP
	mc68030
4$		move.l	(0,a3,d2.l*4),d1
	mc68000
		bra.b		6$

	;***
	;Free the PowerVisor MMU table
	;***
FreeMMUTree:
		move.l	(MyMMUTable,pc),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	(MyMMUTableSize,pc),d0
		jsr		(FreeMem)
		lea		(MyMMUTable,pc),a0
		clr.l		(a0)
1$		rts

	;***
	;Install the PowerVisor MMU tree in the system
	;***
InstallMMUTree:
		move.w	(MyMMUInst,pc),d0
		bne.b		1$
		move.l	a5,-(a7)
		lea		(InstallMMUSuper,pc),a5
		CALLEXEC	Supervisor
		movea.l	(a7)+,a5
		moveq		#1,d0
		lea		(MyMMUInst,pc),a0
		move.w	d0,(a0)
1$		rts

InstallMMUSuper:
	;Remember old
		lea		(OldCRP,pc),a0
		pmove.q	crp,(a0)
		lea		(OldTC,pc),a0
		pmove.l	tc,(a0)

		pea		(0).w

		move.l	(MMUType),d0
		cmp.l		#68851,d0
		beq.b		1$

	;Only for 68030 and 68040
		lea		(OldTT0,pc),a0
	mc68030
		pmove.l	tt0,(a0)
	mc68000
		lea		(OldTT1,pc),a0
	mc68030
		pmove.l	tt1,(a0)
	mc68000

	;First disable translation (and TTx registers)
	mc68030
		pmove.l	(a7),tt0
		pmove.l	(a7),tt1
1$		pmove.l	(a7),tc
	mc68000

	;Install new
		move.l	(MyRoot,pc),(a7)
		pea		($80000002).l
	mc68030
		pmove.q	(a7),crp
	mc68000
		pea		($80c08660).l
	mc68030
		pmove.l	(a7),tc
	mc68000

		lea		(12,a7),a7			;Clean up stack
		rte

	;***
	;Restore the original MMU tree
	;***
RemoveMMUTree:
		move.w	(MyMMUInst,pc),d0
		beq.b		1$
		move.l	a5,-(a7)
		lea		(RemoveMMUSuper,pc),a5
		CALLEXEC	Supervisor
		movea.l	(a7)+,a5
		lea		(MyMMUInst,pc),a0
		clr.w		(a0)
1$		rts

RemoveMMUSuper:
	;Disable translation
		pea		(0).w
	mc68030
		pmove.l	(a7),tc
	mc68000

	;Restore old
		lea		(OldCRP,pc),a0
	mc68030
		pmove.q	(a0),crp
	mc68000
		lea		(OldTC,pc),a0
	mc68030
		pmove.l	(a0),tc
	mc68000

		move.l	(MMUType),d0
		cmp.l		#68851,d0
		beq.b		1$

	;Only for 68030 and 68040
		lea		(OldTT0,pc),a0
	mc68030
		pmove.l	(a0),tt0
	mc68000
		lea		(OldTT1,pc),a0
	mc68030
		pmove.l	(a0),tt1
	mc68000

1$		lea		(4,a7),a7			;Clean up stack
		rte

;---------------------------------------------------------------------------
;General functions
;---------------------------------------------------------------------------

	;***
	;Move the VBR to another place
	;***
MoveVBR:
		move.l	(MyVBR,pc),d0
		bne.b		1$

	;Not yet moved
		bsr.w		GetVBR
		tst.l		d0
		bne.b		1$						;Only move if not already moved

		move.l	#256,d0
		jsr		(AllocClear)
		lea		(MyVBR,pc),a0
		move.l	d0,(a0)
		beq.b		1$

		suba.l	a0,a0					;Source
		movea.l	d0,a1					;Dest
		move.l	#256,d0
		CALLEXEC	CopyMemQuick

		move.l	(MyVBR,pc),d0
		bsr.w		SetVBR

1$		rts

	;***
	;Restore the VBR to the original place
	;***
RestoreVBR:
		move.l	(MyVBR,pc),d0
		beq.b		1$

	;Restore it
		moveq		#0,d0
		bsr.w		SetVBR

		movea.l	(MyVBR,pc),a1
		move.l	#256,d0
		jsr		(FreeMem)
		lea		(MyVBR,pc),a0
		clr.l		(a0)

1$		rts

	;***
	;Remove the reset handler
	;***
RemoveResetHandler:
		move.w	(ResetHInst,pc),d0
		bne.b		2$
		rts

	;It is installed
2$		moveq		#KBD_REMRESETHANDLER,d2
		bsr.w		PerformKeyBoardCmd
		beq.b		1$						;No success

		lea		(ResetHInst,pc),a0
		clr.w		(a0)

1$		rts

	;***
	;Install a reset handler with the keyboard device
	;***
InstallResetHandler:
		move.w	(ResetHInst,pc),d0
		beq.b		2$
		rts

	;Not yet installed
2$		lea		(ResetHandler,pc),a0
		lea		(MyResetHandler,pc),a1
		move.l	a1,(IS_CODE,a0)
		suba.l	a1,a1
		move.l	a1,(IS_DATA,a0)
		move.b	#16,(LN_PRI,a0)

		moveq		#KBD_ADDRESETHANDLER,d2
		bsr.w		PerformKeyBoardCmd
		beq.b		1$						;No success

		lea		(ResetHInst,pc),a0
		moveq		#1,d0
		move.w	d0,(a0)

1$		rts

	;***
	;Perform a command on the keyboard device
	;d2 = command
	;-> d0 = 0 (flags) if no success
	;***
PerformKeyBoardCmd:
		lea		(KeyBoardDevice,pc),a0
		suba.l	a1,a1					;Flags
		moveq		#0,d0					;Unit
		moveq		#IOSTD_SIZE,d1		;Size
		moveq		#0,d3					;No success yet
		jsr		(InstallDevice)
		beq.b		1$
		moveq		#1,d3					;Success

	;Success
		movem.l	d0-d1,-(a7)			;Remember port and IORequest
		lea		(ResetHandler,pc),a0

		movea.l	d0,a1					;IORequest
		move.l	a0,(IO_DATA,a1)
		move.w	d2,(IO_COMMAND,a1)
		CALLEXEC	DoIO

		movem.l	(a7)+,d0-d1

1$		movea.l	d0,a1					;IORequest
		movea.l	d1,a0					;Port
		jsr		(RemoveDevice)
		move.l	d3,d0					;Success?
		rts

	;***
	;Reset handler to clean up MMU tree
	;***
MyResetHandler:
		bsr.w		RemoveTrapBus
		bsr.w		RemoveMMUTree
		moveq		#KBD_RESETHANDLERDONE,d2
		bra.b		PerformKeyBoardCmd

	;***
	;Flush ATC, data and instruction cache
	;***

	IFD D20
FlushCache:
		movem.l	d0-d1/a0-a1/a6,-(a7)
		CALLEXEC	CacheClearU
		movem.l	(a7)+,d0-d1/a0-a1/a6
		rts

FlushCacheSuper:
		movem.l	d0-d1/a0-a1/a6,-(a7)
		CALLEXEC	CacheClearU
		movem.l	(a7)+,d0-d1/a0-a1/a6
		rts
	ENDC

	IFND D20
FlushCache:
		movem.l	d0/a5-a6,-(a7)

		movea.l	(SysBase).w,a6
		move.w	(AttnFlags,a6),d0
		andi.w	#$000e,d0
		beq.b		1$

		lea		(SuperCacheFlush,pc),a5
		CALL		Supervisor

1$		movem.l	(a7)+,d0/a5-a6
		rts

SuperCacheFlush:
		bsr.b		FlushCacheSuper
		rte

FlushCacheSuper:
		movem.l	d0-d1/a0-a1/a6,-(a7)
		CALLEXEC	Disable

		move.w	(AttnFlags,a6),d0
		andi.w	#$000e,d0
		beq.b		1$

	mc68030
		movec		cacr,d0
	mc68000
		bset		#11,d0				;Clear Data Cache
		bset		#3,d0					;Clear Instruction Cache
	mc68030
		movec		d0,cacr
	mc68000
1$		CALL		Enable
		movem.l	(a7)+,d0-d1/a0-a1/a6
		rts
	ENDC

	;***
	;This routine checks CPU flags early in ExecBase for extended
	;CPUs that test as a 68020 under 1.3.  If these flags are set,
	;the actual CPU/MMU type test can be skipped.
	;***
TestFlags:
		moveq		#0,d0
		move.w	(AttnFlags,a6),d1
		btst		#AFB_68040,d1				;Does the OS think an '040 is here?
		beq.b		NoEarly40
		move.l	#68040,d0
		rts
NoEarly40:
		btst		#AFB_68030,d1				;Does the OS think an '030 is here?
		beq.b		NoEarly30
		move.l	#68030,d0					;Sure does...
NoEarly30:
		rts

	;***
	;This function returns 0L if the system contains no MMU, 
	;68851L if the system does contain an 68851, or the CPU number
	;for CPUs with integral CPUs.
	;
	;This routine seems to lock up on at least some CSA 68020 
	;boards, though it runs just fine on those from Ronin and 
	;Commodore, as well as all 68030 boards it's been tested on.
	;
	;(Jorrit)
	;Because of this lockup on some boards we must supply a way for
	;the user to force the MMU without this routine actually being
	;called. This routine therefore also scans the commandline for the
	;processor option
	;***
GetMMUType:
		moveq		#'m',d0
		jsr		(CheckOption)
		beq.b		1$
	;Yes, this commandline option is present, don't execute the test, but
	;force a user-suplied value instead
		jmp		(ParseDec)

1$		movea.l	(4).w,a6						;Get ExecBase
		bsr.w		TestFlags					;Check extended CPU types
		tst.l		d0
		beq.b		MMURealTest
		rts

	;***
	;For any other machine, a real test must be done.  The test will
	;try an MMU instruction.  The instruction will fail unless we're
	;on a "bogus MMU" system, where the FPU responds as an MMU.
	;***
MMURealTest:
		movem.l	a3/a4/a5,-(sp)				;Save this stuff
		suba.l	a1,a1
		CALLEXEC	FindTask						;Call FindTask(0L)
		movea.l	d0,a3

		movea.l	(TC_TRAPCODE,a3),a4		;Change the exception vector
		move.l	#MMUTraps,(TC_TRAPCODE,a3)
	
		moveq		#-1,d0						;Try to detect undecode FPU
		subq.l	#4,sp							;Get a local variable
		pmove.l	tc,(sp)						;Let's try an MMU instruction
		addq.l	#4,sp							;Return that local
		move.l	a4,(TC_TRAPCODE,a3)		;Reset exception stuff
		movem.l	(sp)+,a3/a4/a5				;and return the registers
		rts

	;***
	;This is the exception code.  No matter what machine we're on,
	;we get an exception.  If the MMU's in place, we should get a
	;privilige violation; if not, an F-Line emulation exception.
	;***
MMUTraps:
		move.l	(sp)+,d0						;Get Amiga supplied exception #
		cmpi.w	#11,d0						;Is it an F-Line?
		beq.b		MMUNope						;If so, go to the fail routine
		move.l	#68851,d0					;We have MMU
		addq.l	#4,(2,sp)					;Skip the MMU instruction
		rte
MMUNope:
		moveq.l	#0,d0							;It dinna work,
		addq.l	#4,(2,sp)					;Skip the MMU instruction
		rte

	;***
	;Change some set of attributes in the MMU table
	;(this routine will not exit if there is an error)
	;Only PAGE entries are changed
	;d0 = bits to change (ci, m, u, wp, dt)
	;d1 = mask
	;d2 = if true (1) only special entries (with the least significant bit
	;		of the 24 bit page address set) are changed (these can be
	;		PAGE or INVALID entries)
	;		otherwise, all PAGE entries are changed
	;***
SetAttrInMMUTree:
		and.l		d1,d0
		not.l		d1
		movem.l	d0-d2,-(a7)
		bsr		UpdateMMU
		movea.l	a7,a1					;UserData
		lea		(SetAttrMMUTree,pc),a2
		jsr		(ScanMMUTree)
		bsr.w		FlushCache
		movem.l	(a7)+,d0-d2
		rts

	;***
	;Routine called for each entry in the MMU tree (called by ScanMMUTree)
	;a0 = Private MMU state
	;a1 = UserData
	;***
SetAttrMMUTree:
		jsr		(GetTreeType)
		move.b	d0,d3					;Remember type
		cmp.b		#1,d0
		bgt.b		1$

	;Page or invalid
		jsr		(GetTreeDescriptor)
		movea.l	d0,a2					;a2 = pointer to descriptor
		tst.l		d0
		beq.b		1$
		move.l	(a2),d2
		movem.l	(a1),d0-d1/d4		;d0 = bits to change, d1 = mask, d2 = special entries
		tst.b		d3
		bne.b		2$

	;Invalid
		tst.b		d4
		beq.b		1$						;Do nothing if only PAGE entries should be set
		btst.l	#8,d2
		beq.b		1$						;Not a special entry
	;It is a special entry
3$		and.l		d1,d2
		or.l		d0,d2
		lea		(SuperPoke,pc),a5
		CALLEXEC	Supervisor
		bra.b		1$

	;Page
2$		tst.b		d4
		beq.b		3$
		btst.l	#8,d2
		bne.b		3$						;Not a special entry

1$		rts

		movem.l	(a7)+,d2-d7/a2-a5
		rts

	;***
	;Little subroutine to print a register
	;a2 = pointer in table to 'MsgXXX' and 'RegXXX'
	;-> a2 = pointer to next entry in table
	;***
PReg:
		movea.l	(a2)+,a0
		PRINT
		movea.l	(a2)+,a0
		move.l	(a0),d0
		jmp		(PrintRealHex)

	;***
	;Function: return the address of the entry in the MMU table for a
	;given logical address
	;-> d0 = pointer to entry or 0 if no entry for this address
	;***
FuncGetMMUEntry:
		EVALE
		move.l	d0,-(a7)
		bsr		UpdateMMU
		movea.l	(a7)+,a1
		jmp		(GetEntryInMMUTree)

	;***
	;Get CRP and TC registers (only useful from within supervisor)
	;This routine only works for the 68020 and 68030
	;***
GetCRPandTCsuper:
		movem.l	d0/a0,-(a7)
		lea		(RegCRP,pc),a0
		pmove.q	crp,(a0)
		lea		(RegTC,pc),a0
		pmove.l	tc,(a0)
		bsr		ComputeMMUint
		movem.l	(a7)+,d0/a0
		rts

	;***
	;Print a register (8 byte register)
	;a0 = pointer to string
	;a2 = pointer to rp
	;***
PrintRP:
		PRINT
		move.l	(a2),d0
		jsr		(PrintRealHexNL)
		moveq		#1,d0
		bsr.w		Print3Spaces
		move.l	(4,a2),d0
		jmp		(PrintRealHex)

	;***
	;Print a register (4 byte register)
	;a0 = pointer to string
	;a2 = pointer to reg
	;***
PrintReg:
		PRINT
		move.l	(a2),d0
		jmp		(PrintRealHex)

	;***
	;Get all the available MMU registers
	;This routine works for the 68020, 68030 and 68040
	;This function also initializes the 'ExistsTable' table
	;***
GetMMURegisters:
		movem.l	a2-a5,-(a7)
		moveq		#-1,d0
		lea		(ExistsTable,pc),a2
		move.l	d0,(a2)
		move.l	d0,(4,a2)
		move.l	d0,(8,a2)
		move.l	d0,(12,a2)

		CALLEXEC	Disable

		bsr.w		GetVBR
		movea.l	d0,a3
		move.l	($2c,a3),-(a7)				;Install Line-F trap handler
		move.l	($10,a3),-(a7)				;Install Illegal trap handler
		move.l	#MMUIllegal,($10,a3)
		move.l	#MMUIllegal,($2c,a3)

		lea		(SuperMREG,pc),a5
		CALLEXEC	Supervisor

		move.l	(a7)+,($10,a3)
		move.l	(a7)+,($2c,a3)
		CALL		Enable

		movem.l	(a7)+,a2-a5
		rts

	;***
	;Exception handler for line-F instruction
	;***
MMUIllegal:
		clr.b		(a2)							;Register does not exist
		addq.l	#4,(2,sp)					;Skip the MMU instruction
		rte

SuperMREG:
		lea		(RegDRP,pc),a0
		pmove.q	drp,(a0)						;Warning! don't change size of this instr!
		lea		(1,a2),a2

		lea		(RegCRP,pc),a0
		pmove.q	crp,(a0)						;Warning! don't change size of this instr!
		lea		(1,a2),a2

		lea		(RegSRP,pc),a0
		pmove.q	srp,(a0)						;Warning! don't change size of this instr!
		lea		(1,a2),a2

		lea		(RegTC,pc),a0
		pmove.l	tc,(a0)						;Warning! don't change size of this instr!
		lea		(1,a2),a2

		lea		(RegTT0,pc),a0
	mc68030
		pmove.l	tt0,(a0)						;Warning! don't change size of this instr!
	mc68000
		lea		(1,a2),a2

		lea		(RegTT1,pc),a0
	mc68030
		pmove.l	tt1,(a0)						;Warning! don't change size of this instr!
	mc68000
		lea		(1,a2),a2

	;68040 specific code
		lea		(RegURP40,pc),a0
	mc68040
		movec		urp,d0						;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

	mc68040
		movec		srp,d0						;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

	mc68040
		movec		tc,d0							;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

	mc68040
		movec		dtt0,d0						;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

	mc68040
		movec		dtt1,d0						;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

	mc68040
		movec		itt0,d0						;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

	mc68040
		movec		itt1,d0						;Warning! don't change size of this instr!
	mc68000
		move.l	d0,(a0)+
		lea		(1,a2),a2

		rte

	;***
	;Get the VBR
	;-> d0 = VBR
	;***
GetVBR:
		movea.l	(SysBase).w,a6
		moveq		#0,d0
		move.w	(AttnFlags,a6),d1
		btst		#AFB_68010,d1				;Does the OS think an '010 is here?
		beq.b		1$
		lea		(SuperGetVBR,pc),a5
		CALL		Supervisor
1$		rts

SuperGetVBR:
	mc68030
		movec		vbr,d0
	mc68000
		rte

	;***
	;Set the VBR
	;d0 = VBR
	;***
SetVBR:
		movea.l	(SysBase).w,a6
		move.w	(AttnFlags,a6),d1
		btst		#AFB_68010,d1				;Does the OS think an '010 is here?
		beq.b		1$
		lea		(SuperSetVBR,pc),a5
		CALL		Supervisor
1$		rts

SuperSetVBR:
	mc68030
		movec		d0,vbr
	mc68000
		rte

	;***
	;Subroutine to test a bit and print information
	;a2 = pointer in table to 'Bit'.w, 'MsgInfo' and 'MsgNo'
	;-> a2 = pointer to next entry in table
	;***
TestBit:
		bsr.w		Print3S
		movea.l	(2,a2),a0
		PRINT

	;Get 'no' response
		lea		(YesNoMessages,pc),a0
		moveq		#0,d0
		move.b	(a2),d0
		lsl.w		#2,d0
		adda.l	d0,a0

		move.b	(1,a2),d0			;Bit number
		btst.l	d0,d2
		beq.s		1$

	;It is 'yes'
		lea		(4,a0),a0			;Go to yes response

1$		movea.l	(a0),a0				;Get pointer to yes or no message
		PRINT
		lea		(6,a2),a2
		rts

	;***
	;Print three spaces
	;***
Print3S:
		moveq		#1,d0
	;Fall through

	;***
	;Print three spaces
	;d0 = number of times to print 3 spaces
	;***
Print3Spaces:
		movem.l	d0/a0,-(a7)
		lea		(Spaces,pc),a0
		bra.b		2$
1$		PRINT
2$		dbra		d0,1$
		movem.l	(a7)+,d0/a0
		rts

;-----------------------------------------------------------------------
;All 68020, 68030 and 68040 routines are here
;-----------------------------------------------------------------------

	;Table for CACR register
TestBitTableCACR:
		TESTBIT	13,WA,NotSet
		TESTBIT	12,DBE,Disabled
		TESTBIT	11,CD,NotSet
		TESTBIT	10,CED,NotSet
		TESTBIT	9,FD,NotSet
		TESTBIT	8,ED,Disabled
		TESTBIT	4,IBE,Disabled
		TESTBIT	3,CIC,NotSet
		TESTBIT	2,CEI,NotSet
		TESTBIT	1,FI,NotSet
		TESTBIT	0,EI,Disabled

	;Table for CACR register for the 68040
TestBitTableCACR40:
		TESTBIT	31,DE,Disabled
		TESTBIT	15,IE,Disabled

	;***
	;Subroutine: describe a CACR register
	;This routines works for the 68020, 68030 and 68040
	;a2 = ptr to CACR
	;***
DescribeCACR:
		move.l	(MMUType),d0
		cmp.l		#68040,d0
		bne.b		2$

	;Describe the CACR for the 68040
		move.l	(a2)+,d2
		lea		(TestBitTableCACR40,pc),a2
		moveq		#1,d3					;Loop 2 times
		bra.b		1$

2$		move.w	(a2)+,d2
		move.w	(a2)+,d2

		lea		(TestBitTableCACR,pc),a2
		moveq		#10,d3				;Loop 11 times
1$		bsr		TestBit
		dbra		d3,1$

		rts

	;***
	;Subroutine: compute all relevant MMU values for scan in table
	;This routine works for the 68020, 68030 and 68040
	;***
ComputeMMU:
		move.l	(MMUType),d0
		ERROReq	YouNeedMMU

		bsr.w		GetMMURegisters

		move.l	(MMUType),d0
		cmp.l		#68040,d0
		bne.b		ComputeMMUint

	;We are on an 68040, fill the RegTC and RegCRP as if there was a 68020/68030 in the system
		lea		(RegCRP,pc),a0
		move.l	#$80000002,(a0)+	;Lower Limit, DT = 4 BYTE DESCRIPTORS
		move.l	(RegURP40,pc),(a0)

		lea		(RegTC,pc),a0
		move.l	#$00c07760,(a0)	;4K pages, ISS = 0, TIA = 7, TIB = 7, TIC = 6, TID = 0

		move.w	(RegTC40+2,pc),d0
	mc68030
		bfextu	d0{16:1},d1			;Extract E bit (enable translation)
		bfins		d1,(a0){0:1}		;Put in RegTC
	mc68000

		btst.l	#14,d0				;Page size
		beq.b		1$
	mc68030
		bfset		(a0){11:1}			;8K pages
		moveq		#5,d0					;TIC = 5
		bfins		d0,(a0){24:4}
	mc68000
	;Fall through
1$

	;Subroutine to compute ISS, TIA, TIB, TIC, TID and the table
	;size from the TC register
	;Only for 68020 or 68030
ComputeMMUint:
	;Compute ISS, TIA, TIB, TIC, TID and Table Size
		move.w	(RegTC,pc),d0
		andi.w	#$0070,d0
		lsr.w		#3,d0
		lea		(SizeTable,pc),a0
		move.w	(0,a0,d0.w),(TSize)
	;Initial shift
		move.w	(RegTC,pc),d0
		andi.w	#$000f,d0
		lea		(ISS,pc),a0
		move.w	d0,(a0)+
	;TIA,TIB,TIC,TID
		move.w	(RegTC+2,pc),d0
		andi.w	#$f000,d0
		lsr.w		#8,d0
		lsr.w		#4,d0
		move.w	d0,(a0)+

		move.w	(RegTC+2,pc),d0
		andi.w	#$0f00,d0
		lsr.w		#8,d0
		move.w	d0,(a0)+

		move.w	(RegTC+2,pc),d0
		andi.w	#$00f0,d0
		lsr.w		#4,d0
		move.w	d0,(a0)+

		move.w	(RegTC+2,pc),d0
		andi.w	#$000f,d0
		move.w	d0,(a0)
		rts

;-----------------------------------------------------------------------
;All 68020 / 68030 routines are here
;-----------------------------------------------------------------------

	;Table for TTx registers
TestBitTableTTx:
		TESTBIT	15,TTx,Disabled
		TESTBIT	10,CI,No
		TESTBIT	9,RW,NotSet
		TESTBIT	8,RWM,NotSet

	;Table for TC register
TestBitTableTC:
		TESTBIT	15,E,Disabled
		TESTBIT	9,SRE,Disabled
		TESTBIT	8,FCL,Disabled

TestBitTableRP:
		TESTBIT	15,LU,NotSet

	;***
	;Subroutine: describe a root pointer
	;This routine is only for the 68020 or 68030
	;a2 = ptr to crp, srp or drp (for 68020)
	;***
DescribeRP:
		move.w	(a2)+,d2
	;L/U bit
		move.l	a2,-(a7)
		lea		(TestBitTableRP,pc),a2
		bsr.w		TestBit
		movea.l	(a7)+,a2
	;LIMIT
		andi.w	#$7fff,d2
		lea		(MsgLIMITis,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		jsr		(PrintRealHex)
	;DT
		move.w	(a2)+,d2
		andi.w	#3,d2
		lea		(MsgDT,pc),a0
		PRINT
		tst.w		d2
		beq.b		2$
		cmpi.w	#1,d2
		beq.b		3$
		cmpi.w	#2,d2
		beq.b		4$
		lea		(MsgValid8,pc),a0
		bra.b		5$
4$		lea		(MsgValid4,pc),a0
		bra.b		5$
3$		lea		(MsgPageDesc,pc),a0
		bra.b		5$
2$		lea		(MsgInvalid,pc),a0
5$		PRINT
	;Table address
		move.l	(a2)+,d2
		andi.l	#~15,d2
		lea		(MsgTableA,pc),a0
		PRINT
		move.l	d2,d0
		jmp		(PrintRealHex)

	;***
	;Subroutine: describe a translation control register
	;This routine is only for the 68020 or 68030
	;a2 = ptr to tc
	;***
DescribeTC:
		move.w	(a2)+,d2

		move.l	a2,-(a7)
		lea		(TestBitTableTC,pc),a2
		moveq		#2,d3					;Loop 3 times
1$		bsr.w		TestBit
		dbra		d3,1$
		movea.l	(a7)+,a2

	;System page size
		lea		(MsgSystemPage,pc),a0
		PRINT
		moveq		#0,d0					;Clear for later
		move.w	d2,d0
		andi.w	#$0070,d0
		lsr.w		#3,d0
		lea		(SizeTable,pc),a0
		move.w	(0,a0,d0.w),d0
		jsr		(PrintRealHex)
	;Initial shift
		lea		(MsgInitShift,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$000f,d0
		jsr		(PrintRealHex)
	;TIA,TIB,TIC,TID
		move.w	(a2)+,d2
		lea		(MsgTIA,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$f000,d0
		lsr.w		#8,d0
		lsr.w		#4,d0
		jsr		(PrintRealHex)

		lea		(MsgTIB,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$0f00,d0
		lsr.w		#8,d0
		jsr		(PrintRealHex)

		lea		(MsgTIC,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$00f0,d0
		lsr.w		#4,d0
		jsr		(PrintRealHex)

		lea		(MsgTID,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$000f,d0
		jmp		(PrintRealHex)

	;***
	;Subroutine: describe a TTx register
	;This routine is only for the 68020 or 68030
	;a2 = ptr to TTx
	;***
DescribeTT:
		move.w	(a2)+,d2
		lea		(MsgLogABase,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		lsr.w		#8,d0
		jsr		(PrintRealHex)
		lea		(MsgLogAMask,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#255,d0
		jsr		(PrintRealHex)

		move.w	(a2)+,d2
		lea		(TestBitTableTTx,pc),a2
		moveq		#3,d3					;Loop 4 times
1$		bsr.w		TestBit
		dbra		d3,1$

		lea		(MsgFCBase,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$0070,d0
		lsr.w		#4,d0
		jsr		(PrintRealHex)
		lea		(MsgFCMask,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$0007,d0
		jmp		(PrintRealHex)

;-----------------------------------------------------------------------
;All 68040 routines are here
;-----------------------------------------------------------------------

	;Table for xTTx registers for 68040
TestBitTableTTx40:
		TESTBIT	15,TTx,Disabled
		TESTBIT	14,SField1,No
		TESTBIT	13,SField2,UserMode
		TESTBIT	9,User1,NotSet
		TESTBIT	8,User0,NotSet
		TESTBIT	6,Cache1,No
		TESTBIT	5,Cache0,No
		TESTBIT	2,WriteProt,No

	;Table for TC register for 68040
TestBitTableTC40:
		TESTBIT	15,E,Disabled
		TESTBIT	14,P,Size68040

	;***
	;Subroutine: describe a xTTx register for the 68040 processor
	;This routine is only for the 68040
	;a2 = ptr to xTTx
	;***
DescribeTT40:
		move.w	(a2)+,d2
		lea		(MsgLogABase,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		lsr.w		#8,d0
		and.b		#$7e,d0
		jsr		(PrintRealHex)
		lea		(MsgLogAMask,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$7e,d0
		jsr		(PrintRealHex)

		move.w	(a2)+,d2
		lea		(TestBitTableTTx40,pc),a2
		moveq		#7,d3					;Loop 8 times
1$		bsr.w		TestBit
		dbra		d3,1$

		rts

	;***
	;Subroutine: describe a translation control register for the 68040
	;This routine is only for the 68040
	;a2 = ptr to tc
	;***
DescribeTC40:
		move.w	(a2)+,d2
		lea		(TestBitTableTC40,pc),a2
		moveq		#1,d3					;Loop 2 times
1$		bsr.w		TestBit
		dbra		d3,1$
		rts

;-----------------------------------------------------------------------
; Floating point conversion routines
; (Author of all floatingpoint routines below: Adriaan vd Brand)
;-----------------------------------------------------------------------

;B_LZEROSKIP		EQU 2
B_SPACESKIP		EQU 1
B_LONIBBLE		EQU 0
MAXFPLEN			EQU 17
;F_SPACESKIP		EQU 2
F_LONIBBLE		EQU 1

	;***
	;Convert an ascii string to extended precision floating point number
	;by using the fpu 
	;range: +/- 1.681E-4932 .. 1.1897E+4932
	;       larger pos. or neg. numbers will be converted to + or - infinity
	;       exponents >10000 or less than -10000 will give unpredictable results!
	;(Author: Adriaan)
	;a0 = pointer to string
	;a1 = pointer to extended floating point number
	;
	;A4-usage:
	;  -12..-1 : packed real
	;  -24..-13: temp. bcd storage for exponent
	;***
FAsc2Ext:
		link.w	a4,#-24				; allocate space for local storage
		movem.l	d2-d4/a1,-(sp)
		fmove.b	#1,fp1
		fmove.b	#1,fp2				; (Jorrit) For positive numbers
		clr.l		(-24,a4)				; clear the number
		clr.l		(-12,a4)
		clr.l		(-8,a4)
		clr.l		(-4,a4)
		moveq		#7,d4
		move.w	#$fff,d3

		lea		(-8,a4),a1
		jsr		(SkipSpace)			; (Jorrit)
		cmpi.b	#'-',(a0)
		bne.b		1$

	; Negative
		fmove.b	#-1,fp2				; (Jorrit) For negative numbers
		bra.b		3$

1$		cmpi.b	#'+',(a0)
		bne.b		2$
3$		lea		(1,a0),a0			; Skip - or +

2$		moveq		#F_LONIBBLE,d0
		bsr.w		ScanF					; d0:=nr. of processed digits excl. leading zeros

		move.w	d0,d2					; exponent calculation
		not.w		d0						; new F_LONIBBLE:=1-(proc.dig's mod 1)
		and.w		#1,d0
		cmpi.b	#'.',(a0)
		bne.b		.nodot
		addq.l	#1,a0
	; first non-digit is a dot ('.')
		bsr.w		ScanF
		tst.w		d2						; were there ANY non-0's before the dot?
		bne.b		.large
	; number is a fraction (like 0.000000000123)
	; so recalc exponent
		moveq		#0,d0
		sub.w		d1,d2					; d2:=-nr. of skipped 0's
.large
.nodot
		cmpi.b	#'e',(a0)			; E or e: treat next as exponent
		beq.b		.exp
		cmpi.b	#'E',(a0)
		beq.b		.exp
.NoExp
		moveq		#0,d0
		bra.b		.ExpWasPos	
.exp
		addq.l	#1,a0					; skip e/E character
		cmpi.b	#'-',(a0)			; check for '+' and '-'
		bne.b		.nonegexp
		bset		#16,d3				; negate exponent (flag bit)
		addq.l	#1,a0
.nonegexp
		cmpi.b	#'+',(a0)
		bne.b		.no_plus_e
		addq.l	#1,a0					; just ignore '+'
.no_plus_e
		lea		(-24,a4),a1			; dest. 
		moveq		#0,d0					; clear flags
		bsr.w		ScanF
	; rotate result e.g. 1 -> 0001, 15-> 0015, 1234 -> 1234
		moveq		#4,d1
		sub.w		d0,d1
		asl.w		#2,d1

		move.w	(-24,a4),d0			; result (exponent, 0..4 digits if legal, 0='E0'=nop)
		ror.w		d1,d0
	; convert BCD to integer since it's far too complicated
	; to use BCD arithmetic
		movem.l	d2-d3,-(sp)	
		moveq		#3,d3
		moveq		#0,d2
		move.l	#$1000,d1
.lp
		ext.l		d0
		divu.w	d1,d0
		mulu.w	#10,d2
		add.w		d0,d2
		lsr.w		#4,d1
		swap		d0
		dbra		d3,.lp
		move.w	d2,d0
		movem.l	(sp)+,d2-d3
		btst		#16,d3				; Do we have to negate the exponent ?
		beq.b		.ExpWasPos
		neg.w		d0						; Yep. Let's do that

.ExpWasPos
		subq.w	#1,d2					; correct correction exponent by 1
		add.w		d2,d0
		fmovecr.x #$3d,fp0			; 1E+1024
.lplarge
		cmp.w		#1000,d0
		blt.b		.less1000
		sub.w		#1024,d0
		fmul.x	fp0,fp1
		bra.b		.lplarge
.less1000
		cmp.w		#-1000,d0
		bgt.b		.expok
		add.w		#1024,d0
		fdiv.x	fp0,fp1
		bra.b		.less1000
.expok
		tst.w		d0
		bpl.b		.ExpIsPos
;		addq.w	#1,d0 (***Jorrit***)
		bset		#14,d3				; exponent is negative
		neg.w		d0						; but as plain bcd it'll have to be positive 
.ExpIsPos
	; and now convert it BACK to BCD
		movem.l	d2-d3,-(sp)
		moveq		#3,d3
		moveq		#0,d2
		moveq		#0,d1
		lea		(divtab,pc),a1
.lp2
		ext.l		d0
		move.w	(a1)+,d1
		divu.w	d1,d0
		lsl.w		#4,d2
		add.w		d0,d2
		swap		d0
		dbra		d3,.lp2
		move.w	d2,d0
		movem.l	(sp)+,d2-d3
.spag1
		and.w		#$f000,d3
		move.w	d3,(-12,a4)			; set the sign bits in the right state
		move.w	d0,d3
		and.w		#$0fff,d3
		or.w		d3,(-12,a4)			; Uurgh, how dirty. Let's put it on a odd address
	; (no pre-020 would have made it upto here anyway)
		moveq		#0,d0					; We've made it! rc=ok=0
.exit
		movem.l	(sp)+,d2-d4/a1
		fmove.p	(-12,a4),fp0
		fmul.x	fp1,fp0
		fmul.x	fp2,fp0				; For sign (Jorrit)
		fmove.x	fp0,(a1)
		unlk		a4
		rts	

.error
		moveq		#-1,d0
		bra.b		.exit
.done
		moveq		#0,d0
		bra.b		.spag1				; spagetti code...:-) Finish the number nicely
	
divtab
		dc.w		1000,100,10,1		; almost the same table as with ieee conversions
											; except for the missing 10000 (!)
	
	;---
	;a0 = buffer1
	;a1 = buffer2
	;d0 = flags
	;-> d0 = positions
	;-> d1 = skippedzeros
	;-> a0 = first non-digit (after skipping ' ' if necessary)
	;---
ScanF:
		move.w	d2,-(sp)
		move.w	d3,-(sp)
		moveq		#0,d1
		moveq		#0,d2					; d2=position . (exponent offset+1)
	
.skip
		move.b	(a0)+,d3				; skip {leading spaces} <leading zeros>
		cmp.b		#'0',d3
		bne.b		.notzero
		addq.w	#1,d1
		bra.b		.skip

.lp
		move.b	(a0)+,d3
.notzero
		sub.b		#'0',d3
		bmi.b		.eon
		cmp.b		#9,d3
		bgt.b		.eon
		cmp.w		#MAXFPLEN,d2
		bge.b		.lp
		bchg		#B_LONIBBLE,d0
		bne.b		.lo_nib
.hi_nib
		asl.b		#4,d3
		or.b		d3,(a1)+
		bra.b		.l1
.lo_nib
		or.b		d3,(-1,a1)
.l1
		cmp.w		#MAXFPLEN,d2
		bge.b		.lp
		addq.w	#1,d2					; Yeah, another number!
		bra.b		.lp
	
.eon
		lea		(-1,a0),a0			; a0=&illegal char (or \0)
		move.w	d2,d0					; number of digit-positions (after stripping)

		move.w	(sp)+,d3
		move.w	(sp)+,d2	
		rts

	;***
	;Convert an extended precision floating point number to an ascii string
	;by using the fpu 
	;(Author: Adriaan)
	;a0 = pointer to extended floating point number
	;a1 = pointer to string
	;d0.w = significant digits
	;***
FExt2Asc:
		link.w	a4,#-12
		move.w	d3,-(sp)
		move.w	d2,-(sp)
		move.w	d0,d2
		ble.w		.errorinpara		; error if d0<=0
		fmove.x	(a0),fp0
;		fmove.p	fp0,(-12,a4){d0}
		dc.w		$f22c					; mode = (d16,a4)
		dc.w		$7c00					; dest fmt = .p{d0}, src reg = fp0
		dc.w		-12					; offset

		move.w	(-12,a4),d1
		move.b	#' ',d0
		btst		#15,d1				; sign bit of mantissa
		beq.b		.mpos
		move.b	#'-',d0
.mpos
		move.b	d0,(a1)+
		and.w		#$7fff,d1			; check for infinity or nan
		cmp.w		#$7fff,d1
		bne.b		.notinf
		lea		(txt_inf,pc),a0	; a0 = &'infinity'
		tst.l		(-8,a4)				; check if nan (mantissa=0)
		beq.b		.inf
		tst.l		(-4,a4)
		beq.b		.inf
		lea		(txt_nan,pc),a0	; not infinity but NAN
		subq.l	#1,a1					; delete ' ' or '-' since sign doesn't care	
.inf
		bra.b		.strcpye				; with respect of precision
.strcpy
		move.b	(a0)+,(a1)+
.strcpye
		dbra		d2,.strcpy
		bra.b		.exit	

.notinf
		moveq		#7,d3		
		move.w	d3,d0
		add.w		d3,d2
		bsr.w		GetAscNum			; get digit nr. {d0}, put it in (a1)+

		move.b	#'.',(a1)+
.lp
		addq.w	#1,d3
		cmp.w		d2,d3					; end of number (precision)
		beq.b		.end
		move.w	d3,d0
		bsr.w		GetAscNum
		bra.b		.lp
.end
		move.b	#'E',(a1)+
		move.b	#'+',d0
		btst		#6,(-12,a4)
		beq.b		.epos
		move.b	#'-',d0
.epos
		move.b	d0,(a1)+
		moveq		#4,d0					; get most significant digit of exp.
		bsr.w		GetAscNum
		moveq		#1,d0
		bsr.w		GetAscNum
		moveq		#2,d0
		bsr.w		GetAscNum
		moveq		#3,d0					;     least significant
		bsr.w		GetAscNum

.exit
		clr.b		(a1)+					; add \0 to string
		move.w	(sp)+,d2				; restore registers
		move.w	(sp)+,d3
		unlk		a4
		rts	
.errorinpara:							; wrong d0 parameter, (this is better than a crash!)
		moveq		#-1,d0
		bra.b		.exit

	;---
	; get digit {d0} from packed bcd real at -12(a4) where digit0=bit95..92 and digit23=bit3..bit0
	;    convert that digit to ascii and put it at (a1)+
	;---
GetAscNum:
		move.w	d0,d1
		lsr.w		#1,d0
		move.b	(-12,a4,d0.w),d0
		btst		#0,d1
		bne.b		.noshift
		lsr.w		#4,d0
.noshift
		and.b		#$f,d0
		or.b		#$30,d0
		move.b	d0,(a1)+
		rts 

txt_inf
		dc.b		'infinity',0		; text to be printed if infinity
txt_nan
		dc.b		'nan',0				; not a number
		even


;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------


	;NOTE!!!! ALL THESE SHOULD BE ALLOCATED ON THE STACK FOR EFFICIENCY!!!

MMUState:			dc.l	0			;Private pointer to processor specific data

RegMSP:				dc.l	0
RegISP:				dc.l	0
RegUSP:				dc.l	0
RegSFC:				dc.l	0
RegDFC:				dc.l	0
RegVBR:				dc.l	0
RegCACR:				dc.l	0
RegCAAR:				dc.l	0

RegDRP:				dc.l	0
						dc.l	0
RegCRP:				dc.l	0
						dc.l	0
RegSRP:				dc.l	0
						dc.l	0
RegMMUS:				dc.l	0
RegTC:				dc.l	0
RegTT0:				dc.l	0
RegTT1:				dc.l	0

;68040 specific variables
RegURP40:			dc.l	0
RegSRP40:			dc.l	0
RegTC40:				dc.l	0
RegDTT040:			dc.l	0
RegDTT140:			dc.l	0
RegITT040:			dc.l	0
RegITT140:			dc.l	0

PBusT:				dc.l	0
MissedBusError:	dc.w	0			;If true we missed a bus error
BusErrTable:		dc.l	0			;Table containing the most recent bus errors
BusErrNum:			dc.l	0			;(only if our memory protection system is on)

	;This table contains all descriptors for all tag lists and what each
	;tag list is used for in the memory protection system
TldTable:
						dc.l	0,0		;Global entry (can't be changed)
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0
						dc.l	~0,0

ISS:					dc.w	0			;\
TIA:					dc.w	0			;| 
TIB:					dc.w	0			;--> order is important
TIC:					dc.w	0			;| 
TID:					dc.w	0			;/
TSize:				dc.w	0

MyMMUTableSize:	dc.l	0
MyMMUTable:			dc.l	0
MyRoot:				dc.l	0

	;Original CRP, TC, TT0 and TT1 registers (before the PowerVisor
	;protection system was enabled)
OldCRP:				dc.l	0
						dc.l	0
OldTC:				dc.l	0
OldTT0:				dc.l	0
OldTT1:				dc.l	0

MyVBR:				dc.l	0			;Pointer to PowerVisor VBR table

MyMMUInst:			dc.w	0			;True if my MMU tree is installed
ResetHInst:			dc.w	0			;True if reset handler is installed

SizeTable:			dc.w	256,512,1024,2048,4096,8192,16384,32768

ResetHandler:		ds.b	IS_SIZE
KeyBoardDevice:	dc.b	"keyboard.device",0

ExistsTable:		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;MsgNotAvailable:	dc.b	"(na)",10,0

MsgMSP:				dc.b	"MSP  : ",0
MsgISP:				dc.b	"ISP  : ",0
MsgUSP:				dc.b	"USP  : ",0
MsgSFC:				dc.b	"SFC  : ",0
MsgDFC:				dc.b	"DFC  : ",0
MsgVBR:				dc.b	"VBR  : ",0
MsgCACR:				dc.b	"CACR : ",0
MsgCAAR:				dc.b	"CAAR : ",0

MsgDRP:				dc.b	"DRP  : ",0
MsgCRP:				dc.b	"CRP  : ",0
MsgSRP:				dc.b	"SRP  : ",0
MsgMMUS:				dc.b	"MMUSR: ",0
MsgTC:				dc.b	"TC   : ",0
MsgTT0:				dc.b	"TT0  : ",0
MsgTT1:				dc.b	"TT1  : ",0
;Extensions for the 68040
MsgURP40:			dc.b	"URP  : ",0
MsgSRP40				equ	MsgSRP
MsgTC40				equ	MsgTC
MsgDTT040:			dc.b	"DTT0 : ",0
MsgDTT140:			dc.b	"DTT1 : ",0
MsgITT040:			dc.b	"ITT0 : ",0
MsgITT140:			dc.b	"ITT1 : ",0

MsgLIMITis:			dc.b	"   LIMIT = ",0
MsgDT:				dc.b	"   DT    = ",0
MsgValid8:			dc.b	"Valid 8 byte",10,0
MsgValid4:			dc.b	"Valid 4 byte",10,0
MsgInvalid:			dc.b	"Invalid",10,0
MsgPageDesc:		dc.b	"Page descriptor",10,0
MsgTableA:			dc.b	"   Table address = ",0
	;RP bit messages
MsgLU:				dc.b	"L/U bit",0

MsgSystemPage:		dc.b	"   System page size    = ",0
MsgInitShift:		dc.b	"   Initial shift       = ",0
MsgTIA:				dc.b	"   Table Index A (TIA) = ",0
MsgTIB:				dc.b	"   Table Index B (TIB) = ",0
MsgTIC:				dc.b	"   Table Index C (TIC) = ",0
MsgTID:				dc.b	"   Table Index D (TID) = ",0
	;TC bit messages
MsgE:					dc.b	"Address translation",0
MsgSRE:				dc.b	"Supervisor Root Pointer (SRP)",0
MsgFCL:				dc.b	"Function Code Lookup (FCL)",0
	;TC bit messages for 68040
MsgP:					dc.b	"Page size",0

;MsgLevNum:			dc.b	"   Number of levels = ",0
;	;MMUSR bit messages
;MsgBUS:				dc.b	"Bus error",0
;MsgLIMIT:			dc.b	"Limit violation",0
;MsgSUPER:			dc.b	"Supervisor only",0
;MsgWRITE:			dc.b	"Write protection",0
;MsgINV:				dc.b	"Invalid",0
;MsgMOD:				dc.b	"Modified",0
;MsgTRANS:			dc.b	"Transparent access",0

MsgLogABase:		dc.b	"   Log Address Base = ",0
MsgLogAMask:		dc.b	"   Log Address Mask = ",0
MsgFCBase:			dc.b	"   FC value for TT block = ",0
MsgFCMask:			dc.b	"   FC bits to be ignored = ",0
	;TTx bit messages
MsgTTx:				dc.b	"TT register",0
MsgCI:				dc.b	"Cache Inhibit",0
MsgRW:				dc.b	"R/W",0
MsgRWM:				dc.b	"RWM",0
	;xTTx bit messages for 68040
MsgSField1:			dc.b	"Ignore FC2",0
MsgSField2:			dc.b	"Match if FC2",0
MsgUser1:			dc.b	"U1",0
MsgUser0:			dc.b	"U0",0
MsgWriteProt:		dc.b	"Write protect",0
MsgCache1:			dc.b	"Cachable",0
MsgCache0:			dc.b	"CopyBack or Not Serialized",0

MsgPhysicalTree:	dc.b	"  -> ",0
MsgBytesTree:		dc.b	" # ",0
MsgLog:				dc.b	"Log: ",0
PrintSpace:			dc.b	"        ",0
	EVEN

YesNoMessages:
		dc.l			MsgNotSet,MsgSet
		dc.l			MsgDisabled,MsgEnabled
		dc.l			MsgNo,MsgYes
		dc.l			MsgUser,MsgSuper
		dc.l			MsgPage4,MsgPage8

MsgNotSet:			dc.b	" : not set",10,0
MsgSet:				dc.b	" : set",10,0
MsgDisabled:		dc.b	" : disabled",10,0
MsgEnabled:			dc.b	" : enabled",10,0
MsgNo:				dc.b	" : no",10,0
MsgYes:				dc.b	" : yes",10,0
MsgUser:				dc.b	" : user mode",10,0
MsgSuper:			dc.b	" : supervisor mode",10,0
MsgPage4:			dc.b	" : 4K",10,0
MsgPage8:			dc.b	" : 8K",10,0

	;CACR bit messages
MsgWA:				dc.b	"Write Allocate",0
MsgDBE:				dc.b	"Data Burst",0
MsgCD:				dc.b	"Clear DCache",0
MsgCED:				dc.b	"Clear Entry in DCache",0
MsgFD:				dc.b	"Freeze DCache",0
MsgED:				dc.b	"Data Cache",0
MsgIBE:				dc.b	"Instruction Burst",0
MsgCIC:				dc.b	"Clear ICache",0
MsgCEI:				dc.b	"Clear Entry in ICache",0
MsgFI:				dc.b	"Freeze ICache",0
MsgEI:				dc.b	"Instruction Cache",0
	;CACR bit messages for the 68040
MsgDE					equ	MsgED
MsgIE					equ	MsgEI

MsgWatchOn:			dc.b	"Big brother is watching you!",10,0
MsgWatchOff:		dc.b	"Big brother closed his eyes!",10,0
MsgMissedBERR:		dc.b	"I missed some bus errors!",10,0

;FormatTld:			dc.b	"Tag: %2.d  Task: %08lx",10,0
FormatTld:
		FF		str_,"Tag:",d,2,spc,2,str_,"Task:"
		FF		X,0,nlend,0

;FormatBusErr:		dc.b	"BERR! A: %08lx Task: %08lx PC: %08lx SP: %08lx Val: %08lx %2.ld",10,0
FormatBusErr:
		FF		str_,"BERR!",str_,"A:",X_,0,str_,"Task:"
		FF		X_,0,str_,"PC:",X_,0,str_,"SP:"
		FF		X_,0,str_,"Val:",X_,0,D,2
		FF		nlend,0

MsgFrozenTask:		dc.b	"BERR! Task frozen!",10,0

Spaces:				dc.b	"   ",0

	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLongNNLFormat:
					dc.b	"%08lx ",0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	END
