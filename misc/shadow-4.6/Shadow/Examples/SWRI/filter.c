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

extern struct ExecBase * __far SysBase;
struct IPCBase * __far IPCBase;
struct ShadowBase * __far ShadowBase;
struct DosLibrary * __far DOSBase;
struct GfxBase * __far GfxBase;

struct Task * __far programTask;
long __far GlobalNumOpen = 0;

#define MYLOCALFILTERWINDOW   "Filter Window Class"
#define FILTER                "Filtered Smooth"
#define FILTERWIN             "Smoothing Filter"

extern METHOD_REF REF_FWinInitMethod[];

void FWinRemoveMethod(METHOD_ARGS),
     __saveds FWinPatchMethod(METHOD_ARGS),
     FWinBreakMethod(METHOD_ARGS);

BOOL FWinInitMethod(METHOD_ARGS, CLUSTER cluster);

METHOD_TAG FWinBreak =
                        {
                           METHOD_META_REMOVE,
                           NULL, NULL,
                           SHADOW_MSG_SYNC,
                           METHOD_FLAG_PROC, 1,
                           (METHODFUNCTYPE)FWinBreakMethod, NULL
                        };
METHOD_TAG FWinPatch =
                        {
                           METHOD_SWRINDECONTROLCLUSTER_COMPUTE,
                           NULL, NULL,
                           SHADOW_MSG_CALL,
                           METHOD_FLAG_PROC, 3000,
                           (METHODFUNCTYPE)FWinPatchMethod, NULL
                        };

METHOD_TAG FWinMethods[] =
                        {
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)FWinRemoveMethod, NULL
                           },
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)FWinInitMethod,
                                 REF_FWinInitMethod
                           },
                           TAG_END
                        };

#define MYPROGRAMNAME "SWRINDE Filter"

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
                  if (InitOOProgram(MYPROGRAMNAME))
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

void __regargs *removeFilters(COMPOSITE node,
                             ULONG key,
                             void *garbage)
{
   OBJECT compObject;

   compObject = FindStringInBinTree( &node->cc_classes, FILTER);
   if (compObject)
      RemoveStringBinNode(&node->cc_classes, compObject, FILTER);
   DropObject(compObject);
   return NULL;
}

