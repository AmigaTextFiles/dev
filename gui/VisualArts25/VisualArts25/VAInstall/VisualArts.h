/*
**  $Filename: VisualArts.h $
**  $Includes, V2.5 $
**  $Date: 95/04/22$
**
**
**  (C) 1994-95 Danny Y. Wong  			
**  All Rights Reserved
**
**  DO NOT MODIFY
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/nodes.h>
#include <exec/ports.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <exec/libraries.h>

#include <devices/console.h>
#include <devices/serial.h>
#include <devices/clipboard.h>

#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/classes.h>
#include <intuition/icclass.h>
#include <intuition/sghooks.h>
#include <intuition/cghooks.h>

#include <gadgets/textfield.h>

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <graphics/text.h>

#include <libraries/gadtools.h>
#include <libraries/dos.h>
#include <libraries/asl.h>
#include <libraries/dosextens.h>

#include <workbench/workbench.h>
#include <workbench/startup.h>

#include <clib/wb_protos.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/asl_protos.h>

#include <proto/textfield.h>

#include "string.h" 
#include "stdio.h"
#include "stdlib.h"
#include "ctype.h"

#include "PopUpMenuClass.h" 

/* screemode flags */

#define ASLSM_INITIALAUTOSCROLL         1
#define ASLSM_INITIALINFOOPENED         2
#define ASLSM_DOWIDTH                   4
#define ASLSM_DOHEIGHT                  8
#define ASLSM_DODEPTH                   16
#define ASLSM_DOOVERSCANTYPE            32
#define ASLSM_DOAUTOSCROLL              64
#define ASLSM_SLEEPWINDOW               128

/* font requester flags */

#define ASLFO_SLEEPWINDOW               1
#define ASLFO_DOFRONTPEN                2
#define ASLFO_DOBACKPEN                 4
#define ASLFO_DOSTYLE                   8
#define ASLFO_DODRAWMODE                16
#define ASLFO_FOXEDWIDTHONLY            32

/* file requester flags */

#define ASLFR_DOSAVEMODE                1
#define ASLFR_DOMULTISELECT             2
#define ASLFR_DOPATTERNS                4
#define ASLFR_DRAWERSONLY               8
#define ASLFR_REJECTICONS               16
#define ASLFR_FILTERDRAWERS             32
#define ASLFR_SLEEPWINDOW               64


/* to adjust the GUI if the window title is other than topaz 8
*/
#define kWindowOffSetY  (Scr->Font->ta_YSize - 8)

/* context sensitive */

#define VA_Static       0x0001
#define VA_ExpandX      0x0002
#define VA_MoveX        0x0004
#define VA_ExpandY      0x0008
#define VA_MoveY        0x0010

/* defines for scroller window with super bitmap */

#define MAX_LEVEL          (0xFFFFL)
#define LAYERXOFFSET(win)  (win->RPort->Layer->Scroll_X)  
#define LAYERYOFFSET(win)  (win->RPort->Layer->Scroll_Y)  

/* clip board */
struct cbbuf {

        ULONG size;     /* size of memory allocation            */
        ULONG count;    /* number of characters after stripping */
        UBYTE *mem;     /* pointer to memory containing data    */
};

/* define for Image */

#ifndef IM
#define IM(o)	((struct Image *) o)
#endif

/* define for determining the max value */

#ifndef MAX
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#endif

/* for new menus in V38  */

#ifndef WA_NewLookMenus
  #define WA_NewLookMenus         (WA_Dummy + 0x30)
#endif

#ifndef  GTMN_NewLookMenus
#define GTMN_NewLookMenus    GT_TagBase+67 /* ti_Data is boolean */
#endif

#ifndef WFLG_NEWLOOKMENUS
#define WFLG_NEWLOOKMENUS   0x00200000	/* window has NewLook menus	*/
#endif

/* macros for easy access to Gadget data */

#define GetString(gad)	        (((struct StringInfo *)gad->SpecialInfo)->Buffer)
#define GetUndoString(gad)	(((struct StringInfo *)gad->SpecialInfo)->UndoBuffer)
#define GetNumber(gad)	        (((struct StringInfo *)gad->SpecialInfo)->LongInt)

/* List node name.  Each node have the following */
  
struct NameNode
{
  struct Node nn_Node;  /* linked list node to previous or next node  */
  UBYTE nn_Data[132];   /* name of the node, this is the same as      */
                        /* nn_Node.ln_Name                            */
  struct List *nn_List;
  UBYTE UserData[16];
};

/* Visual Arts message object.  Every GADGETUP event, the object is
   sent to the attached function.  For Menus, the va_Gadget field is
   always NULL.
*/

struct VAobject {
  struct Window *va_Window;           /* window the object originated     */
  struct Gadget *va_Gadget;           /* the gadget that sent this object */
  struct IntuiMessage *va_IntuiMsg;   /* the IntuiMessage                 */
  ULONG va_Flags;                     /* user flags                       */
  APTR va_UserData;                   /* user data, function pointer etc..*/
};

/* Every AREXX command have the following */

struct rexxCommandList
{
  char *name;       /* name of the AREXX command, note its case sensitive */
  APTR userdata;    /* user data, in this case it's a function pointer    */ 
};

/* Structure for Multi-Processing windows.  This structure is a linked
   List for every window opened as Multi-Processing
*/

struct WindowNode
{
	struct Node nn_Node;            /* linked list to prev or next window */
	UBYTE nn_Data[80];              /* window name */
	struct Window *nn_Window;       /* window pointer */
	struct AppWindow *nn_AppWindow; /* AppWindow pointer if window is a AppWindow */
	struct MsgPort *nn_AppWindPort; /* AppWindow Port */
	short ID;                       /* WindowNode ID  */
	APTR UserData;                  /* window Handler for this window */
};
