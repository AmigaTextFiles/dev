/*
 * SWRI Random Input Program.
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
#include <exec/lists.h>

#include <math.h>


extern struct ExecBase * __far SysBase;
struct IPCBase * __far IPCBase;
struct ShadowBase * __far ShadowBase;
struct DosLibrary * __far DOSBase;

struct Task * __far programTask;
long __far GlobalNumOpen = 0;

#define MYLOCALINPUTWINDOW "Input Window Class"

extern METHOD_REF REF_IWinInitMethod[];

void IWinRemoveMethod(METHOD_ARGS),
     __saveds IWinDataMethod(METHOD_ARGS),
     IWinBreakMethod(METHOD_ARGS);

BOOL IWinInitMethod(METHOD_ARGS, CLUSTER cluster);

#define MYPATCHES "Patch me up!"

struct MyLocals {
   COMPOSITE ml_composite;
};

ATTRIBUTE_TAG IWinAttrs[] =
                        {
                           {
                              MYPATCHES,
                              sizeof(struct MyLocals),
                              NULL
                           },
                           TAG_END
                        };

METHOD_TAG IWinBreak =
                        {
                           METHOD_META_REMOVE,
                           NULL, NULL,
                           SHADOW_MSG_SYNC,
                           METHOD_FLAG_PROC, 1,
                           (METHODFUNCTYPE)IWinBreakMethod, NULL
                        };

METHOD_TAG IWinMethods[] =
                        {
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)IWinRemoveMethod, NULL
                           },
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)IWinInitMethod,
                                 REF_IWinInitMethod
                           },
                           {
                              "data",
                              NULL, NULL,
                              SHADOW_MSG_FORCE_ASYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)IWinDataMethod, NULL
                           },
                           TAG_END
                        };

void main(void);

int CXBRK(void)
{
   return(0);
}

chkabort(void)
{
   return(0);
}

void loadControl(CLUSTER cluster);

#define PROGRAMNAME "SWRINDE Input Random"

void main()
{
   CLUSTER controlCluster;

   programTask = FindTask(NULL);

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

                  DropObject(controlCluster);
                  RemoveCurrentProgram(NULL);
               } else
               {
                  DropObject(controlCluster);
                  VPrintf("Coult not init your program\n", NULL);
               }

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
}

void loadControl(CLUSTER cluster)
{
   CLASS    guiProcClass;
   OBJECT   guiProcObject;
   int success;

   PSemString(PROGRAMNAME, SHADOW_EXCLUSIVE_SEMAPHORE);

   /*
    * Have we already started?
    */
   if (CreateInstance(NULL, MYLOCALINPUTWINDOW, METACLASS,
                                                cluster, METHOD_END))
   {
      VSemString(PROGRAMNAME);
      return;
   }

   /*
    * No input, so startup all our classes
    */
   guiProcClass = FindJazzClass(GUIPROCESSCLASS);
   guiProcObject = FindStringInWatchedBinTree((W_AVLTREE)
                                FindAttribute(guiProcClass, ATTR_OBJECTLIST),
                                GUITASK);

   SetupMethodTags(IWinMethods, guiProcObject, (void *)-1);

   /*
    * Can't use SetupMethodTags() for these patches because the
    *  MethodTag is not NULL terminated.
    * So setup our patches directly.
    */
   IWinBreak.mtag_procObject = IWinMethods->mtag_procObject;
   IWinBreak.mtag_defnObject = IWinMethods->mtag_defnObject;

   IWinMethods[2].mtag_procObject = IWinMethods[2].mtag_defnObject;

   DropObject(guiProcClass);
   DropObject(guiProcObject);

   /*
    * We want the class to disappear FIRST, before anything else.
    *  So we use the highest priority we have, which is 1.
    * iwinClass is TRANSFERRED to the program's resource tree.
    */
   success = AddAutoResource(NULL,
                             CreateSubClass(NULL,
                                            WINDOWCLASS,
                                            METACLASS,
                                            MYLOCALINPUTWINDOW,
                                            NULL,
                                            IWinAttrs,
                                            IWinMethods,
                                            METHOD_END),
                             (char *)1);

   /*
    * Class is defined - program has successfully started.
    */
   VSemString(PROGRAMNAME);

   /*
    * startup our window.
    */
   success &= (BOOL)CreateInstance(NULL,
                                   MYLOCALINPUTWINDOW,
                                   METACLASS,
                                   cluster,
                                   METHOD_END);

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
       * Patch control window, so that we get notified when the window
       *  goes away.
       */
      success &= AddAutoResource(NULL,
                                 CreateInstance(NULL,
                                                PATCHERCLASS,
                                                METACLASS,
                                                &IWinBreak,
                                                ctrlWindowClass,
                                                METHOD_END),
                                 (char *)2);
      DropObject(ctrlWindowClass);

      /*
       * Oops, is the window already gone?
       */
      if (wbt = FindAttribute(ctrlWindowClass, ATTR_OBJECTLIST))
      {
         if (!wbt->wv_value)
            success = FALSE;
      } else
         success = FALSE;

   }

   if (success)
      HandleMessages(programTask);
}

