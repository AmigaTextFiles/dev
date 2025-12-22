/*
 * First run attempt at a functional GUI library.
 * I agree, it sucks, but it's good enough, as Americans USED to
 *  say.
 *
 * (C) CopyRight 1991 by David C. Navas
 */
#include "gui.h"

#include <libraries/diskfont.h>
#include <proto/diskfont.h>
#include <proto/graphics.h>
#include <shadow/coreRoot.h>
#include <shadow/coreMeta.h>
#include <shadow/misc.h>
#include <shadow/process.h>
#include <shadow/semaphore.h>
#include <shadow/shadowBase.h>
#include <shadow/shadow_proto.h>
#include <shadow/shadow_pragmas.h>

#include <dos/dostags.h>
#include <ipc.h>
#include <ipc_proto.h>

extern struct ExecBase * __far SysBase;
struct GadToolsBase * __far GadToolsBase;
struct IntuitionBase * __far IntuitionBase;
extern struct DiskfontBase * __far DiskFontBase;
extern struct GfxBase * __far GfxBase;
extern struct ShadowBase * __far ShadowBase;

/*
 * external class definitions.
 */
extern char GuiProcClassName[],
            GuiTaskName[],
            GuiClassName[],
            WindowClassName[],
            GadgTClassName[];

void RemoveWinSafely(struct Window *win);
void StripIntuiMessages(struct MsgPort *port, struct Window *win);

extern struct SignalSemaphore programSemaphore;

struct TextAttr __far ta = {"topaz.font", 11, FS_NORMAL,
                            FPF_ROMFONT | FPF_DISKFONT};
struct TextFont * __far tf;

/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for the GUI process.                        =
 * =                                                                        =
 * ==========================================================================
 */
ATTRIBUTE_TAG guiProcAttrs[] =
                        {
                           ATTR_GUIPROCESS, sizeof(struct GuiProcess), NULL,
                           TAG_END
                        };

/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for GUI type of objects.                    =
 * =                                                                        =
 * ==========================================================================
 */

ATTRIBUTE_TAG guiAttrs[] =
                        {
                           ATTR_GUICHILDREN, FLAG_ATTR_WATCHED | SHADOW_BINTREE,
                                             NULL,
                           ATTR_GUISTRUCT, sizeof(struct GUIStruct), NULL,
                           ATTR_GUIOUTPUT, sizeof(struct OutputStruct), NULL,
                           TAG_END
                        };
METHOD_TAG guiMethods[] =
                        {
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)GuiRemoveMethod, NULL
                           },
                           {
                              METHOD_META_DESTROY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)GuiDestroyMethod, NULL
                           },
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              GuiInitMethod, REF_GuiInitMethod
                           },
                           TAG_END
                        };

/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for window objects.                         =
 * =                                                                        =
 * ==========================================================================
 */

ATTRIBUTE_TAG winAttrs[] =
                        {
                           ATTR_WINDOW, sizeof(struct WindowObject), NULL,
                           TAG_END
                        };
METHOD_TAG winMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              WinOpenMethod, REF_WinOpenMethod
                           },
                           {
                              METHOD_META_DESTROY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)WinDestroyMethod, NULL
                           },
                           {
                              METHOD_WINDOW_CLOSE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)WinCloseMethod, NULL
                           },
                           TAG_END
                        };

/*
 * ==========================================================================
 * =                                                                        =
 * =           Class definition for gadget objects.                         =
 * =                                                                        =
 * ==========================================================================
 */

ATTRIBUTE_TAG gadAttrs[] =
                        {
                            ATTR_GADGET, sizeof(struct GadgetObject), NULL,
                            TAG_END
                        };

METHOD_TAG gadMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              GadgTOpenMethod, REF_GadgTOpenMethod
                           },
                           {
                              METHOD_GADGET_CHANGE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)GadgTChangeMethod,
                                 REF_GadgTChangeMethod
                           },
                           TAG_END
                        };


