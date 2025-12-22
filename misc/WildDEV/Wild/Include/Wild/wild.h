#ifndef	WILD_H
#define	WILD_H

/*
**	Wild.h	
**
**	Includes for Wild.library. 
**
**	VERY VERY incomplete,now: only some stuff to compile
**	the WildPrefs.library. To convert fully, in a quite near future...
**	(HELP ACCEPTED!!)
*/

#include	<exec/nodes.h>
#include	<exec/libraries.h>
#include	<intuition/intuitionbase.h>
#include 	<exec/ports.h>

struct WildBase
{
 struct Library		wi_Library;
 ULONG			wi_Dummy;	/* Necessary. (trust me) */
 ULONG			*wi_FastPool;	/* The fast pool. */
 ULONG			*wi_ChipPool;	/* The chip pool. */
 struct Library		*wi_UtilityBase;
 struct Library		*wi_IntuitionBase;
 struct	Library		*wi_GraphicsBase;	/* no specific base use to minimize compiling-mem. If you need, change... */
 struct Library		*wi_DOSBase;
 struct	Library		*wi_XpkBase;
 struct Library		*wi_WildPrefsBase;
 struct	Library		*wi_PowerPCBase;
 struct Library		*wi_ProfilerBase;	/* tmp probably */
 BYTE			wi_WhyFail;
 BYTE			wi_Hole000;
 struct MinList		wi_Apps;
 struct MinList		wi_Modules;
 struct MinList		wi_Threads;
 struct MinList		wi_Tables;
 struct MinList		wi_Extensions;
 struct MinList		wi_MORE[3];
 ULONG			wi_Ticker;		/* 1/50 sec ticker. */
};

struct  WildTypes
{
 UBYTE	wy_TypeA;
 UBYTE	wy_TypeB;
 UBYTE	wy_TypeC;
 UBYTE	wy_TypeD;
 UBYTE	wy_TypeE;
 UBYTE	wy_TypeF;
 UBYTE	wy_TypeG;
 UBYTE	wy_TypeH;
};

#define TYPEA_FULLCOMPATIBLE		0		
#define TYPEA_TD_STD			1		/* Type A 1: Are the std structs ones. */

#define TYPEB_FULLCOMPATIBLE		0
#define TYPEB_DI_FRIENDLYPLANAR		1		/* Type B 1: Is a standard planar screen. */
#define TYPEB_DI_CHUNKY8		2		/* Type B 2: Uses a 256 colors chunky (ONLY 256 colors, 24Bit,6Bit,4Bit chunky MAY be supported in the future by OTHER TYPES). */
#define	TYPEB_DI_OSWINDOW		3		/* Type B 3: Uses a std OS window, with no direct bitmap access. So, ONLY graphics.library ose here ! (used by editors...) */

#define TYPEC_FULLCOMPATIBLE		0		
#define TYPEC_DW_ONLYX			1		/* Type C 1: drawing. 1 means the broker gives only the x steps and starts. */
#define TYPEC_DW_SHADING		2		/* Type C 2: drawing. 2 means the broker gives the x,i steps and starts. */
#define TYPEC_DW_RGBSHADING		3		/* Type C 3: drawing. 3 means the broker gives the x,r,tg,b steps and starts. */
#define TYPEC_DW_TEX			4		/* Type C 4: drawing. 4 means the broker gives the x,tx,ty steps and starts. */
#define TYPEC_DW_SHADINGTEX		5		/* Type C 5: drawing. 5 means the broker gives the x,i,tx,ty steps and starts. */
#define TYPEC_DW_RGBSHADINGTEX		6		/* Type C 6: drawing. 6 means the broker gives the x,r,g,b,tx,ty steps and starts. */
#define TYPEC_DW_SCANSHADINGTEX		7		/* Type C 7: like 5, but also the ScanLine structure is comprended. */
#define TYPEC_DW_SCANRGBSHADINGTEX	8		/* Type C 8: like 6, but also the ScanLine structure is comprended. */

#define TYPED_FULLCOMPATIBLE		0
#define TYPED_LI_FLATINTENSITY		1		/* Type D 1: Is a FACE lighting, no shading,just intensity. */
#define TYPED_LI_FLATCOLOR		2		/* Type D 2: Is a FACE lighting, but using 24bit colors. */
#define TYPED_LI_SOFTINTENSITY		3		/* Type D 3: Is a POINT lighting, to use with linear interpolations, gouraud shadings. */

#define TYPEE_FULLCOMPATIBLE		0
#define TYPEF_FULLCOMPATIBLE		0
#define TYPEG_FULLCOMPATIBLE		0
#define TYPEH_FULLCOMPATIBLE		0

#define	TYPEH_CPU_68k			0		/* Type H 0: Is the normal 68k cpu */
#define	TYPEH_CPU_WARPUP		1		/* Type H 1: The module's funcs are called via powerpc.library */

