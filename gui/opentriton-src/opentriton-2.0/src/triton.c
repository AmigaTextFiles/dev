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
 *  triton.c - Shared library source
 *
 */


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define INTUI_V36_NAMES_ONLY
#define TR_NOSUPPORT
#define TR_THIS_IS_TRITON
#define TR_THIS_IS_REALLY_TRITON

#include <exec/exec.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <libraries/gadtools.h>
#include <libraries/diskfont.h>
#include <devices/keymap.h>
#include <devices/inputevent.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/keymap_protos.h>
#include <clib/wb_protos.h>
#include <clib/alib_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/keymap_pragmas.h>
#include <pragmas/wb_pragmas.h>

#include <stdlib.h>
#include <ctype.h>

#include "include/libraries/triton.h"
#include "include/clib/triton_protos.h"
#include "prefs/Triton.h"
#include "/internal.h"

#include "parts/define_classes.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Version //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

const UBYTE versionstring[]="\0$VER: triton.library " SVERSION "." SREVISION " " __AMIGADATE__;
const UBYTE cooper[]="/THE/OWLS/ARE/NOT/WHAT/THEY/SEEM/";


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////// Library bases //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct Library *GadToolsBase;
struct Library *UtilityBase;
struct Library *DiskfontBase;
struct Library *KeymapBase;
struct Library *SysBase;
struct Library *DOSBase;
struct Library *WorkbenchBase;
struct Library *LocaleBase;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// Locale support //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define CATCOMP_NUMBERS
#define LOCSTR(num) GetString(&li,num)
#include <libraries/locale.h>
#include <proto/locale.h>
#include "catalogs/triton.h"
struct LocaleInfo li;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////// Amiga.lib, sc.lib replacement functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID GT_SetGadgetAttrs(struct Gadget *g, struct Window *w, struct Requester *r, ULONG tags,...)
{
  GT_SetGadgetAttrsA(g,w,r,(struct TagItem *)&tags);
}

LONG GT_GetGadgetAttrs(struct Gadget *g, struct Window *w, struct Requester *r, ULONG tags,...)
{
  return GT_GetGadgetAttrsA(g,w,r,(struct TagItem *)&tags);
}

struct Menu * __inline CreateMenus(struct NewMenu *n, ULONG tags,...)
{
  return CreateMenusA(n,(struct TagItem *)&tags);
}

BOOL __inline LayoutMenus(struct Menu *m, APTR v, ULONG tags,...)
{
  return LayoutMenusA(m,v,(struct TagItem *)&tags);
}

VOID __inline SetWindowPointer(struct Window *w, ULONG tags,...)
{
  SetWindowPointerA(w,(struct TagItem *)&tags);
}

APTR NewObject(struct IClass *i, UBYTE *c, ULONG tags,...)
{
  return NewObjectA(i,c,(struct TagItem *)&tags);
}

