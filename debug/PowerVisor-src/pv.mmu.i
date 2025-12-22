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
BITSize68040	equ	8

PRT_NONE			equ	0		;No protection
PRT_WPROTECT	equ	1		;w
PRT_RPROTECT	equ	2		;r
PRT_RWPROTECT	equ	3		;rw = PRT+RPROTECT+PRT_WPROTECT


	;Maximum number of bus error remembered in the bus error table
MAXBERR			equ	100

	;Structure for a recorded bus error in the bus error table
	;('BusErrTable')
 STRUCTURE BusError,0
	APTR		berr_FaultAddress		;Address where bus error occured
	APTR		berr_Task				;Offending task
	APTR		berr_PC					;Program counter where the error occured
	APTR		berr_SP					;Stack pointer for offending program
	ULONG		berr_Value				;Value for write
	ULONG		berr_Flags				;Flags such as R/W and SIZE (see below)
	ULONG		berr_pad0				;For future extension
	ULONG		berr_pad1				;For future extension (also to make it 32 bytes big)
	LABEL		berr_SIZE

berrB_Write		equ	0
berrB_Read		equ	1
berrB_Size1		equ	2
berrB_Size2		equ	3

berrF_Write		equ	1
berrF_Read		equ	2
berrF_Size1		equ	4
berrF_Size2		equ	8

	;This structure describes what should be done with a tag list
	;and the memory protection system
 STRUCTURE TagListDesc,0
	APTR		tld_Task					;Task for this tag list (if NULL, this
											;tag list is used for global memory
											;protection)
											;Value is equal to ~0 (or -1) if this tag
											;list is not used for memory protection
											;purposes
	APTR		tld_DebugNode			;Debug node for this tag list (if not NULL,
											;tld_Task may not be equal to NULL but must
											;be equal to the corresponding debug task)
	LABEL		tld_SIZE

