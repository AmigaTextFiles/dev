#ifndef __HOLLYWOOD_PLUGIN_H
#define __HOLLYWOOD_PLUGIN_H
/*
**
**	$VER: plugin.h 10.0 (25.02.23)
**
**	Definitions for the Hollywood plugin interface
**
**	(C) Copyright 2002-2023 Andreas Falkenhahn
**	    All Rights Reserved
**
*/

#ifdef HW_PLUGIN_FT2BASE
#include <ft2build.h>
#include FT_FREETYPE_H
#include FT_GLYPH_H
#include FT_OUTLINE_H
#include FT_SYNTHESIS_H
#include FT_TRUETYPE_TABLES_H
#include FT_STROKER_H
#endif

#ifdef HW_PLUGIN_JPEGBASE
#ifdef HW_MORPHOS
#include <libraries/jfif.h>
#else
#include <jpeglib.h>
#endif
#endif

#ifdef HW_PLUGIN_ZBASE
#ifdef HW_MORPHOS
#include <libraries/z.h>
#else
#include <zlib.h>
#endif
#endif

#include "types.h"

#include <stdio.h>
#include <stdarg.h>
#include <time.h>

/* Base Hollywood API for plugin */
#define HWPLUG_APIVERSION_MIN   5
#define HWPLUG_APIREVISION_MIN  0

#define HWPLUG_APIVERSION_CUR   10
#define HWPLUG_APIREVISION_CUR  0

/* Magic cookie used to identify plugins on Amiga compatible systems */
#ifndef HW_LITTLE_ENDIAN
#define HWPLUG_COOKIE1      0x484F4C49  // 'HOLI'
#define HWPLUG_COOKIE2      0x574F4F44  // 'WOOD'
#else
#define HWPLUG_COOKIE1      0x494C4F48  // 'HOLI'
#define HWPLUG_COOKIE2      0x444F4F57  // 'WOOD'
#endif

/* Plugin capabilities -- for every bit you set in the CapsMask you must implement all corresponding functions (see below) */
#define HWPLUG_CAPS_CONVERT             0x00000001
#define HWPLUG_CAPS_LIBRARY             0x00000002
#define HWPLUG_CAPS_IMAGE               0x00000004
#define HWPLUG_CAPS_ANIM                0x00000008
#define HWPLUG_CAPS_SOUND               0x00000010
#define HWPLUG_CAPS_VECTOR              0x00000020
#define HWPLUG_CAPS_VIDEO               0x00000040
#define HWPLUG_CAPS_SAVEIMAGE           0x00000080
#define HWPLUG_CAPS_SAVEANIM            0x00000100
#define HWPLUG_CAPS_SAVESAMPLE          0x00000200
#define HWPLUG_CAPS_REQUIRE             0x00000400  // V6.0
#define HWPLUG_CAPS_DISPLAYADAPTER      0x00000800  // V6.0
#define HWPLUG_CAPS_TIMERADAPTER        0x00001000  // V6.0
#define HWPLUG_CAPS_REQUESTERADAPTER    0x00002000  // V6.0
#define HWPLUG_CAPS_FILEADAPTER         0x00004000  // V6.0
#define HWPLUG_CAPS_DIRADAPTER          0x00008000  // V6.0
#define HWPLUG_CAPS_AUDIOADAPTER        0x00010000  // V6.0
#define HWPLUG_CAPS_EXTENSION           0x00020000  // V6.0
#define HWPLUG_CAPS_NETWORKADAPTER      0x00040000  // V8.0
#define HWPLUG_CAPS_SERIALIZE           0x00080000  // V9.0
#define HWPLUG_CAPS_ICON                0x00100000  // V9.0
#define HWPLUG_CAPS_SAVEICON            0x00200000  // V9.0
#define HWPLUG_CAPS_IPCADAPTER          0x00400000  // V9.0
#define HWPLUG_CAPS_FONT                0x00800000  // V10.0
#define HWPLUG_CAPS_FILESYSADAPTER      0x01000000  // V10.0

/* Base platforms */
#define HWARCH_OS3          0   // AmigaOS 3.x
#define	HWARCH_MOS          1   // MorphOS
#define HWARCH_WOS          2   // WarpOS
#define HWARCH_OS4          3   // AmigaOS 4.x
#define	HWARCH_AROS         4
#define	HWARCH_WIN32        5
#define HWARCH_MACOS        6
#define HWARCH_LINUX        7
#define	HWARCH_IOS          8
#define HWARCH_ANDROID      9

#ifdef HW_USEPREFIX
#define HWP_ENTRY(f) hwp_##f
#else
#define HWP_ENTRY(f) f
#endif

#if defined(HW_AMIGAOS3) || defined(HW_WARPOS)
#define HW_EXPORT __saveds
#elif defined(HW_WIN32)
#define HW_EXPORT __declspec(dllexport)
#else
#define HW_EXPORT
#endif

#if defined(HW_AMIGAOS3) || defined(HW_WARPOS)
#define SAVEDS __saveds
#else
#define SAVEDS
#endif

#if defined _MSC_VER
typedef __int64 hint64;
typedef unsigned __int64 huint64;
#elif !defined(HW_AMIGAOS3)
typedef long long hint64;
typedef unsigned long long huint64;
#endif

#if defined(HW_AMIGAOS3) || defined(HW_WARPOS)
typedef int DOSINT64;
#else
typedef hint64 DOSINT64;
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef lua_h
typedef APTR lua_State;
typedef double lua_Number;
typedef int (*lua_CFunction) (lua_State *L);

#define LUAL_BUFFERSIZE 1024

typedef struct luaL_Buffer {
	char *p;                      /* current position in buffer */
  	int lvl;  /* number of strings in the stack (level) */
  	lua_State *L;
  	char buffer[LUAL_BUFFERSIZE];
} luaL_Buffer; 
#endif

typedef struct _lua_ID
{
	int num;
	void *ptr;
} lua_ID;

struct hwcrt_stat
{
	size_t struct_size;
	ULONG hwst_mode;
	DOSINT64 hwst_size;
	time_t hwst_atime;
	time_t hwst_mtime;
	time_t hwst_ctime;
};

struct hwcrt_tm
{
	size_t struct_size;
	int hwtm_sec;
	int hwtm_min;
	int hwtm_hour;
	int hwtm_mday;
	int hwtm_mon;
	int hwtm_year;
	int hwtm_wday;
	int hwtm_yday;
	int hwtm_isdst;
	long hwtm_gmtoff;
	char *hwtm_zone;
};

struct hwCmdStruct
{
	STRPTR Name;
	int (*Func)(lua_State *L);
};

struct hwCstStruct
{
	STRPTR Name;
	STRPTR StrVal;
	double Val;
};

struct hwHelpStruct
{
	STRPTR HelpText;
	STRPTR Node;
};
	
struct hwos_ExLockStruct
{
	int nStructSize;
	STRPTR Name;
	int Type;
	ULONG Size;
	ULONG Flags;
};

struct hwos_DateStruct
{
	int Seconds;
	int Minutes;
	int Hours;
	int Day;
	int Month;
	int Year;
};

struct hwos_StatStruct
{
	int Type;
	DOSINT64 Size;
	ULONG Flags;
	struct hwos_DateStruct Time;
	struct hwos_DateStruct LastAccessTime;
	struct hwos_DateStruct CreationTime;
	STRPTR FullPath;
	STRPTR Comment;
	int LinkMode;
	STRPTR Container;
};

struct hwos_TimeVal
{
	ULONG tv_secs;
	ULONG tv_micro;
};

struct hwos_LockBrushStruct
{
	APTR RGBData;
	int RGBModulo;
	UBYTE *AlphaData;
	int AlphaModulo;
	UBYTE *MaskData;
	int MaskModulo;
	int PixelFormat;
	int BytesPerPixel;
	int Width;
	int Height;
	UBYTE *CLUTData;  // V9.0
	int CLUTModulo;   // V9.0
	ULONG *Palette;   // V9.0
	ULONG TransPen;   // V9.0
	int Depth;        // V9.0
};

struct hwos_LockBitMapStruct
{
	APTR Data;
	int Modulo;
	int PixelFormat;
	int BytesPerPixel;
	int Width;
	int Height;
};

struct hwos_LockSampleStruct
{
	APTR Buffer;
	int BufferSize;
	int Samples;
	int Channels;
	int Bits;
	int Frequency;
	ULONG Flags;
};

// for compatibility with Hollywood versions <= 10
#define hwRequireUserTagList hwUserTagList

struct hwUserTagList
{
	struct hwUserTagList *Succ;
	STRPTR Name;
	STRPTR Str;
	double Val;
	int Length;   // V10.0
};

struct LoadImageCtrl
{
	int Width;
	int Height;
	int LineWidth;
	int AlphaChannel;
	int ForceAlphaChannel;
	int Type;
	ULONG Flags;                    // V5.3
	int ScaleWidth;                 // V5.3
	int ScaleHeight;                // V5.3
	int BaseWidth;                  // V5.3
	int BaseHeight;                 // V5.3
	ULONG ScaleMode;                // V5.3
	STRPTR Adapter;                 // V6.0
	ULONG *Palette;                 // V9.0
	ULONG TransPen;                 // V9.0
	int Depth;                      // V9.0
	struct hwUserTagList *UserTags; // V10.0
};

struct LoadAnimCtrl
{
	int Width;
	int Height;
	int LineWidth;
	int NumFrames;
	int AlphaChannel;
	int ForceAlphaChannel;
	STRPTR Adapter;                 // V6.0	
	ULONG Flags;                    // V6.0
	ULONG *Palette;                 // V9.0
	ULONG TransPen;                 // V9.0
	int Depth;                      // V9.0	
	int Type;                       // V9.0
	struct hwUserTagList *UserTags; // V10.0
};

struct LoadSoundCtrl
{
	ULONG Samples;
	int Channels;
	int Bits;
	int Frequency;
	ULONG Flags;
	int SubSong;                    // V5.3
	int NumSubSongs;                // V5.3
	STRPTR Adapter;                 // V6.0
	struct hwUserTagList *UserTags; // V10.0
};

struct StreamSamplesCtrl
{
	APTR Buffer;
	int Request;
	int Written;
	int Done;
};

struct OpenVideoCtrl
{
	int Width;
	int Height;
	ULONG Duration;
	int Frequency;
	int Channels;
	int SeekMode;
	int BitRate;
	int PixFmt;
	ULONG Flags;
	int Pad;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double FrameTime;
	DOSINT64 FileSize;              // V6.0
	STRPTR Adapter;                 // V6.0
	struct hwUserTagList *UserTags; // V10.0
};

struct VideoPacketStruct
{
	APTR Packet;
	int Type;
	int Size;
	int Pad;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double PTS;
};

struct DecodeVideoFrameCtrl
{
	UBYTE **Buffer;
	int *BufferWidth;
	int Delay;
	ULONG Offset;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double PTS;
	double DTS;
};

struct DecodeAudioFrameCtrl
{
	WORD *Buffer;
	int BufferSize;
	int Written;
	int Done;
};

struct hwMatrix2D
{
	double sx;
	double rx;
	double ry;
	double sy;
	double tx;
	double ty;
};

struct PathStyle
{
	int LineJoin;
	int LineCap;
	int FillRule;
	int AntiAlias;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double DashOffset;
	double *Dashes;
	int NumDashes;
	// NB: doubles must be on an 8 byte alignment because of WarpOS	
	double MiterLimit;           // V7.1
};

struct PathExtentsCtrl
{
	void *Path;
	struct PathStyle *Style;
	int Fill;
	int Thickness;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double TX;
	double TY;
	double X1;
	double Y1;
	double X2;
	double Y2;
	struct hwMatrix2D *Matrix;   // V6.0
};

struct DrawPathCtrl
{
	void *Path;
	struct PathStyle *Style;
	int Fill;
	int Thickness;
	ULONG Color;
	UBYTE *Buf;
	int LineWidth;
	int Width;
	int Height;
	int Pad;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double TX;
	double TY;
	double MinX;
	double MinY;
	struct hwMatrix2D *Matrix;
};

struct TranslatePathCtrl
{
	void *Path;
	int Pad;
	// NB: doubles must be on an 8 byte alignment because of WarpOS
	double TX;
	double TY;
};

struct SaveFormatReg
{
	ULONG CapsMask;
	ULONG FormatID;
	STRPTR FormatName;
};
		
struct SaveImageReg
{
	struct SaveFormatReg hdr;
};

struct SaveImageCtrl
{
	APTR Data;
	ULONG *Palette;
	int Width;
	int Height;
	int Modulo;
	int Format;
	int Quality;
	int Colors;
	ULONG TransIndex;
	ULONG Flags;
	ULONG FormatID;                 // V5.3
	STRPTR Adapter;                 // V10.0
	struct hwUserTagList *UserTags; // V10.0
};

struct SaveAnimReg
{
	struct SaveFormatReg hdr;
};

struct SaveAnimCtrl
{
	APTR Data;
	ULONG *Palette;
	int Modulo;
	int Colors;
	ULONG TransIndex;	
	int Delay;
	ULONG Flags;
	ULONG FormatID;   // V5.3	
};

struct SaveSampleReg
{
	struct SaveFormatReg hdr;
};

struct SaveSampleCtrl
{
	APTR Data;
	int DataSize;
	int Samples;
	int Channels;
	int Bits;
	int Frequency;
	ULONG Flags;
	ULONG FormatID;                 // V5.3	
	STRPTR Adapter;                 // V10.0
	struct hwUserTagList *UserTags; // V10.0
};

struct SaveIconReg
{
	struct SaveFormatReg hdr;
};

struct hwSatelliteBltBitMap
{
	APTR BitMap;
	int BitMapType;
	int BitMapWidth;
	int BitMapHeight;
	int BitMapModulo;
	int BitMapPixFmt;
	UBYTE *Mask;
	int MaskModulo;
	int SrcX;
	int SrcY;
	int DstX;
	int DstY;
	int Width;
	int Height;
	ULONG *Palette;    // V9.0
};

struct hwSatelliteRectFill
{
	int X;
	int Y;
	int Width;
	int Height;
	ULONG Color;
};

struct hwSatelliteWritePixel
{
	int X;
	int Y;
	ULONG Color;
};

struct hwSatelliteLine
{
	int X1;
	int Y1;
	int X2;
	int Y2;
	ULONG Color;
};

struct hwSatelliteResize
{
	int Width;
	int Height;
};

struct hwSatelliteSetPointer
{
	int Type;
	APTR Handle;
};

struct hwSatelliteShowHidePointer
{
	int Show;
};

struct hwSatelliteMovePointer
{
	int X;
	int Y;
};

struct hwSatelliteEventMouse
{
	int MouseX;
	int MouseY;
	int ButtonDown;
};

struct hwSatelliteEventKeyboard
{
	int KeyID;
	int KeyDown;
	ULONG Qualifiers;
};

struct hwSatelliteEventDropFile
{
	int MouseX;
	int MouseY;
	STRPTR DropFiles;
};
	
struct hwAddBrush
{
	ULONG *Data;
	int LineWidth;
	ULONG Transparency;
	ULONG Flags;
	APTR Image;
	ULONG *(*GetImage)(APTR handle, struct LoadImageCtrl *ctrl);
	void (*FreeImage)(APTR handle);
	int (*TransformImage)(APTR handle, struct hwMatrix2D *m, int width, int height);
	int Depth;       // V9.0
	ULONG *Palette;  // V9.0
};

struct hwObjectListHeader
{
	int type;
	lua_ID id;
	APTR reserved;
};
		
struct hwObjectList
{
	struct hwObjectListHeader hdr;
	struct hwObjectList *succ;
	// ... private data can follow here ...
};

struct hwIconList
{
	struct hwIconList *Succ;
	APTR Data;
	int Width;
	int Height;
	ULONG Flags;
	ULONG *Palette;     // V9.0
	ULONG TransPen;     // V9.0
	int Depth;          // V9.0
	APTR UserData;      // V9.0
};

struct hwIconEntry
{
	APTR Data;
	int Width;
	int Height;
	ULONG Flags;
	ULONG *Palette;  // V9.0
	ULONG TransPen;  // V9.0
	int Depth;       // V9.0	
};

struct hwIconAmigaExt
{
	int Type;
	int ViewMode;
	int IconX;
	int IconY;
	int DrawerX;
	int DrawerY;
	int DrawerWidth;
	int DrawerHeight;
	int StackSize;
	STRPTR DefaultTool;
	STRPTR *ToolTypes;
	ULONG Flags;
};	

struct hwTagList
{
	ULONG Tag;
	union {
		ULONG iData;
		void *pData;
	} Data;
};

/* used with HWEVTHANDLER_STANDARD */
struct hwStandardEventHandler
{
	void (*EvtFunc)(lua_State *L, int type, APTR userdata);
};
	
/* used with HWEVTHANDLER_CUSTOM */	
struct hwCustomEventHandler
{
	int (*PushData)(lua_State *L, int type, APTR userdata);
	void (*PostCall)(lua_State *L, int type, APTR userdata);
	void (*FreeEvent)(lua_State *L, int type, APTR userdata);
};

struct hwBltBitMapCtrl
{
	int SrcX;
	int SrcY;
	int DstX;
	int DstY;
	int Width;
	int Height;
	int ScaleWidth;
	int ScaleHeight;
	ULONG ScaleMode;
	APTR Mask;
	APTR Alpha;
	struct hwMatrix2D *Matrix; // [V8.0]
	double AnchorX;            // [V8.0]
	double AnchorY;            // [V8.0]
	int AlphaMod;              // [V8.0] 
	ULONG *Palette;            // [V9.0] 
	ULONG TransPen;            // [V9.0]
};

struct hwRawBltBitMapCtrl
{
	int SrcX;
	int SrcY;
	int DstX;
	int DstY;
	int Width;
	int Height;
	int PixFmt;
	UBYTE *MaskData;
	UBYTE *AlphaData;
	int SrcModulo;
	int DstModulo;
	int MaskModulo;
	int AlphaModulo;
};

struct hwRawScaleCtrl
{
	int SrcX;
	int SrcY;
	int DstX;
	int DstY;
	int SrcWidth;
	int SrcHeight;
	int DstWidth;
	int DstHeight;
	int PixFmt;
	int SrcModulo;
	int DstModulo;
};
	
struct hwMonitorInfo
{
	int X;
	int Y;
	int Width;
	int Height;
};

struct hwVideoModeInfo
{
	int Width;
	int Height;
	int Depth;
};

struct hwTranslateFileInfo
{
	STRPTR File;
	int FileLen;
	STRPTR FileExt;
	int FileExtLen;
	STRPTR RealFile;
	int RealFileLen;
	APTR MemoryBlock;
	DOSINT64 Offset;
	DOSINT64 Length;
};

struct hwMakeVFileInfo
{
	STRPTR RealFile;
	APTR MemoryBlock;
	STRPTR FileExt;
	DOSINT64 Offset;
	DOSINT64 Length;
};

struct hwGVMErrorInfo
{
	int Line;
	STRPTR Function;
	STRPTR File;
};

struct hwVertex
{
	int X;
	int Y;
};

struct hwRect
{
	int X;
	int Y;
	int Width;
	int Height;
};

struct hwFileReqFilterInfo
{
	struct hwFileReqFilterInfo *Succ;
	STRPTR Description;
	STRPTR Filter;
	ULONG Flags;
};

struct hwSerializeItemInfo
{
	int Type;
	APTR Data;
	int Length;
	ULONG Flags;
};
	
struct hwRemapCtrl
{
	int Width;
	int Height;
	int SrcDepth;
	int DstDepth;
	ULONG *SrcPalette;
	ULONG *DstPalette;
	ULONG SrcTransPen;
	ULONG DstTransPen;
};

struct hwMenuTreeInfo
{
	struct hwMenuTreeInfo *Succ;
	STRPTR Name;
	STRPTR ID;
	STRPTR Hotkey;
	ULONG Flags;
	struct hwMenuTreeInfo *FirstChild;
	APTR UserData;
};

/* used by HWOPENCONNTAG_MULTIPART [V9.0] */
struct hwMultiPartInfo
{
	struct hwMultiPartInfo *Succ;
	STRPTR Name;
	STRPTR MIMEType;
	STRPTR DestFile;
	STRPTR Data;
	APTR FileHandle;
	DOSINT64 Length;
};

struct hwTextExtent
{
	int MinX;
	int MinY;
	int MaxX;
	int MaxY;
	int Width;
	int Height;
};

struct hwLoadFontCtrl
{
	STRPTR Name;
	STRPTR Adapter;
	ULONG *Palette;
	ULONG TransPen;
	ULONG Flags;
	int Depth;
	int Height;
	int Baseline;
	struct hwUserTagList *UserTags;
};	
	
struct hwRenderTextCtrl
{
	int X;
	int Y;
	int Width;
	int Height;
	APTR RGBData;
	int RGBModulo;
	UBYTE *AlphaData;
	int AlphaModulo;
	UBYTE *MaskData;
	int MaskModulo;
	UBYTE *CLUTData;
	int CLUTModulo;
	int PixelFormat;
	int BytesPerPixel;
};

