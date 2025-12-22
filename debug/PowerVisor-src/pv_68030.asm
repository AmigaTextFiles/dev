*****
****
***			6 8 0 3 0   routines for   P O W E R V I S O R
**
*				Version 1.43
**				Thu Mar 24 09:45:15 1994
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

			INCLUDE	"pv.68030.i"

	super

	XDEF	GetMMUState
	XDEF	UpdateMMUState
	XDEF	FreeMMUState
	XDEF	GetURP
	XDEF	GetPageSize
	XDEF	TestMMUTranslation
	XDEF	ScanMMUTree
	XDEF	GetEntryDescriptor
	XDEF	GetEntryLogical
	XDEF	GetEntryPhysical
	XDEF	GetEntryType
	XDEF	GetEntryFlagsS
	XDEF	GetEntryEntryS
	XDEF	GetEntryLevel
	XDEF	GetEntryBytes
	XDEF	GetEntryInMMUTree
	XDEF	SetEntryNotUsed
	XDEF	SetEntryProtect
	XDEF	ShowMMURegs
	XDEF	ShowSpecRegs
	XDEF	PrintMMUEntry
	XDEF	SuperPoke
	XDEF	SuperPeek
	XDEF	ProtectRange
	XDEF	AllocMMUTree
	XDEF	FreeMMUTree
	XDEF	InstallMMUTree
	XDEF	RemoveMMUTree
	XDEF	MMUTreeInstalled
	XDEF	FlushCache
	XDEF	FlushCacheSuper
	XDEF	BERRStartHandler
	XDEF	BERRStopHandler
	XDEF	BERRSimulateWrite
	XDEF	BERRSimulateRead
	XDEF	BERRRecover

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Get MMU state
	;a0 = pointer to PrintRealHex routine
	;a1 = pointer to PrintRealHexNL routine
	;-> d0 = pointer to private MMU state structure (or 0 if no success)
	;-> a0 = d0
	;***
GetMMUState:
		movem.l	a2-a3/a5/a6,-(a7)

		movea.l	a0,a2
		movea.l	a1,a3

		move.l	#mmu_SIZE,d0
		move.l	#MEMF_CLEAR,d1
		CALLEXEC	AllocMem
		movea.l	d0,a0
		tst.l		d0
		beq.b		1$

		move.l	a2,(mmu_PrintRealHex,a0)
		move.l	a3,(mmu_PrintRealHexNL,a0)

		CALL		Disable
		lea		(SuperMREG,pc),a5
		CALL		Supervisor
		CALL		Enable

		bsr.b		ComputeMMUstate
		move.l	a0,d0

1$		movem.l	(a7)+,a2-a3/a5/a6
		rts

	;---
	;Supervisor routine to get all registers
	;---
SuperMREG:
	mc68030
		pmove.q	crp,(mmu_RegCRP,a0)
		pmove.q	srp,(mmu_RegSRP,a0)
		pmove.l	tc,(mmu_RegTC,a0)
		pmove.l	tt0,(mmu_RegTT0,a0)
		pmove.l	tt1,(mmu_RegTT1,a0)
		lea		(mmu_RegMSP,a0),a1
		movec		msp,d0
		move.l	d0,(a1)+
		movec		isp,d0
		move.l	d0,(a1)+
		movec		usp,d0
		move.l	d0,(a1)+
		movec		sfc,d0
		move.l	d0,(a1)+
		movec		dfc,d0
		move.l	d0,(a1)+
		movec		vbr,d0
		move.l	d0,(a1)+
		movec		cacr,d0
		move.l	d0,(a1)+
		movec		caar,d0
		move.l	d0,(a1)+
	mc68000
		rte

	;***
	;Update MMU state
	;a0 = MMU state
	;-> a0 = MMU state (the same)
	;***
UpdateMMUState:
		movem.l	a5-a6,-(a7)

		CALLEXEC	Disable
		lea		(SuperMREG,pc),a5
		CALL		Supervisor
		CALL		Enable

		bsr.b		ComputeMMUstate

		movem.l	(a7)+,a5-a6
		rts

	;---
	;Compute some other internal MMU state fields
	;a0 = MMU state
	;-> a0 = MMU state
	;---
ComputeMMUstate:
	;Compute ISS, TIA, TIB, TIC, TID and Table Size
		move.l	(mmu_RegTC,a0),d0
		lea		(SizeTable,pc),a1
	mc68030
		bfextu	d0{9:3},d1
		move.w	(0,a1,d1.w*2),(mmu_PageSize,a0)
	;Initial shift
		lea		(mmu_ISS,a0),a1
		bfextu	d0{12:4},d1
		move.w	d1,(a1)+						;ISS
	;TIA,TIB,TIC,TID
		bfextu	d0{16:4},d1
		move.w	d1,(a1)+						;TIA
		bfextu	d0{20:4},d1
		move.w	d1,(a1)+						;TIB
		bfextu	d0{24:4},d1
		move.w	d1,(a1)+						;TIC
		bfextu	d0{28:4},d1
		move.w	d1,(a1)						;TID
	mc68000

		move.w	(mmu_RegCRP,a0),d0
		bclr		#15,d0
		beq.b		1$
	;L/U bit was set, limit is lower
		move.w	d0,(mmu_LoLimit,a0)
		moveq		#-1,d0
		move.w	d0,(mmu_UpLimit,a0)
		bra.b		2$
	;L/U bit is cleared, limit is upper
1$		move.w	d0,(mmu_UpLimit,a0)
		moveq		#0,d0
		move.w	d0,(mmu_LoLimit,a0)
	;Continue

2$		moveq		#32,d0
		sub.w		(mmu_ISS,a0),d0	;Number of significant bits in address
		move.w	d0,(mmu_LogBits,a0)
		moveq		#1,d1
		lsl.l		d0,d1					;Maximum logical address
		move.l	d1,(mmu_MaxLogAddr,a0)
		rts

SizeTable:			dc.w	256,512,1024,2048,4096,8192,16384,32768

	;***
	;Free MMU state
	;a0 = pointer to private MMU state structure (may be 0)
	;***
FreeMMUState:
		bsr		RemoveMMUTree
		bsr		FreeMMUTree
		move.l	a0,d0
		tst.l		d0
		beq.b		1$
		move.l	a6,-(a7)
		movea.l	d0,a1
		move.l	#mmu_SIZE,d0
		CALLEXEC	FreeMem
		movea.l	(a7)+,a6
1$		rts

	;***
	;Routine to flush the cache for all AmigaOS versions.
	;This routine is guaranteed to preserve all registers
	;***
