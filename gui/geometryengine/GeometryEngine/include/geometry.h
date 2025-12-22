/*
**	$Id: geometry.h 1.1 1997/08/03 00:52:00 Aric_Caley Exp Aric_Caley $
**
**      Header file for Geometry.lib
**
**	Written by Aric R Caley
**
**	(C) Copyright 1997 Greywire designs
**	    All Rights Reserved

$Log: geometry.h $
 * Revision 1.1  1997/08/03  00:52:00  Aric_Caley
 * Initial revision
 *
*/

#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <libraries/gadtools.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/dos.h>
#include <proto/gadtools.h>
#include <proto/diskfont.h>

#include <clib/alib_protos.h>

#include <stdio.h>
#include <math.h>

typedef struct LongPoint
{
  LONG x, y;	//** 16.16 bit fractions.
} LongPoint;

//** Dont mess with this stuff.  In fact, just close your eyes.  :)
typedef struct GTTemplate
{
  struct Gadget *Gadget, *Context;
  ULONG Kind;
  UBYTE *Text;
  UWORD NumGads;	//** Number of gadgets we have (stupid GadTools)
  UWORD ID;
  ULONG Flags;
  APTR UserData;
  struct TagItem *Tags;
  struct TagItem *State;
  void *StateData;
} GTTemplate;

//** A minimum geometry, used for "leafs", like a gadget.
typedef struct MGeometry
{
  struct MGeometry *Next;
  void *Object;		//** Note: same as member "Children" in a full geometry
  ULONG Flags;
  struct IBox Box;	//** Relative (interpreted) domain dimensions (see Domains.txt)
  struct IBox Real;	//** Actual calculated pixel dimensions.
  struct IBox Min;	//** Minimum pixel dimensions (Left / Top ignored)
} MGeometry;

typedef struct CustomGeometry
{
  struct Leaf *Next;
  void *Object;		//** Note: same as member "Children" in a full geometry
  ULONG Flags;
  struct IBox Box;	//** Relative (interpreted) domain dimensions (see Domains.txt)
  struct IBox Real;	//** Actual calculated pixel dimensions.
  struct IBox Min;	//** Minimum pixel dimensions (Left / Top ignored)
  struct Hook *Free;
  struct Hook *Render;
  struct Hook *Minsize;
  struct Hook *Resize;
} CustomGeometry;

//** A full geometry; typicaly NOT a "leaf": gadget, image, etc.
typedef struct Geometry
{
  struct Geometry *Next;
  struct Geometry *Children;
  ULONG Flags;
  struct IBox Box;	//** Relative (interpreted) domain dimensions (see Domains.txt)
  struct IBox Real;	//** Actual calculated pixel dimensions.
  struct IBox Min;	//** Minimum pixel dimensions (Left / Top ignored)
  struct Hook *Free;
  struct Hook *Render;
  struct Hook *Minsize;
  struct Hook *Resize;
  Point PropRange;	//** Sum of proportions of our children (* ScaleFact * ScaleMin = actual size)
  Point MinRange;	//** Sum of minsizes of our children
  LongPoint ScaleMin;	//** What we need to scale the proportions by (min) (static).
  LongPoint ScaleFact;	//** What we need to scale by to fit into our parent, relative to our minsize! (dynamic).
  Point Pad;		//** How much "padding" to put around our children (for the frame and/or title text, etc)
  SHORT Spacing;	//** Space between children.
} Geometry;
//** How we layout our children
#define GYF_TYPEFLAGS 0x00000003
#define GYF_PROP 0x00000000
#define GYF_HORIZ 0x00000001
#define GYF_VERT 0x00000002
#define GYF_CUSTOM 0x00000003
#define GYF_JUSTIFYFLAGS 0x0000000C
#define GYF_JRIGHTBOTTOM 0x00000004
#define GYF_JCENTER 0x00000008

//** This is an MGeometry
#define GYF_LEAF 0x10000000
//** This MGeometry is a CustomGeom with Object pointing to a Hook for custom handling,
//** Otherwise it would be a gadtools object with Object pointing to a GTTemplate.
#define GYF_HOOK  0x20000000

//** Frame flags
#define GYF_FRAMEBITS 0x00000070
#define GYF_NONE   0x00
#define GYF_RECESS 0x00000010
#define GYF_RAISED 0x00000020
#define GYF_RIDGE  0x00000030
#define GYF_THICK  0x00000040
//** Text flags
// GYF_TEXTABOVE 0x00000000
#define GYF_TEXTBITS  0x00000300
#define GYF_TEXTBELOW 0x00000100
#define GYF_TEXTLEFT  0x00000200
#define GYF_TEXTRIGHT 0x00000300
// GYF_TEXTBREAKFRAME 0x00000000
#define GYF_TEXTINFRAME 0x00000400
#define GYF_TEXTOUTFRAME 0x00000800

