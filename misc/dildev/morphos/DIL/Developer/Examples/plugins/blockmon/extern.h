/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef N_EXTERN_H
#define N_EXTERN_H 1

//------------------------------------------------------------------------------

#ifdef __NOLIBBASE__
//init.c
extern struct ExecBase   		*SysBase;
extern struct DosLibrary 		*DOSBase;
extern struct Library 			*UtilityBase;
//main.c
extern struct GfxBase       	*GfxBase;
extern struct IntuitionBase 	*IntuitionBase;
extern struct Library 			*IconBase;
extern struct Library 			*MUIMasterBase;
#endif

//------------------------------------------------------------------------------

MCC_DISPATCHER_EXTERN(dpAbout);
MCC_DISPATCHER_EXTERN(dpApplication);
MCC_DISPATCHER_EXTERN(dpDisplay);
MCC_DISPATCHER_EXTERN(dpMain);
MCC_DISPATCHER_EXTERN(dpNList);

//------------------------------------------------------------------------------

#endif /* N_EXTERN_H */