struct hwTextLayout
{
	ULONG Color;
	ULONG Style;
	int Align;
	int WrapWidth;
	int LineSpacing;
	int CharSpacing;
	int Indent;
	int AdvanceX;
	int AdvanceY;
	int *Tabs;
	int TabCount;
};
			
/* for HWEVT_CALLFUNCTION */
struct hwEvtCallFunction
{
	int (*Func)(lua_State *L, APTR userdata);
	APTR UserData;
};	

/* for HWEVT_MOUSE */
struct hwEvtMouse
{
	APTR Handle;
	int X;
	int Y;
	int Button;
	int Down;
	ULONG Flags;
};

/* for HWEVT_KEYBOARD */
struct hwEvtKeyboard
{
	APTR Handle;
	int ID;
	int Down;
	ULONG Qualifiers;
	ULONG Flags;
};
	
/* for HWEVT_CLOSEDISPLAY */
struct hwEvtCloseDisplay
{
	APTR Handle;
	ULONG Flags;
};

/* for HWEVT_SIZEDISPLAY */	
struct hwEvtSizeDisplay
{
	APTR Handle;
	int Width;
	int Height;
	ULONG Flags;
};

/* for HWEVT_MOVEDISPLAY */
struct hwEvtMoveDisplay
{
	APTR Handle;
	int X;
	int Y;
	ULONG Flags;
};

/* for HWEVT_SHOWHIDEDISPLAY */
struct hwEvtShowHideDisplay
{
	APTR Handle;
	int Show;
	ULONG Flags;
};	

/* for HWEVT_FOCUSCHANGEDISPLAY */
struct hwEvtFocusChangeDisplay
{
	APTR Handle;
	int Focus;
	ULONG Flags;
};

/* for HWEVT_DROPFILE */
struct hwEvtDropFile
{
	APTR Handle;
	int MouseX;
	int MouseY;
	STRPTR DropFiles;
	ULONG Flags;
};

/* for HWEVT_MOUSEWHEEL */
struct hwEvtMouseWheel
{
	APTR Handle;
	int X;
	int Y;
	ULONG Flags;
};

/* for HWEVT_MENUITEM */
struct hwEvtMenuItem
{
	APTR Handle;
	APTR Item;
	ULONG Flags;
};

/* for HWEVT_USERMESSAGE */
struct hwEvtUserMessage
{
	APTR Data;
	int DataSize;
	ULONG Flags;
};	

/* image types for LoadImageCtrl */
#define HWIMAGETYPE_RASTER 0
#define HWIMAGETYPE_VECTOR 1

/* flags for LoadImageCtrl [V5.3] */
#define HWIMGFLAGS_DIDSCALE         0x00000001
#define HWIMGFLAGS_TRANSPARENCY     0x00000002  // V6.0
#define HWIMGFLAGS_LOADPALETTE      0x00000004  // V9.0

/* flags for LoadAnimCtrl [V6.0] */
#define HWANMFLAGS_TRANSPARENCY     0x00000001 
#define HWANMFLAGS_LOADPALETTE      0x00000002  // V9.0

/* tags for hw_MasterControl() */
#define HWMCP_GETPOWERPCBASE         25
#define HWMCP_GETAPPTITLE            26    // V5.2
#define HWMCP_GETAPPVERSION          27    // V5.2
#define HWMCP_GETAPPCOPYRIGHT        28    // V5.2
#define HWMCP_GETAPPAUTHOR           29    // V5.2
#define HWMCP_GETAPPDESCRIPTION      30    // V5.2
#define HWMCP_SETCALLBACKMODE        31    // V6.0
#define HWMCP_GETGTKREADY            32    // V6.0, Linux only
#define HWMCP_SETDISABLELINEHOOK     33    // V6.0
#define HWMCP_GETGENERICRP           34    // V6.0, Amiga only, private
#define HWMCP_GETFPSLIMIT            35    // V6.0
#define HWMCP_GETDESIGNERVERSION     36    // V6.0
#define HWMCP_GETAPPIDENTIFIER       37    // V6.1
#define HWMCP_SETGLOBALQUIT          38    // V6.1
#define HWMCP_SETLIGHTCHKEVT         39    // V6.1
#define HWMCP_RESETERRORFLAG         40    // V6.1
#define HWMCP_SETAMIGASIGNALERROR    41    // V6.1
#define HWMCP_PRIVATE1               42    // V6.1
#define HWMCP_SETDISABLERAISEONERROR 43    // V7.0
#define HWMCP_GETEXITONERROR         44    // V7.1
#define HWMCP_GETLUASTATE            45    // V7.1 
#define HWMCP_GETDENSITY             46    // V8.0 
#define HWMCP_GETAMIGASIGNALS        47    // V9.0
#define HWMCP_SETFORBIDMODAL         48    // V9.0
#define HWMCP_GETMOUSEPOINTER        49    // V9.0, Amiga only, private

/* mem types for hw_TrackedAlloc() */
#define HWMEMF_CLEAR 0x00000001

/* flags for LoadSoundCtrl */
#define HWSNDFLAGS_BIGENDIAN 0x00000001
#define HWSNDFLAGS_SIGNEDINT 0x00000002
#define HWSNDFLAGS_CANSEEK   0x00000004
#define HWSNDFLAGS_INFINITE  0x00000008    // V9.0

/* seek modes for OpenVideoCtrl */
#define HWVIDSEEKMODE_TIME 0
#define HWVIDSEEKMODE_BYTE 1

/* pixel formats for OpenVideoCtrl */
#define HWVIDPIXFMT_YUV420P 0
#define HWVIDPIXFMT_ARGB32  1

/* flags for OpenVideoCtrl */
#define HWVIDFLAGS_CANSEEK   0x00000001

/* packet types for VideoPacketStruct */
#define HWVIDPKTTYPE_VIDEO 0
#define HWVIDPKTTYPE_AUDIO 1

/* commands for DrawPath() / GetPathExtents() */
enum {CCMD_STACKTOP, CCMD_MOVETO, CCMD_LINETO, CCMD_CURVETO, CCMD_UNUSED, CCMD_NEWSUBPATH,
	CCMD_CLOSEPATH, CCMD_ARC, CCMD_BOX, CCMD_TEXT};

/* supported line join modes for PathStyle.LineJoin */
#define HWLINEJOIN_MITER 0
#define HWLINEJOIN_ROUND 1
#define HWLINEJOIN_BEVEL 2

/* supported line caps for PathStyle.LineCap */
#define HWLINECAP_BUTT   0
#define HWLINECAP_ROUND  1
#define HWLINECAP_SQUARE 2

/* supported fill rules for PathStyle.FillRule */
#define HWFILLRULE_WINDING 0
#define HWFILLRULE_EVENODD 1

/* capabilities for SaveImageReg */
#define HWSAVEIMGCAPS_ARGB   0x00000001
#define HWSAVEIMGCAPS_CLUT   0x00000002
#define HWSAVEIMGCAPS_ALPHA  0x00000004
#define HWSAVEIMGCAPS_MORE   0x00000008   // V5.3

/* image formats for SaveImageCtrl */
#define HWSAVEIMGFMT_ARGB   0
#define HWSAVEIMGFMT_CLUT   1

/* image flags for SaveImageCtrl */
#define HWSAVEIMGFLAGS_ALPHA      0x00000001
#define HWSAVEIMGFLAGS_TRANSINDEX 0x00000002

/* capabilities for SaveAnimReg */
#define HWSAVEANMCAPS_ARGB         0x00000001
#define HWSAVEANMCAPS_CLUT         0x00000002
#define HWSAVEANMCAPS_ALPHA        0x00000004
#define HWSAVEANMCAPS_TRANSPARENCY 0x00000008   // currently unused
#define HWSAVEANMCAPS_MORE         0x00000010   // V5.3

/* image formats for SaveAnimCtrl */
#define HWSAVEANMFMT_ARGB     0
#define HWSAVEANMFMT_CLUT     1

/* image flags for SaveAnimCtrl */
#define HWSAVEANMFLAGS_ALPHA        0x00000001
#define HWSAVEANMFLAGS_TRANSINDEX   0x00000002

/* capabilities for SaveSampleReg */
#define HWSAVESMPCAPS_MORE   0x00000001   // V5.3

/* types for hw_FSeek() */
#define HWFSEEKMODE_CURRENT    0
#define HWFSEEKMODE_BEGINNING  1
#define HWFSEEKMODE_END        2

/* types for hw_FOpen() and hw_FOpenExt() */
#define HWFOPENMODE_READ_LEGACY   0x00000000   // set to 0 for compatibility reasons
#define HWFOPENMODE_WRITE         0x00000001
#define HWFOPENMODE_READWRITE     0x00000002
#define HWFOPENMODE_READ_NEW      0x00000004   // V6.0
#define HWFOPENMODE_NOFILEADAPTER 0x00000008   // V6.0
#define HWFOPENMODE_EMULATESEEK   0x00000010   // V6.0
#define HWFOPENMODE_FORCEUTF8     0x00000020   // V7.0
#define HWFOPENMODE_WONTSEEK      0x00000040   // V10.0

/* flags for hw_Stat() */
#define HWSTATFLAGS_NOFILEADAPTER  0x00000001
#define HWSTATFLAGS_ALLOCSTRINGS   0x00000002

/* types for hwos_StatStruct */
#define HWSTATTYPE_FILE        0
#define HWSTATTYPE_DIRECTORY   1

/* link modes for hwos_StatStruct */
#define HWSTATLKMODE_NORMAL    0
#define HWSTATLKMODE_NONE      1
#define HWSTATLKMODE_CONTAINER 2

/* types for hw_Lock() */
#define HWLOCKMODE_READ_LEGACY  0x00000000   // set to 0 for compatibility reasons
#define HWLOCKMODE_WRITE        0x00000001
#define HWLOCKMODE_READ         0x00000002   // V6.0, obsolete since V10.0
#define HWLOCKMODE_NOADAPTER    0x00000004   // V6.0
#define HWLOCKMODE_ANY          0x00000002   // V10.0, replaces HWLOCKMODE_READ
#define HWLOCKMODE_FILE         0x00000008   // V10.0
#define HWLOCKMODE_DIR          0x00000010   // V10.0

/* types for hwos_ExLockStruct() */
#define HWEXLOCKTYPE_FILE        0
#define HWEXLOCKTYPE_DIRECTORY   1

/* supported pixel formats */
#define HWOS_PIXFMT_RGB15    0
#define HWOS_PIXFMT_BGR15    1
#define HWOS_PIXFMT_RGB15PC  2
#define HWOS_PIXFMT_BGR15PC  3
#define HWOS_PIXFMT_RGB16    4
#define HWOS_PIXFMT_BGR16    5
#define HWOS_PIXFMT_RGB16PC  6
#define HWOS_PIXFMT_BGR16PC  7
#define HWOS_PIXFMT_RGB24    8
#define HWOS_PIXFMT_BGR24    9
#define HWOS_PIXFMT_ARGB32   10
#define HWOS_PIXFMT_BGRA32   11
#define HWOS_PIXFMT_RGBA32   12
#define HWOS_PIXFMT_ABGR32   13
#define HWOS_PIXFMT_ALPHA8   14
#define HWOS_PIXFMT_MONO1    15
#define HWOS_PIXFMT_CLUT     HWOS_PIXFMT_ALPHA8

/* weight and slant constants for hw_FindTTFFont() */
#define HWFONTWEIGHT_THIN       0 
#define HWFONTWEIGHT_EXTRALIGHT 40 
#define HWFONTWEIGHT_ULTRALIGHT 40 
#define HWFONTWEIGHT_LIGHT      50
#define HWFONTWEIGHT_BOOK       75 
#define HWFONTWEIGHT_NORMAL     80 
#define HWFONTWEIGHT_REGULAR    80 
#define HWFONTWEIGHT_MEDIUM     100 
#define HWFONTWEIGHT_SEMIBOLD   180 
#define HWFONTWEIGHT_DEMIBOLD   180 
#define HWFONTWEIGHT_BOLD       200
#define HWFONTWEIGHT_EXTRABOLD  205 
#define HWFONTWEIGHT_ULTRABOLD  205 
#define HWFONTWEIGHT_HEAVY      210 
#define HWFONTWEIGHT_BLACK      210
#define HWFONTWEIGHT_EXTRABLACK 215
#define HWFONTWEIGHT_ULTRABLACK 215 
#define HWFONTSLANT_ROMAN       0
#define HWFONTSLANT_ITALIC      100
#define HWFONTSLANT_OBLIQUE     110

/* tags for hw_LockBrush() */
#define HWLBRSHTAG_READONLY 1   // V6.0
#define HWLBRSHTAG_PALETTE  2   // V9.0
#define HWLBRSHTAG_DEPTH    3   // V9.0

/* types for hw_RegisterCallback() [V5.2] */
#define HWCB_AMIGASIGNAL    0
#define HWCB_LINEHOOK       1   // V6.0
#define HWCB_SHOWHIDEAPP    2   // V6.1
#define HWCB_ENCODINGCHANGE 3   // V7.0
#define HWCB_DROPFILECHANGE 4   // V7.0

/* tags for hw_GetARGBBrush() [V5.2] */
#define HWGAB_WIDTH   1
#define HWGAB_HEIGHT  2
#define HWGAB_OPAQUE  3
#define HWGAB_FLAGS   4   // V8.0

/* flags for hw_GetARGBBrush() [V8.0] */
#define HWGABFLAGS_SCALE       0x00000001
#define HWGABFLAGS_INTERPOLATE 0x00000002

/* tags for hw_AttachDisplaySatellite() [V5.2] */
#define HWADS_WIDTH            1
#define HWADS_HEIGHT           2
#define HWADS_DISPATCHVWAIT    3   // V6.0
#define HWADS_OPTIMIZEDREFRESH 4   // V6.1
#define HWADS_CUSTOMSCALING    5   // V8.0
#define HWADS_BUFFERWIDTH      6   // V8.0
#define HWADS_BUFFERHEIGHT     7   // V8.0
#define HWADS_PALETTE          8   // V9.0
#define HWADS_MOUSEPOINTER     9   // V9.0

/* operations for the display satellite dispatcher [V5.2] */
#define HWSATOP_BLTBITMAP       0
#define HWSATOP_RECTFILL        1
#define HWSATOP_LINE            2
#define HWSATOP_WRITEPIXEL      3
#define HWSATOP_RESIZE          4
#define HWSATOP_VWAIT           5    // V6.0
#define HWSATOP_SETPOINTER      6    // V9.0
#define HWSATOP_SHOWHIDEPOINTER 7    // V9.0
#define HWSATOP_MOVEPOINTER     8    // V9.0

/* bitmap formats for hwSatelliteBltBitMap.BitmapType [V5.2] */
#define HWSATBMTYPE_AMIGABITMAP 0
#define HWSATBMTYPE_PIXELBUFFER 1
#define HWSATBMTYPE_VIDEOBITMAP 2  // V6.0
#define HWSATBMTYPE_BITMAP      3  // V6.0
#define HWSATBMTYPE_CLUTBITMAP  4  // V9.0

/* event types for hw_PostSatelliteEvent() [V5.2] */
#define HWSATEVT_MOUSEMOVE  0
#define HWSATEVT_LEFTMOUSE  1
#define HWSATEVT_RIGHTMOUSE 2
#define HWSATEVT_MIDMOUSE   3
#define HWSATEVT_MOUSEWHEEL 4
#define HWSATEVT_KEYBOARD   5
#define HWSATEVT_VANILLAKEY 6  // V7.0
#define HWSATEVT_DROPFILE   7  // V7.0
#define HWSATEVT_RAWKEY     8  // V7.1

/* flags for hw_AddBrush() [V5.3] */
#define HWABFLAGS_USEALPHA        0x00000001
#define HWABFLAGS_USETRANSPARENCY 0x00000002
#define HWABFLAGS_VECTORBRUSH     0x00000004
#define HWABFLAGS_USEPALETTE      0x00000008  // V9.0

/* object types for hw_RegisterFileType() [V5.3] */
#define HWFILETYPE_IMAGE 0
#define HWFILETYPE_ANIM  1
#define HWFILETYPE_SOUND 2
#define HWFILETYPE_VIDEO 3
#define HWFILETYPE_ICON  4   // V9.0
#define HWFILETYPE_FONT  5   // V10.0

/* flags for hw_RegisterFileType() [V5.3] */
#define HWFILETYPEFLAGS_SAVE    0x00000001
#define HWFILETYPEFLAGS_ALPHA   0x00000002
#define HWFILETYPEFLAGS_QUALITY 0x00000004
#define HWFILETYPEFLAGS_FPS     0x00000008

/* tags for GfxBase->hw_LockBitMap() [V6.0] */
#define HWLBMAPTAG_READONLY 1   // V6.0

/* flags for hw_MasterServer() [V6.0] */
#define HWMSFLAGS_RUNCALLBACKS  0x00000001
#define HWMSFLAGS_DRAWVIDEOS    0x00000002

/* types for hw_RegisterEventHandlerEx() [V6.0] */
#define HWEVTHANDLER_STANDARD   0
#define HWEVTHANDLER_CUSTOM     1

/* tags for hw_GetEventHandler() [V6.1] */
#define HWGEHTAG_USERDATA 1

/* inbuilt types for hw_PostEvent() [V6.0] */
#define HWEVT_QUIT                0
#define HWEVT_CALLFUNCTION        1
#define HWEVT_WAKEUP              2
#define HWEVT_MOUSE               3
#define HWEVT_KEYBOARD            4
#define HWEVT_CLOSEDISPLAY        5
#define HWEVT_SIZEDISPLAY         6
#define HWEVT_MOVEDISPLAY         7
#define HWEVT_SHOWHIDEDISPLAY     8
#define HWEVT_FOCUSCHANGEDISPLAY  9
#define HWEVT_VANILLAKEY         10  // V7.0
#define HWEVT_DROPFILE           11  // V7.0
#define HWEVT_RAWKEY             12  // V7.1
#define HWEVT_MOUSEWHEEL         13  // V8.0
#define HWEVT_MENUITEM           14  // V9.0
#define HWEVT_USERMESSAGE        15  // V9.0
#define HWEVT_TRAYICON           16  // V9.0
#define HWEVT_MAX                25

/* button types for HWEVT_MOUSE */
#define HWMBTYPE_NONE    0
#define HWMBTYPE_LEFT    1
#define HWMBTYPE_RIGHT   2
#define HWMBTYPE_MIDDLE  3

/* flags for hw_SetDisplayAdapter() [V6.0] */
#define HWSDAFLAGS_PERMANENT           0x00000001
#define HWSDAFLAGS_TIEDVIDEOBITMAP     0x00000002
#define HWSDAFLAGS_SOFTWAREFALLBACK    0x00000004
#define HWSDAFLAGS_CUSTOMSCALING       0x00000008
#define HWSDAFLAGS_VIDEOBITMAPADAPTER  0x00000010
#define HWSDAFLAGS_BITMAPADAPTER       0x00000020
#define HWSDAFLAGS_DOUBLEBUFFERADAPTER 0x00000040
#define HWSDAFLAGS_ALPHADRAW           0x00000080
#define HWSDAFLAGS_SLEEP               0x00000100
#define HWSDAFLAGS_VWAIT               0x00000200
#define HWSDAFLAGS_MONITORINFO         0x00000400
#define HWSDAFLAGS_GRABSCREEN          0x00000800
#define HWSDAFLAGS_DRAWALWAYS          0x00001000  // V6.1
#define HWSDAFLAGS_PALETTE             0x00002000  // V9.0
#define HWSDAFLAGS_CLUTBITMAPADAPTER   0x00004000  // V9.0
#define HWSDAFLAGS_PENDRAW             0x00008000  // V9.0
#define HWSDAFLAGS_SETPALETTE          0x00010000  // V9.0
#define HWSDAFLAGS_MENUADAPTER         0x00020000  // V9.0
#define HWSDAFLAGS_SETTRAYICON         0x00040000  // V9.0
#define HWSDAFLAGS_POPUPMENU           0x00080000  // V10.0

/* tags for hw_SetDisplayAdapter() [V6.0] */
#define HWSDATAG_PIXELFORMAT      1
#define HWSDATAG_BITMAPHOOK       2
#define HWSDATAG_VIDEOBITMAPCAPS  3

/* flags for hw_SetRequesterAdapter() [V6.0] */
#define HWSRAFLAGS_PERMANENT        0x00000001
#define HWSRAFLAGS_SYSTEMREQUEST    0x00000002
#define HWSRAFLAGS_FILEREQUEST      0x00000004
#define HWSRAFLAGS_PATHREQUEST      0x00000008
#define HWSRAFLAGS_STRINGREQUEST    0x00000010
#define HWSRAFLAGS_LISTREQUEST      0x00000020
#define HWSRAFLAGS_FONTREQUEST      0x00000040
#define HWSRAFLAGS_COLORREQUEST     0x00000080

/* flags for hw_SetTimerAdapter() [V6.0] */
#define HWSTAFLAGS_PERMANENT        0x00000001

/* flags for hw_SetAudioAdapter() [V6.0] */
#define HWSAAFLAGS_PERMANENT        0x00000001
#define HWSAAFLAGS_UPDATE           0x00000002

