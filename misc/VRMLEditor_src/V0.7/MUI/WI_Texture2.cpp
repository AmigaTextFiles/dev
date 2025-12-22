#include "MUI_CPP.include"

#include <mui/GLArea_mcc.h>

#include "GLFunctions.h"

void CreateWI_Texture2(struct ObjApp *MBObj)
{
	APTR    GP_RT_Texture2, obj_aux0, obj_aux1, GR_grp_173, GR_grp_271, LA_label_68;
	APTR    GR_grp_175, LA_label_49, LA_label_50, GR_grp_214, LA_label_73, LA_label_74;
	APTR    LA_label_75, GR_grp_174, gr_tex, gr_info;

	MBObj->STR_TX_Texture2Width = NULL;
	MBObj->STR_TX_Texture2Height = NULL;
	MBObj->STR_TX_Texture2Component = NULL;

	MBObj->CY_Texture2WrapSContent[0] = "REPEAT";
	MBObj->CY_Texture2WrapSContent[1] = "CLAMP";
	MBObj->CY_Texture2WrapSContent[2] = NULL;
	MBObj->CY_Texture2WrapTContent[0] = "REPEAT";
	MBObj->CY_Texture2WrapTContent[1] = "CLAMP";
	MBObj->CY_Texture2WrapTContent[2] = NULL;

	MBObj->STR_DEFTexture2Name = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_DEFTexture2Name",
		MUIA_String_Contents, "NONE",
	End;

	obj_aux1 = Label2("DEF");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->STR_DEFTexture2Name,
	End;

	LA_label_68 = Label("filename");

	MBObj->STR_PA_Texture2 = String("", 80);

	MBObj->PA_Texture2 = PopButton(MUII_PopFile);

	MBObj->PA_Texture2 = PopaslObject,
		MUIA_HelpNode, "PA_Texture2",
		MUIA_Popasl_Type, 0,
		MUIA_Popstring_String, MBObj->STR_PA_Texture2,
		MUIA_Popstring_Button, MBObj->PA_Texture2,
	End;

	GR_grp_271 = GroupObject,
		MUIA_HelpNode, "GR_grp_271",
		MUIA_Group_Horiz, TRUE,
		Child, LA_label_68,
		Child, MBObj->PA_Texture2,
	End;

	LA_label_49 = Label("wrapS");

	MBObj->CY_Texture2WrapS = CycleObject,
		MUIA_HelpNode, "CY_Texture2WrapS",
		MUIA_Cycle_Entries, MBObj->CY_Texture2WrapSContent,
	End;

	LA_label_50 = Label("wrapT");

	MBObj->CY_Texture2WrapT = CycleObject,
		MUIA_HelpNode, "CY_Texture2WrapT",
		MUIA_Cycle_Entries, MBObj->CY_Texture2WrapTContent,
	End;

	GR_grp_175 = GroupObject,
		MUIA_HelpNode, "GR_grp_175",
		MUIA_Group_Columns, 2,
		Child, LA_label_49,
		Child, MBObj->CY_Texture2WrapS,
		Child, LA_label_50,
		Child, MBObj->CY_Texture2WrapT,
	End;

	LA_label_73 = Label("Width");

	MBObj->TX_Texture2Width = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Texture2Width,
		MUIA_Text_SetMin, TRUE,
	End;

	LA_label_74 = Label("Height");

	MBObj->TX_Texture2Height = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Texture2Height,
		MUIA_Text_SetMin, TRUE,
	End;

	LA_label_75 = Label("Component");

	MBObj->TX_Texture2Component = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, MBObj->STR_TX_Texture2Component,
		MUIA_Text_SetMin, TRUE,
	End;

	GR_grp_214 = GroupObject,
		MUIA_HelpNode, "GR_grp_214",
		MUIA_Group_Columns, 2,
		Child, LA_label_73,
		Child, MBObj->TX_Texture2Width,
		Child, LA_label_74,
		Child, MBObj->TX_Texture2Height,
		Child, LA_label_75,
		Child, MBObj->TX_Texture2Component,
	End;

	MBObj->GLAR_Texture2Preview = GLAreaObject,
		// MUIA_FillArea, TRUE,
		MUIA_GLArea_SingleTask, TRUE,
		// MUIA_GLArea_Buffered, FALSE,
		MUIA_GLArea_MinWidth,120,
		MUIA_GLArea_MaxWidth,120,
		MUIA_GLArea_MinHeight, 80,
		MUIA_GLArea_MaxHeight, 80,
		// MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		// MUIA_GLArea_MouseDownFunc, MouseDownTexture,
		MUIA_GLArea_DrawFunc, DrawTexturePreview,
	End;

	MBObj->GLAR_Texture2Anim = GLAreaObject,
		MUIA_GLArea_MinWidth,120,
		MUIA_GLArea_MaxWidth,120,
		MUIA_GLArea_MinHeight, 80,
		MUIA_GLArea_MaxHeight, 80,
		MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_InitFunc, MUIV_GLArea_InitFunc_Standard,
		// MUIA_GLArea_MouseDownFunc, MouseDownTexture,
		MUIA_GLArea_DrawFunc, DrawTextureAnim,
	End;

	gr_tex = GroupObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "OpenGL output",
		Child, MBObj->GLAR_Texture2Preview,
		Child, MBObj->GLAR_Texture2Anim,
	End;

	gr_info = GroupObject,
		MUIA_HelpNode, "GR_grp_173",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Attributs",
		Child, GR_grp_271,
		Child, GR_grp_175,
		Child, GR_grp_214,
	End;

	GR_grp_173 = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, gr_tex,
		Child, gr_info,
	End;

	MBObj->BT_Texture2Ok = SimpleButton("Ok");

	MBObj->BT_Texture2Default = SimpleButton("Default");

	MBObj->BT_Texture2Cancel = SimpleButton("Cancel");

	GR_grp_174 = GroupObject,
		MUIA_HelpNode, "GR_grp_174",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "Cmd",
		MUIA_Group_Horiz, TRUE,
		Child, MBObj->BT_Texture2Ok,
		Child, MBObj->BT_Texture2Default,
		Child, MBObj->BT_Texture2Cancel,
	End;

	GP_RT_Texture2 = GroupObject,
		Child, obj_aux0,
		Child, GR_grp_173,
		Child, GR_grp_174,
	End;

	MBObj->WI_Texture2 = WindowObject,
		MUIA_Window_Title, "Texture2",
		MUIA_Window_ID, MAKE_ID('2', '8', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_Texture2,
	End;
}

