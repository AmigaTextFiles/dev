#include "MUI_CPP.include"

#include <mui/GLArea_mcc.h>

#include "GLFunctions.h"

void CreateWI_Texture2Edit(struct ObjApp *MBObj)
{
	APTR    GP_RT_T2Edit, GR_Texture2Up, Space_38, GR_Texture2Edit, Space_39;
	APTR    GR_grp_274, obj_aux0, obj_aux1, obj_aux2, obj_aux3, obj_aux4, obj_aux5;

	Space_38 = HVSpace;

	MBObj->AR_GLAreaTexture2Edit = GLAreaObject,
		MUIA_FillArea, TRUE,
		MCCA_GLArea_MinWidth,1,
		MCCA_GLArea_MaxWidth,1024,
		MCCA_GLArea_MinHeight, 1,
		MCCA_GLArea_MaxHeight, 768,
		MCCA_GLArea_Threaded, TRUE,
		MCCA_GLArea_MouseDownFunc, MouseDownTexture,
		MCCA_GLArea_DrawFunc, DrawTexture,
	End;

	GR_Texture2Edit = GroupObject,
		MUIA_HelpNode, "GR_Texture2Edit",
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "GL result",
		Child, MBObj->AR_GLAreaTexture2Edit,
	End;

	Space_39 = HVSpace;

	GR_Texture2Up = GroupObject,
		MUIA_HelpNode, "GR_Texture2Up",
		MUIA_Group_Horiz, TRUE,
		Child, Space_38,
		Child, GR_Texture2Edit,
		Child, Space_39,
	End;

	MBObj->SL_Texture2EditX = SliderObject,
		MUIA_HelpNode, "SL_Texture2EditX",
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 1,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 1,
	End;

	obj_aux1 = Label2("X");

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, MBObj->SL_Texture2EditX,
	End;

	MBObj->SL_Texture2EditY = SliderObject,
		MUIA_HelpNode, "SL_Texture2EditY",
		MUIA_Frame, MUIV_Frame_Slider,
		MUIA_Slider_Min, 1,
		MUIA_Slider_Max, 100,
		MUIA_Slider_Level, 1,
	End;

	obj_aux3 = Label2("Y");

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, MBObj->SL_Texture2EditY,
	End;

	MBObj->STR_Texture2EditValue = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_HelpNode, "STR_Texture2EditValue",
		MUIA_String_Accept, "0123456789x",
	End;

	obj_aux5 = Label2("Value (Hex)");

	obj_aux4 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux5,
		Child, MBObj->STR_Texture2EditValue,
	End;

	GR_grp_274 = GroupObject,
		MUIA_HelpNode, "GR_grp_274",
		Child, obj_aux0,
		Child, obj_aux2,
		Child, obj_aux4,
	End;

	GP_RT_T2Edit = GroupObject,
		Child, GR_Texture2Up,
		Child, GR_grp_274,
	End;

	MBObj->WI_Texture2Edit = WindowObject,
		MUIA_Window_Title, "Texture editing",
		MUIA_Window_ID, MAKE_ID('3', '9', 'W', 'I'),
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GP_RT_T2Edit,
	End;
}

