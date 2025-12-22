#include "MUI_CPP.include"

void CreateWI_SaveAs(struct ObjApp *MBObj)
{
	APTR    GP_RT_SaveAs, GR_grp_280, Space_44, LA_label_69, LA_label_70;
	APTR    LA_label_72,  LA_label_71, GR_SaveAsCmd, LA_label_73, LA_label_74;

	// MBObj->STR_TX_SaveAsFormat = "VRML V1.0 ascii";

	MBObj->STR_PA_SaveAs = String("", 80);

	MBObj->PA_SaveAs = PopButton(MUII_PopFile);

	MBObj->PA_SaveAs = PopaslObject,
		MUIA_HelpNode, "PA_SaveAs",
		MUIA_Popasl_Type, 0,
		MUIA_Popstring_String, MBObj->STR_PA_SaveAs,
		MUIA_Popstring_Button, MBObj->PA_SaveAs,
	End;

	MBObj->TX_SaveAsFormat = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		// MUIA_Text_Contents, MBObj->STR_TX_label_19,
		MUIA_Text_SetMin, TRUE,
	End;

	Space_44 = HVSpace;

	GR_grp_280 = GroupObject,
		MUIA_HelpNode, "GR_grp_280",
		Child, MBObj->PA_SaveAs,
		Child, MBObj->TX_SaveAsFormat,
		Child, Space_44,
	End;

	LA_label_69 = Label("Generate 'Inlines' Texture images");

	MBObj->CH_SaveAsV1Tex = CheckMark(FALSE);

	LA_label_70 = Label("Generate VRML Code for WWWInlines");

	MBObj->CH_SaveAsV1Inlines = CheckMark(FALSE);

	LA_label_73 = Label("Compress saved world");

	MBObj->CH_SaveAsV1Compress = CheckMark(FALSE);

	LA_label_74 = Label("Generate normals");

	MBObj->CH_SaveAsV1Normals = CheckMark(FALSE);

	MBObj->GR_SaveAsV1 = GroupObject,
		MUIA_HelpNode, "GR_SaveAsV1",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "VRML V1.0",
		MUIA_Group_Columns, 2,
		Child, LA_label_69,
		Child, MBObj->CH_SaveAsV1Tex,
		Child, LA_label_70,
		Child, MBObj->CH_SaveAsV1Inlines,
		Child, LA_label_73,
		Child, MBObj->CH_SaveAsV1Compress,
		Child, LA_label_74,
		Child, MBObj->CH_SaveAsV1Normals,
	End;

	LA_label_72 = Label("Generate 'inlines' Texture images");

	MBObj->CH_SaveAsV2Tex = CheckMark(FALSE);

	MBObj->GR_SaveAsV2 = GroupObject,
		MUIA_HelpNode, "GR_SaveAsV2",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "VRML V2.0",
		MUIA_Group_Columns, 2,
		Child, LA_label_72,
		Child, MBObj->CH_SaveAsV2Tex,
	End;

	LA_label_71 = Label("Generate Texture code");

	MBObj->CH_SaveAsGLTex = CheckMark(FALSE);

	MBObj->GR_SaveAsGL = GroupObject,
		MUIA_HelpNode, "GR_SaveAsGL",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "OpenGL",
		MUIA_Group_Columns, 2,
		Child, LA_label_71,
		Child, MBObj->CH_SaveAsGLTex,
	End;

	MBObj->BT_SaveAsSave = SimpleButton("Save");

	GR_SaveAsCmd = GroupObject,
		MUIA_HelpNode, "GR_SaveAsCmd",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		Child, MBObj->BT_SaveAsSave,
	End;

	GP_RT_SaveAs = GroupObject,
		Child, GR_grp_280,
		Child, MBObj->GR_SaveAsV1,
		Child, MBObj->GR_SaveAsV2,
		Child, MBObj->GR_SaveAsGL,
		Child, GR_SaveAsCmd,
	End;

	MBObj->WI_SaveAs = WindowObject,
		MUIA_Window_Title, "Save as",
		// MUIA_Window_ID, MAKE_ID('4', '0', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_SaveAs,
	End;
}

