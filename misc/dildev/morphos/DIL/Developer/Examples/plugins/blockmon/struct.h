/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef STRUCT_H
#define STRUCT_H 1

//------------------------------------------------------------------------------

typedef struct Entry
{
	struct MinNode 			 e_Node;

	ULONG 						 e_BlockOffset;
	ULONG 						 e_BlockCount;

	ULONG 						 e_RAC;  //Read Access Count
	ULONG 						 e_WAC;  //Write Access Count
	UBYTE 						 e_LA;   //Last Access
} Entry;

//-----------------------------------------------------------------------------

typedef struct _ProcessMsg
{
	struct Message 			 p_Msg;
	
   DILPlugin 					*p_Plugin;
} ProcessMsg;

//------------------------------------------------------------------------------

typedef struct _StartProcessMsg
{
	struct Message 			 sp_Msg;

	DILParams 					*sp_Params;
	UBYTE 						 sp_Error;
} StartProcessMsg;

//------------------------------------------------------------------------------

enum BoldItalicPenspec
{
	BIP_Stats_R = 0,
	BIP_Stats_G,
	BIP_Stats_B,
   BIP_END
};

enum ColumnFlags
{
	CF_Stats = 0,
	CF_END
};

typedef struct _Settings
{
	UBYTE 						*s_PathCache;
	UBYTE 						*s_PathConfig;
	
   ULONG 						 s_CacheMaxLength;
	
   LONG 							 s_Bold[BIP_END];
	LONG 							 s_Italic[BIP_END];
	struct MUI_PenSpec 		 s_PenSpec[BIP_END];
	
   ULONG 						 s_ColumnFlags[CF_END];
} Settings;

//------------------------------------------------------------------------------

enum
{
	MCC_About = 0,
	MCC_Application,
	MCC_Display,
	MCC_Main,
	MCC_NList,
   MCC_LAST
};

#define CF_NEEDSAVE			(1ul << 0)

typedef struct _Control
{
	struct MUI_CustomClass 	*c_MCC[MCC_LAST];
	Object 						*c_APP;
	
   APTR 							 c_Pool;
	ULONG 						 c_PoolUsage;

	struct Task 				*c_Self;
   struct Task 				*c_SigTask;
	struct MsgPort 			*c_SigPort;
	struct MsgPort 			*c_ReplyPort;
	
   DOUBLE 						*c_SinTable;
	DOUBLE 						*c_CosTable;

   struct MinList 			 c_List;
	ULONG 						 c_ListEntries;
	
   ULONG 						 c_AccessCountMax;
	ULONG 						 c_Flags;
	
   struct _Settings			 c_Settings;
} Control;

//------------------------------------------------------------------------------

#endif /* STRUCT_H */