/*
 * ==========================================================================
 * =                                                                        =
 * =                 Initialize these classes                               =
 * =                                                                        =
 * ==========================================================================
 */

void geta4(void);

BOOL InitGUISystem(void)
{
   OBJECT guiTask;
   BOOL   success;

   if (!(DiskfontBase = OpenLibrary("diskfont.library", 0)))
      return FALSE;

   if (!(GfxBase = OpenLibrary("graphics.library", 0)))
   {
      return FALSE;
   }
   if (!(tf = OpenDiskFont(&ta)))
   {
      VPrintf("couldn't find font\n", NULL);
      return FALSE;
   }

   /*
    * Create the guiProcess CLass.
    */
   success = AddAutoResource(NULL,
                             CreateSubClass(NULL,
                                            PROCESSCLASS,
                                            METACLASS,
                                            GuiProcClassName,
                                            NULL,
                                            guiProcAttrs,
                                            NULL,
                                            METHOD_END),
                             GuiProcClassName);

   /*
    * Create the guiTask
    */
   {
      struct TagItem tag[4];

      tag[0].ti_Tag = NP_Priority;
      tag[0].ti_Data = 1;
      tag[1].ti_Tag = NP_StackSize;
      tag[1].ti_Data = 6000;
      tag[2].ti_Tag = NP_Output;
      tag[2].ti_Data = (ULONG)Open("CONSOLE:", MODE_OLDFILE);
      tag[3].ti_Tag = TAG_END;

      guiTask = CreateInstance(NULL,
                               GuiProcClassName,
                               METACLASS,
                               GuiTaskName,
                               GUIThreadStart,
                               &programSemaphore,
                               tag,
                               METHOD_END);
      if (tag[2].ti_Tag != TAG_IGNORE)
         Close(tag[2].ti_Data);
   }

   SetupMethodTags(guiMethods, guiTask, (void *)-1);
   SetupMethodTags(winMethods, guiTask, (void *)-1);
   SetupMethodTags(gadMethods, guiTask, (void *)-1);

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             ROOTCLASS,
                                             METACLASS,
                                             GuiClassName,
                                             NULL,
                                             guiAttrs,
                                             guiMethods,
                                             METHOD_END),
                              GuiClassName);

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             GuiClassName,
                                             METACLASS,
                                             WindowClassName,
                                             NULL,
                                             winAttrs,
                                             winMethods,
                                             METHOD_END),
                              WindowClassName);

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             GuiClassName,
                                             METACLASS,
                                             GadgTClassName,
                                             NULL,
                                             gadAttrs,
                                             gadMethods,
                                             METHOD_END),
                              GadgTClassName);

   success &= AddAutoResource(NULL, guiTask, GuiTaskName);

   return success;
}

/*
 ==========================================================================
                           gui task
 ==========================================================================
 */

/*
 * First, define the GUI Process Class
 */

