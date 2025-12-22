/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef MCC_NLIST_H
#define MCC_NLIST_H 1

//------------------------------------------------------------------------------

struct MCC_NList_Data
{
	Object 								*obj_self;
	Object 								*obj_contextmenu;

	struct MCC_Main_Data				*nld_MainData;
	ULONG 								 nld_ID;
	LONG 								    nld_Pen[BIP_END];
};

struct MUIP_NList_MakeFormat
{
	ULONG 								MethodID;

	LONG 									id;
	LONG 									maxcols;
};

//------------------------------------------------------------------------------

#endif /* MCC_NLIST_H */