FlushCache:
		movem.l	d0-d1/a0-a1/a5-a6,-(a7)
		movea.l	(SysBase).w,a6
		move.w	(LIB_VERSION,a6),d0
		cmp.w		#36,d0
		blt.b		1$

	;2.0, 3.0, 3.1, ... version
		CALL		CacheClearU
		bra.b		2$

	;1.2, 1.3 version
1$		lea		(SuperCacheFlush13,pc),a5
		CALL		Supervisor

2$		movem.l	(a7)+,d0-d1/a0-a1/a5-a6
		rts

SuperCacheFlush13:
		bsr.b		FlushCacheSuper13
		rte

	;***
	;Routine to flush the cache for all AmigaOS versions.
	;Version for supervisor mode.
	;This routine is guaranteed to preserve all registers
	;***
FlushCacheSuper:
		movem.l	d0-d1/a0-a1/a6,-(a7)
		movea.l	(SysBase).w,a6
		move.w	(LIB_VERSION,a6),d0
		cmp.w		#36,d0
		blt.b		1$

	;2.0, 3.0, 3.1, ... version
		CALL		CacheClearU
		bra.b		2$

	;1.2, 1.3 version
1$		bsr.b		FlushCacheSuper13

2$		movem.l	(a7)+,d0-d1/a0-a1/a6
		rts

	;***
	;Routine to flush the cache for AmigaOS 1.2/1.3 (supervisor version)
	;This routine is guaranteed to preserve all registers
	;***
FlushCacheSuper13:
		move.l	d0,-(a7)
	mc68030
		movec		cacr,d0
		bset		#11,d0				;Clear Data Cache
		bset		#3,d0					;Clear Instruction Cache
		movec		d0,cacr
	mc68000
		move.l	(a7)+,d0
		rts

	;***
	;Get user root pointer
	;a0 = MMU state
	;-> d0 = root pointer
	;-> a0 = MMU state
	;***
GetURP:
		move.l	(mmu_RegCRP+4,a0),d0
		and.b		#$f0,d0						;Clear unused bits
		rts

	;***
	;Get page size
	;a0 = MMU state
	;-> d0 = table size
	;-> a0 = MMU state
	;***
GetPageSize:
		moveq		#0,d0
		move.w	(mmu_PageSize,a0),d0
		rts

	;***
	;Test if the translation is enabled
	;a0 = MMU state
	;-> d0 = 1 if enabled, 0 otherwise
	;-> a0 = MMU state
	;***
TestMMUTranslation:
	mc68030
		bfextu	(mmu_RegTC,a0){0:1},d0
		rts
	mc68000

	;***
	;Scan MMU tree
	;a0 = MMU state
	;a1 = userdata (will be passed to routine)
	;a2 = routine to call at each entry
	;		;---
	;		;a0 = MMU state
	;		;a1 = userdata
	;		;-> a1 = new userdata (will be used for the following call of this function)
	;		;-> routine may modify all other registers, this will have no effect at all
	;		;---
	;-> a0 = MMU state
	;***
ScanMMUTree:
		movem.l	d2-d7/a2-a6,-(a7)

		movea.l	a2,a6					;Remember routine
		moveq		#1,d5					;Level 1
		moveq		#0,d1					;No flags in root
		suba.l	a4,a4					;Logical address
		move.l	(mmu_RegCRP+4,a0),d2
		andi.b	#$f0,d2
		move.w	(mmu_LoLimit,a0),d3
		move.w	(mmu_UpLimit,a0),d4
		moveq		#0,d7
		move.w	(mmu_LogBits,a0),d7
		movea.l	(mmu_MaxLogAddr,a0),a5
		lea		(mmu_TIA,a0),a3	;Pointer to TIx reg
		suba.l	a2,a2
		lea		(4,a2),a2			;Dummy address for tree scanning routines
		move.w	(mmu_RegCRP+2,a0),d0
		andi.w	#3,d0					;Extract DT field
		bne.b		1$
		bsr.b		ScanInvalidTree
		bra.b		4$
1$		cmpi.w	#1,d0
		bne.b		2$
		bsr.b		ScanPageDescTree
		bra.b		4$
2$		cmpi.w	#2,d0
		bne.b		3$
		bsr.b		Scan4ByteTree
		bra.b		4$
3$		bsr.b		Scan8ByteTree

4$		movem.l	(a7)+,d2-d7/a2-a6
		rts

	;---
	;Scan routines
	;d0 = value of DT (0, 1, 2 or 3)
	;d1 = flags
	;d2 = address
	;d3.w = lower limit
	;d4.w = upper limit (or -1 if not used)
	;d5 = level counter
	;d7 = number of bits for logical address
	;a0 = MMU state
	;a1 = UserData
	;a2 = address + 4 of current descriptor
	;a3 = ptr to TIx reg
	;a4 = logical address at this moment
	;a5 = total representative bytes
	;a6 = routine to call
	;-> a0 = MMU state
	;---
ScanInvalidTree:
ScanPageDescTree:
Scan8ByteTree:
		bra		CallUserRout

Scan4ByteTree:
		bsr		CallUserRout

		movem.l	a2/a4-a5/d6-d7,-(a7)
		addq.w	#1,d5
		moveq		#0,d6
		move.w	(a3)+,d6				;Get TIx bits
		sub.l		d6,d7
		moveq		#1,d0
		lsl.l		d7,d0					;d0 is the new number of maximum log bytes
		movea.l	d0,a5

		movea.l	d2,a2
		moveq		#1,d1
		lsl.w		d6,d1					;Maximum number of entries in table
		cmpi.w	#-1,d4
		beq.b		1$
	;There is a limit
		cmp.w		d4,d1
		ble.b		1$
		move.w	d4,d1
	;d1 = number of entries to scan
1$		subq.w	#1,d1

	;Loop for each entry
2$		move.l	d1,-(a7)
		move.l	(a2)+,d2
		move.l	d2,d1					;Remember for flags
		move.l	d2,d0					;Extract DT
		andi.w	#3,d0
		beq.b		3$
		cmpi.w	#1,d0
		beq.b		4$
		cmpi.w	#2,d0
		beq.b		5$
	;DT=3
		andi.b	#$f0,d2
		andi.w	#$000f,d1
		moveq		#0,d3
		moveq		#-1,d4
		bsr.w		Scan8ByteTree
		bra.b		6$
	;DT=0
3$		andi.w	#$0003,d1
		bsr.w		ScanInvalidTree
		bra.b		6$
	;DT=1
4$		andi.b	#$0,d2
		moveq		#0,d3
		moveq		#-1,d4
		andi.w	#$00ff,d1
		bsr.w		ScanPageDescTree
		bra.b		6$
	;DT=2
5$		andi.b	#$f0,d2
		moveq		#0,d3
		moveq		#-1,d4
		andi.w	#$000f,d1
		bsr.w		Scan4ByteTree
	;End, advance logical address
