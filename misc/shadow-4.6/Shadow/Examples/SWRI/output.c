/*
 * SWRI Display Program.
 *
 * © Copyright 1991, ALl Rights Reserved
 *
 * David C. Navas
 */
#include <shadow/semaphore.h>
#include "control.h"
#include "/Gui/gui.h"

#include <ipc.h>
#include <shadow/shadow_proto.h>
#include <shadow/shadow_pragmas.h>
#include <dos/dostags.h>

#include <math.h>
#include <stdio.h>

#include <graphics/gfxmacros.h>
#include <proto/graphics.h>

extern struct ExecBase * __far SysBase;
struct IPCBase * __far IPCBase;
struct ShadowBase * __far ShadowBase;
struct DosLibrary * __far DOSBase;
struct GfxBase * __far GfxBase;

struct Task * __far programTask;
#define PROGRAMNAME "SWRINDE Output"

/*
 * The number of windows we have open.
 */
ULONG __far GlobalNumOpen = 0;
/*
 * the global window tree, which holds all the windows
 * interested in getting updated visuals.
 */
AVLTREE __far OutputClassTree = NULL;

/*
 * ==========================================================================
 * =                                                                        =
 * =            Class definition for our Window Class.                      =
 * =                                                                        =
 * ==========================================================================
 */

#define MYLOCALOUTPUTWINDOW "Output Window Class"

/*
 * Attributes for our window class.
 */
#define MYPATCHES "Patch me up for ouput!"
struct MyLocals {
   double             ml_dispInfo[256];
};
ATTRIBUTE_TAG OWinAttrs[] =
                        {
                           {
                              MYPATCHES,
                              sizeof(struct MyLocals),
                              NULL
                           },
                           TAG_END
                        };

/*
 * The Method References structures for our window class.
 */
extern METHOD_REF REF_OWinInitMethod[];

/*
 * Methods for your window class.
 */
void OWinRemoveMethod(METHOD_ARGS),
     __saveds OWinRefreshMethod(METHOD_ARGS);
BOOL OWinInitMethod(METHOD_ARGS, CLUSTER cluster);

METHOD_TAG OWinMethods[] =
                        {
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)OWinRemoveMethod, NULL
                           },
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)OWinInitMethod,
                                 REF_OWinInitMethod
                           },
                           {
                              METHOD_WINDOW_REFRESH,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)OWinRefreshMethod, NULL
                           },
                           TAG_END
                        };

/*
 * Two patches that we make.
 */
/*
 * First, the method description that patches the control window Close
 *  method, so that we can exit our program when the control window goes
 *  away.
 */
void OWinBreakMethod(METHOD_ARGS);
METHOD_TAG OWinBreak =
                        {
                           METHOD_META_REMOVE,
                           NULL, NULL,
                           SHADOW_MSG_SYNC,
                           METHOD_FLAG_PROC, 1,
                           (METHODFUNCTYPE)OWinBreakMethod, NULL
                        };
/*
 * Second, the method description that patches the control method
 *  that is called when new infomation is presented to the system.
 */
void OWinPatchMethod(METHOD_ARGS);
METHOD_TAG OWinPatch =
                        {
                           METHOD_SWRINDECONTROLCLUSTER_COMPUTE,
                           NULL, NULL,
                           SHADOW_MSG_CALL,
                           METHOD_FLAG_PROC, -3000,
                           (METHODFUNCTYPE)OWinPatchMethod, NULL
                        };

int CXBRK(void)
{
   return(0);
}

chkabort(void)
{
   return(0);
}

void loadControl(CLUSTER cluster);

void main(void)
{
   CLUSTER controlCluster;

   programTask = FindTask(NULL);

   if (GfxBase = OpenLibrary("graphics.library", 0))
   {
      if (DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 37))
      {
         if (IPCBase = OpenLibrary("ppipc.library", 0))
         {
            if (ShadowBase = (struct ShadowBase *)
                              OpenLibrary("shadow.library", 4))
            {
               if (controlCluster = FindJazzCluster(SWRINDE_CONTROL_CLUSTER))
               {
                  if (InitOOProgram(PROGRAMNAME))
                  {
                     loadControl(controlCluster);

                     RemoveCurrentProgram(NULL);
                  } else
                  {
                     VPrintf("Coult not init your program\n", NULL);
                  }

                  DropObject(controlCluster);

               } else
                  VPrintf("Hey -- you need to run the control program first!\n", NULL);

               CloseLibrary(ShadowBase);
            }
            else
               VPrintf("requires shadow.library V4.3 in libs:\n", NULL);

            CloseLibrary(IPCBase);
         }
         else
            VPrintf("requires ppipc.library in libs:\n", NULL);
      }
      else
      {
         DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 0);
         Write(Output(), "Sorry, use 2.0\n", 15);
      }

      CloseLibrary(DOSBase);
      CloseLibrary(GfxBase);
   }
}

