
/*
 * TYPEDEFS.H
 *
 *	Feel free to add extern's that should be stuck in here... send
 *	me the additions!
 *
 *	NOTE SPECIAL DEFINES that allow me to compile programs under both
 *	Lattice and Aztec C.
 *
 *	    ARGS
 */

#ifndef LOCAL_TYPEDEFS_H
#define LOCAL_TYPEDEFS_H

#include <exec/types.h>
#include <exec/exec.h>

#include <devices/audio.h>
#include <devices/conunit.h>
#include <devices/inputevent.h>
#include <devices/parallel.h>
#include <devices/keyboard.h>
#include <devices/printer.h>
#include <devices/serial.h>
#include <devices/keymap.h>
#include <devices/prtbase.h>
#include <devices/timer.h>
#include <devices/console.h>
#include <devices/input.h>
#include <devices/prtgfx.h>
#include <devices/trackdisk.h>

#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <libraries/filehandler.h>

#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/clip.h>
#include <graphics/display.h>
#include <graphics/layers.h>
#include <graphics/rastport.h>
#include <graphics/view.h>
#include <graphics/regions.h>
#include <graphics/text.h>

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>

#ifdef LATTICE
#include <proto/all.h>
#else
#include "functions.h"
#endif

/*
 *  Used for prototype compatibility with older compilers
 *
 *  ARGS:   prototype for arguments to function
 *  reg     register variable (for lattice we let the
 *	    compiler pick'm)
 */

#ifdef LATTICE
#define ARGS(args)  args
#define reg
#else
#define ARGS(args)  ()
#define __stdargs
#define __saveds
#define reg register
#endif

#define LALIGN(ptr)  ((void *)(((long)ptr + 3) & ~3))
#define ARYSIZE(ary)    (sizeof(ary)/sizeof((ary)[0]))
#define ARYEND(ary)     ((ary) + ARYSIZE(ary))
#define offsetof(type,elem)     ((long)&((type *)0)->elem)
#define BTOC(bptr)    ((void *)((long)(bptr) << 2))
#define CTOB(cptr)    ((long)(cptr) >> 2)


typedef unsigned char	ubyte;
typedef unsigned short	uword;
typedef unsigned long	ulong;

typedef struct MsgPort		PORT;
typedef struct Message		MSG;
typedef struct List		LIST;
typedef struct Node		NODE;
typedef struct MinList		MLIST;
typedef struct MinNode		MNODE;
typedef struct Device		DEV;
typedef struct Library		LIB;
typedef struct ExecBase 	EXECBASE;
typedef struct SignalSemaphore	SIGSEM;
typedef struct Semaphore	SEM;
typedef struct MemEntry 	MEMENTRY;
typedef struct MemList		MEMLIST;
typedef struct MemHeader	MEMHEADER;
typedef struct Interrupt	INTERRUPT;
typedef struct Custom		CUST;

#define WINSTD	(WINDOWSIZING|WINDOWDRAG|WINDOWDEPTH|WINDOWCLOSE)

typedef struct BoolInfo 	BOOLINFO;
typedef struct Border		BORDER;
typedef struct Gadget		GADGET;
typedef struct Image		IMAGE;
typedef struct IntuiMessage	IMESS;
typedef struct IntuiText	ITEXT;
typedef struct Menu		MENU;
typedef struct MenuItem 	ITEM;
typedef struct NewScreen	NS;
typedef struct NewWindow	NW;
typedef struct Preferences	PREFS;
typedef struct PropInfo 	PROPINFO;
typedef struct Remember 	REMEMBER;
typedef struct Requester	REQUESTER;
typedef struct Screen		SCR;
typedef struct StringInfo	STRINGINFO;
typedef struct Window		WIN;

typedef struct copinit		COPINIT;

typedef struct GListEnv 	GLISTENV;
typedef struct GadgetInfo	GADGETINFO;
typedef struct IBox		IBOX;
typedef struct IntuitionBase	IBASE;
typedef struct PenPair		PENPAIR;
typedef struct Point		POINT;

typedef struct IOAudio		IOAUD;

typedef struct BootBlock	BOOTBLOCK;

typedef struct IOClipReq	    IOCLIPREQ;
typedef struct ClipboardUnitPartial CLIPUNIT;
typedef struct SatisfyMsg	    SATISFYMSG;

typedef struct ConUnit		CONUNIT;
typedef struct IOStdReq 	IOSTD;
typedef struct IOStdReq 	IOCON;
typedef struct IOExtSer 	IOSER;

typedef struct InputEvent	IE;

typedef struct TextAttr 	TA;
typedef struct TextFont 	FONT;
typedef struct Layer		LAYER;
typedef struct Layer_Info	LAYERINFO;
typedef struct Region		REGION;
typedef struct ClipRect 	CLIPRECT;
typedef struct BitMap		BM;
typedef struct RastPort 	RP;
typedef struct TmpRas		TMPRAS;
typedef struct AreaInfo 	AREAINFO;
typedef struct View		VIEW;
typedef struct ViewPort 	VP;
typedef struct ColorMap 	CM;
typedef struct GfxBase		GFXBASE;

typedef struct Process		PROC;
typedef struct Task		TASK;
typedef struct FileInfoBlock	FIB;
typedef struct FileLock 	LOCK;
typedef struct DateStamp	DATESTAMP;

typedef struct timeval		TV;
typedef struct timerequest	IOT;

typedef struct PrinterData	PD;
typedef struct PrinterExtendedData PED;

/*
 *  Support Libraries
 */

#include <local/xmisc.h>
#include <local/ipc.h>
#include <local/suplib.h>

#endif


