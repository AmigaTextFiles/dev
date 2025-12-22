/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef MCC_APPLICATION_H
#define MCC_APPLICATION_H 1

//------------------------------------------------------------------------------

enum menuids
{
	MENU_Project = 0,
		MENU_Project_About,
		MENU_Project_AboutMUI,
		MENU_Project_Iconify,
	MENU_Cache,
		MENU_Cache_Save,
	MENU_LAST
};

//------------------------------------------------------------------------------

struct MCC_Application_Data
{
	Object 						*app; //== obj_self

	Object 						*obj_menustrip;
	Object 						*obj_menuitem[MENU_LAST];

	Object 						*mcc_about;
	Object 						*mcc_main;

	DILParams 					*ad_Params;
};

//------------------------------------------------------------------------------

struct MUIP_Application_Wait
{
	ULONG MethodID;

	ULONG secs;
	ULONG mics;
};

//------------------------------------------------------------------------------

#endif /* MCC_APPLICATION_H */





















