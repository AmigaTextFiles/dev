	;Tag types
TAG_BYTEASCII	equ	1
TAG_WORDASCII	equ	2
TAG_LONGASCII	equ	3
TAG_ASCII		equ	4
TAG_CODE			equ	5
TAG_STRUCT		equ	6

	;***
	;Definition for a tag
	;***
 STRUCTURE StructTag,0
	APTR		tag_Address
	ULONG		tag_Size
	UWORD		tag_Flags
	UWORD		tag_Type
	APTR		tag_Structure
	LABEL		tag_SIZE

BTAG_WPROTECT	equ	0		;w
BTAG_RPROTECT	equ	1		;r
BTAG_IGNORE		equ	2		;i
BTAG_PPRINT		equ	3		;p
BTAG_FREEZE		equ	4		;f

FTAG_WPROTECT	equ	1
FTAG_RPROTECT	equ	2
FTAG_IGNORE		equ	4
FTAG_PPRINT		equ	8
FTAG_FREEZE		equ	16

	;***
	;Definition for a PowerVisor memory header
	;Used by Allocate, Deallocate and Reallocate
	;Almost the same as an Exec memory header
	;WARNING! This structure must be a multiple of 8 bytes!!!
	;***
 STRUCTURE PVMemHeader,0
	APTR		pvmh_Next
	APTR		pvmh_Prev
	APTR		pvmh_First				;Pointer to first free memory chunk
	ULONG		pvmh_Free				;Total free in memory block
	APTR		pvmh_Lower				;Pointer to memory block
	ULONG		pvmh_Size				;Total size of memory block
	ULONG		pvmh_Attributes		;Attributes for this region (MEMF_CHIP, ...)
	ULONG		pvmh_pad0
	LABEL		pvmh_SIZE

REGIONSIZE	equ	8192
