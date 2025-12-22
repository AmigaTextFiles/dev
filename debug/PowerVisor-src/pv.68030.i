	addsym
	debug
	newsyntax
	strict
	times

SysBase			equ	4
_SysBase			equ	4

NEWLINE	macro
				trap		#4
			endm

PRINT		macro
				trap		#6
			endm

CALL		macro
			jsr		(_LVO\1,a6)
			endm

CALLEXEC	macro
			movea.l	(SysBase).w,a6
			jsr		(_LVO\1,a6)
			endm

	;Bit, clear msg, set msg
TESTBIT	macro	*
		dc.b		BIT\3
		dc.b		\1
		dc.l		Msg\2
		endm

BITNotSet		equ	0
BITDisabled		equ	2
BITNo				equ	4
BITUserMode		equ	6

PRT_NONE			equ	0		;No protection
PRT_WPROTECT	equ	1		;w
PRT_RPROTECT	equ	2		;r
PRT_RWPROTECT	equ	3		;rw = PRT+RPROTECT+PRT_WPROTECT

	;***
	;Node definition for 68030 MMU state structure
	;***
 STRUCTURE MMUstate,0
	;MMU registers
		STRUCT	mmu_RegCRP,8
		STRUCT	mmu_RegSRP,8
		ULONG		mmu_RegTC
		ULONG		mmu_RegTT0
		ULONG		mmu_RegTT1

	;68030 registers
		ULONG		mmu_RegMSP
		ULONG		mmu_RegISP
		ULONG		mmu_RegUSP
		ULONG		mmu_RegSFC
		ULONG		mmu_RegDFC
		ULONG		mmu_RegVBR
		ULONG		mmu_RegCACR
		ULONG		mmu_RegCAAR

	;MMU table characteristics
		UWORD		mmu_PageSize
		UWORD		mmu_ISS
		UWORD		mmu_TIA
		UWORD		mmu_TIB
		UWORD		mmu_TIC
		UWORD		mmu_TID
		UWORD		mmu_LoLimit			;Lower limit
		UWORD		mmu_UpLimit			;Upper limit (or -1 if no upper limit)
		UWORD		mmu_LogBits			;Nr of bits for logical address
		ULONG		mmu_MaxLogAddr		;Maximum logical address

	;Values used during tree scanning
		UWORD		mmu_DT				;Value of DT field (0, 1, 2 or 3)
		UWORD		mmu_flags			;Current flags
		APTR		mmu_Entry			;Entry address (physical address if we are dealing with a page,
											;address of next level descriptor if we are dealing with a table descriptor)
		APTR		mmu_Descriptor		;Address+4 of current descriptor
		UWORD		mmu_Level			;Current level
		APTR		mmu_LogAddress		;Logical address at this moment
		ULONG		mmu_TotLogBytes	;Total representative bytes

	;Some PowerVisor routines
		APTR		mmu_PrintRealHex
		APTR		mmu_PrintRealHexNL

	;For the memory protection system
		ULONG		mmu_TableSize		;Size of the MMU table
		APTR		mmu_Table			;Pointer to the MMU table
		APTR		mmu_Root				;Pointer to the real root (is mmu_Table plus alignment)
		UWORD		mmu_Installed		;If 1 the MMU table is installed
		STRUCT	mmu_OrigRegCRP,8
		STRUCT	mmu_OrigRegSRP,8
		ULONG		mmu_OrigRegTC
		ULONG		mmu_OrigRegTT0
		ULONG		mmu_OrigRegTT1
		LABEL		mmu_SIZE

