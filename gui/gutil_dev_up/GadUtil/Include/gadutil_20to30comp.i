	IFND	GADUTIL_20TO30COMP_I
GADUTIL_20TO30COMP_I	SET	1
**------------------------------------------------------------------------**
*
*	$VER: gadutil_20to30comp.i 37.10 (28.09.97)
*
*	Filename:	gadutil_20to30comp.i
*	Version:	37.10
*	Date:		28-Sep-97
*
*	Include file to make all examples compatible with OS 2.04 includes
*
*	© Copyright 1994-1997 by P-O Yliniemi and Staffan Hämälä.
*
*	All Rights Reserved.
*
**------------------------------------------------------------------------**

; ---- GadTools additions

	ifnd	GTMN_NewLookMenus			; Check for v39 libraries/gadtools.i
GTMN_NewLookMenus	equ	GT_TagBase+67
GTCB_Scaled		equ	GT_TagBase+68

MX_WIDTH		equ	17
MX_HEIGHT		equ	9
CHECKBOX_WIDTH		equ	26
CHECKBOX_HEIGHT		equ	11
	endc

;---- Intuition additions

	ifnd	WA_NewLookMenus				; Check for v39 intuition/intuition.i
WA_NewLookMenus		equ	$80000093
EasyStruct_SIZEOF	equ	20
	endc

	ENDC						; gadutil_20to30comp.i
