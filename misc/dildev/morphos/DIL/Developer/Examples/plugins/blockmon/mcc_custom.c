/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------

BOOL InitCustomClasses(Control *control)
{
	control->c_MCC[MCC_About]			 = MUI_CreateCustomClass(NULL, MUIC_Window,
		NULL, sizeof(struct MCC_About_Data),			MCC_DISPATCHER_REF(dpAbout));
	control->c_MCC[MCC_Application]	 = MUI_CreateCustomClass(NULL, MUIC_Application,
		NULL, sizeof(struct MCC_Application_Data),	MCC_DISPATCHER_REF(dpApplication));
	control->c_MCC[MCC_Display]		 = MUI_CreateCustomClass(NULL, MUIC_Area,
		NULL, sizeof(struct MCC_Display_Data),			MCC_DISPATCHER_REF(dpDisplay));
	control->c_MCC[MCC_Main]			 = MUI_CreateCustomClass(NULL, MUIC_Window,
		NULL, sizeof(struct MCC_Main_Data),				MCC_DISPATCHER_REF(dpMain));
	control->c_MCC[MCC_NList]		    = MUI_CreateCustomClass(NULL, MUIC_NList,
		NULL, sizeof(struct MCC_NList_Data),		   MCC_DISPATCHER_REF(dpNList));

	if (
		control->c_MCC[MCC_About] &&
		control->c_MCC[MCC_Application] &&
		control->c_MCC[MCC_Display] &&
		control->c_MCC[MCC_Main] &&
		control->c_MCC[MCC_NList]
		) return TRUE;
	
	ExitCustomClasses(control);
	return FALSE;
}

void ExitCustomClasses(Control *control)
{
	if (control->c_MCC[MCC_About]) MUI_DeleteCustomClass(control->c_MCC[MCC_About]);
	if (control->c_MCC[MCC_Application]) MUI_DeleteCustomClass(control->c_MCC[MCC_Application]);
	if (control->c_MCC[MCC_Display]) MUI_DeleteCustomClass(control->c_MCC[MCC_Display]);
	if (control->c_MCC[MCC_Main]) MUI_DeleteCustomClass(control->c_MCC[MCC_Main]);
	if (control->c_MCC[MCC_NList]) MUI_DeleteCustomClass(control->c_MCC[MCC_NList]);
}

//------------------------------------------------------------------------------





























