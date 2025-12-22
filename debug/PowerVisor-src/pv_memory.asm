*****
****
***			M E M O R Y   routines for   P O W E R V I S O R
**
*				Version 1.40
**				Fri Sep 25 15:58:35 1992
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

			INCLUDE	"pv.debug.i"
			INCLUDE	"pv.general.i"
			INCLUDE	"pv.eval.i"
			INCLUDE	"pv.list.i"
			INCLUDE	"pv.memory.i"

			INCLUDE	"pv.errors.i"

	XDEF		MemoryConstructor,MemoryDestructor
	XDEF		RoutClear,RoutMemory,RoutMemTask,RoutCopy,RoutFill,RoutSearch
	XDEF		RoutNext,FuncAlloc,FuncFree,FuncGetSize,FuncReAlloc,FlashRed
	XDEF		StoreRC,AddAutoClear,ClearAutoClear,AddString,RemoveMem
	XDEF		InsertMem,FreeBlock,VirtualPrint
	XDEF		PrintVirtualBuf,ClearVirtual,AllocClear,ReAllocMem
	XDEF		VPrint,MemoryPointer,FuncLastMem,FuncLastFound
	XDEF		MakeNodeInt,AllocStringInt,AllocBlockInt,RoutCleanup
	XDEF		RoutShowAlloc,FuncIsAlloc,RoutView
	XDEF		RoutAddTag,RoutRemTag,RoutTags,RoutCheckTag
	XDEF		RoutUnAsm,DefaultLengthUA,DisasmSmart,DisasmBreak,CommonUA
	XDEF		SmartUnAsm,RoutLoadTags,RoutSaveTags
	XDEF		AddPointerAlloc,RoutClearTags,RoutUseTag,FuncTagList
	XDEF		RoutTg,AppendMem,MemoryBase
	XDEF		RemPointerAlloc,AddPointerResident,RemPointerResident
	XDEF		ResidentPtr,ShrinkBlock,FuncLastBytes,FuncLastLines
	XDEF		ViewPrintLine,BinarySearch,ApplyCommandOnTags
	XDEF		CheckTagAddress,UseTag,TagNum,CheckTagListRange
	XDEF		_CheckStruct,BlockSize,ReAllocMemBlock,RoutPVMem
	XDEF		AllocMem,FreeMem,ReAlloc,CompactRegion

	;eval
	XREF		ClearString,LongToHex,ByteToHex,MakePrint
	XREF		GetStringE,GetStringPer,GetNextByteE,VarStorage,Upper,WordToHex
	XREF		LongToDec,ZeroString,GetRestLinePer,SkipSpace
	;main
	XREF		Storage,LastCmd,DosBase,ExecAlias
	XREF		Remind,ErrorHandler,FastFPrint,CheckModeBit
	XREF		Forbid,Permit,Disable,Enable,LastError
	XREF		CallDisasm
	;screen
	XREF		Print,PrintRealHexNL,PrintChar,SpecialPrint
	XREF		PrintLine,NewLine
	;general
	XREF		FDFiles
	;debug
	XREF		SearchBreakPoint,CurrentDebug,GetSymbolStr
	;list
	XREF		ListItem,SetList,FormatMemoryL,StructDefs,ResetList
	XREF		PrintBitField
	;file
	XREF		FOpen,FRead,FClose,OpenDos

;---------------------------------------------------------------------------
;Constants
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;Code
;---------------------------------------------------------------------------

	;***
	;Constructor: init everything for memory
	;-> d0 = 0 if success (flags) else errorcode
	;***
MemoryConstructor:
		lea		(AllAllocSize,pc),a0
		moveq		#4,d0
		bsr		ReAllocMem
		bne.b		1$
2$		moveq		#ERROR_MEMORY,d0
		rts
1$		movea.l	d0,a0
		clr.l		(a0)
		lea		(ResidentSize,pc),a0
		moveq		#4,d0
		bsr		ReAllocMem
		beq.b		2$
		movea.l	d0,a0
		clr.l		(a0)
		moveq		#0,d0					;Success
		rts

	;***
	;Destructor: remove everything for memory
	;***
MemoryDestructor:
*		moveq		#15,d7				;Loop 16 times
*2$		move.l	d7,d0
*		bsr		UseTag
*		bsr		ClearTags
*		dbra		d7,2$
*
*		bsr.b		RoutCleanup
*		lea		(AllAllocSize,pc),a0
*		moveq		#0,d0
*		bsr		ReAllocMem

		bsr		CleanSegments

*		lea		(ResidentSize,pc),a0
*		moveq		#0,d0
*		bsr		ReAllocMem
*		move.l	(MemSearch,pc),d0
*		beq.b		1$
*		movea.l	d0,a0
*		bsr		FreeBlock
*1$		bsr		ClearVirtual
		movea.l	(FirstRegion,pc),a0
		bra		FreeRegions

	;***
	;Command: clean all memory allocated by user
	;***
RoutCleanup:
		movea.l	(AllAllocPtr,pc),a4
1$		move.l	(a4)+,d0
		beq.b		2$
		movea.l	d0,a0
		bsr		FreeBlock
		bra.b		1$
2$		lea		(AllAllocSize,pc),a0
		moveq		#4,d0
		bsr		ReAllocMem
		movea.l	d0,a0
		clr.l		(a0)
		rts

	;***
	;Cleanup all resident segments
	;***
CleanSegments:
		movea.l	(ResidentPtr,pc),a4
1$		move.l	(a4)+,d0
		beq.b		2$
		move.l	d0,d1
		subq.l	#4,d1
		lsr.l		#2,d1
		CALLDOS	UnLoadSeg
		bra.b		1$
2$		lea		(ResidentSize,pc),a0
		moveq		#4,d0
		bsr		ReAllocMem
		movea.l	d0,a0
		clr.l		(a0)
		rts


;==================================================================================
;
; INTERNAL POWERVISOR MEMORY ALLOCATION SYSTEM
;
; This memory system uses more or less the same format as that used by the
; AmigaDOS 2.0 Allocate/Deallocate system. I don't use these two functions
; since I need to know the chunk size (8 bytes). In AmigaDOS 2.0 this is
; equal to 8 but I don't think this is guaranteed to be always the case.
; The reason I need to know the chunk size is that I have implemented a
; Reallocate function.
;
;==================================================================================

	;***
	;Command: print all memory regions and the amount of free space left in them
	;***
RoutPVMem:
		movea.l	(FirstRegion,pc),a2

	;***
	;Print all regions in a region list
	;a2 = pointer to first region
	;***
PrintRegions:
		moveq		#0,d2					;Total free size
		moveq		#0,d3					;Total size
		moveq		#0,d4					;Total fragmentation
1$		move.l	a2,d0
		beq.b		2$

	;Count the fragmentation
		moveq		#0,d0
		lea		(pvmh_First,a2),a0
3$		move.l	(a0),d1
		beq.b		4$
		movea.l	d1,a0
		addq.l	#1,d0
		bra.b		3$

4$		add.l		d0,d4
		move.l	d0,-(a7)
		move.l	(pvmh_Size,a2),d0
		add.l		d0,d3
		move.l	d0,-(a7)
		move.l	(pvmh_Free,a2),d0
		add.l		d0,d2
		move.l	d0,-(a7)
		move.l	a2,-(a7)
		bsr.b		PrintItPREG

		movea.l	(pvmh_Next,a2),a2
		bra.b		1$

	;The end, print total
2$		bsr		PrintLine
		move.l	d4,-(a7)
		move.l	d3,-(a7)
		move.l	d2,-(a7)
		pea		(0).w
		bsr.b		PrintItPREG			;MUST be bsr!
		rts

	;Print it
PrintItPREG:
		movea.l	(a7)+,a3				;Get return address
		move.l	(Storage),d0
		movea.l	a7,a1
		lea		(FormatRegion,pc),a0
		bsr		FastFPrint
		lea		(16,a7),a7
		bsr		ViewPrintLine
		jmp		(a3)					;Return

	;***
	;Compactor
	;This function selects a region and starts compacting it.
	;'CompactRegion' will only compact one region at a time. Because of this
	;we have 'gradual compaction'. Compacting may cause a region to be removed.
	;If there is only one region this function does nothing
	;***
CompactRegion:
		lea		(FirstRegion,pc),a0
		move.l	(a0),d0
		beq.b		2$						;No regions, do nothing
		movea.l	d0,a1
		tst.l		(a1)
		beq.b		2$						;Only one region, do nothing

1$		move.l	(a0),d0
		beq.b		2$
		movea.l	d0,a0
		move.l	(pvmh_Size,a0),d0
		lea		(FirstRegion,pc),a1
		cmp.l		(pvmh_Free,a0),d0
		beq		RemoveRegion		;Region is empty, we remove it

		bra.b		1$

2$		rts

	;***
	;Allocate some memory
	;This function uses the general PowerVisor memory allocater (using
	;Allocate). Memory is organized as a double linked list of large
	;regions. If a new memory block does not fit in any of the existing
	;regions a new region is created. Normally regions are always the
	;same size (REGIONSIZE). Multiple allocations may fit in one region.
	;If an allocation is too large for a single region (larger than REGIONSIZE),
	;another larger region is created. The size of this region will always be
	;a multiple of the normal region size (REGIONSIZE). These extra large
	;regions will also be used for smaller allocations after they have been
	;allocated.
	;Each region is represented by a PowerVisor memory header.
	;Note that the list with all regions is sorted with the smallest region
	;first. This means that smaller allocations will go to smaller regions
	;and vice versa
	;d0 = size in bytes
	;d1 = attributes (MEMF_CHIP, MEMF_CLEAR, ...)
	;-> d0 = pointer to allocated memory or 0 (flags)
	;***
AllocMem:
		lea		(FirstRegion,pc),a0

	;a0 = pointer to pointer to first region
AllocMemR:
		tst.l		d0
		beq.b		1$

		movem.l	d2-d4/a2-a3,-(a7)
		move.l	d0,d2					;Remember size
		move.l	d1,d3					;Remember attributes
		movea.l	a0,a2
		movea.l	a0,a3					;Remember pointer to pointer to first region
		tst.l		(a2)
		bne.b		2$

	;There is no space in the existing regions (or there are no regions yet)
	;Allocate a new region
	;d2 = size to allocate
5$		move.l	d3,d1					;Get attributes
		move.l	d2,d0
		movea.l	a3,a0
		bsr		CreateRegion
		beq.b		3$
		movea.l	d0,a2
		bra.b		6$

	;There are already regions
	;Scan all the regions to see if there is place somewhere
2$		move.l	d3,d1
		and.l		#MEMF_CHIP,d1		;Mask out all other flags
8$		move.l	(a2),d0				;Get pointer to first (or next) region
		beq.b		5$						;There is no room in any region, create a new one
		movea.l	d0,a2

	;Check attributes
		cmp.l		(pvmh_Attributes,a2),d1
		bgt.b		8$						;If d1 == Attrib
											;			ok, because
											;			Attrib == 0 and d1 == 0
											;				or
											;			Attrib == CHIP and d1 == CHIP
											;else if d1 < Attrib
											;			ok, because
											;			Attrib == CHIP and d1 == 0
											;else if d1 > Attrib
											;			not ok, jump 8$

		cmp.l		(pvmh_Free,a2),d2
		bhi.b		8$

	;a2 points to a region with enough free space to hold the new block
	;It is possible that this space is too fragmented to use, so it may happen
	;that we have to go back to 2$ to continue scanning the region list
	;or
	;There is a new region created
	;Perform the allocation in this new region
	;a2 = pointer to new PV memory header
6$		movea.l	a2,a0
		move.l	d2,d0
		bsr		Allocate
		beq.b		2$						;Go back, space is too fragmented in this region

	;Success in allocation
	;Check if we must clear this memory
		btst		#MEMB_CLEAR,d3
		beq.b		3$
	;Yes, clear
		movea.l	d0,a0
		subq.l	#1,d2					;Round down to multiple of 8 ('and' is not
											;needed since we are going to shift the lower
											;bits away anyway)
		lsr.l		#3,d2					;Number of 8 bytes chunks minus one
		move.w	d2,d3
		swap		d2
		moveq		#0,d1
9$		move.l	d1,(a0)+
		move.l	d1,(a0)+
		dbra		d3,9$
		dbra		d2,9$

3$		movem.l	(a7)+,d2-d4/a2-a3
		tst.l		d0

1$		rts

	;***
	;Create a new region. The region is inserted in the right place in the
	;list (the list is sorted on the size of the regions, smallest regions
	;first)
	;a0 = pointer to pointer to first region
	;d0 = size that should fit in region
	;d1 = attributes for allocation
	;-> d0 = new region or NULL if not enough memory (flags)
	;***
CreateRegion:
		movem.l	a2-a3/d2,-(a7)
		movea.l	a0,a2					;Remember pointer to pointer to first region
		movea.l	a0,a3					;Remember pointer to pointer to first region

		add.l		#REGIONSIZE-1,d0
		and.l		#-REGIONSIZE,d0
		move.l	d0,d2					;Remember size
		add.l		#pvmh_SIZE,d0
		CALLEXEC	AllocMem				;Allocate new PV memory header and region
		tst.l		d0
		beq.b		1$
		movea.l	d0,a1					;Pointer to PV memory header and region

	;Search the first region that is larger than this one