void GUIThreadStart()
{
   struct Task *task;
   struct JazzProcess *jproc;
   struct GuiProcess *gui;
   struct IPCPort *port, *replyPort;
   struct MsgPort *guiPort;

   /*
    * THE main EVENT LOOP!!!!
    */

   geta4();

#ifndef  NDEBUG
   VPrintf("GUI system startup\n", NULL);
#endif
   task = WaitThread();

   jproc = FindAttribute(task->tc_UserData, ATTR_JAZZPROCESS);

   gui = FindAttribute(task->tc_UserData, ATTR_GUIPROCESS);

   if (!(IntuitionBase = OpenLibrary("intuition.library", 36)))
   {
      DoJazzMethod((OBJECT)task->tc_UserData, NULL,
                   METHOD_META_REMOVE, METHOD_END);
      Signal(jproc->jp_parent, 1L << jproc->jp_parentSignal);
      return;
   }

   if (!(GadToolsBase = OpenLibrary("gadtools.library", 36)))
   {
      DoJazzMethod((OBJECT)task->tc_UserData, NULL,
                   METHOD_META_REMOVE, METHOD_END);
      CloseLibrary(IntuitionBase);
      Signal(jproc->jp_parent, 1L << jproc->jp_parentSignal);
      return;
   }
   if (!(gui->guip_port = guiPort = CreateMsgPort()))
   {
      DoJazzMethod((OBJECT)task->tc_UserData, NULL,
                   METHOD_META_REMOVE, METHOD_END);
      CloseLibrary(GadToolsBase);
      CloseLibrary(IntuitionBase);
      Signal(jproc->jp_parent, 1L << jproc->jp_parentSignal);
      return;
   }
   if (!(task = InitThread(task)))
   {
      CLASS root;

      DeleteMsgPort(guiPort);
      CloseLibrary(GadToolsBase);
      CloseLibrary(IntuitionBase);

      task = FindTask(NULL);

      do
         Wait(SIGBREAKF_CTRL_C);
      while(jproc->jp_parent);

      QuickDropString(jproc->jp_procName);
      root = FindJazzClass(ROOTCLASS);
      DoJazzMethod((OBJECT)task->tc_UserData,
                   root, METHOD_META_DESTROY, METHOD_END);
      DropObject(root);
      return;
   }

   port = jproc->jp_port;
   replyPort = jproc->jp_replyPort;

   while(TRUE)
   {
      struct IPCMessage *msg;
      struct IntuiMessage *intui;
      ULONG signals;

      signals = Wait( SigBitIPCPort(port) |
                      SigBitIPCPort(replyPort) |
                      (1L << guiPort->mp_SigBit) |
                      SIGBREAKF_CTRL_C);

      while(msg = GetIPCMessage(port))
         ParseJazzMessage(msg);
      while(msg = GetIPCMessage(replyPort))
         JunkIPCMessage(msg);
      while(intui = GT_GetIMsg(guiPort))
         HandleIntuiMessage(intui);

      if (signals & SIGBREAKF_CTRL_C)
      {
         if (jproc->jp_parent)
         {
#ifndef  NDEBUG
            VPrintf("I was signalled?\n", NULL);
#endif
            continue;
         } else
         {
            DeleteMsgPort(guiPort);

            RemoveThread(task->tc_UserData);

            CloseLibrary(GadToolsBase);
            CloseLibrary(IntuitionBase);
            if (tf)  CloseFont(tf);
            if (DiskfontBase)
               CloseLibrary(DiskfontBase);
            if (GfxBase)
               CloseLibrary(GfxBase);
            return;
         }
      }
   }
}

/*
 *
 * GUI CLASS METHODS
 *
 */
METHOD_REF REF_GuiInitMethod[] = {
                                    {'JOBJ', sizeof(void *), SHADOW_OBJECT},
                                    {'JSTR', sizeof(char *), 0},
                                    {'JOBJ', sizeof(void *), SHADOW_OBJECT},
                                    {'JSTR', sizeof(char *), 0},
                                    {TAG_END, SHADOW_RETURN_OBJECT, 0}
                                 };

void *GuiInitMethod(METHOD_ARGS, OBJECT parent,
                                 char *name,
                                 OBJECT out_object,
                                 char *out_method)
{
   W_AVLTREE Wtree;
   struct GUIStruct *gui;
   struct OutputStruct *io;

   gui = FindAttribute(object, ATTR_GUISTRUCT);
   gui->gui_parent = parent;

   if (parent)
      Wtree = FindAttribute(parent, ATTR_GUICHILDREN);

   io = FindAttribute(object, ATTR_GUIOUTPUT);
   io->out_object = out_object;

   UseObject(object);
   UseObject(parent);
   UseObject(out_object);

   if (!name || (name = UseString(name)))
   {
      gui->gui_moniker = name;
      if (!out_method || (out_method = UseString(out_method)))
      {
         io->out_method = out_method;
         if (!parent || AddNodeStringWatchedBinTree(Wtree, object, name))
         {
            if(DoJazzMethod(object, class->meta_superClass, MethodID, METHOD_END))
            {

               DropObject(object);
               return object;
            }
            if (parent) RemoveStringWatchedBinNode(Wtree, object, name);
         }
         DropString(out_method);
      }
      DropString(name);
   }
   DropObject(object);
   return NULL;
}

