;Easylife Library V1.01 - Vector Offsets & Macros.
;
;
;All Easylife function may trash registers D0/D1/A0/A1, but all others
;Are preserved.
;

_LVOELST_Lookup		equ	-30
_LVOELST_GetBank	equ	-36
_LVOELST_Free		equ	-42
_LVOELST_Allocate	equ	-48
_LVOELST_GetElement	equ	-54
_LVOELST_SetElement	equ	-60
_LVOELST_StrCmp		equ	-66
_LVOELST_FreeBlocks	equ	-72
_LVOELST_GraphScan	equ	-78
_LVOELST_GraphScanEnd	equ	-84
_LVOELST_LoadGraph	equ	-90
_LVOELST_SaveGraph	equ	-96
_LVOELST_RelocateTable	equ	-102
_LVOELST_FreeGraph	equ	-108



CALLEL	MACRO
	movem.l	a3-6,-(sp)
	move.l	_EasyBaaase,a6
	jsr	_LVO\1(a6)
	movem.l	(sp)+,a3-6
	ENDM
	
EASYNAME	MACRO
		dc.b	"easylife.library",0
		EVEN
		ENDM

EASYLIFEVMIN		equ	1
EASYLIFEREVISION	equ	1
