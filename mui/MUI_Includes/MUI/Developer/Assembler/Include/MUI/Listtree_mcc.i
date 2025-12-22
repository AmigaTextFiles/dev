	IFND	LISTTREE_MCC_I
LISTTREE_MCC_I	SET	1

*		MCC_Listtree (c) by kMel, Klaus Melchior
*
*		Registered class of the Magic User Interface.
*
*		Listtree_mcc.h
*
*		Assembler version by Ilkka Lehtoranta (29-Nov-99)

	IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
	ENDC

*** MUI Defines ***

;#define MUIC_Listtree "Listtree.mcc"
;#define ListtreeObject MUI_NewObject(MUIC_Listtree



*** Methods ***

MUIM_Listtree_Close		EQU	$8002001f
MUIM_Listtree_Exchange		EQU	$80020008
MUIM_Listtree_FindName		EQU	$8002003c
MUIM_Listtree_GetEntry		EQU	$8002002b
MUIM_Listtree_GetNr		EQU	$8002000e
MUIM_Listtree_Insert		EQU	$80020011
MUIM_Listtree_Move		EQU	$80020009
MUIM_Listtree_Open		EQU     $8002001e
MUIM_Listtree_Remove		EQU	$80020012
MUIM_Listtree_Rename		EQU	$8002000c
MUIM_Listtree_SetDropMark	EQU	$8002004c
MUIM_Listtree_Sort		EQU	$80020029
MUIM_Listtree_TestPos		EQU	$8002004b

*** Method structs ***

	STRUCTURE MUIP_Listtree_Close,0
	ULONG	MLC_MethodID
	APTR	MLC_ListNode
	APTR	MLC_TreeNode
	ULONG	MLC_Flags

	STURCTURE MUIP_Listtree_Exchange,0
	ULONG	MLE_MethodID
	APTR	MLE_ListNode1
	APTR	MLE_TreeNode1
	APTR	MLE_ListNode2
	APTR	MLE_TreeNode2
	ULONG	MLE_Flags

	STRUCTURE MUIP_Listtree_FindName,0
	ULONG	MLF_MethodID
	APTR	MLF_ListNode
	APTR	MLF_Name
	ULONG	MLF_Flags

	STRUCTURE MUIP_Listtree_GetEntry,0
	ULONG	MLG_MethodID
	APTR	MLG_Node
	LONG	MLG_Position
	ULONG	MLG_Flags

	ENDASM
struct MUIP_Listtree_GetNr {
	ULONG MethodID;
	APTR  TreeNode;
	ULONG Flags;
};

struct MUIP_Listtree_Insert {
	ULONG MethodID;
	char *Name;
	APTR  User;
	APTR  ListNode;
	APTR  PrevNode;
	ULONG Flags;
};

struct MUIP_Listtree_Move {
	ULONG MethodID;
	APTR  OldListNode;
	APTR  OldTreeNode;
	APTR  NewListNode;
	APTR  NewTreeNode;
	ULONG Flags;
};

struct MUIP_Listtree_Open {
	ULONG MethodID;
	APTR  ListNode;
	APTR  TreeNode;
	ULONG Flags;
};

struct MUIP_Listtree_Remove {
	ULONG MethodID;
	APTR  ListNode;
	APTR  TreeNode;
	ULONG Flags;
};

struct MUIP_Listtree_Rename {
	ULONG MethodID;
	APTR  TreeNode;
	char *NewName;
	ULONG Flags;
};

struct MUIP_Listtree_SetDropMark {
	ULONG MethodID;
	LONG  Entry;
	ULONG Values;
};

struct MUIP_Listtree_Sort {
	ULONG MethodID;
	APTR  ListNode;
	ULONG Flags;
};

struct MUIP_Listtree_TestPos {
	ULONG MethodID;
	LONG  X;
	LONG  Y;
	APTR  Result;
};
	ASM

*** Special method values ***

MUIV_Listtree_Close_ListNode_Root	UEQ	0
MUIV_Listtree_Close_ListNode_Parent	EQU	-1
MUIV_Listtree_Close_ListNode_Active	EQU     -2

MUIV_Listtree_Close_TreeNode_Head	EQU	0
MUIV_Listtree_Close_TreeNode_Tail	EQU	-1
MUIV_Listtree_Close_TreeNode_Active	EQU	-2
MUIV_Listtree_Close_TreeNode_All	EQU	-3

MUIV_Listtree_Exchange_ListNode1_Root	EQU	0
MUIV_Listtree_Exchange_ListNode1_Active	EQU	-2

MUIV_Listtree_Exchange_TreeNode1_Head	EQU	0
MUIV_Listtree_Exchange_TreeNode1_Tail	EQU	-1
MUIV_Listtree_Exchange_TreeNode1_Active	EQU	-2