/*
 * Watch the semaphores!
 */

void GuiRemoveMethod(METHOD_ARGS)
{
   struct GUIStruct *gui;
   struct OutputStruct *io;
   W_AVLTREE children;
   OBJECT    parent;

   gui = FindAttribute(object, ATTR_GUISTRUCT);
   io = FindAttribute(object, ATTR_GUIOUTPUT);

   PSem(object, SHADOW_EXCLUSIVE_SEMAPHORE);

   DropObject(io->out_object);
   QuickDropString(io->out_method);

   parent = gui->gui_parent;
   gui->gui_parent = io->out_object = NULL;
   io->out_method = NULL;

   VSem(object);

   children = FindAttribute(object, ATTR_GUICHILDREN);
   PSem(&children->wv_value, SHADOW_EXCLUSIVE_SEMAPHORE);
   while(children->wv_value)
   {
      OBJECT gadgetObject;

      gadgetObject = UseObject((void *)children->wv_value->bn_value);
      VSem(&children->wv_value);
      DoJazzMethod(gadgetObject, NULL, METHOD_META_REMOVE, METHOD_END);
      DropObject(gadgetObject);
      PSem(&children->wv_value, SHADOW_EXCLUSIVE_SEMAPHORE);
   }

   VSem(&children->wv_value);

   /*
    * remove object from parent list.
    */
   if (parent)
   {
      /*
       * Ignore misnomer, please.
       * Actually, fellow sblings.
       */
      children = FindAttribute(parent, ATTR_GUICHILDREN);
      RemoveStringWatchedBinNode(children, object, gui->gui_moniker);
   }

   CallSuper();
   DropObject(parent);
}

void GuiDestroyMethod(METHOD_ARGS)
{
   struct GUIStruct *gui;

   gui = FindAttribute(object, ATTR_GUISTRUCT);
   QuickDropString(gui->gui_moniker);
   CallSuper();
}

/*
 *
 * WINDOW CLASS METHODS
 *
 */


/*
 * METHOD_META_INIT
 */
METHOD_REF  REF_WinOpenMethod[] = {
                                     {'JOBJ', sizeof(void *), SHADOW_OBJECT},
                                     {'JSTR', sizeof(char *), 0},
                                     {'JOBJ', sizeof(void *), SHADOW_OBJECT},
                                     {'JSTR', sizeof(char *), 0},
                                     {'TAGL', sizeof(void *),
                                              sizeof(struct TagItem)},
                                     {TAG_END, SHADOW_RETURN_OBJECT, 0}
                                  };

void *WinOpenMethod(METHOD_ARGS, OBJECT parent,
                                 char *name,
                                 OBJECT out_object,
                                 char *out_method,
                                 struct TagItem *tags)
{
   struct WindowObject *wobj;

   UseObject(object);
   wobj = FindAttribute(object, ATTR_WINDOW);
   name = UseString(name);

