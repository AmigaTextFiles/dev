	IFND	BETTERSTRING_MCC_I
BETTERSTRING_MCC_I	SET	1

** $VER: BetterString_mcc.h V11.0 (28-Sep-97)
** Copyright © 1997 Allan Odgaard. All rights reserved.
**
** Assembler version by Ilkka Lehtoranta (29-Nov-99)

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC

;#define   MUIC_BetterString     "BetterString.mcc"
;#define   BetterStringObject    MUI_NewObject(MUIC_BetterString

MUIA_BetterString_Columns	EQU	$ad001005
MUIA_BetterString_SelectSize	EQU	$ad001001
MUIA_BetterString_StayActive	EQU	$ad001003
MUIM_BetterString_ClearSelected EQU	$ad001004
MUIM_BetterString_FileNameStart	EQU	$ad001006
MUIM_BetterString_Insert	EQU	$ad001002

MUIV_BetterString_Insert_StartOfString	EQU	$00000000
MUIV_BetterString_Insert_EndOfString	EQU	$fffffffe
MUIV_BetterString_Insert_BufferPos	EQU	$ffffffff

MUIR_BetterString_FileNameStart_Volume	EQU	$ffffffff

;struct MUIP_BetterString_ClearSelected {ULONG MethodID; };
;struct MUIP_BetterString_FileNameStart {ULONG MethodID; STRPTR buffer; LONG pos; };
;struct MUIP_BetterString_Insert	{ULONG MethodID; STRPTR text; LONG pos; };

	ENDC	; BETTERSTRING_MCC_I
