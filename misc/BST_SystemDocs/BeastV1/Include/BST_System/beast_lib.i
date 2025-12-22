** Beast Library version V1 Alpha

; definition of the library base
		rsreset
BeastLib	rs.b	$22 ; LIB_SIZE % should be defined in a include file
ml_SysLib	rs.l	1
ml_DosLib	rs.l	1
ml_SegList	rs.l	1
ml_Flags	rs.b	1
ml_pad		rs.b	1
Beast_Sizeof	rs.l	0

BeastLibEntry	set	-30

BEASTNAME	macro
		dc.b	'beast.library',0
		endm

CALLBEAST	macro
		move.l	_BeastBase,a6
		jsr	_LVO\1(a6)
		endm

BEASTLIBDEF	macro		macro to create library offsets
_LVO\1		equ	BeastLibEntry
BeastLibEntry	set	BeastLibEntry-6
		endm

		BEASTLIBDEF	BST_MakeClass
		BEASTLIBDEF	BST_AddClass
		BEASTLIBDEF	BST_RemoveClass
		BEASTLIBDEF	BST_FreeClass

		BEASTLIBDEF	CLSS_AddMethod
		BEASTLIBDEF	CLSS_FindMethod
		BEASTLIBDEF	CLSS_DisposeMethod
		BEASTLIBDEF	CLSS_AddInput
		BEASTLIBDEF	CLSS_AddOutput
		BEASTLIBDEF	CLSS_RemoveInput
		BEASTLIBDEF	CLSS_RemoveOutput
		
		BEASTLIBDEF	OBJ_NewObject
		BEASTLIBDEF	OBJ_DisposeObject
		BEASTLIBDEF	OBJ_DestroyObject
		BEASTLIBDEF	OBJ_DoMethod
		BEASTLIBDEF	OBJ_CreateConnection
		BEASTLIBDEF	OBJ_RemoveConnection
		BEASTLIBDEF	OBJ_ToOutput

		BEASTLIBDEF	BST_FindTagItem
		BEASTLIBDEF	BST_NextTagItem
		BEASTLIBDEF	BST_ApplyTagChanges
		BEASTLIBDEF	BST_CloneTagItems
		BEASTLIBDEF	BST_FreeTagItems

		BEASTLIBDEF	BST_TagListGETATTRParent
		BEASTLIBDEF	BST_FillAttrTagList

		BEASTLIBDEF	OBJ_FromInput

		BEASTLIBDEF	BST_SetDelayedDispose
		BEASTLIBDEF	BST_DelayedDispose

		BEASTLIBDEF	OBJ_MethodToChildren
		BEASTLIBDEF	OBJ_MethodToParent

		BEASTLIBDEF	BST_MakeSubClass
		BEASTLIBDEF	BST_ForceDestroyAll

		BEASTLIBDEF	BST_CreateObject
