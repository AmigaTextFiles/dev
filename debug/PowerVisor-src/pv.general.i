	;***
	;Node definition for crashed tasks
	;***
 STRUCTURE CrashNode,LN_SIZE
	APTR		cn_Task					;Crashed task
	ULONG		cn_TrapNumber			;Trap number
	ULONG		cn_2ndInfo				;Second information (with alert)
	UBYTE		cn_Guru					;0 for trap, 1 if guru, 2 if stack fail, 3 for BERR
	UBYTE		cn_pad
	APTR		cn_SP						;Pointer to stack
	ULONG		cn_PC						;Start of stackframe
	UWORD		cn_SR						;Original statusregister
	STRUCT	cn_Registers,15*4		;All registers
	LABEL		cn_EndRegisters
	LABEL		cn_SIZE

	;***
	;Node definition for the fd-files
	;***
 STRUCTURE FDFileNode,LN_SIZE
 	APTR		fd_Library				;Pointer to the corresponding library
	UWORD		fd_Bias					;Bias factor from fd-file
	ULONG		fd_BlockSize			;Size of pointer block
	APTR		fd_Block					;Pointer block
	ULONG		fd_StringSize			;Size of string block
	APTR		fd_String				;Pointer to strings
	UWORD		fd_NumFuncs				;Number of library functions
	LABEL		fd_SIZE

	;***
	;Node definition for the function monitor
	;***
 STRUCTURE FuncMonNode,LN_SIZE
	APTR		fm_Library
	UWORD		fm_Offset
	APTR		fm_Task					;If zero all tasks, else specified task
	LONG		fm_Count					;Function usage count
	APTR		fm_CodePtr				;Pointer to code
	LONG		fm_CodeSize				;Size of code
	APTR		fm_OldFunction			;Old function to restore later
	UWORD		fm_Type					;See below
	UWORD		fm_LastTaskNr			;Number of the next last-task position
											;in table below
	STRUCT	fm_LastTask,8*4		;The 8 last tasks using this function
	STRUCT	fm_Registers,8*14*4	;All registers (d0-d7/a0-a5)
	APTR		fm_IDCCommand			;Ptr to IDC command (if FM_EXEC)
	LABEL		FM_SIZE

	;***
	;Structure definition for the tracker
	;***
 STRUCTURE TrackNode,0
	APTR		trk_Next					;Next track node
	APTR		trk_Prev					;Previous track node
	APTR		trk_Ptr					;Pointer to data (memory, library, signal number received)
	ULONG		trk_Size					;Size of data (size, version, signal number requested)
	APTR		trk_PC					;Program counter
	UBYTE		trk_Type					;Type
	UBYTE		trk_pad0					;Must remain padding!!!!!!
	UBYTE		trk_pad1					;Must remain padding!!!!!!
	UBYTE		trk_pad2					;Must remain padding!!!!!!
	LABEL		trk_SIZE

TRK_ALLOCMEM	equ	0
TRK_OPENLIB		equ	1
TRK_ALLOCVEC	equ	2
TRK_ALLOCSIG	equ	3
TRK_CREATEMP	equ	4
TRK_CREATEIO	equ	5
TRK_LOCK			equ	6
TRK_OPEN			equ	7
TRK_ALLOCRAST	equ	8


FM_NORM		equ	0					;Normal monitor
FM_LED		equ	1					;Ledmonitor function
FM_FULL		equ	2					;Include registerinformation
FM_COLD		equ	4					;Freeze task when there (niy)
FM_EXEC		equ	8					;Execute IDC command
FM_SCRATCH	equ	16					;Make scratch registers dirty