/* tags for hw_SetAudioAdapter() [V6.0] */
#define HWSAATAG_BUFFERSIZE 1
#define HWSAATAG_CHANNELS   2

/* types for HWSDATAG_BITMAPHOOK [V6.0] */
#define HWBMAHOOK_BLTBITMAP      0x00000001
#define HWBMAHOOK_BLTMASKBITMAP  0x00000002
#define HWBMAHOOK_BLTALPHABITMAP 0x00000004
#define HWBMAHOOK_RECTFILL       0x00000008
#define HWBMAHOOK_WRITEPIXEL     0x00000010
#define HWBMAHOOK_LINE           0x00000020
#define HWBMAHOOK_BLTCLUTBITMAP  0x00000040  // V9.0

/* flags for hw_HandleEvents() [V6.0] */
#define HWHEFLAGS_LINEHOOK     0x00000001
#define HWHEFLAGS_MODAL        0x00000002
#define HWHEFLAGS_CHECKEVENT   0x00000004
#define HWHEFLAGS_WAITEVENT    0x00000008
#define HWHEFLAGS_RUNCALLBACKS 0x00000010   // V6.1

/* flags for hw_WaitEvents() [V6.0] */
#define HWWEFLAGS_MODAL      0x00000001

/* tags for hw_WaitEvents() [V6.0] */
#define HWWETAG_AMIGASIGNALS 1

/* attributes for hw_GetDisplayAttr() [V6.0] */
#define HWDISPATTR_RAWWIDTH      1
#define HWDISPATTR_RAWHEIGHT     2
#define HWDISPATTR_BUFFERWIDTH   3
#define HWDISPATTR_BUFFERHEIGHT  4
#define HWDISPATTR_FLAGS         5
#define HWDISPATTR_SCALEWIDTH    6
#define HWDISPATTR_SCALEHEIGHT   7
#define HWDISPATTR_SCALEMODE     8
#define HWDISPATTR_CANDROPFILE   9   // V7.0
#define HWDISPATTR_USESATELLITE 10   // V7.0
#define HWDISPATTR_SCALEFACTOR  11   // V8.0
 
/* tags for hw_RawBltBitMap() [V8.0] */
#define HWRBBTAG_CLIPRECT 1
 
/* flags for hw_RawRectFill() [V6.0] */
#define HWRRFFLAGS_BLEND 0x00000001

/* tags for hw_RawRectFill() [V6.0] */
#define HWRRFTAG_PIXFMT   1
#define HWRRFTAG_DSTWIDTH 2
#define HWRRFTAG_CLIPRECT 3   // V8.0

/* flags for hw_RawWritePixel() [V6.0] */
#define HWRWPFLAGS_BLEND 0x00000001

/* tags for hw_RawWritePixel() [V6.0] */
#define HWRWPTAG_PIXFMT   1
#define HWRWPTAG_DSTWIDTH 2
#define HWRWPTAG_CLIPRECT 3   // V8.0

/* flags for hw_RawLine() [V6.0] */
#define HWRLIFLAGS_BLEND 0x00000001

/* tags for hw_RawLine() [V6.0] */
#define HWRLITAG_PIXFMT   1
#define HWRLITAG_DSTWIDTH 2
#define HWRLITAG_CLIPRECT 3   // V8.0

/* flags for hw_RawPolyFill() [V7.1] */
#define HWRPFFLAGS_BLEND 0x00000001

/* tags for hw_RawPolyFill() [V7.1] */
#define HWRPFTAG_PIXFMT   1
#define HWRPFTAG_DSTWIDTH 2
#define HWRPFTAG_X        3   // V9.1
#define HWRPFTAG_Y        4   // V9.1

/* flags for hw_RawScale() [V8.0] */
#define HWRSCFLAGS_INTERPOLATE 0x00000001

/* tags for hw_BitMapToARGB() [V6.0] */
#define HWBM2ARGBTAG_X        1
#define HWBM2ARGBTAG_Y        2
#define HWBM2ARGBTAG_WIDTH    3
#define HWBM2ARGBTAG_HEIGHT   4
#define HWBM2ARGBTAG_CLUT     5   // V9.0
#define HWBM2ARGBTAG_PALETTE  6   // V9.0
#define HWBM2ARGBTAG_TRANSPEN 7   // V9.0

/* flags for hw_CompareString() [V7.0] */
#define HWCMPSTR_IGNORECASE 0x00000001

/* tags for HWPLUG_CAPS_REQUIRE/RequirePlugin() [V6.0] */
#define HWRPTAG_PLUGINFLAGS 1
#define HWRPTAG_USERTAGS    2

/* flags for HWRPTAG_PLUGINFLAGS [V6.0] */
#define HWPLUGINFLAGS_HIDEDISPLAYS  0x00000001
#define HWPLUGINFLAGS_SCALEDISPLAYS 0x00000002   // V8.0
#define HWPLUGINFLAGS_INTERPOLATE   0x00000004   // V8.0

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/OpenDisplay() [V6.0] */
#define HWDISPFLAGS_BORDERLESS      0x00000001
#define HWDISPFLAGS_SIZEABLE        0x00000002
#define HWDISPFLAGS_FIXED           0x00000004
#define HWDISPFLAGS_NOHIDE          0x00000008
#define HWDISPFLAGS_NOCLOSE         0x00000010
#define HWDISPFLAGS_AUTOSCALE       0x00000020
#define HWDISPFLAGS_LAYERSCALE      0x00000040
#define HWDISPFLAGS_LAYERS          0x00000080
#define HWDISPFLAGS_DOUBLEBUFFER    0x00000100
#define HWDISPFLAGS_HARDWAREDB      0x00000200
#define HWDISPFLAGS_FULLSCREEN      0x00000400
#define HWDISPFLAGS_DISABLEBLANKER  0x00000800
#define HWDISPFLAGS_ALWAYSONTOP     0x00001000    // V7.1
#define HWDISPFLAGS_SCALEFACTOR     0x00002000    // V9.0
#define HWDISPFLAGS_TRAPRMB         0x00004000    // V9.0
#define HWDISPFLAGS_KEEPPROPORTIONS 0x00008000    // V9.0

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/OpenDisplay() [V6.0] */
#define HWDISPTAG_BUFFERWIDTH      1
#define HWDISPTAG_BUFFERHEIGHT     2
#define HWDISPTAG_OPTIMIZEDREFRESH 3
#define HWDISPTAG_SINGLEREFRESHFX  4
#define HWDISPTAG_LUASTATE         5
#define HWDISPTAG_MONITOR          6
#define HWDISPTAG_SCREENWIDTH      7
#define HWDISPTAG_SCREENHEIGHT     8
#define HWDISPTAG_SCREENDEPTH      9
#define HWDISPTAG_SCALEWIDTH       10
#define HWDISPTAG_SCALEHEIGHT      11
#define HWDISPTAG_SCALEMODE        12
#define HWDISPTAG_DEPTH            13    // V9.0
#define HWDISPTAG_PALETTE          14    // V9.0
#define HWDISPTAG_PALETTEMODE      15    // V9.0
#define HWDISPTAG_MENU             16    // V9.0
#define HWDISPTAG_XPOSITION        17    // V9.1
#define HWDISPTAG_YPOSITION        18    // V9.1
#define HWDISPTAG_FLAGS            19    // V9.1
#define HWDISPTAG_USERTAGS         20    // V10.0

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/ActivateDisplay() [V6.0] */
#define HWACTDISPFLAGS_TOFRONT 0x00000001

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/SetDisplayAttributes() [V6.0] */
#define HWDISPSATAG_USERCLOSE 1

/* types for HWPLUG_CAPS_DISPLAYADAPTER/SetPointer() [V6.0] */
#define HWPOINTER_SYSTEM 0
#define HWPOINTER_BUSY   1
#define HWPOINTER_CUSTOM 2

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/BltBitMap() [V6.0] */
#define HWBBFLAGS_SRCVIDEOBITMAP  0x00000001
#define HWBBFLAGS_DESTBITMAP      0x00000002
#define HWBBFLAGS_DESTVIDEOBITMAP 0x00000004
#define HWBBFLAGS_DONOTBLEND      0x00000008
#define HWBBFLAGS_DESTALPHAONLY   0x00000010
#define HWBBFLAGS_IGNOREBKBUFFER  0x00000020
#define HWBBFLAGS_SRCCLUTBITMAP   0x00000040  // V9.0

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/RectFill() [V6.0] */
#define HWRFFLAGS_DESTBITMAP      0x00000001
#define HWRFFLAGS_DESTVIDEOBITMAP 0x00000002
#define HWRFFLAGS_DESTALPHAONLY   0x00000004

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/Line() [V6.0] */
#define HWLIFLAGS_DESTBITMAP      0x00000001
#define HWLIFLAGS_DESTVIDEOBITMAP 0x00000002
#define HWLIFLAGS_DESTALPHAONLY   0x00000004

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/WritePixel() [V6.0] */
#define HWWPFLAGS_DESTBITMAP      0x00000001
#define HWWPFLAGS_DESTVIDEOBITMAP 0x00000002
#define HWWPFLAGS_DESTALPHAONLY   0x00000004

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/VWait() [V6.0] */
#define HWVWAITTAG_DOUBLEBUFFER 1

/* types for HWPLUG_CAPS_DISPLAYADAPTER/GetMonitorInfo() [V6.0] */
#define HWGMITYPE_MONITORS   0
#define HWGMITYPE_VIDEOMODES 1

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/Flip() [V6.0] */
#define HWFLIPTAG_VSYNC 1

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/AllocVideoBitMap() [V6.0] */
#define HWAVBMFLAGS_BLEND       0x00000001
#define HWAVBMFLAGS_BITMAPDATA  0x00000002
#define HWAVBMFLAGS_PRIVATE1    0x00000004
#define HWAVBMFLAGS_PRIVATE2    0x00000008
#define HWAVBMFLAGS_SMOOTH      0x00000010    // [V8.0]
#define HWAVBMFLAGS_PRIVATE3    0x00000020    // [V9.0]

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/AllocVideoBitMap() [V6.0] */
#define HWAVBMTAG_DATA      1
#define HWAVBMTAG_SRCWIDTH  2
#define HWAVBMTAG_SRCHEIGHT 3
#define HWAVBMTAG_SCALEMODE 4
#define HWAVBMTAG_MATRIX2D  5
#define HWAVBMTAG_DISPLAY   6

/* capabilities for HWSDATAG_VIDEOBITMAPCAPS [V6.0] */
#define HWVBMCAPS_SCALE          0x00000001
#define HWVBMCAPS_TRANSFORM      0x00000002
#define HWVBMCAPS_OFFSCREENCOLOR 0x00000004
#define HWVBMCAPS_OFFSCREENALPHA 0x00000008
#define HWVBMCAPS_BLITTRANSFORM  0x00000010   // [V8.0]
#define HWVBMCAPS_BLITALPHAMOD   0x00000020   // [V8.0]

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/ReadVideoPixels() [V6.0] */
#define HWRVPTAG_BLEND       1
#define HWRVPTAG_PIXELFORMAT 2

/* methods for HWPLUG_CAPS_DISPLAYADAPTER/DoVideoBitMapMethod() [V6.0] */
#define HWVBMMTHD_SETBLEND 1

/* types for HWPLUG_CAPS_DISPLAYADAPTER/AllocBitMap() [V6.0] */
#define HWBMTYPE_RGB    0
#define HWBMTYPE_ALPHA  1
#define HWBMTYPE_MASK   2
#define HWBMTYPE_CLUT   3   // [V9.0]

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/AllocBitMap() [V6.0] */
#define HWABMFLAGS_CLEAR 0x00000001

/* tags for HWPLUG_CAPS_DISPLAYADAPTER/AllocBitMap() [V6.0] */
#define HWABMTAG_FRIENDBITMAP    1
#define HWABMTAG_DATA            2
#define HWABMTAG_DATABYTESPERROW 3

/* flags for HWPLUG_CAPS_DISPLAYADAPTER/LockBitMap() [V6.0] */
#define HWLBMFLAGS_READONLY 0x00000001

/* attributes for HWPLUG_CAPS_DISPLAYADAPTER/GetBitMapAttr() [V6.0] */
#define HWBMATTR_WIDTH       0
#define HWBMATTR_HEIGHT      1
#define HWBMATTR_BYTESPERROW 2

/* flags for struct hwIconList and hwIconEntry [V6.0] */
#define HWICONFLAGS_DEFAULT  0x00000001
#define HWICONFLAGS_SELECTED 0x00000002
#define HWICONFLAGS_OPAQUE   0x00000004   // V8.0
#define HWICONFLAGS_EXTENDED 0x00000008   // V9.0

/* flags for HWPLUG_CAPS_REQUESTERADAPTER/SystemRequest() [V6.0] */
/* all flags with xxxTYPE and xxxICON are mutually exclusive */
#define HWSYSREQTYPE_OK          0x00000001
#define HWSYSREQTYPE_OKCANCEL    0x00000002
#define HWSYSREQTYPE_YESNO       0x00000004
#define HWSYSREQTYPE_YESNOCANCEL 0x00000008
#define HWSYSREQTYPE_CUSTOM      0x00000010
#define HWSYSREQICON_NONE        0x00000020
#define HWSYSREQICON_INFORMATION 0x00000040
#define HWSYSREQICON_ERROR       0x00000080
#define HWSYSREQICON_WARNING     0x00000100
#define HWSYSREQICON_QUESTION    0x00000200

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/SystemRequest() [V6.0] */
#define HWSYSREQTAG_FROMSCRIPT   1
#define HWSYSREQTAG_CHOICES      2

/* flags for HWPLUG_CAPS_REQUESTERADAPTER/FileRequest() [V6.0] */
#define HWFILEREQFLAGS_MULTISELECT 0x00000001
#define HWFILEREQFLAGS_SAVEMODE    0x00000002

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/FileRequest() [V6.0] */
#define HWFILEREQTAG_FROMSCRIPT    1
#define HWFILEREQTAG_EXTENSIONS    2
#define HWFILEREQTAG_DEFDRAWER     3
#define HWFILEREQTAG_DEFFILE       4
#define HWFILEREQTAG_FILTERS       5   // V9.0

/* flags for HWFILEREQTAG_FILTERS [V9.0] */
#define HWFILEREQFILTERFLAGS_HIDE 0x00000001

/* flags for HWPLUG_CAPS_REQUESTERADAPTER/PathRequest() [V6.0] */
#define HWPATHREQFLAGS_SAVEMODE    0x00000001

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/PathRequest() [V6.0] */
#define HWPATHREQTAG_FROMSCRIPT    1
#define HWPATHREQTAG_DEFDRAWER     2

/* flags for HWPLUG_CAPS_REQUESTERADAPTER/StringRequest() [V6.0] */
/* all flags with xxxTYPE are mutually exclusive */
#define HWSTRINGREQTYPE_ALPHANUMERICAL 0x00000001
#define HWSTRINGREQTYPE_ALPHABETICAL   0x00000002
#define HWSTRINGREQTYPE_NUMERICAL      0x00000004
#define HWSTRINGREQTYPE_HEXANUMERICAL  0x00000008
#define HWSTRINGREQFLAGS_PASSWORD      0x00000010

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/StringRequest() [V6.0] */
#define HWSTRINGREQTAG_FROMSCRIPT  1
#define HWSTRINGREQTAG_DEFTEXT     2
#define HWSTRINGREQTAG_MAXCHARS    3

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/ListRequest() [V6.0] */
#define HWLISTREQTAG_FROMSCRIPT  1
#define HWLISTREQTAG_ACTIVE      2

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/ColorRequest() [V6.0] */
#define HWCOLORREQTAG_FROMSCRIPT  1
#define HWCOLORREQTAG_DEFCOLOR    2

/* tags for HWPLUG_CAPS_REQUESTERADAPTER/FontRequest() [V6.0] */
#define HWFONTREQTAG_FROMSCRIPT  1
#define HWFONTREQTAG_DEFFONT     2
#define HWFONTREQTAG_DEFSIZE     3

/* style flags to be set by HWPLUG_CAPS_REQUESTERADAPTER/FontRequest() [V6.0] */
/* all flags with xxxWEIGHT and xxxSLANT are mutually exclusive */
#define HWFONTREQWEIGHT_THIN       0x00000001
#define HWFONTREQWEIGHT_EXTRALIGHT 0x00000002
#define HWFONTREQWEIGHT_LIGHT      0x00000004
#define HWFONTREQWEIGHT_BOOK       0x00000008
#define HWFONTREQWEIGHT_NORMAL     0x00000010
#define HWFONTREQWEIGHT_MEDIUM     0x00000020
#define HWFONTREQWEIGHT_SEMIBOLD   0x00000040
#define HWFONTREQWEIGHT_BOLD       0x00000080
#define HWFONTREQWEIGHT_EXTRABOLD  0x00000100
#define HWFONTREQWEIGHT_BLACK      0x00000200
#define HWFONTREQWEIGHT_EXTRABLACK 0x00000400
#define HWFONTREQSLANT_ROMAN       0x00000800
#define HWFONTREQSLANT_ITALIC      0x00001000
#define HWFONTREQSLANT_OBLIQUE     0x00002000
#define HWFONTREQSTYLE_UNDERLINED  0x00004000
#define HWFONTREQSTYLE_STRIKEOUT   0x00008000
#define HWFONTREQSTYLE_BOLD        0x00010000
#define HWFONTREQSTYLE_ITALIC      0x00020000

/* types for HWPLUG_CAPS_REQUESTERADAPTER/FreeRequest() [V6.0] */
#define HWREQTYPE_FILE   0
#define HWREQTYPE_PATH   1
#define HWREQTYPE_STRING 2
#define HWREQTYPE_FONT   3

/* extensions for HWPLUG_CAPS_LIBRARY with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.0] */
#define HWEXT_LIBRARY_MULTIPLE    0x00000001
#define HWEXT_LIBRARY_NOAUTOINIT  0x00000002   // V6.1
#define HWEXT_LIBRARY_HELPSTRINGS 0x00000004   // V7.0
#define HWEXT_LIBRARY_UPVALUES    0x00000008   // V7.1

/* extensions for HWPLUG_CAPS_IMAGE with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.0] */
#define HWEXT_IMAGE_NOAUTOINIT 0x00000001
#define HWEXT_IMAGE_FORMATNAME 0x00000002  // V10.0

/* extensions for HWPLUG_CAPS_ANIM with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.0] */
#define HWEXT_ANIM_NOAUTOINIT 0x00000001
#define HWEXT_ANIM_VECTOR     0x00000002   // V9.0
#define HWEXT_ANIM_FORMATNAME 0x00000004   // V10.0

/* extensions for HWPLUG_CAPS_SOUND with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.0] */
#define HWEXT_SOUND_NOAUTOINIT 0x00000001

/* extensions for HWPLUG_CAPS_VECTOR with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.0] */
#define HWEXT_VECTOR_EXACTFIT   0x00000001
#define HWEXT_VECTOR_CUSTOMFT2  0x00000002   // V10.0

/* extensions for HWPLUG_CAPS_VIDEO with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.0] */
#define HWEXT_VIDEO_NOAUTOINIT 0x00000001

/* extensions for HWPLUG_CAPS_DISPLAYADAPTER with HWPLUG_CAPS_EXTENSION/GetExtensions() [V6.1] */
#define HWEXT_DISPLAYADAPTER_MAINLOOP    0x00000001
#define HWEXT_DISPLAYADAPTER_PALETTE     0x00000002   // V9.0
#define HWEXT_DISPLAYADAPTER_MENUADAPTER 0x00000004   // V9.0
#define HWEXT_DISPLAYADAPTER_TRAYICON    0x00000008   // V9.0
#define HWEXT_DISPLAYADAPTER_POPUPMENU   0x00000010   // V10.0

/* extensions for HWPLUG_CAPS_DIRADAPTER with HWPLUG_CAPS_EXTENSION/GetExtensions() [V8.0] */
#define HWEXT_DIRADAPTER_REWIND 0x00000001
#define HWEXT_DIRADAPTER_STAT   0x00000002

/* extensions for HWPLUG_CAPS_REQUIRE with HWPLUG_CAPS_EXTENSION/GetExtensions() [V9.0] */
#define HWEXT_REQUIRE_LUALESS 0x00000001

/* extensions for HWPLUG_CAPS_ICON with HWPLUG_CAPS_EXTENSION/GetExtensions() [V9.0] */
#define HWEXT_ICON_NOAUTOINIT 0x00000001
#define HWEXT_ICON_FORMATNAME 0x00000002   // V10.0

/* extensions for HWPLUG_CAPS_FONT with HWPLUG_CAPS_EXTENSION/GetExtensions() [V10.0] */
#define HWEXT_FONT_NOAUTOINIT 0x00000001

