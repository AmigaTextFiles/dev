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

#include "GenCodeCGUI.h"

struct ObjApp * CreateApp(void)
{
	struct ObjApp * ObjectApp;

	APTR	GROUP_ROOT_0, GR_Option, GR_Main, Space_1, obj_aux0, obj_aux1, Space_2;
	APTR	Space_3, obj_aux2, obj_aux3, Space_4, GR_Register, GR_Buttons;

	if (!(ObjectApp = AllocVec(sizeof(struct ObjApp),MEMF_CLEAR)))
		return(NULL);

	ObjectApp->STR_TX_Prg_Name = NULL;

	ObjectApp->STR_GR_Register[0] = "H-Header";
	ObjectApp->STR_GR_Register[1] = "C-Header";
	ObjectApp->STR_GR_Register[2] = "Main-Header";
	ObjectApp->STR_GR_Register[3] = NULL;

	ObjectApp->TX_Prg_Name = TextObject,
		MUIA_Background, MUII_TextBack,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Text_Contents, ObjectApp->STR_TX_Prg_Name,
		MUIA_Text_SetMin, TRUE,
	End;

	Space_1 = HVSpace;

	ObjectApp->CH_Generate_Main_File = KeyCheckMark(TRUE, 'm');

	obj_aux1 = KeyLabel2("Generate Main File", 'm');

	obj_aux0 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux1,
		Child, ObjectApp->CH_Generate_Main_File,
	End;

	Space_2 = HVSpace;

	GR_Main = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, Space_1,
		Child, obj_aux0,
		Child, Space_2,
	End;

	Space_3 = HVSpace;

	ObjectApp->CH_Add_new_entries_in_Catalog_Description_File = KeyCheckMark(FALSE, 'm');

	obj_aux3 = KeyLabel2("Add new entries in Catalog Description File", 'm');

	obj_aux2 = GroupObject,
		MUIA_Group_Columns, 2,
		Child, obj_aux3,
		Child, ObjectApp->CH_Add_new_entries_in_Catalog_Description_File,
	End;

	Space_4 = HVSpace;

	ObjectApp->GR_Catalog = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, Space_3,
		Child, obj_aux2,
		Child, Space_4,
	End;

	GR_Option = GroupObject,
		Child, GR_Main,
		Child, ObjectApp->GR_Catalog,
	End;

	ObjectApp->GR_H_Header = GroupObject,
	End;

	ObjectApp->GR_C_Header = GroupObject,
	End;

	ObjectApp->GR_Main_Header = GroupObject,
	End;

	GR_Register = RegisterObject,
		MUIA_Register_Titles, ObjectApp->STR_GR_Register,
		MUIA_Frame, MUIV_Frame_Group,
		Child, ObjectApp->GR_H_Header,
		Child, ObjectApp->GR_C_Header,
		Child, ObjectApp->GR_Main_Header,
	End;

	ObjectApp->BT_Generate = TextObject,
		ButtonFrame,
		MUIA_Background, MUII_ButtonBack,
		MUIA_ControlChar, 'g',
		MUIA_Text_Contents, "Generate",
		MUIA_Text_PreParse, "\033c",
		MUIA_Text_HiChar, 'g',
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	ObjectApp->BT_Save_Local = SimpleButton("Save _Local");

	ObjectApp->BT_Save_Global = SimpleButton("Save Gl_obal");

	GR_Buttons = GroupObject,
		MUIA_Group_Horiz, TRUE,
		MUIA_Group_SameWidth, TRUE,
		Child, ObjectApp->BT_Generate,
		Child, ObjectApp->BT_Save_Local,
		Child, ObjectApp->BT_Save_Global,
	End;

	GROUP_ROOT_0 = GroupObject,
		Child, ObjectApp->TX_Prg_Name,
		Child, GR_Option,
		Child, GR_Register,
		Child, GR_Buttons,
	End;

	ObjectApp->WI_C_Generation = WindowObject,
		MUIA_Window_Title, "GenCodeC by Billault © 1995-1997",
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		WindowContents, GROUP_ROOT_0,
	End;

	ObjectApp->App = ApplicationObject,
		MUIA_Application_Author, "Billault",
		MUIA_Application_Base, "C_Generation",
		MUIA_Application_Title, "GenCodeC",
		MUIA_Application_Version, "$VER: GenCodeC 2.2e (03.03.97)",
		MUIA_Application_Copyright, "Billault",
		MUIA_Application_Description, "GenCodeC for MUIBuilder",
		MUIA_Application_HelpFile, "GenCodeC.guide",
		SubWindow, ObjectApp->WI_C_Generation,
	End;


	if (!ObjectApp->App)
	{
		FreeVec(ObjectApp);
		return(NULL);
	}

	DoMethod(ObjectApp->WI_C_Generation,
		MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod(ObjectApp->CH_Generate_Main_File,
		MUIM_Notify, MUIA_Selected, TRUE,
		ObjectApp->GR_Main_Header,
		3,
		MUIM_Set, MUIA_Disabled, FALSE
		);

	DoMethod(ObjectApp->CH_Generate_Main_File,
		MUIM_Notify, MUIA_Selected, FALSE,
		ObjectApp->GR_Main_Header,
		3,
		MUIM_Set, MUIA_Disabled, TRUE
		);

	DoMethod(ObjectApp->BT_Generate,
		MUIM_Notify, MUIA_Pressed, FALSE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, ID_BT_GENERATE
		);

	DoMethod(ObjectApp->BT_Generate,
		MUIM_Notify, MUIA_Pressed, FALSE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit
		);

	DoMethod(ObjectApp->BT_Save_Local,
		MUIM_Notify, MUIA_Pressed, TRUE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, ID_BT_SAVE_LOCAL
		);

	DoMethod(ObjectApp->BT_Save_Global,
		MUIM_Notify, MUIA_Pressed, TRUE,
		ObjectApp->App,
		2,
		MUIM_Application_ReturnID, ID_BT_SAVE_GLOBAL
		);

	DoMethod(ObjectApp->WI_C_Generation,
		MUIM_Window_SetCycleChain, ObjectApp->CH_Generate_Main_File,
		ObjectApp->GR_Catalog,
		ObjectApp->CH_Add_new_entries_in_Catalog_Description_File,
		ObjectApp->GR_H_Header,
		ObjectApp->GR_C_Header,
		ObjectApp->GR_Main_Header,
		ObjectApp->BT_Generate,
		ObjectApp->BT_Save_Local,
		ObjectApp->BT_Save_Global,
		0
		);


	return(ObjectApp);
}

void DisposeApp(struct ObjApp * ObjectApp)
{
	MUI_DisposeObject(ObjectApp->App);
	FreeVec(ObjectApp);
}
