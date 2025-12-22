*****
****
***			M M U   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Thu Mar 24 10:55:51 1994
***			© Jorrit Tyberghein
****
*****

 * Part of PowerVisor source   Copyright © 1993   Jorrit Tyberghein
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
	XDEF		GetMMUType
	XDEF		MMUConstructor,MMUDestructor,RoutMMUWatch,OriginalPC
	XDEF		FuncGetMMUEntry,RoutProtect,DumpBERRs,RoutTagType
	XDEF		FAsc2Ext,FExt2Asc,RoutMMUEntry

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
	XREF		GetEntryDescriptor
	XREF		GetEntryLogical
	XREF		GetEntryPhysical
	XREF		GetEntryType
	XREF		GetEntryFlagsS
	XREF		GetEntryEntryS
	XREF		GetEntryLevel
	XREF		GetEntryBytes
	XREF		GetEntryInMMUTree
	XREF		GetEntryAllowProtect
	XREF		SetEntryNotUsed
	XREF		SetEntryProtect
	XREF		ShowMMURegs
	XREF		ShowSpecRegs
	XREF		PrintMMUEntry
	XREF		SuperPoke
	XREF		SuperPeek
	XREF		ProtectRange
	XREF		AllocMMUTree
	XREF		FreeMMUTree
	XREF		InstallMMUTree
	XREF		RemoveMMUTree
	XREF		MMUTreeInstalled
	XREF		FlushCache
	XREF		FlushCacheSuper
	XREF		BERRStartHandler
	XREF		BERRStopHandler
	XREF		BERRSimulateWrite
	XREF		BERRSimulateRead
	XREF		BERRRecover

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	section MMUCode,code

	;***
	;Constructor: initialize everything for mmu
	;-> d0 = 0 if success (flags) else errorcode
	;***
MMUConstructor:
		lea		(PrintRealHex),a0
		lea		(PrintRealHexNL),a1
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
	;Command: install memory protection manager
	;***
RoutMMUWatch:
		bsr		UpdateMMU
		move.l	(MMUType),d0
		ERROReq	YouNeedMMU

		jsr		(MMUTreeInstalled)
		bne.b		1$

	;Install
		bsr.w		MoveVBR
		movea.l	(MMUState,pc),a0
		jsr		(RemoveMMUTree)
		jsr		(AllocMMUTree)				;@@@ Test for error
		jsr		(InstallMMUTree)
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
		movea.l	(MMUState,pc),a0
		jsr		(RemoveMMUTree)
		bsr.w		RemoveTrapBus
		movea.l	(MMUState,pc),a0
		jsr		(FreeMMUTree)
		bra.w		RestoreVBR

	;***
	;Command: Reset all USED and MODIFIED flags in the MMU table
	;***
RoutMMUReset:
		bsr		UpdateMMU
		lea		(ResetEntry,pc),a2
		jsr		(ScanMMUTree)		;No user data
		jmp		(FlushCache)
ResetEntry:
		jmp		(SetEntryNotUsed)

	;***
	;Command: show all special registers
	;***
RoutSpecRegs:
		bsr		UpdateMMU
		jmp		(ShowSpecRegs)

	;***
	;Command: poke value in memory (long) using supervisor
	;***
RoutSPoke:
		EVALE								;Get address
		movea.l	d0,a2
		EVALE								;Get long value
		movea.l	a2,a1
		bsr		UpdateMMU
		jmp		(SuperPoke)

	;***
	;Command: peek value from memory (long) using supervisor
	;***
RoutSPeek:
		EVALE								;Get address
		movea.l	d0,a1
		bsr		UpdateMMU
		jsr		(SuperPeek)
		PRINTHEX
		rts

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
	;	- These bits are set by the 'AllocMMUTree' function
	;***