   if (wobj->wo_window = OpenWindowTags(NULL, WA_Flags, 0xf,
                                           WA_Title, name,
                                           TAG_MORE, tags))
   {
      struct GuiProcess *gui;

      gui = FindAttribute(FindTask(NULL)->tc_UserData, ATTR_GUIPROCESS);

      wobj->wo_window->UserPort = gui->guip_port;
      wobj->wo_window->UserData = (void *)object;

      /*
       * Would require V37 to check ModifyIDCMP!
       */

      ModifyIDCMP(wobj->wo_window, LISTVIEWIDCMP | CLOSEWINDOW | REFRESHWINDOW);

      {
         if (wobj->wo_vi = GetVisualInfo(wobj->wo_window->WScreen, TAG_END))
         {
            if (wobj->wo_lastGadget = CreateContext(&wobj->wo_rootGadget))
            {
               AddGList(wobj->wo_window, wobj->wo_rootGadget, -1, -1, NULL);

               /*
                * Force tags to NULL -- ick, I hate optimizers.
                */

               ForceMethodEnd(out_method);

               if (CallSuper())
               {
                  /*
                   * Used twice, once for return, once in window structure.
                   */

                  /*
                   * Name is in superClass under gui->gui_moniker
                   */
                  DropString(name);
                  return object;
               }
            }
         }
      }
      DropString(name);
      DoJazzMethod(object, NULL, METHOD_WINDOW_CLOSE, METHOD_END);
      return NULL;
   }
   DropString(name);
   DropObject(object);
   return NULL;
}

void WinDestroyMethod(METHOD_ARGS)
{
   struct WindowObject *wobj;

   wobj = FindAttribute(object, ATTR_WINDOW);

   if (wobj->wo_window)
      CloseWindow(wobj->wo_window);
   FreeVisualInfo(wobj->wo_vi);

   if (wobj->wo_rootGadget)
      FreeGadgets(wobj->wo_rootGadget);

   CallSuper();
}

void WinCloseMethod(METHOD_ARGS)
{
   struct WindowObject *wobj;
   struct Window *window;

   wobj = FindAttribute(object, ATTR_WINDOW);

   /*
    * Should remove all child gadgets.
    */

   if (window = wobj->wo_window)
   {
      RemoveGList(window, wobj->wo_rootGadget, -1);
      RemoveWinSafely(window);      /* Unuses object from UserData field */
   }
   CallSuper();
}

/*
 *
 * GADGT METHODS
 *
 */

METHOD_REF REF_GadgTOpenMethod[] =
                                    {
                                       'JOBJ', sizeof(OBJECT),
                                               SHADOW_OBJECT,
                                       'JSTR', sizeof(char *), 0,
                                       'JOBJ', sizeof(void *),
                                               SHADOW_OBJECT,
                                       'JSTR', sizeof(char *), 0,
                                       'NGAD', sizeof(struct NewGadget *),
                                               sizeof(struct NewGadget),
                                       'type', sizeof(long), 0,
                                       'TAGL', sizeof(void *),
                                               sizeof(struct TagItem),
                                       {TAG_END, SHADOW_RETURN_OBJECT, 0}
                                    };

void *GadgTOpenMethod(METHOD_ARGS, OBJECT window,
                                   char *name,
                                   OBJECT out_object,
                                   char *out_method,
                                   struct NewGadget *ng,
                                   long gadType,
                                   struct TagItem *tags)
{
   struct GadgetObject *gobj;
   struct WindowObject *windowObj;

   UseObject(object);
   if (!window || !ng)
   {
      DropObject(object);
      return NULL;
   }

   gobj = FindAttribute(object, ATTR_GADGET);
   if (!(windowObj = FindAttribute(window, ATTR_WINDOW)))
   {
      DropObject(object);
      return NULL;
   }

   ng->ng_TextAttr = &ta;
   ng->ng_VisualInfo = windowObj->wo_vi;
   ng->ng_UserData = object;
   ng->ng_GadgetText = UseString(name);

   RemoveGList(windowObj->wo_window, windowObj->wo_rootGadget, -1);

   if (gobj->go_gadget = CreateGadgetA(gadType, windowObj->wo_lastGadget, ng, tags))
   {
      AddGList(windowObj->wo_window, windowObj->wo_rootGadget, -1, -1, NULL);

      ForceMethodEnd(ng);
      if (CallSuper())
      {
         RefreshGList(windowObj->wo_lastGadget, windowObj->wo_window, NULL, ((UWORD)-1));
         windowObj->wo_lastGadget = gobj->go_gadget;

         GT_RefreshWindow(windowObj->wo_window, NULL);

         /*
          * name used by superClass, can drop it here.
          * Otherwise would have to subclass METHOD_DESTROY, which would suck.
          */
         DropString(name);
         DropObject(object);
         return object;
      }
   } else
      AddGList(windowObj->wo_window, windowObj->wo_rootGadget, -1, -1, NULL);
   DropObject(object);
   return NULL;
}

