#include "MUI_CPP.include"

#include <mui/GLArea_mcc.h>

#include "GLFunctions.h"

void CreateWI_Material(struct ObjApp *MBObj)
{
	APTR    GP_RT_Material, GR_MatNum, obj_aux0, obj_aux1, LA_MaterialNum, GR_MatAttributs;
	APTR    GR_MatActionIndexes, Space_31, GR_MatAction, GR_grp_251, GR_MatIndexes;
	APTR    Space_34, GR_MatColors, GR_MatAmbient, GR_MatAmbeintSliders, obj_aux2;
	APTR    obj_aux3, obj_aux4, obj_aux5, obj_aux6, obj_aux7, GR_MatDiffuse, GR_DiffuseSlider;
	APTR    obj_aux8, obj_aux9, obj_aux10, obj_aux11, obj_aux12, obj_aux13, GR_MatSpec;
	APTR    GR_MatSpecSliders, obj_aux14, obj_aux15, obj_aux16, obj_aux17, obj_aux18;
	APTR    obj_aux19, GR_MatEmmisive, GR_MatEmmisiveSliders, obj_aux20, obj_aux21;
	APTR    obj_aux22, obj_aux23, obj_aux24, obj_aux25, GR_MatShinines, obj_aux26;
	APTR    obj_aux27, obj_aux28, obj_aux29, GR_MatConfirm;
	/*
	static const struct Hook OkFuncHook = { {NULL, NULL}, (HOOKFUNC) OkFunc, NULL, NULL};
	static const struct Hook CancelFuncHook = { {NULL, NULL}, (HOOKFUNC) CancelFunc, NULL, NULL};
	static const struct Hook DefaultFuncHook = { {NULL, NULL}, (HOOKFUNC) DefaultFunc, NULL, NULL};
	static const struct Hook MatChangeContentsHook = { {NULL, NULL}, (HOOKFUNC) MatChangeContents, NULL, NULL};
	*/

	MBObj->STR_TX_MaterialNum = "1";
	MBObj->STR_TX_MaterialIndex = "0";

	MBObj->STR_DEFMaterialName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFMaterialName",
		MUIA_String_Contents, "NONE",
		MUIA_String_Reject, " ",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFMaterialName,
	End;

	LA_MaterialNum = Label("Total:");

	MBObj->TX_MaterialNum = TextObject,
		MUIA_Weight, 30,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_MaterialNum,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_MatNum = GroupObject,
		MUIA_HelpNode, "GR_MatNum",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux0,
		Child, LA_MaterialNum,
		Child, MBObj->TX_MaterialNum,
	End;

	// Space_31 = HVSpace;
	MBObj->AR_MatGLArea = GLAreaObject,
		// MUIA_FillArea, TRUE,
		MUIA_GLArea_MinWidth,100,
		MUIA_GLArea_MaxWidth,100,
		MUIA_GLArea_MinHeight, 80,
		MUIA_GLArea_MaxHeight, 80,
		MUIA_GLArea_Threaded, TRUE,
		// MUIA_GLArea_SingleTask, TRUE,
		MUIA_GLArea_DrawFunc, DrawMaterialPreviewScene,
	End;

	MBObj->GR_MatPreview = GroupObject,
		MUIA_HelpNode, "GR_MatPreview",
		MUIA_Weight, 50,
		// MUIA_Frame, MUIV_Frame_Group,
		// MUIA_FrameTitle, "Preview",
		Child, MBObj->AR_MatGLArea,
	End;

	MBObj->TX_MaterialIndex = TextObject,
		MUIA_Weight, 20,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_MaterialIndex,
		MUIA_Text_SetMin, TRUE,
	End;

	MBObj->PR_MaterialIndex = PropObject,
		PropFrame,
		MUIA_HelpNode, "PR_MaterialIndex",
		MUIA_Prop_Entries, 0,
		MUIA_Prop_First, 0,
		MUIA_Prop_Horiz, TRUE,
		MUIA_Prop_Visible, 0,
		MUIA_FixHeight, 8,
	End;

	GR_grp_251 = GroupObject,
		MUIA_HelpNode, "GR_grp_251",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->TX_MaterialIndex,
		Child, MBObj->PR_MaterialIndex,
	End;

	MBObj->BT_MaterialAdd = SimpleButton("Add");

	MBObj->BT_MaterialDelete = SimpleButton("Delete");

	GR_MatIndexes = GroupObject,
		MUIA_HelpNode, "GR_MatIndexes",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MaterialAdd,
		Child, MBObj->BT_MaterialDelete,
	End;

	Space_34 = HVSpace;

	GR_MatAction = GroupObject,
		MUIA_HelpNode, "GR_MatAction",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Actions",
		Child, GR_grp_251,
		Child, GR_MatIndexes,
		Child, Space_34,
	End;

	GR_MatActionIndexes = GroupObject,
		MUIA_HelpNode, "GR_MatActionIndexes",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->GR_MatPreview,
		Child, GR_MatAction,
	End;

	MBObj->SL_MaterialAR = SliderObject,
		MUIA_HelpNode, "SL_MaterialAR",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 20,
	End;

	obj_aux3 = Label2("R");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->SL_MaterialAR,
	End;

	MBObj->SL_MaterialAG = SliderObject,
		MUIA_HelpNode, "SL_MaterialAG",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 20,
	End;

	obj_aux5 = Label2("G");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->SL_MaterialAG,
	End;

	MBObj->SL_MaterialAB = SliderObject,
		MUIA_HelpNode, "SL_MaterialAB",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 20,
	End;

	obj_aux7 = Label2("B");

	obj_aux6 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux7,
		Child, MBObj->SL_MaterialAB,
	End;

	GR_MatAmbeintSliders = GroupObject,
		MUIA_HelpNode, "GR_MatAmbeintSliders",
		Child, obj_aux2,
		Child, obj_aux4,
		Child, obj_aux6,
	End;

	MBObj->CF_MaterialAmbient = ColorfieldObject,
		// MUIA_HelpNode, "CF_MaterialAmbient",
		MUIA_Weight, 50,
		MUIA_Colorfield_Red, -1,
		MUIA_Colorfield_Green, -1,
		MUIA_Colorfield_Blue, -1,
	End;

	GR_MatAmbient = GroupObject,
		MUIA_HelpNode, "GR_MatAmbient",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Ambient color",
		MUIA_Group_Horiz, TRUE,
		Child, GR_MatAmbeintSliders,
		Child, MBObj->CF_MaterialAmbient,
	End;

	MBObj->SL_MaterialDR = SliderObject,
		MUIA_HelpNode, "SL_MaterialDR",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 80,
	End;

	obj_aux9 = Label2("R");

	obj_aux8 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux9,
		Child, MBObj->SL_MaterialDR,
	End;

	MBObj->SL_MaterialDG = SliderObject,
		MUIA_HelpNode, "SL_MaterialDG",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 80,
	End;

	obj_aux11 = Label2("G");

	obj_aux10 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux11,
		Child, MBObj->SL_MaterialDG,
	End;

	MBObj->SL_MaterialDB = SliderObject,
		MUIA_HelpNode, "SL_MaterialDB",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 80,
	End;

	obj_aux13 = Label2("B");

	obj_aux12 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux13,
		Child, MBObj->SL_MaterialDB,
	End;

	GR_DiffuseSlider = GroupObject,
		MUIA_HelpNode, "GR_DiffuseSlider",
		Child, obj_aux8,
		Child, obj_aux10,
		Child, obj_aux12,
	End;

	MBObj->CF_MaterialDiffuse = ColorfieldObject,
		// MUIA_HelpNode, "CF_MaterialDiffuse",
		MUIA_Weight, 50,
		MUIA_Colorfield_Red, -1,
		MUIA_Colorfield_Green, -1,
		MUIA_Colorfield_Blue, -1,
	End;

	GR_MatDiffuse = GroupObject,
		MUIA_HelpNode, "GR_MatDiffuse",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Diffuse color",
		MUIA_Group_Horiz, TRUE,
		Child, GR_DiffuseSlider,
		Child, MBObj->CF_MaterialDiffuse,
	End;

	MBObj->SL_MaterialSR = SliderObject,
		MUIA_HelpNode, "SL_MaterialSR",
		// MUIA_InputMode, MUIV_InputMode_Immediate,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 0,
	End;

	obj_aux15 = Label2("R");

	obj_aux14 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux15,
		Child, MBObj->SL_MaterialSR,
	End;

	MBObj->SL_MaterialSG = SliderObject,
		MUIA_HelpNode, "SL_MaterialSG",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 0,
	End;

	obj_aux17 = Label2("G");

	obj_aux16 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux17,
		Child, MBObj->SL_MaterialSG,
	End;

	MBObj->SL_MaterialSB = SliderObject,
		MUIA_HelpNode, "SL_MaterialSB",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 0,
	End;

	obj_aux19 = Label2("B");

	obj_aux18 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux19,
		Child, MBObj->SL_MaterialSB,
	End;

	GR_MatSpecSliders = GroupObject,
		MUIA_HelpNode, "GR_MatSpecSliders",
		Child, obj_aux14,
		Child, obj_aux16,
		Child, obj_aux18,
	End;

	MBObj->CF_MaterialSpecular = ColorfieldObject,
		MUIA_HelpNode, "CF_MaterialSpecular",
		MUIA_Weight, 50,
		MUIA_Colorfield_Red, -1,
		MUIA_Colorfield_Green, -1,
		MUIA_Colorfield_Blue, -1,
	End;

	GR_MatSpec = GroupObject,
		MUIA_HelpNode, "GR_MatSpec",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Specular color",
		MUIA_Group_Horiz, TRUE,
		Child, GR_MatSpecSliders,
		Child, MBObj->CF_MaterialSpecular,
	End;

	MBObj->SL_MaterialER = SliderObject,
		MUIA_HelpNode, "SL_MaterialER",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 0,
	End;

	obj_aux21 = Label2("R");

	obj_aux20 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux21,
		Child, MBObj->SL_MaterialER,
	End;

	MBObj->SL_MaterialEG = SliderObject,
		MUIA_HelpNode, "SL_MaterialEG",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 0,
	End;

	obj_aux23 = Label2("G");

	obj_aux22 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux23,
		Child, MBObj->SL_MaterialEG,
	End;

	MBObj->SL_MaterialEB = SliderObject,
		MUIA_HelpNode, "SL_MaterialEB",
		// MUIA_InputMode, MUIV_InputMode_RelVerify,
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 0,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 0,
	End;

	obj_aux25 = Label2("B");

	obj_aux24 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux25,
		Child, MBObj->SL_MaterialEB,
	End;

	GR_MatEmmisiveSliders = GroupObject,
		MUIA_HelpNode, "GR_MatEmmisiveSliders",
		Child, obj_aux20,
		Child, obj_aux22,
		Child, obj_aux24,
	End;

	MBObj->CF_MaterialEmmisive = ColorfieldObject,
		MUIA_HelpNode, "CF_MaterialEmmisive",
		MUIA_Weight, 50,
		MUIA_Colorfield_Red, -1,
		MUIA_Colorfield_Green, -1,
		MUIA_Colorfield_Blue, -1,
	End;

	GR_MatEmmisive = GroupObject,
		MUIA_HelpNode, "GR_MatEmmisive",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Emmisive color",
		MUIA_Group_Horiz, TRUE,
		Child, GR_MatEmmisiveSliders,
		Child, MBObj->CF_MaterialEmmisive,
	End;

	GR_MatColors = GroupObject,
		MUIA_HelpNode, "GR_MatColors",
		MUIA_Group_Columns, 2,
		Child, GR_MatAmbient,
		Child, GR_MatDiffuse,
		Child, GR_MatSpec,
		Child, GR_MatEmmisive,
	End;

	MBObj->STR_MaterialShininess = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MaterialShininess",
		MUIA_String_Contents, "0.2",
		MUIA_String_Accept, "0123456789.e",
	End;

	obj_aux27 = Label2("Shininess");

	obj_aux26 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux27,
		Child, MBObj->STR_MaterialShininess,
	End;

	MBObj->STR_MaterialTransparency = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_MaterialTransparency",
		MUIA_String_Contents, "0",
		MUIA_String_Accept, "0123456789.e",
	End;

	obj_aux29 = Label2("Transparency");

	obj_aux28 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux29,
		Child, MBObj->STR_MaterialTransparency,
	End;

	GR_MatShinines = GroupObject,
		MUIA_HelpNode, "GR_MatShinines",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Shininess and transparency",
		MUIA_Group_Horiz, TRUE,
		Child, obj_aux26,
		Child, obj_aux28,
	End;

	GR_MatAttributs = GroupObject,
		MUIA_HelpNode, "GR_MatAttributs",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_MatActionIndexes,
		Child, GR_MatColors,
		Child, GR_MatShinines,
	End;

	MBObj->BT_MaterialOk = SimpleButton("Ok");

	MBObj->BT_MaterialDefault = SimpleButton("Default");

	MBObj->BT_MaterialCancel = SimpleButton("Cancel");

	GR_MatConfirm = GroupObject,
		MUIA_HelpNode, "GR_MatConfirm",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Confirm",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_MaterialOk,
		Child, MBObj->BT_MaterialDefault,
		Child, MBObj->BT_MaterialCancel,
	End;

	GP_RT_Material = GroupObject,
		Child, GR_MatNum,
		Child, GR_MatAttributs,
		Child, GR_MatConfirm,
	End;

	MBObj->WI_Material = WindowObject,
		MUIA_Window_Title, "Material",
		MUIA_Window_ID, MAKE_ID('7', 'W', 'I', 'N'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Material,
	End;

}