3$		move.l	(a2),d0
		beq.b		2$
		movea.l	d0,a2
		cmp.l		(pvmh_Size,a2),d2
		bge.b		3$

	;a2 points to a region that is larger than this one
	;we must link the new region before this one
		move.l	a2,(pvmh_Next,a1)	;new->next = larger
		move.l	(pvmh_Prev,a2),d0
		move.l	d0,(pvmh_Prev,a1)	;new->prev = larger->prev
		beq.b		4$
	;There is a predecessor
		movea.l	d0,a0
		move.l	a1,(pvmh_Next,a0)	;larger->prev->next = new
4$		move.l	a1,(pvmh_Prev,a2)	;larger->prev = new
		bra.b		6$

	;No such region found, simply link this region to the end of the chain
	;a2 points to the end of the chain
2$		clr.l		(pvmh_Next,a1)		;new->next = NULL
		cmpa.l	a2,a3
		beq.b		5$
	;There was already another element in the chain
		move.l	a2,(pvmh_Prev,a1)	;new->prev = endchain
5$		move.l	a1,(a2)				;endchain->next = new or firstregion = new

	;The new region is linked in, now fill in some characteristics
6$		movea.l	a1,a2
		CALLEXEC	TypeOfMem
		and.l		#MEMF_CHIP,d0
		move.l	d0,(pvmh_Attributes,a2)
		movea.l	a2,a0					;a0 points to PV memory header
		lea		(pvmh_SIZE,a0),a0	;a0 points to region
		move.l	a0,(pvmh_First,a2)
		move.l	a0,(pvmh_Lower,a2)
		move.l	d2,(pvmh_Size,a2)
		move.l	d2,(pvmh_Free,a2)
		clr.l		(a0)+					;Initialize first 8 bytes of region
		move.l	d2,(a0)

		move.l	a2,d0

1$		movem.l	(a7)+,a2-a3/d2
		rts

	;***
	;Free some memory
	;This function uses the general PowerVisor memory allocater (using
	;Deallocate).
	;If a region becomes empty after deallocation, this function will
	;remove the region
	;a1 = pointer to memory
	;d0 = size to free
	;***
FreeMem:
		lea		(FirstRegion,pc),a0

	;a0 = pointer to pointer to first region
FreeMemR:
		tst.l		d0
		beq.b		1$

		move.l	a0,-(a7)				;Remember pointer to pointer to first region
	;Search where the allocated memory belongs
2$		move.l	(a0),d1
		beq.b		3$						;Serious error
		movea.l	d1,a0					;a2 = pointer to PV memory header
		cmpa.l	(pvmh_Lower,a0),a1
		blo.b		2$
		move.l	(pvmh_Lower,a0),d1
		add.l		(pvmh_Size,a0),d1
		cmpa.l	d1,a1
		bhs.b		2$

	;Found!
	;a0 points to PV memory header containing this block
		bsr		Deallocate
		move.l	(pvmh_Free,a0),d0
		cmp.l		(pvmh_Size,a0),d0
		movea.l	(a7)+,a1				;Restore pointer to pointer to first region (flags)
		beq.b		RemoveRegion
1$		rts

	;Memory does not exist
3$		illegal

	;***
	;Remove region
	;a0 = region
	;a1 = pointer to pointer to first region
	;***
RemoveRegion:
		move.l	(pvmh_Prev,a0),d0
		beq.b		1$
	;There is a previous region
		movea.l	d0,a1
1$		move.l	(a0),d0
		move.l	d0,(a1)				;old->prev->next = old->next
											;or FirstRegion = old->next
		beq.b		2$
	;There is a next region
		movea.l	d0,a1
		move.l	(pvmh_Prev,a0),(pvmh_Prev,a1)

	;Region is unlinked
2$		movea.l	a0,a1
		moveq		#pvmh_SIZE,d0
		add.l		(pvmh_Size,a1),d0
		CALLEXEC	FreeMem
		rts

	;***
	;Reallocate some memory
	;This function uses the general PowerVisor memory allocater (using
	;Reallocate).
	;If a region becomes empty after reallocation, this function will
	;remove the region
	;a1 = pointer to memory
	;d0 = old size (> 0)
	;d1 = new size (if 0, the block is simply deallocated)
	;d2 = attributes for new block (only used if block is moved to other
	;		region)
	;-> d0 = pointer to block or 0 (flags)
	;			Note that the old block is not freed when there is not enough
	;			memory to make the block larger
	;			0 if d1 was 0 (deallocation)
	;***
ReAlloc:
		lea		(FirstRegion,pc),a0

	;a0 = pointer to pointer to first region
ReAllocR:
		tst.l		d0
		beq.b		1$

	;Search where the allocated memory belongs
		movem.l	d3-d4/a2-a4,-(a7)
		movea.l	a0,a4					;Remember pointer to pointer to first region

2$		move.l	(a0),d4
		beq.b		3$						;Serious error
		movea.l	d4,a0					;a2 = pointer to PV memory header
		cmpa.l	(pvmh_Lower,a0),a1
		blo.b		2$
		move.l	(pvmh_Lower,a0),d4
		add.l		(pvmh_Size,a0),d4
		cmpa.l	d4,a1
		bhs.b		2$

	;Found!
	;a0 points to PV memory header containing this region
		movea.l	a1,a2					;Remember pointer to memory
		move.l	d0,d4					;Remember old size
		move.l	d1,d3					;Remember new size
		bsr		Reallocate
		bne.b		3$

		moveq		#0,d0					;Return value is 0
		tst.l		d3
		beq.b		3$						;If null, we must not move block

	;The block can not be reallocated on its current position
		move.l	d3,d0					;Allocate new size
		move.l	d2,d1					;Attributes
		movea.l	a4,a0
		bsr		AllocMemR
		beq.b		3$						;There is simply not enough room
		movea.l	d0,a3					;Remember pointer to new block

		movea.l	a2,a0					;Source (old block)
		movea.l	a3,a1					;Dest (new block)

	;Compute minimum of the two sizes
		move.l	d4,d0
		cmp.l		d3,d0
		bls.b		4$
		move.l	d3,d0

4$		CALLEXEC	CopyMem

	;Free other block
		movea.l	a2,a1
		move.l	d4,d0
		movea.l	a4,a0
		bsr		FreeMemR
		move.l	a3,d0					;Pointer to new block

3$		movem.l	(a7)+,d3-d4/a2-a4	;For flags

1$		rts

	;***
	;Free all memory regions (PV memory headers)
	;a0 = pointer to first PV memory header to free (may be 0)
	;***
FreeRegions:
		move.l	a2,-(a7)
		movea.l	a0,a2

1$		move.l	a2,d0
		beq.b		2$
		movea.l	a2,a1
		movea.l	(pvmh_Next,a2),a2
		moveq		#pvmh_SIZE,d0
		add.l		(pvmh_Size,a1),d0
		CALLEXEC	FreeMem
		bra.b		1$

2$		movea.l	(a7)+,a2
		rts

	;***
	;Allocate some memory in a PowerVisor memory header
	;This function behaves much like the Exec Allocate function. It is in
	;fact an almost exact copy of that function. The reason that I don't
	;use Allocate is mentioned above (chunk size equal to 8)
	;a0 = PowerVisor memory header (almost the same as an Exec memory header)
	;d0 = size in bytes
	;-> d0 = pointer to allocated block or 0 (flags)
	;***
Allocate:
		cmp.l		(pvmh_Free,a0),d0
		bhi.b		1$
		tst.l		d0
		beq.b		2$
		move.l	a2,-(a7)
		addq.l	#7,d0
		and.w		#$fff8,d0			;Round up to multiple of 8
		lea		(pvmh_First,a0),a2

	;Search first free block big enough to hold new block
4$		movea.l	(a2),a1				;Pointer to first free block
		move.l	a1,d1
		beq.b		3$						;Not free
		cmp.l		(4,a1),d0			;Compare with size of this free block
		bls.b		6$

	;Not big enough
		movea.l	(a1),a2				;Get next free block
		move.l	a2,d1
		beq.b		3$						;No free blocks left
		cmp.l		(4,a2),d0
		bhi.b		4$						;Size of block too small
		exg		a1,a2

	;Block is big enough
	;a1 = pointer to this block
	;a2 = pointer to previous block
6$		beq.b		5$
		move.l	a3,-(a7)
		lea		(0,a1,d0.l),a3		;a3 points to new start of this free block
		move.l	a3,(a2)				;Update pointer in previous free block
		move.l	(a1),(a3)+			;Move pointer to next free block to new free block
		move.l	(4,a1),d1			;Get old size of this free block
		sub.l		d0,d1					;New size
		move.l	d1,(a3)				;Set size of new free block
		movea.l	(a7)+,a3
7$		sub.l		d0,(pvmh_Free,a0)	;Change the amount of free memory in memory header
		movea.l	(a7)+,a2
		move.l	a1,d0
		rts

	;Block is just the right size
	;a1 = pointer to this block
	;a2 = pointer to previous block
5$		move.l	(a1),(a2)			;Update pointer in previous free block to next free block
		bra.b		7$

3$		movea.l	(a7)+,a2
1$		moveq.l	#0,d0
2$		rts

	;***
	;Deallocate some memory in a PowerVisor memory header
	;This function behaves much like the Exec Deallocate function. It is in
	;fact an almost exact copy of that function. The reason that I don't
	;use Deallocate is mentioned above (chunk size equal to 8)
	;a0 = PowerVisor memory header (almost the same as an Exec memory header)
	;a1 = pointer to block to free
	;d0 = size in bytes
	;-> d0 = 0 (flags)
	;-> a0 = PowerVisor memory header (unchanged)
	;***
Deallocate:
		tst.l		d0
		beq.b		1$
		movem.l	d3/a2,-(a7)
		move.l	a1,d1					;Pointer to memoryblock
		moveq.l	#-8,d3
		and.l		d3,d1					;Round down to multiple of 8
		exg		d1,a1					;a1 = pointer to rounded memoryblock
		sub.l		a1,d1					;d1 = 0..7
		add.l		d1,d0					;Update size
		addq.l	#7,d0
		and.l		d3,d0					;Round size up to multiple of 8
		beq.b		2$
		lea		(pvmh_First,a0),a2
		move.l	(a2),d3				;Get pointer to first free block
		beq.b		3$						;No free blocks

	;There are free blocks
	;d3 = pointer to this free block
	;a1 = pointer to memory to free
	;a2 = pointer to previous free block (or pointer in memory header (MH_First))
	;Scan all the free blocks to find the first free block just after
	;the block we want to free
5$		cmpa.l	d3,a1
		bls.b		4$

	;The block we want to free is after this free block
		movea.l	d3,a2
		move.l	(a2),d3				;Get next free block
		bne.b		5$
	;No more free blocks
		bra.b		6$

	;The block we want to free is just before this free block
4$		beq.b		7$						;If it is equal there is something wrong

6$		moveq.l	#pvmh_First,d1
		add.l		a0,d1
		cmp.l		a2,d1
		beq.b		3$						;The block we want to free is before the first
											;free block
	;The block we want to free is after the first free block in the memory header
		move.l	(4,a2),d3			;Get size of previous free block
		add.l		a2,d3					;d3 points to first alloc block after prev free block
		cmp.l		a1,d3
		beq.b		8$						;This is the block we must free
		bhi.b		9$						;Something is wrong

	;The block we want to free is before the first free block
	;and/or
	;There is no free block just before the block we want to free
3$		move.l	(a2),(a1)			;Make a new free block and point to the next
											;free block
		move.l	a1,(a2)				;Let the previous free block (or memory header)
											;point to the new free block
		move.l	d0,(4,a1)			;Set the size of the new free block
		bra.b		10$

	;Free the allocated block just after the free block pointed to by a2
8$		add.l		d0,(4,a2)			;Just update the size of this free block
		movea.l	a2,a1

	;See if there is a free block following the current free block
	;containing the freed memory
10$	tst.l		(a1)
		beq.b		11$

	;Yes, there is
	;Join this free block and the next if this is necessary
		move.l	(4,a1),d3
		add.l		a1,d3					;d3 points after this free block
		cmp.l		(a1),d3
		bhi.b		9$						;Something is wrong
		bne.b		11$

	;Yes, we must join
		movea.l	(a1),a2				;Pointer to next free block in a2
		move.l	(a2),(a1)			;Point to next next free block
		move.l	(4,a2),d3
		add.l		d3,(4,a1)			;Update size of joined free blocks

11$	add.l		d0,(pvmh_Free,a0)

2$		movem.l	(a7)+,d3/a2
1$		moveq		#0,d0
		rts

	;Free twice
7$		illegal							;Force crash

	;Memory list corrupt
9$		illegal							;Force crash

	;***
	;Reallocate some memory in a PowerVisor memory header
	;Note that this function does NOT move the block if it doesn't fit
	;at the current position
	;a0 = PowerVisor memory header (almost the same as an Exec memory header)
	;a1 = pointer to block to reallocate
	;d0 = size in bytes (must be > 0)
	;d1 = new size in bytes (if 0, this function is the same as Deallocate)
	;-> d0 = pointer to memory block or 0 (flags)
	;			if the result is 0, the old memory block is NOT freed
	;			Note that this result is undefined if the new size is 0
	;-> a0 = pointer to PowerVisor memory header (unchanged)
	;***
