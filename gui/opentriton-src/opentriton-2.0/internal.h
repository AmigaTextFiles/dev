/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  internal.h - Internal function definitions
 *
 */


#ifndef TR_PREFSONLY

// Includes

#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/utility_protos.h>
#include <clib/wb_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/diskfont_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/wb_pragmas.h>


// Pool support

#ifndef TR_THIS_IS_REALLY_TRITON
  #ifdef TR_OS39
    #define TR_AllocPooled(a,b) AllocPooled(a,b)
    #define TR_FreePooled(a,b,c) FreePooled(a,b,c)
  #else
    extern void *TR_AllocPooled(void *poolHeader, ULONG memSize);
    extern void *TR_FreePooled(void *poolHeader, APTR memory, ULONG memSize);
  #endif
#endif


// Helping functions

struct TROD_Object *  __regargs TR_AddObjectToIDList(struct TR_Project *project, struct TROD_Object * object);
struct Gadget *       __regargs TR_CreateGadget(struct TR_Project *project, struct TROD_Object *object, ULONG kind, ULONG left, ULONG top, ULONG width, ULONG height, struct TagItem *tags);
ULONG                 __regargs TR_CountListEntries(struct List *list);
ULONG                 __regargs TR_GetDisplayInfoData (UBYTE *buf, ULONG size, ULONG tagID, ULONG displayID);
ULONG                 __regargs TR_GetBottomBorderHeight(struct Screen *scr);
ULONG                 __regargs TR_IdFromPlace(struct TR_Project *project, UWORD x, UWORD y);
struct TROD_DisplayObject * __regargs TR_ObjectFromPlace(struct TR_Project *project, UWORD x, UWORD y);
struct TR_Class *     __regargs TR_FindClass(struct TR_App *app, ULONG tag);
VOID                  __regargs TR_AddDefaultClasses(VOID);
ULONG                 __regargs TR_GetTagType(ULONG tag);

static struct Gadget * __inline
TR_CreateGadgetTags(struct TR_Project *project, struct TROD_Object *object, ULONG kind, ULONG left,
		    ULONG top, ULONG width, ULONG height, ULONG tags,...)
{
  return TR_CreateGadget(project,object,kind,left,top,width,height,(struct TagItem *)&tags);
}

static BOOL __inline
TR_InternalAddClassTags(ULONG tag, ULONG superTag, TR_Method defaultMethod, ULONG datasize, ULONG tags,...)
{
  return TR_AddClass(NULL,tag,superTag,defaultMethod,datasize,(struct TagItem *)&tags);
}


// Text

VOID __regargs TR_DoShortcut(struct TR_Project *project, UBYTE shortcut, UWORD code, struct TROM_EventData * edata);


// Gadgets

VOID __regargs TR_SelectGadget(struct TR_Project *project, struct Gadget *gad, BOOL selected);
VOID __regargs TR_DisableGadget(struct TR_Project *project, struct Gadget *gad, BOOL disabled);


// Other

VOID __regargs TR_DoMethodID(struct TR_Project *project, ULONG objectid, ULONG method, APTR data);
VOID __regargs TR_InternalAreaFill(struct TR_Project *project, struct RastPort *rp, ULONG left, ULONG top, ULONG right, ULONG bottom, ULONG type);
VOID __stdargs TR_SPrintF (STRPTR buf, STRPTR format, ...);
VOID TR_UpdateQuickHelp(struct TR_Project *project, ULONG x, ULONG y, BOOL removeNow);


// Library bases

extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
extern struct Library *GadToolsBase;
extern struct Library *UtilityBase;
extern struct Library *DiskfontBase;
extern struct Library *KeymapBase;
extern struct Library *SysBase;
extern struct Library *DOSBase;
extern struct Library *WorkbenchBase;


// Global data

