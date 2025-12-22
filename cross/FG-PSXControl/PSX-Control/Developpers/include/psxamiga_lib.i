*********************************************************************************************************
*
* PSXAmiga_lib.i
*
*********************************************************************************************************

_LVOTransfer2PSX	EQU	-30
_LVOTransferFromPSX	EQU	-36
_LVOSetCPUReg		EQU	-42
_LVOPSXExecute          EQU     -48

PSXAMINAME	MACRO
		dc.b	'psxamiga.library',0
		ENDM

CALLPSX		MACRO
		move.l	_PSXBase,a6
		jsr	_LVO\1(a6)
		ENDM