Reallocate:
		tst.l		d1
		beq		Deallocate

		movem.l	d2-d3/a0/a2,-(a7)
		move.l	a1,d2					;Pointer to memoryblock
		moveq.l	#-8,d3
		and.l		d3,d2					;Round down to multiple of 8
		exg		d2,a1					;a1 = pointer to rounded memoryblock
		sub.l		a1,d2					;d2 = 0..7
		add.l		d2,d0					;Update old size
		addq.l	#7,d0
		and.l		d3,d0					;Round old size up to multiple of 8
		addq.l	#7,d1
		and.l		d3,d1					;Round new size up to multiple of 8

		cmp.l		d0,d1
		bls.b		1$

	;New size is greater than the old size
		lea		(pvmh_First,a0),a2
		move.l	(a2),d3				;Get pointer to first free block
		beq.b		10$					;No free blocks, no space to grow the block

	;There are free blocks
	;d3 = pointer to first free block
	;a1 = pointer to memory to grow
	;a2 = pointer to memory header (pvmh_First)
	;Scan all the free blocks to find the first free block just after
	;the block we want to grow
		move.l	a1,d2
		add.l		d0,d2					;d2 points just after the allocated block

11$	cmp.l		d3,d2
		bls.b		12$

	;The block we want to grow is after this free block
		movea.l	d3,a2
		move.l	(a2),d3				;Get next free block
		bne.b		11$
	;No more free blocks, there is no room to grow the free block
		bra.b		10$

	;We have found a free block after this free block
	;We check if this free block is just after the allocated block so
	;that we can use it to grow the allocated block
	;d3 = pointer to free block
	;a1 = pointer to memory to grow
	;d2 = pointer after old memory block
	;a2 = pointer to previous free block (or pointer in memory header (pvmh_First))
12$	bne.b		10$					;No room
	;There could be room to grow, check if the amount of free space is enough
		sub.l		d0,d1					;d1 contains needed amount of extra free space
		exg		a2,d3					;a2 = pointer to free block
		cmp.l		(4,a2),d1
		bhi.b		10$					;Not enough room
		beq.b		13$

	;There is more than enough room to fit the new block
	;a2 = pointer to free block that must be made smaller
	;d3 = pointer to previous free block
	;d1 = extra space
		sub.l		d1,(pvmh_Free,a0)
		movea.l	d3,a0					;Pointer to previous free block
		add.l		d1,(a0)				;Increment previous pointer to this free block
		move.l	(a2),(0,a2,d1.l)	;Shift pointer to next free block
		move.l	(4,a2),d0
		sub.l		d1,d0
		move.l	d0,(4,a2,d1.l)		;Update size of new free block
		bra.b		4$

	;There is just enough room to fit the new block
	;a2 = pointer to free block that must be completely removed
	;d3 = pointer to previous free block
	;d1 = extra space
13$	sub.l		d1,(pvmh_Free,a0)
		movea.l	d3,a0					;Pointer to previous free block
		move.l	(a2),(a0)
		bra.b		4$

10$	suba.l	a1,a1					;Failure

	;Do nothing, sizes are equal
	;or
	;New size is less than old size and we have already done the
	;shrinking
4$		movem.l	(a7)+,d2-d3/a0/a2
		move.l	a1,d0
		rts

	;New size is less or equal than the old size
1$		beq.b		4$

	;New size is less than the old size
2$		lea		(pvmh_First,a0),a2
		move.l	(a2),d3				;Get pointer to first free block
		beq.b		3$						;No free blocks

	;There are free blocks
	;d3 = pointer to free block
	;a1 = pointer to memory to shrink
	;a2 = pointer to previous free block (or pointer in memory header (pvmh_First))
	;Scan all the free blocks to find the first free block just after
	;the block we want to shrink
5$		cmpa.l	d3,a1
		bls.b		8$

	;The block we want to free is after this free block
		movea.l	d3,a2
		move.l	(a2),d3				;Get next free block
		bne.b		5$
	;No more free blocks
		bra.b		3$

	;The block we want to shrink is just before this free block
8$		beq.b		7$						;If it is equal there is something wrong

	;Here we create a new free block
	;If possible we join this new free block with the next one
	;d3 = pointer to next free block (or NULL)
	;a2 = pointer to previous free block (or pointer in PV memory header)
	;a1 = pointer to memory to shrink
3$		move.l	a1,d2
		add.l		d1,d2					;d2 points to new free block
		move.l	d2,(a2)				;Update previous pointer to new free block
		movea.l	d2,a2					;a2 points to new free block
		move.l	d3,(a2)				;Point to next free block
		sub.l		d1,d0					;d0 = size of new free block
		move.l	d0,(4,a2)			;Set size of new free block
		add.l		d0,(pvmh_Free,a0)
		lea		(0,a2,d0.l),a0		;a0 points after new free block
		cmp.l		a0,d3
		bne.b		4$
	;Join the two free blocks
		move.l	(a0)+,(a2)+			;Update pointer to next free block
		move.l	(a2),d0
		add.l		(a0),d0
		move.l	d0,(a2)				;Update size of new free block
		bra.b		4$

	;Free twice
7$		illegal							;Force crash

	;Memory list corrupt
9$		illegal							;Force crash

;==================================================================================
;
; END INTERNAL POWERVISOR MEMORY ALLOCATION SYSTEM
;
;==================================================================================

	;***
	;Command: show all allocated memory (with 'alloc')
	;***
RoutShowAlloc:
		movea.l	(AllAllocPtr,pc),a4
1$		move.l	(a4)+,d0
		beq.b		2$
		PRINTHEX
		bra.b		1$
2$		rts

	;***
	;Command: fill all unused memory with a value
	;a0 = cmdline
	;d0 = next arg type
	;***
RoutClear:
		moveq		#0,d7					;Longword to clear
		tst.l		d0						;End of line
		beq.b		1$
		EVALE								;Get longword
		move.l	d0,d7
1$		movea.l	(SysBase).w,a6
		movea.l	(MemList,a6),a2
		bsr		Disable
2$		tst.l		(a2)					;Succ
		beq.b		3$
		movea.l	(MH_FIRST,a2),a3
4$		move.l	a3,d0
		beq.b		5$
		move.l	(4,a3),d0			;Get length
		subq.l	#8,d0
		ble.b		6$
		lsr.l		#3,d0
		lea		(8,a3),a0
7$		move.l	d7,(a0)+
		move.l	d7,(a0)+
		subq.l	#1,d0
		bgt.b		7$
6$		movea.l	(a3),a3				;Next free block
		bra.b		4$
5$		movea.l	(a2),a2				;Succ
		bra.b		2$
3$		bra		Enable

	;***
	;Command: view memory in a certain way
	;***
RoutView:
		move.b	#3,(LastCmd)
		tst.l		d0						;End of line
		beq.b		1$
		EVALE								;Get the first integer (start address)
		movea.l	d0,a4
		NEXTTYPE
		beq.b		4$
		EVALE								;Get number of bytes to list
		movea.l	a4,a0
		bra.b		6$

	;Only address argument
4$		movea.l	a4,a0
		bra.b		5$

	;No arguments
1$		movea.l	(MemoryPointer,pc),a0
5$		move.l	(MemoryBytes,pc),d0
6$		move.l	d0,(MemoryBytes)
		bsr		ReallyView
		lea		(MemoryPointer,pc),a1
		move.l	a0,(a1)
		rts

	;***
	;Subroutine: Really view memory
	;a0 = address
	;d0 = bytes
	;-> a0 = address after view
	;***
ReallyView:
		movea.l	a0,a2
		move.l	d0,d2
2$		tst.l		d2
		beq.b		4$
		movea.l	a2,a0
		bsr		CheckTagAddress
		beq.b		5$
	;We are in a tag
6$		lsl.l		#3,d0
		movea.l	a1,a4					;Remember tag for ViewMoreLines
		lea		(TagRoutines,pc),a1
		move.l	(-4,a1,d0.l),-(a7)
		movea.l	(-8,a1,d0.l),a1
		cmp.l		d2,d1
		blt.b		1$
	;Number of bytes remaining in tag is greater or equal than total number to print
		move.l	d2,d0
		moveq		#0,d2
		bra.b		3$
	;Number of bytes remaining in tag is less than total number to print
1$		move.l	d1,d0
		sub.l		d1,d2
	;Print lines
3$		movea.l	a2,a0
		move.l	(a7)+,d1
		bsr		ViewMoreLines
		movea.l	a0,a2
		bra.b		2$
4$		movea.l	a2,a0
		rts
	;We are not in a tag, list default
5$		moveq		#TAG_LONGASCII,d0
		bra.b		6$

	;***
	;Command: list memory
	;a0 = cmdline
	;d0 = next arg type
	;***
RoutMemory:
		move.b	#1,(LastCmd)
		tst.l		d0						;End of line
		beq.b		1$
		EVALE								;Get the first integer (start address)
		movea.l	d0,a4
		NEXTTYPE
		beq.b		4$
		EVALE								;Get number of bytes to list
		movea.l	a4,a0
		bra.b		6$

	;Only address argument
4$		movea.l	a4,a0
		bra.b		5$

	;No arguments
1$		movea.l	(MemoryPointer,pc),a0
5$		move.l	(MemoryBytes,pc),d0
6$		move.l	d0,(MemoryBytes)
		moveq		#16,d1

		moveq		#mo_MemorySize,d0
		bsr		CheckModeBit
		beq.b		2$

	;Long or Ascii
		moveq		#mo_MemorySize+1,d0
		bsr		CheckModeBit
		beq.b		11$					;Long
		bra.b		13$					;Ascii

	;Byte or Word
2$		moveq		#mo_MemorySize+1,d0
		bsr		CheckModeBit
		beq.b		10$					;Byte

	;Word mode
		lea		(View1WordAscii,pc),a1
		bra.b		3$
	;Ascii mode
13$	lea		(View1Ascii,pc),a1
		moveq		#64,d1
		bra.b		3$
	;Long mode
11$	lea		(View1LongAscii,pc),a1
		bra.b		3$
	;Byte mode
10$	lea		(View1ByteAscii,pc),a1
3$		suba.l	a4,a4					;No tag
		move.l	(MemoryBytes,pc),d0
		bsr		ViewMoreLines
		lea		(MemoryPointer,pc),a1
		move.l	a0,(a1)
		rts

	;***
	;Command: temporarily set another tag as current and execute command
	;***
RoutTg:
		EVALE								;Get taglist number
		bsr.b		CheckTagListRange
		move.l	d0,d2					;Remember taglist number
		bsr		GetRestLinePer
		HERReq
		movea.l	d0,a0					;Pointer to command

		move.l	(TagNum,pc),-(a7)	;Remember old taglist
		move.l	d2,d0					;Restore taglist number
		bsr		UseTag

	;Establish an error routine to restore the current taglist later
		move.l	a0,-(a7)				;Remember pointer to command
		moveq		#EXEC_TG,d0
		bsr		ExecAlias
		move.l	d0,d2					;Result
		move.l	d1,d3					;Error status

	;Clean up
		movea.l	(a7)+,a0				;Get command pointer
		bsr		FreeBlock
		move.l	(a7)+,d0
		bsr		UseTag

	;Quit
		tst.l		d3
		HERReq
		move.l	d2,d0					;Result
		rts

	;***
	;Check if tag list value is in range (0..15)
	;d0 = value
	;If there was an error, this function does not return
	;***
CheckTagListRange:
		tst.l		d0
		blt.b		1$
		moveq		#16,d1
		cmp.l		d1,d0
		bge.b		1$
		rts
1$		ERROR		BadTagListValue

	;***
	;Command: use a tag list
	;***
RoutUseTag:
		EVALE
		bsr.b		CheckTagListRange

	;***
	;Subroutine: use another tag list
	;d0 = index of tag list (0..15)
	;-> preserves a0
	;***
UseTag:
		move.l	a0,-(a7)
		lea		(TagNum,pc),a0
	;Copy current tag list to tag list list
		move.l	(a0),d1				;Get old tag list number
		lsl.l		#3,d1
		move.l	d0,(a0)				;Store new tag list number
		lea		(TagListList,pc),a1
		lea		(0,a1,d1.l),a1
		move.l	(TagSize,pc),(a1)+
		move.l	(TagPtr,pc),(a1)
	;Copy new tag list from tag list list to current tag list
		lea		(TagListList,pc),a1
		lsl.l		#3,d0
		lea		(0,a1,d0.l),a1
		lea		(TagSize,pc),a0
		move.l	(a1)+,(a0)
		lea		(TagPtr,pc),a0
		move.l	(a1),(a0)
		movea.l	(a7)+,a0
		rts

	;***
	;Function: ask the current tag list
	;***
FuncTagList:
		move.l	(TagNum,pc),d0
		rts

	;***
	;Command: save tags to a file
	;***
RoutSaveTags:
		bsr		GetStringE
		move.l	d0,d2
		EVALE								;Get base address
		move.l	d0,d7

		move.l	d2,d1
		moveq		#MODE_NEWFILE-1000,d2
		bsr		OpenDos
		movea.l	d0,a5
		ERROReq	OpenFile
		move.l	#'GS10',-(a7)
		move.l	#'PVTA',-(a7)
		move.l	a5,d1
		move.l	a7,d2
		moveq		#8,d3
		CALL		Write					;Write recognizer
		lea		(8,a7),a7
		tst.l		d0
		beq.b		1$
		move.l	a5,d1
		move.l	d7,-(a7)
		move.l	a7,d2
		moveq		#4,d3
		CALL		Write					;Write base address
		lea		(4,a7),a7

		movea.l	(TagPtr,pc),a2
		move.l	(TagSize,pc),d4
		beq.b		2$
		lsr.l		#4,d4					;Divide by 16
		bra.b		4$
3$		bsr		AddTagToFile
		beq.b		1$
		lea		(16,a2),a2
4$		dbra		d4,3$

