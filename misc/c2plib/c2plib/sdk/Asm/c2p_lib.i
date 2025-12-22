		IFND LIBRARIES_C2P_LVO_I
LIBRARIES_C2P_LVO_I	SET	1

		XDEF	_LVOC2P_AllocMem
		XDEF	_LVOC2P_CopyMem
		XDEF	_LVOC2P_FreeMem
		XDEF	_LVOC2P_CreateContext
		XDEF	_LVOC2P_InitializeContext
		XDEF	_LVOC2P_DestroyContext
		XDEF	_LVOC2P_GetContextParameter
		XDEF	_LVOC2P_SetContextParameter
		XDEF	_LVOC2P_GetContextIndexedParameter
		XDEF	_LVOC2P_SetContextIndexedParameter
		XDEF	_LVOC2P_Chunky2Planar
		XDEF	_LVOC2P_WritePixel
		XDEF	_LVOC2P_GetSystemParameter
		XDEF	_LVOC2P_GetSystemIndexedParameter
		XDEF	_LVOC2P_CreateBitMap
		XDEF	_LVOC2P_DestroyBitMap

_LVOC2P_AllocMem            	EQU	-30
_LVOC2P_CopyMem             	EQU	-36
_LVOC2P_FreeMem             	EQU	-42
_LVOC2P_CreateContext       	EQU	-48
_LVOC2P_InitializeContext   	EQU	-54
_LVOC2P_DestroyContext      	EQU	-60
_LVOC2P_GetContextParameter 	EQU	-66
_LVOC2P_SetContextParameter 	EQU	-72
_LVOC2P_GetContextIndexedParameter	EQU	-78
_LVOC2P_SetContextIndexedParameter	EQU	-84
_LVOC2P_Chunky2Planar       	EQU	-90
_LVOC2P_WritePixel          	EQU	-96
_LVOC2P_GetSystemParameter  	EQU	-102
_LVOC2P_GetSystemIndexedParameter	EQU	-108
_LVOC2P_CreateBitMap        	EQU	-114
_LVOC2P_DestroyBitMap       	EQU	-120

		ENDC
