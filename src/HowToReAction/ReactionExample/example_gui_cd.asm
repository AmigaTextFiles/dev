	IFND EXAMPLE_GUI_CD_I
EXAMPLE_GUI_CD_I	SET	1


;-----------------------------------------------------------------------------


* This file was created automatically by CatComp.
* Do NOT edit by hand!
*


	IFND EXEC_TYPES_I
	INCLUDE 'exec/types.i'
	ENDC

	IFD CATCOMP_ARRAY
CATCOMP_NUMBERS SET 1
CATCOMP_STRINGS SET 1
	ENDC

	IFD CATCOMP_CODE
CATCOMP_BLOCK SET 1
	ENDC


;-----------------------------------------------------------------------------


	IFD CATCOMP_NUMBERS

	XDEF MSG_WINTITLE
MSG_WINTITLE EQU 270
	XDEF MSG_CANCEL
MSG_CANCEL EQU 272
	XDEF MSG_HELLOWORLD
MSG_HELLOWORLD EQU 273

	ENDC ; CATCOMP_NUMBERS


;-----------------------------------------------------------------------------


	IFD CATCOMP_STRINGS

	XDEF MSG_WINTITLE_STR
MSG_WINTITLE_STR: DC.B 'Reaction Example',$00
	XDEF MSG_CANCEL_STR
MSG_CANCEL_STR: DC.B 'Cancel',$00
	XDEF MSG_HELLOWORLD_STR
MSG_HELLOWORLD_STR: DC.B 'Hello World!',$00

	ENDC ; CATCOMP_STRINGS


;-----------------------------------------------------------------------------


	IFD CATCOMP_ARRAY

   STRUCTURE CatCompArrayType,0
	LONG cca_ID
	APTR cca_Str
   LABEL CatCompArrayType_SIZEOF

	CNOP 0,4

	XDEF CatCompArray
CatCompArray:
	XDEF _CatCompArray
_CatCompArray:
AS0:	DC.L MSG_WINTITLE,MSG_WINTITLE_STR
AS1:	DC.L MSG_CANCEL,MSG_CANCEL_STR
AS2:	DC.L MSG_HELLOWORLD,MSG_HELLOWORLD_STR

	ENDC ; CATCOMP_ARRAY


;-----------------------------------------------------------------------------


	IFD CATCOMP_BLOCK

	XDEF CatCompBlock
CatCompBlock:
	XDEF _CatCompBlock
_CatCompBlock:
	DC.L $10E
	DC.W $12
	DC.B 'Reaction Example',$00,$00
	DC.L $110
	DC.W $8
	DC.B 'Cancel',$00,$00
	DC.L $111
	DC.W $E
	DC.B 'Hello World!',$00,$00

	ENDC ; CATCOMP_BLOCK


;-----------------------------------------------------------------------------


   STRUCTURE LocaleInfo,0
	APTR li_LocaleBase
	APTR li_Catalog
   LABEL LocaleInfo_SIZEOF

	IFD CATCOMP_CODE

	XREF      _LVOGetCatalogStr
	XDEF      _GetString
	XDEF      GetString
GetString:
_GetString:
	lea       CatCompBlock(pc),a1
	bra.s     2$
1$: move.w  (a1)+,d1
	add.w     d1,a1
2$: cmp.l   (a1)+,d0
	bne.s     1$
	addq.l    #2,a1
	move.l    (a0)+,d1
	bne.s     3$
	move.l    a1,d0
	rts
3$: move.l  a6,-(sp)
	move.l    d1,a6
	move.l    (a0),a0
	jsr       _LVOGetCatalogStr(a6)
	move.l    (sp)+,a6
	rts
	END

	ENDC ; CATCOMP_CODE


;-----------------------------------------------------------------------------


	ENDC ; EXAMPLE_GUI_CD_I
