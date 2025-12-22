#include "MUI_CPP.include"

#include "mui/Listtree_mcc.h"

void CreateWI_Main(struct ObjApp *MBObj)
{

	APTR    MNProject, MNProjectNew, MNProjectSaveas, MNProjectBarLabel0, MNMenuBarBarLabel2;
	APTR    MNOption, GP_RT_Main, GR_Left, GR_MainGroup, GR_MainStructureUp, LA_MainGroupName;
	APTR    GR_MainStructureDown, LA_label_23, GR_MainGroupCmd, GR_LeftCmd, GR_grp_154;
	APTR    GR_Middle, Space_1, GR_MainCmd, GR_MainActions, GR_MainMove, LA_label_24;
	APTR    GR_MainExchange, GR_MainExchangeLeft, GR_MainExchangeRight, GR_MainCopy;
	APTR    LA_label_25, Space_2, GR_Right, GR_MainClipGroup, GR_MainClipGroupUp;
	APTR    LA_MainClipGroupName, GR_MainClipGroupDown, LA_label_23C, GR_MainClipGroupCmd;
	APTR    GR_RightCmd, GR_ClipAddMod, GR_ClipClear;
	static const struct Hook ModifyCmdHook = { {NULL, NULL}, (HOOKFUNC) ModifyCmd, NULL, NULL};
	static const struct Hook GroupCmdHook = { {NULL, NULL}, (HOOKFUNC) GroupCmd, NULL, NULL};
	static const struct Hook ActionsCmdHook = { {NULL, NULL}, (HOOKFUNC) ActionsCmd, NULL, NULL};
	static const struct Hook SelectNodeHook = { {NULL, NULL}, (HOOKFUNC) SelectNode, NULL, NULL};
	static const struct Hook InOutCmdHook = { {NULL, NULL}, (HOOKFUNC) InOutCmd, NULL, NULL};
	static const struct Hook SpecialCmdHook = { {NULL, NULL}, (HOOKFUNC) SpecialCmd, NULL, NULL};
	static const struct Hook MenuCmdHook = { {NULL, NULL}, (HOOKFUNC) MenuCmd, NULL, NULL};
	static const struct Hook LTConstructHook = { {NULL, NULL}, (HOOKFUNC) LTConstruct, NULL, NULL};
	static const struct Hook LTDestructHook = { {NULL, NULL}, (HOOKFUNC) LTDestruct, NULL, NULL};
	// static const struct Hook LTDisplayHook = { {NULL, NULL}, (HOOKFUNC) LTDisplay, NULL, NULL};

	MBObj->STR_TX_MainGroupCurrent = "MAIN";
	MBObj->STR_TX_MainGroupType = "Group";
	MBObj->STR_TX_MainClipGroupCurrent = "MAIN";
	MBObj->STR_TX_MainClipGroupType = "Group";

	LA_MainGroupName = Label("Current group");

	MBObj->TX_MainGroupCurrent = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_MainGroupCurrent,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->BT_MainGroupInfo = SimpleButton("Info");

	GR_MainStructureUp = GroupObject,
		MUIA_HelpNode, "GR_MainStructureUp",
		MUIA_Group_Horiz, TRUE,
		Child, LA_MainGroupName,
		Child, MBObj->TX_MainGroupCurrent,
		Child, MBObj->BT_MainGroupInfo,
	End;

	LA_label_23 = Label("Type");

	MBObj->TX_MainGroupType = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_MainGroupType,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_MainStructureDown = GroupObject,
		MUIA_HelpNode, "GR_MainStructureDown",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_23,
		Child, MBObj->TX_MainGroupType,
	End;

	GR_MainGroup = GroupObject,
		MUIA_HelpNode, "GR_MainGroup",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Main structure",
		Child, GR_MainStructureUp,
		Child, GR_MainStructureDown,
	End;

	MBObj->BT_MainMain = SimpleButton("Main");

	MBObj->BT_MainParent = SimpleButton("Parent");

	MBObj->BT_MainGenerateNormals = SimpleButton("Generate Normals");

	GR_MainGroupCmd = GroupObject,
		MUIA_HelpNode, "GR_MainGroupCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Group commands",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainMain,
		Child, MBObj->BT_MainParent,
		Child, MBObj->BT_MainGenerateNormals,
	End;

	MBObj->LV_MainNodes = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_MainNodes = ListviewObject,
		MUIA_HelpNode, "LV_MainNodes",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_MainNodes,
	End;

	//------------- Listtree object -------------------------
	MBObj->LT_Main = NewObject(MBObj->ltmcc->mcc_Class, NULL,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_Listtree_ConstructHook, &LTConstructHook,
		MUIA_Listtree_DestructHook, &LTDestructHook,
		// MUIA_Listtree_DisplayHook, &LTDisplayHook,
		MUIA_Listtree_MultiSelect, MUIV_Listview_MultiSelect_Default,
	End;

	MBObj->LT_Main = ListviewObject,
		MUIA_Listview_List, MBObj->LT_Main,
	End;

	MBObj->BT_MainDelete = SimpleButton("Delete");

	MBObj->BT_MainCopy = SimpleButton("Copy");

	MBObj->BT_MainMainClear = SimpleButton("Clear");

	GR_grp_154 = GroupObject,
		MUIA_HelpNode, "GR_grp_154",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainDelete,
		Child, MBObj->BT_MainCopy,
		Child, MBObj->BT_MainMainClear,
	End;

	GR_LeftCmd = GroupObject,
		MUIA_HelpNode, "GR_LeftCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Main nodes commands",
		Child, GR_grp_154,
	End;

	GR_Left = GroupObject,
		MUIA_HelpNode, "GR_Left",
		Child, GR_MainGroup,
		Child, GR_MainGroupCmd,
		Child, MBObj->LV_MainNodes,
		Child, MBObj->LT_Main,
		Child, GR_LeftCmd,
	End;

	Space_1 = HVSpace;

	MBObj->BT_MainCmdPreview = SimpleButton("Preview");

	GR_MainCmd = GroupObject,
		MUIA_HelpNode, "GR_MainCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		Child, MBObj->BT_MainCmdPreview,
	End;

	MBObj->IM_MainMoveLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	LA_label_24 = Label("Move");

	MBObj->IM_MainMoveRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	GR_MainMove = GroupObject,
		MUIA_HelpNode, "GR_MainMove",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->IM_MainMoveLeft,
		Child, LA_label_24,
		Child, MBObj->IM_MainMoveRight,
	End;

	MBObj->IM_MainExchangeLeftUp = ImageObject,
		MUIA_Image_Spec, 11,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_MainExchangeLeftDown = ImageObject,
		MUIA_Image_Spec, 12,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	GR_MainExchangeLeft = GroupObject,
		MUIA_HelpNode, "GR_MainExchangeLeft",
		MUIA_Group_HorizSpacing, 0,
		MUIA_Group_VertSpacing, 0,
		Child, MBObj->IM_MainExchangeLeftUp,
		Child, MBObj->IM_MainExchangeLeftDown,
	End;

	MBObj->BT_MainExchange = SimpleButton("Exchange");

	MBObj->IM_MainExchangeRightUp = ImageObject,
		MUIA_Image_Spec, 11,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	MBObj->IM_MainExchangeRightDown = ImageObject,
		MUIA_Image_Spec, 12,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	GR_MainExchangeRight = GroupObject,
		MUIA_HelpNode, "GR_MainExchangeRight",
		MUIA_Group_HorizSpacing, 0,
		MUIA_Group_VertSpacing, 0,
		Child, MBObj->IM_MainExchangeRightUp,
		Child, MBObj->IM_MainExchangeRightDown,
	End;

	GR_MainExchange = GroupObject,
		MUIA_HelpNode, "GR_MainExchange",
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_HorizSpacing, 0,
		MUIA_Group_VertSpacing, 0,
		Child, GR_MainExchangeLeft,
		Child, MBObj->BT_MainExchange,
		Child, GR_MainExchangeRight,
	End;

	MBObj->IM_MainCopyLeft = ImageObject,
		MUIA_Image_Spec, 13,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	LA_label_25 = Label("Copy");

	MBObj->IM_MainCopyRight = ImageObject,
		MUIA_Image_Spec, 14,
		MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_ImageButton,
		MUIA_Image_FreeVert, TRUE,
		MUIA_Image_FreeHoriz, TRUE,
		MUIA_FixHeight, 10,
		MUIA_FixWidth, 8,
	End;

	GR_MainCopy = GroupObject,
		MUIA_HelpNode, "GR_MainCopy",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->IM_MainCopyLeft,
		Child, LA_label_25,
		Child, MBObj->IM_MainCopyRight,
	End;

	GR_MainActions = GroupObject,
		MUIA_HelpNode, "GR_MainActions",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Actions",
		MUIA_Group_HorizSpacing, 0,
		Child, GR_MainMove,
		Child, GR_MainExchange,
		Child, GR_MainCopy,
	End;

	Space_2 = HVSpace;

	GR_Middle = GroupObject,
		MUIA_HelpNode, "GR_Middle",
		MUIA_Weight, 20,
		Child, Space_1,
		Child, GR_MainCmd,
		Child, GR_MainActions,
		Child, Space_2,
	End;

	LA_MainClipGroupName = Label("Current group");

	MBObj->TX_MainClipGroupCurrent = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_MainClipGroupCurrent,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->BT_MainClipGroupInfo = SimpleButton("Info");

	GR_MainClipGroupUp = GroupObject,
		MUIA_HelpNode, "GR_MainClipGroupUp",
		MUIA_Group_Horiz, TRUE,
		Child, LA_MainClipGroupName,
		Child, MBObj->TX_MainClipGroupCurrent,
		Child, MBObj->BT_MainClipGroupInfo,
	End;

	LA_label_23C = Label("Type");

	MBObj->TX_MainClipGroupType = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_MainClipGroupType,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_MainClipGroupDown = GroupObject,
		MUIA_HelpNode, "GR_MainClipGroupDown",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_23C,
		Child, MBObj->TX_MainClipGroupType,
	End;

	GR_MainClipGroup = GroupObject,
		MUIA_HelpNode, "GR_MainClipGroup",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Clipboard structure",
		Child, GR_MainClipGroupUp,
		Child, GR_MainClipGroupDown,
	End;

	MBObj->BT_MainClipMain = SimpleButton("Main");

	MBObj->BT_MainClipParent = SimpleButton("Parent");

	GR_MainClipGroupCmd = GroupObject,
		MUIA_HelpNode, "GR_MainClipGroupCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Group commands",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainClipMain,
		Child, MBObj->BT_MainClipParent,
	End;

	MBObj->LV_MainClipboard = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
	End;

	MBObj->LV_MainClipboard = ListviewObject,
		MUIA_HelpNode, "LV_MainClipboard",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_MainClipboard,
	End;

	MBObj->BT_MainClipAdd = SimpleButton("Add");

	MBObj->BT_MainClipDelete = SimpleButton("Delete");

	MBObj->BT_MainClipCopy = SimpleButton("Copy");

	MBObj->BT_MainClipClear = SimpleButton("Clear");

	GR_ClipAddMod = GroupObject,
		MUIA_HelpNode, "GR_ClipAddMod",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainClipAdd,
		Child, MBObj->BT_MainClipDelete,
		Child, MBObj->BT_MainClipCopy,
		Child, MBObj->BT_MainClipClear,
	End;

	MBObj->BT_MainClipSave = SimpleButton("Save");

	MBObj->BT_MainClipInsert = SimpleButton("Insert");

	GR_ClipClear = GroupObject,
		MUIA_HelpNode, "GR_ClipClear",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainClipSave,
		Child, MBObj->BT_MainClipInsert,
	End;

	GR_RightCmd = GroupObject,
		MUIA_HelpNode, "GR_RightCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Clipboard commands",
		Child, GR_ClipAddMod,
		Child, GR_ClipClear,
	End;

	GR_Right = GroupObject,
		MUIA_HelpNode, "GR_Right",
		Child, GR_MainClipGroup,
		Child, GR_MainClipGroupCmd,
		Child, MBObj->LV_MainClipboard,
		Child, GR_RightCmd,
	End;

	GP_RT_Main = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, GR_Left,
		Child, GR_Middle,
		Child, GR_Right,
	End;

	MBObj->MNProjectNewAll = MenuitemObject,
		MUIA_Menuitem_Title, "All",
	End;

	MBObj->MNProjectNewOnlyMain = MenuitemObject,
		MUIA_Menuitem_Title, "Only main",
	End;

	MBObj->MNProjectNewOnlyClip = MenuitemObject,
		MUIA_Menuitem_Title, "Only clip",
	End;

	MNProjectNew = MenuitemObject,
		MUIA_Menuitem_Title, "New",
		MUIA_Family_Child, MBObj->MNProjectNewAll,
		MUIA_Family_Child, MBObj->MNProjectNewOnlyMain,
		MUIA_Family_Child, MBObj->MNProjectNewOnlyClip,
	End;

	MBObj->MNProjectOpen = MenuitemObject,
		MUIA_Menuitem_Title, "Open",
	End;

	MBObj->MNProjectSaveasVRML = MenuitemObject,
		MUIA_Menuitem_Title, "VRML V1.0 ascii",
	End;

	MBObj->MNProjectSaveasOpenGL = MenuitemObject,
		MUIA_Menuitem_Title, "OpenGL source code",
	End;

	MBObj->MNProjectSaveasGEO = MenuitemObject,
		MUIA_Menuitem_Title, "Geo ascii",
	End;

	MNProjectSaveas = MenuitemObject,
		MUIA_Menuitem_Title, "Save as",
		MUIA_Family_Child, MBObj->MNProjectSaveasVRML,
		MUIA_Family_Child, MBObj->MNProjectSaveasOpenGL,
		MUIA_Family_Child, MBObj->MNProjectSaveasGEO,
	End;

	MNProjectBarLabel0 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectAbout = MenuitemObject,
		MUIA_Menuitem_Title, "About",
	End;

	MBObj->MNProjectAboutMUI = MenuitemObject,
		MUIA_Menuitem_Title, "About MUI...",
	End;

	MNMenuBarBarLabel2 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectQuit = MenuitemObject,
		MUIA_Menuitem_Title, "Quit",
	End;

	MNProject = MenuitemObject,
		MUIA_Menuitem_Title, "Project",
		MUIA_Family_Child, MNProjectNew,
		MUIA_Family_Child, MBObj->MNProjectOpen,
		MUIA_Family_Child, MNProjectSaveas,
		MUIA_Family_Child, MNProjectBarLabel0,
		MUIA_Family_Child, MBObj->MNProjectAbout,
		MUIA_Family_Child, MBObj->MNProjectAboutMUI,
		MUIA_Family_Child, MNMenuBarBarLabel2,
		MUIA_Family_Child, MBObj->MNProjectQuit,
	End;

	MBObj->MNOptionParseroutput = MenuitemObject,
		MUIA_Menuitem_Title, "Parser output",
		MUIA_Menuitem_Checkit, TRUE,
		MUIA_Menuitem_Toggle, TRUE,
	End;

	MBObj->MNOptionPrefs = MenuitemObject,
		MUIA_Menuitem_Title, "Prefs",
	End;

	MNOption = MenuitemObject,
		MUIA_Menuitem_Title, "Option",
		MUIA_Family_Child, MBObj->MNOptionParseroutput,
		MUIA_Family_Child, MBObj->MNOptionPrefs,
	End;

	MBObj->MN_MenuBar = MenustripObject,
		MUIA_Family_Child, MNProject,
		MUIA_Family_Child, MNOption,
	End;

	MBObj->WI_Main = WindowObject,
		MUIA_Window_Title, "VRMLEditor V 0.62 (Beta)",
		MUIA_Window_Menustrip, MBObj->MN_MenuBar,
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GP_RT_Main,
	End;
}