struct  WildModule
{
 struct	Library		wm_Library;
 ULONG			wm_Dummy;		/* necessary... */
 struct	MinNode		wm_Node;
 struct	WildBase	*wm_WildBase;
 UWORD			wm_CNT;
 struct	WildTypes	wm_Types;
};

struct  WildEngine
{
 struct	WildModule	*we_Display;
 struct	WildModule	*we_TDCore;
 struct	WildModule	*we_Light;
 struct	WildModule	*we_Draw;
 struct	WildModule	*we_FX;
 struct	WildModule	*we_Sound;
 struct	WildModule	*we_Music;
 struct	WildModule	*we_Broker;
 struct WildModule 	*we_Loader;
 struct WildModule	*we_Saver;
 struct	WildModule	*we_MORE[7];
}; 

struct	WildApp
{
 struct MinNode		wap_Node;
 struct	MsgPort		*wap_WildPort;
 struct WildBase 	*wap_WildBase;
 struct TagItem		*wap_Tags;
 ULONG			wap_Flags;
 ULONG			*wap_ChipPool;
 ULONG			*wap_FastPool;
 struct WildEngine	wap_Engine;
 struct WildEngine	wap_EngineData;
 struct FrameBuffer	*wap_FrameBuffer;
 struct WildScene	*wap_Scene;
 struct WildTypes	wap_Types;
 ULONG			*wap_AppPrefs;
 ULONG			*wap_ScanLineHeader;
 ULONG			*wap_Level;
 ULONG			*wap_UserData;
};

#define	WAF_RefreshEngine	0x00010000
#define WAF_FreeFastPool	0x01000000
#define WAF_FreeChipPool	0x02000000

/******************************************************************************
*** Threads definitions							*******
******************************************************************************/

struct WildThread
{
 struct MinNode		wt_Node;
 struct WildBase	*wt_WildBase;
 struct MsgPort		*wt_WildPort;		/* a message port to communicate! */
 struct WildApp		*wt_WildApp;		/* usually, the thread refers to a singular app! */
 ULONG			*wt_FastPool;		/* two pools */
 ULONG			*wt_ChipPool;		
 WORD			wt_TimeOut;		/* timeout, after sending the kill-signal: expired, hard-killing will be performed ! */
 WORD			wt_DieCheck;		/* INTERNAL:needed to check if the process is dead, after a kill message... (DO NOT USE) */
 ULONG			*wt_Entry;		/* entry point (initial PC) */
 ULONG			*wt_Args;		/* args you passsed with the tag. */
 ULONG			*wt_Process;		/* the process created by dos */
};	

struct WildMessage
{
 struct	Message		wm_Message;
 ULONG			wm_Type;		/* Longword, says the type of message this is. */
 ULONG			wm_Data;		/* then, the data */
};

#define		WIME_Kill	'Kill'		/* Kill yourself as fast as you can ! (after the timeout, you will be killed hardly!) */
#define		WIME_Freeze	'Friz'		/* Take a coffee, stop doing what you are doing... */
#define		WIME_WarmUp	'Warm'		/* Was good the coffee ?? RESTART SUDDENTLY YOUR WORK !!!! */

/******************************************************************************
*** Tags definitions							*******
******************************************************************************/

#define	WILD_TAGBASE		TAG_USER+('W'<<16)
#define	WILD_PRIVATESTD		WILD_TAGBASE
#define	WILD_SIMPLESTD		WILD_TAGBASE+0x1000000
#define	WILD_COMPLEXSTD		WILD_TAGBASE+0x2000000
#define WILD_OTHERSTD		WILD_TAGBASE+0x4000000

#define	WILD_USERBASE		WILD_TAGBASE+0x8000000
#define	WILD_PRIVATEUSER	WILD_USERBASE		
#define	WILD_SIMPLEUSER		WILD_USERBASE+0x1000000	
#define	WILD_COMPLEXUSER	WILD_USERBASE+0x2000000	

#define WILD_MAXTAG		WILD_TAGBASE+0xFFFFFFF		/* upper limit, just to check in wildprefs... */

/* Application Tags */

#define WIAP_DisplayModule	WILD_COMPLEXSTD+0
#define WIAP_TDCoreModule	WILD_COMPLEXSTD+1
#define WIAP_LightModule	WILD_COMPLEXSTD+2
#define WIAP_DrawModule		WILD_COMPLEXSTD+3
#define WIAP_FXModule		WILD_COMPLEXSTD+4
#define WIAP_SoundModule	WILD_COMPLEXSTD+5
#define WIAP_MusicModule	WILD_COMPLEXSTD+6
#define WIAP_BrokerModule	WILD_COMPLEXSTD+7
#define WIAP_LoaderModule	WILD_COMPLEXSTD+8
#define	WIAP_SaverModule	WILD_COMPLEXSTD+9

/*#define WIAP_			WILD_STD+ */

