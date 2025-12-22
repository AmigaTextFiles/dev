#include "MUI_CPP.include"

void CreateWI_NormalBinding(struct ObjApp *MBObj)
{
	APTR    GP_RT_NormalBinding, obj_aux0, obj_aux1, GR_grp_134, LA_label_36;
	APTR    GR_grp_135;
	// static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	// static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->CY_NormalBindingValueContent[0] = "OVERALL";
	MBObj->CY_NormalBindingValueContent[1] = "DEFAULT";
	MBObj->CY_NormalBindingValueContent[2] = "PER_PART";
	MBObj->CY_NormalBindingValueContent[3] = "PER_PART_INDEXED";
	MBObj->CY_NormalBindingValueContent[4] = "PER_FACE";
	MBObj->CY_NormalBindingValueContent[5] = "PER_FACE_INDEXED";
	MBObj->CY_NormalBindingValueContent[6] = "PER_VERTEX";
	MBObj->CY_NormalBindingValueContent[7] = "PER_VERTEX_INDEXED";
	MBObj->CY_NormalBindingValueContent[8] = NULL;

	MBObj->STR_DEFNormalBindingName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFNormalBindingName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFNormalBindingName,
	End;

	LA_label_36 = Label("value:");

	MBObj->CY_NormalBindingValue = CycleObject,
		MUIA_HelpNode, "CY_NormalBindingValue",
		MUIA_Cycle_Entries, MBObj->CY_NormalBindingValueContent,
	End;

	GR_grp_134 = GroupObject,
		MUIA_HelpNode, "GR_grp_134",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_36,
		Child, MBObj->CY_NormalBindingValue,
	End;

	MBObj->BT_NormalBindingOk = SimpleButton("Ok");

	MBObj->BT_NormalBindingCancel = SimpleButton("Cancel");

	GR_grp_135 = GroupObject,
		MUIA_HelpNode, "GR_grp_135",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_NormalBindingOk,
		Child, MBObj->BT_NormalBindingCancel,
	End;

	GP_RT_NormalBinding = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_134,
		Child, GR_grp_135,
	End;

	MBObj->WI_NormalBinding = WindowObject,
		MUIA_Window_Title, "NormalBinding",
		MUIA_Window_ID, MAKE_ID('2', '3', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_NormalBinding,
	End;

}

