/*
 * SWRI controller Program.
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

extern struct ExecBase * __far SysBase;
struct IPCBase * __far IPCBase;
struct ShadowBase * __far ShadowBase;
struct DosLibrary * __far DOSBase;

/*
 * external class definitions.
 */
char GuiProcClassName[] = GUIPROCESSCLASS,
     GuiTaskName[] = GUITASK,
     GuiClassName[] = GUICLASS,
     WindowClassName[] = WINDOWCLASS,
     GadgTClassName[] = GADGTCLASS;


struct Task * __far programTask;

#define WINNAME "SWRINDE CONTROL PANEL"

/*
 * This is the data class that I will use.  Don't need to
 *  actually create a class like this, unless I want it automatically
 *  created by the cluster below.
 */

ATTRIBUTE_TAG dataAttrs[] =
                        {
                           {
                              ATTR_SWRINDE_DATA, sizeof(double) * 256, NULL
                           },
                           TAG_END
                        };


/*
 * This is the Cluster that I will create.
 *
 * It creates one instance of the above class.
 */

void blankMethod(METHOD_ARGS);

METHOD_TAG clusterMethods[] =
                        {
                           {
                              METHOD_SWRINDECONTROLCLUSTER_COMPUTE,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)blankMethod, NULL
                           },
                           TAG_END
                        };

/*
 * My local window.
 */

void CWinRemoveMethod(METHOD_ARGS);

BOOL CWinInitMethod(METHOD_ARGS);

METHOD_TAG CWinMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinInitMethod, NULL
                           },
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinRemoveMethod, NULL
                           },
                           TAG_END
                        };

struct SignalSemaphore programSemaphore;

int CXBRK(void)
{
   return(0);
}

chkabort(void)
{
   return(0);
}

void loadControl(void);

void main(void)
{
   CLASS  procClass;
   OBJECT procObject = NULL;

   InitSemaphore(&programSemaphore);
   programTask = FindTask(NULL);

   if (DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 37))
   {
      if (IPCBase = OpenLibrary("ppipc.library", 0))
      {
         if (ShadowBase = (struct ShadowBase *)
                           OpenLibrary("shadow.library", 4))
         {
            PSem(NULL, SHADOW_EXCLUSIVE_SEMAPHORE);
            if ((procClass = FindJazzClass(PROCESSCLASS)) &&
                !(procObject = FindStringInWatchedBinTree(
                               (W_AVLTREE)
                                FindAttribute(procClass, ATTR_OBJECTLIST),
                               SWRINDE_CONTROL_PROGRAM)))
            {
               DropObject(procClass);
               if (InitOOProgram(SWRINDE_CONTROL_PROGRAM))
               {
                  VSem(NULL);
                  loadControl();

                  RemoveCurrentProgram(&programSemaphore);
               } else
               {
                  VPrintf("Coult not init your program\n", NULL);
                  VSem(NULL);
               }

            } else
            {
               VSem(NULL);
               VPrintf("Hey -- your program is already running, no need to run it again!\n", NULL);
               DropObject(procObject);
               DropObject(procClass);
            }

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

void loadControl(void)
{
   CLASS       table[2];
   OBJECT      guiTask;
   W_AVLTREE   wbt;
   BOOL        success;

   if (InitGUISystem())
   {
      /*
       * Find the guiTask.
       */

      if (wbt = FindAttribute(programTask->tc_UserData, ATTR_RESOURCETREE))
         guiTask = FindStringInWatchedBinTree(wbt, GUITASK);
      else
         guiTask = NULL;

      SetupMethodTags(CWinMethods, guiTask, (void *)-1);
      SetupMethodTags(clusterMethods, (void *)-1, (void *)-1);
      DropObject(guiTask);

      /*
       * Create my own Window Class
       */
      success = AddAutoResource(NULL,
                                CreateSubClass(NULL,
                                               WINDOWCLASS,
                                               METACLASS,
                                               CONTROLWINCLASS,
                                               NULL,
                                               NULL,
                                               CWinMethods,
                                               METHOD_END),
                                CONTROLWINCLASS);

      /*
       * Create the window.
       */
      success &= (BOOL)CreateInstance(NULL,
                                      CONTROLWINCLASS,
                                      METACLASS,
                                      METHOD_END);


      /*
       * Create the data class.
       */
      table[0] = CreateSubClass(NULL,
                                ROOTCLASS,
                                METACLASS,
                                SWRINDE_DATA_CLASS,
                                NULL,
                                dataAttrs,
                                METHOD_END);

      /*
       * Now create the data cluster
       */
      table[1] = NULL;
      success &= AddAutoResource(NULL,
                                 CreateSubClass(NULL,
                                                ROOTCLUSTER,
                                                METACLUSTER,
                                                SWRINDE_CONTROL_CLUSTER,
                                                NULL,
                                                NULL,
                                                clusterMethods,
                                                table,
                                                METHOD_END),
                                 SWRINDE_CONTROL_CLUSTER);

      /*
       * Transfer ownership to the programTask.
       */
      success &= AddAutoResource(NULL, table[0], SWRINDE_DATA_CLASS);

      if (success)
         HandleMessages(programTask);
   }
}

/*
 * CWin Class methods.
 */

BOOL CWinInitMethod(METHOD_ARGS)
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
   tag[8].ti_Data = 0;
   tag[9].ti_Tag = TAG_END;

   object = DoJazzMethod(object, class->meta_superClass, METHOD_META_INIT,
                                              NULL,
                                              WINNAME,
                                              NULL,
                                              NULL,
                                              tag, METHOD_END);
   if (!object)
      return FALSE;



   /*
    * Okay, we have a window.  Now we need the close gadget.
    */
   {
      struct NewGadget  ng;

      ng.ng_LeftEdge = 15;
      ng.ng_TopEdge = 45;
      ng.ng_Width = 80;
      ng.ng_Height = 20;
      ng.ng_Flags = 0;
      DropObject(CreateInstance(NULL,
                                GADGTCLASS,
                                METACLASS,
                                object,
                                "QUIT",
                                object,
                                METHOD_META_REMOVE,
                                &ng,
                                BUTTON_KIND,
                                METHOD_END));
   }

   /*
    * Get rid of this object FIRST!  Probably not important, but better
    *  not take any chances, add it priority one.
    */
   return AddAutoResource(programTask->tc_UserData, object, (char *)1);
}

void CWinRemoveMethod(METHOD_ARGS)
{

   Signal(programTask, SIGBREAKF_CTRL_C);
   CallSuper();               /* Let GadTools know to get rid of gadgets. */
}

/*
 * Blank method that is patched by all the other modules.
 */
void blankMethod(METHOD_ARGS)
{
   return;
}