6$		adda.l	a5,a4
		move.l	(a7)+,d1
		dbra		d1,2$

		subq.l	#2,a3					;Restore to previous TIx
		subq.w	#1,d5
		movem.l	(a7)+,a2/a4-a5/d6-d7
		rts

	;---
	;Call the user routine
	;---
CallUserRout:
		movem.l	d0-d7/a0/a2-a6,-(a7)
		move.w	d0,(mmu_DT,a0)
		move.w	d1,(mmu_flags,a0)
		move.l	d2,(mmu_Entry,a0)
		move.l	a2,(mmu_Descriptor,a0)
		move.w	d5,(mmu_Level,a0)
		move.l	a4,(mmu_LogAddress,a0)
		move.l	a5,(mmu_TotLogBytes,a0)
		jsr		(a6)
		movem.l	(a7)+,d0-d7/a0/a2-a6
		rts

	;***
	;Standard routine usable for ScanMMUTree
	;This routine prints information for one MMU entry
	;ONLY IN SCANMMUTREE
	;a0 = private MMU state pointer
	;-> a0 = private MMU state pointer
	;***
PrintMMUEntry:
		movem.l	a0/a2-a3/a6,-(a7)
		lea		(-12,a7),a7
		movea.l	a7,a3					;Print space

		movea.l	a0,a2
		bsr		GetEntryDescriptor
		movea.l	(mmu_PrintRealHexNL,a2),a0
		jsr		(a0)
		movea.l	a2,a0
		bsr		GetEntryLevel
		bsr		Print3Spaces

		movea.l	a3,a1
		move.l	#$20202020,(a1)
		move.l	#$20202000,(4,a1)
		movea.l	a2,a0
		bsr		GetEntryEntryS
		movea.l	a3,a0
		PRINT

		movea.l	a3,a1
		move.b	#'(',(a1)+
		move.l	#$20202020,(1,a1)
		move.l	#')  '<<8,(5,a1)
		movea.l	a2,a0
		bsr		GetEntryFlagsS
		movea.l	a3,a0
		PRINT

		lea		(MsgLog,pc),a0
		PRINT

		movea.l	a2,a0
		bsr		GetEntryLogical
		movea.l	(mmu_PrintRealHexNL,a2),a0
		jsr		(a0)

		lea		(MsgBytesTree,pc),a0
		PRINT

		movea.l	a2,a0
		bsr		GetEntryBytes
		movea.l	(mmu_PrintRealHexNL,a2),a0
		jsr		(a0)

		movea.l	a2,a0
		bsr		GetEntryType
		cmp.b		#1,d0
		bne.b		1$

	;It is a page
		lea		(MsgPhysicalTree,pc),a0
		PRINT

		movea.l	a2,a0
		bsr		GetEntryPhysical
		movea.l	(mmu_PrintRealHexNL,a2),a0
		jsr		(a0)

1$		NEWLINE

		lea		(12,a7),a7			;Free Print space
		movem.l	(a7)+,a0/a2-a3/a6
		rts

	;***
	;Reset USED and MODIFIED bit
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> a0 = MMU state
	;***
SetEntryNotUsed:
		bsr		GetEntryDescriptor
		beq.b		1$
		movea.l	d0,a1					;Pointer to descriptor
		bsr		GetEntryType
		cmp.b		#1,d0
		bne.b		1$

	;PAGE
		move.l	(a1),d0				;Or bsr SuperPeek?
		and.b		#~(16+8),d0			;Clear USED and MODIFIED
		bsr		SuperPoke

1$		rts

	;***
	;Get current descriptor address
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> d0 = current desciptor address
	;-> a0 = MMU state
	;***
GetEntryDescriptor:
		move.l	(mmu_Descriptor,a0),d0
		subq.l	#4,d0
		rts

	;***
	;Get current logical address
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> d0 = current logical address
	;-> a0 = MMU state
	;***
GetEntryLogical:
		move.l	(mmu_LogAddress,a0),d0
		rts

	;***
	;Get current physical address (only for pages)
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> d0 = current physical address (or -1 if not a page)
	;-> a0 = MMU state
	;***
GetEntryPhysical:
		move.w	(mmu_DT,a0),d0
		cmp.b		#1,d0					;DT = PAGE DESCRIPTOR
		bne.b		1$

	;Page
		move.l	(mmu_Entry,a0),d0
		rts

1$		moveq		#-1,d0
		rts

	;***
	;Get processor independant type of current descriptor
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> d0 = type : 0 for invalid, 1 for page, 2 for table
	;-> a0 = MMU state
	;***
GetEntryType:
		moveq		#0,d0
		move.w	(mmu_DT,a0),d0
		cmp.b		#2,d0
		ble.b		1$
		moveq		#2,d0
1$		rts

	;***
	;Give string with description of flags
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;a1 = pointer to string buffer (at least 8 bytes), will not be null-terminated
	;-> a0 = MMU state
	;***
GetEntryFlagsS:
		move.w	(mmu_flags,a0),d0

		move.w	(mmu_DT,a0),d1
		cmp.w		#1,d1					;DT = PAGE DESCRIPTOR
		bne.b		5$

	;Page
		move.l	#'imuw',(a1)		;This is possible since we are surely running on an 68030

		btst.l	#6,d0					;Cache Inhibit
		beq.b		1$
		subi.b	#'a'-'A',(a1)
1$		btst.l	#4,d0					;Modified
		beq.b		2$
		subi.b	#'a'-'A',(1,a1)
2$		btst.l	#3,d0					;Used
		beq.b		3$
		subi.b	#'a'-'A',(2,a1)
3$		btst.l	#2,d0					;Write Protect
		beq.b		4$
		subi.b	#'a'-'A',(3,a1)
4$		rts

	;Table descriptor
5$		move.w	#'uw',(a1)
		subq.l	#2,a1
		bra.b		2$

	;***
	;Give string with description of the name of current entry
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;a1 = pointer to string buffer (at least 8 bytes long), will not be null-terminated
	;-> a0 = MMU state
	;***
GetEntryEntryS:
		move.l	a2,-(a7)
		move.w	(mmu_DT,a0),d0
		lea		(EntryStrings,pc),a2
	mc68030
		movea.l	(0,a2,d0.w*4),a2
	mc68000
1$		move.b	(a2)+,d0
		beq.b		2$
		move.b	d0,(a1)+
		bra.b		1$

2$		movea.l	(a7)+,a2
		rts

	;***
	;Get level in MMU scan
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> d0 = level
	;-> a0 = MMU state
	;***
GetEntryLevel:
		moveq		#0,d0
		move.w	(mmu_Level,a0),d0
		rts

	;***
	;Get number of bytes represented by this entry
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;-> d0 = number of bytes
	;-> a0 = MMU state
	;***