extern struct TR_Global
{
  UWORD                 trg_OSVersion;        // OS version (e.g. 39 for OS3.0)
  struct MinList        trg_ClassList;        // Contains classes
  VOID *                trg_ClassListPool;    // Pool for the class list
  struct MinList        trg_ScreenList;       // Contains opened public screens
  VOID *                trg_ScreenListPool;   // Pool for the screen list
} TR_Global;


////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// Class management //
////////////////////////////////////////////////////////////////////////////

typedef struct TR_Class
{
  struct MinNode                trc_Node;
  struct TR_Class             * trc_SuperClass;
  ULONG                         trc_Tag;
  TR_Method                     trc_Dispatcher[25];
  struct TR_Class             * trc_MetaClass[25];
  ULONG                         trc_SizeOfClassData;
} TR_Class;


////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// Dispatcher stuff //
////////////////////////////////////////////////////////////////////////////

/* Object Messages */

#define TROM_PREGTREMOVE        5L         /* Is called before GadTools gadgets are removed */
#define TROM_GETBETTERHEIGHT    21L        /* Get a better height for an object */


////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////// Private window flags //
////////////////////////////////////////////////////////////////////////////

#define TRWF_QUICKHELP          0x10000000L     /* Quick help active? */


/**************************************************************************************************** Text */

extern BOOL __regargs TR_ThickBorders(struct TR_Project *project);

extern VOID __asm TR_InternalPrintText(register __a0 struct TR_Project *project,
				       register __a1 struct RastPort *rp,
				       register __a2 STRPTR text,
				       register __d1 ULONG x, register __d2 ULONG y,
				       register __d3 width, register __d0 ULONG flags);


/*************************************************************************************************** Frame */

extern VOID __asm TR_InternalDrawFrame(register __a0 struct TR_Project *project,
				       register __a1 struct RastPort *rp, register __d1 UWORD left,
				       register __d2 UWORD top, register __d3 UWORD width,
				       register __d4 UWORD height, register __d0 UWORD type,
				       register __d5 BOOL inverted);


////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// Class construction macros //
////////////////////////////////////////////////////////////////////////////

#define TR_METHOD(class,method,dstr) ULONG __asm TRDP_ ## class ## _ ## method \
				(register __a0 struct TROD_ ## class *object,\
				 register __d0 ULONG messageid,\
				 register __a2 struct TROM_ ## dstr *data,\
				 register __a1 struct TR_Class *metaclass)

#define TR_SIMPLEMETHOD(class,method) ULONG __asm TRDP_ ## class ## _ ## method \
                                (register __a0 struct TROD_ ## class *object,\
				 register __d0 ULONG messageid,\
				 register __a2 void *data,\
				 register __a1 struct TR_Class *metaclass)

#define TR_DEFAULTMETHOD(class) ULONG __asm TRDP_ ## class \
                                (register __a0 struct TROD_ ## class *object,\
				 register __d0 ULONG messageid,\
				 register __a2 void *data,\
				 register __a1 struct TR_Class *metaclass)

#define NEWDATA ((struct TROM_NewData *)data)
#define SETATDATA ((struct TROM_SetAttributeData *)data)