2$		move.l	a5,d1
		pea		(-1).w
		move.l	a7,d2
		moveq		#4,d3
		CALL		Write
		lea		(4,a7),a7
		move.l	a5,d1
		CALL		Close
		rts

	;Error writing file
1$		move.l	a5,d1
		CALL		Close
		ERROR		WriteFile

	;***
	;Add one tag to a file
	;a5 = file
	;a2 = pointer to tag
	;-> d0 = 0 if error (flags)
	;***
AddTagToFile:
		move.l	a5,d1
		move.l	a2,d2
		moveq		#tag_SIZE,d3
		CALLDOS	Write
		tst.l		d0
		beq.b		3$

		cmpi.w	#TAG_STRUCT,(tag_Type,a2)
		beq.b		1$
		moveq		#1,d0
3$		rts

	;Structure tag, we also write name of structure
1$		movea.l	(tag_Structure,a2),a3	;Pointer to structure node
		movea.l	(LN_NAME,a3),a3	;Pointer to name
		movea.l	a3,a0
2$		tst.b		(a0)+
		bne.b		2$
		suba.l	a3,a0					;a0 = length of string +1
	;First length of string
		move.l	a5,d1
		move.l	a0,-(a7)				;Store length +1
		move.l	a7,d2
		moveq		#4,d3
		CALL		Write
		move.l	(a7)+,d3				;Get length +1
		tst.l		d0
		beq.b		3$
	;Now, the string
		move.l	a5,d1
		move.l	a3,d2
		CALL		Write
		tst.l		d0
		rts

	;***
	;Get tag from file and add to current tag list
	;a5 = file (PowerVisor handle)
	;d7 = displacement factor (add to address)
	;-> a0 = pointer to new tag (only if d0 == 1 or 2)
	;-> d0 = 0 if eof, 1 if fine, 2 if fine but warning, -1 if error (flags)
	;***
GetTagFromFile:
		move.l	a5,d1
		lea		(-4,a7),a7
		move.l	a7,d2
		moveq		#4,d3
		bsr		FRead
		move.l	(a7)+,d1
		tst.l		d0
		SERReq	ReadFile,2$
		move.l	d1,d0
		addq.l	#1,d1					;-1 == EOF
		bne.b		1$

	;EOF
		moveq		#0,d0					;EOF
		rts

	;Error
2$		moveq		#-1,d0				;Error
		rts


	;Read rest
	;d0 = address
	;a5 = filehandle
	;d7 = displacement factor
1$		add.l		d7,d0					;Displacement factor

	;Read rest of structure
		lea		(-tag_SIZE+4,a7),a7
		move.l	a7,d2

		move.l	d0,-(a7)				;Remember address for tag

		moveq		#tag_SIZE-4,d3
		move.l	a5,d1
		bsr		FRead

		movea.l	(a7)+,a0				;Restore address for tag

		move.l	(tag_Size-4,a7),d0	;Bytes
		move.l	(tag_Flags-4,a7),d1	;Flags & type
		lea		(tag_SIZE-4,a7),a7

		bsr		AddTag
		beq.b		2$

	;Success, see if it is a structure
		movea.l	d0,a0					;Pointer to tag
		cmpi.w	#TAG_STRUCT,(tag_Type,a0)
		bne.b		3$

	;Yes, it is a structure, try to locate the structure
	;If not found we replace the type with TAG_LONGASCII
		move.l	d0,-(a7)				;Remember pointer to tag

	;Read length of string
		lea		(-4,a7),a7
		move.l	a7,d2
		moveq		#4,d3
		move.l	a5,d1
		bsr		FRead
		move.l	(a7)+,d3
	;Read string
		move.l	(Storage),d2
		bsr		FRead

		movea.l	(Storage),a1
		lea		(StructDefs),a0
		CALLEXEC	FindName
		beq.b		4$

	;Yes !
		movea.l	(a7)+,a0				;Restore pointer to tag
		move.l	d0,(tag_Structure,a0)

	;Success
3$		moveq		#1,d0					;Success
		rts

	;No !
4$		movea.l	(a7)+,a0				;Restore pointer to tag
		move.w	#TAG_LONGASCII,(tag_Type,a0)
		moveq		#2,d0					;Warn!
		rts

	;***
	;Command: load tags from a file
	;***
RoutLoadTags:
		bsr		GetStringE
		move.l	d0,d2
		EVALE								;Get new base address
		move.l	d0,d7

		move.l	d2,d1
		bsr		FOpen
		movea.l	d0,a5
		ERROReq	OpenFile
		subq.l	#8,a7					;Reserve 8 bytes
		move.l	a7,d2
		moveq		#8,d3
		bsr		FRead
		tst.l		d0
		beq.b		1$
		cmpi.l	#'PVTA',(a7)
		bne.b		3$
		cmpi.l	#'GS10',(4,a7)
		bne.b		3$
		lea		(4,a7),a7				;Free 8 bytes and reserve 4 bytes

	;File is correct
		move.l	a7,d2
		moveq		#4,d3
		bsr		FRead					;Read old base
		move.l	(a7)+,d6				;Old base
		sub.l		d6,d7					;d7 = value to add to each tag address

		moveq		#0,d6					;Set warning flag off

6$		bsr		GetTagFromFile
		blt.b		4$						;-1, Error
		beq.b		5$						;0, EOF
		subq.l	#1,d0
		beq.b		6$						;1, ok
		moveq		#1,d6					;Set warning flag on
		bra.b		6$

	;Check if some of the structures were not found
5$		tst.w		d6
		beq.b		2$
		lea		(TagWarning,pc),a0
		PRINT

	;Exit
2$		move.l	a5,d1
		bra		FClose

	;Error reading file
1$		bsr.b		2$						;First close file
		ERROR		ReadFile

	;Error wrong format
3$		bsr.b		2$						;First close file
		ERROR		NotATagFile

	;Error out of memory or other error
4$		bsr.b		2$						;First close file
		HERR

	;***
	;Command: add a tag
	;***
RoutAddTag:
		EVALE								;Get address
		movea.l	d0,a2
		EVALE								;Get number of bytes
		move.l	d0,d2
		bsr		GetStringE			;Get type
		movea.l	d0,a1
		movea.l	a0,a4					;Remember ptr to cmdline
		lea		(TypeString,pc),a0
		move.b	(a1)+,d0
		bsr		Upper
		move.b	d0,(a0)+
		move.b	(a1)+,d0
		bsr		Upper
		move.b	d0,(a0)+
		lea		(TagStrings,pc),a0
		move.w	(TypeString,pc),d1
		moveq		#1,d3

	;Search the correct type
1$		move.w	(a0)+,d0
		ERROReq	UnknownTagType
		cmp.w		d0,d1
		beq.b		2$
		addq.l	#1,d3
		bra.b		1$

	;Check if the tag is a TAG_STRUCT type
2$		moveq		#0,d4
		cmpi.w	#TAG_STRUCT,d3
		bne.b		3$
	;Yes there is an extra argument (the structure)
		movea.l	a4,a0					;Get ptr to commandline
		moveq		#I_STRUCT,d6
		bsr		SetList
		EVALE
		bsr		ResetList
		movea.l	a0,a4					;Remember commandline
		movea.l	d0,a0
		cmpi.l	#'PVSD',(str_MatchWord,a0)
		ERRORne	NotAStructDef
		move.l	d0,d4

	;First check if there are some extra protection arguments
3$		movea.l	a4,a0					;Get ptr to commandline
		NEXTTYPE
		beq.b		4$
	;Yes there are
		lea		(AddTagFlags,pc),a1
		bsr		MakeBitField
		bsr		SkipSpace
		move.b	(a0),d1
		ERRORne	BadArgValue
		swap		d3
		move.w	d0,d3
		swap		d3

	;Really add tag
4$		bsr		AddTagCheck
		ERROReq	NotEnoughMemory
		movea.l	d0,a0
		move.l	d4,(tag_Structure,a0)
		rts

	;Subroutine: Add a tag with collisioncheck
	;d3 = Flags & type
	;d2 = bytes
	;a2 = address
	;-> d0 = 0 (flags) is no success else pointer to tag
AddTagCheck:
	;We can add our tag to the tag list, first we check if there are no
	;collisions.
2$		movea.l	a2,a0
		bsr		SearchTag
		beq.b		3$
		cmp.l		(TagPtr,pc),d0
		blt.b		3$						;d0 < TagPtr
		movea.l	d0,a1					;a1 = tag
		cmpa.l	(tag_Address,a1),a0	;Compare our address with address in tag
		ble.b		3$
	;Our tag start is after a tag pointed to by a1. Check if our tag does
	;fit completely in the other tag.
		adda.l	d2,a0					;a0 = end address for our tag
		move.l	(tag_Address,a1),d0
		add.l		(tag_Size,a1),d0	;d0 = end other tag
		cmp.l		a0,d0
		ble.b		4$
	;Our tag is in the other tag. We must split the other tag.
	;First make the orignal other tag smaller
		move.l	d0,d1					;Remember end of tag
		sub.l		a2,d1					;d1 = number of bytes to decrease tag with
		sub.l		d1,(tag_Size,a1)	;Decrease size other tag
	;Make a new tag
		movea.l	a2,a0
		adda.l	d2,a0					;Start address for new tag
		sub.l		a0,d0					;Number of bytes for new tag
		move.l	(tag_Flags,a1),d1	;Same flags & type as other tag
		bsr		AddTag				;We ignore errors
		bra.b		3$

	;Our tag is not in the other tag, but can overlap it.
4$		cmp.l		a2,d0					;Check our start address with tag end
		blt.b		3$
	;Our tag overlaps the other. We must make the other tag smaller.
		sub.l		a2,d0					;d0 = number of overlapping bytes
		sub.l		d0,(tag_Size,a1)	;Decrease size other tag

	;Really add him
3$		move.l	d3,d1					;Flags & Type
		move.l	d2,d0					;Bytes
		movea.l	a2,a0					;Address
		bra		AddTag				;We ignore errors

	;***
	;Make a bit field
	;a0 = pointer to input string (ending with something not in the table)
	;a1 = pointer to table with letters for each bit (ending with 0) (uppercase)
	;		If you want to ignore a certain bit you can put an arbitrary lowercase
	;		letter on that position
	;-> d0 = integer with all right bits set
	;***
MakeBitField:
		movem.l	d2/a2,-(a7)
		movea.l	a1,a2					;Remember pointer to table
		moveq		#0,d1

1$		move.b	(a0),d0
		beq.b		2$
		bsr		Upper
		movea.l	a2,a1
		moveq		#1,d2					;Bit counter
3$		tst.b		(a1)
		beq.b		2$
		lsl.l		#1,d2
		cmp.b		(a1)+,d0
		bne.b		3$

	;Found!
		lsr.l		#1,d2
		or.l		d2,d1
		lea		(1,a0),a0			;Next char
		bra.b		1$

2$		move.l	d1,d0
		movem.l	(a7)+,d2/a2
		rts

	;***
	;Command: remove a tag
	;***
RoutRemTag:
		EVALE								;Get address
		movea.l	d0,a0
		bra		RemTag

	;***
	;Perform a routine for each element of the current tag list
	;a5 = pointer to routine
	;a3/d3 are passed to the routine
	;			;***
	;			;Routine for each element in list
	;			;a0 = pointer to tag
	;			;a3/d3 = parameters
	;			;-> a3/d3 = updated parameters
	;			;Routine must preserve all regs except a0-a1/a3/d0-d1/d3/a6
	;			;***
	;***
ApplyCommandOnTags:
		movem.l	a2/d2,-(a7)
		movea.l	(TagPtr,pc),a2
		move.l	(TagSize,pc),d2
		beq.b		1$
		lsr.l		#4,d2					;Divide by 16 (size of tag structure)
		bra.b		3$

2$		movea.l	a2,a0
		jsr		(a5)
		lea		(tag_SIZE,a2),a2
3$		dbra		d2,2$

1$		movem.l	(a7)+,a2/d2
		rts

	;***
	;Command: list all tags
	;***
RoutTags:
		movea.l	(TagPtr,pc),a2
		move.l	(TagSize,pc),d2
		beq.b		1$
		lsr.l		#4,d2					;Divide by 16 (size of tag structure)
		subq.w	#1,d2

2$		move.l	d2,-(a7)
		movea.l	a2,a1
		GETFMT	_,0,_,0,l,tag_Address,l,tag_Size
		FMTSTR	_,_,_,_,08lx,col,08lx,spc
		bsr		SpecialPrint
		move.l	(a7)+,d2

		lea		(tag_Flags,a2),a2

		move.w	(a2)+,d5				;Flags
		move.w	(a2)+,d0				;Type
		move.w	d0,d4
		lea		(TagStrings,pc),a0
		lsl.w		#1,d0
		lea		(-2,a0,d0.w),a0
		pea		(0).w
		move.w	(a0),-(a7)
		movea.l	a7,a0
		PRINT
		lea		(6,a7),a7

	;Check if it is a STRUCT tag
		movea.l	(a2)+,a3				;Get next long (possibly a structure pointer)
		cmpi.w	#TAG_STRUCT,d4
		bne.b		3$
	;Yes
		moveq		#' ',d0
		bsr		PrintChar
		movea.l	(LN_NAME,a3),a0
		PRINT
	;No
3$		moveq		#32,d0
		bsr		PrintChar
		lea		(bfTagFlags,pc),a0
		move.w	d5,d0
		bsr		PrintBitField
		dbra		d2,2$
1$		rts

	;***
	;Command: check tag address
	;***