/*
 * IWin Class methods.
 */
METHOD_REF  REF_IWinInitMethod[] = {
                                      {
                                         'JOBJ',
                                         sizeof(void *),
                                         SHADOW_CLUSTER
                                      },
                                      { TAG_END, 0, 0}
                                   };
BOOL IWinInitMethod(METHOD_ARGS, CLUSTER cluster)
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
   tag[8].ti_Data = 100;
   tag[9].ti_Tag = TAG_END;


   object = DoJazzMethod(object, class->meta_superClass, METHOD_META_INIT,
                                           NULL,
                                           "INPUT CONTROL PANEL",
                                           NULL,
                                           NULL,
                                           tag, METHOD_END);

   {
      struct MyLocals *mls;
      void *args[4];

      if (mls = FindAttribute(object, MYPATCHES))
      {
         mls->ml_composite = CreateInstance(cluster, NULL, NULL,
                                            METHOD_END);
      }
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

void IWinRemoveMethod(METHOD_ARGS)
{
   struct MyLocals *mls;

   DropObject(RemoveAutoResource(programTask->tc_UserData, object, NULL));

   /*
    * Let Input know not to keep sending data out.
    */

   mls = FindAttribute(object, MYPATCHES);

   RemoveObject(SetObject(&mls->ml_composite, NULL));

   CallSuper();               /* Let GadTools know to get rid of gadgets. */
   if (!--GlobalNumOpen)
      Signal(programTask, SIGBREAKF_CTRL_C);
}

void IWinBreakMethod(METHOD_ARGS)
{
   Signal(programTask, SIGBREAKF_CTRL_C);
}

void __saveds IWinDataMethod(METHOD_ARGS)
{
   COMPOSITE comp;
   struct MyLocals *mls;
   OBJECT    objectComp;
   double *table;
   int i, j;

   mls = FindAttribute(object, MYPATCHES);
   comp = (COMPOSITE)GetObject(&mls->ml_composite);

   /*
    * Input window removal NULLs out this field.
    */
   if (!comp)
      return;

   objectComp = FindStringInBinTree(&comp->cc_classes, SWRINDE_DATA_CLASS);
   table = FindAttribute(objectComp, ATTR_SWRINDE_DATA);

   for (j = 0; j <10 && !(SetSignal(NULL, NULL) & SIGBREAKF_CTRL_C); j++)
   {
      for (i = 0; i < 256; i++)
      {
         table[i] = drand48();
      }
      DoJazzMethod(comp, NULL, METHOD_SWRINDECONTROLCLUSTER_COMPUTE,
                               METHOD_END);
   }
   DropObject(objectComp);
   DropObject(comp);

   DJM((void **)&object, NULL);
}
