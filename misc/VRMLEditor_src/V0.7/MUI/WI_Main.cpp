#include "MUI_CPP.include"

#include <mui/Listtree_mcc.h>
#include <mui/GLArea_mcc.h>

#include "GLFunctions.h"

void CreateWI_Main(struct ObjApp *MBObj)
{
	APTR    MNProject, MNProjectNew, MNMenuBarBarLabel4, MNProjectSaveas, MNProjectBarLabel0;
	APTR    MNMenuBarBarLabel2, MNMenuBarEdit, MNOption, MNMenuBarBarLabel3, GP_RT_Main, MNProjectBarLabel15;
	APTR    GR_MainUp, GR_MainToolbar, GR_MainTitle, LA_label_62, Space_36, GR_MainTBActions;
	APTR    GR_MainLV, GR_MainLeftLV, LA_label_64, GR_MainCmd, Space_35, LA_label_63;
	APTR    GR_MainRightLV, LA_label_65, GR_MainOverallCmd, GR_ClipAddMod, GR_MainIO;

	// static const struct Hook ModifyCmdHook = { {NULL, NULL}, (HOOKFUNC) ModifyCmd, NULL, NULL};
	// static const struct Hook ActionsCmdHook = { {NULL, NULL}, (HOOKFUNC) ActionsCmd, NULL, NULL};
	// static const struct Hook SelectNodeHook = { {NULL, NULL}, (HOOKFUNC) SelectNode, NULL, NULL};
	// static const struct Hook InOutCmdHook = { {NULL, NULL}, (HOOKFUNC) InOutCmd, NULL, NULL};
	// static const struct Hook SpecialCmdHook = { {NULL, NULL}, (HOOKFUNC) SpecialCmd, NULL, NULL};
	// static const struct Hook MenuCmdHook = { {NULL, NULL}, (HOOKFUNC) MenuCmd, NULL, NULL};

	// LA_label_62 = Label("\033lVRMLEditor V 0.63 (12.12.98)\nWritten by Bodmer Stephan\n(bodmer2@uni2a.unige.ch)");
	/*
	MBObj->BC_Logo = BodychunkObject,
		MUIA_Bodychunk_Body, BODY_vrmleditor_image_Data,
		MUIA_Bodychunk_Compression, BODY_vrmleditor_image_Compression,
		MUIA_Bitmap_Width, BODY_vrmleditor_image_Width,
		MUIA_Bitmap_Height, BODY_vrmleditor_image_Height,
		MUIA_FixWidth, BODY_vrmleditor_image_Width,
		MUIA_FixHeight, BODY_vrmleditor_image_Height,
		MUIA_Bitmap_SourceColors, BODY_vrmleditor_image_Colors,
		// MUIA_Bitmap_Transparent, BODY_vrmleditor_image_Transparent,
		MUIA_Bodychunk_Depth, BODY_vrmleditor_image_Depth,
		MUIA_Bodychunk_Masking, BODY_vrmleditor_image_Masking,
	End;
	*/
	MBObj->GL_Logo = GLAreaObject,
		MUIA_FillArea, TRUE,
		MUIA_GLArea_MinWidth, 300,
		MUIA_GLArea_MaxWidth, 300,
		MUIA_GLArea_MinHeight, 50,
		MUIA_GLArea_MaxHeight, 50,
		MUIA_GLArea_DrawFunc, DrawMainLogoScene,
		// MUIA_GLArea_ResetFunc, Reset,
		// MUIA_GLArea_InitFunc, Init,
		// MUIA_GLArea_MouseDownFunc, MouseDown,
		// MUIA_GLArea_MouseMoveFunc, MouseMove,
		// MUIA_GLArea_MouseUpFunc, MouseUp,
	End;

	Space_36 = HVSpace;

	GR_MainTitle = GroupObject,
		// MUIA_HelpNode, "GR_MainTitle",
		// MUIA_Background, MUII_SHINE,
		// MUIA_Frame, MUIV_Frame_Group,
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->GL_Logo,
		Child, Space_36,
	End;

	MBObj->BT_MainInfo = SimpleButton("World info");

	MBObj->BT_MainPreview = SimpleButton("Preview");

	GR_MainTBActions = GroupObject,
		MUIA_HelpNode, "GR_MainTBActions",
		MUIA_Weight, 50,
		Child, MBObj->BT_MainInfo,
		Child, MBObj->BT_MainPreview,
	End;

	GR_MainToolbar = GroupObject,
		MUIA_HelpNode, "GR_MainToolbar",
		MUIA_Group_Horiz, TRUE,
		Child, GR_MainTitle,
		Child, GR_MainTBActions,
	End;

	GR_MainUp = GroupObject,
		MUIA_HelpNode, "GR_MainUp",
		MUIA_Weight, 20,
		Child, GR_MainToolbar,
	End;

	LA_label_64 = Label("\033cMain world");

	MBObj->CF_MainWorld = ColorfieldObject,
		MUIA_HelpNode, "CF_MainWorld",
		MUIA_FixHeight, 10,
		// MUIA_InputMode, 1,
		MUIA_Colorfield_Red, -1,
		MUIA_Colorfield_Green, -1,
		MUIA_Colorfield_Blue, -1,
	End;

	MBObj->GR_MainColor = GroupObject,
		MUIA_HelpNode, "GR_MainColor",
		MUIA_Group_Horiz, TRUE,
		MUIA_InputMode, 1,
		Child, LA_label_64,
		Child, MBObj->CF_MainWorld,
	End;

	//--------- DDListtree --------------
	MBObj->LT_MainWorld = NewObject(MBObj->ltmcc->mcc_Class, NULL,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_Listtree_DoubleClick, MUIV_Listtree_DoubleClick_Tree,
		MUIA_Listtree_Format, ",,",
	End;

	MBObj->LV_MainWorld = ListviewObject,
		MUIA_HelpNode, "LV_MainWorld",
		// MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
		MUIA_Listview_List, MBObj->LT_MainWorld,
	End;

	GR_MainLeftLV = GroupObject,
		MUIA_HelpNode, "GR_MainLeftLV",
		MUIA_Group_VertSpacing, 0,
		// MUIA_InputMode, 1,
		Child, MBObj->GR_MainColor,
		Child, MBObj->LV_MainWorld,
	End;
	//--------------------------------------------

	MBObj->BT_MainMoveRight = SimpleButton(">>");

	MBObj->BT_MainMoveLeft = SimpleButton("<<");

	MBObj->BT_MainMoveUp = SimpleButton("Up");

	MBObj->BT_MainMoveDown = SimpleButton("Down");

	Space_35 = HVSpace;

	// LA_label_63 = Label("V 1.0");

	GR_MainCmd = GroupObject,
		MUIA_HelpNode, "GR_MainCmd",
		MUIA_Weight, 20,
		Child, MBObj->BT_MainMoveRight,
		Child, MBObj->BT_MainMoveLeft,
		Child, MBObj->BT_MainMoveUp,
		Child, MBObj->BT_MainMoveDown,
		Child, Space_35,
		// Child, LA_label_63,
	End;

	MBObj->CF_MainClip = ColorfieldObject,
		MUIA_HelpNode, "CF_MainClip",
		MUIA_FixHeight, 10,
		// MUIA_InputMode, 1,
		MUIA_Colorfield_Red, -1,
		MUIA_Colorfield_Green, -1,
		MUIA_Colorfield_Blue, -1,
	End;

	LA_label_65 = Label("Clip world");

	MBObj->GR_ClipColor = GroupObject,
		MUIA_HelpNode, "GR_ClipColor",
		MUIA_Group_Horiz, TRUE,
		MUIA_InputMode, 1,
		Child, MBObj->CF_MainClip,
		Child, LA_label_65,
	End;


	//---------- DDListtree -------------------------------------
	MBObj->LT_MainClip = NewObject(MBObj->ltmcc->mcc_Class, NULL,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_Listtree_DoubleClick, MUIV_Listtree_DoubleClick_Tree,
		MUIA_Listtree_Format, ",,",
	End;

	MBObj->LV_MainClip = ListviewObject,
		MUIA_HelpNode, "LV_MainClipboard",
		// MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_DragType, MUIV_Listview_DragType_Immediate,
		MUIA_Listview_List, MBObj->LT_MainClip,
	End;

	GR_MainRightLV = GroupObject,
		MUIA_HelpNode, "GR_MainRightLV",
		MUIA_Group_VertSpacing, 0,
		Child, MBObj->GR_ClipColor,
		Child, MBObj->LV_MainClip,
	End;

	GR_MainLV = GroupObject,
		MUIA_HelpNode, "GR_MainLV",
		MUIA_Group_Horiz, TRUE,
		Child, GR_MainLeftLV,
		Child, GR_MainCmd,
		Child, GR_MainRightLV,
	End;
	//------------------------------------------

	MBObj->BT_MainAdd = SimpleButton("Add");

	MBObj->BT_MainDelete = SimpleButton("Delete");

	MBObj->BT_MainCopy = SimpleButton("Copy");

	MBObj->BT_MainClear = SimpleButton("Clear");

	MBObj->BT_MainExchange = SimpleButton("Exchange");

	MBObj->BT_MainTransform = SimpleButton("Transform");

	GR_ClipAddMod = GroupObject,
		MUIA_HelpNode, "GR_ClipAddMod",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainAdd,
		Child, MBObj->BT_MainDelete,
		Child, MBObj->BT_MainCopy,
		Child, MBObj->BT_MainClear,
		Child, MBObj->BT_MainExchange,
		Child, MBObj->BT_MainTransform,
	End;

	MBObj->BT_MainSave = SimpleButton("Save");

	MBObj->BT_MainInsert = SimpleButton("Insert");

	GR_MainIO = GroupObject,
		MUIA_HelpNode, "GR_MainIO",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MainSave,
		Child, MBObj->BT_MainInsert,
	End;

	GR_MainOverallCmd = GroupObject,
		MUIA_HelpNode, "GR_MainOverallCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Commands",
		Child, GR_ClipAddMod,
		Child, GR_MainIO,
	End;

	GP_RT_Main = GroupObject,
		Child, GR_MainUp,
		Child, GR_MainLV,
		Child, GR_MainOverallCmd,
	End;

	MBObj->MNProjectNewAll = MenuitemObject,
		MUIA_Menuitem_Title, "All",
	End;

	MBObj->MNProjectNewOnlyMain = MenuitemObject,
		MUIA_Menuitem_Title, "Only main world",
	End;

	MBObj->MNProjectNewOnlyClip = MenuitemObject,
		MUIA_Menuitem_Title, "Only clip world",
	End;

	MNProjectNew = MenuitemObject,
		MUIA_Menuitem_Title, "New",
		MUIA_Family_Child, MBObj->MNProjectNewAll,
		MUIA_Family_Child, MBObj->MNProjectNewOnlyMain,
		MUIA_Family_Child, MBObj->MNProjectNewOnlyClip,
	End;

	MNMenuBarBarLabel4 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectOpen = MenuitemObject,
		MUIA_Menuitem_Title, "Open",
	End;

	MBObj->MNProjectSave = MenuitemObject,
		MUIA_Menuitem_Title, "Save",
	End;

	MBObj->MNProjectSaveasVRML = MenuitemObject,
		MUIA_Menuitem_Title, "VRML V1.0 ascii",
	End;

	MBObj->MNProjectSaveasVRML2 = MenuitemObject,
		MUIA_Menuitem_Title, "VRML V2.0 utf8",
	End;

	MBObj->MNProjectSaveasOpenGL = MenuitemObject,
		MUIA_Menuitem_Title, "OpenGL source code",
	End;

	MNProjectSaveas = MenuitemObject,
		MUIA_Menuitem_Title, "Save as",
		MUIA_Family_Child, MBObj->MNProjectSaveasVRML,
		MUIA_Family_Child, MBObj->MNProjectSaveasVRML2,
		MUIA_Family_Child, MBObj->MNProjectSaveasOpenGL,
	End;

	MNProjectBarLabel0 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNProjectExport = MenuitemObject,
		MUIA_Menuitem_Title, "Export",
	End;

	MNProjectBarLabel15 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

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
		MUIA_Family_Child, MNMenuBarBarLabel4,
		MUIA_Family_Child, MBObj->MNProjectOpen,
		MUIA_Family_Child, MBObj->MNProjectSave,
		MUIA_Family_Child, MNProjectSaveas,
		MUIA_Family_Child, MNProjectBarLabel0,
		MUIA_Family_Child, MBObj->MNProjectExport,
		MUIA_Family_Child, MNProjectBarLabel15,
		MUIA_Family_Child, MBObj->MNProjectAbout,
		MUIA_Family_Child, MBObj->MNProjectAboutMUI,
		MUIA_Family_Child, MNMenuBarBarLabel2,
		MUIA_Family_Child, MBObj->MNProjectQuit,
	End;

	MBObj->MNEditCut = MenuitemObject,
		MUIA_Menuitem_Title, "Cut",
	End;

	MBObj->MNEditCopy = MenuitemObject,
		MUIA_Menuitem_Title, "Copy",
	End;

	MBObj->MNEditPaste = MenuitemObject,
		MUIA_Menuitem_Title, "Paste",
	End;

	MNMenuBarEdit = MenuitemObject,
		MUIA_Menuitem_Title, "Edit",
		MUIA_Family_Child, MBObj->MNEditCut,
		MUIA_Family_Child, MBObj->MNEditCopy,
		MUIA_Family_Child, MBObj->MNEditPaste,
	End;

	MBObj->MNOptionParseroutput = MenuitemObject,
		MUIA_Menuitem_Title, "Parser output",
		MUIA_Menuitem_Checkit, TRUE,
		MUIA_Menuitem_Toggle, TRUE,
	End;

	MNMenuBarBarLabel3 = MUI_MakeObject(MUIO_Menuitem, NM_BARLABEL, 0, 0, 0);

	MBObj->MNOptionPrefs = MenuitemObject,
		MUIA_Menuitem_Title, "Prefs",
	End;

	MNOption = MenuitemObject,
		MUIA_Menuitem_Title, "Option",
		MUIA_Family_Child, MBObj->MNOptionParseroutput,
		MUIA_Family_Child, MNMenuBarBarLabel3,
		MUIA_Family_Child, MBObj->MNOptionPrefs,
	End;

	MBObj->MN_MenuBar = MenustripObject,
		MUIA_Family_Child, MNProject,
		MUIA_Family_Child, MNMenuBarEdit,
		MUIA_Family_Child, MNOption,
	End;

	MBObj->WI_Main = WindowObject,
		MUIA_Window_Title, "VRML World:<NONE>",
		MUIA_Window_Menustrip, MBObj->MN_MenuBar,
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GP_RT_Main,
	End;
}

