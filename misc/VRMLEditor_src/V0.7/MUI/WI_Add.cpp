#include "MUI_CPP.include"

void CreateWI_Add(struct ObjApp *MBObj)
{
	APTR    GP_RT_Add, obj_aux0, obj_aux1, GR_AddConfirm;
	// static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	// static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	// static const struct Hook ChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) ChangeContents, NULL, NULL};

	char *entries[]={
		"AsciiText",
		"Cone","Coordinate3","Cube","Cylinder",
		"DirectionalLight",
		"FontStyle",
		"Group",
		"IndexedFaceSet","IndexedLineSet","Info",
		"LOD",
		"Material","MaterialBinding","MatrixTransform",
		"Normal","NormalBinding",
		"OrthographicCamera",
		"PerspectiveCamera","PointLight","PointSet",
		"Rotation",
		"Scale","Separator","ShapeHints","Sphere","SpotLight","Switch",
		"Texture2","Texture2Transform","TextureCoordinate2",
		"Transform","TransformSeparator","Translation",
		"WWWAnchor","WWWInline",
		NULL
	};
	

	MBObj->LV_AddNode = ListObject,
		MUIA_Frame, MUIV_Frame_InputList,
		MUIA_List_Active, MUIV_List_Active_Top,
		MUIA_List_ConstructHook, MUIV_List_ConstructHook_String,
		MUIA_List_DestructHook, MUIV_List_DestructHook_String,
		MUIA_List_Entries, entries,
	End;

	MBObj->LV_AddNode = ListviewObject,
		MUIA_HelpNode, "LV_AddNode",
		MUIA_Listview_DoubleClick, TRUE,
		MUIA_Listview_List, MBObj->LV_AddNode,
	End;

	MBObj->STR_AddNodeName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_AddNodeName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("Node name");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_AddNodeName,
	End;

	MBObj->BT_AddOk = SimpleButton("Ok");

	MBObj->BT_AddCancel = SimpleButton("Cancel");

	GR_AddConfirm = GroupObject,
		MUIA_HelpNode, "GR_AddConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_AddOk,
		Child, MBObj->BT_AddCancel,
	End;

	GP_RT_Add = GroupObject,
		Child, MBObj->LV_AddNode,
		Child, obj_aux0,
		Child, GR_AddConfirm,
	End;

	MBObj->WI_Add = WindowObject,
		MUIA_Window_Title, "Choose",
		MUIA_Window_ID, MAKE_ID('2', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Add,
	End;

	DoMethod((Object *) MBObj->LV_AddNode,MUIM_List_Insert,entries,-1,MUIV_List_Insert_Bottom);
}