RoutProtect:
		movea.l	(MMUState,pc),a0
		jsr		(MMUTreeInstalled)
		ERROReq	FirstInstallWatch

		bsr		UpdateMMU
		movea.l	a0,a3					;For ApplyCommandOnTags (ProtectTag)
		lea		(ValidateEntry,pc),a2
		jsr		(ScanMMUTree)		;No user data

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
		jsr		(ApplyCommandOnTags)	;(Used to be in Disable/Enable pair, but I don't think these were needed)

2$		dbra		d2,1$

		jsr		(FlushCache)

		move.l	(a7)+,d0				;Restore old current tag list
		jmp		(UseTag)

	;---
	;a0 = MMU state
	;-> a0 = MMU state
	;---
ValidateEntry:
		moveq		#PRT_NONE,d1
		jmp		(SetEntryProtect)

	;---
	;(this routine is called from ApplyCommandOnTags so it must preserve all registers
	;except a0-a1/a3/d0-d1/d3/a6)
	;a0 = pointer to tag
	;a3 = MMU state
	;-> a3 = MMU state
	;---
ProtectTag:
		move.w	(tag_Flags,a0),d1	;Get protection type (this is compatible with the BTAG_xxx flags)
		move.l	(tag_Size,a0),d0
		movea.l	(tag_Address,a0),a1
		movea.l	a3,a0					;Get pointer to MMU state
		jmp		(ProtectRange)

	;***
	;Command: show the MMU tree entry for a logical address
	;***
RoutMMUEntry:
		EVALE
		move.l	d0,-(a7)
		bsr		UpdateMMU
		movea.l	(a7)+,a1
		jsr		(GetEntryInMMUTree)
		jmp		(PrintMMUEntry)

	;***
	;Command: show MMU tree (DEBUG: FC tree not supported yet)
	;***
RoutMMUTree:
		bsr		UpdateMMU
		lea		(PrintMMUTree,pc),a2
		jmp		(ScanMMUTree)		;No UserData

	;***
	;Print an entry from the MMU tree (called from within ScanMMUTree)
	;a0 = private MMU state pointer
	;***
PrintMMUTree:
		jmp		(PrintMMUEntry)

	;***
	;Command: show all special registers
	;***
RoutMMURegs:
		bsr		UpdateMMU
		jmp		(ShowMMURegs)

	;***
	;Update the processor state, this function does not return if there is an error
	;-> a0 = MMU State
	;-> Preserves all other registers
	;***
UpdateMMU:
		movem.l	d0-d1/a1,-(a7)
		move.l	(MMUState,pc),d0
		ERROReq	YouNeedMMU
		movea.l	d0,a0
		jsr		(UpdateMMUState)
		movem.l	(a7)+,d0-d1/a1
		rts

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
	;the table empty afterwards. Please note that this table may grow
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
	;Stop the offending bus error task but not if this task happens
	;to be PowerVisor (we are really egoistic about this).
	;ONLY CALL THIS FUNCTION WITH JSR OR BSR STARTING FROM THE STACKFRAME
	;PUT THERE WITH BERRStartHandler!
	;a7+16*4 = bus error stack frame
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
		suba.l	a0,a0						;No replyport
		CALLPV	PP_SignalPowerVisor

		move.l	(16*4+8+2,a7),d0		;PC
		lea		(OriginalPC,pc),a1
		move.l	d0,(a1)

		ori.w		#$8000,(16*4+8,a7)	;Enable trace mode

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
	;ONLY CALL THIS FUNCTION WITH JSR OR BSR STARTING FROM THE STACKFRAME
	;PUT THERE WITH BERRStartHandler!
	;a7+16*4 = bus error stack frame
	;-> d0 is preserved
	;***
AddBERRspec:
		move.l	d0,-(a7)
		move.l	(BusErrTable,pc),d0
		bne.b		1$
		move.l	(a7)+,d0
		rts

1$		lea		(MissedBusError,pc),a1
		move.w	#1,(a1)					;It is possible that we miss a bus error

		movea.l	d0,a0
		lea		(BusErrNum,pc),a1
		move.l	(a1),d0
		cmp.l		#MAXBERR,d0
		bge.b		4$

	;There is a table and it is not full
		addq.l	#1,(a1)
		lea		(MissedBusError,pc),a1
		clr.w		(a1)						;We don't miss this bus error
		lsl.l		#5,d0						;Multiply with 32 == berr_SIZE
		lea		(0,a0,d0.l),a0			;Pointer to bus error entry (berr)
		move.l	(16*4+8+16,a7),(berr_FaultAddress,a0)
		movea.l	(SysBase).w,a6
		move.l	(ThisTask,a6),(berr_Task,a0)
		move.l	(16*4+8+2,a7),(berr_PC,a0)
		move.l	usp,a1
		move.l	a1,(berr_SP,a0)

	;Get value to write and Read/Write flags
		moveq		#0,d0						;Value to write
		moveq		#0,d1						;Flags

		btst.b	#6,(16*4+8+11,a7)		;RW (Read Write)
		bne.b		3$
	;Write
		bset.l	#berrB_Write,d1
		move.l	(16*4+8+$18,a7),d0	;Data output buffer
		bra.b		2$
	;Read
3$		bset.l	#berrB_Read,d1
2$		move.l	d0,(berr_Value,a0)

	;Get size of offense (SIZE field in SSW)
	mc68030
		bfextu	(16*4+8+10,a7){10:2},d0
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
	;this failure is in a tag range.
	;ONLY JUMP TO THIS LABEL WITH BRA OR JMP BECAUSE THE STACKFRAME FROM
	;BERRStartHandler HAS TO BE PRESERVED
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

;3$	movem.l	(a7)+,d0-d1/a0-a2/a6
3$		jsr		(BERRStopHandler)
		rte

	;***
	;Start entry for the bus handler
	;***
BusHandler:
		jsr		(BERRStartHandler)
		move.l	d0,d4					;Remember action

		movea.l	a4,a1					;Get fault address
		movea.l	(MMUState,pc),a0
		jsr		(GetEntryInMMUTree)
		tst.l		d0
		beq.b		3$						;It is not our concern!
		movea.l	d0,a2					;Pointer to entry

;@@@ Eventueel hier veralgemenen
;		movea.l	a4,a0					;Fault address
;		bsr.w		CheckAddressInTags
;		beq.b		2$

2$		tst.b		d4
		beq.w		SingleStepInst		; 0 == SingleStep
		blt.w		1$						;-1 == Read
											; 1 == Write

	;There was a data fault (write) bus error
	;We will recover if needed
		movea.l	a4,a0					;Fault address
		bsr.w		CheckAddressInTags
		beq.b		SimulateWrite
		move.w	(tag_Flags,a1),d0
		and.w		#FTAG_WPROTECT,d0
		beq.b		SimulateWrite

		bra.b		ShowFailure

3$		jsr		(BERRStopHandler)
		rte

	;There was a read data fault (read) bus error
	;We will recover if needed
1$		movea.l	a4,a0					;Fault address
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
		btst.b	#0,(2,a2)			;Bit 8 of the first longword of our entry
		beq.b		2$						;It is not one of our own entries
											;Do not simulate the write because this
											;could be harmful. We simply ignore the
											;write action (no message, no simulation)

	;It is one of our own entries
		movea.l	a2,a1
		jsr		(BERRSimulateWrite)

2$		jsr		(BERRStopHandler)
		rte

	;***
	;We had a read data fault bus error, but the address was not in
	;a protected range. So we should simulate the read on behalf of
	;the failing program
	;a2 = pointer to MMU entry
	;***
SimulateRead:
		movea.l	a2,a1
		jsr		(BERRSimulateRead)
		jsr		(BERRStopHandler)
		rte

BusJumpAddress:
		jmp		($00000000).l

	;***
	;Simulate all other unrecognized bus errors by single-stepping the
	;instruction
	;a2 = pointer to MMU entry
	;a4 = fault address
	;***
SingleStepInst:
		movea.l	a4,a0					;Fault address
		bsr.w		CheckAddressInTags
		beq.b		1$
		move.w	(tag_Flags,a1),d0
		and.w		#FTAG_WPROTECT+FTAG_RPROTECT,d0
		beq.b		1$

	;BUG
	;We should freeze here, because we can't simply let the program
	;continue executing. We would get continious bus errors
		bra.w		ShowFailure

1$		jsr		(BERRRecover)
		jsr		(BERRStopHandler)
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
		movea.l	(MMUState,pc),a0
		jsr		(RemoveMMUTree)
		moveq		#KBD_RESETHANDLERDONE,d2
		bra.b		PerformKeyBoardCmd

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

PBusT:				dc.l	0
MissedBusError:	dc.w	0			;If true we missed a bus error
BusErrTable:		dc.l	0			;Table containing the most recent bus errors
BusErrNum:			dc.l	0			;(only if our memory protection system is on)

	;This table contains all descriptors for all tag lists and what each
	;tag list is used for in the memory protection system
TldTable:			dc.l	0,0		;Global entry (can't be changed)
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

MyVBR:				dc.l	0			;Pointer to PowerVisor VBR table
ResetHInst:			dc.w	0			;True if reset handler is installed

SizeTable:			dc.w	256,512,1024,2048,4096,8192,16384,32768

ResetHandler:		ds.b	IS_SIZE
KeyBoardDevice:	dc.b	"keyboard.device",0

ExistsTable:		dc.b	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

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

	IFD	DEBUGGING
DebugLongFormat:
					dc.b	"%08lx",10,0
DebugLongNNLFormat:
					dc.b	"%08lx ",0
DebugLong2Format:
					dc.b	"%s : %08lx",10,0
	ENDC

	END
