STACK	MACRO
	cmv4	\z
	cmv4	\y
	cmv4	\x
	cmv4	\w
	cmv4	\v
	cmv4	\u
	cmv4	\t
	cmv4	\s
	cmv4	\r
	cmv4	\q
	cmv4	\p
	cmv4	\o
	cmv4	\n
	cmv4	\m
	cmv4	\l
	cmv4	\k
	cmv4	\j
	cmv4	\i
	cmv4	\h
	cmv4	\g
	cmv4	\f
	cmv4	\e
	cmv4	\d
	cmv4	\c
	cmv4	\b
	cmv4	\a
	cmv4	\9
	cmv4	\8
	cmv4	\7
	cmv4	\6
	cmv4	\5
	cmv4	\4
	cmv4	\3
	cmv4	\2
	cmv4	\1
	ENDM

STACK2	MACRO
	cmv3	\z
	cmv3	\y
	cmv3	\x
	cmv3	\w
	cmv3	\v
	cmv3	\u
	cmv3	\t
	cmv3	\s
	cmv3	\r
	cmv3	\q
	cmv3	\p
	cmv3	\o
	cmv3	\n
	cmv3	\m
	cmv3	\l
	cmv3	\k
	cmv3	\j
	cmv3	\i
	cmv3	\h
	cmv3	\g
	cmv3	\f
	cmv3	\e
	cmv3	\d
	cmv3	\c
	cmv3	\b
	cmv3	\a
	cmv3	\9
	cmv3	\8
	cmv3	\7
	cmv3	\6
	cmv3	\5
	cmv3	\4
	cmv3	\3
	cmv3	\2
	cmv3	\1
	ENDM

SETI	MACRO
	MOVE.L	SP,D0
	MOVE.L	#TAG_DONE,-(SP)
	STACK	\1,\2,\3,\4,\5,\6,\7,\8,\9,\a,\b,\c,\d,\e,\f,\g,\h,\i,\j,\k,\l,\m,\n,\o,\p,\q,\r,\s,\t,\u,\v,\w,\x,\y,\z
	MOVE.L	SP,A1
	MOVE.L	D0,-(SP)
	JSR	_LVOSetAttrsA(A6)
	MOVE.L	(SP)+,SP
	ENDM

SET2	MACRO
	MOVE.L	SP,D0
	MOVE.L	#TAG_DONE,-(SP)
	STACK2	\1,\2,\3,\4,\5,\6,\7,\8,\9,\a,\b,\c,\d,\e,\f,\g,\h,\i,\j,\k,\l,\m,\n,\o,\p,\q,\r,\s,\t,\u,\v,\w,\x,\y,\z
	MOVE.L	SP,A1
	MOVE.L	D0,-(SP)
	JSR	_LVOSetAttrsA(A6)
	MOVE.L	(SP)+,SP
	ENDM

SetTag	MACRO
	MOVE.L	\1,A0
	LEA	\2-t(A5),A1
	JSR	_LVOSetAttrsA(A6)
	ENDM

TeeMetodi	MACRO
	MOVE.L	\1,A2
	MOVE.L	SP,D0
	CLR.L	-(SP)
	STACK	\2,\3,\4,\5,\6,\7,\8,\9,\a,\b,\c,\d,\e,\f,\g,\h,\i,\j,\k,\l,\m,\n,\o,\p,\q,\r,\s,\t,\u,\v,\w,\x,\y,\z
	MOVE.L	SP,A1
	MOVE.L	D0,-(SP)
	MOVE.L	-4(A2),A0
	MOVE.L	8(A0),A6
	JSR	(A6)
	MOVE.L	(SP)+,SP
	ENDM

TeeMetodi2	MACRO
	MOVE.L	\1,A2
	MOVE.L	SP,D0
	CLR.L	-(SP)
	STACK2	\2,\3,\4,\5,\6,\7,\8,\9,\a,\b,\c,\d,\e,\f,\g,\h,\i,\j,\k,\l,\m,\n,\o,\p,\q,\r,\s,\t,\u,\v,\w,\x,\y,\z
	MOVE.L	SP,A1
	MOVE.L	D0,-(SP)
	MOVE.L	-4(A2),A0
	MOVE.L	8(A0),A6
	JSR	(A6)
	MOVE.L	(SP)+,SP
	ENDM

TEE_METODI	MACRO
	MOVE.L	\1,A2
	LEA	\2-t(A5),A1
	MOVE.L	-4(A2),A0
	MOVE.L	8(A0),A6
	JSR	(A6)
	ENDM

