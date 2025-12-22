#include "MUI_CPP.include"

void CreateWI_Sphere(struct ObjApp *MBObj)
{
	APTR    GP_RT_Sphere, obj_aux0, obj_aux1, GR_grp_208, obj_aux2, obj_aux3;
	APTR    GR_grp_209;

	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->STR_DEFSphereName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFSphereName",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFSphereName,
	End;

	MBObj->STR_SphereRadius = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_SphereRadius",
		MUIA_String_Contents, "2",
		MUIA_String_Accept, "-0123456789.",
	End;

	obj_aux3 = Label2("radius");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_SphereRadius,
	End;

	MBObj->BT_SphereOk = SimpleButton("Ok");

	MBObj->BT_SphereDefault = SimpleButton("Default");

	MBObj->BT_SphereCancel = SimpleButton("Cancel");

	GR_grp_209 = GroupObject,
		MUIA_HelpNode, "GR_grp_209",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_SphereOk,
		Child, MBObj->BT_SphereDefault,
		Child, MBObj->BT_SphereCancel,
	End;

	GR_grp_208 = GroupObject,
		MUIA_HelpNode, "GR_grp_208",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attribut",
		Child, obj_aux2,
		Child, GR_grp_209,
	End;

	GP_RT_Sphere = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_208,
	End;

	MBObj->WI_Sphere = WindowObject,
		MUIA_Window_Title, "Sphere",
		MUIA_Window_ID, MAKE_ID('3', '8', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Sphere,
	End;

}

