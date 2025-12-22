#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

/* Libraries */
#include <libraries/mui.h>
#include <libraries/gadtools.h> /* for Barlabel in MenuItem */
#include <exec/memory.h>

/* Prototypes */
#include <proto/muimaster.h>
#include <proto/exec.h>
#ifdef __GNUC__
#include <proto/alib.h>
#else
#include <clib/alib_protos.h>
#endif /* __GNUC__ */

#include "WriteCatalogGUI.h"

struct ObjApp * CreateApp(void)
{
	struct ObjApp * ObjectApp;

	APTR	GROUP_ROOT_0, obj_aux0, obj_aux1, GR_Buttons, Space_0, Space_1;

	if (!(ObjectApp = AllocVec(sizeof(struct ObjApp),MEMF_PUBLIC|MEMF_CLEAR)))
		return(NULL);

	ObjectApp->STR_GetStringName = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_ControlChar, 'n',
	End;

	obj_aux1 = KeyLabel2("GetString Name", 'n');

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, ObjectApp->STR_GetStringName,
	End;

	ObjectApp->GR_GetStringName = GroupObject,
		Child, obj_aux0,
	End;

	ObjectApp->GR_Text = GroupObject,
		MUIA_Frame, MUIV_Frame_Group,
	End;

	Space_0 = HVSpace;

	ObjectApp->BT_GenerateFiles = TextObject,
		ButtonFrame,
		MUIA_Background, MUII_ButtonBack,
		MUIA_ControlChar, 'g',
		MUIA_Text_Contents, "Generate Files",
		MUIA_Text_PreParse, "\033c",
		MUIA_Text_HiChar, 'g',
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	ObjectApp->BT_Save = TextObject,
		ButtonFrame,
		MUIA_Background, MUII_ButtonBack,
		MUIA_ControlChar, 's',
		MUIA_Text_Contents, "Save",
		MUIA_Text_PreParse, "\033c",
		MUIA_Text_HiChar, 's',
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	Space_1 = HVSpace;

	GR_Buttons = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, Space_0,
		Child, ObjectApp->BT_GenerateFiles,
		Child, ObjectApp->BT_Save,
		Child, Space_1,
	End;

	GROUP_ROOT_0 = GroupObject,
		Child, ObjectApp->GR_GetStringName,
		Child, ObjectApp->GR_Text,
		Child, GR_Buttons,
	End;

	ObjectApp->WI_WriteCatalog = WindowObject,
		MUIA_Window_Title, "WriteCatalog",
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GROUP_ROOT_0,
	End;

	ObjectApp->App = ApplicationObject,
		MUIA_Application_Author, "Billault(s)",
		MUIA_Application_Base, "WriteCatalog",
		MUIA_Application_Title, "WriteCatalog",
		MUIA_Application_Version, "$VER: WriteCatalog 1.0 (20.09.95)",
		MUIA_Application_Copyright, "Billault(s)",
		MUIA_Application_Description, "Générateur C pour la localisation",
		SubWindow, ObjectApp->WI_WriteCatalog,
	End;


	if (!ObjectApp->App)
	{
		FreeVec(ObjectApp);
		return(NULL);
	}

	DoMethod(ObjectApp->WI_WriteCatalog,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod(ObjectApp->BT_GenerateFiles,
		MUIM_Notify, MUIA_Pressed, FALSE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, ID_BT_GenerateFiles
		);

	DoMethod(ObjectApp->BT_Save,
		MUIM_Notify, MUIA_Pressed, TRUE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, ID_BT_Save
		);

	DoMethod(ObjectApp->WI_WriteCatalog,
		MUIM_Window_SetCycleChain, ObjectApp->GR_GetStringName,
		ObjectApp->STR_GetStringName,
		ObjectApp->GR_Text,
		ObjectApp->BT_GenerateFiles,
		ObjectApp->BT_Save,
		0
		);


	return(ObjectApp);
}

void DisposeApp(struct ObjApp * ObjectApp)
{
	MUI_DisposeObject(ObjectApp->App);
	FreeVec(ObjectApp);
}
