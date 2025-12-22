/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef MCC_MAIN_H
#define MCC_MAIN_H 1

//------------------------------------------------------------------------------

struct MCC_Main_Data
{
	Object								*obj_self;
	Object								*obj_parent;
	
	Object 								*mcc_display;

	Object 								*obj_display;
	Object 								*obj_group_display;

	Object 								*obj_list;
	Object 								*obj_update;

	struct MCC_Application_Data 	*md_ApplicationData;
	UBYTE 								*md_WindowTitle;
};

//------------------------------------------------------------------------------

void SetTitle(Object *obj, UBYTE *fmt, ...);

//------------------------------------------------------------------------------

#endif /* MCC_MAIN_H */





