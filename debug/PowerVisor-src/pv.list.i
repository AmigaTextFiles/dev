	;***
	;Node definition for the structure interpretor
	;***
 STRUCTURE StructInter,LN_SIZE
	ULONG		str_MatchWord			;Contains 'PVSD'
	APTR		str_Strings				;pointer to actual strings
	APTR		str_InfoBlock			;InfoBlock (PowerVisor memoryblock)
	UWORD		str_Length				;Length of structure
	LABEL		str_SIZE

	;***
	;Definition for one entry for the structure (see str_InfoBlock above)
	;***
 STRUCTURE StructEntry,0
	APTR		sen_Name					;Pointer to the name for this entry (in str_Strings)
	UBYTE		sen_Type					;Type
	UBYTE		sen_Size					;Size of array or inline string
	UWORD		sen_Offset				;Offset in structure
	LABEL		sen_SIZE

SEN_BYTE			equ	0
SEN_WORD			equ	1
SEN_LONG			equ	2
SEN_STRING		equ	3
SEN_OBJECT		equ	4
SEN_INLINESTR	equ	5
SENF_ARRAY		equ	64
SENF_BPTR		equ	128
SENB_ARRAY		equ	6
SENB_BPTR		equ	7

	;***
	;Structure definition for a InfoBlock (don't confuse with InfoBlock
	;in previous structure!)
	;***
 STRUCTURE	InfoBlock,0
	ULONG		in_Prompt				;Prompt
	UBYTE		in_Item					;Item number
	UBYTE		in_Control				;Control byte
	LABEL		in_Routine				;Routine to goto base list
	APTR		in_Base					;Base ptr
	UWORD		in_Offset				;Offset to add to Base
	LABEL		in_InfoList				;Ptr to InfoList
	APTR		in_Next					;Next routine
	APTR		in_Header				;Header
	APTR		in_Format				;Format string
	ULONG		in_Arg					;Argument for 'list'
	UBYTE		in_pad					;Must be zero
	UBYTE		in_IsList				;If true, in_Info is a ptr to a InfoList
	APTR		in_Info					;Ptr to info routine
	APTR		in_PrintLine			;Ptr to print line routine
	UWORD		in_Name					;Offset for name in structure
	LABEL		in_SIZE

	;Macros for InfoLists
DEFIN	macro	*
			dc.l	H\2
			dc.b	\1
			dc.b	0
			ifnc	'\3',''
				dc.w	\3
			endc
			ifc	'\3',''
				dc.w	\2
			endc
		endm
DEFII	macro	*
		DEFIN	4,\1,\2
		endm
DEFBI	macro	*
		DEFIN	0,\1,\2
		endm
DEFWI	macro	*
		DEFIN	1,\1,\2
		endm
DEFLI	macro	*
		DEFIN	2,\1,\2
		endm
DEFSI	macro	*
		DEFIN	3,\1,\2
		endm
DEFlI	macro	*
		DEFIN	128+2,\1,\2
		endm
DEFsI	macro	*
		DEFIN	128+3,\1,\2
		endm

TC_TRAPALLOC	equ	tc_ETask
TC_TRAPABLE		equ	tc_ETask+2