GetEntryBytes:
		move.l	(mmu_TotLogBytes,a0),d0
		rts

	;***
	;Get the entry for a logical address in the current MMU table
	;This routine simulates the situation where you can use all
	;routines normally only useful from within ScanMMUTree
	;@@@ BUG This routine does not yet check if an address is in the
	;table
	;a0 = MMU state
	;a1 = address
	;-> d0 = pointer to entry or 0 if no entry for this address
	;-> a1 = pointer to parent entry (only valid if d0 != 0)
	;-> a0 = MMU state
	;***
GetEntryInMMUTree:
		movem.l	d2-d7/a2/a5,-(a7)
		move.l	a1,d5					;Address
		move.l	a1,d6					;Remember for later

		move.l	(mmu_RegCRP+4,a0),d0
		andi.b	#$f0,d0
		tst.l		d0
		beq.w		2$						;MMU is not used

	;The MMU is used
		movea.l	d0,a5

	;Set all unused TIx registers to 0
		lea		(mmu_TIA,a0),a1
		move.w	(a1)+,d0				;TIA
		beq.b		3$
		move.w	(a1)+,d0				;TIB
		beq.b		4$
		move.w	(a1)+,d0				;TIC
		beq.b		5$
		bra.b		6$
3$		clr.w		(a1)+					;TIB
4$		clr.w		(a1)+					;TIC
5$		clr.w		(a1)+					;TID

	;Start parsing the address and table
6$		move.w	(mmu_TID,a0),d4
		add.w		(mmu_TIC,a0),d4
		add.w		(mmu_TIB,a0),d4
		lea		(mmu_TIA,a0),a1

		moveq		#32,d1
		sub.w		d4,d1
		sub.w		(a1),d1
		sub.w		(mmu_ISS,a0),d1
		lsr.l		d1,d5

		moveq		#0,d7					;No parent entry
		moveq		#3,d3					;Loop 4 times

	;Loop for each level (A, B, C and D)
8$		move.l	d5,d0
		lsr.l		d4,d0
		move.w	(a1),d1
		moveq		#1,d2
		lsl.l		d1,d2
		subq.l	#1,d2
		and.l		d2,d0					;d0 contains field

		move.l	a5,d7					;Remember parent entry
	mc68030
		lea		(0,a5,d0.l*4),a5	;Pointer to level entry
	mc68000
		move.l	(a5),d0
		and.b		#%11,d0				;dt
		cmp.b		#2,d0					;4 BYTE
		bne.b		7$
		move.l	(a5),d0
		and.b		#$f0,d0				;Remove u, wp, dt
		movea.l	d0,a5

		lea		(2,a1),a1			;Go to next TIx register
		sub.w		(a1),d4				;Subtract TIx register from bit offset
		dbra		d3,8$

7$		movea.l	d7,a1
		move.l	a5,d0

	;Store results in MMU state to simulate MMU tree scan point
		movea.l	d0,a2
		move.l	(a2),d1
		moveq		#0,d2
		move.b	d1,d2					;Get flags
		move.w	d2,(mmu_flags,a0)
		andi.b	#$0,d1				;We have a page
		move.l	d1,(mmu_Entry,a0)	;Physical address of page
		move.l	d0,d1
		addq.l	#4,d1
		move.l	d1,(mmu_Descriptor,a0)
		moveq		#1,d1					;DT = PAGE DESCRIPTOR
		move.w	d1,(mmu_DT,a0)
		moveq		#5,d1
		sub.w		d3,d1					;Level
		move.w	d1,(mmu_Level,a0)
		moveq		#1,d1
	mc68030
		bfextu	(mmu_RegTC,a0){8:4},d2	;Table size in bits (8 to 15)
	mc68000
		add.w		d2,d4
		lsl.l		d4,d1					;d4 = size (in bits) of this page
		move.l	d1,(mmu_TotLogBytes,a0)
		subq.l	#1,d1
		not.l		d1
		and.l		d1,d6					;d6 = start logical address of this page
		move.l	d6,(mmu_LogAddress,a0)

	;d0 = result
	;a0 = MMU state
	;a1 = parent

2$		movem.l	(a7)+,d2-d7/a2/a5
		rts

	;***
	;Poke value to physical address
	;a0 = MMU state
	;a1 = address
	;d0 = value
	;-> a0 = MMU state
	;***
SuperPoke:
		move.l	a6,-(a7)
		lea		(SSuperPoke,pc),a5
		CALLEXEC	Supervisor
		movea.l	(a7)+,a6
		rts

	;---
	;Supervisor routine for SuperPoke
	;This routine could fail if there are translations from logical
	;addresses to different physical addresses and this routine just
	;falls in such a trap. As far as I know these translations currently
	;do not happen, so this should not be a problem in the near future
	;---
SSuperPoke:
		CALL		Disable

		lea		(-4,a7),a7			;Allocate room on stack
	mc68030
		pmove.l	tc,(a7)				;Remember old TC register
	mc68000
		pea		(0).w
	mc68030
		pmove.l	(a7),tc				;Disable MMU translation
	mc68000
		move.l	d0,(a1)				;Poke value
	mc68030
		pmove.l	(4,a7),tc			;Restore old TC register
	mc68000
		lea		(8,a7),a7			;Clean stack

		CALL		Enable
		rte

	;***
	;Peek value from physical address
	;a0 = MMU state
	;a1 = address
	;-> a0 = MMU state
	;-> d0 = value
	;***
SuperPeek:
		move.l	a6,-(a7)
		lea		(SSuperPeek,pc),a5
		CALLEXEC	Supervisor
		movea.l	(a7)+,a6
		rts

	;---
	;Supervisor routine for SuperPeek
	;This routine could fail if there are translations from logical
	;addresses to different physical addresses and this routine just
	;falls in such a trap. As far as I know these translations currently
	;do not happen, so this should not be a problem in the near future
	;---
SSuperPeek:
		CALL		Disable

		lea		(-4,a7),a7
	mc68030
		pmove.l	tc,(a7)				;Remember old TC register
	mc68000
		pea		(0).w
	mc68030
		pmove.l	(a7),tc				;Disable MMU translation
	mc68000
		move.l	(a1),d0
	mc68030
		pmove.l	(4,a7),tc			;Restore old TC register
	mc68000
		lea		(8,a7),a7			;Clean stack

		CALL		Enable
		rte

;---------------------------------------------------------------------------
;Memory protection system
;---------------------------------------------------------------------------

	;***
	;Protect a page
	;ONLY IN SCANMMUTREE
	;a0 = MMU state
	;d1 = protection type (PRT_NONE, PRT_WPROTECT, PRT_RPROTECT or PRT_RWPROTECT)
	;-> a0 = MMU state
	;***