/* extensions for HWPLUG_CAPS_SAVEANIM with HWPLUG_CAPS_EXTENSION/GetExtensions() [V10.0] */
#define HWEXT_SAVEANIM_BEGINANIMSTREAM 0x00000001   // V10.0

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_FILEADAPTER [V6.0] */
#define HWCLAFAFLAGS_CHUNKLOADER 0x00000001
#define HWCLAFAFLAGS_MUSTREQUIRE 0x00000002   // V7.1

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_DIRADAPTER [V6.0] */
#define HWCLADAFLAGS_MUSTREQUIRE 0x00000001   // V7.1

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_IMAGE [V6.0] */
#define HWCLAIMGFLAGS_MUSTREQUIRE 0x00000001   // V7.1

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_ANIM [V6.0] */
#define HWCLAANMFLAGS_MUSTREQUIRE 0x00000001   // V7.1

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_SOUND [V6.0] */
#define HWCLASNDFLAGS_MUSTREQUIRE 0x00000001   // V7.1

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_VIDEO [V6.0] */
#define HWCLAVIDFLAGS_MUSTREQUIRE 0x00000001   // V7.1

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_NETWORKADAPTER [V8.0] */
#define HWCLANAFLAGS_MUSTREQUIRE  0x00000001   // V8.0

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_ICON [V9.0] */
#define HWCLAICONFLAGS_MUSTREQUIRE 0x00000001  // V9.0

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_FONT [V10.0] */
#define HWCLAFONTFLAGS_MUSTREQUIRE 0x00000001  // V10.0

/* flags for hw_ConfigureLoaderAdapter: HWPLUG_CAPS_FILESYSADAPTER [V10.0] */
#define HWCLAFSAFLAGS_MUSTREQUIRE 0x00000001   // V10.0

/* tags for and HWPLUG_CAPS_FILEADAPTER/FOpen() [A] and hw_FOpenExt() [B] [V6.0] */
#define HWFOPENTAG_FLAGS       1   // A (due to historical reasons 1 is used twice)
#define HWFOPENTAG_ADAPTER     1   // B (due to historical reasons 1 is used twice)
#define HWFOPENTAG_CHUNKFILE   2   // A
#define HWFOPENTAG_CHUNKOFFSET 3   // A
#define HWFOPENTAG_CHUNKLENGTH 4   // A
#define HWFOPENTAG_CHUNKMEMORY 5   // A
#define HWFOPENTAG_USERTAGS    6   // AB [V10.0]
#define HWFOPENTAG_FORMAT      7   // A  [V10.0]

/* flags for HWFOPENTAG_FLAGS [V6.0] */
#define HWFOPENFLAGS_STREAMING 0x00000001
#define HWFOPENFLAGS_NOSEEK    0x00000002
#define HWFOPENFLAGS_WONTSEEK  0x00000004   // V10.0

/* flags for hw_ChunkToFile() [V6.0] */
#define HWCTFFLAGS_MEMORYSOURCE 0x00000001

/* tags for hw_LoadImage() */
#define HWLDIMGTAG_USEARGB      1    // V6.1
#define HWLDIMGTAG_SCALE        2    // V8.0
#define HWLDIMGTAG_INTERPOLATE  3    // V8.0
#define HWLDIMGTAG_ADAPTER      4    // V9.0
#define HWLDIMGTAG_LOADER       5    // V9.0

/* key definitions - 0 to 255 are reserved for ISO-8859-1 charset */
#define HWKEY_CURSOR_UP     256
#define HWKEY_CURSOR_DOWN   257
#define HWKEY_CURSOR_RIGHT  258
#define HWKEY_CURSOR_LEFT   259
#define HWKEY_HELP          260
#define HWKEY_F1            261
#define HWKEY_F2            262
#define HWKEY_F3            263
#define HWKEY_F4            264
#define HWKEY_F5            265
#define HWKEY_F6            266
#define HWKEY_F7            267
#define HWKEY_F8            268
#define HWKEY_F9            269
#define HWKEY_F10           270
#define HWKEY_BACKSPACE     271
#define HWKEY_TAB           272
#define HWKEY_ENTER         273
#define HWKEY_RETURN        274
#define HWKEY_ESC           275
#define HWKEY_SPACE         276
#define HWKEY_DEL           277
#define HWKEY_F11           278
#define HWKEY_F12           279
#define HWKEY_INSERT        280
#define HWKEY_HOME          281
#define HWKEY_END           282
#define HWKEY_PAGEUP        283
#define HWKEY_PAGEDOWN      284
#define HWKEY_PRINT         285
#define HWKEY_PAUSE         286
#define HWKEY_F13           287
#define HWKEY_F14           288
#define HWKEY_F15           289
#define HWKEY_F16           290

/* NB: the following definitions are raw keys; only use them with HWSATEVT_RAWKEY and HWEVT_RAWKEY! */
#define HWKEY_NP0           291
#define HWKEY_NP1           292
#define HWKEY_NP2           293
#define HWKEY_NP3           294
#define HWKEY_NP4           295
#define HWKEY_NP5           296
#define HWKEY_NP6           297
#define HWKEY_NP7           298
#define HWKEY_NP8           299
#define HWKEY_NP9           300
#define HWKEY_NPMUL         301
#define HWKEY_NPADD         302
#define HWKEY_NPSUB         303
#define HWKEY_NPDEC         304
#define HWKEY_NPDIV         305
#define HWKEY_LSHIFT        306
#define HWKEY_RSHIFT        307
#define HWKEY_LALT          308
#define HWKEY_RALT          309
#define HWKEY_LCOMMAND      310
#define HWKEY_RCOMMAND      311
#define HWKEY_LCONTROL      312
#define HWKEY_RCONTROL      313

/* key qualifiers */
#define HWKEY_QUAL_MASK     0x80000000
#define HWKEY_QUAL_LSHIFT   0x80010000
#define HWKEY_QUAL_RSHIFT   0x80020000
#define HWKEY_QUAL_LALT     0x80040000
#define HWKEY_QUAL_RALT     0x80080000
#define HWKEY_QUAL_LCOMMAND 0x80100000
#define HWKEY_QUAL_RCOMMAND 0x80200000
#define HWKEY_QUAL_LCONTROL 0x80400000
#define HWKEY_QUAL_RCONTROL 0x80800000

/* string encodings */
#define HWOS_ENCODING_ISO8859_1 0
#define HWOS_ENCODING_UTF8      1
#define HWOS_ENCODING_AMIGA     2   // V7.0

/* file flags */
#define HWOS_FILEATTR_READ       0x00000001
#define HWOS_FILEATTR_WRITE      0x00000002
#define HWOS_FILEATTR_DELETE     0x00000004
#define HWOS_FILEATTR_EXECUTE    0x00000008
#define HWOS_FILEATTR_PURE       0x00000010
#define HWOS_FILEATTR_ARCHIVE    0x00000020
#define HWOS_FILEATTR_SCRIPT     0x00000040
#define HWOS_FILEATTR_HIDDEN     0x00000080
#define HWOS_FILEATTR_SYSTEM     0x00000100
#define HWOS_FILEATTR_READG      0x00000200
#define HWOS_FILEATTR_WRITEG     0x00000400
#define HWOS_FILEATTR_EXECUTEG   0x00000800
#define HWOS_FILEATTR_READO      0x00001000
#define HWOS_FILEATTR_WRITEO     0x00002000
#define HWOS_FILEATTR_EXECUTEO   0x00004000
#define HWOS_FILEATTR_READONLY   0x00008000
#define HWOS_FILEATTR_DIRECTORY  0x00020000

/* sample formats used by HWPLUG_CAPS_AUDIOADAPTER/AllocAudioChannel() [V6.0] */
#define HWSMPFMT_U8M  0
#define HWSMPFMT_U8S  1
#define HWSMPFMT_S8M  2
#define HWSMPFMT_S8S  3
#define HWSMPFMT_S16M 4
#define HWSMPFMT_S16S 5

/* tags for HWPLUG_CAPS_AUDIOADAPTER/SetChannelAttributes() [V6.0] */
#define HWSCATAG_VOLUME  1
#define HWSCATAG_PANNING 2
#define HWSCATAG_PITCH   3

/* tags for hw_GetEncoding() [V7.0] */
#define HWGENCTAG_STRING 1   // V9.0

/* types for hw_GetSystemPath() [V7.1] */
#define HWSYSPATH_PROGRAMNAME     0
#define HWSYSPATH_WINDOWS         1
#define HWSYSPATH_PROGRAMFILES    2
#define HWSYSPATH_APPDATA         3
#define HWSYSPATH_COMMONAPPDATA   4
#define HWSYSPATH_MYDOCUMENTS     5
#define HWSYSPATH_USERHOME        6
#define HWSYSPATH_USERNAME        7
#define HWSYSPATH_SDCARD          8
#define HWSYSPATH_EXTERNALSTORAGE 9
#define HWSYSPATH_INTERNALSTORAGE 10
#define HWSYSPATH_APPBUNDLE       11
#define HWSYSPATH_PREFERENCES     12
#define HWSYSPATH_TEMPFILES       13
#define HWSYSPATH_LOCALAPPDATA    14   // V9.0
#define HWSYSPATH_STARTPATH       15   // V9.0

/* tags for hw_TmpNamNew() [V7.1] */
#define HWTMPNAMTAG_USERAM 1

/* languages returned by hw_GetSystemLanguage() [V7.1] */
#define HWLANG_ENGLISH          0
#define HWLANG_GERMAN           1
#define HWLANG_DUTCH            2
#define HWLANG_ITALIAN          3
#define HWLANG_FRENCH           4
#define HWLANG_SPANISH          5
#define HWLANG_PORTUGUESE       6
#define HWLANG_SWEDISH          7
#define HWLANG_DANISH           8
#define HWLANG_FINNISH          9
#define HWLANG_NORWEGIAN        10
#define HWLANG_POLISH           11
#define HWLANG_HUNGARIAN        12
#define HWLANG_GREEK            13
#define HWLANG_CZECH            14
#define HWLANG_TURKISH          15
#define HWLANG_CROATIAN         16
#define HWLANG_RUSSIAN          17
#define HWLANG_UNKNOWN          18
#define HWLANG_ABKHAZIAN        19
#define HWLANG_AFAR             20
#define HWLANG_AFRIKAANS        21
#define HWLANG_AKAN             22
#define HWLANG_ALBANIAN         23
#define HWLANG_AMHARIC          24
#define HWLANG_ARABIC           25
#define HWLANG_ARAGONESE        26
#define HWLANG_ARMENIAN         27
#define HWLANG_ASSAMESE         28
#define HWLANG_AVARIC           29
#define HWLANG_AVESTAN          30
#define HWLANG_AYMARA           31
#define HWLANG_AZERBAIJANI      32
#define HWLANG_BAMBARA          33
#define HWLANG_BASHKIR          34
#define HWLANG_BASQUE           35
#define HWLANG_BELARUSIAN       36
#define HWLANG_BENGALI          37
#define HWLANG_BIHARI           38
#define HWLANG_BISLAMA          39
#define HWLANG_BOSNIAN          40
#define HWLANG_BRETON           41
#define HWLANG_BULGARIAN        42
#define HWLANG_BURMESE          43
#define HWLANG_CATALAN          44
#define HWLANG_CHAMORRO         45
#define HWLANG_CHECHEN          46
#define HWLANG_CHICHEWA         47
#define HWLANG_CHINESE          48
#define HWLANG_CHUVASH          49
#define HWLANG_CORNISH          50
#define HWLANG_CORSICAN         51
#define HWLANG_CREE             52
#define HWLANG_DIVEHI           53
#define HWLANG_DZONGKHA         54
#define HWLANG_ESPERANTO        55
#define HWLANG_ESTONIAN         56
#define HWLANG_EWE              57
#define HWLANG_FAROESE          58
#define HWLANG_FIJIAN           59
#define HWLANG_FULAH            60
#define HWLANG_GALICIAN         61
#define HWLANG_GEORGIAN         62
#define HWLANG_GREENLANDIC      63
#define HWLANG_GUARANI          64
#define HWLANG_GUJARATI         65
#define HWLANG_HAITIAN          66
#define HWLANG_HAUSA            67
#define HWLANG_HEBREW           68
#define HWLANG_HERERO           69
#define HWLANG_HINDI            70
#define HWLANG_HIRIMOTU         71
#define HWLANG_INTERLINGUA      72
#define HWLANG_INDONESIAN       73
#define HWLANG_INTERLINGUE      74
#define HWLANG_IRISH            75
#define HWLANG_IGBO             76
#define HWLANG_INUPIAQ          77
#define HWLANG_IDO              78
#define HWLANG_ICELANDIC        79
#define HWLANG_INUKTITUT        80
#define HWLANG_JAPANESE         81
#define HWLANG_JAVANESE         82
#define HWLANG_KANNADA          83
#define HWLANG_KANURI           84
#define HWLANG_KASHMIRI         85
#define HWLANG_KAZAKH           86
#define HWLANG_CENTRALKHMER     87
#define HWLANG_KIKUYU           88
#define HWLANG_KINYARWANDA      89
#define HWLANG_KIRGHIZ          90
#define HWLANG_KOMI             91
#define HWLANG_KONGO            92
#define HWLANG_KOREAN           93
#define HWLANG_KURDISH          94
#define HWLANG_KUANYAMA         95
#define HWLANG_LATIN            96
#define HWLANG_LUXEMBOURGISH    97
#define HWLANG_GANDA            98
#define HWLANG_LIMBURGAN        99
#define HWLANG_LINGALA          100
#define HWLANG_LAO              101
#define HWLANG_LITHUANIAN       102
#define HWLANG_LUBAKATANGA      103
#define HWLANG_LATVIAN          104
#define HWLANG_MANX             105
#define HWLANG_MACEDONIAN       106
#define HWLANG_MALAGASY         107
#define HWLANG_MALAY            108
#define HWLANG_MALAYALAM        109
#define HWLANG_MALTESE          110
#define HWLANG_MAORI            111
#define HWLANG_MARATHI          112
#define HWLANG_MARSHALLESE      113
#define HWLANG_MONGOLIAN        114
#define HWLANG_NAURU            115
#define HWLANG_NAVAJO           116
#define HWLANG_NORTHNDEBELE     117
#define HWLANG_NEPALI           118
#define HWLANG_NDONGA           119
#define HWLANG_NORWEGIANBOKMAL  120
#define HWLANG_NORWEGIANNYNORSK 121
#define HWLANG_SICHUANYI        122
#define HWLANG_SOUTHNDEBELE     123
#define HWLANG_OCCITAN          124
#define HWLANG_OJIBWA           125
#define HWLANG_CHURCHSLAVIC     126
#define HWLANG_OROMO            127
#define HWLANG_ORIYA            128
#define HWLANG_OSSETIAN         129
#define HWLANG_PANJABI          130
#define HWLANG_PALI             131
#define HWLANG_PERSIAN          132
#define HWLANG_PASHTO           133
#define HWLANG_QUECHUA          134
#define HWLANG_ROMANSH          135
#define HWLANG_RUNDI            136
#define HWLANG_ROMANIAN         137
#define HWLANG_SANSKRIT         138
#define HWLANG_SARDINIAN        139
#define HWLANG_SINDHI           140
#define HWLANG_NORTHERNSAMI     141
#define HWLANG_SAMOAN           142
#define HWLANG_SANGO            143
#define HWLANG_SERBIAN          144
#define HWLANG_GAELIC           145
#define HWLANG_SHONA            146
#define HWLANG_SINHALA          147
#define HWLANG_SLOVAK           148
#define HWLANG_SLOVENIAN        149
#define HWLANG_SOMALI           150
#define HWLANG_SOUTHERNSOTHO    151
#define HWLANG_SUNDANESE        152
#define HWLANG_SWAHILI          153
#define HWLANG_SWATI            154
#define HWLANG_TAMIL            155
#define HWLANG_TELUGU           156
#define HWLANG_TAJIK            157
#define HWLANG_THAI             158
#define HWLANG_TIGRINYA         159
#define HWLANG_TIBETAN          160
#define HWLANG_TURKMEN          161
#define HWLANG_TAGALOG          162
#define HWLANG_TSWANA           163
#define HWLANG_TONGA            164
#define HWLANG_TSONGA           165
#define HWLANG_TATAR            166
#define HWLANG_TWI              167
#define HWLANG_TAHITIAN         168
#define HWLANG_UIGHUR           169
#define HWLANG_UKRAINIAN        170
#define HWLANG_URDU             171
#define HWLANG_UZBEK            172
#define HWLANG_VENDA            173
#define HWLANG_VIETNAMESE       174
#define HWLANG_WALLOON          175
#define HWLANG_WELSH            176
#define HWLANG_WOLOF            177
#define HWLANG_WESTERNFRISIAN   178
#define HWLANG_XHOSA            179
#define HWLANG_YIDDISH          180
#define HWLANG_YORUBA           181
#define HWLANG_ZHUANG           182
#define HWLANG_ZULU             183

