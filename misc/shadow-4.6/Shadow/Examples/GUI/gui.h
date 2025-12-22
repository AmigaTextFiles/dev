
#ifndef SHADOW_GUI_H
#define SHADOW_GUI_H

#include <exec/exec.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <intuition/intuition.h>
#include <proto/intuition.h>
#include <libraries/gadtools.h>
#include <proto/gadtools.h>
#include <shadow/watcher.h>

/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for the GUI process.                        =
 * =                                                                        =
 * ==========================================================================
 */
#ifndef GUIPROCESSCLASS
#define GUIPROCESSCLASS "gui process class"
#endif

#ifndef GUITASK
#define GUITASK "Gui Task\0"
#endif

#define ATTR_GUIPROCESS "shared window port\0"
struct GuiProcess {
   struct MsgPort *guip_port;
};

void HandleIntuiMessage(struct IntuiMessage *intui);
void GUIThreadStart(void);


/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for GUI type of objects.                    =
 * =                                                                        =
 * ==========================================================================
 */
#ifndef GUICLASS
#define GUICLASS        "gui class"
#endif

#define ATTR_GUICHILDREN   "gui children\0"
#define ATTR_GUISTRUCT     "gui struct\0"
struct GUIStruct {
   OBJECT gui_parent;
   char   *gui_moniker;
};

#define ATTR_GUIOUTPUT     "gui output\0"
struct OutputStruct {
   OBJECT out_object;
   char   *out_method;
};

extern METHOD_REF REF_GuiInitMethod[];

void *GuiInitMethod(METHOD_ARGS, OBJECT parent,
                                 char   *name,
                                 OBJECT out_object,
                                 char   *out_method);
void GuiRemoveMethod(METHOD_ARGS);
void GuiDestroyMethod(METHOD_ARGS);

/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for window objects.                         =
 * =                                                                        =
 * ==========================================================================
 */

#ifndef WINDOWCLASS
#define WINDOWCLASS     "Window Class\0"
#endif

#define ATTR_WINDOW     "window attributes"
struct WindowObject {
   struct Window *wo_window;
   /*
    * Should really be a pointer to a screen Object, but....
    */
   struct VisualInfo *wo_vi;

   /*
    * Will eventually need menus here, too.
    */
   struct Gadget *wo_rootGadget, *wo_lastGadget;
};

#define METHOD_WINDOW_CLOSE   METHOD_META_REMOVE
#define METHOD_WINDOW_REFRESH "Method window refresh"
#define METHOD_GADGET_SELECT  "Method gadget select\0"

extern METHOD_REF REF_WinOpenMethod[];

void *WinOpenMethod(METHOD_ARGS, OBJECT parent,
                                 char *name,
                                 OBJECT out_object,
                                 char *out_method,
                                 struct TagItem *tags);
void WinCloseMethod(METHOD_ARGS);
void WinDestroyMethod(METHOD_ARGS);


/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for GADTOOL gadget objects.                 =
 * =                                                                        =
 * ==========================================================================
 */

#ifndef GADGTCLASS
#define GADGTCLASS    "Gadget GadTool Class\0"
#endif

#define ATTR_GADGET   "gadget base offset\0"

struct GadgetObject {
   struct Gadget *go_gadget;
};

extern METHOD_REF REF_GadgTOpenMethod[], REF_GadgTChangeMethod[];

void *GadgTOpenMethod(METHOD_ARGS, OBJECT window,
                                   char *name,
                                   OBJECT out_object,
                                   char *out_method,
                                   struct NewGadget *ng,
                                   long gadType,
                                   struct TagItem *tags);


#define METHOD_GADGET_CHANGE "Method Change gadtool attrs"
void GadgTChangeMethod(METHOD_ARGS, struct TagItem *tags);

BOOL InitGUISystem(void);

#endif