SetEntryProtect:
		bsr		GetEntryDescriptor
		beq.b		1$
		movea.l	d0,a1					;Pointer to descriptor

		move.w	(mmu_DT,a0),d0
		cmp.b		#2,d0
		bge.b		1$						;Only look at INVALID and PAGE entries

		move.l	(a1),d0				;Or bsr SuperPeek?
		btst.l	#8,d0					;Is this a special entry for the memory protection system?
		beq.b		1$						;No

		and.b		#%11111001,d0		;Clear WP and bit 1 of DT
		or.b		#%00000001,d0		;Set DT to PAGE

		btst.l	#0,d1					;Test if we must writeprotect?
		beq.b		2$						;No

		or.b		#%00000100,d0		;Set WP

2$		btst.l	#1,d1					;Test if we must readprotect?
		beq.b		3$						;No

		and.b		#%11111100,d0		;Set DT to INVALID

3$		bsr		SuperPoke
1$		rts

	;***
	;Protect a range of memory (memory protection must be enabled first!)
	;a0 = MMU state
	;a1 = start address
	;d0 = number of bytes to protect
	;d1 = protection type (PRT_NONE, PRT_WPROTECT, PRT_RPROTECT or PRT_RWPROTECT)
	;-> a0 = MMU state
	;***
ProtectRange:
		movem.l	a2/d2-d3,-(a7)
		movea.l	a1,a2					;Start address
		move.l	d0,d2					;Number of bytes
		move.l	d1,d3					;Remember protection type

	;Change last entry
		movea.l	a2,a1					;Get start address
		adda.l	d2,a1
		subq.l	#1,a1
		bsr		GetEntryInMMUTree
		tst.l		d0
		beq.b		2$
		move.l	d3,d1					;Restore protection type
		bsr		SetEntryProtect

	;Change all other entries
2$		movea.l	a2,a1
		bsr		GetEntryInMMUTree
		tst.l		d0
		beq.b		1$
		move.l	d3,d1					;Restore protection type
		bsr		SetEntryProtect
		moveq		#0,d0
		move.w	(mmu_PageSize,a0),d0
		adda.l	d0,a2
		sub.l		d0,d2
		bge.b		2$

1$		movem.l	(a7)+,a2/d2-d3
		rts

	;---
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
	;---
GetMMUTreeSize:
		movem.l	d4/a6,-(a7)

		movea.l	(SysBase).w,a6
		movea.l	(MemList,a6),a1
		moveq		#0,d4					;Size starts with 0
	;For each memory header
1$		tst.l		(a1)					;Succ
		beq.b		2$

		move.l	(MH_LOWER,a1),d0
		and.l		#-65536,d0			;Allign to get real start of region
		add.l		(MH_UPPER,a1),d4
		sub.l		d0,d4					;Add size of this region

		movea.l	(a1),a1				;Succ
		bra.b		1$

	;d4 is now the number of bytes available as normal RAM
	;We will now estimate the size of the MMU table using this
	;parameter. This estimate in fact slightly overestimates
	;the really needed size, but this is no big deal since the table
	;is not very large anyway
2$		bsr.w		Count2ndLevelTables

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

		movem.l	(a7)+,d4/a6
		rts

	;---
	;Count all needed 2nd level tables
	;-> d0 = number of needed 2nd level tables
	;---
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

	;---
	;Check if there is a memory header region that overlaps with this
	;16 Megabytes page in physical memory
	;d0 = address (multiple of 16 Megabytes)
	;-> flags NE if there is an overlap somewhere
	;-> all registers are preserved
	;---
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

	;---
	;Check if there is a memory header region that overlaps with this
	;256 KByte page in physical memory
	;d0 = address (multiple of 256 Kbytes)
	;-> flags NE if there is an overlap somewhere
	;-> all registers are preserved
	;---
CheckHeaderIn256K:
		movem.l	d0-d3/a1,-(a7)
		move.l	d0,d2
		move.l	d0,d3
		add.l		#$00040000,d3
		bra.b		In16MCheck

	;---
	;Little subroutine used by 'MakeMMUTree' to quickly calculate
	;the offset in the MMU tree for a second level table
	;d0 = number of the required second level table
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d0 = offset
	;-> all other registers are preserved
	;---
Get2nd:
		lsl.l		#6+2,d0				;6 bits for level B (4 bytes per entry)
		add.l		#1024,d0				;Skip root entry
		rts

	;---
	;Little subroutine used by 'MakeMMUTree' to quickly calculate
	;the offset in the MMU tree for a third level table
	;d0 = number of the required third level table
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d0 = offset
	;-> all other registers are preserved
	;---
Get3th:
		add.l		d3,d0					;Little trick that works because the number
											;of bits in level B and C are the same (6)
		lsl.l		#6+2,d0				;6 bits for level B and C (4 bytes per entry)
		add.l		#1024,d0
		rts

	;---
	;Check if an integer is in a region
	;a0 = integer to check
	;d0,d1 = low/high of region
	;-> flags NE if integer in region
	;-> all registers are unchanged
	;---
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

	;---
	;Check if one region overlaps another region. Use this function twice
	;to make sure all possible size differences are accounted for
	;d0,d1 = low/high of region 1 (must be larger than region 2)
	;d2,d3 = low/high of region 2
	;-> flags NE if region 2 overlaps region 1
	;-> all registers are unchanged
	;---
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

	;---
	;Init all second level tables for MMU tree.
	;This routine also initialized the root table to point to these
	;2nd level tables. The physical address are also filled in
	;For each second level table only the first physical address
	;is initialized. 'Init3thLevel' will do the rest
	;a2 = pointer to root
	;d3 = total number of second level tables
	;d4 = total number of third level tables
	;-> d2 = scratch
	;---
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

	;---
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
	;---
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

	;---
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
	;---
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
	;Free the PowerVisor MMU table
	;a0 = MMU state
	;-> a0 = MMU state
	;***
FreeMMUTree:
		move.l	(mmu_Table,a0),d0
		beq.b		1$
		movea.l	d0,a1
		move.l	(mmu_TableSize,a0),d0
		movem.l	a0/a6,-(a7)
		CALLEXEC	FreeMem
		movem.l	(a7)+,a0/a6
		clr.l		(mmu_Table,a0)
1$		rts

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
	;
	;a0 = MMU state
	;-> a0 = MMU state
	;-> d0 = 1 if success or 0 otherwise (flags)
	;***