RoutCheckTag:
		EVALE								;Get address
		movea.l	d0,a0
		bsr		CheckTagAddress
		beq.b		1$
		move.l	d1,-(a7)
		lea		(TagStrings,pc),a0
		lsl.w		#1,d0
		lea		(-2,a0,d0.w),a0
		move.b	(a0)+,d0
		bsr		PrintChar
		move.b	(a0),d0
		bsr		PrintChar
		moveq		#' ',d0
		bsr		PrintChar
		move.l	(a7)+,d0
		PRINTHEX
		rts
	;Not in tag list
1$		move.l	d1,d0
		PRINTHEX
		rts

	;***
	;Check type of address
	;a0 = address
	;-> d0 = type number or flags if not in tag list
	;-> d1 = number of bytes left in tag
	;			(or number of bytes before next tag if not in tag list)
	;-> a1 = ptr to tag (if type was given)
	;***
CheckTagAddress:
		bsr		SearchTag
		beq.b		2$
		cmp.l		(TagPtr,pc),d0
		blt.b		1$						;d0 < TagPtr
		movea.l	d0,a1
;	cmp.l		(tag_Address,a1),a0
;	blt.s		1$
		move.l	(tag_Address,a1),d0	;Get start address
		sub.l		a0,d0					;Distance between start and our address
		neg.l		d0
		move.l	(tag_Size,a1),d1	;Get number of bytes
		sub.l		d0,d1					;d1 = number of bytes left
		ble.b		3$
		moveq		#0,d0
		move.w	(tag_Type,a1),d0	;Get type
		rts
	;We are not in a tag, a1 = ptr to current tag we are after
3$		move.l	(TagSize,pc),d0
		add.l		(TagPtr,pc),d0		;d0 = ptr after last tag
		subq.l	#8,d0
		subq.l	#8,d0					;d0 = ptr to last tag
		cmp.l		a1,d0					;Is a1 the last tag ?
		beq.b		2$						;Yes, we do as if there are no tags at all
		lea		(tag_SIZE,a1),a1	;No, we point to the next tag, and goto 1$
	;We are before all tags, a1 = ptr to first tag
1$		move.l	(tag_Address,a1),d1
		sub.l		a0,d1					;Number of bytes before next tag
		moveq		#0,d0
		rts
	;No tags at all
2$		move.l	#$7fffffff,d1		;Infinite number of bytes
		moveq		#0,d0
		rts

	;***
	;Add a tag to the taglist (or update)
	;a0 = address
	;d0 = bytes
	;d1 = flags & type
	;-> d0 = 0 if error (flags) else pointer to tag
	;***
AddTag:
		movem.l	a2-a3/d2-d3,-(a7)
		move.l	d0,d2					;Bytes
		move.l	d1,d3					;Flags & type
		movea.l	a0,a3					;Address
		lea		(TagSize,pc),a2
		tst.l		(a2)
		beq.b		2$
	;Tag list is not empty
		bsr		SearchTag
		cmp.l		(TagPtr,pc),d0
		blt.b		2$						;d0 < TagPtr
		movea.l	d0,a1
		cmpa.l	(tag_Address,a1),a3
		beq.b		1$
		blt.b		2$
	;Normal situation, insert tag after current element
		sub.l		(4,a2),d0			;Compute offset to insert
		addq.l	#8,d0
		addq.l	#8,d0					;After current element
		bra.b		3$
	;Tag already exists, replace number of bytes value
1$		move.l	d2,(tag_Size,a1)
		move.l	d3,(tag_Flags,a1)	;Flags & type
		move.l	a1,d0					;No error
		bra.b		4$
	;Insert tag in front of all other tags
2$		moveq		#0,d0					;Offset 0
3$		movea.l	a2,a0
		moveq		#tag_SIZE,d1
		move.l	d0,-(a7)
		bsr		InsertMem
		movem.l	(a7)+,d0				;Preserve flags
		beq.b		4$
	;Fill in
		movea.l	(4,a2),a0
		lea		(0,a0,d0.l),a0
		move.l	a0,d0
		move.l	a3,(a0)+				;Address
		move.l	d2,(a0)+				;Size
		move.l	d3,(a0)+				;Flags & type
		tst.l		d0						;Success
	;End (flags are set)
4$		movem.l	(a7)+,a2-a3/d2-d3
		rts

	;***
	;Remove a tag from the tag list
	;a0 = address
	;***
RemTag:
		bsr		SearchTag
		beq.b		1$
		cmp.l		(TagPtr,pc),d0
		blt.b		1$						;d0 < TagPtr
		movea.l	d0,a1
		cmpa.l	(a1),a0
		bne.b		1$
	;Yes, we can remove it
		lea		(TagSize,pc),a0
		sub.l		(4,a0),d0			;Offset to start removing
		moveq		#tag_SIZE,d1		;Size to remove
		bsr		RemoveMem
1$		rts

	;***
	;Search a tag in the tag list
	;a0 = address
	;-> d0 = ptr to tag in tag list (of null, flags if list empty)
	;-> a0 = address (unchanged)
	;***
SearchTag:
		lea		(TagSize,pc),a1
		move.l	(a1)+,d0				;Size tag list
		beq.b		4$						;Tag list empty
		movea.l	(a1),a1				;Ptr to start block
		moveq		#0,d1
		moveq		#tag_SIZE,d1		;Tag structures are 16 bytes big
		bra		BinarySearch

4$		moveq		#0,d0
		rts

	;***
	;This routine is to be called from C (mondis.c). It checks if a given
	;address is the start of a structure tag and if this is the case it
	;will check if the given offset is part of the structure. If all these
	;tests succeed this function will return the pointer to the name of
	;the structure element. Otherwise NULL is returned
	;Parameters on stack (address,offset)
	;-> d0 = pointer to name or NULL
	;***
_CheckStruct:
		movem.l	a2/d2,-(a7)
		movea.l	(8+4,a7),a2			;Address
		move.l	(8+8,a7),d2			;Offset

	;Search tag
		movea.l	a2,a0
		bsr		SearchTag
		beq.b		1$

	;Check type
		movea.l	d0,a0
		move.w	(tag_Type,a0),d0
		cmp.w		#TAG_STRUCT,d0
		bne.b		1$

	;Check if address is start of tag
		cmpa.l	(tag_Address,a0),a2
		bne.b		1$

	;Check if offset is in structure
		movea.l	(tag_Structure,a0),a0
		movea.l	(str_InfoBlock,a0),a0
3$		move.l	(a0)+,d0				;Pointer to string
		beq.b		1$
		lea		(2,a0),a0			;Skip type of element in structure
		cmp.w		(a0)+,d2				;Compare offset
		beq.b		2$						;If equal we have success
		bra.b		3$

	;No success
1$		moveq		#0,d0

2$		movem.l	(a7)+,a2/d2
		rts

	;***
	;Clear tag list
	;***
RoutClearTags:
ClearTags:
		lea		(TagSize,pc),a0
		moveq		#0,d0
		bra		ReAllocMem

	;***
	;View more lines
	;a0 = address
	;d0 = bytes
	;a1 = routine
	;d1 = number of bytes per line (0 to ignore)
	;a4 = pointer to tag
	;-> a0 = First address not viewed
	;***
ViewMoreLines:
		movem.l	a2/d2,-(a7)
3$		tst.l		d0
		ble.b		1$
		movea.l	a0,a2
		move.l	d1,d2
		beq.b		2$						;Ignore number of bytes per line because d1=0
		cmp.l		d1,d0
		bge.b		2$
	;We do not have d1 bytes to view
		move.l	d0,d2
2$		jsr		(a1)
		lea		(0,a0,d2.l),a0
		sub.l		d2,d0
		bra.b		3$
1$		adda.l	d0,a0					;Correct a possible overflow (possible if
											;d1 = 0 (bytes per line not constant)).
		movem.l	(a7)+,a2/d2
		rts

	;***
	;Subroutine: Display 1 structure
	;a2 = address (ignored)
	;d2 = ignored
	;a4 = ptr to tag
	;-> d2 = number of bytes actually printed
	;***
View1Struct:
		movem.l	a0-a4/d0-d1/d3,-(a7)
	;Fill output string with zeroes
		movea.l	(Storage),a3
		movea.l	a3,a0
		moveq		#76,d0
		bsr		ZeroString
	;Print address in string
		movea.l	a3,a0
		movea.l	a2,a1
		moveq		#74,d0
		bsr		MakeLabel
		movea.l	a3,a0
		PRINT
		movea.l	(tag_Structure,a4),a0	;Get structure definition ptr
		movea.l	(LN_NAME,a0),a0
		PRINT
		NEWLINE
	;Really list
		movea.l	(tag_Address,a4),a2		;Get real start of structure
		move.l	(tag_Size,a4),d2			;Get number of bytes
		movea.l	(tag_Structure,a4),a4	;Get structure definition ptr
		movea.l	(str_InfoBlock,a4),a0
		bsr		ListItem
		movem.l	(a7)+,a0-a4/d0-d1/d3
		rts

	;***
	;Subroutine: Display 1 machinelanguage instruction
	;a2 = address
	;d2 = ignored
	;-> d2 = number of bytes actually printed
	;***
View1Code:
		movem.l	a0-a1/a4/d0-d1/d3,-(a7)
		movea.l	(Storage),a0
		move.l	a2,d0

	;Clear line
		moveq		#39,d1
1$		move.b	#' ',(a0)+
		dbra		d1,1$

		bsr		DisasmBreak
		move.l	d0,d2
		movea.l	(Storage),a0
		move.l	a2,d0					;Before
		move.l	d0,d1
		add.l		d2,d1					;After
		bsr		PrintAddress
		PRINT
		NEWLINE
		movem.l	(a7)+,a0-a1/a4/d0-d1/d3
		rts

	;***
	;Subroutine: Display ascii format (1 line only)
	;a2 = address
	;d2 = bytes
	;-> d2 = number of bytes actually printed
	;***
View1Ascii:
		movem.l	a0-a3/d0-d3,-(a7)
		bsr		ViewHeader

	;For each byte to display
		bra.b		2$
1$		move.b	(a2)+,d0
		bsr		MakePrint
		move.b	d0,(a3)+
2$		dbra		d2,1$

		move.b	#10,(a3)+
		clr.b		(a3)+
		bsr		ViewPrintLine
		movem.l	(a7)+,a0-a3/d0-d3
		rts

	;***
	;Subroutine: Display long/ascii format (1 line only)
	;a2 = address to display
	;d2 = number of bytes to display
	;-> d2 = number of bytes actually printed
	;***
View1LongAscii:
		move.l	d5,-(a7)
		moveq		#4,d5
		bsr		View1BWLAscii
		move.l	(a7)+,d5
		rts

	;***
	;Subroutine: Display word/ascii format (1 line only)
	;a2 = address to display
	;d2 = number of bytes to display
	;-> d2 = number of bytes actually printed
	;***
View1WordAscii:
		move.l	d5,-(a7)
		moveq		#2,d5
		bsr		View1BWLAscii
		move.l	(a7)+,d5
		rts

	;***
	;Subroutine: Display byte/ascii format (1 line only)
	;a2 = address to display
	;d2 = number of bytes to display
	;-> d2 = number of bytes actually printed
	;***
View1ByteAscii:
		move.l	d5,-(a7)
		moveq		#1,d5
		bsr		View1BWLAscii
		move.l	(a7)+,d5
		rts

	;***
	;Subroutine: View 1 line byte/word/long ascii format
	;a2 = address to display
	;d2 = number of bytes to display
	;d5 = space pos
	;***
View1BWLAscii:
		movem.l	a0-a4/d0-d4,-(a7)
		bsr		ViewHeader
		lea		(50,a3),a4			;Ptr to ascii in data
		move.l	d5,d4					;Counter for space
	;For each byte to display
		bra.b		3$

1$		movea.l	a3,a0
		move.b	(a2)+,d0
		bsr		ByteToHex
		lea		(2,a3),a3
		move.b	#' ',(a3)
		subq.w	#1,d4
		bne.b		2$

	;No, go one right
		lea		(1,a3),a3
		move.l	d5,d4

	;Show ascii value
2$		bsr		MakePrint
		move.b	d0,(a4)+
3$		dbra		d2,1$

		move.b	#10,(a4)+
		clr.b		(a4)+
		bsr		ViewPrintLine
		movem.l	(a7)+,a0-a4/d0-d4
		rts

	;***
	;Subroutine: Show header for each line
	;a2 = address
	;-> a3 = ptr to somewhere in Storage
	;***
ViewHeader:
	;Fill output string with spaces
		movea.l	(Storage),a3
		movea.l	a3,a0
		moveq		#76,d0
		bsr		ClearString
	;Print address in string
		movea.l	a3,a0
		movea.l	a2,a1
		moveq		#9,d0
		bsr		MakeLabel
		lea		(10,a3),a3			;Ptr to following hex data
		rts

	;***
	;Subroutine: Print the line
	;***
ViewPrintLine:
		movea.l	(Storage),a0
		bra		Print

	;***
	;Command: unassemble memory
	;a0 = cmdline
	;d0 = next arg type
	;***
RoutUnAsm:
		move.b	#2,(LastCmd)
		tst.l		d0						;End of line
		bne.b		1$
		move.l	(MemoryPointer,pc),d6
		move.l	(MemoryLines,pc),d7
		bra.b		DefaultLengthUA
1$		EVALE
		move.l	d0,d6						;Address to start disassembly
		move.l	(MemoryLines,pc),d7	;default Number of lines
		NEXTTYPE
		beq.b		DefaultLengthUA
		EVALE
		move.l	d0,d7					;Number of lines