MUIV_Listtree_Exchange_ListNode2_Root	EQU	0
MUIV_Listtree_Exchange_ListNode2_Active	EQU	-2

MUIV_Listtree_Exchange_TreeNode2_Head	EQU	0
MUIV_Listtree_Exchange_TreeNode2_Tail	EQU	-1
MUIV_Listtree_Exchange_TreeNode2_Active	EQU	-2
MUIV_Listtree_Exchange_TreeNode2_Up	EQU	-5
MUIV_Listtree_Exchange_TreeNode2_Down	EQU	-6

MUIV_Listtree_FindName_ListNode_Root	EQU	0
MUIV_Listtree_FindName_ListNode_Active	EQU	-2

MUIV_Listtree_GetEntry_ListNode_Root	EQU	0
MUIV_Listtree_GetEntry_ListNode_Active	EQU	-2

MUIV_Listtree_GetEntry_Position_Head	EQU	0
MUIV_Listtree_GetEntry_Position_Tail	EQU	-1
MUIV_Listtree_GetEntry_Position_Active	EQU	-2
MUIV_Listtree_GetEntry_Position_Next	EQU	-3
MUIV_Listtree_GetEntry_Position_Previous	EQU	-4
MUIV_Listtree_GetEntry_Position_Parent	EQU	-5

MUIV_Listtree_GetNr_TreeNode_Active	EQU	-2

MUIV_Listtree_Insert_ListNode_Root	EQU	0
MUIV_Listtree_Insert_ListNode_Active	EQU	-2

MUIV_Listtree_Insert_PrevNode_Head	EQU	0
MUIV_Listtree_Insert_PrevNode_Tail	EQU	-1
MUIV_Listtree_Insert_PrevNode_Active	EQU	-2
MUIV_Listtree_Insert_PrevNode_Sorted	EQU	-4

MUIV_Listtree_Move_OldListNode_Root	EQU	0
MUIV_Listtree_Move_OldListNode_Active	EQU	-2

MUIV_Listtree_Move_OldTreeNode_Head	EQU	0
MUIV_Listtree_Move_OldTreeNode_Tail	EQU	-1
MUIV_Listtree_Move_OldTreeNode_Active	EQU	-2

MUIV_Listtree_Move_NewListNode_Root	EQU	0
MUIV_Listtree_Move_NewListNode_Active	EQU	-2

MUIV_Listtree_Move_NewTreeNode_Head	EQU	0
MUIV_Listtree_Move_NewTreeNode_Tail	EQU     -1
MUIV_Listtree_Move_NewTreeNode_Active	EQU     -2
MUIV_Listtree_Move_NewTreeNode_Sorted	EQU	-4

MUIV_Listtree_Open_ListNode_Root	EQU	0
MUIV_Listtree_Open_ListNode_Parent	EQU	-1
MUIV_Listtree_Open_ListNode_Active	EQU	-2
MUIV_Listtree_Open_TreeNode_Head	EQU	0
MUIV_Listtree_Open_TreeNode_Tail	EQU	-1
MUIV_Listtree_Open_TreeNode_Active	EQU	-2
MUIV_Listtree_Open_TreeNode_All		EQU	-3

MUIV_Listtree_Remove_ListNode_Root	EQU	0
MUIV_Listtree_Remove_ListNode_Active	EQU	-2
MUIV_Listtree_Remove_TreeNode_Head	EQU	0
MUIV_Listtree_Remove_TreeNode_Tail	EQU	-1
MUIV_Listtree_Remove_TreeNode_Active	EQU	-2
MUIV_Listtree_Remove_TreeNode_All	EQU	-3

MUIV_Listtree_Rename_TreeNode_Active	EQU	-2

MUIV_Listtree_SetDropMark_Entry_None	EQU	-1

MUIV_Listtree_SetDropMark_Values_None	EQU	0
MUIV_Listtree_SetDropMark_Values_Above	EQU	1
MUIV_Listtree_SetDropMark_Values_Below	EQU	2
MUIV_Listtree_SetDropMark_Values_Onto	EQU	3
MUIV_Listtree_SetDropMark_Values_Sorted	EQU	4

MUIV_Listtree_Sort_ListNode_Root	EQU	0
MUIV_Listtree_Sort_ListNode_Active	EQU	-2

MUIV_Listtree_TestPos_Result_Flags_None		EQU	0
MUIV_Listtree_TestPos_Result_Flags_Above	EQU	1
MUIV_Listtree_TestPos_Result_Flags_Below	EQU	2
MUIV_Listtree_TestPos_Result_Flags_Onto		EQU	3
MUIV_Listtree_TestPos_Result_Flags_Sorted	EQU	4