AllocMMUTree:
		movem.l	d2-d4/a0/a2-a4/a6,-(a7)
		movea.l	a0,a4					;Remember MMU state

		bsr		FreeMMUTree

		bsr		GetMMUTreeSize		;d2 = (Over)estimated size, d0 = #2nd level, d1 = #3th level
		move.l	d2,(mmu_TableSize,a4)
		move.l	d0,d3					;Number of second level tables
		move.l	d1,d4					;Number of third level tables

		move.l	d2,d0
		move.l	#MEMF_CLEAR,d1
		CALLEXEC	AllocMem
		tst.l		d0
		beq.b		10$					;No success
		move.l	d0,(mmu_Table,a4)
		add.l		#1023,d0
		and.l		#-1024,d0
		move.l	d0,(mmu_Root,a4)
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

		moveq		#1,d0					;Success
10$	movem.l	(a7)+,d2-d4/a0/a2-a4/a6
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
	;a4 = MMU state
5$		move.l	(mmu_RegTC,a4),d0
		btst.l	#31,d0				;Check if MMU translation enabled
		beq.b		4$						;No, ROM is real

		movea.l	a4,a0
		bsr		GetEntryInMMUTree
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

	;It is not a PAGE descriptor or the entry is not in the existing
	;MMU tree. Set the page to WP
	mc68030
4$		move.l	(0,a3,d2.l*4),d1
	mc68000
		bra.b		6$

	;***
	;Install the PowerVisor MMU tree in the system (first use AllocMMUTree to make the tree)
	;a0 = MMU state
	;-> a0 = MMU state
	;***
InstallMMUTree:
		movem.l	a2/a5-a6,-(a7)

		move.w	(mmu_Installed,a0),d0	;If 1 the MMU table is already installed
		bne.b		1$
		moveq		#1,d0
		move.w	d0,(mmu_Installed,a0)

	;Remember all old MMU registers
		lea		(mmu_OrigRegCRP,a0),a1
		lea		(mmu_RegCRP,a0),a2
		moveq		#6,d0							;7 longwords to copy
2$		move.l	(a2)+,(a1)+
		dbra		d0,2$

	;Fill new values in MMU state
		lea		(mmu_RegCRP,a0),a2
		move.l	#$80000002,(a2)+
		move.l	(mmu_Root,a0),(a2)+		;CRP
		lea		(8,a2),a2					;SRP
		move.l	#$80c08660,(a2)+			;TC
		moveq		#0,d0
		move.l	d0,(a2)+						;TT0
		move.l	d0,(a2)+						;TT1

	;Fill the values for real
		lea		(MMUSuper,pc),a5
		CALLEXEC	Supervisor

1$		movem.l	(a7)+,a2/a5-a6
		rts

	;***
	;Restore the original MMU tree
	;a0 = MMU state
	;-> a0 = MMU state
	;***
RemoveMMUTree:
		movem.l	a2/a5-a6,-(a7)

		move.w	(mmu_Installed,a0),d0
		beq.b		1$
		clr.w		(mmu_Installed,a0)

	;First restore the original MMU registers
		lea		(mmu_RegCRP,a0),a1
		lea		(mmu_OrigRegCRP,a0),a2
		moveq		#6,d0							;7 longwords to copy
2$		move.l	(a2)+,(a1)+
		dbra		d0,2$

		lea		(MMUSuper,pc),a5
		CALLEXEC	Supervisor

1$		movem.l	(a7)+,a2/a5-a6
		rts

	;---
	;Supervisor routine to install or remove our MMU table
	;a0 = MMU state
	;---
MMUSuper:
		pea		(0).w
	mc68030
		pmove.l	(a7),tc				;Temporarily disable translation
		pmove.q	(mmu_RegCRP,a0),crp
		pmove.l	(mmu_RegTC,a0),tc
		pmove.l	(mmu_RegTT0,a0),tt0
		pmove.l	(mmu_RegTT1,a0),tt1
	mc68000
		lea		(4,a7),a7			;Clean up stack
		rte

	;***
	;Restore the original MMU tree
	;a0 = MMU state
	;-> a0 = MMU state
	;-> d0.w = 1 if MMU tree is installed or 0 otherwise (flags)
	;***
MMUTreeInstalled:
		move.w	(mmu_Installed,a0),d0
		rts

	;***
	;Start handling the bus error
	;This routine preserves all registers on stack (use StopBERRHandler to
	;restore everything) and returns some extra info
	;THIS FUNCTION MUST BE CALLED WITH BSR OR JSR!!!
	;-> d0 = 0 if handler must singlestep, -1 for read and 1 for write (flags)
	;-> a4 = fault address
	;***
BERRStartHandler:
		movem.l	d0-d7/a0-a6,-(a7)
		movea.l	(15*4,a7),a5		;Get returnaddress

		movea.l	(16*4+16,a7),a4	;Fault address
		btst.b	#0,(16*4+10,a7)	;DF (Data Fault) Bit 8 of SSW
		beq.w		3$						;No data fault

	;Data Fault
		bclr.b	#0,(16*4+10,a7)	;Clear DF (Data Fault)
		btst.b	#6,(16*4+11,a7)	;RW (Read Write)
		beq.b		2$
		clr.l		(16*4+$2c,a7)		;Set data input buffer to 0

	;There was a data fault (read or write) bus error
2$		btst.b	#6,(16*4+11,a7)	;RW (Read Write) Bit 6 of SSW
		bne.b		1$						;Read

	;There was a write data fault bus error
		moveq		#1,d0					;Write
		jmp		(a5)

	;There was a read data fault bus error
1$		moveq		#-1,d0				;Read
		jmp		(a5)

	;There was no data fault, singlestep
3$		moveq		#0,d0					;Singlestep
		jmp		(a5)

	;***
	;Stop handling the bus error
	;This routine restores all registers from stack (use StartBERRHandler to
	;put them there)
	;THIS FUNCTION MUST BE CALLED WITH BSR OR JSR!!!
	;***
BERRStopHandler:
		move.l	(a7)+,(15*4,a7)	;Move return address
		movem.l	(a7)+,d0-d7/a0-a6	;Restore all registers
		rts								;Return

	;***
	;Simulate a write
	;Only use this function from within the BERR handler
	;a1 = entry
	;***
BERRSimulateWrite:
		move.l	(a1),d0
		move.l	d0,d1					;Remember this entry contents
		andi.b	#~%111,d0			;Clear WP
		ori.b		#%001,d0				;Set to valid PAGE
		move.l	d0,(a1)

	mc68030								;@@@ Do we need to flush other things too?
		pflusha							;68030 only!!! Not for the 68020/68851
	mc68000

	;Simulate the write
		movea.l	(4+16*4+16,a7),a0	;Fault address
		move.l	(4+16*4+24,a7),d0	;Data to write
		btst.b	#4,(4+16*4+11,a7)	;One of the two SIZE bits
		beq.b		3$
	;byte
		move.b	d0,(a0)
		bra.b		5$

3$		btst.b	#5,(4+16*4+11,a7)	;One of the two SIZE bits
		beq.b		4$
	;word
		move.w	d0,(a0)
		bra.b		5$

	;long
