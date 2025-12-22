	IFND	MUI_NFLOATTEXT_MCC_I
MUI_NFLOATTEXT_MCC_I	SET	1

*  NFloattext.mcc (c) Copyright 1996 by Gilles Masson
*  Registered MUI class, Serial Number: 1d51     		       0x9d5100a1 to 0x9d5100aF
*  *** use only YOUR OWN Serial Number for your public custom class ***
*  NFloattext_mcc.h
*
*  Assembler version by Ilkka Lehtoranta (29-Nov-99)

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

	IFND	MUI_NLISTVIEW_MCC_I
	INCLUDE	"MUI/NListview_mcc.i"
	ENDC

;#define MUIC_NFloattext "NFloattext.mcc"
;#define NFloattextObject MUI_NewObject(MUIC_NFloattext


* Attributes *

MUIA_NFloattext_Text		EQU	$9d5100a1	; GM  isg STRPTR
MUIA_NFloattext_SkipChars	EQU	$9d5100a2	; GM  isg char *
MUIA_NFloattext_TabSize		EQU	$9d5100a3	; GM  isg ULONG
MUIA_NFloattext_Justify		EQU	$9d5100a4	; GM  isg BOOL
MUIA_NFloattext_Align		EQU	$9d5100a5	; GM  isg LONG

MUIM_NFloattext_GetEntry	EQU	$9d5100aF	; GM
;struct  MUIP_NFloattext_GetEntry	    { ULONG MethodID; LONG pos; APTR *entry; };


	ENDC	; MUI_NFLOATTEXT_MCC_I