DefaultLengthUA:
		lea		(MemoryLines,pc),a0
		move.l	d7,(a0)
		suba.l	a4,a4

	;a4 = stackframe or NULL
SmartUnAsm:
		move.l	a4,-(a7)
		bclr		#0,d6					;Make address even
		lea		(MemoryPointer,pc),a0
		move.l	d6,(a0)
		bra.b		2$

1$		bsr		CommonUA
		bsr		Print
		bsr		NewLine				;For efficiency we don't use the macros
		suba.l	a4,a4
2$		dbra		d7,1$

		lea		(MemoryPointer,pc),a4
		move.l	d6,(a4)
		movea.l	(a7)+,a4
		rts

	;Subroutine
	;d6 = address
	;a4 = pointer to stackframe (pointer to PC, SR, Dx, Ax) (or NULL)
	;-> a0 = ptr to Storage
	;-> d0 = bytes disassembled
	;-> d5 = ptr to previous instruction
	;-> d6 = ptr to next instruction
CommonUA:
		suba.l	a6,a6
		move.l	a4,d0
		beq.b		2$
		movea.l	(6+8*4+6*4,a4),a6	;Get a6 register

2$		move.l	d6,d0
		movea.l	(Storage),a0
		move.l	a0,-(a7)

		moveq		#39,d1
1$		move.b	#' ',(a0)+
		dbra		d1,1$

		bsr		DisasmSmart
		move.l	d6,d5					;Remember previous address
		add.l		d0,d6					;New address after instruction
	;Print address
		movea.l	(a7)+,a0				;Ptr to storage
		move.l	d0,-(a7)				;Preserve bytes disassembled
		move.l	d5,d0
		move.l	d6,d1
		bsr		PrintAddress
		move.l	(a7)+,d0				;Restore bytes disassembled
		rts

	;***
	;Print address label and possibly some hex words
	;a0 = string
	;d0 = address before instruction
	;d1 = address after instruction
	;-> a0 unchanged
	;***
PrintAddress:
		movem.l	a0/a2-a3,-(a7)
		movea.l	d0,a2					;Before
		movea.l	d1,a3					;After
		movea.l	a2,a1
		moveq		#mo_SHex,d0
		bsr		CheckModeBit
		beq.b		1$

	;Yes, we must include a hex dump
		moveq		#11,d0
		move.l	a0,-(a7)
		bsr		MakeLabel
		movea.l	(a7)+,a0
	;Print instruction in hex
		move.l	a3,d1					;After
		sub.l		a2,d1					;d1 = After-Before = bytes of instruction
		lsr.l		#1,d1					;Nr of words in instruction
		cmpi.l	#6,d1
		ble.b		4$
		moveq		#6,d1
4$		subq.l	#1,d1					;For loop
		lea		(10,a0),a0
		moveq		#0,d0

	;For each word ...
2$		move.w	(a2)+,d0
		bsr		WordToHex
		lea		(4,a0),a0
		move.b	#' ',(a0)+
		dbra		d1,2$

3$		movem.l	(a7)+,a0/a2-a3
		rts

	;No, do not include hex dump
1$		moveq		#39,d0
		bsr		MakeLabel
		bra.b		3$

	;***
	;Disassemble memory (beware breakpoints)
	;DisasmSmart is with fd-file checking
	;a0 = str
	;d0 = addr
	;a4 = stackframe (for debug task, registers) (only for DisasmSmart) (or NULL)
	;a6 = value in a6 (for debug task) (only for DisasmSmart) (or NULL)
	;-> d0 = bytes dissasembled
	;-> a0 = ptr to end str
	;-> a4 = destroyed by 'DisasmBreak' and preserved by 'DisasmSmart'
	;***
DisasmBreak:
		suba.l	a4,a4
		suba.l	a6,a6
DisasmSmart:
		movem.l	a1-a5/d2/d6-d7,-(a7)
		movea.l	a6,a5
		movea.l	a0,a2					;str
		move.l	d0,d2					;addr
		movea.l	d0,a0
		cmpi.w	#$4afc,(a0)			;ILLEGAL
		bne.b		1$
		bsr		SearchBreakPoint
		beq.b		1$
	;There is a breakpoint on this position
	;temporary restore (a0=addr, d0=brkpt)
		movea.l	d0,a3					;Brkpt
		bsr		Disable
		move.w	(bp_Original,a3),(a0)
		move.l	a0,d0
		movea.l	a2,a0
		bsr		RCallDisasm
		movea.l	d2,a1
		move.w	#$4afc,(a1)			;ILLEGAL
		bsr		Enable
		move.b	#' ',(a0)+
		move.b	#' ',(a0)+
		move.b	#'>',(a0)+
		move.l	d0,-(a7)
		moveq		#0,d0
		move.w	(bp_Number,a3),d0
		bsr		LongToDec
		move.l	(a7)+,d0
2$		movem.l	(a7)+,a1-a5/d2/d6-d7
		rts
1$		move.l	d2,d0
		movea.l	a2,a0
		bsr		RCallDisasm
		bra.b		2$

	;***
	;Convert an address to a label if possible
	;a0 = pointer to put label or address
	;d0 = length we may use for our label
	;a1 = address
	;-> a0 = ptr to end of label (warning ! no NULL char is appended)
	;			(a0 = ptr to where NULL char should be)
	;***
MakeLabel:
		movem.l	d2/a2-a4,-(a7)
		movea.l	a1,a4					;Remember address
		move.l	d0,d2					;Remember length
		movea.l	a0,a3					;Remember label address
		move.l	(CurrentDebug),d1
		beq.b		1$

	;Search label
		move.l	a4,d0					;Get address
		movea.l	d1,a2
		bsr		GetSymbolStr
		beq.b		1$

	;There is a label for this instruction
		subq.w	#1,d2
2$		move.b	(a0)+,(a3)+
		dbeq		d2,2$
		movea.l	a3,a0
		move.b	#' ',(-1,a0)
		bra.b		3$

	;There is no label or there is no debugtask, print a number
1$		movea.l	a3,a0					;Restore label address
		move.l	a4,d0					;Get address
		bsr		LongToHex
		lea		(8,a0),a0
		move.b	#':',(a0)+
		move.b	#' ',(a0)+
3$		movem.l	(a7)+,d2/a2-a4
		rts

	;Subroutine: disassemble memory for DisasmSmart and DisasmBreak
	;	a0 = string to disassemble in
	;	d0 = address
	;	a4 = stackframe for registers (or NULL)
	;	a5 = ptr to library (or NULL)
	;	-> d0 = bytes disassembled
	;	-> a0 = pointer to end of string
RCallDisasm:
		move.l	a5,d1
		beq		CallDisasm
		movea.l	d0,a1
		cmpi.w	#$4eae,(a1)			;JSR	(...,A6)
		beq.b		2$
		cmpi.w	#$4eee,(a1)			;JMP	(...,A6)
		bne		CallDisasm
	;YES ! We have the right instruction for a library jump
2$		move.w	(2,a1),d1				;Get offset in library
	;See if we have an fd-file for this library
		lea		(FDFiles),a1
3$		movea.l	(a1),a1				;Succ
		tst.l		(a1)					;Succ
		beq.b		1$						;No, does not exist
		cmpa.l	(fd_Library,a1),a5
		bne.b		3$
	;We have found the library !
4$		neg.w		d1
		sub.w		(fd_Bias,a1),d1
		ext.l		d1
		divu.w	#6,d1					;d1 is number of function
		cmp.w		(fd_NumFuncs,a1),d1
		bgt.b		1$						;Function goes to far
	;Ok, now we can disassemble our function
		move.l	a1,-(a7)
		move.b	#'J',(a0)+
		movea.l	d0,a1
		cmpi.w	#$4eae,(a1)
		beq.b		5$
	;JMP
		move.b	#'M',(a0)+
		move.b	#'P',(a0)+
		bra.b		6$
	;JSR
5$		move.b	#'S',(a0)+
		move.b	#'R',(a0)+
6$		moveq		#5,d0

7$		move.b	#' ',(a0)+
		dbra		d0,7$

		move.b	#'(',(a0)+
		movea.l	(a7),a1				;Get ptr to fd-node
		ext.l		d1
		mulu.w	#12,d1				;Offset in fd_Block
		movea.l	(fd_Block,a1),a1
		adda.l	d1,a1
		move.l	(a1),d1				;Offset for string
		movea.l	(a7)+,a1				;Ptr to fd-node
		movea.l	(fd_String,a1),a1
		adda.l	d1,a1					;Ptr to string
8$		move.b	(a1)+,(a0)+
		bne.b		8$
		move.b	#',',(-1,a0)
		move.b	#'A',(a0)+
		move.b	#'6',(a0)+
		move.b	#')',(a0)+
		clr.b		(a0)
		moveq		#4,d0					;4 bytes disassembled
		rts
1$		bra		CallDisasm

	;***
	;Command: list all memory for a task
	;a0 = cmdline
	;***
RoutMemTask:
		moveq		#I_TASK,d6
		bsr		SetList
		EVALE
		movea.l	d0,a2
		lea		(TC_MEMENTRY,a2),a2
1$		movea.l	(a2),a2				;Succ
		tst.l		(a2)					;Succ
		beq.b		2$
		move.l	a2,d0
		PRINTHEX
		move.w	(ML_NUMENTRIES,a2),d4
		lea		(ML_ME,a2),a3
3$		tst.w		d4
		beq.b		1$
		lea		(FormatMemoryL),a0
		move.l	(4,a3),-(a7)
		move.l	a3,-(a7)
		move.l	(Storage),d0
		movea.l	a7,a1
		bsr		FastFPrint
		lea		(8,a7),a7
		bsr		ViewPrintLine
		lea		(8,a3),a3
		subq.w	#1,d4
		bra.b		3$
2$		rts

	;***
	;Command: copy memory
	;a0 = cmdline
	;***
RoutCopy:
		EVALE								;Get source start
		move.l	d0,d6
		EVALE								;Get dest start
		move.l	d0,d7
		EVALE								;Get number of bytes
		movea.l	d6,a1
		movea.l	d7,a0
		bra.b		2$

1$		move.b	(a1)+,(a0)+
2$		dbra		d0,1$
		rts

	;***
	;Command: fill memory with value
	;a0 = cmdline
	;***
RoutFill:
		EVALE								;Get source start
		move.l	d0,d6
		EVALE								;Get fill length
		move.l	d0,d7
		bsr		GetStringE			;Get string to fill
		movea.l	d6,a0					;Start
		movea.l	d0,a1					;Ptr to string
		moveq		#0,d5					;Ptr in string
1$		tst.l		d7
		beq.b		2$
		subq.l	#1,d7
		move.b	(a1,d5.l),(a0)+
		addq.l	#1,d5
		cmp.l		d5,d1					;Have we copied the complete string ?
		bne.b		1$
		moveq		#0,d5
		bra.b		1$
2$		rts

	;***
	;Command: search to something
	;a0 = cmdline
	;***
RoutSearch:
		move.l	a0,-(a7)				;Delete previous memory search string
		move.l	(MemSearch,pc),d0
		beq.b		1$
		movea.l	d0,a0
		bsr		FreeBlock
1$		movea.l	(a7)+,a0
		EVALE								;Get search start
		move.l	d0,d6
		EVALE								;Get search length
		move.l	d0,d7
		bsr		GetStringPer		;Get string to search
		HERReq
		movea.l	d0,a2					;Ptr to string
		lea		(MemSearch,pc),a0
		move.l	d0,(a0)
		movea.l	d6,a0					;Start
		movea.l	a2,a1					;Ptr to string
InRoutSearch:
2$		tst.l		d7
		beq.b		3$
		subq.l	#1,d7
		move.b	(a0)+,d0
		cmp.b		(a1),d0
		bne.b		2$						;No, continue searching
	;See if this is a good one
		move.l	d7,d6					;Remember d7
		movea.l	a0,a2					;Remember position
		moveq		#0,d5
4$		addq.l	#1,d5
		cmp.l		d5,d1					;Have we found the complete string ?
		beq.b		5$
		tst.l		d7
		beq.b		3$
		subq.l	#1,d7
		move.b	(a1,d5.l),d0
		cmp.b		(a2)+,d0
		beq.b		4$
	;No, it is not a good one, restore d7 (remaining bytes)
		move.l	d6,d7
		bra.b		2$
3$		lea		(MemorySPointer,pc),a0
		clr.l		(a0)
		lea		(MemRemain,pc),a0
		clr.l		(a0)
		moveq		#0,d0
1$		PRINTHEX
		bra		StoreRC
	;Found
5$		move.l	a0,d0
		lea		(MemorySPointer,pc),a0
		move.l	d0,(a0)
		lea		(MemRemain,pc),a0
		move.l	d6,(a0)
		subq.l	#1,d0
		bra.b		1$

	;***
	;Command: continue searching
	;***
RoutNext:
		move.l	(MemRemain,pc),d7
		movea.l	(MemorySPointer,pc),a0
		movea.l	(MemSearch,pc),a1
		moveq		#0,d1
		move.w	(-2,a1),d1
		subq.w	#1,d1
		bra.b		InRoutSearch

	;***
	;Return last memory ptr
	;-> d0 = ptr
	;***
FuncLastMem:
		move.l	(MemoryPointer,pc),d0
		rts

	;***
	;Return last number of listed bytes
	;-> d0 = ptr
	;***
