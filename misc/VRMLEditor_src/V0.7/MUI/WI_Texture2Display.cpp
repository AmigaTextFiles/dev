#include "MUI_CPP.include"

#include <mui/GLArea_mcc.h>

#include "GLFunctions.h"

void CreateWI_Texture2Display(struct ObjApp *MBObj)
{
	APTR    GROUP_ROOT_46,Space_38,Space_39;

	MBObj->GLAR_Texture2 = GLAreaObject,
		MUIA_FillArea, TRUE,
		MUIA_GLArea_MinWidth,1,
		MUIA_GLArea_MaxWidth,1024,
		MUIA_GLArea_MinHeight, 1,
		MUIA_GLArea_MaxHeight, 768,
		MUIA_GLArea_Threaded, TRUE,
		MUIA_GLArea_MouseDownFunc, MouseDownTexture,
		MUIA_GLArea_DrawFunc, DrawTexture,
	End;

	MBObj->GR_Texture2Display = GroupObject,
		MUIA_Frame, MUIV_Frame_Group,
		MUIA_FrameTitle, "OpenGL output",
		Child, MBObj->GLAR_Texture2,
	End;

	// Space_38 = HVSpace;

	// Space_39 = HVSpace;

	GROUP_ROOT_46 = GroupObject,
		MUIA_Group_Horiz, TRUE,
		// Child, Space_38,
		Child, MBObj->GR_Texture2Display,
		// Child, Space_39,
		
	End;

	MBObj->WI_Texture2Display = WindowObject,
		MUIA_Window_Title, "Texture",
		// MUIA_Window_ID, MAKE_ID('3', '8', 'W', 'I'),
		MUIA_Window_SizeGadget, TRUE,
		MUIA_Window_NoMenus, TRUE,
		WindowContents, GROUP_ROOT_46,
	End;
}

