#include "MUI_CPP.include"

void CreateWI_Coordinate3(struct ObjApp *MBObj)
{
	APTR    GP_RT_Coordinate3, GR_Coordinate3Names, obj_aux0, obj_aux1, LA_Coordinate3Num;
	APTR    GR_Coordinate3Attributs, GR_Coordinate3Index, GR_Coordinate3Coord;
	APTR    obj_aux2, obj_aux3, obj_aux4, obj_aux5, obj_aux6, obj_aux7, GR_Coordinate3Actions;
	APTR    GR_Coordinate3Confirm;
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook CoordinateChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) CoordinateChangeContents, NULL, NULL};


	MBObj->STR_TX_Coordinate3Num = "0";
	MBObj->STR_TX_Coordinate3Index = "0";

	MBObj->STR_DEFCoordinate3Name = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFCoordinate3Name",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFCoordinate3Name,
	End;

	LA_Coordinate3Num = Label("Num");

	MBObj->TX_Coordinate3Num = TextObject,
		MUIA_Weight, 40,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Coordinate3Num,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_Coordinate3Names = GroupObject,
		MUIA_HelpNode, "GR_Coordinate3Names",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux0,
		Child, LA_Coordinate3Num,
		Child, MBObj->TX_Coordinate3Num,
	End;

	MBObj->TX_Coordinate3Index = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Coordinate3Index,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_Coordinate3Index = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_Coordinate3Index",
		MUIA_Prop_Entries, 1,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 1,
		MUIA_FixHeight, 8,
	End;

	GR_Coordinate3Index = GroupObject,
		MUIA_HelpNode, "GR_Coordinate3Index",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_Coordinate3Index,
		Child, MBObj->PR_Coordinate3Index,
	End;

	MBObj->STR_Coordinate3X = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Coordinate3X",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.-",
	End;

	obj_aux3 = Label2("X");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->STR_Coordinate3X,
	End;

	MBObj->STR_Coordinate3Y = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Coordinate3Y",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.",
	End;

	obj_aux5 = Label2("Y");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_Coordinate3Y,
	End;

	MBObj->STR_Coordinate3Z = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Coordinate3Z",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "-0123456789.",
	End;

	obj_aux7 = Label2("Z");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->STR_Coordinate3Z,
	End;

	GR_Coordinate3Coord = GroupObject,
		MUIA_HelpNode, "GR_Coordinate3Coord",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "point",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	GR_Coordinate3Attributs = GroupObject,
		MUIA_HelpNode, "GR_Coordinate3Attributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_Coordinate3Index,
		Child, GR_Coordinate3Coord,
	End;

	MBObj->BT_Coordinate3Add = SimpleButton("Add");

	MBObj->BT_Coordinate3Delete = SimpleButton("Delete");

	GR_Coordinate3Actions = GroupObject,
		MUIA_HelpNode, "GR_Coordinate3Actions",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Actions",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_Coordinate3Add,
		Child, MBObj->BT_Coordinate3Delete,
	End;

	MBObj->BT_Coordinate3Ok = SimpleButton("Ok");

	MBObj->BT_Coordinate3Cancel = SimpleButton("Cancel");

	GR_Coordinate3Confirm = GroupObject,
		MUIA_HelpNode, "GR_Coordinate3Confirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_Coordinate3Ok,
		Child, MBObj->BT_Coordinate3Cancel,
	End;

	GP_RT_Coordinate3 = GroupObject,
		Child, GR_Coordinate3Names,
		Child, GR_Coordinate3Attributs,
		Child, GR_Coordinate3Actions,
		Child, GR_Coordinate3Confirm,
	End;

	MBObj->WI_Coordinate3 = WindowObject,
		MUIA_Window_Title, "Coordinate3",
		MUIA_Window_ID, MAKE_ID('1', '2', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Coordinate3,
	End;
}

