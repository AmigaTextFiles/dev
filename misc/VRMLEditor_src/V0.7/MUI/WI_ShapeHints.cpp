#include "MUI_CPP.include"

void CreateWI_ShapeHints(struct ObjApp *MBObj)
{
	APTR    GP_RT_ShapeHints, obj_aux0, obj_aux1, GR_grp_168, GR_grp_169, LA_label_46;
	APTR    LA_label_47, LA_label_48, obj_aux2, obj_aux3, GR_grp_170;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};
	*/

	MBObj->CY_ShapeHintsVertexOrderingContent[0] = "UNKNOW_ORDERING";
	MBObj->CY_ShapeHintsVertexOrderingContent[1] = "CLOCKWISE";
	MBObj->CY_ShapeHintsVertexOrderingContent[2] = "COUNTERCLOCKWISE";
	MBObj->CY_ShapeHintsVertexOrderingContent[3] = NULL;
	MBObj->CY_ShapeHintsShapeTypeContent[0] = "UNKNOW_SHAPE_TYPE";
	MBObj->CY_ShapeHintsShapeTypeContent[1] = "SOLID";
	MBObj->CY_ShapeHintsShapeTypeContent[2] = NULL;
	MBObj->CY_ShapeHintsFaceTypeContent[0] = "CONVEX";
	MBObj->CY_ShapeHintsFaceTypeContent[1] = "UNKNOW_FACE_TYPE";
	MBObj->CY_ShapeHintsFaceTypeContent[2] = NULL;

	MBObj->STR_DEFShapeHintsName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFShapeHintsName",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFShapeHintsName,
	End;

	LA_label_46 = Label("vertexOrdering");

	MBObj->CY_ShapeHintsVertexOrdering = CycleObject,
		MUIA_HelpNode, "CY_ShapeHintsVertexOrdering",
		MUIA_Cycle_Entries, MBObj->CY_ShapeHintsVertexOrderingContent,
	End;

	LA_label_47 = Label("shapeType");

	MBObj->CY_ShapeHintsShapeType = CycleObject,
		MUIA_HelpNode, "CY_ShapeHintsShapeType",
		MUIA_Cycle_Entries, MBObj->CY_ShapeHintsShapeTypeContent,
	End;

	LA_label_48 = Label("faceType");

	MBObj->CY_ShapeHintsFaceType = CycleObject,
		MUIA_HelpNode, "CY_ShapeHintsFaceType",
		MUIA_Cycle_Entries, MBObj->CY_ShapeHintsFaceTypeContent,
	End;

	GR_grp_169 = GroupObject,
		MUIA_HelpNode, "GR_grp_169",
		MUIA_Group_Columns, 2,
		Child, LA_label_46,
		Child, MBObj->CY_ShapeHintsVertexOrdering,
		Child, LA_label_47,
		Child, MBObj->CY_ShapeHintsShapeType,
		Child, LA_label_48,
		Child, MBObj->CY_ShapeHintsFaceType,
	End;

	MBObj->STR_ShapeHintsCreaseAngle = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_ShapeHintsCreaseAngle",
		MUIA_String_Contents, "0.5",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("creaseAngle");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_ShapeHintsCreaseAngle,
	End;

	GR_grp_168 = GroupObject,
		MUIA_HelpNode, "GR_grp_168",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_grp_169,
		Child, obj_aux2,
	End;

	MBObj->BT_ShapeHintsOk = SimpleButton("Ok");

	MBObj->BT_ShapeHintsDefault = SimpleButton("Default");

	MBObj->BT_ShapeHintsCancel = SimpleButton("Cancel");

	GR_grp_170 = GroupObject,
		MUIA_HelpNode, "GR_grp_170",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_ShapeHintsOk,
		Child, MBObj->BT_ShapeHintsDefault,
		Child, MBObj->BT_ShapeHintsCancel,
	End;

	GP_RT_ShapeHints = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_168,
		Child, GR_grp_170,
	End;

	MBObj->WI_ShapeHints = WindowObject,
		MUIA_Window_Title, "ShapeHints",
		MUIA_Window_ID, MAKE_ID('2', '8', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_ShapeHints,
	End;


}