FuncLastBytes:
		move.l	(MemoryBytes,pc),d0
		rts

	;***
	;Return last number of listed lines
	;-> d0 = ptr
	;***
FuncLastLines:
		move.l	(MemoryLines,pc),d0
		rts

	;***
	;Return last memory search ptr
	;-> d0 = ptr
	;***
FuncLastFound:
		move.l	(MemorySPointer,pc),d0
		rts

	;***
	;Add a pointer to the resident table
	;d0 = BPTR seglist to add
	;-> flags if no success
	;-> d0 is unchanged
	;***
AddPointerResident:
		lea		(ResidentSize,pc),a0
		bra.b		AddPointer

	;***
	;Add a pointer to the alloc table
	;d0 = pointer to add
	;-> flags if no success
	;-> d0 is unchanged
	;***
AddPointerAlloc:
		lea		(AllAllocSize,pc),a0

	;***
	;Add a pointer to a list
	;d0 = pointer to add
	;a0 = pointer to list (pointer to PV memory block)
	;-> flags if no success
	;-> d0 is unchanged
	;***
AddPointer:
		move.l	d0,-(a7)
		move.l	(a0),d0				;Get logical size = position to append new item
		subq.l	#4,d0					;Insert before last 0
		moveq		#4,d1
		bsr		InsertMem
		movem.l	(a7)+,d0				;For flags !
		beq.b		1$
		movea.l	(a0),a1				;Get logical size
		subq.l	#8,a1					;Offset to newly added pointer
		adda.l	(4,a0),a1
		move.l	d0,(a1)				;Success
1$		rts

	;***
	;Remove a segment from the resident list
	;a0 = segment
	;-> a0 is unchanged
	;***
RemPointerResident:
		lea		(ResidentSize,pc),a1
		bra.b		RemPointer

   ;***
   ;Remove a pointer from the global autoclear list
   ;a0 = pointer
	;-> a0 is unchanged
   ;***
RemPointerAlloc:
		lea		(AllAllocSize,pc),a1

   ;***
   ;Remove a pointer from a list
   ;a0 = pointer
	;a1 = pointer to list (pointer to PV memory block)
	;-> a0 is unchanged
   ;***
RemPointer:
		bsr		SearchPointer
		beq.b    1$
	;It is one of our own blocks
		move.l	a0,-(a7)
		movea.l	a1,a0
		sub.l		(4,a0),d0				;Offset to start removing
		moveq		#4,d1
		bsr		RemoveMem
		movea.l	(a7)+,a0
1$    rts

	;***
	;See if we know about an allocated memory block
	;a0 = ptr to memory block
	;-> d0 = ptr to ptr to memory block or 0 (flags)
	;-> a0 is unchanged
	;***
SearchAlloc:
		lea		(AllAllocSize,pc),a1

	;***
	;See if we know about an allocated memory block
	;a0 = ptr to memory block
	;a1 = pointer to list (pointer to PV memory block)
	;-> d0 = ptr to ptr to memory block or 0 (flags)
	;-> a0 and a1 are unchanged
	;***
SearchPointer:
		move.l	a1,-(a7)
		movea.l	(4,a1),a1				;Get pointer
1$		move.l	(a1)+,d0
		beq.b		2$
		cmp.l		a0,d0
		bne.b		1$
	;Found it !
		subq.l	#4,a1
		move.l	a1,d0
2$		movea.l	(a7)+,a1				;For flags
		rts

	;***
	;Function: allocate memory
	;a0 = (type,size)
	;-> d0 = pointer
	;***
FuncAlloc:
		bsr		GetNextByteE
		cmpi.b	#'S',d0
		beq.b		1$
		move.l	#MEMF_CLEAR,d2
		cmpi.b	#'C',d0
		bne.b		4$
	;Alloc memory in chip ram
		move.l	#MEMF_CLEAR+MEMF_CHIP,d2
4$		EVALE
		move.l	d2,d1
		bsr		AllocBlockReq
		HERReq
		bra.b		2$
1$		bsr		GetStringPer
		HERReq
2$		bsr		AddPointerAlloc
		beq.b		3$
		rts
3$		movea.l	d0,a0
		bsr		FreeBlock
		HERR

	;***
	;Function: is a block one of our allocated memory blocks
	;***
FuncIsAlloc:
		EVALE
		movea.l	d0,a0
		bra		SearchAlloc

	;***
	;Function: free memory
	;***
FuncFree:
		EVALE
		movea.l	d0,a0
		bsr      FreeBlock
		bra		RemPointerAlloc

	;***
	;Function: return size of memoryblock
	;a0 = cmdline
	;-> d0 = size
	;***
FuncGetSize:
		EVALE
	;Fall thru

	;***
	;Return size of a memoryblock
	;d0 = ptr to memoryblock
	;-> d0 = size
	;***
BlockSize:
		movea.l	d0,a0
		btst		#1,d0					;Multiple of 4 ?
		beq.b		1$
		subq.l	#2,a0
		moveq		#0,d0
		move.w	(a0),d0
		rts
1$		subq.l	#4,a0
		move.l	(a0),d0
		rts

	;***
	;Function: reallocate memory
	;a0 = (pointer,newsize)
	;-> d0 = new pointer
	;***
FuncReAlloc:
		EVALE								;Get pointer
		move.l	d0,d4
		EVALE								;Get new size
		movea.l	d4,a0
		move.l	d0,d2
		beq		FreeBlock
		cmpi.l	#65533,d2
		ble.b		1$
2$		ERROR		Only64KBlocks

1$		move.l	a0,d0
		btst		#1,d0
		beq.b		2$
		move.l	d2,d1
		movea.l	a0,a1
		bsr		ReAllocMemBlock
		beq.b		3$
	;Block has moved, now we must check our memory pool
		move.l	d0,-(a7)
		movea.l	d4,a0
		bsr		SearchAlloc
		beq.b		4$
		movea.l	d0,a0
		move.l	(a7),(a0)
4$		move.l	(a7)+,d0
3$		rts

	;***
	;Shrink a PV block (only for PV blocks less than 64 K)
	;This function is guaranteed to never fail and also guarantees
	;that the PV block will remain on the same position
	;d1 = new size (must be less than old size)
	;a1 = PV block (pointer after size)
	;***
ShrinkBlock:

	;***
	;ReAllocate a memory block
	;This function never returns if there is an error
	;d1 = new size (less than 64K)
	;a1 = pointer to memory block (after size)
	;-> d0 = pointer to new memory block (after size)
	;-> flags eq if block not moved
	;***
ReAllocMemBlock:
		movem.l	a1/d1-d2,-(a7)
		subq.l	#2,a1					;Go before size
		addq.l	#2,d1					;Increment new size
		moveq		#0,d0
		move.w	(a1),d0				;Get old size
		addq.l	#2,d0					;Increment old size
		moveq		#0,d2
		bsr		ReAlloc
		ERROReq	NotEnoughMemory
		movem.l	(a7)+,a1/d1-d2
		movea.l	d0,a0					;Pointer to new block
		move.w	d1,(a0)+				;Fill in new size
		move.l	a0,d0					;Pointer after size
		cmp.l		a1,d0					;Compare with old pointer after size
		rts

	;***
	;Special not enough memory warning in special cases
	;Flash the screen red
	;***
FlashRed:
		move.w	($dff180).l,d2
		move.w	#30000,d0
1$		move.w	#$0a00,($dff180)
		dbra		d0,1$
		move.w	d2,($dff180)
		rts

	;***
	;Store an integer in the rc variable
	;d0 = int
	;***
StoreRC:
		move.l	a1,-(a7)
		movea.l	(VarStorage),a1
		lea		(VOFFS_RC,a1),a1
		move.l	d0,(a1)
		movea.l	(a7)+,a1
		rts

	;***
	;Add a ptr to a memblock to the autoclear pool
	;This pool always contains less than 'MaxAutoClear' entries.
	;The last allocated entrie is cleared each time a new one is
	;entered. New elements are allocated at the end of the list.
	;This means that the first entry in the pool is the oldest entry.
	;This routine preserves all registers
	;d0 = ptr
	;-> Z flag is set if error
	;***
AddAutoClear:
		movem.l	d0-d2/a0-a1,-(a7)
		move.l	d0,d2
		moveq		#8,d0
		bsr		AllocClear
		beq.b		1$

	;Check if the oldest (the first in the list) autoclear entry should be removed
		move.w	(NumAutoClear,pc),d1
		cmp.w		(MaxAutoClear,pc),d1
		blt.b		2$

	;Yes, remove the oldest entry
		move.l	d0,-(a7)				;Remember pointer to new entry
		movea.l	(AutoClear,pc),a1	;Pointer to oldest entry
		movea.l	(4,a1),a0			;Pointer to element to free in entry
		bsr		FreeBlock
		lea		(AutoClear,pc),a0
		move.l	(a1),(a0)			;Pointer to next autoclear entry
		moveq		#8,d0
		bsr		FreeMem				;Free entry
		move.l	(a7)+,d0				;Restore pointer to new entry
		bra.b		3$

	;No, there is still room
2$		addq.w	#1,d1
		lea		(NumAutoClear,pc),a0
		move.w	d1,(a0)

	;d0 = pointer to new entry
3$		lea		(LastAutoClear,pc),a1
		movea.l	d0,a0					;Store pointer to entry in a0
		move.l	d2,(4,a0)				;Store pointer to memory in entry
		tst.l		(a1)
		bne.b		4$

	;There are no entries yet
		move.l	d0,(a1)				;Last autoclear is equal to this one
		lea		(AutoClear,pc),a1
		move.l	d0,(a1)				;First autoclear is equal to this one
		bra.b		5$

	;There are other entries
4$		movea.l	(a1),a0				;Get pointer to last entry
		move.l	d0,(a0)				;Store pointer to this entry to previous last entry
		move.l	d0,(a1)				;New last autoclear entry is equal to this one
5$		moveq		#1,d0					;Success, set flags
1$		movem.l	(a7)+,d0-d2/a0-a1
		rts

	;***
	;Clear the autoclear pool
	;***
ClearAutoClear:
		movem.l	d0-d1/a0-a2,-(a7)
		move.l	(AutoClear,pc),d0
		beq.b		1$
		movea.l	d0,a2
2$		movea.l	(4,a2),a0
		bsr		FreeBlock
		movea.l	a2,a1
		movea.l	(a2),a2
		moveq		#8,d0
		bsr		FreeMem
		move.l	a2,d0
		bne.b		2$
		lea		(AutoClear,pc),a0
		move.l	d0,(a0)+				;AutoClear
		move.l	d0,(a0)+				;LastAutoClear
		move.w	d0,(a0)+				;NumAutoClear
1$		movem.l	(a7)+,d0-d1/a0-a2
		rts

	;***
	;Binary search in a table
	;a0 = value to search
	;a1 = pointer to table (or to field in first element to check for)
	;d0 = size of table to search in
	;d1 = size of table element (8 or 16 or ... (power of 2))
	;-> d0 = ptr to element in list
	;-> a0 = search value (unchanged)
	;***
BinarySearch:
		movem.l	d2-d3,-(a7)
		move.l	d1,d2
		subq.l	#1,d2					;8,16 -> 7,15
		not.b		d2						;7,15 -> $f8,$f0
		move.l	d1,d3

3$		move.l	d0,d1
		lsr.l		#1,d0					;Div by two (binary search)
		and.b		d2,d0					;Make mult of 8 or 16
		cmp.l		d0,d1
		beq.b		2$
		cmpa.l	(0,a1,d0.l),a0
		beq.b		1$
		blt.b		3$
		tst.l		d0
		beq.b		1$
		adda.l	d0,a1
		sub.l		d0,d1
		move.l	d1,d0
		bra.b		3$

1$		add.l		a1,d0
		movem.l	(a7)+,d2-d3
		rts

2$		cmpa.l	(0,a1,d0.l),a0
		bge.b		1$
		sub.l		d3,d0					;Subtract size of element
		bra.b		1$

	;***
	;Add a string to a string pool
	;a0 = ptr to string
	;a1 = ptr to pool
	;-> d0 = pos relative to start pool + 1 (or 0, flags)
	;***
AddString:
		movem.l	d1-d2/a0-a2,-(a7)
		movea.l	a0,a2					;a2 = string
1$		tst.b		(a0)+					;compute length
		bne.b		1$
		move.l	a0,d0
		sub.l		a2,d0					;d0 = length
		movea.l	a1,a0					;a0 = ptr to pool
		move.l	(a0),d2				;Get logical size of block (or real size for normal)
		add.l		d2,d0					;adjust logical size
		bsr		ReAllocMem
		beq.b		3$
		movea.l	d2,a0					;Old logical size of pool
		adda.l	d0,a0					;Add pointer to start of memoryblock = ptr to string
2$		move.b	(a2)+,(a0)+			;Copy string
		bne.b		2$
		move.l	d2,d0					;Get size
		addq.l	#1,d0
3$		movem.l	(a7)+,d1-d2/a0-a2
		rts

	;***
	;Remove some memory from a memory block (ReAllocMem format)
	;a0 = ptr to memblock
	;d0 = offset to start removing
	;d1 = size to remove
	;***
RemoveMem:
		movem.l	a0/d1,-(a7)
		movea.l	(4,a0),a1
		adda.l	d0,a1
		sub.l		(a0),d0
		neg.l		d0
		sub.l		d1,d0
		movea.l	a1,a0
		adda.l	d1,a0
		CALLEXEC	CopyMem
		movem.l	(a7)+,a0/d0
		sub.l		(a0),d0
		neg.l		d0
		bra		ReAllocMem

	;***
	;Append some memory to a memory block (ReAllocMem format)
	;a0 = ptr to memblock
	;d1 = size to insert
	;-> flags if error
	;***