struct Screen * __inline OpenScreenTags(struct NewScreen *ns, ULONG tags,...)
{
  return OpenScreenTagList(ns,(struct TagItem *)&tags);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////// Pool support for all system software versions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef TR_OS39

#define TR_CreatePool(a,b,c)  CreatePool(a,b,c)
#define TR_DeletePool(a)      DeletePool(a)
#define TR_AllocPooled(a,b)   AllocPooled(a,b)
#define TR_FreePooled(a,b,c)  FreePooled(a,b,c)

#else

struct TR_MemPoolList
{
  struct MinList list;
  ULONG flags;
};

struct TR_MemPoolNode
{
  struct Node node;
  ULONG size;
  void *memory;
};

void *TR_CreatePool(ULONG memFlags, ULONG puddleSize, ULONG threshSize)
{
  struct TR_MemPoolList *list;

  /* Use Exec pool functions on v39+ */
  if(SysBase->lib_Version>=39) return CreatePool(memFlags,puddleSize,threshSize);

  if(!(list=(struct TR_MemPoolList *)AllocMem(sizeof(struct TR_MemPoolList),MEMF_ANY|MEMF_CLEAR)))
    return NULL;
  NewList((struct List *)list);
  list->flags=memFlags;
  return (void *)list;
}

void TR_DeletePool(void *poolHeader)
{
  struct TR_MemPoolNode *worknode,*nextnode;

  /* Use Exec pool functions on v39+ */
  if(SysBase->lib_Version>=39) {DeletePool(poolHeader); return;}

  /* Free all entries */
  worknode=(struct TR_MemPoolNode *)(((struct List *)poolHeader)->lh_Head);
  while(nextnode=(struct TR_MemPoolNode *)(worknode->node.ln_Succ))
  {
    FreeMem((APTR)worknode,(ULONG)(worknode->size)+(ULONG)(sizeof(struct TR_MemPoolNode)));
    worknode=nextnode;
  }

  /* Free list header */
  FreeMem(poolHeader,sizeof(struct TR_MemPoolList));
}

void *TR_AllocPooled(void *poolHeader, ULONG memSize)
{
  struct TR_MemPoolList *list;
  struct TR_MemPoolNode *node;

  /* Use Exec pool functions on v39+ */
  if(SysBase->lib_Version>=39) return AllocPooled(poolHeader,memSize);

  list=(struct TR_MemPoolList *)poolHeader;
  if(!(node=(struct TR_MemPoolNode *)AllocMem(sizeof(struct TR_MemPoolNode)+memSize,list->flags)))
    return NULL;
  node->memory=(void *)((ULONG)node+(ULONG)sizeof(struct TR_MemPoolNode));
  node->size=memSize;
  AddTail((struct List *)list,(struct Node *)node);
  return node->memory;
}

void TR_FreePooled(void *poolHeader, void *memory, ULONG memSize)
{
  struct TR_MemPoolNode *node;

  /* Use Exec pool functions on v39+ */
  if(SysBase->lib_Version>=39) {FreePooled(poolHeader,memory,memSize); return;}

  node=(struct TR_MemPoolNode *)((ULONG)(memory)-(ULONG)(sizeof(struct TR_MemPoolNode)));
  Remove((struct TR_MemPoolNode *)node);
  FreeMem((APTR)node,sizeof(struct TR_MemPoolNode)+memSize);
}

#endif


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Global variables //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct TR_Global TR_Global;
struct TextAttr topaz8attr={"topaz.font",8,NULL,FPF_ROMFONT};


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////// The ID list structure //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct TR_IDNode
{
  struct MinNode        tri_Node;
  ULONG                 tri_ID;
  struct TROD_Object *  tri_Object;
};


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////// Prototypes for our private functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

ULONG             __regargs TR_CreateMenus(struct TR_Project *project, struct TagItem *tags, ULONG items);
VOID              __regargs TR_DoBackfill(struct TR_Project *project);

VOID              __regargs TR_RefreshProject(struct TR_Project *project);

VOID              __regargs TR_GetWindowDimensions(struct TR_Project *project);
BYTE              __regargs TR_StrCmp(STRPTR s1,STRPTR s2);

VOID              __regargs TR_LockWindow(struct TR_Project *project);
VOID              __regargs TR_UnlockWindow(struct TR_Project *project);

VOID              __regargs TR_DisposeClasses(struct MinList *list);

VOID              __regargs TR_SaveAppInfos(struct TR_App *app);
VOID              __regargs TR_LoadTritonPrefs(struct TR_App *app);
VOID              __regargs TR_SaveWindowDimensions(struct TR_Project *project);
VOID              __regargs TR_LoadWindowDimensions(struct TR_Project *project);

struct Screen *   __regargs TR_OpenScreen(struct TR_ScreenNode *sn);
struct Screen *   __regargs TR_LockPubScreen(STRPTR name);
BOOL              __regargs TR_CloseScreen(struct TR_ScreenNode *sn);
VOID              __regargs TR_RemoveScreens(VOID);
VOID              __regargs TR_UnlockPubScreen(struct Screen *scr);


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// The backfill hook //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_AreaFill ******
*
*   NAME	
*	TR_AreaFill -- Draw a background pattern
*
*   SYNOPSIS
*	TR_AreaFill(Project, RastPort, Left, Top, Right, Bottom,
*	            A0       A1        D0    D1   D2     D3
*	            Type, Dummy)
*	            D4    A2
*
*	VOID TR_AreaFill(struct TR_Project *, struct RastPort *,
*	                 ULONG, ULONG, ULONG, ULONG, ULONG, VOID *);
*
*   FUNCTION
*	Fill an area with one of Triton's default backfill patterns.
*	The "Type" argument is a code from the TR_Images enumeration.
*	"Dummy" is currently unused and should be set to NULL. If
*	the RastPort is not specified (NULL) the project's default
*	RastPort will be used.
*
******/

struct BackFillPacket
{
  struct Layer *                layer;
  struct Rectangle              bounds;
  WORD                          offsetx;
  WORD                          offsety;
};


VOID __regargs TR_InternalAreaFill(struct TR_Project *project, struct RastPort *rp, ULONG left, ULONG top, ULONG right, ULONG bottom, ULONG type)
{
  ULONG frontpen,backpen,bftype;
  static UWORD TR_Planepattern[]={0x5555,0xAAAA};
  static const struct TR_PenArray {ULONG pen,paper;} penarray[]=
  {
    BACKGROUNDPEN,  BACKGROUNDPEN,
    SHINEPEN,       SHINEPEN,
    SHINEPEN,       SHADOWPEN,
    SHINEPEN,       FILLPEN,
    SHINEPEN,       BACKGROUNDPEN,
    SHADOWPEN,      SHADOWPEN,
    SHADOWPEN,      FILLPEN,
    SHADOWPEN,      BACKGROUNDPEN,
    FILLPEN,        FILLPEN,
    FILLPEN,        BACKGROUNDPEN
  };

  if(!rp) rp=project->trp_Window->RPort;

  if((type<=1)||(type>100))
    {
      if(type>100) type=(type&(~0x00010000));

      if(((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->imgtype[type]==TRIT_BFPATTERN)
	{
	  bftype=((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->imgdata[type]-2;
	  backpen=project->trp_DrawInfo->dri_Pens[((penarray[bftype]).paper)];
	  frontpen=project->trp_DrawInfo->dri_Pens[((penarray[bftype]).pen)];
	}
      /*-- else... add more image types here */
    }
  else
    {
      frontpen=project->trp_DrawInfo->dri_Pens[((penarray[type-2]).pen)];
      backpen=project->trp_DrawInfo->dri_Pens[((penarray[type-2]).paper)];
    }

  SetDrMd(rp,JAM2);
  SetAPen(rp,frontpen);
  SetBPen(rp,backpen);
  SetAfPt(rp,TR_Planepattern,1);
  RectFill(rp,left,top,right,bottom);
  SetAfPt(rp,NULL,-1);
}

VOID __saveds __asm TR_AreaFill(register __a0 struct TR_Project *project, register __a1 struct RastPort *rp,
				register __d0 ULONG left, register __d1 ULONG top, register __d2 ULONG right,
				register __d3 ULONG bottom, register __d4 ULONG type,
				register __a2 VOID *dummy)
{
  TR_InternalAreaFill(project,rp,left,top,right,bottom,type);
}

ULONG __saveds __asm TR_BackfillFunc(register __a0 struct Hook *hook,register __a2 struct RastPort *rp,
				     register __a1 struct BackFillPacket *bfp)
{
  struct TR_Project *project=(struct TR_Project *)(hook->h_Data);

  if(!(((bfp->bounds.MinX)>(bfp->bounds.MaxX))||((bfp->bounds.MinY)>(bfp->bounds.MaxY))))
    TR_InternalAreaFill(project,NULL, bfp->bounds.MinX, bfp->bounds.MinY, bfp->bounds.MaxX, bfp->bounds.MaxY,
			project->trp_BackfillType);
  return NULL;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////// Open and close the global things //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

int __saveds __asm __UserLibInit(VOID);
VOID __saveds __UserLibCleanup(VOID);


int __saveds __asm __UserLibInit(VOID)
{
  ULONG ch1,ch2;

  SysBase=*((void **)4);
#ifndef TR_OS39
  if((((struct Library *)(SysBase))->lib_Version)<37) return 1;
#endif

#ifdef TR_OS39
  /*-- Let's hope the compiler didn't generate an 68020+ instruction upto this point ;-) */
  if(!((((struct ExecBase *)(SysBase))->AttnFlags)&AFF_68020)) return 1;
  if((((struct Library *)(SysBase))->lib_Version)<39) return 1;
#endif

  NewList((struct List *)&(TR_Global.trg_ClassList));
  NewList((struct List *)&(TR_Global.trg_ScreenList));

  if(!(DOSBase=OpenLibrary("dos.library",37L))) goto failed;
  if(!(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library",37L))) goto failed;
  if(!(GfxBase=(struct GfxBase *)OpenLibrary("graphics.library",37L))) goto failed;
  if(!(GadToolsBase=OpenLibrary("gadtools.library",37L))) goto failed;
  if(!(UtilityBase=OpenLibrary("utility.library",37L))) goto failed;
  if(!(DiskfontBase=OpenLibrary("diskfont.library",36L))) goto failed;
  if(!(KeymapBase=OpenLibrary("keymap.library",37L))) goto failed;
  if(!(WorkbenchBase=OpenLibrary("workbench.library",37L))) goto failed;

  if(LocaleBase=OpenLibrary("locale.library",38L))
    {
      li.li_LocaleBase=LocaleBase;
      li.li_Catalog=OpenCatalogA(NULL,"triton.catalog",NULL);
    }

  if(!(TR_Global.trg_ClassListPool=
       TR_CreatePool(MEMF_ANY|MEMF_CLEAR,20*sizeof(struct TR_Class),sizeof(struct TR_Class)+1))) goto failed;
  if(!(TR_Global.trg_ScreenListPool=
       TR_CreatePool(MEMF_ANY,4*sizeof(struct TR_ScreenNode),sizeof(struct TR_ScreenNode)))) goto failed;

  TR_Global.trg_OSVersion=((struct Library *)(IntuitionBase))->lib_Version;

#include "parts/install_classes.h"

  if(!(TR_AddClass(NULL,TRMN_Title,TROB_Object,NULL,0,TAG_END))) goto failed;
  if(!(TR_AddClass(NULL,TRMN_Item,TROB_Object,NULL,0,TAG_END))) goto failed;
  if(!(TR_AddClass(NULL,TRMN_Sub,TROB_Object,NULL,0,TAG_END))) goto failed;

  return 0;

failed:
  __UserLibCleanup();
  return 1;
}


VOID __saveds __UserLibCleanup(VOID)
{
  TR_RemoveScreens();
  TR_DisposeClasses(&(TR_Global.trg_ClassList));
  if(TR_Global.trg_ClassListPool) TR_DeletePool(TR_Global.trg_ClassListPool);
  if(LocaleBase)
    {
      CloseCatalog(li.li_Catalog);
      CloseLibrary(LocaleBase);
    }
  CloseLibrary(WorkbenchBase);
  CloseLibrary(KeymapBase);
  CloseLibrary(DiskfontBase);
  CloseLibrary(UtilityBase);
  CloseLibrary(GadToolsBase);
  CloseLibrary((struct Library *)GfxBase);
  CloseLibrary((struct Library *)IntuitionBase);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////// Open and close a window/project //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_CloseProject ******
*
*   NAME	
*	TR_CloseProject -- Closes a project/window.
*
*   SYNOPSIS
*	TR_CloseProject(Project)
*	                A0
*
*	VOID TR_CloseProject(struct TR_Project *);
*
*   FUNCTION
*	Closes a Triton project.
*
*   SEE ALSO
*	TR_OpenProject()
*
******/

VOID __saveds __asm TR_CloseProject(register __a0 struct TR_Project *project)
{
  if(!project) return;

  project->trp_TicksPassed=0;
  TR_UpdateQuickHelp(project,0,0,TRUE);

  if(project->trp_NewGadget) FreeMem((VOID *)(project->trp_NewGadget),sizeof(struct NewGadget));
  if(project->trp_GadToolsGadgetList)
    {
      if(project->trp_Window) RemoveGList(project->trp_Window,project->trp_GadToolsGadgetList,-1);
      FreeGadgets(project->trp_GadToolsGadgetList);
    }
  if(project->trp_RootObject)
    {
      if(project->trp_Window)
	TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_REMOVE,NULL);
      TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_DISPOSE,NULL);
    }
  if(project->trp_Window)
    {
      TR_GetWindowDimensions(project);
      TR_SaveWindowDimensions(project);
      if(project->trp_UserDimensions)
	CopyMem((APTR)(project->trp_Dimensions),(APTR)(project->trp_UserDimensions),
		sizeof(struct TR_Dimensions));
      if(project->trp_Window->MenuStrip) ClearMenuStrip(project->trp_Window);
      TR_CloseWindowSafely(project->trp_Window);
      if(project->trp_AppWindow) RemoveAppWindow(project->trp_AppWindow);
    }
  if(project->trp_Menu) FreeMenus(project->trp_Menu);
  if(project->trp_NewMenu) FreeMem((VOID *)(project->trp_NewMenu),project->trp_NewMenuSize);
  if((project->trp_OpenedPropFont)&&(project->trp_PropFont)) CloseFont(project->trp_PropFont);
  if((project->trp_OpenedFixedWidthFont)&&(project->trp_FixedWidthFont))
    CloseFont(project->trp_FixedWidthFont);
  if(project->trp_VisualInfo) FreeVisualInfo(project->trp_VisualInfo);
  if(project->trp_DrawInfo) FreeScreenDrawInfo(project->trp_Screen, project->trp_DrawInfo);
  if(project->trp_LockedPubScreen) TR_UnlockPubScreen(project->trp_LockedPubScreen);
  if(project->trp_MemPool) TR_DeletePool(project->trp_MemPool);
  FreeMem((VOID *)(project),sizeof(struct TR_Project));
}


/****** triton.library/TR_OpenProject ******
*
*   NAME	
*	TR_OpenProject -- Opens a project/window.
*	TR_OpenProjectTags -- Varargs stub for TR_OpenProject.
*
*   SYNOPSIS
*	Project = TR_OpenProject(App, TagItems)
*	D0                       A1   A0
*
*	struct TR_Project *TR_OpenProject(struct TR_App *,
*	                                  struct TagItem *);
*
*	Project = TR_OpenProjectTags(App, Tag1,...)
*
*	struct TR_Project *TR_OpenProjectTags(struct TR_App *,
*	                                      ULONG,...);
*
*   FUNCTION
*	Opens a Triton project. The supplied taglist may contain
*	window tags, menu tags and object tags (in that order).
*	Mutually exclusive menus are not yet supported. When creating
*	a menu item with an ID, TRAT_ID must be the *last* tag.
*	A valid application pointer must be supplied.
*
*   INPUTS
*	App = Valid application pointer
*	TagItems = List of tags describing the project
*
*   TAGS
*	The taglist may contain window tags, menu tags and object tags
*	(in that order!). The following list shows the window and menu
*	tags. See the class descriptions for the object tags.
*
*	TRWI_Title (STRPTR) - The window title (changeable)
*
*	TRWI_ScreenTitle (STRPTR) - The screen title (changeable) (V2)
*
*	TRWI_Flags (ULONG) - The Triton window flags:
*	- TRWF_BACKDROP        : Create a backdrop borderless window
*	                         in full screen size
*	- TRWF_NODRAGBAR       : No dragging bar
*	- TRWF_NODEPTHGADGET   : No depth arranging gadget
*	- TRWF_NOCLOSEGADGET   : No close gadget
*	- TRWF_NOACTIVATE      : Don't activate window
*	- TRWF_NOESCCLOSE      : Don't send TRMS_CLOSEWINDOW when
*	                         Esc is pressed
*	- TRWF_NOPSCRFALLBACK  : Don't fall back onto default PubScreen
*	- TRWF_NOZIPGADGET     : No zip/zoom gadget
*	- TRWF_ZIPCENTERTOP    : Center zipped window on screen title bar
*	- TRWF_NOMINTEXTWIDTH  : Window title text length doesn't count
*	                         for window size calculation
*	- TRWF_NOSIZEGADGET    : No size gadget
*	- TRWF_NOFONTFALLBACK  : Don't fall back to topaz/8
*	- TRWF_NODELZIP        : Don't zip the window when Del is pressed
*	- TRWF_SIMPLEREFRESH   : Use simple instead of smart refresh. (V1)
*	                         This flag is *obsolete* in V3+!
*	                         The refresh type is now set by the user.
*	- TRWF_ZIPTOCURRENTPOS : Zip the window without changing its
*	                         position. Requires OS3.0 or higher.
*	- TRWF_APPWINDOW       : Create an AppWindow even if no object
*	                         reacts on dropped icons
*	- TRWF_ACTIVATESTRGAD  : Activate the first string gadget after
*	                         opening the window
*	- TRWF_HELP            : When the user presses <Help> over a menu
*	                         item or a display object, a TRMS_HELP
*	                         message will be sent (V2)
*	- TRWF_SYSTEMACTION    : When a system action IDCMP message arrives,
*	                         a corresponding Triton message will be
*	                         generated. These are currently
*	                         TRMS_DISKINSERTED and TRMS_DISKREMOVED.
*	                         (V4)
*
*	TRWI_Underscore (UBYTE *) - The underscore for menu and gadget
*	    shortcuts. The default is "_".
*
*	TRWI_Position (ULONG) - The window position:
*	- TRWP_DEFAULT         : Let Triton choose a good position for
*	                         the window (default; preferred)
*	- TRWP_BELOWTITLEBAR   : Left side of screen; below the title bar
*	- TRWP_CENTERTOP       : Top of screen; centered on the title bar
*	- TRWP_TOPLEFTSCREEN   : Top left corner of screen
*	- TRWP_CENTERSCREEN    : Centered on the screen
*	- TRWP_CENTERDISPLAY   : Centered on the currently displayed clip
*	- TRWP_MOUSEPOINTER    : Centered under the mouse pointer
*
*	TRWI_CustomScreen (struct Screen *) - A custom screen on which
*	    the window will be opened
*
*	TRWI_PubScreen (struct Screen *) - A public screen on which the
*	    window will be opened. The screen *must* have been locked.
*
*	TRWI_PubScreenName (STRPTR) - A public screen on which the window
*	    will be opened. Triton will try to lock the screen with the
*	    specified name. It will fall back onto the default public
*	    screen in case the screen can't be found/locked if you don't
*	    specify TRWF_NOPSCRFALLBACK.
*
*	TRWI_PropFontAttr (struct TextAttr *) - The proportional font. If
*	    Triton can't open the font or the window would become too big
*	    for the screen with this font and you didn't specify
*	    TRWF_NOFONTFALLBACK, Triton will try to use topaz/8 instead.
*
*	TRWI_FixedWidthFontAttr (struct TextAttr *) - The fixed-width
*	    font. If Triton can't open the font or the window would
*	    become too big for the screen with this font and you didn't
*	    specify TRWF_NOFONTFALLBACK, Triton will try to use topaz/8
*	    instead.
*
*	TRWI_Backfill (ULONG) - The backfill type:
*	- TRBF_WINDOWBACK        : Default window background; Can be
*	                           changed by the user in the Triton
*	                           Preferences editor
*	- TRBF_REQUESTERBACK     : Default requester background; Can be
*	                           changed by the user in the Triton
*	                           Preferences editor
*	- TRBF_NONE              : No backfill (i.e. fill with
*	                           BACKGROUNDPEN)
*	- TRBF_SHINE             : Fill with SHINEPEN
*	- TRBF_SHADOW            : Fill with SHADOWPEN
*	- TRBF_FILL              : Fill with FILLPEN
*	- TRBF_SHINE_SHADOW      : Fill with a pattern composed of
*	                           SHINEPEN and SHADOWPEN
*	- TRBF_SHINE_FILL        : ~ SHINEPEN and FILLPEN
*	- TRBF_SHINE_BACKGROUND  : ~ SHINEPEN and BACKGROUNDPEN
*	- TRBF_SHADOW_FILL       : ~ SHADOWPEN and FILLPEN
*	- TRBF_SHADOW_BACKGROUND : ~ SHADOWPEN and BACKGROUNDPEN
*	- TRBF_FILL_BACKGROUND   : ~ FILLPEN and BACKGROUNDPEN
*
*	TRWI_ID (ULONG) - An ID for the window. Identical windows (e.g.
*	    several identical data editor windows) should share the same
*	    ID, otherwise application-wide unique IDs should be used.
*
*	TRWI_Dimensions (struct TR_Dimensions *) - A window dimension
*	    structure. The user program must supply a structure on its
*	    own if it wants to use this feature. Triton will *not*
*	    allocate it. If you use a dimensions structure, Triton will
*	    copy the window dimensions into it when you close the window.
*	    If you supply a filled-in dimension structure, Triton will try
*	    to open the window with these dimensions. Supply a cleared
*	    structure if you want Triton to use the default dimensions (the
*	    position may then be specified with TRWI_Position) and fill
*	    in the structure for later use.
*
*	TRWI_QuickHelp (BOOL) - When this flag is set, QuickHelp windows
*	    will pop up for those objects which have QuickHelp strings
*	    assigned to them. (changeable) (V4)
*
*	TRMN_Title (STRPTR) - A menu label
*
*	TRMN_Item (STRPTR) - A menu item label. You may attach a
*	    keyboard shortcut to a menu by starting the label string
*	    with the shortcut followed by the project's underscore
*	    character and then the actual label. You may also use
*	    extended menu shortcuts composed of more than one character.
*	    Extended shortcuts can be specified with an underscore at
*	    the beginning, then the shortcut, again an underscore and
*	    the label. You may specify TRMN_BARLABEL instead of a string
*	    to create a separator bar in the menu.
*
*	TRMN_Sub (STRPTR) - A sub-menu item label. See TRMN_Item.
*
*	TRMN_Flags (ULONG) - Flags for a menu item:
*	- TRMF_CHECKIT         : The menu item may be checked.
*	- TRMF_CHECKED         : The menu item is checked. You may, but
*	                         you do not need to specify TRMF_CHECKIT
*	                         in addition.
*	- TRMF_DISABLED        : The menu / (sub) item will be ghosted.
*
*   RESULT
*	Project - The pointer to the TR_Project structure
*
*   SEE ALSO
*	TR_CloseProject()
*
******/

struct TR_Project * __saveds __asm TR_OpenProject(register __a1 struct TR_App *app, register __a0 struct TagItem *tags)
{
  ULONG i=0, menuitems=0;
  struct TR_Project *project;
  struct Window *window;
  struct TROM_NewData newdata,realnewdata;
  struct TROM_InstallData installdata;
  struct TagItem *firstobjitem=NULL, *firstmenuitem=NULL;
  STRPTR wintitle;
  ULONG positioning=TRWP_DEFAULT;
  BOOL zipcentertop=FALSE, mintextwidth=TRUE;
  ULONG screenmodeID;
  struct Rectangle displayrect;
  ULONG displayleft,displaytop,displaywidth,displayheight;
  BOOL centeronscreen=FALSE;
  ULONG globalobject;
  BOOL iszoomgadget,isclosegadget=TRUE,isdepthgadget=TRUE;
  BOOL dozip=TRUE,dozoom=TRUE;
  LONG topgadgetswidth=0;
  ULONG closewidth,toprightwidth,bottomgadgetheight,maxborderwidth,maxborderheight;
  struct DimensionInfo diminfo;
  ULONG minwidth,minheight;
  ULONG tagData;
  BOOL hasObjects=FALSE;

  /* The default window tags */

  struct TagItem winTags[]=
  {
    /*  0 */  WA_Flags,         WFLG_ACTIVATE|
                                WFLG_CLOSEGADGET|
                                WFLG_DEPTHGADGET|
                                WFLG_SIZEGADGET|
                                WFLG_DRAGBAR|
                                WFLG_RMBTRAP|
                                WFLG_NEWLOOKMENUS|
                                WFLG_SMART_REFRESH|
                                WFLG_SIZEBBOTTOM,
    /*  1 */  WA_IDCMP,         NULL,
    /*  2 */  WA_Title,         NULL,
    /*  3 */  WA_PubScreenName, NULL, /* This tag can be replaced later on */
    /*  4 */  WA_Width,         NULL,
    /*  5 */  WA_Height,        NULL,
    /*  6 */  WA_Zoom,          NULL,
    /*  7 */  WA_Left,          NULL,
    /*  8 */  WA_Top,           NULL,
    /*  9 */  WA_MaxWidth,      ~0,
    /* 10 */  WA_MaxHeight,     ~0,
    /* 11 */  WA_MinWidth,      0,
    /* 12 */  WA_MinHeight,     0,
    /* 13 */  WA_MenuHelp,      FALSE,
              TAG_END
  };

  /* Allocate the Project structure and attached structures */

  if(!(project=(struct TR_Project *)AllocMem(sizeof(struct TR_Project),MEMF_ANY|MEMF_CLEAR)))
  {
    app->tra_LastError=TRER_ALLOCMEM;
    return NULL;
  }

  if(!(project->trp_MemPool=TR_CreatePool(MEMF_ANY|MEMF_CLEAR,1024,512)))
  {
    app->tra_LastError=TRER_ALLOCMEM;
    TR_CloseProject(project);
    return NULL;
  }

  if(!(project->trp_Dimensions=(struct TR_Dimensions *)TR_AllocPooled(project->trp_MemPool,sizeof(struct TR_Dimensions))))
  {
    app->tra_LastError=TRER_ALLOCMEM;
    TR_CloseProject(project);
    return NULL;
  }

  /* Set basic IDCMP flags */

  project->trp_IDCMPFlags=
    IDCMP_CLOSEWINDOW|
    IDCMP_REFRESHWINDOW|
    IDCMP_CHANGEWINDOW|
    IDCMP_ACTIVEWINDOW|
    IDCMP_INACTIVEWINDOW|
    IDCMP_MENUPICK|
    IDCMP_RAWKEY;

  /* Prepare the object and menu lists */

  NewList((struct List *)&(project->trp_MenuList));
  NewList((struct List *)&(project->trp_IDList));

  /* Fill in the defaults */

  project->trp_App=app;
  project->trp_EscClose=TRUE;
  project->trp_DelZip=TRUE;
  project->trp_Underscore='_';
  project->trp_PubScreenFallBack=TRUE;
  project->trp_FontFallBack=TRUE;

  if((((struct TR_AppPrefs *)(app->tra_Prefs))->flags)&TRPF_SIMPLEREFRESH) {winTags[0].ti_Data&=(~WFLG_SMART_REFRESH); winTags[0].ti_Data|=WFLG_SIMPLE_REFRESH;}

  realnewdata.project=project;

  /* Install the backfill hook */

  if(!(project->trp_BackfillHook=(struct Hook *)TR_AllocPooled(project->trp_MemPool,sizeof(struct Hook))))
  {
    app->tra_LastError=TRER_ALLOCMEM;
    TR_CloseProject(project);
    return NULL;
  }
  project->trp_BackfillHook->h_Entry=(ULONG (* )())TR_BackfillFunc;
  project->trp_BackfillHook->h_Data=(APTR)project;
  project->trp_BackfillType=TRBF_WINDOWBACK;

  /* Process the tags */

  for(;;)
  {
    if((tags[i].ti_Tag)==TAG_END) break;
    tagData=tags[i].ti_Data;
    switch(tags[i].ti_Tag)
    {
      case TAG_IGNORE:
        break;

      case TRWI_Title:
        winTags[2].ti_Data=tagData;
        break;

      case TRWI_ScreenTitle:
        project->trp_ScreenTitle=(STRPTR)tagData;
        break;

      case TRWI_Flags:
        project->trp_Flags|=tagData;
        if(tagData&TRWF_BACKDROP)
        {
          winTags[0].ti_Data|=(WFLG_BACKDROP|WFLG_BORDERLESS);
          winTags[0].ti_Data&=(~(WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_SIZEGADGET));
          winTags[6].ti_Tag=TAG_IGNORE;
          isdepthgadget=FALSE;
          isclosegadget=FALSE;
          dozoom=FALSE;
          dozip=FALSE;
        }
        if(tagData&TRWF_NODRAGBAR) winTags[0].ti_Data&=(~WFLG_DRAGBAR);
        if(tagData&TRWF_NODEPTHGADGET) { winTags[0].ti_Data&=(~WFLG_DEPTHGADGET); isdepthgadget=FALSE; }
        if(tagData&TRWF_NOCLOSEGADGET) { winTags[0].ti_Data&=(~WFLG_CLOSEGADGET); isclosegadget=FALSE; }
        if(tagData&TRWF_NOZIPGADGET) { winTags[6].ti_Tag=TAG_IGNORE; dozip=FALSE; }
        if(tagData&TRWF_NOACTIVATE) winTags[0].ti_Data&=(~WFLG_ACTIVATE);
        if(tagData&TRWF_NOESCCLOSE) project->trp_EscClose=FALSE;
        if(tagData&TRWF_NODELZIP) project->trp_DelZip=FALSE;
        if(tagData&TRWF_NOPSCRFALLBACK) project->trp_PubScreenFallBack=FALSE;
        if(tagData&TRWF_ZIPCENTERTOP) zipcentertop=TRUE;
        if(tagData&TRWF_NOMINTEXTWIDTH) mintextwidth=FALSE;
        if(tagData&TRWF_NOSIZEGADGET) { winTags[0].ti_Data&=(~WFLG_SIZEGADGET); dozoom=FALSE; }
        if(tagData&TRWF_NOFONTFALLBACK) project->trp_FontFallBack=FALSE;
        if(tagData&TRWF_HELP) { winTags[13].ti_Data=TRUE; project->trp_IDCMPFlags|=IDCMP_MENUHELP; }
        if(tagData&TRWF_SYSTEMACTION) project->trp_IDCMPFlags|=(IDCMP_DISKINSERTED|IDCMP_DISKREMOVED);
        break;

      case TRWI_CustomScreen:
        winTags[3].ti_Tag=WA_CustomScreen;
        winTags[3].ti_Data=tagData;
        break;

      case TRWI_PubScreen:
        winTags[3].ti_Tag=WA_PubScreen;
        winTags[3].ti_Data=tagData;
        break;

      case TRWI_PubScreenName:
        winTags[3].ti_Data=tagData;
        break;

      case TRWI_Underscore:
        project->trp_Underscore=((UBYTE *)tagData)[0];
        break;

      case TRWI_Position:
        positioning=tagData;
        break;

      case TRWI_PropFontAttr:
        project->trp_PropAttr=(struct TextAttr *)tagData;
        break;

      case TRWI_FixedWidthFontAttr:
        project->trp_FixedWidthAttr=(struct TextAttr *)tagData;
        break;

      case TRWI_Backfill:
        project->trp_BackfillType=tagData;
        break;

      case TRWI_QuickHelp:
        if(tagData) project->trp_Flags|=TRWF_QUICKHELP;
	else project->trp_Flags&=(~TRWF_QUICKHELP);
        break;

      case TRWI_ID:
        project->trp_ID=tagData;
        break;

      case TRWI_Dimensions:
        project->trp_UserDimensions=(struct TR_Dimensions *)tagData;
        project->trp_UserDimensions->trd_Zoomed=FALSE;
        CopyMem((APTR)(project->trp_UserDimensions),(APTR)(project->trp_Dimensions),sizeof(struct TR_Dimensions));
        break;

      case TRMN_Title:
        if(!firstmenuitem) firstmenuitem=&tags[i];
        menuitems++;
        break;

      case TRMN_Item:
        menuitems++;
        break;

      case TRMN_Sub:
        menuitems++;
        break;

      default:
        if(TR_GetTagType(tags[i].ti_Tag)==TRTG_CLS)
        {
          if(firstobjitem) break;
          realnewdata.firstitem=&(tags[i+1]);
          realnewdata.itemdata=tagData;
          realnewdata.parseargs=TRUE;
          firstobjitem=&(tags[i]);
          globalobject=tags[i].ti_Tag;
          hasObjects=TRUE;
        }
        break;
    }
    i++;
  }

  /* Load the window dimensions */

  TR_LoadWindowDimensions(project);

  /* Clear RMBTRAP if a menu is to be created */

  if(menuitems) winTags[0].ti_Data&=(~WFLG_RMBTRAP);

  /* Apply screen manager changes to screen specification */

  if(winTags[3].ti_Tag!=WA_CustomScreen)
  {
    switch(((struct TR_AppPrefs *)(app->tra_Prefs))->pubscreen[0])
    {
      case 1: /* Program default */
        break;

      case 2: /* Default */
        winTags[3].ti_Tag=WA_PubScreenName;
        winTags[3].ti_Data=NULL;
        break;

      case 3: /* Workbench */
        winTags[3].ti_Tag=WA_PubScreenName;
        winTags[3].ti_Data=(ULONG)("Workbench");
        break;

      default: /* Specified screen */
        winTags[3].ti_Tag=WA_PubScreenName;
        winTags[3].ti_Data=(ULONG)(((struct TR_AppPrefs *)(app->tra_Prefs))->pubscreen);
        break;
    }
  }

  /* Lock public screen */

  if(winTags[3].ti_Tag==WA_PubScreenName)
  {
    if(!(project->trp_LockedPubScreen=TR_LockPubScreen((STRPTR)(winTags[3].ti_Data))))
    {
      if(project->trp_PubScreenFallBack) project->trp_LockedPubScreen=LockPubScreen(NULL);
    }
    if(!(project->trp_LockedPubScreen))
    {
      TR_CloseProject(project);
      app->tra_LastError=TRER_NOLOCKPUBSCREEN;
      return NULL;
    }
    winTags[3].ti_Tag=WA_PubScreen;
    winTags[3].ti_Data=(ULONG)(project->trp_LockedPubScreen);
  }

  /* Get window title */

  wintitle=(STRPTR)(winTags[2].ti_Data);

  /* Get screen related data */

  project->trp_Screen=(struct Screen *)(winTags[3].ti_Data);
  project->trp_ScreenType=winTags[3].ti_Tag;

  if(!(project->trp_DrawInfo=GetScreenDrawInfo(project->trp_Screen)))
  {
    TR_CloseProject(project);
    app->tra_LastError=TRER_DRAWINFO;
    return NULL;
  }

  if(project->trp_Screen->Flags&SCREENHIRES)
  {
    closewidth=20;
    toprightwidth=24;
    bottomgadgetheight=TR_GetBottomBorderHeight(project->trp_Screen);
  }
  else
  {
    closewidth=15;
    toprightwidth=18;
    bottomgadgetheight=11;
  }

  /* Prepare fonts */

  if(!project->trp_PropAttr) project->trp_PropAttr=project->trp_Screen->Font;
  project->trp_PropFont=OpenDiskFont(project->trp_PropAttr);

  if(project->trp_PropFont) project->trp_OpenedPropFont=TRUE;
  else /* Fall back */
  {
    project->trp_PropAttr=&topaz8attr;
    project->trp_PropFont=OpenDiskFont(project->trp_PropAttr);
    if(project->trp_PropFont) project->trp_OpenedPropFont=TRUE;
    else
    {
      TR_CloseProject(project);
      app->tra_LastError=TRER_OPENFONT;
      return NULL;
    }
  }

  if(!project->trp_FixedWidthAttr)
  {
    project->trp_FixedWidthFont=GfxBase->DefaultFont;
    if(!(project->trp_FixedWidthAttr=(struct TextAttr *)TR_AllocPooled(project->trp_MemPool,sizeof(struct TextAttr))))
    {
      TR_CloseProject(project);
      app->tra_LastError=TRER_ALLOCMEM;
      return NULL;
    }
    project->trp_FixedWidthAttr->ta_Name=project->trp_FixedWidthFont->tf_Message.mn_Node.ln_Name;
    project->trp_FixedWidthAttr->ta_Flags=project->trp_FixedWidthFont->tf_Flags;
    project->trp_FixedWidthAttr->ta_Style=project->trp_FixedWidthFont->tf_Style;
    project->trp_FixedWidthAttr->ta_YSize=project->trp_FixedWidthFont->tf_YSize;
  }
  else
  {
    if(project->trp_FixedWidthFont=OpenDiskFont(project->trp_FixedWidthAttr)) project->trp_OpenedFixedWidthFont=TRUE; /* Yes, we've opened it ourselves */
  }

  if(!project->trp_FixedWidthFont) /* Fall back */
    {
      project->trp_FixedWidthAttr=&topaz8attr;
      project->trp_FixedWidthFont=OpenDiskFont(project->trp_FixedWidthAttr);
      if(project->trp_FixedWidthFont)
	project->trp_OpenedFixedWidthFont=TRUE; /* Yes, we've opened it ourselves */
      else
	{
	  TR_CloseProject(project);
	  app->tra_LastError=TRER_OPENFONT;
	  return NULL;
	}
    }

  project->trp_TotalPropFontHeight=max(project->trp_PropFont->tf_YSize,project->trp_PropFont->tf_Baseline+1);

  /* Precalculate maximum border sizes */

  maxborderheight=project->trp_Screen->WBorTop+(project->trp_Screen->Font->ta_YSize+1)+bottomgadgetheight;
  maxborderwidth=project->trp_Screen->WBorLeft+project->trp_Screen->WBorRight;

  /* Get screenmode data */

  screenmodeID=GetVPModeID(&project->trp_Screen->ViewPort);
  if(screenmodeID!=INVALID_ID) if(TR_GetDisplayInfoData((UBYTE *)&diminfo,sizeof(struct DimensionInfo),DTAG_DIMS,screenmodeID)>0)
  {
    if((diminfo.Nominal.MaxX-diminfo.Nominal.MinX==1023)&&(diminfo.Nominal.MaxY-diminfo.Nominal.MinY==1023))
      project->trp_AspectFixing=16;
    else project->trp_AspectFixing=(((diminfo.Nominal.MaxX-diminfo.Nominal.MinX+1)/320)*16)/((diminfo.Nominal.MaxY-diminfo.Nominal.MinY+1)/200);
    if(!(project->trp_AspectFixing)) project->trp_AspectFixing=16;
  }

  /* Create all objects */

  realnewdata.objecttype=globalobject;
  realnewdata.project=project;
  realnewdata.backfilltype=project->trp_BackfillType;

  if(hasObjects)
  {
    if(!(CreateContext(&(project->trp_GadToolsGadgetList))))
    {
      TR_CloseProject(project);
      app->tra_LastError=TRER_GT_CREATECONTEXT;
      return NULL;
    }
    CopyMem((APTR)(&realnewdata),(APTR)(&newdata),sizeof(struct TROM_NewData));
    if(!(project->trp_RootObject=(struct TROD_DisplayObject *)TR_DoMethod(NULL,TROM_NEW,(APTR)(&newdata))))
    {
      TR_CloseProject(project);
      return NULL;
    }
    if((project->trp_RootObject->MinWidth+maxborderwidth>project->trp_Screen->Width)
       ||(project->trp_RootObject->MinHeight+maxborderheight>project->trp_Screen->Height))
    {
      if(project->trp_FontFallBack)
      {
        /* Fall back to topaz.8... */
        project->trp_PropAttr=&topaz8attr;
        project->trp_PropFont=OpenDiskFont(project->trp_PropAttr);
        if(project->trp_PropFont) project->trp_OpenedPropFont=TRUE;
        else
        {
          TR_CloseProject(project);
          app->tra_LastError=TRER_OPENFONT;
          return NULL;
        }
        project->trp_FixedWidthAttr=&topaz8attr;
        project->trp_FixedWidthFont=OpenDiskFont(project->trp_FixedWidthAttr);
        if(project->trp_FixedWidthFont) project->trp_OpenedFixedWidthFont=TRUE;
        else
        {
          TR_CloseProject(project);
          app->tra_LastError=TRER_OPENFONT;
          return NULL;
        }
        project->trp_TotalPropFontHeight=max(project->trp_PropFont->tf_YSize,project->trp_PropFont->tf_Baseline+1);
        /* ...and try again */
        TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_DISPOSE,NULL);
        NewList((struct List *)&(project->trp_IDList));
        CopyMem((APTR)(&realnewdata),(APTR)(&newdata),sizeof(struct TROM_NewData));
        project->trp_RootObject=(struct TROD_DisplayObject *)TR_DoMethod(NULL,TROM_NEW,(APTR)(&newdata));
	if((project->trp_RootObject->MinWidth+maxborderwidth>project->trp_Screen->Width)
	   ||(project->trp_RootObject->MinHeight+maxborderheight>project->trp_Screen->Height))
        {
          TR_CloseProject(project);
          app->tra_LastError=TRER_WINDOWTOOBIG;
          return NULL;
        }
      }
      else
      {
        TR_CloseProject(project);
        app->tra_LastError=TRER_WINDOWTOOBIG;
        return NULL;
      }
    }

    if(project->trp_RootObject->XResize==FALSE) winTags[9].ti_Data=0;
    if(project->trp_RootObject->YResize==FALSE) winTags[10].ti_Data=0;
  }

  if((!hasObjects) || ((!project->trp_RootObject->XResize) && (!project->trp_RootObject->YResize)))
  {
    winTags[0].ti_Data&=(~WFLG_SIZEGADGET);
    dozoom=FALSE;
  }

  /* Calculate top border gadget width */

  if(!hasObjects) { dozoom=FALSE; dozip=FALSE; }
  if(dozoom||dozip) iszoomgadget=TRUE; else iszoomgadget=FALSE;
  if(isclosegadget) topgadgetswidth+=closewidth;

  if(iszoomgadget) topgadgetswidth+=(2*toprightwidth)-2;
  else if(isdepthgadget) topgadgetswidth+=toprightwidth-1;

  /* Precalculate border dimensions */

  project->trp_TopBorder=project->trp_Screen->WBorTop;
  project->trp_BottomBorder=project->trp_Screen->WBorBottom;
  project->trp_LeftBorder=project->trp_Screen->WBorLeft;
  project->trp_RightBorder=project->trp_Screen->WBorRight;
  if((winTags[2].ti_Data)||
    ((winTags[0].ti_Data)&(WFLG_DRAGBAR))||
    iszoomgadget||isdepthgadget||isclosegadget)
    project->trp_TopBorder+=(project->trp_Screen->Font->ta_YSize+1);
  if(dozoom) project->trp_BottomBorder=bottomgadgetheight;

  /* Calculate minimum window size */

  if(hasObjects)
  {
    minwidth  = project->trp_LeftBorder+project->trp_RightBorder + project->trp_RootObject->MinWidth;
    minheight = project->trp_TopBorder+project->trp_BottomBorder + project->trp_RootObject->MinHeight;

    if(mintextwidth)
    {
      if(((ULONG)TextLength(&(project->trp_Screen->RastPort),wintitle,TR_FirstOccurance(0L,wintitle))+21+topgadgetswidth)>minwidth)
        minwidth=(ULONG)TextLength(&(project->trp_Screen->RastPort),wintitle,TR_FirstOccurance(0L,wintitle))+21+topgadgetswidth;
    }
  }
  else /* No objects */
  {
    minwidth=(ULONG)TextLength(&(project->trp_Screen->RastPort),wintitle,TR_FirstOccurance(0L,wintitle))+21+topgadgetswidth;
    minheight=project->trp_TopBorder;
    winTags[6].ti_Tag=TAG_IGNORE;              /* Don't allow zipping       */
    winTags[0].ti_Data&=(~WFLG_SIZEGADGET);    /* Remove size & zoom gadget */
  }

  /* Set real window size */

  winTags[4].ti_Data = minwidth; /* Normal */
  winTags[5].ti_Data = minheight;

  winTags[11].ti_Data = minwidth; /* Minimum */
  winTags[12].ti_Data = minheight;

  if(winTags[0].ti_Data&WFLG_BACKDROP)
  {
    winTags[4].ti_Data=project->trp_Screen->Width;
    winTags[5].ti_Data=project->trp_Screen->Height-project->trp_Screen->Font->ta_YSize-3;
    positioning=TRWP_BELOWTITLEBAR;
  }

  /* Correct window size according to dimensions structure */

  if(hasObjects)
  {
    if((project->trp_Dimensions->trd_Width>winTags[4].ti_Data)
      &&(project->trp_Dimensions->trd_Width<=project->trp_Screen->Width)
      &&(project->trp_RootObject->XResize))
      winTags[4].ti_Data=project->trp_Dimensions->trd_Width;
    if((project->trp_Dimensions->trd_Height>winTags[5].ti_Data)
      &&(project->trp_Dimensions->trd_Height<=project->trp_Screen->Height)
      &&(project->trp_RootObject->YResize))
      winTags[5].ti_Data=project->trp_Dimensions->trd_Height;
  }

  /* Set various window parameters */

  project->trp_WindowStdHeight=minheight; /* winTags[5].ti_Data; */
  if(!iszoomgadget) project->trp_DelZip=FALSE;

  /* Set the window position */

  switch(positioning)
  {
    case TRWP_BELOWTITLEBAR:
      winTags[8].ti_Data=project->trp_Screen->Font->ta_YSize+3;
      break;
    case TRWP_CENTERTOP:
      if((project->trp_Screen->Width)>=(winTags[4].ti_Data)) winTags[7].ti_Data=((project->trp_Screen->Width)-(winTags[4].ti_Data))/2;
      break;
    case TRWP_TOPLEFTSCREEN:
      break;
    case TRWP_CENTERDISPLAY:
      if(screenmodeID!=INVALID_ID)
      {
        if(QueryOverscan(screenmodeID,&displayrect,OSCAN_TEXT))
        {
          displayleft=max(0,-project->trp_Screen->LeftEdge);
          displaytop=max(0,-project->trp_Screen->TopEdge);
          displaywidth=displayrect.MaxX-displayrect.MinX+1;
          displayheight=displayrect.MaxY-displayrect.MinY+1;
          if(project->trp_Screen->TopEdge>0) displayheight-=project->trp_Screen->TopEdge;
          displayheight=min(displayheight,project->trp_Screen->Height);
          displaywidth=min(displaywidth,project->trp_Screen->Width);
          if((displaywidth)>=(winTags[4].ti_Data)) winTags[7].ti_Data=(((displaywidth)-(winTags[4].ti_Data))/2)+displayleft;
          else centeronscreen=TRUE;
          if((displayheight)>=(winTags[5].ti_Data)) winTags[8].ti_Data=(((displayheight)-(winTags[5].ti_Data))/2)+displaytop;
          else centeronscreen=TRUE;
        }
        else centeronscreen=TRUE;
      }
      else centeronscreen=TRUE;
      if(!centeronscreen) break;
    case TRWP_CENTERSCREEN:
      if((project->trp_Screen->Width)>=(winTags[4].ti_Data)) winTags[7].ti_Data=((project->trp_Screen->Width)-(winTags[4].ti_Data))/2;
      if((project->trp_Screen->Height)>=(winTags[5].ti_Data)) winTags[8].ti_Data=((project->trp_Screen->Height)-(winTags[5].ti_Data))/2;
      break;
    case TRWP_MOUSEPOINTER:
      winTags[7].ti_Data=max((LONG)((project->trp_Screen->MouseX)-((winTags[4].ti_Data)/2)),0);
      winTags[8].ti_Data=max((LONG)((project->trp_Screen->MouseY)-((winTags[5].ti_Data)/2)),0);
      break;
    default:
      if(hasObjects) winTags[8].ti_Data=project->trp_Screen->Font->ta_YSize+3; /* BELOWTITLEBAR */
      else if((project->trp_Screen->Width)>=(winTags[4].ti_Data)) winTags[7].ti_Data=((project->trp_Screen->Width)-(winTags[4].ti_Data))/2; /* CENTERTOP */
      break;
  }

  /* Correct window position according to dimensions structure */

  if(project->trp_Dimensions->trd_Width) winTags[7].ti_Data=project->trp_Dimensions->trd_Left;
  if(project->trp_Dimensions->trd_Height) winTags[8].ti_Data=project->trp_Dimensions->trd_Top;

  /* Calculate the zip dimensions */

  #ifndef TR_OS39
  if(TR_Global.trg_OSVersion<39) project->trp_Flags&=(~TRWF_ZIPTOCURRENTPOS);
  #endif

  if(winTags[6].ti_Tag==WA_Zoom) /* Zoom */
  {
    winTags[6].ti_Data=(ULONG)(project->trp_ZipDimensions);
    project->trp_ZipDimensions[2]=TextLength(&(project->trp_Screen->RastPort),wintitle,TR_FirstOccurance(0L,wintitle))+21+topgadgetswidth; /* Width */
    project->trp_ZipDimensions[3]=project->trp_TopBorder; /* Height */
    if(zipcentertop)
    {
      if((project->trp_Screen->Width)>=(project->trp_ZipDimensions[2])) project->trp_ZipDimensions[0]=(WORD)(((project->trp_Screen->Width)-(project->trp_ZipDimensions[2]))/2); /* Left */
      project->trp_ZipDimensions[1]=0; /* Top */
    }
    else
    {
      project->trp_ZipDimensions[0]=(WORD)(winTags[7].ti_Data); /* Left */
      project->trp_ZipDimensions[1]=(WORD)(winTags[8].ti_Data); /* Top */
    }
  }
  if((winTags[0].ti_Data)&(WFLG_SIZEGADGET)) /* Resize */
  {
    winTags[6].ti_Tag=WA_Zoom;
    winTags[6].ti_Data=(ULONG)(project->trp_ZipDimensions);
    project->trp_ZipDimensions[2]=winTags[4].ti_Data*3/2;
    project->trp_ZipDimensions[3]=winTags[5].ti_Data*3/2;

    if(positioning>=TRWP_MAGIC)
    {
      if(project->trp_RootObject->XResize)
	project->trp_ZipDimensions[0]=max((WORD)(winTags[7].ti_Data)-((WORD)(winTags[4].ti_Data/4)),0);
      if(project->trp_RootObject->YResize)
	project->trp_ZipDimensions[1]=max((WORD)(winTags[8].ti_Data)-((WORD)(winTags[5].ti_Data/4)),0);
    }
    else
    {
      project->trp_ZipDimensions[0]=(WORD)(winTags[7].ti_Data); /* Left */
      project->trp_ZipDimensions[1]=(WORD)(winTags[8].ti_Data); /* Top */
    }
  }

  /* Correct alternate dimensions according to dimensions structure */

  if(hasObjects)
  {
    /* Size */
    if((project->trp_Dimensions->trd_Width2>=minwidth)
      &&(project->trp_Dimensions->trd_Width2<=project->trp_Screen->Width)
      &&(project->trp_RootObject->XResize))
      project->trp_ZipDimensions[2]=project->trp_Dimensions->trd_Width2;
    if((project->trp_Dimensions->trd_Height2>=minheight)
      &&(project->trp_Dimensions->trd_Height2<=project->trp_Screen->Height)
      &&(project->trp_RootObject->YResize))
      project->trp_ZipDimensions[3]=project->trp_Dimensions->trd_Height2;

    /* Position */
    if((project->trp_Dimensions->trd_Width2))
      project->trp_ZipDimensions[0]=project->trp_Dimensions->trd_Left2;
    if((project->trp_Dimensions->trd_Height2))
      project->trp_ZipDimensions[1]=project->trp_Dimensions->trd_Top2;
  }

  if(project->trp_Flags&TRWF_ZIPTOCURRENTPOS)
  {
    project->trp_ZipDimensions[0]=(WORD)(~0);
    project->trp_ZipDimensions[1]=(WORD)(~0);
  }

  /* Get the inner coordinates of the window */

  project->trp_InnerWidth=winTags[4].ti_Data-project->trp_LeftBorder-project->trp_RightBorder;
  project->trp_InnerHeight=winTags[5].ti_Data-project->trp_TopBorder-project->trp_BottomBorder;

  /* Open the window */

  if(!(window=OpenWindowTagList(NULL,winTags)))
  {
    TR_CloseProject(project);
    app->tra_LastError=TRER_OPENWINDOW;
    return NULL;
  }
  window->UserData=(APTR)project;
  project->trp_Window=window;

  /* Install the global message port in the window */

  window->UserPort=app->tra_IDCMPPort;
  if(project->trp_Flags&TRWF_QUICKHELP)
  {
    project->trp_IDCMPFlags|=(IDCMP_MOUSEMOVE|IDCMP_INTUITICKS|IDCMP_MOUSEBUTTONS);
    project->trp_Window->Flags|=WFLG_REPORTMOUSE;
  }
  ModifyIDCMP(window,project->trp_IDCMPFlags);

  /* Set screen title */
  if(project->trp_ScreenTitle) SetWindowTitles(window,(STRPTR)(-1),project->trp_ScreenTitle);

  /* Make window an application window */
  if(project->trp_Flags&TRWF_APPWINDOW)
  {
    if(!(app->tra_AppPort))
    {
      if(!(app->tra_AppPort=CreateMsgPort()))
      {
        TR_CloseProject(project);
        app->tra_LastError=TRER_CREATEMSGPORT;
        return NULL;
      }
      app->tra_BitMask|=1<<app->tra_AppPort->mp_SigBit;
    }
    project->trp_AppWindow=AddAppWindowA((ULONG)project,NULL,window,app->tra_AppPort,NULL);
  }

  /* Get the visual info */

  if(!(project->trp_VisualInfo=GetVisualInfoA(project->trp_Window->WScreen,NULL)))
  {
    TR_CloseProject(project);
    app->tra_LastError=TRER_NOLOCKPUBSCREEN;
    return NULL;
  }

  /* Draw the backfill pattern */

  TR_DoBackfill(project);

  /* Create the menus */

  if(menuitems!=0)
  {
    if(app->tra_LastError=TR_CreateMenus(project,firstmenuitem,menuitems))
    {
      TR_CloseProject(project);
      return NULL;
    }
  }

  /* Get current window dimensions */

  project->trp_OldWidth=project->trp_Window->Width;
  project->trp_OldHeight=project->trp_Window->Height;
  TR_GetWindowDimensions(project);

  /* Install the display objects */

  if(hasObjects)
  {
    /* Allocate NewGadget structure */
    if(!(project->trp_NewGadget=(struct NewGadget *)AllocMem(sizeof(struct NewGadget),MEMF_ANY|MEMF_CLEAR)))
    {
      app->tra_LastError=TRER_ALLOCMEM;
      TR_CloseProject(project);
      return NULL;
    }
    project->trp_NewGadget->ng_VisualInfo=project->trp_VisualInfo;
    project->trp_NewGadget->ng_TextAttr=project->trp_PropAttr;

    project->trp_PrevGadget=project->trp_GadToolsGadgetList;

    installdata.left=project->trp_LeftBorder;
    installdata.top=project->trp_TopBorder;
    installdata.width=project->trp_InnerWidth;
    installdata.height=project->trp_InnerHeight;

    if(!TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_INSTALL,(APTR)(&installdata)))
    {
      TR_CloseProject(project);
      app->tra_LastError=TRER_INSTALLOBJECT;
      return NULL;
    }

    AddGList(project->trp_Window,project->trp_GadToolsGadgetList,-1,-1,NULL);
    RefreshGList((struct Gadget *)(project->trp_Window->FirstGadget),project->trp_Window,NULL,-1);
    GT_RefreshWindow(project->trp_Window,NULL);

    if(project->trp_Flags&TRWF_ACTIVATESTRGAD) TR_DoShortcut(project, 9, TR_SHORTCUT_KEYDOWN, NULL);
  }

  return project;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Create the menus //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct TROD_MenuItem
{
  struct TROD_DisplayObject DO;
  ULONG                     MenuNumber;
};

#define MENUITEM ((struct TROD_MenuItem *)object)


ULONG __regargs TR_CreateMenus(struct TR_Project *project, struct TagItem *tags, ULONG items)
{
  struct NewMenu *newmenu;
  ULONG i=0,errorcode=0,strl;
  LONG menunumber=-1;
  STRPTR rmtxt;
  UWORD sepnum;
  struct TROD_MenuItem *object;
  BOOL broken;
  UWORD menun=NOMENU,itemn=NOITEM,subn=NOSUB;
  ULONG tagData;

  /* Allocate the NewMenu structure */

  if(!(newmenu=(struct NewMenu *)
    AllocMem((sizeof(struct NewMenu))*(items+1),MEMF_ANY|MEMF_CLEAR)))
    return TRER_ALLOCMEM;

  /* Fill in the NewMenu structure */

  for(broken=FALSE;broken==FALSE;)
  {
    tagData=tags[i].ti_Data;
    switch(tags[i].ti_Tag)
    {
      case TRMN_Title:
        if(menun==NOMENU) menun=0; else menun++;
        itemn=NOITEM;
        subn=NOSUB;
        newmenu[++menunumber].nm_Type=NM_TITLE;
        strl=TR_FirstOccurance(0,(STRPTR)tagData)+1;
        if(!(rmtxt=(STRPTR)TR_AllocPooled(project->trp_MemPool,strl))) return TRER_ALLOCMEM;
        CopyMem((APTR)tagData,(APTR)rmtxt,strl);
        newmenu[menunumber].nm_Label=rmtxt;
        break;

      case TRMN_Item:
        if(itemn==NOITEM) itemn=0; else itemn++;
        subn=NOSUB;
        newmenu[++menunumber].nm_Type=NM_ITEM;
        if((STRPTR)tagData==NM_BARLABEL) newmenu[menunumber].nm_Label=NM_BARLABEL;
        else
        {
          strl=TR_FirstOccurance(0,(STRPTR)tagData)+1;
          if(!(rmtxt=(STRPTR)TR_AllocPooled(project->trp_MemPool,strl))) return TRER_ALLOCMEM;
          CopyMem((APTR)tagData,(APTR)rmtxt,strl);
          if(rmtxt[0]==project->trp_Underscore)
          {
            sepnum=TR_FirstOccurance(project->trp_Underscore,&rmtxt[2])+2;
            rmtxt[sepnum]=0;
            newmenu[menunumber].nm_Label=&rmtxt[sepnum+1];
            #ifndef TR_OS39
            if(TR_Global.trg_OSVersion>=39)
            {
            #endif
              newmenu[menunumber].nm_Flags|=NM_COMMANDSTRING;
              newmenu[menunumber].nm_CommKey=&rmtxt[1];
            #ifndef TR_OS39
            }
            #endif
          }
          else if(rmtxt[1]==project->trp_Underscore)
          {
            newmenu[menunumber].nm_CommKey=&rmtxt[0];
            newmenu[menunumber].nm_Label=&rmtxt[2];
          }
          else
          {
            newmenu[menunumber].nm_Label=rmtxt;
          }
        }
        break;

      case TRMN_Sub:
        if(subn==NOSUB) subn=0; else subn++;
        newmenu[++menunumber].nm_Type=NM_SUB;
        if((STRPTR)tagData==NM_BARLABEL) newmenu[menunumber].nm_Label=NM_BARLABEL;
        else
        {
          strl=TR_FirstOccurance(0,(STRPTR)tagData)+1;
          if(!(rmtxt=(STRPTR)TR_AllocPooled(project->trp_MemPool,strl))) return TRER_ALLOCMEM;
          CopyMem((APTR)tagData,(APTR)rmtxt,strl);
          if(rmtxt[0]==project->trp_Underscore)
          {
            sepnum=TR_FirstOccurance(project->trp_Underscore,&rmtxt[2])+2;
            rmtxt[sepnum]=0;
            newmenu[menunumber].nm_Label=&rmtxt[sepnum+1];
            #ifdef TR_OS39
            if(TR_Global.trg_OSVersion>=39)
            {
            #endif
              newmenu[menunumber].nm_Flags|=NM_COMMANDSTRING;
              newmenu[menunumber].nm_CommKey=&rmtxt[1];
            #ifdef TR_OS39
            }
            #endif
          }
          else if(rmtxt[1]==project->trp_Underscore)
          {
            newmenu[menunumber].nm_CommKey=&rmtxt[0];
            newmenu[menunumber].nm_Label=&rmtxt[2];
          }
          else
          {
            newmenu[menunumber].nm_Label=rmtxt;
          }
        }
        break;

      case TRMN_Flags:
        if(tagData&TRMF_CHECKIT) newmenu[menunumber].nm_Flags|=(CHECKIT|MENUTOGGLE);
        if(tagData&TRMF_CHECKED) newmenu[menunumber].nm_Flags|=(CHECKIT|MENUTOGGLE|CHECKED);
        if(tagData&TRMF_DISABLED)
        {
          if(newmenu[menunumber].nm_Type==NM_TITLE) newmenu[menunumber].nm_Flags|=NM_MENUDISABLED;
          else newmenu[menunumber].nm_Flags|=NM_ITEMDISABLED;
        }
        break;

      case TRAT_ID:
        if(!(object=(struct TROD_MenuItem *)TR_AllocPooled(project->trp_MemPool,sizeof(struct TROD_MenuItem)))) return TRER_ALLOCMEM;
        newmenu[menunumber].nm_UserData=(APTR)tagData;
        object->DO.ID=tagData;
        object->MenuNumber=FULLMENUNUM(menun,itemn,subn);
        if(newmenu[menunumber].nm_Type==NM_TITLE)
	  object->DO.O.Class=TR_FindClass(project->trp_App,TRMN_Title);
        else if(newmenu[menunumber].nm_Type==NM_ITEM)
	  object->DO.O.Class=TR_FindClass(project->trp_App,TRMN_Item);
        else if(newmenu[menunumber].nm_Type==NM_SUB)
	  object->DO.O.Class=TR_FindClass(project->trp_App,TRMN_Sub);
        if(!TR_AddObjectToIDList(project,(struct TROD_Object *)object)) return TRER_ALLOCMEM;
        AddTail((struct List *)(&project->trp_MenuList),(struct Node *)object);
        break;

      default:
        broken=TRUE;
        break;
    }
    i++;
  }
  newmenu[++menunumber].nm_Type=NM_END;

  /* Create the menus */

  if(!(project->trp_Menu=CreateMenus(newmenu,GTMN_FrontPen,0,GTMN_SecondaryError,&errorcode,TAG_DONE)))
  {
    if(errorcode==GTMENU_NOMEM) return TRER_ALLOCMEM;
    else return TRER_CREATEMENUS;
  }

  /* Layout the menus */

  if(!LayoutMenus(project->trp_Menu,project->trp_VisualInfo,GTMN_NewLookMenus,TRUE,TAG_DONE)) return TRER_CREATEMENUS;

  /* Apply the menus */

  SetMenuStrip(project->trp_Window,project->trp_Menu);
  project->trp_NewMenu=newmenu;
  project->trp_NewMenuSize=(sizeof(struct NewMenu))*(items+1);

  return TRER_OK;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////// Refresh or resize a window //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID __regargs TR_DoBackfill(struct TR_Project *project)
{
  struct BackFillPacket bfp;
  struct Window *window;

  window=project->trp_Window;

  bfp.layer=window->WLayer;
  bfp.bounds.MinX=window->BorderLeft;
  bfp.bounds.MinY=window->BorderTop;
  bfp.bounds.MaxX=window->Width-window->BorderRight-1;
  bfp.bounds.MaxY=window->Height-window->BorderBottom-1;
  bfp.offsetx=bfp.bounds.MinX;
  bfp.offsety=bfp.bounds.MinY;

  TR_BackfillFunc(project->trp_BackfillHook, window->RPort, &bfp);
}


VOID __regargs TR_RefreshProject(struct TR_Project *project)
{
  struct Window *window;

  window=project->trp_Window;

  GT_BeginRefresh(window);
  if(project->trp_RootObject)
  {
    if(window->Height>=project->trp_WindowStdHeight)
    {
      TR_DoBackfill(project);
      TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_REFRESH,NULL);
    }
  }
  /* Next 2 lines needed only for simple refresh */
  RefreshGList((struct Gadget *)(project->trp_Window->FirstGadget),project->trp_Window,NULL,-1);
  GT_RefreshWindow(project->trp_Window,NULL);
  GT_EndRefresh(window,TRUE);
}


BOOL __inline TR_ResizeProject(struct TR_Project *project)
{
  struct TROM_InstallData installdata;
  struct Window *window;
  BOOL retval=TRUE;

  window=project->trp_Window;

  if((project->trp_RootObject)&&(window->Height>=project->trp_WindowStdHeight))
  {
    if(!project->trp_IsUserLocked) TR_LockWindow(project);

    GT_BeginRefresh(window);
    GT_EndRefresh(window,TRUE);

    TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_PREGTREMOVE,NULL);
    RemoveGList(project->trp_Window,project->trp_GadToolsGadgetList,-1);
    if(project->trp_GadToolsGadgetList->NextGadget) FreeGadgets(project->trp_GadToolsGadgetList->NextGadget);
    project->trp_PrevGadget=project->trp_GadToolsGadgetList;
    TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_REMOVE,NULL);

    TR_DoBackfill(project);

    installdata.left=project->trp_LeftBorder;
    installdata.top=project->trp_TopBorder;
    installdata.width=project->trp_InnerWidth;
    installdata.height=project->trp_InnerHeight;

    if(!TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_INSTALL,(APTR)(&installdata)))
      retval=FALSE;

    AddGList(project->trp_Window,project->trp_GadToolsGadgetList,-1,-1,NULL);

    /* TR_DoBackfill(project); */
    /* TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_REFRESH,NULL); */

    GT_RefreshWindow(project->trp_Window,NULL); /* Required for GadTools Listview refresh */
    RefreshWindowFrame(window);
    if(!project->trp_IsUserLocked) TR_UnlockWindow(project);
  }
  else
  {
    GT_BeginRefresh(window);
    GT_EndRefresh(window,TRUE);
  }

  return retval;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Some helping functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

ULONG __regargs TR_GetDisplayInfoData(UBYTE *buf, ULONG size, ULONG tagID, ULONG displayID)
{
  return GetDisplayInfoData(FindDisplayInfo(displayID), buf, size, tagID, displayID);
}


ULONG __regargs TR_GetBottomBorderHeight(struct Screen *scr)
{
  struct DrawInfo *dri;
  APTR obj;
  ULONG h=10;

  if(dri=GetScreenDrawInfo(scr))
  {
    if(obj=NewObject(NULL,"sysiclass",
                     SYSIA_DrawInfo,dri, SYSIA_Size,SYSISIZE_MEDRES, SYSIA_Which,SIZEIMAGE,
                     TAG_DONE))
    {
      GetAttr(IA_Height,obj,&h);
      DisposeObject(obj);
    }
    FreeScreenDrawInfo(scr,dri);
  }
  return h;
}


/****** triton.library/TR_FirstOccurance ******
*
*   NAME	
*	TR_FirstOccurance -- Finds a character in a string.
*
*   SYNOPSIS
*	Position = TR_FirstOccurance(Character, String)
*	D0                           D0         A0
*
*	LONG TR_FirstOccurance(UBYTE, STRPTR);
*
*   FUNCTION
*	Finds the specified character in the string.
*
*   RESULT
*	Position - The position of the first occurance of the
*	character in the string or -1 if the character couldn't
*	be found in the string.
*
******/

LONG __saveds __asm TR_FirstOccurance(register __d0 UBYTE ch, register __a0 STRPTR str)
{
  register LONG i=0;

  if(!str) return 0;

  for(;;)
  {
    if(str[i]==ch) return i;
    if(str[i]==0) return (-1);
    i++;
  }
}


/****** triton.library/TR_NumOccurances ******
*
*   NAME	
*	TR_NumOccurances -- Counts a character in a string.
*
*   SYNOPSIS
*	Number = TR_NumOccurances(Character, String)
*	D0                        D0         A0
*
*	LONG TR_NumOccurances(UBYTE, STRPTR);
*
*   FUNCTION
*	Counts the number of occurances of the character in the string.
*
*   RESULT
*	Number - The number of matching characters found.
*
******/

LONG __saveds __asm TR_NumOccurances(register __d0 UBYTE ch, register __a0 STRPTR str)
{
  LONG i=0,num=0;
  while(str[i]) if(str[i++]==ch) num++;
  return num;
}


VOID __regargs TR_GetWindowDimensions(struct TR_Project *project)
{
  project->trp_LeftBorder = project->trp_Window->BorderLeft;
  project->trp_TopBorder  = project->trp_Window->BorderTop;
  project->trp_InnerWidth = project->trp_Window->Width
                          - project->trp_Window->BorderLeft
                          - project->trp_Window->BorderRight;
  project->trp_InnerHeight= project->trp_Window->Height
                          - project->trp_Window->BorderTop
                          - project->trp_Window->BorderBottom;

  if(((project->trp_Window->Flags&WFLG_ZOOMED)&&(!(project->trp_Dimensions->trd_Zoomed)))
    ||((!(project->trp_Window->Flags&WFLG_ZOOMED))&&(project->trp_Dimensions->trd_Zoomed)))
  {
    project->trp_Dimensions->trd_Zoomed  = (project->trp_Window->Flags&WFLG_ZOOMED)?TRUE:FALSE;
    project->trp_Dimensions->trd_Left2   = project->trp_Dimensions->trd_Left;
    project->trp_Dimensions->trd_Top2    = project->trp_Dimensions->trd_Top;
    project->trp_Dimensions->trd_Width2  = project->trp_Dimensions->trd_Width;
    project->trp_Dimensions->trd_Height2 = project->trp_Dimensions->trd_Height;
  }
  project->trp_Dimensions->trd_Left    = project->trp_Window->LeftEdge;
  project->trp_Dimensions->trd_Top     = project->trp_Window->TopEdge;
  project->trp_Dimensions->trd_Width   = project->trp_Window->Width;
  project->trp_Dimensions->trd_Height  = project->trp_Window->Height;
}


/****** triton.library/TR_GetErrorString ******
*
*   NAME	
*	TR_GetErrorString -- Creates an error message
*
*   SYNOPSIS
*	Message = TR_GetErrorString(Number)
*	D0                          D0
*
*	STRPTR TR_GetErrorString(UWORD);
*
*   FUNCTION
*	Creates an error message which matches the supplied
*	Triton error code.
*
*   INPUTS
*	Number - Triton error code. In most cases you will
*	         get this with TR_GetLastError().
*
*   RESULT
*	Message - Pointer to a user-readable error message
*	          or an empty string ("") if none available.
*
*   BUGS
*	In older Triton versions, TR_GetErrorString() did
*	return NULL instead of an empty string. This is
*	fixed in V4.
*
*   SEE ALSO
*	TR_GetLastError()
*
******/

STRPTR __saveds __asm TR_GetErrorString(register __d0 UWORD num)
{
  ULONG locnum;
  static const char *emptyString="";
  STRPTR errorString;

  switch(num)
  {
    case TRER_OK:
      return emptyString;
    case TRER_ALLOCMEM:
      locnum=MSG_ERROR_ALLOCMEM;
      break;
    case TRER_OPENWINDOW:
      locnum=MSG_ERROR_OPENWINDOW;
      break;
    case TRER_WINDOWTOOBIG:
      locnum=MSG_ERROR_WINDOWTOOBIG;
      break;
    case TRER_DRAWINFO:
      locnum=MSG_ERROR_DRAWINFO;
      break;
    case TRER_OPENFONT:
      locnum=MSG_ERROR_OPENFONT;
      break;
    case TRER_CREATEMSGPORT:
      locnum=MSG_ERROR_CREATEMSGPORT;
      break;
    case TRER_INSTALLOBJECT:
      locnum=MSG_ERROR_INSTALLOBJECT;
      break;
    case TRER_CREATECLASS:
      locnum=MSG_ERROR_CREATECLASS;
      break;
    case TRER_NOLOCKPUBSCREEN:
      locnum=MSG_ERROR_NOLOCKPUBSCREEN;
      break;
    case TRER_CREATEMENUS:
      locnum=MSG_ERROR_CREATEMENUS;
      break;
    case TRER_GT_CREATECONTEXT:
      locnum=MSG_ERROR_GADGETCONTEXT;
      break;
    default:
      locnum=MSG_ERROR_UNKNOWN;
  }

  if(errorString=LOCSTR(locnum)) return errorString;
  else return emptyString;
}


/****** triton.library/TR_GetLastError ******
*
*   NAME	
*	TR_GetLastError -- Gets the last error code
*
*   SYNOPSIS
*	Number = TR_GetLastError(App)
*	D0                       A1
*
*	UWORD TR_GetLastError(struct TR_App *);
*
*   FUNCTION
*	Returns the TRER code of the last error which occured
*	in the application and sets the internal tra_LastError
*	back to TRER_OK.
*
*   INPUTS
*	App - Pointer to a Triton Application
*
*   RESULT
*	Number - TRER error code
*
*   SEE ALSO
*	TR_GetErrorString()
*
******/

UWORD __saveds __asm TR_GetLastError(register __a1 struct TR_App *app)
{
  UWORD error;

  error=app->tra_LastError;
  app->tra_LastError=0;

  return error;
}


VOID __stdargs TR_SPrintF (STRPTR buf, STRPTR format, ...)
{
  RawDoFmt(format, &format+1, (void (*))"\x16\xC0\x4E\x75", buf);
}


ULONG __regargs TR_CountListEntries(struct List *list)
{
  struct Node *worknode, *nextnode;
  ULONG numlines=0;

  if(!list) return NULL;
  if((ULONG)list==~0) return NULL;

  worknode=(struct Node *)(list->lh_Head);
  while(nextnode=(struct Node *)(worknode->ln_Succ))
  {
    numlines++;
    worknode=nextnode;
  }
  return numlines;
}


BYTE __regargs TR_StrCmp(STRPTR s1,STRPTR s2)
{
  ULONG i;

  for(i=0;TRUE;i++)
  {
    if(s1[i]!=s2[i]) return 1;
    else if((s1[i]==0)&&(s2[i]==0)) return 0;
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////// Global message port support functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID __regargs __inline TR_StripIntuiMessages(struct MsgPort *mp, struct Window *win)
{
  struct IntuiMessage *msg;
  struct Node *succ;

  msg=(struct IntuiMessage *)mp->mp_MsgList.lh_Head;
  while(succ=msg->ExecMessage.mn_Node.ln_Succ)
  {
    if(msg->IDCMPWindow==win)
    {
      Remove((struct Node *)msg);
      ReplyMsg((struct Message *)msg);
    }
    msg=(struct IntuiMessage *)succ;
  }
}


/****** triton.library/TR_CloseWindowSafely ******
*
*   NAME	
*	TR_CloseWindowSafely -- Closes as window with a shared IDCMP port.
*
*   SYNOPSIS
*	TR_CloseWindowSafely(Window)
*	                     A0
*
*	VOID TR_CloseWindowSafely(struct Window *);
*
*   FUNCTION
*	Closes a window which shares its IDCMP port with another window.
*	All the pending messages (concerning this window) on the port
*	will be removed and the window will be closed.
*	
*	Do *NOT* use this function to close windows which have an IDCMP
*	port set up by Intuition. If you do the port will be left in memory!
*	
*	If you intend to open a lot of windows all sharing the same IDCMP
*	port it is easiest if you create a port yourself and open all
*	windows with newwin.IDCMPFlags set to 0 (this tells Intuition NOT to
*	set up an IDCMP port). After opening the window set win->UserPort
*	to your message port and call ModifyIDCMP() to set your IDCMP flags.
*	
*	When you then receive messages from Intuition check their
*	imsg->IDCMPWindow field to find out what window they came from
*	and act upon them.
*	
*	When closing your windows call TR_CloseWindowSafely() for all of
*	them and delete your message port.
*
*   INPUTS
*	Window - pointer to the window to be closed.
*
*   NOTE
*	This function is for the advanced Triton user.
*
*   SEE ALSO
*	intuition.library/CloseWindow()
*
******/

VOID __saveds __asm TR_CloseWindowSafely(register __a0 struct Window *win)
{
  Forbid();
  TR_StripIntuiMessages(win->UserPort,win);
  win->UserPort=NULL;
  ModifyIDCMP(win,NULL);
  Permit();
  CloseWindow(win);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Class management //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_AddClass ******
*
*   NAME	
*	TR_AddClass -- Add a class to Triton's class management. (V6)
*
*   SYNOPSIS
*	Success = TR_AddClass(Application, Tag, SuperTag,
*	                      A1           D0   D1
*	                      DefaultMethod, DataSize, Tags)
*	                      A2             D2        A0
*
*	BOOL TR_AddClass(struct TR_App *, ULONG, ULONG, TR_Method,
*	                 struct TR_Class *, struct TagItem *);
*
*   FUNCTION
*	Add a class to Triton's class management. Objects of the class
*	may then be used in TR_OpenProject(). You don't have to remove
*	the classes. This is done automatically when the application
*	is deleted.
*
*   RESULT
*	Success - FALSE if the class couldn't be initialized.
*
******/

BOOL __saveds __asm TR_AddClass(register __a1 struct TR_App *app, register __d0 ULONG tag,
				register __d1 ULONG superTag, register __a2 TR_Method defaultMethod,
				register __d2 ULONG datasize, register __a0 struct TagItem *tags)
{
  ULONG i;
  struct TR_Class *classnode;
  TR_Method method;

  if(app)
    {
      if(!(classnode=TR_AllocPooled(app->tra_MemPool,sizeof(struct TR_Class)))) return FALSE;
    }
  else if(!(classnode=TR_AllocPooled(TR_Global.trg_ClassListPool,sizeof(struct TR_Class)))) return FALSE;

  classnode->trc_Tag=tag;
  classnode->trc_Dispatcher[0]=defaultMethod;
  classnode->trc_SizeOfClassData=datasize;
  classnode->trc_SuperClass=TR_FindClass(NULL,superTag);

  if((!defaultMethod)&&classnode->trc_SuperClass) for(i=1;i<24;i++)
  {
    classnode->trc_Dispatcher[i]=classnode->trc_SuperClass->trc_Dispatcher[i];
    classnode->trc_MetaClass[i]=classnode->trc_SuperClass->trc_MetaClass[i];
  }

  if(tags) for(i=0;tags[i].ti_Tag;i++)
  {
    classnode->trc_Dispatcher[tags[i].ti_Tag]=(TR_Method)(tags[i].ti_Data);
    classnode->trc_MetaClass[tags[i].ti_Tag]=classnode;
  }

  if(app) AddTail((struct List *)&(app->tra_ClassList),(struct Node *)classnode);
  else AddTail((struct List *)&(TR_Global.trg_ClassList),(struct Node *)classnode);

  if(!(method=classnode->trc_Dispatcher[TROM_CREATECLASS]))
    method=defaultMethod;
  if(method) if((*method)(NULL,TROM_CREATECLASS,NULL,classnode)) return FALSE;

  return TRUE;
}


VOID __regargs __inline TR_DisposeClasses(struct MinList *list)
{
  TR_Method method;
  struct TR_Class *classnode;

  for(classnode=(struct TR_Class *)(list->mlh_Head);
      classnode->trc_Node.mln_Succ;
      classnode=(struct TR_Class *)(classnode->trc_Node.mln_Succ))
  {
    if(!(method=classnode->trc_Dispatcher[TROM_DISPOSECLASS]))
      method=classnode->trc_Dispatcher[0];
    if(method) (*method)(NULL,TROM_DISPOSECLASS,NULL,classnode);
  }
}


/****i* triton.library/TR_FindClass ******
*
*   NAME	
*	TR_FindClass -- Get a class pointer from a class ID
*
*   SYNOPSIS
*	Class = TR_FindClass(App, ID)
*
*	struct TR_Class *TR_FindClass(struct TR_App *, ULONG);
*
*   FUNCTION
*	Find a class given by a class ID (i.e. a project tag). Set App
*	to NULL if you only want the global class list to be searched.
*
*   RESULT
*	Class - A class pointer or NULL if the class doesn't exist.
*
******/

struct TR_Class * __regargs TR_FindClass(struct TR_App *app, ULONG tag)
{
  struct TR_Class *classnode;

  for(classnode=(struct TR_Class *)(TR_Global.trg_ClassList.mlh_Head);
      classnode->trc_Node.mln_Succ;
      classnode=(struct TR_Class *)(classnode->trc_Node.mln_Succ))
    if(classnode->trc_Tag==tag) return classnode;

  if(app)
    for(classnode=(struct TR_Class *)(app->tra_ClassList.mlh_Head);
	classnode->trc_Node.mln_Succ;
	classnode=(struct TR_Class *)(classnode->trc_Node.mln_Succ))
      if(classnode->trc_Tag==tag) return classnode;

  return NULL;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Object management //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_DoMethodClass ******
*
*   NAME	
*	TR_DoMethodClass -- Dispatch a method through a meta-class. (V6)
*
*   SYNOPSIS
*	Result = TR_DoMethodClass(Object, MessageID, Data, Class)
*	                          A0      D0         A1    A2
*
*	ULONG TR_DoMethodClass(struct TROD_Object *, ULONG, APTR,
*	                       struct TR_Class *);
*
*   FUNCTION
*	Dispatch a method to an object as if the object was of the
*	specified class.
*
*   RESULT
*	Depends on the class and method being called.
*
*   SEE ALSO
*	TR_DoMethod()
*
******/

ULONG __saveds __asm TR_DoMethodClass(register __a0 struct TROD_Object *object,
				      register __d0 ULONG messageid, register __a1 APTR data,
				      register __a2 struct TR_Class *cl)
{
  TR_Method method;
  struct TR_Class *metaclass;

  if(method=cl->trc_Dispatcher[messageid]) metaclass=cl->trc_MetaClass[messageid];
  else
  {
    if(!(method=cl->trc_Dispatcher[0])) return 0;
    metaclass=cl;
  }
  return (*method)(object,messageid,data,metaclass);
}


/****** triton.library/TR_DoMethod ******
*
*   NAME	
*	TR_DoMethod -- Dispatch a method. (V6)
*
*   SYNOPSIS
*	Result = TR_DoMethod(Object, MessageID, Data)
*	                     A0      D0         A1
*
*	ULONG TR_DoMethod(struct TROD_Object *, ULONG, APTR);
*
*   FUNCTION
*	Dispatch a method to an object.
*
*   RESULT
*	Depends on the class and method being called.
*
*   SEE ALSO
*	TR_DoMethodClass()
*
******/

ULONG __saveds __asm TR_DoMethod(register __a0 struct TROD_Object *object,
				 register __d0 ULONG messageid, register __a1 APTR data)
{
  struct TR_Class *cl;

  if(messageid==TROM_NEW)
  {
    if(!(cl=TR_FindClass(((struct TROM_NewData *)data)->project->trp_App,
			 ((struct TROM_NewData *)data)->objecttype))) return 0;
    if(!(object=TR_AllocPooled(((struct TROM_NewData *)data)->project->trp_MemPool,
			       cl->trc_SizeOfClassData))) return 0;
    object->Class=cl;
  }
  else cl=object->Class;

  return TR_DoMethodClass(object,messageid,data,cl);
}


VOID __regargs TR_DoMethodID(struct TR_Project *project, ULONG objectid, ULONG method, APTR data)
{
  struct TR_IDNode *idnode;

  for(idnode=(struct TR_IDNode *)(project->trp_IDList.mlh_Head);
      idnode->tri_Node.mln_Succ;
      idnode=(struct TR_IDNode *)(idnode->tri_Node.mln_Succ))
    {
      if(idnode->tri_ID==objectid)
	if(TR_GetTagType(idnode->tri_Object->Class->trc_Tag)==TRTG_CLS)
	  if(!(((struct TROD_DisplayObject *)(idnode->tri_Object))->Flags&TROB_DISPLAYOBJECT_DISABLED))
	    TR_DoMethod(idnode->tri_Object,method,data);
    }
}


/****** triton.library/TR_SendMessage ******
*
*   NAME	
*	TR_SendMessage -- Send a message to one or more objects. (V4)
*
*   SYNOPSIS
*	TR_SendMessage(Project, ID, MessageID, MessageData)
*	               A0       D0  D1         A1
*
*	ULONG TR_SendMessage(struct TR_Project *, ULONG,
*	                     ULONG, void *);
*
*   FUNCTION
*	Sends an object message, specified by its ID (TROM_...)
*	and the message data to one or more objects of a project
*	which share the specified ID. By specifying an ID of NULL,
*	you can send a message to the project itself.
*
*   SEE ALSO
*	Class descriptions, TR_SetAttribute, TR_GetAttribute()
*
******/

ULONG __saveds __asm TR_SendMessage(register __a0 struct TR_Project *project, register __d0 ULONG objectid, register __d1 ULONG messageid, register __a1 void *messagedata)
{
  struct TR_IDNode *idnode;
  struct TROD_DisplayObject *object;
  ULONG retval=0;

  /*-- if(!objectid) return 0; No window messages available at the moment */

  for(idnode=(struct TR_IDNode *)(project->trp_IDList.mlh_Head);
      idnode->tri_Node.mln_Succ;
      idnode=(struct TR_IDNode *)(idnode->tri_Node.mln_Succ))
  {
    if(idnode->tri_ID==objectid)
    {
      object=(struct TROD_DisplayObject *)(idnode->tri_Object);
      if(!((object->O.Class->trc_Tag>=TRMN_Title)
	   &&(object->O.Class->trc_Tag<=TRMN_Sub))) /* No menu */
	retval=TR_DoMethod(object,messageid,(APTR)messagedata);
    }
  }

  return retval;
}


/****** triton.library/TR_SetAttribute ******
*
*   NAME	
*	TR_SetAttribute -- Sets an attribute of an object.
*
*   SYNOPSIS
*	TR_SetAttribute(Project, ID, Attribute, Value)
*	                A0       D0  D1         D2
*
*	VOID TR_SetAttribute(struct TR_Project *, ULONG,
*	                     ULONG, ULONG);
*
*   FUNCTION
*	Sets an attribute of a Triton object. Only attributes
*	of objects with an ID can be changed. You can change the
*	default attribute of an object by specifying 0 as
*	the attribute to change. By specifying an ID of 0, you
*	can change those attributes of a Triton project which are
*	marked with '(changeable)' in the TR_OpenProject docs.
*
*   SEE ALSO
*	Class descriptions, TR_GetAttribute(), TR_OpenProject()
*
******/

VOID __saveds __asm TR_SetAttribute(register __a0 struct TR_Project *project, register __d0 ULONG objectid, register __d1 ULONG attribute, register __d2 ULONG value)
{
  struct TROM_SetAttributeData sadata;
  struct TR_IDNode *idnode;
  struct TROD_DisplayObject *object;
  UWORD menun,itemn,subn,i;
  struct Menu *currentmenu;
  struct MenuItem *currentitem;

  if(!objectid)
  {
    switch(attribute)
    {
      case TRWI_Title:
        SetWindowTitles(project->trp_Window,(STRPTR)value,(STRPTR)(-1));
        break;
      case TRWI_ScreenTitle:
        project->trp_ScreenTitle=(STRPTR)value;
        SetWindowTitles(project->trp_Window,(STRPTR)(-1),(STRPTR)value);
        break;
      case TRWI_QuickHelp:
        if(value)
	{
	  project->trp_Flags|=TRWF_QUICKHELP;
	  project->trp_IDCMPFlags|=(IDCMP_MOUSEMOVE|IDCMP_INTUITICKS|IDCMP_MOUSEBUTTONS);
          project->trp_Window->Flags|=WFLG_REPORTMOUSE;
	  ModifyIDCMP(project->trp_Window,project->trp_IDCMPFlags);
	}
	else
	{
	  project->trp_Flags&=~TRWF_QUICKHELP;
          project->trp_Window->Flags&=~WFLG_REPORTMOUSE;
	}
        TR_UpdateQuickHelp(project,0,0,TRUE);
        break;
    }
    return;
  }

  sadata.attribute=attribute;
  sadata.value=value;

  for(idnode=(struct TR_IDNode *)(project->trp_IDList.mlh_Head);
      idnode->tri_Node.mln_Succ;
      idnode=(struct TR_IDNode *)(idnode->tri_Node.mln_Succ))
  {
    if(idnode->tri_ID==objectid)
    {
      object=(struct TROD_DisplayObject *)(idnode->tri_Object);
      if((object->O.Class->trc_Tag>=TRMN_Title)&&(object->O.Class->trc_Tag<=TRMN_Sub))
      {
        if(attribute==TRAT_Disabled)
        {
          if(value) OffMenu(project->trp_Window,MENUITEM->MenuNumber);
          else OnMenu(project->trp_Window,MENUITEM->MenuNumber);
        }
        else
        {
          /* Get menu number */
          menun=MENUNUM(MENUITEM->MenuNumber);
          itemn=ITEMNUM(MENUITEM->MenuNumber);
          subn=SUBNUM(MENUITEM->MenuNumber);
          /* Get pointer to menu item */
          currentmenu=project->trp_Menu;
          for(i=0;i<menun;i++) currentmenu=currentmenu->NextMenu;
          currentitem=currentmenu->FirstItem;
          for(i=0;i<itemn;i++) currentitem=currentitem->NextItem;
          if(subn!=NOSUB)
          {
            currentitem=currentitem->SubItem;
            for(i=0;i<subn;i++) currentitem=currentitem->NextItem;
          }
          /* Set attribute */
          ClearMenuStrip(project->trp_Window);
          if(value) currentitem->Flags|=CHECKED;
          else currentitem->Flags&=(~CHECKED);
          ResetMenuStrip(project->trp_Window,project->trp_Menu);
        }
      }
      else TR_DoMethod(object,TROM_SETATTRIBUTE,(APTR)(&sadata));
    }
  }
}


/****** triton.library/TR_GetAttribute ******
*
*   NAME	
*	TR_GetAttribute -- Gets an attribute of an object.
*
*   SYNOPSIS
*	value = TR_GetAttribute(Project, ID, Attribute)
*	D0                      A0       D0  D1
*
*	ULONG TR_GetAttribute(struct TR_Project *, ULONG,
*	                      ULONG);
*
*   FUNCTION
*	Gets an attribute of a Triton object. Only attributes
*	of objects with an ID can be queried.
*
*   RESULT
*	value - Value of the specified attribute. Depends
*	        on specific class and attribute.
*
*   SEE ALSO
*	Class descriptions, TR_SetAttribute()
*
******/

ULONG __saveds __asm TR_GetAttribute(register __a0 struct TR_Project *project, register __d0 ULONG objectid, register __d1 ULONG attribute)
{
  struct TR_IDNode *idnode;
  ULONG attval=NULL;
  struct TROD_DisplayObject *object;
  UWORD menun,itemn,subn,i;
  struct Menu *currentmenu;
  struct MenuItem *currentitem;

  for(idnode=(struct TR_IDNode *)(project->trp_IDList.mlh_Head);
      idnode->tri_Node.mln_Succ;
      idnode=(struct TR_IDNode *)(idnode->tri_Node.mln_Succ))
  {
    if(idnode->tri_ID==objectid)
    {
      object=(struct TROD_DisplayObject *)(idnode->tri_Object);
      if((object->O.Class->trc_Tag>=TRMN_Title)&&(object->O.Class->trc_Tag<=TRMN_Sub))
      {
        /* Get menu number */
        menun=MENUNUM(MENUITEM->MenuNumber);
        itemn=ITEMNUM(MENUITEM->MenuNumber);
        subn=SUBNUM(MENUITEM->MenuNumber);
        /* Get pointer to menu item */
        currentmenu=project->trp_Menu;
        for(i=0;i<menun;i++) currentmenu=currentmenu->NextMenu;
        currentitem=currentmenu->FirstItem;
        for(i=0;i<itemn;i++) currentitem=currentitem->NextItem;
        if(subn!=NOSUB)
        {
          currentitem=currentitem->SubItem;
          for(i=0;i<subn;i++) currentitem=currentitem->NextItem;
        }
        /* Get attribute */
        if(attribute==TRAT_Disabled) attval=(currentitem->Flags&ITEMENABLED)?FALSE:TRUE;
        else if(attribute==TRAT_Value) attval=(currentitem->Flags&CHECKED)?TRUE:FALSE;
      }
      else attval=TR_DoMethod(object,TROM_GETATTRIBUTE,(APTR)attribute);
    }
    if(attval) break;
  }

  return attval;
}

struct TROD_DisplayObject * __regargs TR_ObjectFromPlace(struct TR_Project *project, UWORD x, UWORD y)
{
  struct TROM_HitData hitdata;

  if(!project->trp_RootObject) return 0L;
  hitdata.x=x;
  hitdata.y=y;
  hitdata.object=NULL;
  TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_HIT,(APTR)(&hitdata));

  return hitdata.object;
}


ULONG __regargs TR_IdFromPlace(struct TR_Project *project, UWORD x, UWORD y)
{
  struct TROD_DisplayObject *object=TR_ObjectFromPlace(project,x,y);
  return object ? object->ID : 0;
}


ULONG __regargs TR_GetTagType(ULONG tag)
{
  tag&=~(TRTG_SER(0xFFFF)|TAG_USER);
  if(tag&0x400) return TRTG_OAT;
  if(tag&0x300) return TRTG_CLS;
  if(tag==201) return TRTG_CLS; /* TRGR_Horiz */
  if(tag==202) return TRTG_CLS; /* TRGR_Vert  */
  if(tag&0x80) return TRTG_OAT;
  return TRTG_PAT;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Object list management //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct TROD_Object * __regargs TR_AddObjectToIDList(struct TR_Project *project, struct TROD_Object *object)
{
  struct TR_IDNode *idnode;

  if(((struct TROD_DisplayObject *)(object))->ID)
  {
    idnode=(struct TR_IDNode *)TR_AllocPooled(project->trp_MemPool,sizeof(struct TR_IDNode));
    if(!idnode)
    {
      project->trp_App->tra_LastError=TRER_ALLOCMEM;
      return NULL;
    }
    idnode->tri_ID=((struct TROD_DisplayObject *)(object))->ID;
    idnode->tri_Object=object;
    AddTail((struct List *)(&(project->trp_IDList)),(struct Node *)idnode);
  }

  return object;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// GadTools support //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Gadget * __regargs TR_CreateGadget(struct TR_Project *project, struct TROD_Object *object, ULONG kind, ULONG left, ULONG top, ULONG width, ULONG height, struct TagItem *tags)
{
  struct Gadget *gad;

  project->trp_NewGadget->ng_LeftEdge=left;
  project->trp_NewGadget->ng_TopEdge=top;
  project->trp_NewGadget->ng_Width=width;
  project->trp_NewGadget->ng_Height=height;
  project->trp_NewGadget->ng_UserData=(APTR)object;

  if(gad=CreateGadgetA(kind,project->trp_PrevGadget,project->trp_NewGadget,tags))
    project->trp_PrevGadget=gad;

  return gad;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Window blocking system //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef TR_OS39
static const UWORD chip TR_BusyPointerData[]=
{
  0x0000,0x0000,0x0400,0x07C0,0x0000,0x07C0,0x0100,0x0380,
  0x0000,0x07E0,0x07C0,0x1FF8,0x1FF0,0x3FEC,0x3FF8,0x7FDE,
  0x3FF8,0x7FBE,0x7FFC,0xFF7F,0x7EFC,0xFFFF,0x7FFC,0xFFFF,
  0x3FF8,0x7FFE,0x3FF8,0x7FFE,0x1FF0,0x3FFC,0x07C0,0x1FF8,
  0x0000,0x07E0,0x0000,0x0000
};
#endif


VOID __regargs TR_LockWindow(struct TR_Project *project)
{
  if(project->trp_InvisibleRequest) return;
  project->trp_InvisibleRequest=(struct Requester *)AllocMem(sizeof(struct Requester),MEMF_CLEAR);
  if(project->trp_InvisibleRequest) Request(project->trp_InvisibleRequest,project->trp_Window);
}


VOID __regargs TR_UnlockWindow(struct TR_Project *project)
{
  if(project->trp_InvisibleRequest)
  {
    EndRequest(project->trp_InvisibleRequest,project->trp_Window);
    FreeMem((void *)(project->trp_InvisibleRequest),sizeof(struct Requester));
    project->trp_InvisibleRequest=NULL;
  }
}


/****** triton.library/TR_LockProject ******
*
*   NAME	
*	TR_LockProject -- Locks a Triton project.
*
*   SYNOPSIS
*	TR_LockProject(Project)
*	               A0
*
*	VOID TR_LockProject(struct TR_Project *);
*
*   FUNCTION
*	Locks a Triton project. Only window resizing will
*	still work in a locked project. All other kinds of
*	input (i.e. all input which requires interaction
*	by your program and not only by Triton) are not
*	possible.
*
*   SEE ALSO
*	TR_UnlockProject()
*
******/

VOID __saveds __asm TR_LockProject(register __a0 struct TR_Project *project)
{
  project->trp_IsUserLocked=TRUE;
  TR_LockWindow(project);
  #ifndef TR_OS39
  if(TR_Global.trg_OSVersion>=39)
  #endif
    SetWindowPointer(project->trp_Window,WA_BusyPointer,TRUE,WA_PointerDelay,TRUE,TAG_END);
  #ifndef TR_OS39
  else SetPointer(project->trp_Window,(UWORD *)TR_BusyPointerData,16,16,-6,0);
  #endif
}


/****** triton.library/TR_UnlockProject ******
*
*   NAME	
*	TR_UnlockProject -- Unlocks a Triton project.
*
*   SYNOPSIS
*	TR_UnlockProject(Project)
*	                 A0
*
*	VOID TR_UnlockProject(struct TR_Project *);
*
*   FUNCTION
*	Unlocks a Triton project previously locked by
*	TR_LockProject().
*
*   SEE ALSO
*	TR_LockProject()
*
******/

VOID __saveds __asm TR_UnlockProject(register __a0 struct TR_Project *project)
{
  TR_UnlockWindow(project);
  project->trp_IsUserLocked=FALSE;
  ClearPointer(project->trp_Window);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////// Window locking protocol //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_ObtainWindow ******
*
*   NAME	
*	TR_ObtainWindow -- Get a project's window. (V3)
*
*   SYNOPSIS
*	window = TR_ObtainWindow(Project)
*	D0                       A0
*
*	struct Window * TR_ObtainWindow(struct TR_Project *);
*
*   FUNCTION
*	Lock the window of a Triton project for non-Triton window
*	operations (e.g. activating a window or bringing it to the
*	front). Do not manipulate the contents of Triton windows!
*	Locked windows must be freed again with TR_UnlockWindow().
*	Locking/unlocking calls are nested.
*
*   RESULT
*	window - Pointer to the project's Window. A value of NULL should
*	         be quietly ignored. NULL simply indicates that there is
*	         currently no window available.
*
*   SEE ALSO
*	TR_UnlockWindow()
*
******/

struct Window * __asm __saveds TR_ObtainWindow(register __a0 struct TR_Project *project)
{
  return project->trp_Window;
}


/****** triton.library/TR_ReleaseWindow ******
*
*   NAME	
*	TR_ReleaseWindow -- Release a project's window. (V3)
*
*   SYNOPSIS
*	TR_ReleaseWindow(Window)
*	                A0
*
*	VOID TR_ReleaseWindow(struct Window *);
*
*   FUNCTION
*	Unlock a window which has been locked by TR_ObtainWindow(). All
*	locked windows must be unlocked! Locking/unlocking calls are
*	nested.
*
*   SEE ALSO
*	TR_ObtainWindow()
*
******/

VOID __asm __saveds TR_ReleaseWindow(register __a0 struct Window *screen)
{
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Application management //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_CreateApp ******
*
*   NAME	
*	TR_CreateApp -- Creates a Triton application.
*	TR_CreateAppTags -- Varargs stub for TR_CreateApp.
*
*   SYNOPSIS
*	app = TR_CreateApp(TagList)
*	D0                 A1
*
*	struct TR_App * TR_CreateApp(struct TagItem *);
*
*	app = TR_CreateAppTags(Tag1,...)
*
*	struct TR_App * TR_CreateApp(ULONG,...);
*
*   FUNCTION
*	Creates an application. An application is required
*	for opening windows and polling messages. All projects
*	of an application will share one IDCMP port and one
*	memory pool.
*
*   TAGS
*	TRCA_Name        - (STRPTR)
*	                   Unique name for the application. Must not be
*	                   longer than 20 characters. Case-insensitive.
*	                   ' ', '/', '.' and ':' are not allowed.
*	TRCA_LongName    - (STRPTR)
*	                   A user-readable name for the application.
*	                   Up to 60 characters allowed.
*	TRCA_Info        - (STRPTR)
*	                   Information about the application. Should not
*	                   be more than 2 lines with 60 characters each.
*	TRCA_Version     - (STRPTR)
*	                   Internal version of the application.
*	TRCA_Release     - (STRPTR)
*	                   Release number of the application.
*	TRCA_Date        - (STRPTR)
*	                   Creation/compilation date. Should be given
*	                   in standard version string format.
*	
*	Example:
*	  Name        : DilloCreate
*	  LongName    : Armadillo Creator
*	  Info        : Part of the Armadillo Management System.
*	                © 1994 by DilloWorks Enterprises.
*	  Version     : 42.135
*	  Release     : 2.1bß3
*	  Date        : 17.6.94
*
*   RESULT
*	app - A pointer to the created application structure.
*	      NULL indicates failure.
*
*   SEE ALSO
*	TR_DeleteApp()
*
******/

struct TR_App * __saveds __asm TR_CreateApp(register __a1 struct TagItem *apptags)
{
  struct TR_App *app;
  void *pool;
  struct TagItem *tstate,*tag;
  ULONG strsize;

  /* Allocate structure */

  if(!(pool=TR_CreatePool(MEMF_ANY|MEMF_CLEAR,1024,512))) return NULL;
  if(!(app=(struct TR_App *)TR_AllocPooled(pool,sizeof(struct TR_App)))) {TR_DeletePool(pool); return NULL;}
  app->tra_MemPool=pool;

  /* Create some stuff */

  NewList((struct List *)&(app->tra_ClassList));
  NewList((struct List *)&(app->tra_MsgList));
  if(!(app->tra_IDCMPPort=CreateMsgPort())) goto cleanup;
  if(!(app->tra_InputEvent=(struct InputEvent *)AllocVec(sizeof(struct InputEvent),MEMF_ANY|MEMF_CLEAR))) goto cleanup;

  /* Set IDCMP signal bit */

  app->tra_BitMask=1<<app->tra_IDCMPPort->mp_SigBit;

  /* Go through tags and allocate other entries via the pool */

  tstate=apptags;
  while(tag=NextTagItem(&tstate))
  {
    switch(tag->ti_Tag)
    {
      case TRCA_Name:
        strsize=TR_FirstOccurance(0L,(STRPTR)(tag->ti_Data))+1;
        if(!(app->tra_Name=(STRPTR)TR_AllocPooled(pool,strsize))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_Name),strsize);
        break;
      case TRCA_LongName:
        strsize=TR_FirstOccurance(0L,(STRPTR)(tag->ti_Data))+1;
        if(!(app->tra_LongName=(STRPTR)TR_AllocPooled(pool,strsize))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_LongName),strsize);
        break;
      case TRCA_Info:
        strsize=TR_FirstOccurance(0L,(STRPTR)(tag->ti_Data))+1;
        if(!(app->tra_Info=(STRPTR)TR_AllocPooled(pool,strsize))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_Info),strsize);
        break;
      case TRCA_Version:
        strsize=TR_FirstOccurance(0L,(STRPTR)(tag->ti_Data))+1;
        if(!(app->tra_Version=(STRPTR)TR_AllocPooled(pool,strsize))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_Version),strsize);
        break;
      case TRCA_Release:
        strsize=TR_FirstOccurance(0L,(STRPTR)(tag->ti_Data))+1;
        if(!(app->tra_Release=(STRPTR)TR_AllocPooled(pool,strsize))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_Release),strsize);
        break;
      case TRCA_Date:
        strsize=TR_FirstOccurance(0L,(STRPTR)(tag->ti_Data))+1;
        if(!(app->tra_Date=(STRPTR)TR_AllocPooled(pool,strsize))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_Date),strsize);
        break;
      case TRCA_MagicPrefs:
        if(!(app->tra_Prefs=TR_AllocPooled(app->tra_MemPool,sizeof(struct TR_AppPrefs)))) goto cleanup;
        CopyMem((APTR)(tag->ti_Data),(APTR)(app->tra_Prefs),sizeof(struct TR_AppPrefs));
        break;
      default:
        break;
    }
  }

  TR_SaveAppInfos(app);
  if(!app->tra_Prefs) TR_LoadTritonPrefs(app);

  return app;

  cleanup:
    TR_DeleteApp(app);
    return NULL;
}


/****** triton.library/TR_DeleteApp ******
*
*   NAME	
*	TR_DeleteApp -- Deletes a Triton application.
*
*   SYNOPSIS
*	TR_DeleteApp(App)
*	             A1
*
*	VOID TR_DeleteApp(struct TR_App *);
*
*   FUNCTION
*	Deletes an application created by TR_CreateApp().
*
*   NOTES
*	All windows have to be closed before deleting the
*	corresponding application!
*
*   SEE ALSO
*	TR_CreateApp()
*
******/

VOID __saveds __asm TR_DeleteApp(register __a1 struct TR_App *app)
{
  struct Message *msg;

  if(app)
  {
    TR_DisposeClasses(&(app->tra_ClassList));
    if(app->tra_IDCMPPort)
    {
      while(msg=GetMsg(app->tra_IDCMPPort)) ReplyMsg(msg);
      DeleteMsgPort(app->tra_IDCMPPort);
    }
    if(app->tra_AppPort)
    {
      while(msg=GetMsg(app->tra_AppPort)) ReplyMsg(msg);
      DeleteMsgPort(app->tra_AppPort);
    }
    if(app->tra_InputEvent) FreeVec(app->tra_InputEvent);
    TR_DeletePool(app->tra_MemPool);
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////// Broadcasting system //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_CreateMsg ******
*
*   NAME	
*	TR_CreateMsg -- Create an application message. (V6)
*
*   SYNOPSIS
*	message = TR_CreateMsg(App)
*	D0                     A1
*
*	struct TR_Message * TR_CreateMsg(struct TR_App *);
*
*   FUNCTION
*	Creates an empty message to be filled in by a custom
*	class which wants to send a user message. The message
*	is automatically added to the application's message
*	queue (which is emptied by user-level calls to
*	TR_GetMsg()). The trm_App field of the message is
*	initialized to the supplied app. When called within
*	a method which is invoked by TR_GetMsg() (i.e. an
*	event-handling method) trm_Project, trm_Seconds,
*	trm_Micros and trm_Qualifier are also initialized.
*
*   SEE ALSO
*	TR_GetMsg(), TR_ReplyMsg()
*
******/

struct TR_Message * __saveds __asm TR_CreateMsg(register __a1 struct TR_App *app)
{
  struct TR_Message *m;

  if(m=TR_AllocPooled(app->tra_MemPool,sizeof(struct TR_Message)))
    {
      m->trm_App=app;
      if(app->tra_CurProject)
	{
	  m->trm_Project=app->tra_CurProject;
	  m->trm_Seconds=app->tra_CurSecs;
	  m->trm_Micros=app->tra_CurMicros;
	  m->trm_Qualifier=app->tra_CurQual;
	}
      AddTail((struct List *)&(app->tra_MsgList),(struct Node *)(&(m->trm_Node)));
    }
  else DisplayBeep(NULL); /* We're out of memory. That's the best we can do... */
  return m;
}


/****** triton.library/TR_GetMsg ******
*
*   NAME	
*	TR_GetMsg -- Gets a Triton message.
*
*   SYNOPSIS
*	message = TR_GetMsg(App)
*	D0                  A1
*
*	struct TR_Message * TR_GetMsg(struct TR_App *);
*
*   FUNCTION
*	Gets a message from a Triton application created
*	by TR_CreateApp(). You may first want to wait for
*	a message with TR_Wait().
*
*   NOTES
*	Please reply all messages as quickly as possible
*	with TR_ReplyMsg(). Shutting down an application
*	does not free unreplied messages and resources
*	which are attached to them (like AppMessages).
*
*   SEE ALSO
*	TR_ReplyMsg(), TR_Wait(), TR_CreateMsg()
*
******/

struct TR_Message * __saveds __asm TR_GetMsg(register __a1 struct TR_App *app)
{
  struct IntuiMessage *imsg, ownimsg;
  struct AppMessage *amsg;
  struct TROM_EventData edata;
  BOOL keydown;
  struct TR_Project *project;
  UBYTE buffer, lowerbuffer;
  struct MenuItem *menuitem;
  ULONG menuid,realcode=NULL;
  struct TR_Message *message=NULL;
  struct Node *node;
  UWORD selitem;

  if(node=RemHead((struct List *)&(app->tra_MsgList))) goto finished;

  edata.imsg=&ownimsg;

  while(imsg=GT_GetIMsg(app->tra_IDCMPPort))
  {
    project=(struct TR_Project *)(imsg->IDCMPWindow->UserData);
    CopyMem((APTR)imsg,(APTR)(&ownimsg),sizeof(struct IntuiMessage));
    GT_ReplyIMsg(imsg);
    app->tra_CurProject=project;
    app->tra_CurSecs=imsg->Seconds;
    app->tra_CurMicros=imsg->Micros;
    app->tra_CurQual=imsg->Qualifier;

    if(project->trp_Flags&TRWF_QUICKHELP)
    {
      if(ownimsg.Class==IDCMP_INTUITICKS) project->trp_TicksPassed++;
      else project->trp_TicksPassed=0;
      TR_UpdateQuickHelp(project,ownimsg.MouseX,ownimsg.MouseY,
			 (ownimsg.Class==IDCMP_MOUSEMOVE || ownimsg.Class==IDCMP_INTUITICKS)?FALSE:TRUE);
    }

    switch(ownimsg.Class)
    {
      case IDCMP_INTUITICKS:
        break;

      case IDCMP_CLOSEWINDOW:
	if(message=TR_CreateMsg(app)) message->trm_Class=TRMS_CLOSEWINDOW;
        break;

      case IDCMP_DISKINSERTED:
	if(message=TR_CreateMsg(app)) message->trm_Class=TRMS_DISKINSERTED;
        break;

      case IDCMP_DISKREMOVED:
	if(message=TR_CreateMsg(app)) message->trm_Class=TRMS_DISKREMOVED;
        break;

      case IDCMP_REFRESHWINDOW:
        TR_RefreshProject(project);
        break;

      case IDCMP_CHANGEWINDOW:
        TR_GetWindowDimensions(project);
        if((project->trp_Window->Width!=project->trp_OldWidth)||(project->trp_Window->Height!=project->trp_OldHeight))
        {
          project->trp_OldWidth=project->trp_Window->Width;
          project->trp_OldHeight=project->trp_Window->Height;
          if(!(TR_ResizeProject(project))) if(message=TR_CreateMsg(app))
          {
            message->trm_Class=TRMS_ERROR;
            message->trm_Data=TRER_INSTALLOBJECT;
          }
          TR_DoShortcut(project, 0, TR_SHORTCUT_CANCELLED, &edata);
        }
        break;

      case IDCMP_MENUPICK:
	for(selitem=ownimsg.Code;selitem!=MENUNULL;selitem=menuitem->NextSelect)
	  {
	    menuitem=ItemAddress(project->trp_Menu,selitem);
	    menuid=(ULONG)(GTMENUITEM_USERDATA(menuitem));
	    if(menuid) if(message=TR_CreateMsg(app))
	      {
		message->trm_Project=project;
		message->trm_ID=menuid;
		if(menuitem->Flags&CHECKIT)
		  {
		    message->trm_Class=TRMS_NEWVALUE;
		    message->trm_Data=(menuitem->Flags&CHECKED)? TRUE:FALSE;
		  }
		else message->trm_Class=TRMS_ACTION;
	      }
	  }
	break;

      case IDCMP_ACTIVEWINDOW:
      case IDCMP_INACTIVEWINDOW:
        TR_DoShortcut(project, 0, TR_SHORTCUT_CANCELLED, &edata);
        break;

      case IDCMP_MENUHELP:
        if(ITEMNUM(ownimsg.Code)!=NOITEM) if(message=TR_CreateMsg(app))
        {
          menuitem=ItemAddress(project->trp_Menu,ownimsg.Code);
          message->trm_Class=TRMS_HELP;
          message->trm_ID=(ULONG)(GTMENUITEM_USERDATA(menuitem));
        }
        break;

      case IDCMP_RAWKEY:
        app->tra_InputEvent->ie_Class        = IECLASS_RAWKEY;
        app->tra_InputEvent->ie_Code         = ownimsg.Code;
        app->tra_InputEvent->ie_Qualifier    = ownimsg.Qualifier;
        app->tra_InputEvent->ie_EventAddress = (APTR *) *((ULONG *)ownimsg.IAddress);

        if(app->tra_InputEvent->ie_Code&IECODE_UP_PREFIX)
        {
          app->tra_InputEvent->ie_Code&=~(IECODE_UP_PREFIX);
          keydown=FALSE;
        }
        else keydown=TRUE;

        buffer=0;
        if(MapRawKey(app->tra_InputEvent,&buffer,1,NULL)==1)
        {
          lowerbuffer=tolower(buffer);
          realcode=edata.imsg->Code;
          if(lowerbuffer==buffer) edata.imsg->Code=FALSE; /* unshifted */
          else edata.imsg->Code=TRUE;                     /* shifted   */
          if(keydown)
          {
            if((buffer==27)&&(project->trp_EscClose)) /* Escape */
            {
              if(message=TR_CreateMsg(app)) message->trm_Class=TRMS_CLOSEWINDOW;
            }
            else if(buffer==127)
            {
              if(project->trp_DelZip) ZipWindow(imsg->IDCMPWindow);
            }
            else TR_DoShortcut(project, lowerbuffer, TR_SHORTCUT_KEYDOWN, &edata);
          }
          else TR_DoShortcut(project, lowerbuffer, TR_SHORTCUT_KEYUP, &edata);
        }
        else if((app->tra_InputEvent->ie_Code==96)||(app->tra_InputEvent->ie_Code==97))
        {
          if(app->tra_InputEvent->ie_Qualifier&3)
            TR_DoShortcut(project, 0, TR_SHORTCUT_CANCELLED, &edata);
	  /* else project->trp_IsCancelDown=FALSE; */
        }
        else if(app->tra_InputEvent->ie_Code==95 && project->trp_Flags&TRWF_HELP && keydown)
        {
	  if(message=TR_CreateMsg(app))
            {
              message->trm_Class=TRMS_HELP;
              message->trm_ID=TR_IdFromPlace(project,imsg->MouseX,imsg->MouseY);
            }
	}

	if(node=RemHead((struct List *)&(app->tra_MsgList))) goto finished;

	if(realcode) edata.imsg->Code=realcode;
	if(project->trp_RootObject)
	  TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_EVENT,(APTR)(&edata));

	if(node=RemHead((struct List *)&(app->tra_MsgList))) goto finished;

	if(message=TR_CreateMsg(app))
          {
            message->trm_Class     = TRMS_KEYPRESSED;
            message->trm_Data      = (ULONG)buffer;
            message->trm_Code      = (ULONG)(ownimsg.Code);
            message->trm_Qualifier = (ULONG)(ownimsg.Qualifier);
          }
        break;

      default:
        if(project->trp_RootObject)
	  TR_DoMethod((struct TROD_Object *)(project->trp_RootObject),TROM_EVENT,(APTR)(&edata));
    }

    if(node=RemHead((struct List *)&(app->tra_MsgList))) goto finished;
  }

  if(app->tra_AppPort)
    if(amsg=(struct AppMessage *)GetMsg(app->tra_AppPort))
      if(message=TR_CreateMsg(app))
	{
	  project=(struct TR_Project *)(amsg->am_ID);
	  message->trm_Project=project;
	  message->trm_ID=TR_IdFromPlace(project,amsg->am_MouseX,amsg->am_MouseY);
	  message->trm_Class=TRMS_ICONDROPPED;
	  message->trm_Data=(ULONG)amsg;
	  message->trm_Seconds=amsg->am_Seconds;
	  message->trm_Micros=amsg->am_Micros;
	}

  if(!(node=RemHead((struct List *)&(app->tra_MsgList))))
    {
      app->tra_CurProject=NULL;
      return NULL;
    }

finished:
  app->tra_CurProject=NULL;
  return TR_NODE2MSG(node);
}


/****** triton.library/TR_ReplyMsg ******
*
*   NAME	
*	TR_ReplyMsg -- Replies a Triton message.
*
*   SYNOPSIS
*	TR_ReplyMsg(Message)
*	            A1
*
*	VOID TR_ReplyMsg(struct TR_Message *);
*
*   FUNCTION
*	Replies a message received by TR_GetMsg().
*
*   SEE ALSO
*	TR_GetMsg(), TR_Wait()
*
******/

VOID __saveds __asm TR_ReplyMsg(register __a1 struct TR_Message *message)
{
  if(message)
  {
    if(message->trm_Class==TRMS_ICONDROPPED) ReplyMsg((struct Message *)(message->trm_Data));
    TR_FreePooled(message->trm_App->tra_MemPool,(void *)message,sizeof(struct TR_Message));
  }
}


/****** triton.library/TR_Wait ******
*
*   NAME	
*	TR_Wait -- Waits for exec signals.
*
*   SYNOPSIS
*	Signals = TR_Wait(App, OtherBits)
*	        A1   D0
*
*	ULONG TR_Wait(struct TR_App *, ULONG);
*
*   FUNCTION
*	Waits until a signal of the specified application
*	or one of the other signal bits is set.
*
*   RESULT
*	Signals - The mask of set signals
*
*   SEE ALSO
*	TR_GetMsg(), TR_ReplyMsg()
*
******/

ULONG __saveds __asm TR_Wait(register __a1 struct TR_App *app, register __d0 ULONG otherbits)
{
  return Wait((app->tra_BitMask)|otherbits);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////// Text support functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID __regargs TR_DoShortcut(struct TR_Project *project, UBYTE shortcut, UWORD code, struct TROM_EventData *edata)
{
  struct TR_IDNode *idnode;
  struct TROD_DisplayObject *object;
  BOOL isshortcut,oldscdown;

  for(idnode=(struct TR_IDNode *)(project->trp_IDList.mlh_Head);
      idnode->tri_Node.mln_Succ;
      idnode=(struct TR_IDNode *)(idnode->tri_Node.mln_Succ))
  {
    object=(struct TROD_DisplayObject *)(idnode->tri_Object);
    if(TR_GetTagType(object->O.Class->trc_Tag)==TRTG_CLS)
    {
      isshortcut=FALSE;
      if((object->Shortcut==shortcut)||
	 ( (object->O.Class->trc_Tag==TROB_Button) && /*-- Kludge! */
	   ( ((object->Flags&TROB_DISPLAYOBJECT_RETURNOK)&&(shortcut==13))||
	     ((object->Flags&TROB_DISPLAYOBJECT_ESCOK)&&(shortcut==27)) )
	 )||
	 ( (object->O.Class->trc_Tag==TROB_String) && /*-- Kludge! */
	   ((object->Flags&TROB_DISPLAYOBJECT_TABOK)&&(shortcut==9))
	 )
	) isshortcut=TRUE;

      switch(code)
      {
        case TR_SHORTCUT_KEYDOWN:
          if(isshortcut)
          {
            if((project->trp_CurrentID)&&(project->trp_CurrentID!=idnode->tri_ID)) TR_DoMethodID(project, project->trp_CurrentID, TROM_KEYCANCELLED, (APTR)(edata));
            project->trp_CurrentID=idnode->tri_ID;
            oldscdown=project->trp_IsShortcutDown;
            project->trp_IsShortcutDown=TRUE;
            if(oldscdown) TR_DoMethodID(project, idnode->tri_ID, TROM_REPEATEDKEYDOWN, (APTR)(edata));
            else TR_DoMethodID(project, idnode->tri_ID, TROM_KEYDOWN, (APTR)(edata));
            return;
          }
          break;
        case TR_SHORTCUT_KEYUP:
          if(isshortcut)
          {
            project->trp_CurrentID=NULL;
            TR_DoMethodID(project, idnode->tri_ID, TROM_KEYUP, (APTR)(edata));
            project->trp_IsShortcutDown=FALSE;
            return;
          }
          break;
        case TR_SHORTCUT_CANCELLED:
          TR_DoMethodID(project, project->trp_CurrentID, TROM_KEYCANCELLED, (APTR)(edata));
          project->trp_CurrentID=0;
          /* project->trp_IsCancelDown=TRUE; */
          return;
          break;
      }
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////// Gadget support functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID __regargs TR_SelectGadget(struct TR_Project *project, struct Gadget *gad, BOOL selected)
{
  if(selected) gad->Flags |= GFLG_SELECTED;
    else gad->Flags &= ~(GFLG_SELECTED);
  RefreshGList (gad, project->trp_Window, NULL, 1);
}


VOID __regargs TR_DisableGadget(struct TR_Project *project, struct Gadget *gad, BOOL disabled)
{
  if(disabled) gad->Flags |= GFLG_DISABLED;
    else gad->Flags &= ~(GFLG_DISABLED);
  RefreshGList (gad, project->trp_Window, NULL, 1);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////// Requester functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_AutoRequest ******
*
*   NAME	
*	TR_AutoRequest -- A (relatively ;-) low-level requester function.
*
*   SYNOPSIS
*	selection = TR_AutoRequest(App, Project, TagList)
*	D0                         A1   A0       A2
*
*	ULONG TR_AutoRequest(struct TR_App *, struct TR_Project *,
*	                     struct AppItem *);
*
*	selection = TR_AutoRequestTags(App, Project, Tag,...)
*	D0
*
*	ULONG TR_AutoRequestTags(struct TR_App *, struct TR_Project *,
*	                     struct AppItem *);
*
*   FUNCTION
*	Pops up a requester which is described by the supplied tag list.
*	As soon as a TRMS_ACTION message is sent by one of the objects,
*	the requester will close. If a project is supplied, it will be
*	locked when opening the requester and unlocked when closing it.
*
*   RESULT
*	selection - The ID of the object which triggered the action,
*	            0 for an error, (ULONG)(-1) for the close gadget.
*
*   NOTES
*	Simple requesters with just text and buttons can be done easier
*	with TR_EasyRequest(). If you need more complex requesters, you
*	have to use your own message polling loop instead of
*	TR_AutoRequest(). You may still use the requester macros though.
*
*   SEE ALSO
*	TR_EasyRequest()
*
******/

ULONG __saveds __asm TR_AutoRequest(register __a1 struct TR_App *app, register __a0 struct TR_Project *lockproject, register __a2 struct TagItem *request_trwintags)
{
  struct TR_Project *request_project;
  struct TR_Message *trmsg;
  ULONG id=0;

  if(!(request_project=TR_OpenProject(app,request_trwintags))) return 0;
  if(lockproject) TR_LockProject(lockproject);

  while(!id)
  {
    TR_Wait(app,0);
    while(trmsg=TR_GetMsg(app))
    {
      if(trmsg->trm_Project==request_project)
      {
        if(trmsg->trm_Class==TRMS_ACTION) id=trmsg->trm_ID;
        else if(trmsg->trm_Class==TRMS_CLOSEWINDOW) id=(ULONG)(-1);
      }
      TR_ReplyMsg(trmsg);
    }
  }

  if(lockproject) TR_UnlockProject(lockproject);
  TR_CloseProject(request_project);

  return id;
}


/****** triton.library/TR_EasyRequest ******
*
*   NAME	
*	TR_EasyRequest -- A high-level requester function.
*
*   SYNOPSIS
*	selection = TR_EasyRequest(App, BodyFmt, GadFmt, TagList)
*	D0                         A1   A2       A3      A0
*
*	ULONG TR_EasyRequest(struct TR_App *, STRPTR, STRPTR, struct TagItem *);
*
*	selection = TR_EasyRequestTags(App, BodyFmt, GadFmt, Tag,...)
*	D0
*
*	ULONG TR_EasyRequestTags(struct TR_App *, STRPTR, STRPTR, ULONG,...);
*
*   FUNCTION
*	Pops up a requester and waits for the user to select a gadget.
*
*   INPUTS
*	App       - A valid Triton application.
*	BodyFmt   - A multi-line text which will be displayed in the
*	            requester body. See TR_PrintText() autodoc clip
*	            for details about the formatting sequences.
*	GadFmt    - The gadget texts, separated by '|'.
*	TagList   - Pointer to a TagItem array.
*
*   TAGS
*	TREZ_ReqPos (ULONG) - The requester's position (TRWP_...).
*	    The default is TRWP_MOUSEPOINTER.
*
*	TREZ_LockProject (struct TR_Project *) - This project will be
*	    locked while the requester is displayed. Information about
*	    screen and activity state of the requester are taken from
*	    this project.
*
*	TREZ_Return (ULONG) - Number of the default gadget which can be
*	    activated by <RETURN>. Defaults to 1 (0 in a single-gadget
*	    requester).
*
*	TREZ_Title (STRPTR) - Requester window title. Default is "System
*	    request" (or a localized version under OS2.1 and higher).
*
*	TREZ_Activate (BOOL) - If this tag is supplied, the activity
*	    state of the requester window will be taken from this tag's
*	    argument instead of being inherited from the locked project
*	    (if applicable).
*
*	TRWI_PubScreen (struct Screen *) - A public screen on which the
*	    window will be opened. The screen *must* have been locked.
*
*	TRWI_PubScreenName (STRPTR) - A public screen on which the window
*	    will be opened. Triton will try to lock the screen with the
*	    specified name. It will fall back onto the default public
*	    screen in case the screen can't be found/locked.
*
*   RESULT
*	selection - The number of the selected gadget. The gadgets are
*	            numbered from left to right beginning with 1. The
*	            rightmost gadget (or the only gadget in a 1-gadget
*	            requester) has got number 0. (ULONG)(-1) is returned
*	            for indicating an error.
*
*   SEE ALSO
*	TR_AutoRequest(), TR_PrintText()
*
******/

ULONG __saveds __asm TR_EasyRequest(register __a1 struct TR_App *app, register __a2 STRPTR bodyfmt, register __a3 STRPTR gadfmt, register __a0 struct TagItem *taglist)
{
  ULONG defid=1, retval=(ULONG)(-1), numgads;
  ULONG currentpos=26,gstrsize,wintagslen;
  struct TR_Project *lockproject=NULL;
  struct TagItem *tstate,*tag,*wintags;
  STRPTR copygadfmt=NULL;
  ULONG i,oldi,buttonnumber;
  BOOL activate=TRUE;
  BOOL ownactivate=FALSE;
  BOOL finished=FALSE;
  ULONG scrtype=TAG_IGNORE, scrdata;

  struct TagItem deftags[]=
  {
    /* Beginning */
    TRWI_Title, 0, // 0
    TRWI_Position, TRWP_MOUSEPOINTER, // 1
    TRWI_Flags, TRWF_NOZIPGADGET|TRWF_NOSIZEGADGET|TRWF_NOCLOSEGADGET|TRWF_NODELZIP|TRWF_NOESCCLOSE, // 2
    TRWI_Backfill, TRBF_REQUESTERBACK, // 3
    0,0, // 4
    TRGR_Vert, TRGR_ALIGN,
    TROB_Space, TRST_NORMAL,
    TRGR_Horiz, TRGR_ALIGN,
    TROB_Space, TRST_NORMAL,
    TROB_FrameBox, 0,
    TRAT_Backfill, TRBF_NONE,
    TRGR_Vert, TRGR_ALIGN,
    TROB_Space, TRST_NORMAL,
    /* Text */
    TRGR_Horiz, TRGR_PROPSPACES|TRGR_CENTER,
    TROB_Space, TRST_NORMAL,
    TROB_Text, 0,
    TRAT_Text, 0, // 16
    TRAT_Flags, TRTX_NOUNDERSCORE|TRTX_MULTILINE|TRTX_CENTER,
    TROB_Space, TRST_NORMAL,
    TRGR_End, 0,
    /* Intermediate */
    TROB_Space, TRST_NORMAL,
    TRGR_End, 0,
    TROB_Space, TRST_NORMAL,
    TRGR_End, 0,
    TROB_Space, TRST_NORMAL,
    TRGR_Horiz, TRGR_PROPSPACES|TRGR_CENTER
  };

  /* Calculate TagList length */

  numgads = TR_NumOccurances('|',gadfmt) + 1;

  /* Initialize TagList */

  wintagslen  = (35 + 5*numgads)*sizeof(struct TagItem);
  if(!(wintags=(struct TagItem *)TR_AllocPooled(app->tra_MemPool,wintagslen))) goto cleanup;
  CopyMem((APTR)(deftags),(APTR)(wintags),26*sizeof(struct TagItem));
  wintags[0].ti_Data = (ULONG)LOCSTR(MSG_SYSTEMREQUEST_TITLE);
  wintags[16].ti_Data = (ULONG)bodyfmt;

  /* Go through tags */

  if(taglist)
  {
    tstate=taglist;
    while(tag=NextTagItem(&tstate))
    {
      switch(tag->ti_Tag)
      {
        case TREZ_ReqPos:
	  wintags[1].ti_Data = tag->ti_Data;
          break;
        case TREZ_LockProject:
          lockproject=(struct TR_Project *)(tag->ti_Data);
          break;
        case TREZ_Return:
          defid=tag->ti_Data;
          break;
        case TREZ_Activate:
          ownactivate=TRUE;
          activate=tag->ti_Data;
          break;
        case TREZ_Title:
	  wintags[0].ti_Data = tag->ti_Data;
          break;
        case TRWI_PubScreen:
          scrtype=TRWI_PubScreen;
          scrdata=(ULONG)(tag->ti_Data);
          break;
        case TRWI_PubScreenName:
          scrtype=TRWI_PubScreenName;
          scrdata=(ULONG)(tag->ti_Data);
      }
    }
  }

  if(lockproject)
  {
    if(scrtype==TAG_IGNORE)
      {
	scrtype=TRWI_CustomScreen;
	scrdata=(ULONG)(lockproject->trp_Window->WScreen);
      }
    if(!ownactivate) if(!(lockproject->trp_Window->Flags&WFLG_WINDOWACTIVE)) activate=FALSE;
  }

  /* Make a copy of the gadget format string */

  gstrsize=TR_FirstOccurance(0L,gadfmt)+1;
  if(!(copygadfmt=(STRPTR)TR_AllocPooled(app->tra_MemPool,gstrsize))) goto cleanup;
  CopyMem((APTR)(gadfmt),(APTR)(copygadfmt),gstrsize);

  /* Fill in the tag list */

  if(!activate) wintags[2].ti_Data |= TRWF_NOACTIVATE;
  wintags[4].ti_Tag    = scrtype;
  wintags[4].ti_Data = scrdata;

  /* Build tag list: Gadgets */

  if(numgads>1)
  {
    wintags[currentpos].ti_Tag    = TRGR_Horiz;
    wintags[currentpos++].ti_Data = TRGR_FIXHORIZ;
  }

  wintags[currentpos].ti_Tag    = TROB_Space;
  wintags[currentpos++].ti_Data = TRST_NORMAL;

  if(numgads>1) wintags[currentpos++].ti_Tag    = TRGR_End;

  if(!defid) defid=numgads;
  for(i=0,buttonnumber=1;;buttonnumber++)
  {
    wintags[currentpos++].ti_Tag  = TROB_Button;
    wintags[currentpos].ti_Tag    = TRAT_Flags;
    if(buttonnumber==numgads) wintags[currentpos].ti_Data |= TRBU_ESCOK;
    if(buttonnumber==defid) wintags[currentpos].ti_Data |= TRBU_RETURNOK;
    currentpos++;
    wintags[currentpos].ti_Tag    = TRAT_Text;
    wintags[currentpos++].ti_Data = (ULONG)(&(copygadfmt[i]));
    wintags[currentpos].ti_Tag    = TRAT_ID;
    wintags[currentpos++].ti_Data = buttonnumber;

    oldi=i;
    if((i=TR_FirstOccurance('|',&copygadfmt[i]))==(ULONG)(-1))
      {
	finished=TRUE;
	if(numgads>1)
	  {
	    wintags[currentpos].ti_Tag    = TRGR_Horiz;
	    wintags[currentpos++].ti_Data = TRGR_FIXHORIZ;
	  }
      }

    wintags[currentpos].ti_Tag    = TROB_Space;
    wintags[currentpos++].ti_Data = TRST_NORMAL;

    if(numgads>1) if(finished) wintags[currentpos++].ti_Tag = TRGR_End;

    if(finished) break;
    i+=oldi;
    copygadfmt[i++]=0;
  }

  /* Build tag list: End */

  wintags[currentpos++].ti_Tag  = TRGR_End;
  wintags[currentpos].ti_Tag    = TROB_Space;
  wintags[currentpos++].ti_Data = TRST_NORMAL;
  wintags[currentpos++].ti_Tag  = TRGR_End;
  wintags[currentpos].ti_Tag    = TAG_END;

  /* The best, the rest, the rare */

  retval=TR_AutoRequest(app, lockproject, wintags);

cleanup:
  if(copygadfmt) TR_FreePooled(app->tra_MemPool,(void *)copygadfmt,gstrsize);
  if(wintags) TR_FreePooled(app->tra_MemPool,(void *)wintags,wintagslen);

  if(retval==numgads) return 0;
  else if(retval==0) return (ULONG)(-1);
  else return retval;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Prefs management //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

VOID __regargs __inline TR_SaveAppInfos(struct TR_App *app)
{
  BPTR lock;
  ULONG val;
  UBYTE filename[40];

  /* Abort if env:Triton doesn't exist or if the application is unnamed */
  if((!(app->tra_Name))||(!(*(app->tra_Name)))) return;
  if(lock=Lock("env:Triton",ACCESS_READ)) UnLock(lock); else return;

  TR_SPrintF(filename,"env:Triton/%s.app",app->tra_Name);

  if(!(lock=Open(filename,MODE_NEWFILE))) {DisplayBeep(NULL); return;}

  val=TR_FirstOccurance(0,app->tra_Name);
  FWrite(lock,(STRPTR)(&val),4,1);
  FWrite(lock,app->tra_Name,val,1);

  val=TR_FirstOccurance(0,app->tra_LongName);
  FWrite(lock,(STRPTR)(&val),4,1);
  if(val) FWrite(lock,app->tra_LongName,val,1);

  val=TR_FirstOccurance(0,app->tra_Info);
  FWrite(lock,(STRPTR)(&val),4,1);
  if(val) FWrite(lock,app->tra_Info,val,1);

  val=TR_FirstOccurance(0,app->tra_Version);
  FWrite(lock,(STRPTR)(&val),4,1);
  if(val) FWrite(lock,app->tra_Version,val,1);

  val=TR_FirstOccurance(0,app->tra_Release);
  FWrite(lock,(STRPTR)(&val),4,1);
  if(val) FWrite(lock,app->tra_Release,val,1);

  val=TR_FirstOccurance(0,app->tra_Date);
  FWrite(lock,(STRPTR)(&val),4,1);
  if(val) FWrite(lock,app->tra_Date,val,1);

  Close(lock);
}


VOID __regargs __inline TR_LoadTritonPrefs(struct TR_App *app)
{
  BPTR lock;
  UBYTE filename[40];
  struct TR_AppPrefs loadedprefs;

  if((!(app->tra_Name))||(!(*(app->tra_Name)))) return;

  if(!(app->tra_Prefs=TR_AllocPooled(app->tra_MemPool,sizeof(struct TR_AppPrefs))))
  {
    DisplayBeep(NULL);
    return;
  }

  CopyMem(&TR_DefaultAppPrefs,app->tra_Prefs,sizeof(struct TR_AppPrefs));
  ((struct TR_AppPrefs *)(app->tra_Prefs))->pubscreen[0]=1;
  ((struct TR_AppPrefs *)(app->tra_Prefs))->pubscreen[1]=0;

  TR_SPrintF(filename,"env:Triton/%s.tri",app->tra_Name);
  if(!(lock=Open(filename,MODE_OLDFILE))) lock=Open("env:Triton/__GLOBAL__.tri",MODE_OLDFILE);
  if(lock)
  {
    if(FRead(lock,(STRPTR)(&loadedprefs),sizeof(struct TR_AppPrefs),1))
    {
      CopyMem((void *)(&loadedprefs),
	      (void *)(app->tra_Prefs),sizeof(struct TR_AppPrefs));
    }
    Close(lock);
  }
}


VOID __regargs __inline TR_SaveWindowDimensions(struct TR_Project *project)
{
  BPTR lock;
  ULONG val;
  UBYTE filename[46];

  if(!(project->trp_ID)) return;
  if((!(project->trp_App->tra_Name))||(!(*(project->trp_App->tra_Name)))) return;
  if(lock=Lock("env:Triton",ACCESS_READ)) UnLock(lock); else return;

  TR_SPrintF(filename,"env:Triton/%s.win.%ld",project->trp_App->tra_Name,project->trp_ID);

  if(!(lock=Open(filename,MODE_NEWFILE))) return;
  FWrite(lock,(STRPTR)(project->trp_Dimensions),sizeof(struct TR_Dimensions),1);

  if(project->trp_Window->Title)
  {
    val=TR_FirstOccurance(0,project->trp_Window->Title);
    FWrite(lock,(STRPTR)(&val),4,1);
    FWrite(lock,project->trp_Window->Title,val,1);
  }
  else { val=0; FWrite(lock,(STRPTR)(&val),4,1); }

  Close(lock);
}


VOID __regargs __inline TR_LoadWindowDimensions(struct TR_Project *project)
{
  BPTR lock;
  UBYTE filename[46];

  if(!(project->trp_ID)) return;
  if((!(project->trp_App->tra_Name))||(!(*(project->trp_App->tra_Name)))) return;
  if(lock=Lock("env:Triton",ACCESS_READ)) UnLock(lock); else return;

  TR_SPrintF(filename,"env:Triton/%s.win.%ld",project->trp_App->tra_Name,project->trp_ID);

  if(!(lock=Open(filename,MODE_OLDFILE))) return;
  FRead(lock,(STRPTR)(project->trp_Dimensions),sizeof(struct TR_Dimensions),1);
  Close(lock);
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////// Public screen support //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Screen * __regargs __inline TR_OpenScreen(struct TR_ScreenNode *sn)
{
  UWORD pens[]={(UWORD)(~0)};
  struct Screen *scr;

  if(scr=OpenScreenTags(NULL,
    SA_LikeWorkbench, TRUE,
    SA_Title,         sn->title,
    SA_Depth,         sn->depth,
    SA_Type,          PUBLICSCREEN,
    SA_DisplayID,     sn->screenmode,
    SA_PubName,       sn->pubname,
    SA_AutoScroll,    TRUE,
    SA_Pens,          pens,
    SA_FullPalette,   TRUE,
    TAG_DONE))
  {
    PubScreenStatus(scr,0);
    sn->screen=scr;
    Forbid();
    AddTail((struct List *)&(TR_Global.trg_ScreenList),(struct Node *)sn);
    Permit();
  }

  return scr;
}


struct Screen * __regargs __inline TR_LockPubScreen(STRPTR name)
{
  struct Screen *scr,*openedscreen=NULL;
  BPTR lock;
  struct TR_ScreenNode *node;
  ULONG dummy;
  BOOL got_one;

  if(scr=LockPubScreen(name)) return scr;

  if(node=(struct TR_ScreenNode *)AllocPooled(TR_Global.trg_ScreenListPool,sizeof(struct TR_ScreenNode)))
  {
    if(lock=Open("env:Triton/Screens.trc",MODE_OLDFILE))
    {
      FRead(lock,(STRPTR)(&dummy),4,1);
      while(got_one=(BOOL)FRead(lock,(STRPTR)(node),sizeof(struct TR_ScreenNode),1))
      {
        if(!TR_StrCmp(name,node->pubname)) break;
      }
      Close(lock);
      if(got_one)
      {
        openedscreen=TR_OpenScreen(node);
        if(!(scr=LockPubScreen(node->pubname)))
	{
	  CloseScreen(openedscreen);
	  openedscreen=NULL;
	}
      }
      if(!openedscreen) TR_FreePooled(TR_Global.trg_ScreenListPool,(void *)node,sizeof(struct TR_ScreenNode));
    }
  }

  return scr;
}


VOID __regargs __inline TR_UnlockPubScreen(struct Screen *scr)
{
  struct TR_ScreenNode *screennode;

  UnlockPubScreen(NULL,scr);

  for(screennode=(struct TR_ScreenNode *)(TR_Global.trg_ScreenList.mlh_Head);
      screennode->node.ln_Succ;
      screennode=(struct TR_ScreenNode *)(screennode->node.ln_Succ))
  {
    if(scr==screennode->screen)
    {
      TR_CloseScreen(screennode);
      return;
    }
  }
}


BOOL __regargs TR_CloseScreen(struct TR_ScreenNode *sn)
{
  struct Screen *screen;

  if(screen=LockPubScreen(sn->pubname))
  {
    UnlockPubScreen(NULL,screen);
    if(PubScreenStatus(screen,PSNF_PRIVATE)&1) /*-- Only needed because of a bug in KCommodity */
    {
      if(CloseScreen(screen))
      {
        Forbid();
        Remove((struct Node *)sn);
        Permit();
        TR_FreePooled(TR_Global.trg_ScreenListPool,(void *)sn,sizeof(struct TR_ScreenNode));
        return TRUE;
      }
    }
  }
  return FALSE;
}


VOID __regargs __inline TR_RemoveScreens(VOID)
{
  struct TR_ScreenNode *screennode;

  /* This function is only called during library expunge. Thus it is not necessary
     to protect access to the screen list by disabling the multi-tasking scheduler. */

  for(screennode=(struct TR_ScreenNode *)(TR_Global.trg_ScreenList.mlh_Head);
      screennode->node.ln_Succ;
      screennode=(struct TR_ScreenNode *)(screennode->node.ln_Succ))
    TR_CloseScreen(screennode);

  if(TR_Global.trg_ScreenListPool) TR_DeletePool(TR_Global.trg_ScreenListPool);
}


/****** triton.library/TR_LockScreen ******
*
*   NAME	
*	TR_LockScreen -- Get a project's screen
*
*   SYNOPSIS
*	screen = TR_LockScreen(Project)
*	D0                     A0
*
*	struct Screen * TR_LockScreen(struct TR_Project *);
*
*   FUNCTION
*	Lock the screen of a Triton project for use with non-Triton
*	windows (e.g. for opening a file requester on the screen of a
*	Triton application). The screen must be unlocked later with
*	TR_UnlockScreen(). Locking/unlocking calls are nested.
*
*   RESULT
*	screen - Pointer to the project's screen or NULL to indicate an
*	         error. In this case the application should *not* abort,
*	         but *quietly* use another screen (preferably the
*	         Workbench screen) instead.
*
*   SEE ALSO
*	TR_UnlockScreen()
*
******/

struct Screen * __asm __saveds TR_LockScreen(register __a0 struct TR_Project *project)
{
  return project->trp_Screen;
}


/****** triton.library/TR_UnlockScreen ******
*
*   NAME	
*	TR_UnlockScreen -- Release a project's screen
*
*   SYNOPSIS
*	TR_UnlockScreen(Screen)
*	                A0
*
*	VOID TR_UnlockScreen(struct Screen *);
*
*   FUNCTION
*	Unlock a screen which has been locked by TR_LockScreen(). All
*	locked screens must be unlocked! Locking/unlocking calls are
*	nested.
*
*   SEE ALSO
*	TR_LockScreen()
*
******/

VOID __asm __saveds TR_UnlockScreen(register __a0 struct Screen *screen)
{
}