#define WIAP_Speed		WILD_SIMPLESTD+0
#define WIAP_Quality		WILD_SIMPLESTD+1

#define WIAP_FastPoolPuddles	WILD_PRIVATESTD+0
#define WIAP_ChipPoolPuddles	WILD_PRIVATESTD+1
#define WIAP_FastPoolThresh	WILD_PRIVATESTD+2
#define WIAP_ChipPoolThresh	WILD_PRIVATESTD+3
#define	WIAP_TypeABCD		WILD_PRIVATESTD+4
#define	WIAP_TypeEFGH		WILD_PRIVATESTD+5
#define	WIAP_Name		WILD_PRIVATESTD+6
#define	WIAP_BaseName		WILD_PRIVATESTD+7
#define	WIAP_Description	WILD_PRIVATESTD+8
#define	WIAP_PrefsHandle	WILD_PRIVATESTD+9
#define WIAP_Level		WILD_PRIVATESTD+10

/* Display tags */

#define WIDI_Width		WILD_SIMPLESTD+50
#define WIDI_Height		WILD_SIMPLESTD+51
#define WIDI_PixelRes		WILD_SIMPLESTD+52
#define WIDI_Depth		WILD_SIMPLESTD+53
#define WIDI_DisplayID		WILD_SIMPLESTD+54

#define WIDI_Screen		WILD_PRIVATESTD+50
#define WIDI_Palette		WILD_PRIVATESTD+51

/* TDCore tags */

#define WITD_Scene		WILD_PRIVATESTD+100

#define WITD_CutDistance	WILD_SIMPLESTD+100

#define WILD_APPDEFINED		9+2+11+5+2+1+1

/* WildThreads tags */

#define	WITH_Priority		WILD_OTHERSTD+1		/* default 0 */
#define	WITH_TimeOut		WILD_OTHERSTD+2		/* default 100 (2 secs) Wait when killing before eliminating automatically. */ 
#define	WITH_Entry 		WILD_OTHERSTD+3 	/* REQUIDED - It's the initial PC. */
#define	WITH_Args		WILD_OTHERSTD+4		/* REQUIDED - Are the initial args. */
#define	WITH_Name		WILD_OTHERSTD+5		/* Name of the "New Process" (default: "Wild generic thread...") */
#define	WITH_Stack		WILD_OTHERSTD+6		/* stack size (default 4096) */

/* BuildWildObject() tags */

#define WIBU_ObjectType		WILD_OTHERSTD+50
#define WIBU_BuildObject	WILD_OTHERSTD+51
#define WIBU_WildApp		WILD_OTHERSTD+52
#define WIBU_ModifyObject  	WILD_OTHERSTD+53

#define TEXACTION_Load	1
#define TEXACTION_Free	2		/* passed via A1 to the Hook. */

/* Loader tags... */

#define	WILO_ObjectType		WIBU_ObjectType
#define WILO_ReadHook		WILD_OTHERSTD+100	/* hook convs: a0:hook a1:buf a2:len hdata:fh*/
#define WILO_FileHandle		WILD_OTHERSTD+101
#define	WILO_FileName		WILD_OTHERSTD+102
#define WILO_LoadedAttrsFirst   WILD_OTHERSTD+103  	/* use the provided attrs or the loaded attrs first ? (default:FALSE (=use app's)) */
#define	WILO_SeekHook		WILD_OTHERSTD+104	/* hook convs: a0:hook hdata:fh */
#define	WILO_OpenHook		WILD_OTHERSTD+105	/* hook convs: a0:hook hdata:filename (anything passed by WILO_FileName) */
#define	WILO_CloseHook		WILD_OTHERSTD+106	/* hook convs: a0.hook hdata:fh (anything returned by openhook) */

/* note: the Seek hook may or may not be needed. If you know what loader you are
 using, see if it wants or not. If you don't know, you MUST prodive it ! 
 Now, only wsff needs it. */

/* Saver tags... */

#define	WISA_ObjectType		WIBU_ObjectType
#define WISA_WriteHook		WILD_OTHERSTD+110	/* hook convs: a0:hook a1:buf a2:len */
#define WISA_FileHandle		WILO_FileHandle
#define	WISA_FileName		WILO_FileName
#define WISA_Object		WILD_OTHERSTD+111	/* Wild obj to save */
#define WISA_SaveChilds		WILD_OTHERSTD+112	/* save childs ? (default:TRUE) */

/* More generic tags... */

#define WILD_ModuleGroup	WILD_OTHERSTD+1000
#define WILD_ModuleName		WILD_OTHERSTD+1001

#define	GROUP_Display	1
#define	GROUP_TDCore	2
#define	GROUP_Light	3
#define	GROUP_Draw	4
#define	GROUP_FX	5
#define	GROUP_Sound	6
#define	GROUP_Music	7
#define	GROUP_Broker	8
#define	GROUP_Loader	9

#endif
