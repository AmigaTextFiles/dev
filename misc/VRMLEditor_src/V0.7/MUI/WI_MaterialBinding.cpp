#include "MUI_CPP.include"

void CreateWI_MaterialBinding(struct ObjApp *MBObj)
{
	APTR    GP_RT_MatBind, obj_aux0, obj_aux1, GR_grp_165, LA_MatrielBinding;
	APTR    GR_MatBindConfirm;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->CY_MaterialBindingContent[0] = "OVERALL";
	MBObj->CY_MaterialBindingContent[1] = "DEFAULT";
	MBObj->CY_MaterialBindingContent[2] = "PER_PART";
	MBObj->CY_MaterialBindingContent[3] = "PER_PART_INDEXED";
	MBObj->CY_MaterialBindingContent[4] = "PER_FACE";
	MBObj->CY_MaterialBindingContent[5] = "PER_FACE_INDEXED";
	MBObj->CY_MaterialBindingContent[6] = "PER_VERTEX";
	MBObj->CY_MaterialBindingContent[7] = "PER_VERTEX_INDEXED";
	MBObj->CY_MaterialBindingContent[8] = NULL;

	MBObj->STR_DEFMaterialBindingName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFMaterialBindingName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFMaterialBindingName,
	End;

	LA_MatrielBinding = Label("value");

	MBObj->CY_MaterialBinding = CycleObject,
		MUIA_HelpNode, "CY_MaterialBinding",
		MUIA_Cycle_Entries, MBObj->CY_MaterialBindingContent,
	End;

	GR_grp_165 = GroupObject,
		MUIA_HelpNode, "GR_grp_165",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		MUIA_Group_Horiz, TRUE,
		Child, LA_MatrielBinding,
		Child, MBObj->CY_MaterialBinding,
	End;

	MBObj->BT_MaterialBindingOk = SimpleButton("Ok");

	MBObj->BT_MaterialBindingCancel = SimpleButton("Cancel");

	GR_MatBindConfirm = GroupObject,
		MUIA_HelpNode, "GR_MatBindConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MaterialBindingOk,
		Child, MBObj->BT_MaterialBindingCancel,
	End;

	GP_RT_MatBind = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_165,
		Child, GR_MatBindConfirm,
	End;

	MBObj->WI_MaterialBinding = WindowObject,
		MUIA_Window_Title, "MaterialBinding",
		MUIA_Window_ID, MAKE_ID('8', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_MatBind,
	End;
}

