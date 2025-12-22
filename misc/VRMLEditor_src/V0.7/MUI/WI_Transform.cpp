#include "MUI_CPP.include"

void CreateWI_Transform(struct ObjApp *MBObj)
{
	APTR    GP_RT_Transform, obj_aux0, obj_aux1, GR_grp_200, GR_TTranslation;
	APTR    obj_aux2, obj_aux3, obj_aux4, obj_aux5, obj_aux6, obj_aux7, GR_TRotation;
	APTR    obj_aux8, obj_aux9, obj_aux10, obj_aux11, obj_aux12, obj_aux13, obj_aux14;
	APTR    obj_aux15, GR_TScalefactor, obj_aux16, obj_aux17, obj_aux18, obj_aux19;
	APTR    obj_aux20, obj_aux21, GR_TScaleorientation, obj_aux22, obj_aux23;
	APTR    obj_aux24, obj_aux25, obj_aux26, obj_aux27, obj_aux28, obj_aux29;
	APTR    GR_TCenter, obj_aux30, obj_aux31, obj_aux32, obj_aux33, obj_aux34;
	APTR    obj_aux35, GR_TransformConfirm;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/
	MBObj->STR_DEFTransformName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFTransformName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFTransformName,
	End;

	MBObj->STR_TTranslationX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TTranslationX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_TTranslationX,
	End;

	MBObj->STR_TTranslationY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TTranslationY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_TTranslationY,
	End;

	MBObj->STR_TTranslationZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TTranslationZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_TTranslationZ,
	End;

	GR_TTranslation = GroupObject,
		MUIA_HelpNode, "GR_TTranslation",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Translation",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->STR_TRotationX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TRotationX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux9 = Label2("X");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->STR_TRotationX,
	End;

	MBObj->STR_TRotationY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TRotationY",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux11 = Label2("Y");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->STR_TRotationY,
	End;

	MBObj->STR_TRotationZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TRotationZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux13 = Label2("Z");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->STR_TRotationZ,
	End;

	MBObj->STR_TRotationA = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TRotationA",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux15 = Label2("Angle (DEG)");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->STR_TRotationA,
	End;

	GR_TRotation = GroupObject,
		MUIA_HelpNode, "GR_TRotation",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Rotation",
		Child, obj_aux8,
		Child, obj_aux10,
		Child, obj_aux12,
		Child, obj_aux14,
	End;

	MBObj->STR_TScaleFX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleFX",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux17 = Label2("X");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->STR_TScaleFX,
	End;

	MBObj->STR_TScaleFY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleFY",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux19 = Label2("Y");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->STR_TScaleFY,
	End;

	MBObj->STR_TScaleFZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleFZ",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux21 = Label2("Z");

	obj_aux20 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux21,
		Child, MBObj->STR_TScaleFZ,
	End;

	GR_TScalefactor = GroupObject,
		MUIA_HelpNode, "GR_TScalefactor",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Scalefactor",
		Child, obj_aux16,
		Child, obj_aux18,
		Child, obj_aux20,
	End;

	MBObj->STR_TScaleOX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleOX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux23 = Label2("X");

	obj_aux22 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux23,
		Child, MBObj->STR_TScaleOX,
	End;

	MBObj->STR_TScaleOY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleOY",
		MUIA_String_Contents, "1",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux25 = Label2("Y");

	obj_aux24 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux25,
		Child, MBObj->STR_TScaleOY,
	End;

	MBObj->STR_TScaleOZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleOZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux27 = Label2("Z");

	obj_aux26 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux27,
		Child, MBObj->STR_TScaleOZ,
	End;

	MBObj->STR_TScaleOA = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TScaleOA",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux29 = Label2("Angle (DEG)");

	obj_aux28 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux29,
		Child, MBObj->STR_TScaleOA,
	End;

	GR_TScaleorientation = GroupObject,
		MUIA_HelpNode, "GR_TScaleorientation",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Scale orientation",
		Child, obj_aux22,
		Child, obj_aux24,
		Child, obj_aux26,
		Child, obj_aux28,
	End;

	GR_grp_200 = GroupObject,
		MUIA_HelpNode, "GR_grp_200",
		MUIA_Group_Columns, 2,
		Child, GR_TTranslation,
		Child, GR_TRotation,
		Child, GR_TScalefactor,
		Child, GR_TScaleorientation,
	End;

	MBObj->STR_TCenterX = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TCenterX",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux31 = Label2("X");

	obj_aux30 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux31,
		Child, MBObj->STR_TCenterX,
	End;

	MBObj->STR_TCenterY = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TCenterY",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux33 = Label2("Y");

	obj_aux32 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux33,
		Child, MBObj->STR_TCenterY,
	End;

	MBObj->STR_TCenterZ = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_TCenterZ",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.e",
	End;

	obj_aux35 = Label2("Z");

	obj_aux34 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux35,
		Child, MBObj->STR_TCenterZ,
	End;

	GR_TCenter = GroupObject,
		MUIA_HelpNode, "GR_TCenter",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Center",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux30,
		Child, obj_aux32,
		Child, obj_aux34,
	End;

	MBObj->BT_TransformOk = SimpleButton("Ok");

	MBObj->BT_TransformDefault = SimpleButton("Default");

	MBObj->BT_TransformCancel = SimpleButton("Cancel");

	GR_TransformConfirm = GroupObject,
		MUIA_HelpNode, "GR_TransformConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_TransformOk,
		Child, MBObj->BT_TransformDefault,
		Child, MBObj->BT_TransformCancel,
	End;

	GP_RT_Transform = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_200,
		Child, GR_TCenter,
		Child, GR_TransformConfirm,
	End;

	MBObj->WI_Transform = WindowObject,
		MUIA_Window_Title, "Transform",
		MUIA_Window_ID, MAKE_ID('3', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Transform,
	End;
}

