/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef TAGS_H
#define TAGS_H 1

//------------------------------------------------------------------------------

#define MSERIAL_NATMEG 										2099480043
#define TAGBASE_NATMEG										(TAG_USER | (MSERIAL_NATMEG << 16))

//------------------------------------------------------------------------------

//mcc_about
#define MUIM_About_About									(TAGBASE_NATMEG | 0x0000)

#define MUIA_About_ApplicationData						(TAGBASE_NATMEG | 0x0100)

#define MUIV_About_Ok 										(TAGBASE_NATMEG | 0x0200)

//mcc_application
#define MUIM_Application_Init								(TAGBASE_NATMEG | 0x1000)
#define MUIM_Application_Exit								(TAGBASE_NATMEG | 0x1001)
#define MUIM_Application_LoadOptions					(TAGBASE_NATMEG | 0x1002)
#define MUIM_Application_SaveOptions					(TAGBASE_NATMEG | 0x1003)
#define MUIM_Application_MakeOptions					(TAGBASE_NATMEG | 0x1004)
#define MUIM_Application_Project_About					(TAGBASE_NATMEG | 0x1005)
#define MUIM_Application_Project_AboutMUI				(TAGBASE_NATMEG | 0x1006)
#define MUIM_Application_Project_Iconify				(TAGBASE_NATMEG | 0x1007)
#define MUIM_Application_Cache_Save						(TAGBASE_NATMEG | 0x1008)

#define MUIA_Application_Params						   (TAGBASE_NATMEG | 0x1100)

//mcc_display
#define MUIM_Display_Update								(TAGBASE_NATMEG | 0x2000)
#define MUIM_Display_Trigger								(TAGBASE_NATMEG | 0x2001)

#define MUIA_Display_Control								(TAGBASE_NATMEG | 0x2100)
#define MUIA_Display_MainData								(TAGBASE_NATMEG | 0x2101)

//mcc_main
#define MUIM_Main_Init										(TAGBASE_NATMEG | 0x3000)
#define MUIM_Main_Exit										(TAGBASE_NATMEG | 0x3001)
#define MUIM_Main_Update									(TAGBASE_NATMEG | 0x3002)

#define MUIA_Main_ApplicationData					   (TAGBASE_NATMEG | 0x3100)

// mcc_nlist
#define MUIM_NList_MakeFormat 							(TAGBASE_NATMEG | 0x4000)
#define MUIM_NList_UpdateColors 							(TAGBASE_NATMEG | 0x4001)

#define MUIA_NList_MainData 								(TAGBASE_NATMEG | 0x4100)
#define MUIA_NList_ID 										(TAGBASE_NATMEG | 0x4101)

#define MUIV_NList_ID_Stats								(TAGBASE_NATMEG | 0x4200)

//------------------------------------------------------------------------------

#endif /* TAGS_H */