METHOD_REF REF_GadgTChangeMethod[] =
                                    {
                                       'TAGL', sizeof(void *),
                                               sizeof(struct TagItem),
                                       TAG_END
                                    };
void GadgTChangeMethod(METHOD_ARGS, struct TagItem *tags)
{
   struct GadgetObject *gobj;
   struct GUIStruct *gui;
   struct WindowObject *windowObj;

   gobj = FindAttribute(object, ATTR_GADGET);
   gui = FindAttribute(object, ATTR_GUISTRUCT);
   windowObj = FindAttribute(gui->gui_parent, ATTR_WINDOW);

   GT_SetGadgetAttrsA(gobj->go_gadget, windowObj->wo_window, NULL, tags);
}

/*
 ==============================================================================
 =                                                                            =
 =                            SUPPLEMENTARY                                   =
 =                                                                            =
 ==============================================================================
 */
void HandleIntuiMessage(struct IntuiMessage *intui)
{
   switch(intui->Class) {
      OBJECT winObject;

      case CLOSEWINDOW:
         winObject = (void *)intui->IDCMPWindow->UserData;
         GT_ReplyIMsg(intui);
         UseObject(winObject);
         DoJazzMethod(winObject, NULL, METHOD_WINDOW_CLOSE, METHOD_END);
         DropObject(winObject);
         break;
/*
      case MOUSEBUTTONS:
         if(msg->Code == SELECTDOWN)
            handler = mouseHandlers.push;
         else handler = mouseHandlers.release;
         break;
      case MOUSEMOVE:
         if(msg->Qualifier & IEQUALIFIER_LEFTBUTTON)
		 handler = mouseHandlers.move;
         break;
*/
      case REFRESHWINDOW:
         winObject = (void *)intui->IDCMPWindow->UserData;
         UseObject(winObject);

         GT_BeginRefresh(intui->IDCMPWindow);
         DoJazzMethod((void *)intui->IDCMPWindow->UserData, NULL,
                      METHOD_WINDOW_REFRESH, METHOD_END);
         GT_EndRefresh(intui->IDCMPWindow, TRUE);
         GT_ReplyIMsg(intui);
         DropObject(winObject);
         break;

      case GADGETUP:
         {
            struct OutputStruct *io;
            OBJECT object;

            io = FindAttribute(((struct Gadget *)intui->IAddress)->UserData,
                               ATTR_GUIOUTPUT);
            UseObject(object = io->out_object);
            GT_ReplyIMsg(intui);
            DoJazzMethod(object, NULL, io->out_method, (void *)intui->Code,
                                                       METHOD_END);
            DropObject(object);
         }
         break;
      default:
         GT_ReplyIMsg(intui);
         break;
  }
}

void RemoveWinSafely(struct Window *win)
{
   void *object;

   object = win->UserData;
   if (win->UserPort)
   {
      Forbid();
      StripIntuiMessages(win->UserPort, win);
      win->UserPort = NULL;
      ModifyIDCMP(win, NULL);
      win->UserData = NULL;
      Permit();

      /*
       * stop using this object in window structure.
       */
      DropObject(object);
   }
}

void StripIntuiMessages(struct MsgPort *port, struct Window *win)
{
   struct IntuiMessage *msg;
   struct Node *succ;

   msg = (struct IntuiMessage *)port->mp_MsgList.lh_Head;

   while(succ = msg->ExecMessage.mn_Node.ln_Succ)
   {
      if (msg->IDCMPWindow == win)
      {
         Remove(msg);
         ReplyMsg(msg);
      }
      msg = (struct IntuiMessage *)succ;
   }
}