/* countries returned by hw_GetSystemCountry() [V7.1] */
#define HWCOUNTRY_UK                     0
#define HWCOUNTRY_USA                    1
#define HWCOUNTRY_AUSTRALIA              2
#define HWCOUNTRY_BELGIUM                3
#define HWCOUNTRY_BULGARIA               4
#define HWCOUNTRY_BRAZIL                 5
#define HWCOUNTRY_CANADA                 6
#define HWCOUNTRY_CZECHREPUBLIC          7
#define HWCOUNTRY_DENMARK                8
#define HWCOUNTRY_GERMANY                9
#define HWCOUNTRY_SPAIN                  10
#define HWCOUNTRY_FRANCE                 11
#define HWCOUNTRY_GREECE                 12
#define HWCOUNTRY_ITALY                  13
#define HWCOUNTRY_LIECHTENSTEIN          14
#define HWCOUNTRY_LITHUANIA              15
#define HWCOUNTRY_LUXEMBOURG             16
#define HWCOUNTRY_HUNGARY                17
#define HWCOUNTRY_MALTA                  18
#define HWCOUNTRY_MONACO                 19
#define HWCOUNTRY_NETHERLANDS            20
#define HWCOUNTRY_NORWAY                 21
#define HWCOUNTRY_POLAND                 22
#define HWCOUNTRY_PORTUGAL               23
#define HWCOUNTRY_ROMANIA                24
#define HWCOUNTRY_RUSSIA                 25
#define HWCOUNTRY_SANMARINO              26
#define HWCOUNTRY_SLOVAKIA               27
#define HWCOUNTRY_SLOVENIA               28
#define HWCOUNTRY_SWITZERLAND            29
#define HWCOUNTRY_FINLAND                30
#define HWCOUNTRY_SWEDEN                 31
#define HWCOUNTRY_TURKEY                 32
#define HWCOUNTRY_IRELAND                33
#define HWCOUNTRY_AUSTRIA                34
#define HWCOUNTRY_ICELAND                35
#define HWCOUNTRY_ANDORRA                36
#define HWCOUNTRY_UKRAINE                37
#define HWCOUNTRY_UNKNOWN                38
#define HWCOUNTRY_AFGHANISTAN            39
#define HWCOUNTRY_ALANDISLANDS           40
#define HWCOUNTRY_ALBANIA                41
#define HWCOUNTRY_ALGERIA                42
#define HWCOUNTRY_AMERICANSAMOA          43
#define HWCOUNTRY_ANGOLA                 44
#define HWCOUNTRY_ANGUILLA               45
#define HWCOUNTRY_ANTARCTICA             46
#define HWCOUNTRY_ANTIGUAANDBARBUDA      47
#define HWCOUNTRY_ARGENTINA              48
#define HWCOUNTRY_ARMENIA                49
#define HWCOUNTRY_ARUBA                  50
#define HWCOUNTRY_AZERBAIJAN             51
#define HWCOUNTRY_BAHAMAS                52
#define HWCOUNTRY_BAHRAIN                53
#define HWCOUNTRY_BANGLADESH             54
#define HWCOUNTRY_BARBADOS               55
#define HWCOUNTRY_BELARUS                56
#define HWCOUNTRY_BELIZE                 57
#define HWCOUNTRY_BENIN                  58
#define HWCOUNTRY_BERMUDA                59
#define HWCOUNTRY_BHUTAN                 60
#define HWCOUNTRY_BOLIVIA                61
#define HWCOUNTRY_BESISLANDS             62
#define HWCOUNTRY_BOSNIAANDHERZEGOVINA   63
#define HWCOUNTRY_BOTSWANA               64
#define HWCOUNTRY_BOUVETISLAND           65
#define HWCOUNTRY_BRUNEI                 66
#define HWCOUNTRY_BURKINAFASO            67
#define HWCOUNTRY_BURUNDI                68
#define HWCOUNTRY_CAMBODIA               69
#define HWCOUNTRY_CAMEROON               70
#define HWCOUNTRY_CAPEVERDE              71
#define HWCOUNTRY_CAYMANISLANDS          72
#define HWCOUNTRY_CENTRALAFRICANREPUBLIC 73
#define HWCOUNTRY_CHAD                   74
#define HWCOUNTRY_CHILE                  75
#define HWCOUNTRY_CHINA                  76
#define HWCOUNTRY_CHRISTMASISLAND        77
#define HWCOUNTRY_COCOSISLANDS           78
#define HWCOUNTRY_COLOMBIA               79
#define HWCOUNTRY_COMOROS                80
#define HWCOUNTRY_CONGO                  81
#define HWCOUNTRY_COOKISLANDS            82
#define HWCOUNTRY_COSTARICA              83
#define HWCOUNTRY_IVORYCOAST             84
#define HWCOUNTRY_CROATIA                85
#define HWCOUNTRY_CUBA                   86
#define HWCOUNTRY_CURACAO                87
#define HWCOUNTRY_CYPRUS                 88
#define HWCOUNTRY_DJIBOUTI               89
#define HWCOUNTRY_DOMINICA               90
#define HWCOUNTRY_DOMINICANREPUBLIC      91
#define HWCOUNTRY_DRCONGO                92
#define HWCOUNTRY_ECUADOR                93
#define HWCOUNTRY_EGYPT                  94
#define HWCOUNTRY_ELSALVADOR             95
#define HWCOUNTRY_EQUATORIALGUINEA       96
#define HWCOUNTRY_ERITREA                97
#define HWCOUNTRY_ESTONIA                98
#define HWCOUNTRY_ETHIOPIA               99
#define HWCOUNTRY_FALKLANDISLANDS        100
#define HWCOUNTRY_FAROEISLANDS           101
#define HWCOUNTRY_FIJI                   102
#define HWCOUNTRY_FRENCHGUIANA           103
#define HWCOUNTRY_FRENCHPOLYNESIA        104
#define HWCOUNTRY_GABON                  105
#define HWCOUNTRY_GAMBIA                 106
#define HWCOUNTRY_GEORGIA                107
#define HWCOUNTRY_GHANA                  108
#define HWCOUNTRY_GIBRALTAR              109
#define HWCOUNTRY_GREENLAND              110
#define HWCOUNTRY_GRENADA                111
#define HWCOUNTRY_GUADELOUPE             112
#define HWCOUNTRY_GUAM                   113
#define HWCOUNTRY_GUATEMALA              114
#define HWCOUNTRY_GUERNSEY               115
#define HWCOUNTRY_GUINEA                 116
#define HWCOUNTRY_GUINEABISSAU           117
#define HWCOUNTRY_GUYANA                 118
#define HWCOUNTRY_HAITI                  119
#define HWCOUNTRY_HOLYSEE                120
#define HWCOUNTRY_HONDURAS               121
#define HWCOUNTRY_HONGKONG               122
#define HWCOUNTRY_INDIA                  123
#define HWCOUNTRY_INDONESIA              124
#define HWCOUNTRY_IRAN                   125
#define HWCOUNTRY_IRAQ                   126
#define HWCOUNTRY_ISLEOFMAN              127
#define HWCOUNTRY_ISRAEL                 128
#define HWCOUNTRY_JAMAICA                129
#define HWCOUNTRY_JAPAN                  130
#define HWCOUNTRY_JERSEY                 131
#define HWCOUNTRY_JORDAN                 132
#define HWCOUNTRY_KAZAKHSTAN             133
#define HWCOUNTRY_KENYA                  134
#define HWCOUNTRY_KIRIBATI               135
#define HWCOUNTRY_NORTHKOREA             136
#define HWCOUNTRY_SOUTHKOREA             137
#define HWCOUNTRY_KUWAIT                 138
#define HWCOUNTRY_KYRGYZSTAN             139
#define HWCOUNTRY_LAOS                   140
#define HWCOUNTRY_LATVIA                 141
#define HWCOUNTRY_LEBANON                142
#define HWCOUNTRY_LESOTHO                143
#define HWCOUNTRY_LIBERIA                144
#define HWCOUNTRY_LIBYA                  145
#define HWCOUNTRY_MACAO                  146
#define HWCOUNTRY_MACEDONIA              147
#define HWCOUNTRY_MADAGASCAR             148
#define HWCOUNTRY_MALAWI                 149
#define HWCOUNTRY_MALAYSIA               150
#define HWCOUNTRY_MALDIVES               151
#define HWCOUNTRY_MALI                   152
#define HWCOUNTRY_MARSHALLISLANDS        153
#define HWCOUNTRY_MARTINIQUE             154
#define HWCOUNTRY_MAURITANIA             155
#define HWCOUNTRY_MAURITIUS              156
#define HWCOUNTRY_MAYOTTE                157
#define HWCOUNTRY_MEXICO                 158
#define HWCOUNTRY_MICRONESIA             159
#define HWCOUNTRY_MOLDOVA                160
#define HWCOUNTRY_MONGOLIA               161
#define HWCOUNTRY_MONTENEGRO             162
#define HWCOUNTRY_MONTSERRAT             163
#define HWCOUNTRY_MOROCCO                164
#define HWCOUNTRY_MOZAMBIQUE             165
#define HWCOUNTRY_MYANMAR                166
#define HWCOUNTRY_NAMIBIA                167
#define HWCOUNTRY_NAURU                  168
#define HWCOUNTRY_NEPAL                  169
#define HWCOUNTRY_NEWCALEDONIA           170
#define HWCOUNTRY_NEWZEALAND             171
#define HWCOUNTRY_NICARAGUA              172
#define HWCOUNTRY_NIGER                  173
#define HWCOUNTRY_NIGERIA                174
#define HWCOUNTRY_NIUE                   175
#define HWCOUNTRY_NORFOLKISLAND          176
#define HWCOUNTRY_OMAN                   177
#define HWCOUNTRY_PAKISTAN               178
#define HWCOUNTRY_PALAU                  179
#define HWCOUNTRY_PALESTINE              180
#define HWCOUNTRY_PANAMA                 181
#define HWCOUNTRY_PAPUANEWGUINEA         182
#define HWCOUNTRY_PARAGUAY               183
#define HWCOUNTRY_PERU                   184
#define HWCOUNTRY_PHILIPPINES            185
#define HWCOUNTRY_PITCAIRN               186
#define HWCOUNTRY_PUERTORICO             187
#define HWCOUNTRY_QATAR                  188
#define HWCOUNTRY_REUNION                189
#define HWCOUNTRY_RWANDA                 190
#define HWCOUNTRY_SAINTBARTHELEMY        191
#define HWCOUNTRY_SAINTHELENA            192
#define HWCOUNTRY_SAINTKITTSANDNEVIS     193
#define HWCOUNTRY_SAINTLUCIA             194
#define HWCOUNTRY_SAINTVINCENT           195
#define HWCOUNTRY_SAMOA                  196
#define HWCOUNTRY_SAOTOMEANDPRINCIPE     197
#define HWCOUNTRY_SAUDIARABIA            198
#define HWCOUNTRY_SENEGAL                199
#define HWCOUNTRY_SERBIA                 200
#define HWCOUNTRY_SEYCHELLES             201
#define HWCOUNTRY_SIERRALEONE            202
#define HWCOUNTRY_SINGAPORE              203
#define HWCOUNTRY_SOLOMONISLANDS         204
#define HWCOUNTRY_SOMALIA                205
#define HWCOUNTRY_SOUTHAFRICA            206
#define HWCOUNTRY_SOUTHSUDAN             207
#define HWCOUNTRY_SRILANKA               208
#define HWCOUNTRY_SUDAN                  209
#define HWCOUNTRY_SURINAME               210
#define HWCOUNTRY_SWAZILAND              211
#define HWCOUNTRY_SYRIA                  212
#define HWCOUNTRY_TAIWAN                 213
#define HWCOUNTRY_TAJIKISTAN             214
#define HWCOUNTRY_TANZANIA               215
#define HWCOUNTRY_THAILAND               216
#define HWCOUNTRY_TIMOR                  217
#define HWCOUNTRY_TOGO                   218
#define HWCOUNTRY_TONGA                  219
#define HWCOUNTRY_TRINIDADANDTOBAGO      220
#define HWCOUNTRY_TUNISIA                221
#define HWCOUNTRY_TURKMENISTAN           222
#define HWCOUNTRY_TUVALU                 223
#define HWCOUNTRY_UGANDA                 224
#define HWCOUNTRY_UAE                    225
#define HWCOUNTRY_URUGUAY                226
#define HWCOUNTRY_UZBEKISTAN             227
#define HWCOUNTRY_VANUATU                228
#define HWCOUNTRY_VENEZUELA              229
#define HWCOUNTRY_VIETNAM                230
#define HWCOUNTRY_YEMEN                  231
#define HWCOUNTRY_ZAMBIA                 232

/* Hollywood object types for hw_HaveObject() */
#define HWOBJ_BGPIC           1
#define HWOBJ_SAMPLE          2
#define HWOBJ_BRUSH           3
#define HWOBJ_ANIM            4
#define HWOBJ_SNDMODULE       5
#define HWOBJ_KEYDOWN         6
#define HWOBJ_NOOBJECT        7
#define HWOBJ_TEXTOBJECT      8
#define HWOBJ_TEXTOUT         9
#define HWOBJ_UNDO            10
#define HWOBJ_PRINT           11
#define HWOBJ_BRUSHPART       12
#define HWOBJ_BGPICPART       13
#define HWOBJ_BOX             14
#define HWOBJ_CIRCLE          15
#define HWOBJ_ELLIPSE         16
#define HWOBJ_LINE            17
#define HWOBJ_PLOT            18
#define HWOBJ_MAINWINDOW      19
#define HWOBJ_ANIMDISK        20
#define HWOBJ_DISPLAY         21
#define HWOBJ_LAYER           22
#define HWOBJ_HIDEBRUSH       23
#define HWOBJ_INSERTBRUSH     24
#define HWOBJ_HIDELAYER       25
#define HWOBJ_REMOVELAYER     26
#define HWOBJ_POLYGON         27
#define HWOBJ_MASK            28
#define HWOBJ_NEXTFRAME       29
#define HWOBJ_ALPHACHANNEL    30
#define HWOBJ_ARC             31
#define HWOBJ_SPRITE          32
#define HWOBJ_MUSIC           33
#define HWOBJ_NEXTFRAME2      34
#define HWOBJ_CLIPREGION      35
#define HWOBJ_POINTER         36
#define HWOBJ_ASYNCDRAW       37
#define HWOBJ_DOUBLEBUFFER    38
#define HWOBJ_MEMORY          39
#define HWOBJ_EVENTHANDLER    40
#define HWOBJ_INTERVAL        41
#define HWOBJ_TIMEOUT         42
#define HWOBJ_FONT            43
#define HWOBJ_FILE            44
#define HWOBJ_DIR             45
#define HWOBJ_BRUSH_VS_BOX    46
#define HWOBJ_LAYER_VS_BOX    47
#define HWOBJ_SPRITE_VS_BOX   48
#define HWOBJ_VECTORPATH      49
#define HWOBJ_VIDEO           50
#define HWOBJ_MOVELIST        51
#define HWOBJ_ANIMSTREAM      52
#define HWOBJ_TIMER           53
#define HWOBJ_CLIENT          54
#define HWOBJ_SERVER          55
#define HWOBJ_UDPOBJECT       56
#define HWOBJ_MENU            57
#define HWOBJ_SPRITE_VS_BRUSH 58
#define HWOBJ_ICON            59
#define HWOBJ_SERIAL          60
#define HWOBJ_ASYNCOBJ        61
#define HWOBJ_PALETTE         62
#define HWOBJ_MERGED          63

/* flags for hw_GetIconForDensity() [V8.0] */
#define HWGIFDFLAGS_SELECTED    0x00000001
#define HWGIFDFLAGS_NOSCALE     0x00000002
#define HWGIFDFLAGS_MUSTMATCH   0x00000004
#define HWGIFDFLAGS_INTERPOLATE 0x00000008

/* tags for hw_ChangeRootDisplaySize() [V8.0] */
#define HWCRDSTAG_SCALEWIDTH  1
#define HWCRDSTAG_SCALEHEIGHT 2

/* tags for HWPLUG_CAPS_NETWORKADAPTER/OpenConnection() [V8.0] */
#define HWOPENCONNTAG_SSL             1
#define HWOPENCONNTAG_TIMEOUT         2
#define HWOPENCONNTAG_URL             3   // V9.0
#define HWOPENCONNTAG_CUSTOMPROTOCOL  4   // V9.0
#define HWOPENCONNTAG_UPLOAD          5   // V9.0
#define HWOPENCONNTAG_UPLOADSIZE      6   // V9.0
#define HWOPENCONNTAG_USERNAME        7   // V9.0
#define HWOPENCONNTAG_PASSWORD        8   // V9.0
#define HWOPENCONNTAG_FOLLOWLOCATION  9   // V9.0
#define HWOPENCONNTAG_TEXTMODE       10   // V9.0
#define HWOPENCONNTAG_MULTIPART      11   // V9.0
#define HWOPENCONNTAG_PROXY          12   // V9.0
#define HWOPENCONNTAG_USERAGENT      13   // V9.0
#define HWOPENCONNTAG_CUSTOMHEADERS  14   // V9.0
#define HWOPENCONNTAG_VERBOSE        15   // V9.0
#define HWOPENCONNTAG_POST           16   // V9.0
#define HWOPENCONNTAG_POSTSIZE       17   // V9.0
#define HWOPENCONNTAG_POSTTYPE       18   // V9.0
#define HWOPENCONNTAG_FAILONERROR    19   // V9.1
#define HWOPENCONNTAG_ENCODED        20   // V9.1
#define HWOPENCONNTAG_USERTAGS       21   // V10.0
	
/* tags for HWPLUG_CAPS_NETWORKADAPTER/GetConnectionInfo() [V8.0] */
#define HWCONNINFOTAG_LOCALIP       1
#define HWCONNINFOTAG_LOCALPORT     2
#define HWCONNINFOTAG_REMOTEIP      3
#define HWCONNINFOTAG_REMOTEPORT    4
#define HWCONNINFOTAG_DOWNLOADSIZE  5   // V9.0
#define HWCONNINFOTAG_DOWNLOADCOUNT 6   // V9.0
#define HWCONNINFOTAG_UPLOADSIZE    7   // V9.0
#define HWCONNINFOTAG_UPLOADCOUNT   8   // V9.0

/* tags for HWPLUG_CAPS_SERIALIZE/InitSerializer() [V9.0] */
#define HWISZTAG_SRCENCODING    1
#define HWISZTAG_DSTENCODING    2
#define HWISZTAG_USERTAGS       3   // V10.0
#define HWISZTAG_SERIALIZEMODE  4   // V10.0
#define HWISZTAG_SERIALIZEOPTS  5   // V10.0

/* types for HWPLUG_CAPS_SERIALIZE/SerializeItem() [V9.0] */
#define HWSERIALIZETYPE_DOUBLE   0
#define HWSERIALIZETYPE_STRING   1
#define HWSERIALIZETYPE_TABLE    2
#define HWSERIALIZETYPE_FUNCTION 3

/* flags for hwSerializeItemInfo [V9.0] */
#define HWSERIALIZEFLAGS_SPARSE  0x00000001
#define HWSERIALIZEFLAGS_BINARY  0x00000002
#define HWSERIALIZEFLAGS_NUMIDX  0x00000004   // V10.0
#define HWSERIALIZEFLAGS_STRIDX  0x00000008   // V10.0
#define HWSERIALIZEFLAGS_KEYVAL  0x00000010   // V10.0

/* tags for HWPLUG_CAPS_ICON/LoadIcon() [V9.0] */
#define HWLDICONTAG_ADAPTER  1
#define HWLDICONTAG_AMIGAEXT 2
#define HWLDICONTAG_USERTAGS 3   // V10.0

/* flags for struct hwIconAmigaExt [V9.0] */
#define HWAMIGAICONFLAGS_VIEWALL 0x00000001

/* Use this to indicate that there is no transparent pen */
#define HWPEN_NONE 0xFFFFFFFF

/* tags for hw_GetIconImages() [V9.0] */
#define HWGIITAG_PALETTE 1

/* capabilities for SaveIconReg [V9.0] */
#define HWSAVEICNCAPS_MORE   0x00000001

/* tags for HWPLUG_CAPS_SAVEICON/SaveIcon() [V9.0] */
#define HWSVICONTAG_FORMAT      1
#define HWSVICONTAG_COMPRESSION 2
#define HWSVICONTAG_AMIGAEXT    3
#define HWSVICONTAG_ADAPTER     4   // V10.0
#define HWSVICONTAG_USERTAGS    5   // V10.0

/* Amiga icon types [V9.0] */
#define HWAMIGAICON_NONE      0
#define HWAMIGAICON_DISK      1
#define HWAMIGAICON_DRAWER    2
#define HWAMIGAICON_TOOL      3
#define HWAMIGAICON_PROJECT   4
#define HWAMIGAICON_GARBAGE   5
#define HWAMIGAICON_DEVICE    6
#define HWAMIGAICON_KICKSTART 7
#define HWAMIGAICON_MAX       8

/* Amiga icon view modes [V9.0] */
#define HWAMIGAICONMODE_NONE  0
#define HWAMIGAICONMODE_ICONS 1
#define HWAMIGAICONMODE_NAME  2
#define HWAMIGAICONMODE_DATE  3
#define HWAMIGAICONMODE_SIZE  4
#define HWAMIGAICONMODE_TYPE  5
#define HWAMIGAICONMODE_MAX   6

/* tags for hw_SaveImage() [V9.0] */
#define HWSVIMGTAG_QUALITY      1
#define HWSVIMGTAG_DEPTH        2
#define HWSVIMGTAG_PALETTE      3
#define HWSVIMGTAG_TRANSPEN     4
#define HWSVIMGTAG_ADAPTER      5   // V10.0
#define HWSVIMGTAG_USERTAGS     6   // V10.0

/* formats for hw_SaveImage() [V9.0] */
#define HWIMGFMT_BMP  0
#define HWIMGFMT_PNG  1
#define HWIMGFMT_JPEG 2
#define HWIMGFMT_GIF  3
#define HWIMGFMT_ILBM 4

/* tags for hw_Remap() [V9.0] */
#define HWREMAPTAG_ALPHATHRESHOLD 1

/* flags for hw_Remap() [V9.0] */
#define HWREMAPFLAGS_DITHER      0x00000001
#define HWREMAPFLAGS_MAKEPALETTE 0x00000002

/* tags for ChangeBufferSize() [V9.0] */
#define HWCBSTAG_DEPTH 1

/* menu item flags [V9.0] */
#define HWMENUFLAGS_TOGGLE   0x00000001
#define HWMENUFLAGS_SELECTED 0x00000002
#define HWMENUFLAGS_DISABLED 0x00000004
#define HWMENUFLAGS_RADIO    0x00000008

/* flags for hw_SetIPCAdapter() [V9.0] */
#define HWSIAFLAGS_PERMANENT        0x00000001

/* tags for SetTrayIcon() [V9.0] */
#define HWSTITAG_TOOLTIP 1

/* anim types for LoadAnimCtrl [V9.0] */
#define HWANIMTYPE_RASTER 0
#define HWANIMTYPE_VECTOR 1

/* tags for hw_ConvertString() [V9.0] */
#define HWCSTAG_LENGTH 1

/* flags for HWPLUG_CAPS_FONT/LoadFont() [V10.0] */ 
#define HWFONTFLAGS_VECTOR    0x00000001
#define HWFONTFLAGS_USEPOINTS 0x00000002
#define HWFONTFLAGS_ANTIALIAS 0x00000004
#define HWFONTFLAGS_NOFILE    0x00000008
#define HWFONTFLAGS_LAYOUT    0x00000010

/* tags for HWPLUG_CAPS_FONT/MeasureText() and RenderText() [V10.0] */
#define HWTEXTTAG_LAYOUT    1

/* font styles */
#define HWFONTSTYLE_ANTIALIAS  0x00000001
#define HWFONTSTYLE_BOLD       0x00000002
#define HWFONTSTYLE_ITALIC     0x00000004
#define HWFONTSTYLE_UNDERLINED 0x00000008

/* text align */
#define HWTEXTALIGN_LEFT      0
#define HWTEXTALIGN_RIGHT     1
#define HWTEXTALIGN_CENTER    2
#define HWTEXTALIGN_JUSTIFIED 3

/* tags for HWPLUG_CAPS_FONT/SetFontScale() [V10.0] */
#define HWFONTSCALETAG_HEIGHT   1
#define HWFONTSCALETAG_BASELINE 2

/* tags for HWPLUG_CAPS_SAVEANIM/BeginAnimStreamExt() [V10.0] */
#define HWBASTAG_FORMAT   1
#define HWBASTAG_ADAPTER  2
#define HWBASTAG_USERTAGS 3

/* tags for HWPLUG_CAPS_DIRADAPTER/OpenDir() [V10.0] */
#define HWOPENDIRTAG_USERTAGS 1
#define HWOPENDIRTAG_FORMAT   2

/* tags for HWPLUG_CAPS_FILESYSADAPTER/ChangeDir() [V10.0] */
#define HWCHANGEDIRTAG_USERTAGS 1

/* tags for HWPLUG_CAPS_FILESYSADAPTER/MakeDir() [V10.0] */
#define HWMAKEDIRTAG_USERTAGS 1

/* tags for HWPLUG_CAPS_FILESYSADAPTER/DeleteFSObj() [V10.0] */
#define HWDELETEFSOBJTAG_USERTAGS 1

/* tags for HWPLUG_CAPS_FILESYSADAPTER/RenameFSObj() [V10.0] */
#define HWRENAMEFSOBJTAG_USERTAGS 1

/* tags for HWPLUG_CAPS_FILESYSADAPTER/MoveFSObj() [V10.0] */
#define HWMOVEFSOBJTAG_USERTAGS 1

