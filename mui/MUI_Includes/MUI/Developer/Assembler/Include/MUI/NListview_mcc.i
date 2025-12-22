	IFND	MUI_NLISTVIEW_MCC_I
MUI_NLISTVIEW_MCC_I	SET	1

*  NListview.mcc (c) Copyright 1996 by Gilles Masson
*  Registered MUI class, Serial Number: 1d51     		       0x9d510020 to 0x9d51002F
*  *** use only YOUR OWN Serial Number for your public custom class ***
*  NListview_mcc.h
*
*  Assembler version by Ilkka Lehtoranta (29-Nov-99)

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

	IFND	MUI_NLIST_MCC_I
	INCLUDE	"MUI/NList_mcc.i"
	ENDC

;#define MUIC_NListview "NListview.mcc"
;#define NListviewObject MUI_NewObject(MUIC_NListview


* Attributes *

MUIA_NListview_NList		EQU	$9d510020	; GM  i.g Object *

MUIA_NListview_Vert_ScrollBar	EQU	$9d510021	; GM  isg LONG
MUIA_NListview_Horiz_ScrollBar	EQU	$9d510022	; GM  isg LONG
MUIA_NListview_VSB_Width	EQU	$9d510023	; GM  ..g LONG
MUIA_NListview_HSB_Height	EQU	$9d510024	; GM  ..g LONG

	ENDASM
MUIV_Listview_ScrollerPos_Default	EQU	0
MUIV_Listview_ScrollerPos_Left		EQU	1
MUIV_Listview_ScrollerPos_Right		EQU	2
MUIV_Listview_ScrollerPos_None		EQU	3
	ASM

MUIM_NListview_QueryBeginning	EQU	MUIM_NList_QueryBeginning	; obsolete

MUIV_NListview_VSB_Always	EQU	1
MUIV_NListview_VSB_Auto		EQU	2
MUIV_NListview_VSB_FullAuto	EQU	3
MUIV_NListview_VSB_None		EQU	4
MUIV_NListview_VSB_Default	EQU	5
MUIV_NListview_VSB_Left		EQU	6

MUIV_NListview_HSB_Always	EQU	1
MUIV_NListview_HSB_Auto		EQU     2
MUIV_NListview_HSB_FullAuto	EQU	3
MUIV_NListview_HSB_None		EQU	4
MUIV_NListview_HSB_Default	EQU	5

MUIV_NListview_VSB_On		EQU	$0030
MUIV_NListview_VSB_Off		EQU	$0010

MUIV_NListview_HSB_On		EQU	$0300
MUIV_NListview_HSB_Off		EQU	$0100


	ENDC	;	MUI_NLISTVIEW_MCC_I