TeeObj	MACRO
	MOVE.L	localebase(A4),A6
	MOVE.L	catalog(A4),A0
	MOVE.L	#\2_HELP,D0
	LEA	\2_HELP_STR-t(A5),A1
	JSR	_LVOGetCatalogStr(A6)
	MOVE.L	D0,HelpString-t(A5)
	MOVE.L	catalog(A4),A0
	MOVE.L	#\2,D0
	LEA	\2_STR-t(A5),A1
	JSR	_LVOGetCatalogStr(A6)

	MOVE.L	D0,D1
	MOVEQ.L	#\1,D0

	BSR	TeeObjekti
	MOVE.L	D0,\3-t(A5)
	ENDM

TeeCheckmark	MACRO
	MOVE.L	#\1,CheckMarkID-t(A5)
	MOVE.L	#\2_ID,CheckMarkState-t(A5)
	MOVE.L	\2_obj-t(A5),D1
	BSR	TeeObjekti_Checkmark
	MOVE.L	D0,\2-t(A5)
	ENDM

TeeKuvaObj	MACRO
	MOVE.L	muimaster(A4),A6
	MOVEQ.L	#MUIO_PopButton,D0
	MOVEQ.L	#\1,D1
	BSR	TeeObjekti
	MOVE.L	D0,\2-t(A5)
	ENDM

CREATEOBJECT	MACRO
	LEA	\1-t(A5),A0

	IFC	'\2','NO_TAGS'
		SUBA.L	A1,A1
	ELSE
	LEA	\2-t(A5),A1
	ENDC

	JSR	_LVOMUI_NewObjectA(a6)
	ENDM

	ENDASM
CREATELABEL	MACRO
	MOVE.L	localebase(A4),A6
	MOVE.L	catalog(A4),A0
	MOVE.L	#\1,D0
	LEA	\1_STR-t(A5),A1
	JSR	_LVOGetCatalogStr(A6)
	MOVE.L	#\2,D1
	BSR	TeeNimiObjekti
	ENDM
	ASM

MENUSTR	MACRO
	GETSTR2	MSG_\1_MENU
	MOVE.L	D0,\2-t(A5)
	ENDM

GETSTR	MACRO
	MOVE.L	localebase(A4),A6
	MOVE.L	catalog(A4),A0
	MOVE.L	#\1,D0
	LEA	\1_STR-t(A5),A1
	JSR	_LVOGetCatalogStr(A6)
	ENDM

GETSTR2	MACRO
	MOVE.L	#\1,D0
	LEA	\1_STR-t(A5),A1
	MOVE.L	catalog(A4),A0
	JSR	_LVOGetCatalogStr(A6)
	ENDM

CreatePopAsl	MACRO
	MOVEQ	#MUIO_PopButton,D0
	MOVE.L	#\1,D1
	BSR	TeeObjekti
	MOVE.L	D0,PopButton-t(A5)
	MOVE.L	STR_\2-t(A5),PopString-t(A5)

	IFC	'\1','MUII_PopDrawer'
		CREATEOBJECT	MUIC_Popasl,PopAslTags2
	ELSE
		CREATEOBJECT	MUIC_Popasl,PopAslTags
	ENDC

	MOVE.L	D0,PA_\2-t(A5)
	ENDM

CreatePopUp	MACRO
	MOVEQ	#MUIO_PopButton,D0
	MOVE.L	#\1,D1
	BSR	TeeObjekti
	MOVE.L	D0,PopButton2-t(A5)
	MOVE.L	D0,PO_\2(A4)
	MOVE.L	STR_\2-t(A5),PopString2-t(A5)
	CREATEOBJECT	MUIC_Popstring,PopUpTags
	MOVE.L	D0,PA_\2-t(A5)
	ENDM

ALOITA	MACRO
	MOVEM.L	D2-D7/A2-A6,-(SP)
	LEA	t,A5
	MOVE.L	(A5),A4
	ENDM

LOPETA	MACRO
	MOVEM.L	(SP)+,D2-D7/A2-A6
	ENDM

KUVA	MACRO
	LEA	\1ImageName-t(A5),A1
	MOVE.L	A1,ImageSpec-t(A5)
	CREATEOBJECT	MUIC_Image,ImageTags
	MOVE.L	D0,BT_\1-t(A5)
	ENDM

TeeLabel	MACRO
	MOVE.L	#\1,D0
	LEA	\1_STR-t(A5),A1

	IFC	'\2','NO_FLAGS'
		MOVEQ	#0,D2
	ELSE
		MOVE.L	#\2,D2
	ENDC

	BSR	TeeObjekti_Label
	MOVE.L	D0,\3-t(A5)
	ENDM
