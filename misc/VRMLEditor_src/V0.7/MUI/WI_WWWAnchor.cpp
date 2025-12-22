#include "MUI_CPP.include"

void CreateWI_WWWAnchor(struct ObjApp *MBObj)
{
	APTR    GP_RT_WWWAnchor, obj_aux0, obj_aux1, GR_grp_183, LA_label_51, GR_grp_184;
	APTR    obj_aux2, obj_aux3, obj_aux4, obj_aux5, GR_grp_185, LA_label_52, GR_grp_186;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_TX_WWWAnchorNum = "0";

	MBObj->CY_WWWAnchorMapContent[0] = "NONE";
	MBObj->CY_WWWAnchorMapContent[1] = "POINT";
	MBObj->CY_WWWAnchorMapContent[2] = NULL;

	MBObj->STR_DEFWWWAnchorName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFWWWAnchorName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFWWWAnchorName,
	End;

	LA_label_51 = Label("Number of children");

	MBObj->TX_WWWAnchorNum = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_WWWAnchorNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_183 = GroupObject,
		MUIA_HelpNode, "GR_grp_183",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_51,
		Child, MBObj->TX_WWWAnchorNum,
	End;

	MBObj->STR_WWWAnchorName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWAnchorName",
	End;

	obj_aux3 = Label2("Name");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_WWWAnchorName,
	End;

	MBObj->STR_WWWAnchorDescription = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_WWWAnchorDescription",
	End;

	obj_aux5 = Label2("description");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_WWWAnchorDescription,
	End;

	LA_label_52 = Label("map");

	MBObj->CY_WWWAnchorMap = CycleObject,
		MUIA_HelpNode, "CY_WWWAnchorMap",
		MUIA_Cycle_Entries, MBObj->CY_WWWAnchorMapContent,
	End;

	GR_grp_185 = GroupObject,
		MUIA_HelpNode, "GR_grp_185",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_52,
		Child, MBObj->CY_WWWAnchorMap,
	End;

	GR_grp_184 = GroupObject,
		MUIA_HelpNode, "GR_grp_184",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, GR_grp_185,
	End;

	MBObj->BT_WWWAnchorOk = SimpleButton("Ok");

	GR_grp_186 = GroupObject,
		MUIA_HelpNode, "GR_grp_186",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_WWWAnchorOk,
	End;

	GP_RT_WWWAnchor = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_183,
		Child, GR_grp_184,
		Child, GR_grp_186,
	End;

	MBObj->WI_WWWAnchor = WindowObject,
		MUIA_Window_Title, "WWWAnchor",
		MUIA_Window_ID, MAKE_ID('3', '4', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_WWWAnchor,
	End;

}