4$		move.l	d0,(a0)

5$		move.l	d1,(a1)				;Restore entry contents
	mc68030								;@@@ Do we need to flush other things too?
		pflusha							;68030 only!!! Not for the 68020/68851
	mc68000
		rts

	;***
	;Simulate a read
	;Only use this function from within the BERR handler
	;a1 = entry
	;***
BERRSimulateRead:
		move.l	(a1),d0
		move.l	d0,d1					;Remember this entry contents
		andi.b	#~%11,d0
		ori.b		#%01,d0				;Set to valid PAGE
		move.l	d0,(a1)

	mc68030								;@@@ Do we need to flush other things too?
		pflusha							;68030 only!!! Not for the 68020/68851
	mc68000

	;Simulate the read
		movea.l	(4+16*4+16,a7),a0	;Fault address
		moveq		#0,d0
		btst.b	#4,(4+16*4+11,a7)	;One of the two SIZE bits
		beq.b		3$
	;byte
		move.b	(a0),d0
		bra.b		5$

3$		btst.b	#5,(4+16*4+11,a7)	;One of the two SIZE bits
		beq.b		4$
	;word
		move.w	(a0),d0
		bra.b		5$

	;long
4$		move.l	(a0),d0

5$		move.l	d0,(4+16*4+44,a7)	;Data input buffer
		move.l	d1,(a1)				;Restore entry contents
	mc68030								;@@@ Do we need to flush other things too?
		pflusha							;68030 only!!! Not for the 68020/68851
	mc68000
		rts

	;***
	;Recover from a bus error (write data fault only at this moment)
	;Only use this function from within the BERR handler
	;THIS FUNCTION MUST BE CALLED WITH BSR OR JSR!!!
	;a1 = entry
	;***
BERRRecover:
		movea.l	a1,a2					;Remember entry
		lea		(RememberInt,pc),a1
		move.w	($dff01c),(a1)+	;Remember interrupts (intenar)
	mc68030
		movec		vbr,a0
	mc68000
		lea		(9*4,a0),a0			;Trace vector
		move.l	(a0),(a1)+			;Remember original trace vector
		ori.w		#$8000,(16*4,a7)	;Enable trace mode

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
		rts

RememberInt:	dc.w	0
OrigTraceVec:	dc.l	0
RememberEntry:	dc.l	0
RememberVal:	dc.l	0

	;---
	;Trace routine to solve a bus error
	;---
TraceRoutine:
		movem.l	d0-d1/a0-a2/a6,-(a7)

		andi.w	#$3fff,(6*4,a7)	;Disable trace mode
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

;---------------------------------------------------------------------------
;All code needed to show registers
;---------------------------------------------------------------------------

	;***
	;Show all MMU registers (output is processor dependant)
	;a0 = MMU state
	;-> a0 = MMU state
	;***
ShowMMURegs:
		movem.l	a0/a2-a3/a6,-(a7)
		movea.l	a0,a3
	;Describe CRP
		lea		(MsgCRP,pc),a0
		lea		(mmu_RegCRP,a3),a2
		bsr		PrintRP
		bsr		DescribeRP
	;Describe SRP
		lea		(MsgSRP,pc),a0
		lea		(mmu_RegSRP,a3),a2
		bsr		PrintRP
		bsr		DescribeRP
	;Describe TC
		lea		(MsgTC,pc),a0
		lea		(mmu_RegTC,a3),a2
		bsr		PrintReg
		bsr		DescribeTC
	;Describe TT0
		lea		(MsgTT0,pc),a0
		lea		(mmu_RegTT0,a3),a2
		bsr		PrintReg
		bsr		DescribeTT
	;Describe TT1
		lea		(MsgTT1,pc),a0
		lea		(mmu_RegTT1,a3),a2
		bsr		PrintReg
		bsr		DescribeTT
		movem.l	(a7)+,a0/a2-a3/a6
		rts

	;---
	;Print a register (8 byte register)
	;a0 = pointer to string
	;a2 = pointer to rp
	;a3 = MMUState
	;---
PrintRP:
		PRINT
		move.l	(a2),d0
		movea.l	(mmu_PrintRealHexNL,a3),a0
		jsr		(a0)
		moveq		#1,d0
		bsr		Print3Spaces
		move.l	(4,a2),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jmp		(a0)

	;---
	;Print a register (4 byte register)
	;a0 = pointer to string
	;a2 = pointer to reg
	;a3 = MMUState
	;---
PrintReg:
		PRINT
		move.l	(a2),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jmp		(a0)

	;---
	;Print three spaces
	;---
Print3S:
		moveq		#1,d0
	;Fall through

	;---
	;Print three spaces
	;d0 = number of times to print 3 spaces
	;---
Print3Spaces:
		movem.l	d0/a0,-(a7)
		lea		(Spaces,pc),a0
		bra.b		2$
1$		PRINT
2$		dbra		d0,1$
		movem.l	(a7)+,d0/a0
		rts

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

	;---
	;Subroutine: describe a root pointer
	;a2 = ptr to crp or srp
	;a3 = MMU state
	;---
DescribeRP:
		move.w	(a2)+,d2
	;L/U bit
		move.l	a2,-(a7)
		lea		(TestBitTableRP,pc),a2
		bsr		TestBit
		movea.l	(a7)+,a2
	;LIMIT
		andi.w	#$7fff,d2
		lea		(MsgLIMITis,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)
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
		movea.l	(mmu_PrintRealHex,a3),a0
		jmp		(a0)

	;---
	;Subroutine: describe a translation control register
	;a2 = ptr to tc
	;a3 = MMU state
	;---
DescribeTC:
		move.w	(a2)+,d2

		move.l	a2,-(a7)
		lea		(TestBitTableTC,pc),a2
		moveq		#2,d3					;Loop 3 times
1$		bsr		TestBit
		dbra		d3,1$
		movea.l	(a7)+,a2

	;System page size
		lea		(MsgSystemPage,pc),a0
		PRINT
		moveq		#0,d0					;Clear for later
		move.w	(mmu_PageSize,a3),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)
	;Initial shift
		lea		(MsgInitShift,pc),a0
		PRINT
		moveq		#0,d0
		move.w	(mmu_ISS,a3),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)
	;TIA,TIB,TIC,TID
		lea		(MsgTIA,pc),a0
		PRINT
		moveq		#0,d0
		move.w	(mmu_TIA,a3),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)

		lea		(MsgTIB,pc),a0
		PRINT
		moveq		#0,d0
		move.w	(mmu_TIB,a3),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)

		lea		(MsgTIC,pc),a0
		PRINT
		moveq		#0,d0
		move.w	(mmu_TIC,a3),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)

		lea		(MsgTID,pc),a0
		PRINT
		moveq		#0,d0
		move.w	(mmu_TID,a3),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jmp		(a0)

	;---
	;Subroutine: describe a TTx register
	;This routine is only for the 68020 or 68030
	;a2 = ptr to TTx
	;a3 = MMU state
	;---