/* tags for HWPLUG_CAPS_FILESYSADAPTER/SetFSObjAttributes() [V10.0] */
#define HWSETFSOATAG_USERTAGS 1

/* tags for HWPLUG_CAPS_FILESYSADAPTER/GetCurDir() [V10.0] */
#define HWGETCURDIRTAG_USERTAGS 1

/* flags for HWPLUG_CAPS_FILESYSADAPTER/SetFSObjAttributes() [V10.0] */
#define HWSETFSOATTR_FLAGS   0x00000001
#define HWSETFSOATTR_TIME    0x00000002
#define HWSETFSOATTR_COMMENT 0x00000004

/* serialize modes for HWISZTAG_SERIALIZEMODE [V10.0] */
#define HWSERIALIZEMODE_HOLLYWOOD 0
#define HWSERIALIZEMODE_NAMED     1
#define HWSERIALIZEMODE_LIST      2

/* serialize flags fow HWISZTAG_SERIALIZEOPTS [V10.0] */
#define HWSERIALIZEOPTS_NOLOWERCASE 0x00000001

#define HWUSERATTR          32768

typedef void (*LuaGateErrFunc) (APTR gate, lua_State *L, int error, APTR userdata);

typedef struct _hwAmigaEntry
{
	ULONG MagicCookie[2];
	int Platform;
	void *(*GetProcAddress)(STRPTR name);
} hwAmigaEntry;

typedef struct _hwPluginBase
{
	ULONG CapsMask;
	int Version;
	int Revision;		
	int hwVersion;
	int hwRevision;
	STRPTR Name;
	STRPTR ModuleName;	
	STRPTR Author;
	STRPTR Description;
	STRPTR Copyright;
	STRPTR URL;
	STRPTR Date;
	STRPTR Settings;
	STRPTR HelpFile;
} hwPluginBase;

struct hwPluginList
{
	struct hwPluginList *Succ;
	hwPluginBase *Plugin;
};

typedef struct _hwCRTBase
{
	void *(*malloc)(size_t size);
	void *(*calloc)(size_t num, size_t size);
	void *(*realloc)(void *ptr, size_t size);
	void (*free)(void *ptr);
	char *(*strdup)(const char *str);
	FILE *(*fopen)(char *filename, char *modes);
	int (*fclose)(FILE *stream);
	int (*fseek)(FILE *fp, long offset, int how);
	long (*ftell)(FILE *fp);
	size_t (*fread)(void *buf, size_t objsize, size_t nobjs, FILE *fp);
	size_t (*fwrite)(const void *buf, size_t objsize, size_t nobjs, FILE *fp);
	int (*fgetc)(FILE *fp);
	int (*fputc)(int c, FILE *fp);
	int (*ferror)(FILE *fp);
	int (*feof)(FILE *fp);
	int (*vfprintf)(FILE *fp, char *fmt, va_list argvect);
	int (*vsnprintf)(char *buffer, size_t count, const char *format, va_list argptr);
	int (*vprintf)(const char *fmt, va_list argptr);
	void (*qsort)(void *array, size_t num, size_t size, int (*cmpfunc)(const void *arg1, const void *arg2));
	int (*vsscanf)(const char *s, const char *ctrl, va_list argptr);
	double (*strtod)(const char *s, char **tp);
	long (*strtol)(const char *nptr, char **endptr, int base);
	unsigned long (*strtoul)(const char *nptr, char **endptr, int base);
	int (*stricmp)(const char *s1, const char *s2);
	int (*strnicmp)(const char *s1, const char *s2, size_t n);
	int (*tolower)(int c);
	int (*toupper)(int c);
	char *(*strtolwr)(char *s);
	char *(*strtoupr)(char *s);
	int (*gettimeofday)(void *tv, void *restrict);
	time_t (*time)(time_t *t);
	long int (*lrint)(double x);

	/****** V6.0 vectors start here *****/
	struct hwcrt_tm *(*localtime)(const time_t *t);
	struct hwcrt_tm *(*gmtime)(const time_t *t);
	char *(*asctime)(const struct hwcrt_tm *t);
	char *(*ctime)(const time_t *t);
	time_t (*mktime)(struct hwcrt_tm *timeptr);
	size_t (*strftime)(char *s, size_t maxsize, const char *format, const struct hwcrt_tm *timeptr);
	clock_t (*clock)(void);
	void (*difftime)(time_t a, time_t b, double *diff);
	void (*clearerr)(FILE *fp);
	int (*fileno)(FILE *fp);
	int (*fflush)(FILE *fp);
	int (*fstat)(int fd, struct hwcrt_stat *stat_buf);
	int (*stat)(const char *name, struct hwcrt_stat *stat_buf);
	int (*vfscanf)(FILE *fp, const char *fmt, va_list argptr);
	int (*ungetc)(int c, FILE *fp);
	int (*rename)(const char *old, const char *nnew);
	int (*remove)(const char *name);
	int (*geterrno)(void);
	void (*seterrno)(int e);

	/****** V7.1 vectors start here *****/	
	char *(*strerror)(int errnum);	
	FILE *(*getstdin)(void);
	FILE *(*getstdout)(void);
	FILE *(*getstderr)(void);
	int *(*geterrnoptr)(void);
	int (*fputs)(const char *str, FILE *fp);
	char *(*fgets)(char *str, int num, FILE *fp);
	
	/****** V9.0 vectors start here *****/		
	void (*dtostr)(double x, char *buf);
} hwCRTBase;

typedef struct _hwSysBase
{
	int (*hw_MasterControl)(struct hwTagList *tags);
	int (*hw_RegisterError)(STRPTR msg);
	void (*hw_SetErrorString)(STRPTR s);
	void (*hw_SetErrorCode)(int c);
	void (*hw_GetErrorName)(int error, STRPTR buf, int size);
	void (*hw_GetSysTime)(struct hwos_TimeVal *tv);
	void (*hw_SubTime)(struct hwos_TimeVal *dest, struct hwos_TimeVal *src);
	void (*hw_AddTime)(struct hwos_TimeVal *dest, struct hwos_TimeVal *src);
	int (*hw_CmpTime)(struct hwos_TimeVal *t1, struct hwos_TimeVal *t2);
	void (*hw_Delay)(int time);
	void (*hw_GetDate)(STRPTR buf);
	APTR (*hw_TrackedAlloc)(int size, ULONG flags, STRPTR name);
	void (*hw_TrackedFree)(APTR blk);

	/****** V5.2 vectors start here *****/
	APTR (*hw_RegisterCallback)(int type, APTR func, APTR userdata);
	int (*hw_RegisterEventHandler)(STRPTR name, void (*evtfunc)(lua_State *L, int type, APTR userdata));
	void (*hw_PostEvent)(int type, APTR userdata);
	void (*hw_PostSatelliteEvent)(APTR handle, int type, APTR typedata);
	
	/****** V5.3 vectors start here *****/	
	int (*hw_RegisterUserObject)(lua_State *L, STRPTR name, struct hwObjectList **list, int (*attrfunc)(lua_State *L, int attr, lua_ID *id));
	void (*hw_FreeObjectData)(lua_State *L, struct hwObjectList *item);
	int (*hw_RegisterFileType)(hwPluginBase *self, int type, STRPTR name, STRPTR mime, STRPTR ext, ULONG formatid, ULONG flags);
	
	/****** V6.0 vectors start here *****/	
	int (*hw_MasterServer)(lua_State *L, ULONG flags, struct hwTagList *tags);		
	APTR (*hw_CreateLuaGate)(ULONG flags, APTR data, int (*f)(APTR gate, lua_State *L, APTR f, APTR userdata), LuaGateErrFunc errfunc, APTR userdata);
	void (*hw_FreeLuaGate)(APTR gate);
	int (*hw_RegisterLuaGateFunction)(APTR gate, int (*f)(lua_State *L));
	void (*hw_SetLuaGateErrorFunction)(APTR gate, LuaGateErrFunc errfunc);
	LuaGateErrFunc (*hw_GetLuaGateErrorFunction)(APTR gate);
	void (*hw_DisableLuaGate)(APTR gate, int disable);
	int (*hw_PostEventEx)(lua_State *L, int type, APTR userdata, struct hwTagList *tags);	
	int (*hw_HandleEvents)(lua_State *L, ULONG flags, int *quit);
	int (*hw_WaitEvents)(lua_State *L, ULONG flags);	
	APTR (*hw_AllocSemaphore)(void);
	void (*hw_FreeSemaphore)(APTR sem);
	void (*hw_LockSemaphore)(APTR sem);
	void (*hw_UnLockSemaphore)(APTR sem);
	void (*hw_DisableCallback)(APTR handle, int disable);
	void (*hw_UnregisterCallback)(APTR handle);
	int (*hw_RegisterEventHandlerEx)(STRPTR name, int type, APTR data);	
	void (*hw_LogPrintF)(const char *fmt, va_list argptr);
	int (*hw_RunTimerCallback)(lua_State *L, APTR handle);
	int (*hw_SetTimerAdapter)(hwPluginBase *self, ULONG flags, struct hwTagList *tags);	
	void (*hw_GetDateStamp)(struct hwos_DateStruct *stamp);
	STRPTR (*hw_ConvertString)(STRPTR in, int infmt, int outfmt, struct hwTagList *tags);
	void (*hw_FreeString)(STRPTR s);
	int (*hw_AddLoaderAdapter)(hwPluginBase *self, ULONG type);	
	void (*hw_RemoveLoaderAdapter)(hwPluginBase *self, ULONG type);
	int (*hw_ConfigureLoaderAdapter)(hwPluginBase *self, ULONG type, ULONG flags, struct hwTagList *tags);	

	/****** V6.1 vectors start here *****/		
	int (*hw_RunEventCallback)(lua_State *L, int type, APTR userdata);	
	int (*hw_GetVMErrorInfo)(lua_State *L, struct hwGVMErrorInfo *vme, struct hwTagList *tags);	
	int (*hw_GetEventHandler)(STRPTR name, struct hwTagList *tags);
	
	/****** V7.0 vectors start here *****/		
	int (*hw_GetEncoding)(struct hwTagList *tags);
	int (*hw_RaiseOnError)(lua_State *L, int error, struct hwTagList *tags);
	int (*hw_CompareString)(STRPTR s1, STRPTR s2, ULONG flags, struct hwTagList *tags);
	
	/****** V7.1 vectors start here *****/		
	int (*hw_StrongRandom)(APTR buf, int len, struct hwTagList *tags);
	int (*hw_GetSystemPath)(int type, STRPTR buf, int len, struct hwTagList *tags);
	
	/****** V8.0 vectors start here *****/		
	int (*hw_HaveObject)(int type, lua_ID *id, struct hwTagList *tags);
	
	/****** V9.0 vectors start here *****/		
	void (*hw_UnregisterEventHandler)(int handler);
	int (*hw_SetIPCAdapter)(hwPluginBase *self, ULONG flags, struct hwTagList *tags);		
} hwSysBase;

typedef struct _hwDOSBase
{
	APTR (*hw_FOpen)(STRPTR name, int mode);
	int (*hw_FClose)(APTR fh);
	ULONG (*hw_FSeek)(APTR fh, ULONG pos, int mode);
	int (*hw_FRead)(APTR fh, APTR block, ULONG blocklen);
	int (*hw_FWrite)(APTR fh, APTR block, ULONG blocklen);
	int (*hw_FGetC)(APTR fh);
	int (*hw_FPutC)(APTR fh, int ch);
	int (*hw_FEof)(APTR fh);
	int (*hw_DeleteFile)(STRPTR name);
	APTR (*hw_Lock)(STRPTR name, int mode);
	void (*hw_UnLock)(APTR lock);
	int (*hw_NameFromLock)(APTR lock, STRPTR str, int len);
	int (*hw_ExLock)(APTR lock, struct hwos_ExLockStruct *exlock);
	int (*hw_BeginDirScan)(APTR lock, APTR *userdata);
	void (*hw_EndDirScan)(APTR userdata);
	int (*hw_NextDirEntry)(APTR lock, APTR userdata, struct hwos_ExLockStruct *exlock);
	int (*hw_CreateDir)(STRPTR name);
	int (*hw_Rename)(STRPTR oldname, STRPTR newname);
	void (*hw_GetCurrentDir)(STRPTR buf, int len);
	void (*hw_TmpNam)(STRPTR buf);
 	int (*hw_AddPart)(STRPTR dirname, STRPTR filename, int size);
	STRPTR (*hw_PathPart)(STRPTR pathname);
	STRPTR (*hw_FilePart)(STRPTR name);

	/****** V5.3 vectors start here *****/
	int (*hw_TranslateFileName)(STRPTR name, STRPTR buf, int bufsize, ULONG *offset, ULONG *size);
	
	/****** V6.0 vectors start here *****/	
	int (*hw_Stat)(STRPTR name, ULONG flags, struct hwos_StatStruct *st, struct hwTagList *tags);
	DOSINT64 (*hw_FSeek64)(APTR fh, DOSINT64 pos, int mode);	
	ULONG (*hw_FFlags)(APTR fh);
	int (*hw_FStat)(APTR fh, ULONG flags, struct hwos_StatStruct *st, struct hwTagList *tags);
	int (*hw_ChunkToFile)(STRPTR dest, APTR src, DOSINT64 pos, DOSINT64 len, ULONG flags, struct hwTagList *tags);
	int (*hw_TranslateFileNameExt)(STRPTR name, struct hwTranslateFileInfo *tf, struct hwTagList *tags);
	int (*hw_FFlush)(APTR fh);
	void (*hw_TmpNamExt)(STRPTR buf, int useram);
	APTR (*hw_FOpenExt)(STRPTR name, int mode, struct hwTagList *tags);	
	
	/****** V7.1 vectors start here *****/		
	int (*hw_AddDeleteFile)(STRPTR name, struct hwTagList *tags);
	int (*hw_MakeVirtualFile)(STRPTR dest, int len, struct hwMakeVFileInfo *mvf, struct hwTagList *tags);
	int (*hw_TmpNamNew)(STRPTR buf, int bufsize, struct hwTagList *tags);
	
	/****** V9.0 vectors start here *****/		
	APTR (*hw_CreateVirtualWriteFile)(STRPTR buf, int bufsize, struct hwTagList *tags);
	APTR (*hw_GetVirtualWriteFileBuffer)(APTR handle, ULONG *size, struct hwTagList *tags);
	void (*hw_FreeVirtualWriteFile)(APTR handle);
} hwDOSBase;

typedef struct _hwGfxBase
{
	int (*hw_IsImage)(STRPTR filename, int *retwidth, int *retheight, int *retalphachannel);
	APTR (*hw_LoadImage)(STRPTR filename, struct hwTagList *tags, int *retwidth, int *retheight, int *retalphachannel);
	ULONG *(*hw_GetImageData)(APTR handle);
	void (*hw_FreeImage)(APTR handle);
	APTR (*hw_LockBrush)(lua_ID *id, struct hwTagList *tags, struct hwos_LockBrushStruct *brlock);
	void (*hw_UnLockBrush)(APTR lock);

	/****** V5.2 vectors start here *****/
	ULONG *(*hw_GetARGBBrush)(lua_ID *id, struct hwTagList *tags);
	void (*hw_FreeARGBBrush)(ULONG *buffer);
	APTR (*hw_AttachDisplaySatellite)(lua_ID *id, int (*dispatcher)(APTR handle, int op, APTR opdata, APTR userdata), APTR userdata, struct hwTagList *tags);
	void (*hw_DetachDisplaySatellite)(APTR handle);
	void (*hw_RefreshSatelliteRoot)(APTR handle);
	int (*hw_ChangeRootDisplaySize)(APTR handle, int width, int height, struct hwTagList *tags);
	
	/****** V5.3 vectors start here *****/
	int (*hw_AddBrush)(lua_State *L, lua_ID *id, int width, int height, struct hwAddBrush *ctrl);	
	
	/****** V6.0 vectors start here *****/	
	int (*hw_SetDisplayAdapter)(hwPluginBase *self, ULONG flags, struct hwTagList *tags);
	struct hwIconList *(*hw_GetIcons)(void);
	void (*hw_FreeIcons)(struct hwIconList *iconlist);
	APTR (*hw_LockBitMap)(APTR bmap, ULONG flags, struct hwos_LockBitMapStruct *bmlock, struct hwTagList *tags);
	void (*hw_UnLockBitMap)(APTR lock);
	int (*hw_GetDisplayAttr)(APTR handle, struct hwTagList *tags);
	int (*hw_RefreshDisplay)(APTR handle, ULONG flags, struct hwTagList *tags);
	APTR (*hw_FindDisplay)(lua_ID *id, APTR handle);
	void (*hw_RawBltBitMap)(APTR src, APTR dst, struct hwRawBltBitMapCtrl *ctrl, ULONG flags, struct hwTagList *tags);	
	void (*hw_RawRectFill)(APTR dst, int x, int y, int width, int height, ULONG color, ULONG flags, struct hwTagList *tags);	
	void (*hw_RawWritePixel)(APTR dst, int x, int y, ULONG color, ULONG flags, struct hwTagList *tags);	
	void (*hw_RawLine)(APTR dst, int x1, int y1, int x2, int y2, ULONG color, ULONG flags, struct hwTagList *tags);
	ULONG *(*hw_BitMapToARGB)(APTR bmap, APTR mask, APTR alpha, struct hwTagList *tags);
	int (*hw_GetBitMapAttr)(APTR handle, int attr, struct hwTagList *tags);	
	ULONG (*hw_MapRGB)(ULONG color, int outfmt);
	ULONG (*hw_GetRGB)(ULONG color, int infmt);	
	
	/****** V6.1 vectors start here *****/		
	int (*hw_FreeBrush)(lua_State *L, lua_ID *id);
	
	/****** V7.1 vectors start here *****/	
	APTR (*hw_FindBrush)(lua_ID *id, APTR handle);	
	void (*hw_RawPolyFill)(APTR dst, struct hwVertex *v, int n, ULONG color, ULONG flags, struct hwTagList *tags);
	
	/****** V8.0 vectors start here *****/		
	struct hwIconList *(*hw_GetIconImages)(lua_ID *id, struct hwTagList *tags);	
	struct hwIconEntry *(*hw_GetIconForDensity)(lua_ID *id, double *density, ULONG flags, struct hwTagList *tags);
	void (*hw_FreeIcon)(struct hwIconEntry *icon);
	int (*hw_RawScale)(APTR src, APTR dst, struct hwRawScaleCtrl *ctrl, ULONG flags, struct hwTagList *tags);
	
	/****** V9.0 vectors start here *****/		
	int (*hw_SaveImage)(STRPTR filename, APTR data, int width, int height, ULONG fmt, ULONG flags, struct hwTagList *tags);
	int (*hw_Remap)(APTR src, UBYTE *dst, struct hwRemapCtrl *ctrl, ULONG flags, struct hwTagList *tags);
	
	/****** V9.1 vectors start here *****/		
	int (*hw_MapCoordinate)(int horiz, int c, int size, int parentsize, double *anchor, struct hwTagList *tags);
} hwGfxBase;

typedef struct _hwAudioBase
{
	APTR (*hw_LockSample)(lua_ID *id, int readonly, struct hwTagList *tags, struct hwos_LockSampleStruct *smplock);
	void (*hw_UnLockSample)(APTR lock);
	
	/****** V6.0 vectors start here *****/	
	int (*hw_SetAudioAdapter)(hwPluginBase *self, ULONG flags, struct hwTagList *tags);		
} hwAudioBase;

typedef struct _hwRequesterBase
{
	int (*hw_EasyRequest)(STRPTR title, STRPTR body, STRPTR gadgets, struct hwTagList *tags);
	int (*hw_FileRequest)(STRPTR title, STRPTR buf, int len, struct hwTagList *tags);
	int (*hw_PathRequest)(STRPTR title, STRPTR buf, int len, struct hwTagList *tags);
	
	/****** V6.0 vectors start here *****/		
	int (*hw_SetRequesterAdapter)(hwPluginBase *self, ULONG flags, struct hwTagList *tags);	
} hwRequesterBase;

typedef struct _hwFontBase
{
	STRPTR (*hw_FindTTFFont)(STRPTR name, int weight, int slant, int fileonly, int *retoffset, int *retlen, int *rettmp);
} hwFontBase;

