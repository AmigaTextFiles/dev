#include "MUI_CPP.include"

void CreateWI_TransformSeparator(struct ObjApp *MBObj)
{
	APTR    GP_RT_TransformSeparator, obj_aux0, obj_aux1, GR_grp_81C, LA_label_21C;
	APTR    GR_grp_82C;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_TX_TransformSeparatorNum = NULL;

	MBObj->STR_DEFTransformSeparatorName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFTransformSeparatorName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFTransformSeparatorName,
	End;

	LA_label_21C = Label("Number of children");

	MBObj->TX_TransformSeparatorNum = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_TransformSeparatorNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_81C = GroupObject,
		MUIA_HelpNode, "GR_grp_81C",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Informations",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_21C,
		Child, MBObj->TX_TransformSeparatorNum,
	End;

	MBObj->BT_TransformSeparatorOk = SimpleButton("Ok");

	GR_grp_82C = GroupObject,
		MUIA_HelpNode, "GR_grp_82C",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_TransformSeparatorOk,
	End;

	GP_RT_TransformSeparator = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_81C,
		Child, GR_grp_82C,
	End;

	MBObj->WI_TransformSeparator = WindowObject,
		MUIA_Window_Title, "TransformSeparator",
		MUIA_Window_ID, MAKE_ID('3', '7', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_TransformSeparator,
	End;

}