#define TR_CLASS_BEG(c,sc)      if(!(TR_InternalAddClassTags(TROB_ ## c,TROB_ ## sc,TRDP_ ## c,\
							     sizeof(struct TROD_ ## c),
#define TR_CLASS_BEG_ND(c,sc)   if(!(TR_InternalAddClassTags(TROB_ ## c,TROB_ ## sc,NULL,\
							     sizeof(struct TROD_ ## c),
#define TR_CLASS_MET(c,m)       TROM_ ## m, TRDP_ ## c ## _ ## m ,
#define TR_CLASS_DMET(c,m,d)    TROM_ ## m, TRDP_ ## c ## _ ## d ,
#define TR_CLASS_END            TAG_END))) goto failed;

#define TR_DIRECTMETHODCALL(c,m) TRDP_ ## c ## _ ## m(object,messageid,data,metaclass)


////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////// PREFERENCES //
////////////////////////////////////////////////////////////////////////////

#endif /* TR_PREFSONLY */


////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////// Magic values //
////////////////////////////////////////////////////////////////////////////

#define TRWP_MAGIC              1024L           /* PRIVATE! */

#define TRCA_MagicPrefs         (TAG_USER+1000) /* PRIVATE! */


/* Definitions for TR_DoShortcut() */

#define TR_SHORTCUT_KEYDOWN   1
#define TR_SHORTCUT_KEYUP     2
#define TR_SHORTCUT_CANCELLED 3


/************************************************************************** The Triton application message */

struct TR_Message
{
  struct TR_Project *           trm_Project;    /* The project which triggered the message */
  ULONG                         trm_ID;         /* The object's ID (where appropriate) */
  ULONG                         trm_Class;      /* The Triton message class */
  ULONG                         trm_Data;       /* The class-specific data */
  ULONG                         trm_Code;       /* Currently only used by TRMS_KEYPRESSED */
  ULONG                         trm_Qualifier;  /* IEQUALIFIERs */
  ULONG                         trm_Seconds;    /* \ Copy of system clock time (Only where */
  ULONG                         trm_Micros;     /* / available! If not set, trm_Seconds is 0) */
  struct TR_App *               trm_App;        /* The project's application */
  /* FIELDS BELOW THIS LINE ARE PRIVATE */
  struct MinNode                trm_Node;       /* Used for insertion into the message queue */
};

#define TR_NODE2MSG(n) ((struct TR_Message *)(((char *)n)-36))


/******************************************************************************* The Application Structure */

typedef struct TR_App
{
  VOID *                        tra_MemPool;    /* The memory pool */
  ULONG                         tra_BitMask;    /* Bits to Wait() for */
  STRPTR                        tra_Name;       /* Unique name */
  /* PRIVATE PARTS FOLLOWING */
  struct MinList                tra_ClassList;  /* The private classes of this application */
  ULONG                         tra_LastError;  /* TRER code of last error */
  STRPTR                        tra_LongName;   /* User-readable name */
  STRPTR                        tra_Info;       /* Info string */
  STRPTR                        tra_Version;    /* Version */
  STRPTR                        tra_Release;    /* Release */
  STRPTR                        tra_Date;       /* Compilation date */
  struct MsgPort *              tra_AppPort;    /* Application message port */
  struct MsgPort *              tra_IDCMPPort;  /* IDCMP message port */
  VOID *                        tra_Prefs;      /* Pointer to Triton app prefs */
  struct TR_Project *           tra_CurProject; /* Used by TR_CreateMsg() */
  ULONG                         tra_CurSecs;    /* Used by TR_CreateMsg() */
  ULONG                         tra_CurMicros;  /* Used by TR_CreateMsg() */
  ULONG                         tra_CurQual;    /* Used by TR_CreateMsg() */
  struct InputEvent *           tra_InputEvent; /* Used for RAWKEY conversion */
  struct MinList                tra_MsgList;    /* Message queue */
} TR_App;


/*********************************************************************************** The Project structure */

#include <classes/object.def>

typedef struct TR_Project
{
  struct TROD_Object            tro_SC_Object;                  /* Superclass object data */
  struct TR_App *               trp_App;                        /* Our application */
  VOID *                        trp_MemPool;                    /* The memory pool for the lists */
  ULONG                         trp_ID;                         /* The project's ID */
  ULONG                         trp_IDCMPFlags;                 /* The IDCMP flags */
  struct Window *               trp_Window;                     /* The default window */
  UWORD                         trp_AspectFixing;               /* Pixel aspect correction factor */

  /* PRIVATE PARTS FOLLOWING */

  struct Screen *               trp_Screen;                     /* Our screen, always valid */
  ULONG                         trp_ScreenType;                 /* Type of screen (WA_...Screen) */
  struct Screen *               trp_LockedPubScreen;            /* Only valid if we're using a PubScreen */
  STRPTR                        trp_ScreenTitle;                /* The screen title */

  struct AppWindow *            trp_AppWindow;                  /* AppWindow for icon dropping */

  ULONG                         trp_Flags;                      /* Triton window flags */

  struct NewMenu *              trp_NewMenu;                    /* The newmenu stucture built by Triton */
  ULONG                         trp_NewMenuSize;                /* The number of menu items in the list */
  struct Menu *                 trp_Menu;                       /* The menu structure */

  VOID *                        trp_VisualInfo;                 /* The VisualInfo of our window */
  struct DrawInfo *             trp_DrawInfo;                   /* The DrawInfo of the screen */
  struct TR_Dimensions *        trp_UserDimensions;             /* User-supplied dimensions */
  struct TR_Dimensions *        trp_Dimensions;                 /* Private dimensions */

  ULONG                         trp_WindowStdHeight;            /* The standard height of the window */
  ULONG                         trp_LeftBorder;                 /* The width of the left window border */
  ULONG                         trp_RightBorder;                /* The width of the right window border */
  ULONG                         trp_TopBorder;                  /* The height of the top window border */
  ULONG                         trp_BottomBorder;               /* The height of the bottom window border */
  ULONG                         trp_InnerWidth;                 /* The inner width of the window */
  ULONG                         trp_InnerHeight;                /* The inner height of the window */
  WORD                          trp_ZipDimensions[4];           /* The dimensions for the zipped window */

  struct TROD_DisplayObject *   trp_RootObject;                 /* The root object of the window */
  struct MinList                trp_MenuList;                   /* The list of menus */
  struct MinList                trp_IDList;                     /* The ID linking list (menus & objects) */

  struct TextAttr *             trp_PropAttr;                   /* The proportional font attributes */
  struct TextAttr *             trp_FixedWidthAttr;             /* The fixed-width font attributes */
  struct TextFont *             trp_PropFont;                   /* The proportional font */
  struct TextFont *             trp_FixedWidthFont;             /* The fixed-width font */
  BOOL                          trp_OpenedPropFont;             /* \ Have we opened the fonts ? */
  BOOL                          trp_OpenedFixedWidthFont;       /* /                            */
  UWORD                         trp_TotalPropFontHeight;        /* Height of prop font incl. underscore */

  ULONG                         trp_BackfillType;               /* The backfill type */
  struct Hook *                 trp_BackfillHook;               /* The backfill hook */

  struct Gadget *               trp_GadToolsGadgetList;         /* List of GadTools gadgets */
  struct Gadget *               trp_PrevGadget;                 /* Previous GadTools gadget */
  struct NewGadget *            trp_NewGadget;                  /* GadTools NewGadget */

  struct Requester *            trp_InvisibleRequest;           /* The invisible blocking requester */
  BOOL                          trp_IsUserLocked;               /* Project locked by the user? */

  ULONG                         trp_CurrentID;                  /* The currently keyboard-selected ID */
  BOOL                          trp_IsShortcutDown;             /* Shortcut key pressed? */
  UBYTE                         trp_Underscore;                 /* The underscore character */

  BOOL                          trp_EscClose;                   /* Close window on Esc? */
  BOOL                          trp_DelZip;                     /* Zip window on Del? */
  BOOL                          trp_PubScreenFallBack;          /* Fall back onto default public screen? */
  BOOL                          trp_FontFallBack;               /* Fall back to topaz.8? */

  UWORD                         trp_OldWidth;                   /* Old window width */
  UWORD                         trp_OldHeight;                  /* Old window height */

  struct Window *               trp_QuickHelpWindow;            /* The QuickHelp window */
  struct TROD_DisplayObject *   trp_QuickHelpObject;            /* Object for which help is popped up */
  ULONG                         trp_TicksPassed;                /* IntuiTicks passed since last MouseMove */
} TR_Project;