/*
 * This function is used as a callback to RecurseBinTree.
 * Used in order to change all the data in all of the output
 * windows.
 */
void __regargs *UpdateAndRefresh(OBJECT window,
                                 ULONG  key,
                                 double *data)
{
   int i;
   double *table;
   struct RastPort *rp;
   struct WindowObject *wo;
   WORD top, left;

   table = FindAttribute(window, MYPATCHES);
   wo    = FindAttribute(window, ATTR_WINDOW);

   if (!wo->wo_window || !table)
   {
      return NULL;
   }

   rp   = wo->wo_window->RPort;
   left = wo->wo_window->BorderLeft;
   top  = wo->wo_window->BorderTop;

   /*
    * Clear window.
    */
   SetWrMsk(rp, 1);
   SetAPen(rp, 0);
   RectFill(rp, 2 + left, 2 + top, 258 + left, 102 + top);
   SetWrMsk(rp, -1);

   for(i = 0; i <256; i++)
   {
      table[i] = data[i];
   }

   /*
    * Redraw window.
    */
   DoJazzMethod(window, NULL, METHOD_WINDOW_REFRESH, METHOD_END);

   return NULL;
}

void loadControl(CLUSTER cluster)
{
   CLASS    guiProcClass;
   OBJECT   guiProcObject;
   int      success;

   /*
    * Make sure we only have one of these programs open at a time.
    */
   PSemString(PROGRAMNAME, SHADOW_EXCLUSIVE_SEMAPHORE);

   /*
    * Is this program already running?
    */
   if (CreateInstance(NULL, MYLOCALOUTPUTWINDOW, METACLASS,
                            cluster, METHOD_END))
   {
      VSemString(PROGRAMNAME);
      return;
   }

   /*
    * No output, so startup all our classes
    */
   guiProcClass = FindJazzClass(GUIPROCESSCLASS);
   guiProcObject = FindStringInWatchedBinTree((W_AVLTREE)
                                FindAttribute(guiProcClass, ATTR_OBJECTLIST),
                                GUITASK);
   SetupMethodTags(OWinMethods, guiProcObject, (void *)-1);

   /*
    * Can't use SetupMethodTags() for these patches because the
    *  MethodTag is not NULL terminated.
    * So setup our patches directly.
    */
   OWinBreak.mtag_procObject = OWinMethods->mtag_procObject;
   OWinBreak.mtag_defnObject = OWinMethods->mtag_defnObject;

   OWinPatch.mtag_procObject = OWinMethods->mtag_procObject;
   OWinPatch.mtag_defnObject = OWinMethods->mtag_defnObject;

   DropObject(guiProcClass);
   DropObject(guiProcObject);

   /*
    * We want the class to disappear FIRST, before anything else.
    *  So we use the highest priority we have, which is 1.
    * owinClass is TRANSFERRED to the program's resource tree.
    */
   success = AddAutoResource(NULL,
                             CreateSubClass(NULL, WINDOWCLASS, METACLASS,
                                            MYLOCALOUTPUTWINDOW,
                                            NULL,
                                            OWinAttrs,
                                            OWinMethods,
                                            METHOD_END),
                             (char *)1);

   /*
    * Class is defined - program has successfully started.
    */
   VSemString(PROGRAMNAME);

   /*
    * startup our window.
    */
   success &= (int)CreateInstance(NULL, MYLOCALOUTPUTWINDOW, METACLASS,
                                        cluster, METHOD_END);

   {
      META        ctrlWindowClass;
      W_AVLTREE   wbt;

      ctrlWindowClass = FindJazzClass(CONTROLWINCLASS);

      /*
       * Add Patches.  Patches must disappear before the windows,
       *  so we add them at a high priority (2).  Remember that Resources
       *  in AVLTree ordering have high priorities in low numbers and
       *  vice-versa
       */

      /*
       * Patch control window, so that we get notified when the control window
       *  goes away.
       */

      success &= AddAutoResource(NULL,
                                 CreateInstance(NULL, PATCHERCLASS, METACLASS,
                                                &OWinBreak,
                                                ctrlWindowClass,
                                                METHOD_END),
                                 (char *)2);


      /*
       * Oops, was the window already away?
       */
      if (wbt = FindAttribute(ctrlWindowClass, ATTR_OBJECTLIST))
      {
         if (!wbt->wv_value)
            success = FALSE;
      } else
         success = FALSE;

      /*
       * The actual output patch -- notification when new
       *  information is presented to the system.
       */
      success &= AddAutoResource(NULL,
                                 CreateInstance(NULL, PATCHERCLASS, METACLASS,
                                                &OWinPatch,
                                                cluster,
                                                METHOD_END),
                                 (char *)2);

      DropObject(ctrlWindowClass);
   }

   if (success)
      HandleMessages(programTask);
}