void loadControl(CLUSTER cluster)
{
   CLASS  guiProcClass;
   OBJECT guiProcObject;
   int success;

   PSemString(MYPROGRAMNAME, SHADOW_EXCLUSIVE_SEMAPHORE);

   /*
    * Check if we've already started up a filter, and just make
    *  another instantiation.
    */
   if (CreateInstance(NULL,
                      MYLOCALFILTERWINDOW,
                      METACLASS,
                      cluster,
                      METHOD_END))
   {
      VSemString(MYPROGRAMNAME);
      return;
   }

   /*
    * No filter, so startup all our classes
    */
   guiProcClass = FindJazzClass(GUIPROCESSCLASS);
   guiProcObject = FindStringInWatchedBinTree((W_AVLTREE)
                                FindAttribute(guiProcClass, ATTR_OBJECTLIST),
                                GUITASK);
   SetupMethodTags(FWinMethods, guiProcObject, (void *)-1);

   /*
    * Can't use SetupMethodTags() for these patches because the
    *  MethodTag is not NULL terminated.
    * So setup our patches directly.
    */
   FWinBreak.mtag_procObject = FWinMethods->mtag_procObject;
   FWinBreak.mtag_defnObject = FWinMethods->mtag_defnObject;

   FWinPatch.mtag_procObject = FWinMethods->mtag_procObject;
   FWinPatch.mtag_defnObject = FWinMethods->mtag_defnObject;

   DropObject(guiProcClass);
   DropObject(guiProcObject);

   /*
    * Transfer the fwinClass into the program's resource tree.
    *  Will be freed automatically when program exits.  Must
    *  be freed first, so we set the priority highest (1).
    */
   success = AddAutoResource(NULL,
                             CreateSubClass(NULL,
                                            WINDOWCLASS,
                                            METACLASS,
                                            MYLOCALFILTERWINDOW,
                                            NULL,
                                            NULL,
                                            FWinMethods,
                                            METHOD_END),
                             (char *)1);

   /*
    * Class is defined - program has successfully started.
    */
   VSemString(MYPROGRAMNAME);

   success &= (BOOL)CreateInstance(NULL,
                                   MYLOCALFILTERWINDOW,
                                   METACLASS,
                                   cluster,
                                   METHOD_END);
   {
      META      ctrlWindowClass;
      W_AVLTREE wbt;

      ctrlWindowClass = FindJazzClass(CONTROLWINCLASS);

      /*
       * Add Patches.  Patches must disappear before the windows,
       *  so we add them at a high priority (2).  Remember that Resources
       *  in AVLTree ordering have high priorities in low numbers and
       *  vice-versa
       */

      /*
       * Patch control window, so that we get notified when the window
       *  goes away.
       */
      success &= AddAutoResource(NULL,
                                 CreateInstance(NULL,
                                                PATCHERCLASS,
                                                METACLASS,
                                                &FWinBreak,
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
       * The actual filtering patch.  This patch filters the data, and adds
       *  the filtered data to the cluster.
       */
      success &= AddAutoResource(NULL,
                                 CreateInstance(NULL,
                                                PATCHERCLASS,
                                                METACLASS,
                                                &FWinPatch,
                                                cluster,
                                                METHOD_END),
                                 (char *)2);

      DropObject(ctrlWindowClass);
   }

   if (success)
      HandleMessages(programTask);

   /*
    * Have to Remove all those old filter objects from all composites.
    */
   {
      W_AVLTREE wbt;

      wbt = FindAttribute(cluster, ATTR_OBJECTLIST);
      DoInOrderBinTree(&wbt->wv_value, removeFilters, NULL);
   }
}

/*
 * FWin Class methods.
 */
METHOD_REF  REF_FWinInitMethod[] = {
                                      {
                                         'JOBJ',
                                         sizeof(void *),
                                         SHADOW_CLUSTER
                                      },
                                      { TAG_END, 0, 0}
                                   };
BOOL FWinInitMethod(METHOD_ARGS, CLUSTER cluster)
{
   struct TagItem tag[10];

   tag[0].ti_Tag = WA_Width;
   tag[0].ti_Data = 150;
   tag[1].ti_Tag = WA_Height;
   tag[1].ti_Data = 100;
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
   tag[7].ti_Data = 0;
   tag[8].ti_Tag = WA_Top;
   tag[8].ti_Data = 200;
   tag[9].ti_Tag = TAG_END;

   object = DoJazzMethod(object, class->meta_superClass, METHOD_META_INIT,
                                           NULL,
                                           FILTERWIN,
                                           NULL,
                                           NULL,
                                           tag, METHOD_END);

   DoJazzMethod(object, NULL, METHOD_WINDOW_REFRESH, METHOD_END);
   {
      void *args[4];

      args[0] = object;
      args[1] = object->cob_class;
      args[2] = "data";
       args[3] = METHOD_END;

      DJM(args, SHADOW_MSG_FINDMETHOD);
   }

   if (AddAutoResource(programTask->tc_UserData, object, NULL))
   {
      GlobalNumOpen++;
      return TRUE;
   }
   return FALSE;
}

void FWinRemoveMethod(METHOD_ARGS)
{
   DropObject(RemoveAutoResource(programTask->tc_UserData, object, NULL));

   CallSuper();               /* Let GadTools know to get rid of gadgets. */
   if (!--GlobalNumOpen)
      Signal(programTask, SIGBREAKF_CTRL_C);
}

void FWinBreakMethod(METHOD_ARGS)
{
   Signal(programTask, SIGBREAKF_CTRL_C);
}

void __saveds FWinPatchMethod(METHOD_ARGS)
{
   OBJECT compObject,
          newCompObject;
   double *table1,
          *table2;
   int i;

   compObject = FindStringInBinTree(&((COMPOSITE)object)->cc_classes,
                                SWRINDE_DATA_CLASS);
   table1 = FindAttribute(compObject, ATTR_SWRINDE_DATA);

   if (!(newCompObject = FindStringInBinTree(&((COMPOSITE)
                                              object)->cc_classes,
                                             FILTER)))
   {
      newCompObject = CreateInstance(compObject->cob_class, NULL, NULL,
                                     METHOD_END);
      if (newCompObject)
         AddNodeStringBinTree(&((COMPOSITE)object)->cc_classes,
                              newCompObject, FILTER);
      AddAutoResource(programTask->tc_UserData,
                      UseObject(newCompObject),
                      FILTER);

   }

   table2 = FindAttribute(newCompObject, ATTR_SWRINDE_DATA);

   if (table2)
   {
      table2[0] = table1[0] * 6;

      for(i = 1; i < 256; i++)
         table2[i] = table2[i - 1] - ((i < 5)?table1[0]:
                                             table1[i - 5]) + table1[i];

      for(i = 0; i < 256; i++)
         table2[i] = table2[i] / 6.0;
/*
      table2[0] = table2[1] = table2[2] = table2[3] = table2[4] = 0.0;
      for(i = 5; i < 256; i++)
         table2[i] = (table1[i] + table1[i - 1] + table1[i - 2] +
                      table1[i - 3] + table1[i - 4] + table1[i - 5])/6.0;
*/
   }

   DropObject(compObject);
   DropObject(newCompObject);
}