DescribeTT:
		move.w	(a2)+,d2
		lea		(MsgLogABase,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		lsr.w		#8,d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)
		lea		(MsgLogAMask,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#255,d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)

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
		movea.l	(mmu_PrintRealHex,a3),a0
		jsr		(a0)
		lea		(MsgFCMask,pc),a0
		PRINT
		moveq		#0,d0
		move.w	d2,d0
		andi.w	#$0007,d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jmp		(a0)

	;---
	;Subroutine to test a bit and print information
	;a2 = pointer in table to 'Bit'.w, 'MsgInfo' and 'MsgNo'
	;-> a2 = pointer to next entry in table
	;---
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

RegTableSREG:
		dc.l		MsgMSP,mmu_RegMSP
		dc.l		MsgISP,mmu_RegISP
		dc.l		MsgUSP,mmu_RegUSP
		dc.l		MsgSFC,mmu_RegSFC
		dc.l		MsgDFC,mmu_RegDFC
		dc.l		MsgVBR,mmu_RegVBR
		dc.l		MsgCAAR,mmu_RegCAAR
		dc.l		MsgCACR,mmu_RegCACR

	;***
	;Show all processor specific registers (MMU registers excluded)
	;a0 = MMU state
	;-> a0 = MMU state
	;***
ShowSpecRegs:
		movem.l	d2-d3/a0/a2-a3/a5-a6,-(a7)
		movea.l	a0,a3					;Remember MMU state

		lea		(RegTableSREG,pc),a2
		moveq		#7,d2					;Loop 8 times
1$		bsr		PReg
		dbra		d2,1$

		lea		(mmu_RegCACR,a3),a2
		bsr		DescribeCACR
		movem.l	(a7)+,d2-d3/a0/a2-a3/a5-a6
		rts

	;---
	;Little subroutine to print a register
	;a2 = pointer in table to 'MsgXXX' and 'RegXXX'
	;a3 = MMU state
	;-> a2 = pointer to next entry in table
	;---
PReg:
		movea.l	(a2)+,a0
		PRINT
		move.l	(a2)+,d0
		move.l	(0,a3,d0.l),d0
		movea.l	(mmu_PrintRealHex,a3),a0
		jmp		(a0)

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

	;---
	;Subroutine: describe a CACR register
	;a2 = ptr to CACR
	;a3 = MMU state
	;---
DescribeCACR:
		move.w	(a2)+,d2
		move.w	(a2)+,d2

		lea		(TestBitTableCACR,pc),a2
		moveq		#10,d3				;Loop 11 times
1$		bsr		TestBit
		dbra		d3,1$

		rts

;---------------------------------------------------------------------------
;Data
;---------------------------------------------------------------------------

	;Bit table
YesNoMessages:
		dc.l		MsgNotSet,MsgSet
		dc.l		MsgDisabled,MsgEnabled
		dc.l		MsgNo,MsgYes

	;DT types table
EntryStrings:
		dc.l		StrInvalid
		dc.l		StrPage
		dc.l		Str4Byte
		dc.l		Str8Byte

	;DT types
StrInvalid:		dc.b	"INV",0
StrPage:			dc.b	"PAGE",0
Str4Byte:		dc.b	"4 BYTE",0
Str8Byte:		dc.b	"8 BYTE",0

	;MMU register names
MsgCRP:			dc.b	"CRP  : ",0
MsgSRP:			dc.b	"SRP  : ",0
MsgTC:			dc.b	"TC   : ",0
MsgTT0:			dc.b	"TT0  : ",0
MsgTT1:			dc.b	"TT1  : ",0

	;68030 register names
MsgMSP:				dc.b	"MSP  : ",0
MsgISP:				dc.b	"ISP  : ",0
MsgUSP:				dc.b	"USP  : ",0
MsgSFC:				dc.b	"SFC  : ",0
MsgDFC:				dc.b	"DFC  : ",0
MsgVBR:				dc.b	"VBR  : ",0
MsgCACR:				dc.b	"CACR : ",0
MsgCAAR:				dc.b	"CAAR : ",0

	;Bit values for bit table
MsgNotSet:		dc.b	" : not set",10,0
MsgSet:			dc.b	" : set",10,0
MsgDisabled:	dc.b	" : disabled",10,0
MsgEnabled:		dc.b	" : enabled",10,0
MsgNo:			dc.b	" : no",10,0
MsgYes:			dc.b	" : yes",10,0

	;TTx bit messages
MsgTTx:			dc.b	"TT register",0
MsgCI:			dc.b	"Cache Inhibit",0
MsgRW:			dc.b	"R/W",0
MsgRWM:			dc.b	"RWM",0

	;TC bit messages
MsgE:				dc.b	"Address translation",0
MsgSRE:			dc.b	"Supervisor Root Pointer (SRP)",0
MsgFCL:			dc.b	"Function Code Lookup (FCL)",0

	;RP bit messages
MsgLU:			dc.b	"L/U bit",0

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

	;For description of RP
MsgLIMITis:		dc.b	"   LIMIT = ",0
MsgDT:			dc.b	"   DT    = ",0
MsgValid8:		dc.b	"Valid 8 byte",10,0
MsgValid4:		dc.b	"Valid 4 byte",10,0
MsgInvalid:		dc.b	"Invalid",10,0
MsgPageDesc:	dc.b	"Page descriptor",10,0
MsgTableA:		dc.b	"   Table address = ",0

	;For description of TC
MsgSystemPage:	dc.b	"   System page size    = ",0
MsgInitShift:	dc.b	"   Initial shift       = ",0
MsgTIA:			dc.b	"   Table Index A (TIA) = ",0
MsgTIB:			dc.b	"   Table Index B (TIB) = ",0
MsgTIC:			dc.b	"   Table Index C (TIC) = ",0
MsgTID:			dc.b	"   Table Index D (TID) = ",0

	;For description of TTx
MsgLogABase:	dc.b	"   Log Address Base = ",0
MsgLogAMask:	dc.b	"   Log Address Mask = ",0
MsgFCBase:		dc.b	"   FC value for TT block = ",0
MsgFCMask:		dc.b	"   FC bits to be ignored = ",0

	;For MMU tree
MsgPhysicalTree:	dc.b	"  -> ",0
MsgBytesTree:		dc.b	" # ",0
MsgLog:				dc.b	"Log: ",0

	;For Print3Spaces
Spaces:			dc.b	"   ",0


	END