*** Special method flags ***

MUIV_Listtree_Close_Flags_Nr		EQU	(1<<15)
MUIV_Listtree_Close_Flags_Visible	EQU	(1<<14)

MUIV_Listtree_FindName_Flags_SameLevel	EQU	(1<<15)
MUIV_Listtree_FindName_Flags_Visible	EQU	(1<<14)

MUIV_Listtree_GetEntry_Flags_SameLevel	EQU	(1<<15)
MUIV_Listtree_GetEntry_Flags_Visible	EQU	(1<<14)

MUIV_Listtree_GetNr_Flags_ListEmpty	EQU	(1<<12)
MUIV_Listtree_GetNr_Flags_CountList	EQU	(1<<13)
MUIV_Listtree_GetNr_Flags_CountLevel	EQU	(1<<14)
MUIV_Listtree_GetNr_Flags_CountAll	EQU	(1<<15)

MUIV_Listtree_Insert_Flags_Nr		EQU	(1<<15)
MUIV_Listtree_Insert_Flags_Visible	EQU	(1<<14)
MUIV_Listtree_Insert_Flags_Active	EQU	(1<<13)
MUIV_Listtree_Insert_Flags_NextNode	EQU	(1<<12)

MUIV_Listtree_Move_Flags_Nr		EQU	(1<<15)
MUIV_Listtree_Move_Flags_Visible	EQU	(1<<14)

MUIV_Listtree_Open_Flags_Nr		EQU	(1<<15)
MUIV_Listtree_Open_Flags_Visible	EQU     (1<<14)

MUIV_Listtree_Remove_Flags_Nr		EQU	(1<<15)
MUIV_Listtree_Remove_Flags_Visible	EQU	(1<<14)

MUIV_Listtree_Rename_Flags_User		EQU	(1<<8)
MUIV_Listtree_Rename_Flags_NoRefresh	EQU	(1<<9)

MUIV_Listtree_Sort_Flags_Nr		EQU	(1<<15)
MUIV_Listtree_Sort_Flags_Visible	EQU	(1<<14)



*** Attributes ***

MUIA_Listtree_Active		EQU	$80020020
MUIA_Listtree_CloseHook		EQU	$80020033
MUIA_Listtree_ConstructHook	EQU	$80020016
MUIA_Listtree_DestructHook	EQU	$80020017
MUIA_Listtree_DisplayHook	EQU	$80020018
MUIA_Listtree_DoubleClick	EQU	$8002000d
MUIA_Listtree_DragDropSort	EQU	$80020031
MUIA_Listtree_DuplicateNodeName	EQU	$8002003d
MUIA_Listtree_EmptyNodes	EQU	$80020030
MUIA_Listtree_Format		EQU	$80020014
MUIA_Listtree_MultiSelect	EQU	$800200c3
MUIA_Listtree_NList		EQU	$800200c4
MUIA_Listtree_OpenHook		EQU	$80020032
MUIA_Listtree_Quiet		EQU	$8002000a
MUIA_Listtree_SortHook		EQU	$80020010
MUIA_Listtree_Title		EQU	$80020015
MUIA_Listtree_TreeColumn	EQU	$80020013

*** Special attribute values ***

MUIV_Listtree_Active_Off		EQU	0

MUIV_Listtree_ConstructHook_String	EQU	-1

MUIV_Listtree_DestructHook_String	EQU	-1

MUIV_Listtree_DisplayHook_Default	EQU	-1

MUIV_Listtree_DoubleClick_Off		EQU	-1
MUIV_Listtree_DoubleClick_All		EQU	-2
MUIV_Listtree_DoubleClick_Tree		EQU	-3

MUIV_Listtree_SortHook_Head		EQU     0
MUIV_Listtree_SortHook_Tail		EQU	-1
MUIV_Listtree_SortHook_LeavesTop	EQU	-2
MUIV_Listtree_SortHook_LeavesMixed	EQU	-3
MUIV_Listtree_SortHook_LeavesBottom	EQU	-4



*** Structures, Flags & Values ***

	ENDASM
struct MUIS_Listtree_TreeNode {
	LONG  tn_Private1;
	LONG  tn_Private2;
	char *tn_Name;
	UWORD tn_Flags;
	APTR  tn_User;
};

struct MUIS_Listtree_TestPos_Result {
	APTR  tpr_TreeNode;
	UWORD tpr_Flags;
	LONG  tpr_ListEntry;
	UWORD tpr_ListFlags;
};
	ASM

TNF_OPEN	EQU	(1<<00)
TNF_LIST	EQU	(1<<01)
TNF_FROZEN	EQU	(1<<02)
TNF_NOSIGN	EQU	(1<<03)




*** Configs ***


	ENDC