#ifdef HW_PLUGIN_FT2BASE
typedef struct _hwFT2Base
{
	FT_Error (*FT_Init_FreeType)(FT_Library *alibrary);
	FT_Error (*FT_Done_FreeType)(FT_Library library);
	FT_Error (*FT_New_Face)(FT_Library library, const char *filepathname, FT_Long face_index, FT_Face *aface);
	FT_Error (*FT_New_Memory_Face)(FT_Library library, const FT_Byte *file_base, FT_Long file_size, FT_Long face_index, FT_Face *aface);
	FT_Error (*FT_Load_Glyph)(FT_Face face, FT_UInt glyph_index, FT_Int32 load_flags);
	FT_Error (*FT_Render_Glyph)(FT_GlyphSlot slot, FT_Render_Mode render_mode);
	FT_Error (*FT_Get_Glyph)(FT_GlyphSlot slot, FT_Glyph *aglyph);
	void (*FT_Done_Glyph)(FT_Glyph glyph);
	void (*FT_Outline_Transform)(const FT_Outline *outline, const FT_Matrix*   matrix);
	void (*FT_Outline_Translate)(const FT_Outline *outline, FT_Pos xOffset, FT_Pos yOffset);
	FT_Error (*FT_Outline_Get_Bitmap)(FT_Library library, FT_Outline *outline, const FT_Bitmap *abitmap);
	void (*FT_Outline_Get_CBox)(const FT_Outline*  outline, FT_BBox *acbox);
	FT_Error (*FT_Outline_Decompose)(FT_Outline *outline, const FT_Outline_Funcs *func_interface, void *user);
	FT_Error (*FT_Done_Face)(FT_Face face);
	FT_UInt (*FT_Get_Char_Index)(FT_Face face, FT_ULong  charcode);
	FT_ULong (*FT_Get_First_Char)(FT_Face face, FT_UInt  *agindex);
	FT_ULong (*FT_Get_Next_Char)(FT_Face face, FT_ULong   char_code, FT_UInt   *agindex);
	void (*FT_Set_Transform)(FT_Face face, FT_Matrix*  matrix, FT_Vector*  delta);
	FT_Error (*FT_Set_Charmap)(FT_Face face, FT_CharMap  charmap);
	FT_Error (*FT_Set_Pixel_Sizes)(FT_Face face, FT_UInt  pixel_width, FT_UInt  pixel_height);
	FT_Error (*FT_Set_Char_Size)(FT_Face face, FT_F26Dot6  char_width, FT_F26Dot6  char_height, FT_UInt horz_resolution, FT_UInt vert_resolution);
	FT_Long (*FT_MulFix)(FT_Long  a, FT_Long  b);
	void (*FT_Vector_Transform)(FT_Vector *vec, const FT_Matrix*  matrix);
	FT_Error (*FT_Get_Kerning)(FT_Face face, FT_UInt left_glyph, FT_UInt right_glyph, FT_UInt kern_mode, FT_Vector *akerning);
	void* (*FT_Get_Sfnt_Table)(FT_Face face, FT_Sfnt_Tag tag);
	FT_Error (*FT_Load_Sfnt_Table)(FT_Face face, FT_ULong tag, FT_Long offset, FT_Byte *buffer, FT_ULong *length);
	
	/****** V5.3 vectors start here *****/	
	const char *(*FT_Get_X11_Font_Format)(FT_Face face);
	FT_UInt (*FT_Get_Name_Index)(FT_Face face, FT_String *glyph_name);	
	FT_Error (*FT_Get_Glyph_Name)(FT_Face face, FT_UInt glyph_index, FT_Pointer buffer, FT_UInt buffer_max);
	FT_Error (*FT_Select_Charmap)(FT_Face face, FT_Encoding encoding);
	FT_Error (*FT_Get_Advance)(FT_Face face, FT_UInt gindex, FT_Int32 load_flags, FT_Fixed *padvance);
	void (*FT_Library_Version)(FT_Library library, FT_Int *amajor, FT_Int *aminor, FT_Int *apatch);
	FT_Error (*FT_Outline_Embolden)(FT_Outline *outline, FT_Pos strength);
	FT_Error (*FT_Stroker_New)(FT_Library library, FT_Stroker *astroker);	
	void (*FT_Stroker_Set)(FT_Stroker stroker, FT_Fixed radius, FT_Stroker_LineCap line_cap, FT_Stroker_LineJoin line_join, FT_Fixed miter_limit);
	void (*FT_Stroker_Done)(FT_Stroker stroker);
	FT_Error (*FT_Glyph_Stroke)(FT_Glyph *pglyph, FT_Stroker stroker, FT_Bool destroy);
	FT_Error (*FT_Glyph_To_Bitmap)(FT_Glyph *the_glyph, FT_Render_Mode render_mode, FT_Vector *origin, FT_Bool destroy);
} hwFT2Base;
#else
typedef void hwFT2Base;
typedef APTR FT_Face;
#endif

typedef struct _hwLuaBase
{
	int (*lua_gettop)(lua_State *L);
	void (*lua_settop)(lua_State *L, int idx);
	void (*lua_pushvalue)(lua_State *L, int idx);
	void (*lua_remove)(lua_State *L, int idx);
	void (*lua_insert)(lua_State *L, int idx);
	void (*lua_replace)(lua_State *L, int idx);
	int (*lua_iscfunction)(lua_State *L, int idx);
	int (*lua_isnumber)(lua_State *L, int idx);
	int (*lua_isstring)(lua_State *L, int idx);
	int (*lua_isuserdata)(lua_State *L, int idx);
	int (*lua_type)(lua_State *L, int idx);
	int (*lua_equal)(lua_State *L, int idx1, int idx2);
	int (*lua_rawequal)(lua_State *L, int idx1, int idx2);
	int (*lua_lessthan)(lua_State *L, int idx1, int idx2, int casesen);
	lua_Number (*lua_tonumber)(lua_State *L, int idx);
	const char *(*lua_tostring)(lua_State *L, int idx);
	size_t (*lua_strlen)(lua_State *L, int idx);
	lua_CFunction (*lua_tocfunction)(lua_State *L, int idx);		
	void *(*lua_touserdata)(lua_State *L, int idx);
	const void *(*lua_topointer)(lua_State *L, int idx);
	void (*lua_pushnil)(lua_State *L);
	void (*lua_pushnumber)(lua_State *L, lua_Number n);
	void (*lua_pushlstring)(lua_State *L, const char *s, size_t l);
	void (*lua_pushstring)(lua_State *L, const char *s);
	void (*lua_pushlightuserdata)(lua_State *L, void *p);
	void (*lua_pushcclosure)(lua_State *L, lua_CFunction fn, int n);	
	void (*lua_gettable)(lua_State *L, int idx);
	void (*lua_rawget)(lua_State *L, int idx);
	void (*lua_rawgeti)(lua_State *L, int idx, int n);
	void (*lua_newtable)(lua_State *L);
	void (*lua_getfenv)(lua_State *L, int idx);	
	void (*lua_settable)(lua_State *L, int idx);
	void (*lua_rawset)(lua_State *L, int idx);
	void (*lua_rawseti)(lua_State *L, int idx, int n);
	int (*lua_setfenv)(lua_State *L, int idx);	
	int (*lua_pcall)(lua_State *L, int nargs, int nresults, int errfunc);
	int (*lua_next)(lua_State *L, int idx);
	void (*lua_concat)(lua_State *L, int n);
	int (*lua_pushupvalues)(lua_State *L);
	const char *(*lua_getupvalue)(lua_State *L, int funcindex, int n);
	const char *(*lua_setupvalue)(lua_State *L, int funcindex, int n);
	void *(*lua_newuserdata)(lua_State *L, size_t size);
	int (*lua_setmetatable)(lua_State *L, int objindex);
	int (*lua_getmetatable)(lua_State *L, int objindex);	
	void (*lua_throwerror)(lua_State *L, int error);				
	const char *(*luaL_checklstring)(lua_State *L, int numArg, size_t *l);
	const char *(*luaL_optlstring)(lua_State *L, int numArg, const char *def, size_t *l);
	lua_Number (*luaL_checknumber)(lua_State *L, int numArg);
	lua_Number (*luaL_optnumber)(lua_State *L, int nArg, lua_Number def);
	unsigned int (*luaL_checkuint)(lua_State *L, int narg);
	unsigned int (*luaL_optuint)(lua_State *L, int narg, unsigned int def);
	void (*luaL_checktable)(lua_State *L, int narg);
	void (*luaL_checkfunction)(lua_State *L, int narg);
	void (*luaL_checktype)(lua_State *L, int narg, int t);	
	int (*luaL_ref)(lua_State *L, int t);
	void (*luaL_unref)(lua_State *L, int t, int ref);
	void (*luaL_checkid)(lua_State *L, int numArg, lua_ID *id);
	int (*luaL_newmetatable)(lua_State *L, const char *tname);
	void (*luaL_getmetatable)(lua_State *L, const char *tname);	
	void *(*luaL_checkudata)(lua_State *L, int ud, const char *tname);
	void (*luaL_buffinit)(lua_State *L, luaL_Buffer *B);
	char *(*luaL_prepbuffer)(luaL_Buffer *B);
	void (*luaL_addlstring)(luaL_Buffer *B, const char *s, size_t l);
	void (*luaL_addstring)(luaL_Buffer *B, const char *s);
	void (*luaL_addvalue)(luaL_Buffer *B);
	void (*luaL_pushresult)(luaL_Buffer *B);	
	int (*luaL_findstring)(const char *name, const char *const list[]);

	/****** V5.2 vectors start here *****/
	int (*lua_checkstack)(lua_State *L, int size);
	
	/****** V5.3 vectors start here *****/
	const char *(*luaL_checkfilename)(lua_State *L, int numArg);	
	void (*luaL_checknewid)(lua_State *L, int numArg, lua_ID *id);	
	
	/****** V6.0 vectors start here *****/
	void (*lua_pushboolean)(lua_State *L, int b);
	int (*lua_toboolean)(lua_State *L, int idx);	
	void (*lua_createtable)(lua_State *L, int narray, int nrec);
	const char *(*lua_typename)(lua_State *L, int t);	
	int (*lua_call)(lua_State *L, int nargs, int nresults);	
	int (*lua_getgcthreshold)(lua_State *L);
	int (*lua_getgccount)(lua_State *L);
	void (*lua_setgcthreshold)(lua_State *L, int newthreshold);	
	
	/****** V9.0 vectors start here *****/
	int (*luaL_getconstant)(lua_State *L, const char *name, lua_Number *nval, char **sval);
} hwLuaBase;

#ifdef HW_PLUGIN_ZBASE
typedef struct _hwZBase
{
	int (*inflateInit)(z_streamp strm, const char *version, int size);	
	int (*inflate)(z_streamp strm, int flush);
	int (*inflateEnd)(z_streamp strm);
	int (*deflateInit)(z_streamp strm, int level, const char *version, int size);	
	int (*deflate)(z_streamp strm, int flush);
	int (*deflateEnd)(z_streamp strm);	
	int (*deflateReset)(z_streamp strm);
	int (*deflateParams)(z_streamp strm, int level, int strategy);		
	int (*inflateReset)(z_streamp strm);	
	int (*inflateSync)(z_streamp strm);		

	/****** V6.0 vectors start here *****/
	int (*inflateInit2)(z_streamp strm, int windowBits, const char *version, int stream_size);
	int (*deflateInit2)(z_streamp strm, int level, int method, int windowBits, int memLevel, int strategy, const char *version, int stream_size);
	ULONG (*crc32)(ULONG crc, const UBYTE *buf, ULONG len);
	
	/****** V9.0 vectors start here *****/	
	int (*compress)(Bytef *dest, uLongf *destLen, const Bytef *source, uLong sourceLen);	
	int (*uncompress)(Bytef *dest, uLongf *destLen, const Bytef *source, uLong sourceLen);
} hwZBase;
#else
typedef void hwZBase;
#endif

#ifdef HW_PLUGIN_JPEGBASE
typedef struct _hwJPEGBase
{
	void (*jpeg_create_decompress)(j_decompress_ptr cinfo, int version, size_t structsize);
	boolean (*jpeg_finish_decompress)(j_decompress_ptr cinfo);
	void (*jpeg_destroy_decompress)(j_decompress_ptr cinfo);
	struct jpeg_error_mgr *(*jpeg_std_error)(struct jpeg_error_mgr *err);
	int (*jpeg_read_header)(j_decompress_ptr cinfo, boolean require_image);
	JDIMENSION (*jpeg_read_scanlines)(j_decompress_ptr cinfo, JSAMPARRAY scanlines, JDIMENSION max_lines);
	boolean (*jpeg_start_decompress)(j_decompress_ptr cinfo);
	boolean (*jpeg_resync_to_restart)(j_decompress_ptr cinfo, int desired);
	void (*jpeg_create_compress)(j_compress_ptr cinfo, int version, size_t structsize);
	void (*jpeg_finish_compress)(j_compress_ptr cinfo);	
	void (*jpeg_destroy_compress)(j_compress_ptr cinfo);
	void (*jpeg_start_compress)(j_compress_ptr cinfo, boolean write_all_tables);	
	void (*jpeg_set_defaults)(j_compress_ptr cinfo);
	JDIMENSION (*jpeg_write_scanlines)(j_compress_ptr cinfo, JSAMPARRAY scanlines, JDIMENSION num_lines);	
	void (*jpeg_set_quality)(j_compress_ptr cinfo, int quality, boolean force_baseline);	
	void (*jpeg_set_colorspace)(j_compress_ptr cinfo, J_COLOR_SPACE colorspace);
	void (*jpeg_default_colorspace)(j_compress_ptr cinfo);	
	void (*jpeg_destroy)(j_common_ptr cinfo);	
	void (*jpeg_abort)(j_common_ptr cinfo);	
	void (*jpeg_suppress_tables)(j_compress_ptr cinfo, boolean suppress);	
	JDIMENSION (*jpeg_write_raw_data)(j_compress_ptr cinfo, JSAMPIMAGE data, JDIMENSION num_lines);	
	void (*jpeg_write_tables)(j_compress_ptr cinfo);
	JDIMENSION (*jpeg_read_raw_data)(j_decompress_ptr cinfo, JSAMPIMAGE data, JDIMENSION max_lines);
	void (*jpeg_save_markers)(j_decompress_ptr cinfo, int marker_code, unsigned int length_limit);	
	void (*jpeg_calc_output_dimensions)(j_decompress_ptr cinfo);				
} hwJPEGBase;
#else
typedef void hwJPEGBase;	
#endif

typedef struct _hwPluginLibBase
{
	struct hwPluginList *(*hw_GetPluginList)(struct hwTagList *tags);
	void (*hw_FreePluginList)(struct hwPluginList *plugins);
	void (*hw_DisablePlugin)(hwPluginBase *plugin, int disable);
	void (*hw_SetPluginUserPointer)(hwPluginBase *plugin, APTR userdata);
	APTR (*hw_GetPluginUserPointer)(hwPluginBase *plugin);
} hwPluginLibBase;

typedef struct _hwUtilityBase
{
	void (*hw_EncodeBase64)(UBYTE *src, int srclen, UBYTE *dst, int *dstlen, struct hwTagList *tags);
	int (*hw_DecodeBase64)(UBYTE *src, int srclen, UBYTE *dst, int *dstlen, struct hwTagList *tags);
	ULONG (*hw_CRC32)(UBYTE *data, int len);
	void (*hw_MD5)(UBYTE *data, int len, STRPTR dest);
	
	/****** V10.0 vectors start here *****/	
	struct hwUserTagList *(*hw_CloneUserTagList)(struct hwUserTagList *usertags, struct hwTagList *tags);
	void (*hw_FreeUserTagList)(struct hwUserTagList *usertags);	
} hwUtilityBase;	

typedef struct _hwUnicodeBase
{
	size_t (*strlen)(const char *s);
	int (*stricmp)(const char *s1, const char *s2);
	int (*strnicmp)(const char *s1, const char *s2, size_t n);
	int (*tolower)(int c);
	int (*toupper)(int c);	
	int (*isalnum)(int c);
	int (*isalpha)(int c);
	int (*iscntrl)(int c);
	int (*isdigit)(int c);
	int (*isgraph)(int c);	
	int (*islower)(int c);
	int (*isprint)(int c);	
	int (*ispunct)(int c);
	int (*isspace)(int c);
	int (*isxdigit)(int c);
	int (*isupper)(int c);
	int (*validate)(const char *s);
	int (*getbyteindex)(const char *s, int charindex);
	int (*getcharindex)(const char *s, int byteindex);
	int (*getnextchar)(const char *s, int *pos);
	void (*composechar)(char *dst, int c);
} hwUnicodeBase;

typedef struct _hwLocaleBase
{
	int (*hw_GetSystemLanguage)(struct hwTagList *tags);
	int (*hw_GetSystemCountry)(struct hwTagList *tags);
	int (*hw_GetTimeZone)(int *isdst, struct hwTagList *tags);	
	
	/****** V9.0 vectors start here *****/	
	APTR (*hw_OpenCatalog)(STRPTR catalog, struct hwTagList *tags);
	void (*hw_CloseCatalog)(APTR handle);
	STRPTR (*hw_GetCatalogString)(APTR handle, int idx, STRPTR def, struct hwTagList *tags);	
} hwLocaleBase;

typedef struct _hwMiscBase
{
	UBYTE *VeraSans;
	UBYTE *VeraMono;
	UBYTE *VeraSerif;
	int sizeof_VeraSans;
	int sizeof_VeraMono;
	int sizeof_VeraSerif;
} hwMiscBase;

typedef struct _hwPluginAPI
{
	int hwVersion;
	int hwRevision;
	hwCRTBase *CRTBase;
	hwSysBase *SysBase;
	hwDOSBase *DOSBase;
	hwGfxBase *GfxBase;
	hwAudioBase *AudioBase;
	hwRequesterBase *RequesterBase;
	hwFontBase *FontBase;
	hwFT2Base *FT2Base;
	hwLuaBase *LuaBase;
	hwMiscBase *MiscBase;
	
	/****** V5.3 vectors start here *****/	
	hwZBase *ZBase;
	hwJPEGBase *JPEGBase;

	/****** V6.0 vectors start here *****/
	hwPluginLibBase *PluginBase;
	hwUtilityBase *UtilityBase;
	
	/****** V7.0 vectors start here *****/	
	hwUnicodeBase *UnicodeBase;
	
	/****** V7.1 vectors start here *****/	
	hwLocaleBase *LocaleBase;	
} hwPluginAPI;

#ifndef HW_PLUGIN_NOPROTOS

// Base functions for all plugins
HW_EXPORT int HWP_ENTRY(InitPlugin)(hwPluginBase *self, hwPluginAPI *cl, STRPTR path);
HW_EXPORT void HWP_ENTRY(ClosePlugin)(void);

// Functions to implement when HWPLUG_CAPS_CONVERT is set
HW_EXPORT STRPTR HWP_ENTRY(GetScript)(STRPTR file);
HW_EXPORT void HWP_ENTRY(FreeScript)(STRPTR buf);

// Functions to implement when HWPLUG_CAPS_LIBRARY is set
HW_EXPORT STRPTR HWP_ENTRY(GetBaseTable)(void);
HW_EXPORT struct hwCmdStruct* HWP_ENTRY(GetCommands)(void);
HW_EXPORT struct hwCstStruct* HWP_ENTRY(GetConstants)(void);
HW_EXPORT int HWP_ENTRY(InitLibrary)(lua_State *L);
HW_EXPORT void HWP_ENTRY(FreeLibrary)(lua_State *L);
HW_EXPORT int HWP_ENTRY(GetLibraryCount)(void);                  // V6.0, optional - only when HWEXT_LIBRARY_MULTIPLE is set
HW_EXPORT void HWP_ENTRY(SetCurrentLibrary)(int n);              // V6.0, optional - only when HWEXT_LIBRARY_MULTIPLE is set
HW_EXPORT struct hwHelpStruct* HWP_ENTRY(GetHelpStrings)(void);  // V7.0, optional - only when HWEXT_LIBRARY_HELPSTRINGS is set
HW_EXPORT int HWP_ENTRY(PushUpvalues)(lua_State *L);             // V7.1, optional - only when HWEXT_LIBRARY_UPVALUES is set
     
// Functions to implement when HWPLUG_CAPS_IMAGE is set
HW_EXPORT int HWP_ENTRY(IsImage)(STRPTR filename, struct LoadImageCtrl *ctrl);
HW_EXPORT APTR HWP_ENTRY(LoadImage)(STRPTR filename, struct LoadImageCtrl *ctrl);
HW_EXPORT ULONG* HWP_ENTRY(GetImage)(APTR handle, struct LoadImageCtrl *ctrl);
HW_EXPORT void HWP_ENTRY(FreeImage)(APTR handle);
HW_EXPORT int HWP_ENTRY(TransformImage)(APTR handle, struct hwMatrix2D *m, int width, int height);
HW_EXPORT STRPTR HWP_ENTRY(GetImageFormat)(APTR handle);        // V10.0, optional - only when HWEXT_IMAGE_FORMATNAME is set

// Functions to implement when HWPLUG_CAPS_ANIM is set
HW_EXPORT APTR HWP_ENTRY(OpenAnim)(STRPTR filename, struct LoadAnimCtrl *ctrl);
HW_EXPORT ULONG* HWP_ENTRY(LoadFrame)(APTR handle, int frame, struct LoadAnimCtrl *ctrl);
HW_EXPORT void HWP_ENTRY(FreeFrame)(ULONG *frame);
HW_EXPORT int HWP_ENTRY(GetFrameDelay)(APTR handle, int frame);
HW_EXPORT void HWP_ENTRY(CloseAnim)(APTR handle);
HW_EXPORT ULONG* HWP_ENTRY(GetFrame)(APTR handle, struct LoadAnimCtrl *ctrl);                       // V9.0, optional - only when HWEXT_ANIM_VECTOR is set
HW_EXPORT int HWP_ENTRY(TransformFrame)(APTR handle, struct hwMatrix2D *m, int width, int height);  // V9.0, optional - only when HWEXT_ANIM_VECTOR is set
HW_EXPORT void HWP_ENTRY(FreeVectorFrame)(APTR handle);                                             // V9.0, optional - only when HWEXT_ANIM_VECTOR is set
HW_EXPORT STRPTR HWP_ENTRY(GetAnimFormat)(APTR handle);                                             // V10.0, optional - only when HWEXT_ANIM_FORMATNAME is set