typedef struct GUI
{
  struct Screen *Scr;
  APTR VI;
  struct DrawInfo *DrInfo;
  struct Window *Win;
  struct TextAttr Attr;
  struct TextFont *Font;
  ULONG Flags;
  Geometry *Geom;
} GUI;
//** Don't mess with these!
//** In the middle of a resize
#define GUIF_RESIZING 0x00000001
#define GUIF_NEEDSREFRESH 0x00000002
#define GUIF_DYING 0x00000004

//** High level interface construct
typedef struct GUIForm
{
  GUI *GUI;
  struct TagItem *Args;
  ULONG *OKID;	//** The ID's to consider in order to close the window
  ULONG *CancelID;
  struct Hook *Custom;
} GUIForm;

//** Tags
#define GE_Geometry	(TAG_USER + 1) //** Init this geometry under the given GUI envirionment
#define GE_Child	GE_Geometry
#define GE_RenderHook	(TAG_USER + 2)
#define GE_MinsizeHook	(TAG_USER + 3)
#define GE_ResizeHook	(TAG_USER + 4)
#define GE_FreeHook	(TAG_USER + 5)
#define GE_ScreenName	(TAG_USER + 6)
#define GE_FontAttr	(TAG_USER + 7)
#define GE_Object	(TAG_USER + 8)

//** Geometry management/layout functions
/* Ignore the #define's and IT_* functions.  This was due to an API change, to
keep compatible with a few programs.  This will go away.  In fact I don't know
why it's still here.  Just paranoid I guess :)
*/
//		IT_InitGeometry(GUI *MyGUI);
#define 	IT_InitGeometry(gui) GE_InitGeometry(gui,TAG_END)
BOOL		GE_InitGeometry(GUI *MyGUI, Tag tags,...);
BOOL		GE_InitGeometryA(GUI *MyGUI, struct TagItem *tags);

//void		IT_BeginResizeGeometry(GUI *MyGUI);
#define		IT_BeginResizeGeometry(gui) GE_BeginResizeGeometry(gui,TAG_END);
BOOL		GE_BeginResizeGeometry(GUI *MyGUI, Tag tags,...);
BOOL		GE_BeginResizeGeometryA(GUI *MyGUI, struct TagItem *tags);

//		IT_ResizeGeometry(GUI *MyGUI);
#define		IT_ResizeGeometry(gui) GE_ResizeGeometry(gui,TAG_END);
BOOL		GE_ResizeGeometry(GUI *MyGUI, Tag tags,...);
BOOL		GE_ResizeGeometryA(GUI *MyGUI, struct TagItem *tags);

#define		IT_RefreshGeometry(gui) GE_RenderGeometry(gui,TAG_END)
BOOL		GE_RenderGeometry(GUI *MyGUI,Tag tags,...);
BOOL		GE_RenderGeometryA(GUI *MyGUI, struct TagItem *tags);

//void		IT_GTMinSize(struct RastPort *rp,GUI *MyGUI,Geometry *me);
//void		IT_GTReSize(GUI *MyGUI,Geometry *me,SHORT width, SHORT height);

//** Geometry/template creation functions
Geometry *	GE_CreateGTA(SHORT Width, SHORT Height,ULONG Kind,UBYTE *Text,UWORD ID,ULONG Flags,struct TagItem *tags);
Geometry *	GE_CreateGT(SHORT Width, SHORT Height,ULONG Kind,UBYTE *Text,UWORD ID,ULONG Flags,Tag tags,...);
//Geometry *	IT_CreateMGeometry(ULONG Flags,SHORT Width, SHORT Height,void *object);
Geometry *	GE_CreateGeometryA(ULONG Flags,SHORT Width, SHORT Height, struct TagItem *tags);
Geometry *	GE_CreateGeometry(ULONG Flags,SHORT Width, SHORT Height, Tag tags,...);
void		GE_FreeGeometries(GUI *MyGUI,Geometry *me);
void		GE_FreeGT(GUI *MyGUI,Geometry *gt);

//** GUI functions
#define 	IT_CreateGUI(scr,attr) GE_CreateGUI(GE_ScreenName,scr,GE_FontAttr,attr,TAG_END)
GUI *           GE_CreateGUI(Tag tags,...);
GUI *           GE_CreateGUIA(struct TagItem *tags);
void		GE_FreeGUI(GUI *MyGUI);
struct Window *	GE_OpenWindow(GUI *MyGUI,Tag tags,...);
struct Window *	GE_OpenWindowA(GUI *MyGUI,struct TagItem *tags);
void		GE_CloseWindow(GUI *MyGUI);

//** Higher level requester-like functions
BOOL		IT_OpenForm(GUIForm *Form);
BOOL		IT_HandleForm(GUIForm *Form);
BOOL		IT_CloseForm(GUIForm *Form);
ULONG		IT_DoForm(GUIForm *Form);

//** A couple of internal functions for GadTools stuff
SHORT CountGadgets(struct Gadget *gads);
void TerminateGadgets(struct Gadget *gads, SHORT count);
