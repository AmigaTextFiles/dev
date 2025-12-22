#include "MUI_CPP.include"

void CreateWI_Translation(struct ObjApp *MBObj)
{
	APTR    GP_RT_Translate, obj_aux0, obj_aux1, GR_TranslateAttributs, obj_aux2;
	APTR    obj_aux3, obj_aux4, obj_aux5, obj_aux6, obj_aux7, GR_TranslateConfirm;
	// static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	// static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	// static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	// static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	MBObj->STR_DEFTranslationName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFTranslationName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFTranslationName,
	End;

	MBObj->STR_TranslationX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TranslationX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_TranslationX,
	End;

	MBObj->STR_TranslationY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TranslationY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_TranslationY,
	End;

	MBObj->STR_TranslationZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TranslationZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_TranslationZ,
	End;

	GR_TranslateAttributs = GroupObject,
		MUIA_HelpNode, "GR_TranslateAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->BT_TranslationOk = SimpleButton("Ok");

	MBObj->BT_TranslationDefault = SimpleButton("Default");

	MBObj->BT_TranslationCancel = SimpleButton("Cancel");

	GR_TranslateConfirm = GroupObject,
		MUIA_HelpNode, "GR_TranslateConfirm",
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_TranslationOk,
		Child, MBObj->BT_TranslationDefault,
		Child, MBObj->BT_TranslationCancel,
	End;

	GP_RT_Translate = GroupObject,
		Child, obj_aux0,
		Child, GR_TranslateAttributs,
		Child, GR_TranslateConfirm,
	End;

	MBObj->WI_Translation = WindowObject,
		MUIA_Window_Title, "Translation",
		MUIA_Window_ID, MAKE_ID('5', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Translate,
	End;

}

