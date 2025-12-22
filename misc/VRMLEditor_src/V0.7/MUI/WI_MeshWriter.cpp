#include "MUI_CPP.include"

// #include <meshwriter/meshwriter.h>
// #include <proto/meshwriter.h>

// #include <meshwriter/meshwriter.h>
// STRPTR *MWL3DFileFormatNamesGet();

void CreateWI_MeshWriter(struct ObjApp *MBObj) {
	APTR    GP_RT_Meshwriter, GR_grp_269, LA_label_66, GR_grp_270, LA_label_67;
	APTR    obj_aux0, obj_aux1;

	// MBObj->CY_MWFormatContent[0] = "format";
	// MBObj->CY_MWFormatContent[1] = NULL;

	LA_label_66 = Label("Format");

	MBObj->CY_MWFormat = CycleObject,
		MUIA_HelpNode, "CY_MWFormat",
		// MUIA_Cycle_Entries, MWL3DFileFormatNamesGet(),
		// MUIA_Cycle_Entries, MBObj->CY_MWFormatContent,
	End;

	GR_grp_269 = GroupObject,
		MUIA_HelpNode, "GR_grp_269",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_66,
		Child, MBObj->CY_MWFormat,
	End;

	LA_label_67 = Label("Save as");

	MBObj->STR_PA_MWName = String("", 80);

	MBObj->PA_MWName = PopButton(MUII_PopFile);

	MBObj->PA_MWName = PopaslObject,
		MUIA_HelpNode, "PA_MWName",
		MUIA_Popasl_Type, 0,
		MUIA_Popstring_String, MBObj->STR_PA_MWName,
		MUIA_Popstring_Button, MBObj->PA_MWName,
	End;

	GR_grp_270 = GroupObject,
		MUIA_HelpNode, "GR_grp_270",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_67,
		Child, MBObj->PA_MWName,
	End;

	MBObj->STR_MWExtension = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MWExtension",
	End;

	obj_aux1 = Label2("Extension");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_MWExtension,
	End;

	MBObj->BT_MWSave = SimpleButton("Save");

	GP_RT_Meshwriter = GroupObject,
		Child, GR_grp_269,
		Child, GR_grp_270,
		Child, obj_aux0,
		Child, MBObj->BT_MWSave,
	End;

	MBObj->WI_MeshWriter = WindowObject,
		MUIA_Window_Title, "Meshwriter export",
		// MUIA_Window_ID, MAKE_ID('3', '7', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Meshwriter,
	End;
}

