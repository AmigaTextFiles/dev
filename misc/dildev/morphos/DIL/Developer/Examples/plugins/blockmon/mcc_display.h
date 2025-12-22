/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef MCC_DISPLAY_H
#define MCC_DISPLAY_H 1


//------------------------------------------------------------------------------

struct MUI_MinMaxDefCur
{
	WORD MinWidth;
	WORD MinHeight;
	WORD MaxWidth;
	WORD MaxHeight;
	WORD DefWidth;
	WORD DefHeight;
	WORD CurWidth;
	WORD CurHeight;
};

//------------------------------------------------------------------------------

#define DDF_FIRST 					(1ul << 0)
#define DDF_ICONIFIED 				(1ul << 1)


//------------------------------------------------------------------------------

struct MCC_Display_Data
{
	Object		   				   *obj_self;
	Object		   				   *obj_parent;

	struct MsgPort     				*dd_EHPort;	
	struct timerequest 				*dd_EHReq;
	struct MUI_EventHandlerNode 	 dd_EHNode;
	
   struct MUI_InputHandlerNode 	 dd_IHNode;
	LONG 									 dd_MousePos[2];

	struct MUI_MinMaxDefCur			 dd_MinMaxDefCur;

	struct TmpRas 						 dd_TmpRas;
	PLANEPTR 							 dd_Raster;
	LONG 									 dd_RasterWidth;
	LONG 									 dd_RasterHeight;

	struct AreaInfo 					 dd_AreaInfo;
	APTR 									 dd_Vectors;
	ULONG 								 dd_VectorsMax;

	ULONG 								 dd_Scale;
	ULONG 								 dd_Flags;

	struct MCC_Main_Data				*dd_MainData;
	DILPlugin 							*dd_Plugin;
	DILParams 							*dd_Params;
	Control 								*dd_Control;

	ULONG 								 dd_Cylinders;
	ULONG 								 dd_CylinderFract;
	ULONG 								 dd_Tracks;
	ULONG 								 dd_TrackFract;
};

//------------------------------------------------------------------------------

struct MUIP_Display_Update
{
	ULONG MethodID;

	DILPlugin *Plugin;
};

//------------------------------------------------------------------------------

#endif /* MCC_DISPLAY_H */












