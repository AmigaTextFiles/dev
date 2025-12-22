#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#ifdef _DCC
#define __inline
#endif

#ifdef AZTEC_C
#define __inline
#endif

#include "TextWin.h"

struct ObjApp * CreateApp(void)
{
	struct ObjApp * Object;

	APTR	GROUP_ROOT_0;

	if (!(Object = AllocVec(sizeof(struct ObjApp), MEMF_PUBLIC|MEMF_CLEAR)))
		return(NULL);

	Object->GR_ListView = GroupObject,
		MUIA_HelpNode, "GR_ListView",
	End;

	Object->GR_Buttons = GroupObject,
		MUIA_HelpNode, "GR_Buttons",
		MUIA_Group_Horiz, TRUE,
	End;

	GROUP_ROOT_0 = GroupObject,
		Child, Object->GR_ListView,
		Child, Object->GR_Buttons,
	End;

	Object->WI_label_0 = WindowObject,
		MUIA_Window_Title, "window_title",
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GROUP_ROOT_0,
	End;

	Object->App = ApplicationObject,
		MUIA_Application_Author, "Will Bow and Colin Thompson",
		MUIA_Application_Base, "TextWin",
		MUIA_Application_Title, "TextWin",
		MUIA_Application_Version, "$VER: TextWin  1.00m (05.12.94)",
		MUIA_Application_Copyright, "(c) BOTH Software 1994",
		MUIA_Application_Description, "",
		SubWindow, Object->WI_label_0,
	End;


	if (!Object->App)
	{
		FreeVec(Object);
		return(NULL);
	}

	DoMethod(Object->WI_label_0,
		MUIM_Window_SetCycleChain, 0
		);

	return(Object);
}

void DisposeApp(struct ObjApp * Object)
{
	MUI_DisposeObject(Object->App);
	FreeVec(Object);
}