AppendMem:
		move.l	(a0),d0				;Get size of memoryblock

	;***
	;Insert some memory in a memory block (ReAllocMem format)
	;a0 = ptr to memblock
	;d0 = offset to insert
	;d1 = size to insert
	;-> a0/d0-d1 are unchanged
	;-> flags if error
	;***
InsertMem:
		movem.l	a0/d0-d1,-(a7)
		move.l	(a0),d0				;Get logical size
		add.l		d1,d0					;Add new size to insert
		bsr		ReAllocMem			;Adjust memoryblock to reflect new size
		beq.b		1$
	;No error
		movem.l	(a7),a0/d0-d1
		movea.l	(4,a0),a1			;Get pointer to block
		adda.l	d0,a1					;Add offset
		sub.l		(a0),d0
		neg.l		d0						;Compute logsize-offset
		sub.l		d1,d0					;logsize-offset-insertsize = #bytes to move
		beq.b		3$
	;Yes, we must move
		movea.l	a1,a0					;Get ptr to first byte to move
		adda.l	d1,a1					;Get ptr to destination for first byte
		adda.l	d0,a0					;Point to end (backwards move)
		adda.l	d0,a1					;Point to end (backwards move)
2$		move.b	-(a0),-(a1)
		subq.l	#1,d0
		bne.b		2$
3$		moveq		#1,d0
1$		movem.l	(a7)+,a0/d0-d1
		rts

	;***
	;Alloc new string, and copy string there
	;a0 = ptr to null terminated string
	;-> d0 = new string space (pts after len) (or 0, flags if error)
	;***
AllocStringInt:
		movea.l	a0,a1
1$		tst.b		(a1)+
		bne.b		1$
		move.l	a1,d0
		sub.l		a0,d0
		move.w	d0,-(a7)
		addq.w	#2,d0
		move.l	a0,-(a7)
		bsr		AllocClear
		bne.b		3$
		movea.l	(a7)+,a0
		lea		(2,a7),a7
		moveq		#0,d1					;Failure
		rts
3$		movea.l	d0,a1
		movea.l	(a7)+,a0
		move.w	(a7)+,(a1)+			;Store len
		move.l	a1,d0
2$		move.b	(a0)+,(a1)+			;Store string
		bne.b		2$
		moveq		#1,d1					;Success
		rts

	;***
	;Alloc block
	;d0 = size
	;-> d0 = new block (or 0, flags if error)
	;***
AllocBlockInt:
		move.l	#MEMF_CLEAR,d1

	;***
	;Alloc block with requirements
	;d0 = size
	;d1 = requirements
	;-> d0 = new block (or 0, flags if error)
	;***
AllocBlockReq:
		cmpi.l	#65533,d0
		bgt.b		1$
		move.w	d0,-(a7)
		addq.w	#2,d0
		bsr		AllocRClear
		bne.b		3$
		lea		(2,a7),a7
		moveq		#0,d0					;Failure
		rts
3$		movea.l	d0,a0
		move.w	(a7)+,(a0)+			;Store len
2$		move.l	a0,d0					;Success
		rts
	;Block is bigger than 64K
1$		move.l	d0,-(a7)
		addq.l	#4,d0
		bsr		AllocRClear
		bne.b		4$
		lea		(4,a7),a7
		moveq		#0,d0					;Failure
		rts
4$		movea.l	d0,a0
		move.l	(a7)+,(a0)+			;Store len
		bra.b		2$

	;***
	;Free a block
	;a0 = ptr to block (with preceding size) (may be zero)
	;-> a0 = original pointer
	;***
FreeBlock:
		movem.l	d0-d1/a0-a1,-(a7)
		move.l	a0,d0
		beq.b		3$
		btst		#1,d0					;Multiple of 4 ?
		beq.b		1$
		subq.l	#2,a0
		movea.l	a0,a1
		moveq		#0,d0
		move.w	(a0),d0
		addq.w	#2,d0
2$		bsr		FreeMem
3$		movem.l	(a7)+,d0-d1/a0-a1
		rts
	;Block is bigger than 64K
1$		subq.l	#4,a0
		movea.l	a0,a1
		move.l	(a0),d0
		addq.l	#4,d0
		bra.b		2$

	;***
	;Virtually print a line in a buffer
	;a0 = ptr to line
	;***
VirtualPrint:
		movem.l	a1-a2/d0-d2,-(a7)
		movea.l	a0,a2					;Remember pointer to line

	;StrLen
1$		tst.b		(a0)+					;Compute length of line
		bne.b		1$

		move.l	a0,d0
		sub.l		a2,d0					;d0 = length + 1

6$		move.w	d0,d2					;d2 = length of string + 1 (including '\0')
		addq.l	#6,d0					;Ptr to next and len
		bsr		AllocClear

	;If not enough memory we simply print nothing
		beq.b		5$

	;Success
		movea.l	d0,a0					;Pointer to memory
		lea		(VPrintFirst,pc),a1
		lea		(6,a0),a0			;Skip ptr to next and len
		move.w	d2,d1					;Length + 1
		bra.b		7$

	;Copy string (including \0 at end)
2$		move.b	(a2)+,(a0)+
7$		dbra		d1,2$

	;Assume this is the first line in the VirtualPrint buffer
		tst.l		(a1)
		beq.b		3$

	;The assumption was not true, there are already lines in the
	;VirtualPrint buffer
		movea.l	(VPrintLast,pc),a1

3$		move.l	d0,(a1)				;New first element or put after last element
		lea		(VPrintLast,pc),a1
		move.l	d0,(a1)				;New last element
		movea.l	d0,a0
		move.w	d2,(4,a0)			;Initialize len ('next' is already set to 0)

	;The end
4$		movem.l	(a7)+,a1-a2/d0-d2
		rts

	;Fatal error
5$		bsr		FlashRed
		bra.b		4$

	;***
	;Print the virtual buffer
	;***
PrintVirtualBuf:
		move.l	(VPrintFirst,pc),d0
		beq.b		2$
1$		movea.l	d0,a1
		lea		(6,a1),a0
		PRINT
		move.l	(a1),d0
		bne.b		1$
2$		rts

	;***
	;Clear the virtual buffer
	;***
ClearVirtual:
		move.l	a2,-(a7)
		movea.l	(VPrintFirst,pc),a2
1$		move.l	a2,d0
		beq.b		2$
		moveq		#0,d0
		move.w	(4,a2),d0				;get size
		addq.w	#6,d0
		movea.l	a2,a1
		movea.l	(a2),a2
		bsr		FreeMem
		bra.b		1$
2$		lea		(VPrintFirst,pc),a0
		clr.l		(a0)
		lea		(VPrintLast,pc),a0
		clr.l		(a0)
		movea.l	(a7)+,a2
		rts

	;***
	;Allocate memory with clear
	;d0 = size
	;-> d0 = ptr to block (flags are set)
	;***
AllocClear:
		move.l	d1,-(a7)
		move.l	#MEMF_CLEAR,d1
		bsr		AllocRClear
		movem.l	(a7)+,d1				;For flags
		rts

	;***
	;Allocate memory with requirements
	;d0 = size
	;d1 = req
	;-> d0 = ptr to block (flags are set)
	;***
AllocRClear:
		bsr		AllocMem
		SERReq	NotEnoughMemory
		tst.l		d0
		rts

	;***
	;Construct a node
	;d0 = size
	;a0 = ptr to name to copy in LN_NAME (may be zero)
	;-> a0 = ptr to node (or 0, flags if error)
	;***
MakeNodeInt:
		movem.l	a1-a3/d1-d2,-(a7)
		movea.l	a0,a2
		move.l	d0,d2
		bsr		AllocClear
		movea.l	d0,a3
		beq.b		2$						;Failure
		move.l	a2,d0
		beq.b		1$
		movea.l	a2,a0
		bsr		AllocStringInt
		bne.b		1$
		movea.l	a3,a1
		move.l	d2,d0
		bsr		FreeMem
		moveq		#0,d0					;Failure
		bra.b		2$
1$		move.l	d0,(LN_NAME,a3)
		clr.b		(LN_PRI,a3)
		movea.l	a3,a0
		moveq		#1,d0					;Success
2$		movem.l	(a7)+,a1-a3/d1-d2
		rts

	;***
	;Reallocate memory
	;a0 = ptr to memblock ( (a0) is length of block, 4(a0) is ptr to block )
	;d0 = new size (if zero, block is freed)
	;-> a0 = ptr to the same memblock
	;-> d0 = 0 if no success, else ptr to memory ( 4(a0) ) (flags)
	;***
ReAllocMem:
		movem.l	a0/d0/d2,-(a7)

		move.l	(4,a0),d1
		beq.b		3$

		move.l	d0,d1					;New size
		move.l	(a0),d0				;Get old size
		moveq		#0,d2					;No attributes
		movea.l	(4,a0),a1			;Pointer to memory
		bsr		ReAlloc

		movem.l	(a7)+,a0/d1/d2
		tst.l		d1						;If d1 != 0 and d0 == 0 there was a real
											;memory allocation error
											;In that case we don't overwrite the old
											;values in the memblock since these are not
											;freed
		beq.b		1$
		tst.l		d0
		beq.b		2$

1$		move.l	d1,(a0)				;Store new size
		move.l	d0,(4,a0)			;Store new pointer
2$		rts

	;There is nothing allocated at this moment
3$		moveq		#0,d1
		bsr		AllocMem
		movem.l	(a7)+,a0/d1/d2
		bra.b		1$

;---------------------------------------------------------------------------
;Variables
;---------------------------------------------------------------------------

	;***
	;Start of MemoryBase
	;***
MemoryBase:

AutoClear:		dc.l	0				;List with automatic clear memory
LastAutoClear:	dc.l	0				;Pointer to last autoclear entry
NumAutoClear:	dc.w	0				;Current number of entries in above list
MaxAutoClear:	dc.w	10				;Maximum number of entries in above list (>=2)


	;Memory block for the global autoclear list
AllAllocSize:	dc.l	0				;Logical size
AllAllocPtr:	dc.l	0				;made by user (with alloc func)
					dc.l	0				;OBSOLETE

	;Tag list format :
	;	Long Address
	;	Long Bytes
	;	Word Flags
	;	Word Type
	;	Long notused (or structure pointer)
TagSize:			dc.l	0				;Tag list used by View command
TagPtr:			dc.l	0

TagNum:			dc.l	0				;Default tag list (0..15)

TagListList:	dc.l	0,0			;16 tag lists
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0
					dc.l	0,0

QTressHold:		dc.l	256			;OBSOLETE

MemoryPointer:	dc.l	0				;Memory ptr (for list memory)
MemorySPointer:dc.l	0				;Memory ptr for next search
MemRemain:		dc.l	0				;Remain memory to search
MemSearch:		dc.l	0				;Ptr to string to search
					dc.b	0				;OBSOLETE
					dc.b	0				;OBSOLETE

	;Memory block for the resident list
ResidentSize:	dc.l	0				;Logical size
ResidentPtr:	dc.l	0				;made by user (with resident command)
					dc.l	0				;OBSOLETE

	;Everything for virtual print
VPrintFirst:	dc.l	0
VPrintLast:		dc.l	0
VPrint:			dc.b	0				;If true Print will print virtual

					dc.b	0
MemoryBytes:	dc.l	320			;Last number of bytes used with 'memory' or
											;'view'
MemoryLines:	dc.l	20				;Last number of lines used with 'unasm',

	;The pointer to the first memory region
FirstRegion:	dc.l	0

	;***
	;End of MemoryBase
	;***

	;Flags for 'MakeBitField'
AddTagFlags:
		dc.b		"WRIPF",0			;WRITE, READ, IGNORE, PRINT, FREEZE

TagWarning:		dc.b	"Warning! Unknown structure types have been changed to LA!",10,0
bftf_WPROTECT:	dc.b	"WRITE",0
bftf_RPROTECT:	dc.b	"READ",0
bftf_IGNORE:	dc.b	"IGNORE",0
bftf_PPRINT:	dc.b	"PRINT",0
bftf_FREEZE:	dc.b	"FREEZE",0

;FormatRegion:	dc.b	"%08lx F:%-8ld T:%-8ld (%ld)",10,0
FormatRegion:
		FF		X_,0,str,"F:",lD_,8,str,"T:"
		FF		lD_,8,str,"(",D,0,str,")"
		FF		nlend,0

	EVEN
	;Bit fields
bfTagFlags:		dc.l	$0001,$0001,bftf_WPROTECT,$0002,$0002,bftf_RPROTECT
					dc.l	$0004,$0004,bftf_IGNORE,$0008,$0008,bftf_PPRINT
					dc.l	$0010,$0010,bftf_FREEZE
					dc.l	0

TypeString:		dc.w	0
	;Tag types (must be EVEN!)
TagStrings:
TagByteAscii:	dc.w	'BA'
TagWordAscii:	dc.w	'WA'
TagLongAscii:	dc.w	'LA'
TagAscii:		dc.w	'AS'
TagCode:			dc.w	'CO'
TagStruct:		dc.w	'ST'
					dc.w	0

	;Tag routines
TagRoutines:
	dc.l	View1ByteAscii,16
	dc.l	View1WordAscii,16
	dc.l	View1LongAscii,16
	dc.l	View1Ascii,64
	dc.l	View1Code,0
	dc.l	View1Struct,0

	END