// Functions to implement when HWPLUG_CAPS_SOUND is set
HW_EXPORT APTR HWP_ENTRY(OpenStream)(STRPTR filename, struct LoadSoundCtrl *ctrl);
HW_EXPORT void HWP_ENTRY(CloseStream)(APTR handle);
HW_EXPORT void HWP_ENTRY(SeekStream)(APTR handle, ULONG pos);
HW_EXPORT int HWP_ENTRY(StreamSamples)(APTR handle, struct StreamSamplesCtrl *ctrl);
HW_EXPORT STRPTR HWP_ENTRY(GetFormatName)(APTR handle);

// Functions to implement when HWPLUG_CAPS_VECTOR is set
HW_EXPORT void HWP_ENTRY(GetPathExtents)(struct PathExtentsCtrl *ctrl);
HW_EXPORT int HWP_ENTRY(DrawPath)(struct DrawPathCtrl *ctrl);
HW_EXPORT void HWP_ENTRY(TranslatePath)(struct TranslatePathCtrl *ctrl);
HW_EXPORT void HWP_ENTRY(GetCurrentPoint)(void *path, struct PathStyle *style, double *curx, double *cury);
HW_EXPORT APTR HWP_ENTRY(CreateVectorFont)(FT_Face face);
HW_EXPORT void HWP_ENTRY(FreeVectorFont)(APTR font);
HW_EXPORT FT_Face HWP_ENTRY(OpenFont)(UBYTE *data, int datalen);
HW_EXPORT void HWP_ENTRY(CloseFont)(FT_Face face);

// Functions to implement when HWPLUG_CAPS_VIDEO is set
HW_EXPORT APTR HWP_ENTRY(OpenVideo)(STRPTR filename, struct OpenVideoCtrl *ctrl);
HW_EXPORT void HWP_ENTRY(CloseVideo)(APTR handle);
HW_EXPORT int HWP_ENTRY(NextPacket)(APTR handle, struct VideoPacketStruct *p);
HW_EXPORT void HWP_ENTRY(FreePacket)(APTR packet);
HW_EXPORT int HWP_ENTRY(DecodeVideoFrame)(APTR handle, APTR packet, struct DecodeVideoFrameCtrl *ctrl);
HW_EXPORT int HWP_ENTRY(DecodeAudioFrame)(APTR handle, APTR packet, struct DecodeAudioFrameCtrl *ctrl);
HW_EXPORT int HWP_ENTRY(SeekVideo)(APTR handle, ULONG pos, int mode);
HW_EXPORT void HWP_ENTRY(FlushAudio)(APTR handle);
HW_EXPORT void HWP_ENTRY(FlushVideo)(APTR handle);
HW_EXPORT ULONG HWP_ENTRY(GetVideoFrames)(APTR handle);
HW_EXPORT STRPTR HWP_ENTRY(GetVideoFormat)(APTR handle);

// Functions to implement when HWPLUG_CAPS_SAVEIMAGE is set
HW_EXPORT void HWP_ENTRY(RegisterImageSaver)(struct SaveImageReg *reg);
HW_EXPORT int HWP_ENTRY(SaveImage)(STRPTR filename, struct SaveImageCtrl *ctrl);

// Functions to implement when HWPLUG_CAPS_SAVEANIM is set
HW_EXPORT void HWP_ENTRY(RegisterAnimSaver)(struct SaveAnimReg *reg);
HW_EXPORT APTR HWP_ENTRY(BeginAnimStream)(STRPTR filename, int width, int height, int format, int quality, int fps);
HW_EXPORT APTR HWP_ENTRY(BeginAnimStreamExt)(STRPTR filename, int width, int height, int format, int quality, int fps, struct hwTagList *tags);   // V10.0, optional - only when HWEXT_SAVEANIM_BEGINANIMSTREAM is set
HW_EXPORT int HWP_ENTRY(WriteAnimFrame)(APTR stream, struct SaveAnimCtrl *ctrl);
HW_EXPORT int HWP_ENTRY(FinishAnimStream)(APTR stream);

// Functions to implement when HWPLUG_CAPS_SAVESAMPLE is set
HW_EXPORT void HWP_ENTRY(RegisterSampleSaver)(struct SaveSampleReg *reg);
HW_EXPORT int HWP_ENTRY(SaveSample)(STRPTR filename, struct SaveSampleCtrl *ctrl);

// Functions to implement when HWPLUG_CAPS_REQUIRE is set [V6.0]
HW_EXPORT int HWP_ENTRY(RequirePlugin)(lua_State *L, int version, int revision, ULONG flags, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_DISPLAYADAPTER is set [V6.0]
HW_EXPORT int HWP_ENTRY(HandleEvents)(lua_State *L, ULONG flags, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(WaitEvents)(lua_State *L, ULONG flags, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(ForceEventLoopIteration)(struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(DetermineBorderSizes)(ULONG flags, int *left, int *right, int *top, int *bottom);
HW_EXPORT APTR HWP_ENTRY(OpenDisplay)(STRPTR title, int x, int y, int width, int height, ULONG flags, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(CloseDisplay)(APTR handle);
HW_EXPORT int HWP_ENTRY(ChangeBufferSize)(APTR handle, int width, int height, ULONG flags, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(ShowHideDisplay)(APTR handle, int show, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(SizeMoveDisplay)(APTR handle, int x, int y, int width, int height, ULONG flags, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(SetDisplayTitle)(APTR handle, STRPTR title);
HW_EXPORT void HWP_ENTRY(ActivateDisplay)(APTR handle, ULONG flags);
HW_EXPORT int HWP_ENTRY(SetDisplayAttributes)(APTR handle, struct hwTagList *tags);
HW_EXPORT APTR HWP_ENTRY(CreatePointer)(ULONG *rgb, int hx, int hy, int *width, int *height, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(FreePointer)(APTR handle);
HW_EXPORT void HWP_ENTRY(SetPointer)(APTR handle, int type, APTR data);
HW_EXPORT void HWP_ENTRY(ShowHidePointer)(APTR handle, int show);
HW_EXPORT void HWP_ENTRY(MovePointer)(APTR handle, int x, int y);
HW_EXPORT void HWP_ENTRY(GetMousePos)(APTR handle, int *mx, int *my);
HW_EXPORT ULONG HWP_ENTRY(GetQualifiers)(APTR handle);
HW_EXPORT void HWP_ENTRY(BltBitMap)(APTR bmap, APTR handle, struct hwBltBitMapCtrl *ctrl, ULONG flags, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(RectFill)(APTR handle, int x, int y, int width, int height, ULONG color, ULONG flags, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(WritePixel)(APTR handle, int x, int y, ULONG color, ULONG flags, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(Line)(APTR handle, int x1, int y1, int x2, int y2, ULONG color, ULONG flags, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(Sleep)(lua_State *L, int ms);                                                                          // only used if HWSDAFLAGS_SLEEP is set
HW_EXPORT void HWP_ENTRY(VWait)(APTR handle, struct hwTagList *tags);                                                          // only used if HWSDAFLAGS_VWAIT is set
HW_EXPORT int HWP_ENTRY(GetMonitorInfo)(int what, int monitor, APTR *data, struct hwTagList *tags);                            // only used if HWSDAFLAGS_MONITORINFO is set
HW_EXPORT void HWP_ENTRY(FreeMonitorInfo)(int what, APTR data);                                                                // only used if HWSDAFLAGS_MONITORINFO is set
HW_EXPORT ULONG* HWP_ENTRY(GrabScreenPixels)(APTR handle, int x, int y, int width, int height, ULONG flags, struct hwTagList *tags); // only used if HWSDAFLAGS_GRABSCREEN is set
HW_EXPORT void HWP_ENTRY(FreeGrabScreenPixels)(ULONG *pixels);                                                                 // only used if HWSDAFLAGS_GRABSCREEN is set
HW_EXPORT int HWP_ENTRY(BeginDoubleBuffer)(APTR handle, struct hwTagList *tags);                                               // only used if HWSDAFLAGS_DOUBLEBUFFERADAPTER is set
HW_EXPORT int HWP_ENTRY(EndDoubleBuffer)(APTR handle, struct hwTagList *tags);                                                 // only used if HWSDAFLAGS_DOUBLEBUFFERADAPTER is set 
HW_EXPORT int HWP_ENTRY(Flip)(APTR handle, struct hwTagList *tags);                                                            // only used if HWSDAFLAGS_DOUBLEBUFFERADAPTER is set
HW_EXPORT int HWP_ENTRY(Cls)(APTR handle, ULONG color, struct hwTagList *tags);                                                // only used if HWSDAFLAGS_DOUBLEBUFFERADAPTER is set
HW_EXPORT APTR HWP_ENTRY(AllocBitMap)(int type, int width, int height, ULONG flags, struct hwTagList *tags);                   // only used if HWSDAFLAGS_BITMAPADAPTER is set
HW_EXPORT void HWP_ENTRY(FreeBitMap)(APTR handle);                                                                             // only used if HWSDAFLAGS_BITMAPADAPTER is set
HW_EXPORT APTR HWP_ENTRY(LockBitMap)(APTR handle, ULONG flags, struct hwos_LockBitMapStruct *bmlock, struct hwTagList *tags);  // only used if HWSDAFLAGS_BITMAPADAPTER is set
HW_EXPORT void HWP_ENTRY(UnLockBitMap)(APTR handle);                                                                           // only used if HWSDAFLAGS_BITMAPADAPTER is set
HW_EXPORT int HWP_ENTRY(GetBitMapAttr)(APTR handle, int attr, struct hwTagList *tags);                                         // only used if HWSDAFLAGS_BITMAPADAPTER is set
HW_EXPORT APTR HWP_ENTRY(AllocVideoBitMap)(int width, int height, ULONG flags, struct hwTagList *tags);                        // only used if HWSDAFLAGS_VIDEOBITMAPADAPTER is set
HW_EXPORT void HWP_ENTRY(FreeVideoBitMap)(APTR handle);                                                                        // only used if HWSDAFLAGS_VIDEOBITMAPADAPTER is set
HW_EXPORT APTR HWP_ENTRY(ReadVideoPixels)(APTR handle, struct hwTagList *tags);                                                // only used if HWSDAFLAGS_VIDEOBITMAPADAPTER is set
HW_EXPORT void HWP_ENTRY(FreeVideoPixels)(APTR pixels);                                                                        // only used if HWSDAFLAGS_VIDEOBITMAPADAPTER is set
HW_EXPORT int HWP_ENTRY(DoVideoBitMapMethod)(APTR handle, int method, APTR data);                                              // only used if HWSDAFLAGS_VIDEOBITMAPADAPTER is set
HW_EXPORT int HWP_ENTRY(AdapterMainLoop)(lua_State *L, int (*f)(APTR data), APTR data, ULONG flags, struct hwTagList *tags);   // V6.1, optional - only when HWEXT_DISPLAYADAPTER_MAINLOOP is set
HW_EXPORT void HWP_ENTRY(SetPalette)(APTR handle, ULONG *palette, struct hwTagList *tags);                                     // V9.0, optional - only when HWEXT_DISPLAYADAPTER_PALETTE is set
HW_EXPORT int HWP_ENTRY(SetMenuBar)(APTR display, struct hwMenuTreeInfo *menu, struct hwTagList *tags);                        // V9.0, optional - only when HWEXT_DISPLAYADAPTER_MENUADAPTER is set
HW_EXPORT int HWP_ENTRY(SetMenuAttributes)(APTR display, struct hwMenuTreeInfo *item, ULONG setflags, ULONG clrflags, struct hwTagList *tags); // V9.0, optional - only when HWEXT_DISPLAYADAPTER_MENUADAPTER is set
HW_EXPORT int HWP_ENTRY(GetMenuAttributes)(APTR display, struct hwMenuTreeInfo *item, ULONG *flags, struct hwTagList *tags);   // V9.0, optional - only when HWEXT_DISPLAYADAPTER_MENUADAPTER is set
HW_EXPORT int HWP_ENTRY(SetTrayIcon)(APTR display, ULONG *rgb, int width, int height, struct hwTagList *tags);                 // V9.0, optional - only when HWEXT_DISPLAYADAPTER_TRAYICON is set
HW_EXPORT int HWP_ENTRY(OpenPopupMenu)(APTR display, struct hwMenuTreeInfo *menu, int x, int y, struct hwTagList *tags);       // V10.0, optional - only when HWEXT_DISPLAYADAPTER_POPUPMENU is set

// Functions to implement when HWPLUG_CAPS_TIMERADAPTER is set [V6.0]
HW_EXPORT APTR HWP_ENTRY(RegisterTimer)(lua_State *L, int ms, int oneshot);
HW_EXPORT void HWP_ENTRY(FreeTimer)(APTR handle);

// Functions to implement when HWPLUG_CAPS_REQUESTERADAPTER is set [V6.0]
HW_EXPORT int HWP_ENTRY(SystemRequest)(APTR handle, STRPTR title, STRPTR body, ULONG flags, int *result, struct hwTagList *tags);               // only used if HWSRAFLAGS_SYSTEMREQUEST is set
HW_EXPORT int HWP_ENTRY(FileRequest)(APTR handle, STRPTR title, ULONG flags, STRPTR *result, struct hwTagList *tags);                           // only used if HWSRAFLAGS_FILEREQUEST is set 
HW_EXPORT int HWP_ENTRY(PathRequest)(APTR handle, STRPTR title, ULONG flags, STRPTR *result, struct hwTagList *tags);                           // only used if HWSRAFLAGS_PATHREQUEST is set
HW_EXPORT int HWP_ENTRY(StringRequest)(APTR handle, STRPTR title, STRPTR body, ULONG flags, STRPTR *result, struct hwTagList *tags);            // only used if HWSRAFLAGS_STRINGREQUEST is set
HW_EXPORT int HWP_ENTRY(ListRequest)(APTR handle, STRPTR title, STRPTR body, STRPTR choices, ULONG flags, int *result, struct hwTagList *tags); // only used if HWSRAFLAGS_LISTREQUEST is set
HW_EXPORT int HWP_ENTRY(FontRequest)(APTR handle, STRPTR title, ULONG flags, STRPTR *result, ULONG *style, struct hwTagList *tags);             // only used if HWSRAFLAGS_FONTREQUEST is set
HW_EXPORT int HWP_ENTRY(ColorRequest)(APTR handle, STRPTR title, ULONG flags, int *result, struct hwTagList *tags);                             // only used if HWSRAFLAGS_COLORREQUEST is set
HW_EXPORT void HWP_ENTRY(FreeRequest)(int type, STRPTR data);

// Functions to implement when HWPLUG_CAPS_FILEADAPTER is set [V6.0]
HW_EXPORT APTR HWP_ENTRY(FOpen)(STRPTR name, int mode, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(FClose)(APTR handle);
HW_EXPORT int HWP_ENTRY(FRead)(APTR handle, APTR buf, int size);
HW_EXPORT int HWP_ENTRY(FGetC)(APTR handle);
HW_EXPORT int HWP_ENTRY(FWrite)(APTR handle, APTR buf, int size);
HW_EXPORT int HWP_ENTRY(FPutC)(APTR handle, int ch);
HW_EXPORT DOSINT64 HWP_ENTRY(FSeek)(APTR handle, DOSINT64 pos, int mode);
HW_EXPORT int HWP_ENTRY(FFlush)(APTR handle);
HW_EXPORT int HWP_ENTRY(FEof)(APTR handle);
HW_EXPORT int HWP_ENTRY(FStat)(APTR handle, ULONG flags, struct hwos_StatStruct *st, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(Stat)(STRPTR name, ULONG flags, struct hwos_StatStruct *st, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_DIRADAPTER is set [V6.0]
HW_EXPORT APTR HWP_ENTRY(OpenDir)(STRPTR name, int mode, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(CloseDir)(APTR handle);
HW_EXPORT int HWP_ENTRY(NextDirEntry)(APTR handle, struct hwos_StatStruct *st, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(RewindDir)(APTR handle);                                                                 // V8.0, optional - only if HWEXT_DIRADAPTER_REWIND is set
HW_EXPORT int HWP_ENTRY(StatDir)(APTR handle, ULONG flags, struct hwos_StatStruct *st, struct hwTagList *tags);  // V9.0, optional - only if HWEXT_DIRADAPTER_STAT is set

// Functions to implement when HWPLUG_CAPS_AUDIOADAPTER is set [V6.0]
HW_EXPORT APTR HWP_ENTRY(OpenAudio)(ULONG flags, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(CloseAudio)(APTR handle);
HW_EXPORT APTR HWP_ENTRY(AllocAudioChannel)(APTR handle, int fmt, int freq, int vol, int (*feedproc)(APTR handle, APTR chandle, APTR buf, int count, APTR userdata), ULONG flags, APTR userdata, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(FreeAudioChannel)(APTR handle, APTR chandle);
HW_EXPORT int HWP_ENTRY(SetChannelAttributes)(APTR handle, APTR chandle, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_EXTENSION is set [V6.0]
HW_EXPORT ULONG HWP_ENTRY(GetExtensions)(ULONG capbit, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_NETWORKADAPTER is set [V8.0]
HW_EXPORT APTR HWP_ENTRY(OpenConnection)(STRPTR address, int port, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(CloseConnection)(APTR handle);
HW_EXPORT int HWP_ENTRY(GetConnectionInfo)(APTR handle, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(ReceiveData)(APTR handle, APTR buf, int size, int *n, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(SendData)(APTR handle, APTR buf, int size, int *n, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_SERIALIZE is set [V9.0]
HW_EXPORT APTR HWP_ENTRY(InitSerializer)(int (*readfunc)(APTR buf, int len, APTR userdata), int (*writefunc)(APTR data, int len, APTR userdata), APTR userdata, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(FreeSerializer)(APTR handle);
HW_EXPORT int HWP_ENTRY(SerializeItem)(APTR handle, struct hwSerializeItemInfo *key, struct hwSerializeItemInfo *val, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(DeserializeItem)(APTR handle, struct hwSerializeItemInfo *key, struct hwSerializeItemInfo *val, int *done, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_ICON is set [V9.0]
HW_EXPORT APTR HWP_ENTRY(LoadIcon)(STRPTR filename, struct hwTagList *tags);
HW_EXPORT struct hwIconList* HWP_ENTRY(GetIconImages)(APTR handle, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(FreeIcon)(APTR handle);
HW_EXPORT STRPTR HWP_ENTRY(GetIconFormat)(APTR handle);        // V10.0, optional - only when HWEXT_ICON_FORMATNAME is set

// Functions to implement when HWPLUG_CAPS_SAVEICON is set [V9.0]
HW_EXPORT void HWP_ENTRY(RegisterIconSaver)(struct SaveIconReg *reg);
HW_EXPORT int HWP_ENTRY(SaveIcon)(STRPTR filename, struct hwIconList *list, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_IPCADAPTER is set [V9.0]
HW_EXPORT APTR HWP_ENTRY(CreateIPCPort)(STRPTR name, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(FreeIPCPort)(APTR handle);
HW_EXPORT int HWP_ENTRY(SendIPCMessage)(STRPTR port, UBYTE *data, int len, struct hwTagList *tags);

// Functions to implement when HWPLUG_CAPS_FONT is set [V10.0]
HW_EXPORT APTR HWP_ENTRY(LoadFont)(STRPTR name, int size, struct hwLoadFontCtrl *lf, struct hwTagList *tags);
HW_EXPORT void HWP_ENTRY(FreeFont)(APTR font);
HW_EXPORT int HWP_ENTRY(MeasureText)(APTR font, STRPTR text, int count, int encoding, struct hwTextExtent *te, struct hwTextLayout *tl, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(RenderText)(APTR font, STRPTR text, int count, int encoding, struct hwRenderTextCtrl *pt, struct hwMatrix2D *m, struct hwTextLayout *tl, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(GetKerning)(APTR font, STRPTR pair, int encoding, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(SetFontScale)(APTR font, double *sx, double *sy, struct hwTagList *tags);
HW_EXPORT STRPTR HWP_ENTRY(GetFontFormat)(APTR font);

// Functions to implement when HWPLUG_CAPS_FILESYSADAPTER is set [V10.0]
HW_EXPORT int HWP_ENTRY(ChangeDir)(STRPTR dir, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(GetCurDir)(STRPTR buf, int size, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(MakeDir)(STRPTR dir, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(DeleteFSObj)(STRPTR obj, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(RenameFSObj)(STRPTR oldobj, STRPTR newobj, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(MoveFSObj)(STRPTR src, STRPTR dst, struct hwTagList *tags);
HW_EXPORT int HWP_ENTRY(SetFSObjAttributes)(STRPTR obj, ULONG attr, struct hwos_StatStruct *st, struct hwTagList *tags); 
#endif

#endif