/*
 * OWin Class methods.
 */
METHOD_REF  REF_OWinInitMethod[] = {
                                       {
                                          'JOBJ',
                                          sizeof(void *),
                                          SHADOW_CLUSTER
                                       },
                                       {
                                          TAG_END,
                                          0,
                                          0
                                       }
                                    };
BOOL OWinInitMethod(METHOD_ARGS, CLUSTER cluster)
{
   struct TagItem tag[10];

   tag[0].ti_Tag = WA_InnerWidth;
   tag[0].ti_Data = 261;
   tag[1].ti_Tag = WA_InnerHeight;
   tag[1].ti_Data = 105;
   tag[2].ti_Tag = WA_MinWidth;
   tag[2].ti_Data = 60;
   tag[3].ti_Tag = WA_MinHeight;
   tag[3].ti_Data = 40;
   tag[4].ti_Tag = WA_MaxWidth;
   tag[4].ti_Data = -1;
   tag[5].ti_Tag = WA_MaxHeight;
   tag[5].ti_Data = -1;
   tag[6].ti_Tag = WA_SimpleRefresh;
   tag[6].ti_Data = TRUE;
   tag[7].ti_Tag = WA_Left;
   tag[7].ti_Data = 250 + GlobalNumOpen * 14;
   tag[8].ti_Tag = WA_Top;
   tag[8].ti_Data = GlobalNumOpen * 10;
   tag[9].ti_Tag = TAG_END;

   object = DoJazzMethod(object, class->meta_superClass, METHOD_META_INIT,
                                           NULL,
                                           "Original Data Window",
                                           NULL,
                                           NULL,
                                           tag, METHOD_END);

   DoJazzMethod(object, NULL, METHOD_WINDOW_REFRESH, METHOD_END);

   /*
    * Add the window to the program's Resource tree.
    * Add the window to the REFRESH tree.
    * change the GlobalNumOpen count.
    */
   if (object && AddAutoResource(programTask->tc_UserData, object, NULL)
       && AddNodeBinTree(&OutputClassTree, object, (ULONG)object))
   {
      GlobalNumOpen++;
      return TRUE;
   }
   return FALSE;
}

/*
 * Remove the window from the Program's Resource tree.
 * Remove it from the REFRESH window list.
 * Then Close the window.
 *
 * if there are no more window's Open (GlobalNumOpen), kill the program
 */
void OWinRemoveMethod(METHOD_ARGS)
{
   DropObject(RemoveAutoResource(programTask->tc_UserData, object, NULL));
   RemoveBinNode(&OutputClassTree, object, (ULONG)object);

   CallSuper();               /* Let GadTools know to get rid of gadgets. */
   if (!--GlobalNumOpen)
      Signal(programTask, SIGBREAKF_CTRL_C);
}

/*
 * When the control window is closed, kill this program.
 */
void OWinBreakMethod(METHOD_ARGS)
{
   Signal(programTask, SIGBREAKF_CTRL_C);
}

/*
 * Refresh the window with the new data.
 */
void __saveds OWinRefreshMethod(METHOD_ARGS)
{
   struct WindowObject *wo;
   double *table;
   int i;
   struct RastPort *rp;
   WORD top, left;
   WORD poly[510];

   table = FindAttribute(object, MYPATCHES);
   wo = FindAttribute(object, ATTR_WINDOW);

   if (!wo->wo_window || !table)
   {
      CallSuper();
      return;
   }

   Move(rp = wo->wo_window->RPort, 2 + (left = wo->wo_window->BorderLeft),
                                   102 + (top = wo->wo_window->BorderTop) -
                             (long)max(0.0, min(100.0, table[0] * 100.0)));

   SetAPen(rp, 1);
   SetWrMsk(rp, 1);
   for(i = 0; i < 255; i++)
   {
      poly[i * 2] = 3 + left + i;
      poly[i * 2 + 1] = top + 102 -
                              (long)max(0.0, min(100.0, table[i + 1] * 100.0));
   }
   PolyDraw(rp, 255, poly);
   SetWrMsk(rp, -1);

   CallSuper();
}

/*
 * Everytime a new bunch of data comes through the patch-chain, this
 *  method is called.
 */
void OWinPatchMethod(METHOD_ARGS)
{
   OBJECT compObject;

/*
 * Get the original data
 */
   compObject = FindStringInBinTree(&((COMPOSITE)object)->cc_classes,
                                SWRINDE_DATA_CLASS);

   if (!compObject)
      return;

   DoPreOrderBinTree(&OutputClassTree,
                     UpdateAndRefresh,
                     FindAttribute(compObject, ATTR_SWRINDE_DATA));
   DropObject(compObject);
}
