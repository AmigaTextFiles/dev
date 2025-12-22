/*
 * Browser Program.
 *
 * å© Copyright 1991, ALl Rights Reserved
 *
 *  David C. Navas
 */
#include <shadow/coreMeta.h>
#include <shadow/coreRoot.h>
#include <shadow/process.h>
#include <shadow/semaphore.h>

/*
 * Strings have to be word-aligned -- so add the space at the end,
 * just in case.
 */
#define GUITASK "Browser's Gui Task\0"
#include "/Gui/gui.h"

#include <ipc.h>
#include <shadow/shadow_proto.h>
#include <shadow/shadow_pragmas.h>
#include <shadow/method.h>
#include <dos/dostags.h>

extern struct ExecBase * __far SysBase;
extern struct IntuitionBase * __far IntuitionBase;
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

/*
 * Global Variables (non-library).
 */
OBJECT __far GlobalDirector = NULL;
struct SignalSemaphore programSemaphore;
struct Task * __far programTask;
long __far GlobalNumOpen = 0;

/*
 * Function prototypes.
 */
void __regargs *addFromBinNodes(void *, ULONG, struct CWinLocalObjects *);
void LoadBrowser(void);


/*
 * ==========================================================================
 * =                                                                        =
 * =            Class definition for the BlockClass.                        =
 * =                                                                        =
 * ==========================================================================
 */

#define BLOCKCLASS   "Browser Class"

/*
 * Attributes
 */
#define ATTR_BLOCKDIR "director"

ATTRIBUTE_TAG blockAttrs[] = {
                                ATTR_BLOCKDIR, 2 * sizeof(void *), NULL,
                                TAG_END
                             };

/*
 * Methods
 */
BOOL BlockInitMethod(METHOD_ARGS);
void BlockRemoveMethod(METHOD_ARGS);
void BlockNotifyMethod(METHOD_ARGS, long flags,
                                       W_VALUE watcher,
                                       void *first,
                                       void *second,
                                       OBJECT dispatch);
METHOD_TAG blockMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_FORCE_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)BlockInitMethod, NULL
                           },
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_FORCE_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)BlockRemoveMethod, NULL
                           },
                           {
                              METHOD_DIRECTOR_NOTIFY,
                              NULL, NULL,
                              SHADOW_MSG_FORCE_ASYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)BlockNotifyMethod,
                                 REF_NODENOTIFY
                           },
                           TAG_END
                        };


/*
 * ==========================================================================
 * =                                                                        =
 * =       Class definition for the Class Display Window Class.             =
 * =                                                                        =
 * ==========================================================================
 */

#define CWINCLASS "Window subClass that shows JOBJs"

/*
 * Attributes
 */
#define ATTR_LOCALWIN "local objects"

struct MyNode {
   struct Node node;
   void *object;
};

struct CWinLocalObjects {
   struct MyNode     *lastNode,
                     *nodes;
   struct List       list;
   OBJECT            listObject,
                     object1,
                     object2,
                     object3,
                     object4;
   char              *superClassText;
   OBJECT            director;
   struct MemoryList myMemList;
   META              meta;
};

ATTRIBUTE_TAG CWinAttrs[] =
                        {
                           {ATTR_LOCALWIN, sizeof(struct CWinLocalObjects),
                                           NULL},
                           {TAG_END}
                        };

/*
 * MethodRefs
 */
extern METHOD_REF REF_CWinInitMethod[], REF_CWinHitMethod[];

/*
 * Methods
 */
void CWinHitMethod(METHOD_ARGS, long code);
void *CWinInitMethod(METHOD_ARGS, OBJECT parent,
                                  META   meta);
void CWinRemoveMethod(METHOD_ARGS);
void CWinDestroyMethod(METHOD_ARGS);

#define METHOD_GADGET_OPEN_MWIN  "open method display window"
#define METHOD_GADGET_OPEN_AWIN  "open attr display window"
#define METHOD_GADGET_OPEN_OWIN  "open object display"

void CWinOpenMWinMethod(METHOD_ARGS);
void CWinOpenAWinMethod(METHOD_ARGS);
void CWinOpenOWinMethod(METHOD_ARGS);

void CWinNotifyMethod(METHOD_ARGS, long flags,
                                       W_VALUE watcher,
                                       void *first,
                                       void *second);

METHOD_TAG CWinMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              CWinInitMethod, REF_CWinInitMethod
                           },
                           {
                              METHOD_META_DESTROY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinDestroyMethod, NULL
                           },
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinRemoveMethod, NULL
                           },
                           {
                              METHOD_GADGET_SELECT,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinHitMethod,
                                 REF_CWinHitMethod
                           },
                           {
                              METHOD_GADGET_OPEN_MWIN,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinOpenMWinMethod, NULL
                           },
                           {
                              METHOD_GADGET_OPEN_AWIN,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinOpenAWinMethod, NULL
                           },
                           {
                              METHOD_GADGET_OPEN_OWIN,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinOpenOWinMethod, NULL
                           },
                           {
                              METHOD_DIRECTOR_NOTIFY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)CWinNotifyMethod,
                                 REF_NODENOTIFY
                           },
                           TAG_END
                        };

/*
 * ==========================================================================
 * =                                                                        =
 * =       Class definition for the Method Display Window Class.            =
 * =                                                                        =
 * ==========================================================================
 */

#define METWINCLASS "Window subClass that shows Methods"

/*
 * Attributes
 */
struct MWinLocalObjects {
   struct MyNode  *lastNode,
                  *nodes;
   struct List    list;
   OBJECT         object1,
                  object2,
                  object3,
                  object4,
                  object5,
                  director;
   CLASS          class;
};

ATTRIBUTE_TAG MetWinAttrs[] =
                        {
                           {ATTR_LOCALWIN, sizeof(struct MWinLocalObjects),
                                           NULL},
                           {TAG_END}
                        };

/*
 * MethodRefs
 */
extern METHOD_REF REF_MetWinInitMethod[], REF_MetWinHitMethod[],
                  REF_MWinOpenRWinMethod[];

/*
 * Methods
 */
void MetWinUpdateInfo(METHOD_ARGS);
void MetWinHitMethod(METHOD_ARGS, long code);
void *MetWinInitMethod(METHOD_ARGS, OBJECT parent,
                                    CLASS);
void MetWinDestroyMethod(METHOD_ARGS);
void MetWinRemoveMethod(METHOD_ARGS);

void MWinOpenRWinMethod(METHOD_ARGS);

#define METHOD_GADGET_OPEN_RWIN "open argument display window"
#define METHOD_METHOD_UPDATE_INFO "Update Info in Method Window"

METHOD_TAG  MetWinMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              MetWinInitMethod, REF_MetWinInitMethod
                           },
                           {
                              METHOD_META_DESTROY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)MetWinDestroyMethod, NULL
                           },
                           {
                              METHOD_META_REMOVE,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)MetWinRemoveMethod, NULL
                           },
                           {
                              METHOD_GADGET_SELECT,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)MetWinHitMethod,
                                 REF_MetWinHitMethod
                           },
                           {
                              METHOD_GADGET_OPEN_RWIN,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)MWinOpenRWinMethod, NULL
                           },
                           {
                              METHOD_METHOD_UPDATE_INFO,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)MetWinUpdateInfo, NULL
                           },
                           TAG_END
                        };


/*
 * ==========================================================================
 * =                                                                        =
 * =     Class definition for the Attribute Display Window Class.           =
 * =                                                                        =
 * ==========================================================================
 */

#define ATTWINCLASS "Window subClass that shows Attributes"

/*
 * Attributes
 */
struct AWinLocalObjects {
   struct MyNode *lastNode,
                 *nodes;
   struct List   list;
   OBJECT        object1,
                 object2,
                 object3,
                 object4;
   META          meta;
};

ATTRIBUTE_TAG AttWinAttrs[] =
                        {
                           {ATTR_LOCALWIN, sizeof(struct AWinLocalObjects),
                                           NULL},
                           {TAG_END}
                        };

/*
 * MethodRefs
 */
extern METHOD_REF REF_AttWinInitMethod[], REF_AttWinHitMethod[];

/*
 * Methods
 */
void AttWinHitMethod(METHOD_ARGS, long code);
void *AttWinInitMethod(METHOD_ARGS, OBJECT parent, CLASS);
void AttWinDestroyMethod(METHOD_ARGS);

METHOD_TAG AttWinMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              AttWinInitMethod, REF_AttWinInitMethod
                           },
                           {
                              METHOD_META_DESTROY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)AttWinDestroyMethod, NULL
                           },
                           {
                              METHOD_GADGET_SELECT,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)AttWinHitMethod,
                                 REF_AttWinHitMethod
                           },
                           TAG_END
                        };


/*
 * ==========================================================================
 * =                                                                        =
 * =     Class definition for the MethodRef Display Window Class.           =
 * =                                                                        =
 * ==========================================================================
 */

#define REFWINCLASS "Window subClass that shows MethodRefs"

/*
 * Attributes
 */
struct RWinLocalObjects {
   struct MyNode  *lastNode,
                  *nodes;
   struct List    list;
   OBJECT         object1,
                  object2;
   char           *text;
};

ATTRIBUTE_TAG RefWinAttrs[] =
                        {
                           {ATTR_LOCALWIN, sizeof(struct RWinLocalObjects),
                                           NULL},
                           {TAG_END}
                        };

/*
 * MethodRefs
 */
extern METHOD_REF REF_RefWinInitMethod[], REF_RefWinHitMethod[];

/*
 * Methods
 */
void RefWinHitMethod(METHOD_ARGS, long code);
void *RefWinInitMethod(METHOD_ARGS, OBJECT parent,
                                    struct MethodHandler *,
                                    CLASS  mclass);
void RefWinDestroyMethod(METHOD_ARGS);

METHOD_TAG RefWinMethods[] =
                        {
                           {
                              METHOD_META_INIT,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              RefWinInitMethod, REF_RefWinInitMethod
                           },
                           {
                              METHOD_META_DESTROY,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)RefWinDestroyMethod, NULL
                           },
                           {
                              METHOD_GADGET_SELECT,
                              NULL, NULL,
                              SHADOW_MSG_CALL,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)RefWinHitMethod,
                                 REF_RefWinHitMethod
                           },
                           TAG_END
                        };


/*
 * ==========================================================================
 * =                                                                        =
 * =                    F  U  N  C  T  I  O  N  S                           =
 * =                                                                        =
 * ==========================================================================
 */

/*
 * ^C -- just say no.
 */
int CXBRK(void)
{
   return(0);
}

/*
 * no!
 */
chkabort(void)
{
   return(0);
}

/*
 * Okay, here's the main.
 */
void main(void)
{

   programTask = FindTask(NULL);

   /*
    * Open Libraries and startup the program for SHADOW.
    */
   InitSemaphore(&programSemaphore);

   if (DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 37))
   {
      if (IPCBase = OpenLibrary("ppipc.library", 0))
      {

         if (ShadowBase = (struct ShadowBase *)
                          OpenLibrary("shadow.library", 4))
         {

            if (InitOOProgram("Browser Program"))
            {

               /*
                * Okay, run the Browser.
                */
               LoadBrowser();
               RemoveCurrentProgram(&programSemaphore);
            } else
               VPrintf("Can't init Browser program.\n", NULL);

            CloseLibrary(ShadowBase);
         } else
            VPrintf("requires shadow.library 4.3 in libs:\n", NULL);

         CloseLibrary(IPCBase);
      } else
         VPrintf("requires ppipc.library in libs:\n", NULL);
   } else
   {
      DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 0);
      Write(Output(), "Sorry, use 2.0\n", 15);
   }
   CloseLibrary(DOSBase);
}

void LoadBrowser(void)
{
   OBJECT    guiTask;
   W_AVLTREE wbt;
   int success;

#ifndef NDEBUG
   ULONG args[10];
   long mem2;

   args[0] = mem2 = AvailMem(MEMF_ANY);
#endif

   /*
    * Have we already started a browser ???
    * if so, we can just send it a method and shut ourselves down.
    */
   if (CreateInstance(NULL, BLOCKCLASS, METACLASS, METHOD_END))
      return;

   /*
    * Initialize the GUI
    */
   success = InitGUISystem();

#ifndef NDEBUG
   VPrintf("MemStart %ld\n", args);
#endif

   if (wbt = FindAttribute(programTask->tc_UserData, ATTR_RESOURCETREE))
      guiTask = FindStringInWatchedBinTree(wbt, GUITASK);
   else
      guiTask = NULL;

   SetupMethodTags(CWinMethods, guiTask, (void *)-1);
   SetupMethodTags(MetWinMethods, guiTask, (void *)-1);
   SetupMethodTags(AttWinMethods, guiTask, (void *)-1);
   SetupMethodTags(RefWinMethods, guiTask, (void *)-1);
   SetupMethodTags(blockMethods, guiTask, (void *)-1);

   DropObject(guiTask);

   /*
    * Create BlockClass.
    */

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             GUICLASS,
                                             METACLASS,
                                             BLOCKCLASS,
                                             NULL,
                                             blockAttrs,
                                             blockMethods,
                                             METHOD_END),
                              BLOCKCLASS);

   /*
    * Create the window classes.
    */
   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                            WINDOWCLASS,
                                            METACLASS,
                                            CWINCLASS,
                                            NULL,
                                            CWinAttrs,
                                            CWinMethods,
                                            METHOD_END),
                              CWINCLASS);

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             WINDOWCLASS,
                                             METACLASS,
                                             METWINCLASS,
                                             NULL,
                                             MetWinAttrs,
                                             MetWinMethods,
                                             METHOD_END),
                              METWINCLASS);

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             WINDOWCLASS,
                                             METACLASS,
                                             ATTWINCLASS,
                                             NULL,
                                             AttWinAttrs,
                                             AttWinMethods,
                                             METHOD_END),
                              ATTWINCLASS);

   success &= AddAutoResource(NULL,
                              CreateSubClass(NULL,
                                             WINDOWCLASS,
                                             METACLASS,
                                             REFWINCLASS,
                                             NULL,
                                             RefWinAttrs,
                                             RefWinMethods,
                                             METHOD_END),
                              REFWINCLASS);

   /*
    * Create the top level window.
    */
   success &= (BOOL)CreateInstance(NULL, BLOCKCLASS, METACLASS, METHOD_END);


#ifndef NDEBUG
   args[0] = mem2 - AvailMem(MEMF_ANY);

   VPrintf("Memory Usage %ld\n", args);
#endif


   /*
    * basically Wait for everything to shut down.
    *
    * Nothing is actually going to use these ports, but they ARE
    *  allocated, so I might as well use them.
    */
   if (success)
      HandleMessages(programTask);

#ifndef NDEBUG
   args[0] = AvailMem(MEMF_ANY);
   VPrintf("MemEnd %ld\n", args);
#endif
}


/*
 * Add all of the objects into the list....
 */
void __regargs *addFromBinNodes(void *value,
                                ULONG name,
                                struct CWinLocalObjects *local)
{
   struct MyNode *node;

   if (!(node = AllocateItem(&local->myMemList)))
      return (void *)-1;

   if (name == (long)value)
   {
      char buffer[20];
      long name2;

      name2 = name;

      RawDoFmt("Object at: %lx", &name2, SprintfCallback, buffer);
      node->node.ln_Name = UseString(buffer);
   }
   else
      node->node.ln_Name = UseString((char *)name);

   /*
    * The object might reference this CWindow.
    *  THEREFORE, it hangs, unless reference removed during remove
    *   method, as opposed to DESTROY method.
    *   [Because DESTROY would never get called, it self-references.]
    */

   node->object = value;
   UseObject(value);

   AddTail(&local->list, node);
   return NULL;
}


/*
 * ==========================================================================
 * =                                                                        =
 * =            ALL OF THE CLASS METHODS ARE BELOW.                         =
 * =                                                                        =
 * ==========================================================================
 */

/*
 * Block Class methods.
 */
BOOL BlockInitMethod(METHOD_ARGS)
{
   OBJECT *director, handle;

   director = FindAttribute(object, ATTR_BLOCKDIR);

   if (CallSuper())
   {
      OBJECT window;
      CLASS  windowClass;

      /*
       * Create the example Global Director which watches all of the
       *  window classes' GUICHILDREN attribute.
       */
      if (!GlobalDirector)
      {
         /*
          * Get a director object.
          */
         GlobalDirector = CreateInstance(NULL,
                                         DIRECTORCLASS,
                                         METACLASS,
                                         "WatchWindows",
                                         object,
                                         METHOD_DIRECTOR_NOTIFY,
                                         (W_INSERT_NODE | W_REMOVE) |
                                           (SHADOW_CLASS << 16) |
                                           W_FLAG_AUTOBREAK  |
                                           W_FLAG_AUTOREMOVE,
                                         METHOD_END);

         /*
          * Establish the actual connection.  We don't care if
          * it doesn't actually Open, so that makes things easier.
          *
          * We are watching all the ATTR_GUICHILDREN of every instance
          *  whose class is a subclass of WINDOWCLASS
          */
         windowClass = FindJazzClass(WINDOWCLASS);
         DropObject(DoJazzMethod(GlobalDirector,
                                 NULL,
                                 METHOD_DIRECTOR_ESTABLISH,
                                 ATTR_GUICHILDREN,
                                 windowClass,
                                 METHOD_END));
         DropObject(windowClass);

         /*
          * Why is this at priority one?
          * Well, there's this race condition....  You can either shut
          *  this down FIRST, or you can make the notification in
          *  CWIN ASYNC.  I like this better.
          */
         AddAutoResource(programTask->tc_UserData, GlobalDirector, (char *)1);
      }


      /*
       * Create the director to watch the children of this object.
       *
       * When this object's children reaches zero, this object
       *  should GO AWAY!
       */

      *director = CreateInstance(NULL,
                                 DIRECTORCLASS,
                                 METACLASS,
                                 "WatchBlockedChildren",
                                 object,
                                 METHOD_DIRECTOR_NOTIFY,
                                 (W_INSERT_NODE | W_REMOVE) |
                                   (SHADOW_OBJECT << 16) |
                                   W_FLAG_AUTOBREAK |
                                   W_FLAG_AUTOREMOVE,
                                 METHOD_END);
      /*
       * Establish the conection for the director.
       */
      if (handle = DoJazzMethod(*director, NULL, METHOD_DIRECTOR_ESTABLISH,
                                        ATTR_GUICHILDREN,
                                        object,
                                        METHOD_END))
      {
         DropObject(handle);
         if (window = CreateInstance(NULL,
                                     CWINCLASS,
                                     METACLASS,
                                     object,
                                     METHOD_END))
         {
            DropObject(window);
            if (AddAutoResource(programTask->tc_UserData, object, NULL))
            {
               GlobalNumOpen++;
               return TRUE;
            }
         }
      }
      RemoveObject(object);
   }
   return FALSE;
}

void BlockRemoveMethod(METHOD_ARGS)
{
   OBJECT director;

   DropObject(RemoveAutoResource(programTask->tc_UserData, object, NULL));

   director = SetObject(FindAttribute(object, ATTR_BLOCKDIR), NULL);
   RemoveObject(director);

   CallSuper();

   if (!--GlobalNumOpen)
      Signal(programTask, SIGBREAKF_CTRL_C);
}

void BlockNotifyMethod(METHOD_ARGS, long flags,
                                       W_VALUE  watcher,
                                       void *first,
                                       void *second,
                                       OBJECT dispatch)
{
   long *director;

   director = FindAttribute(object, ATTR_BLOCKDIR);
   if (!second)  second = "";

   if (dispatch == GlobalDirector)
   {
      if (flags & W_INSERT)
      {
         VPrintf("Inserted child <%s> into some Window Object.\n",
                  (ULONG *)&second);
      } else
      {
         VPrintf("Removed child <%s> from some Window Object.\n",
                  (ULONG *)&second);
      }
   } else
   {
      if (flags & W_INSERT)
         (director[1])++;
      else if (!(--(director[1])))
      {
         RemoveObject(UseObject(object));
      }
   }
}

/*
 * CWin Class methods.
 */
METHOD_REF REF_CWinInitMethod[] = {
                                     {'JOBJ', sizeof(void *), SHADOW_OBJECT},
                                     {'JOBJ', sizeof(void *), SHADOW_CLASS},
                                     {TAG_END, SHADOW_RETURN_OBJECT, 0}
                                  };
void *CWinInitMethod(METHOD_ARGS, OBJECT parent,
                                  META meta)
{
   struct CWinLocalObjects *mlo;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   NewList(&mlo->list);
   if (!(InitTable(&mlo->myMemList, NULL, NULL, sizeof(struct MyNode))))
   {
      UseObject(object);
      DropObject(object);
      return NULL;
   }

   /*
    * Create the correct window with the correct title....
    */
   {
      struct TagItem tag[8];
      char *string;

      {
         char buffer[128];

         if (!meta)
            strcpy(buffer, "Meta list for system");
         else if (meta->meta_class == meta)
         {
            strcpy(buffer, "Class list for: ");
            strncat(buffer, meta->meta_name, 64);
         } else
         {
            strcpy(buffer, "Object list for: ");
            strncat(buffer, meta->meta_name, 64);
         }
         if (!(string = UseString(buffer)))
         {
            UseObject(object);
            DropObject(object);
            return NULL;
         }
      }

      tag[0].ti_Tag = WA_Width;
      tag[0].ti_Data = 500;
      tag[1].ti_Tag = WA_Height;
      tag[1].ti_Data = 200;
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
      tag[7].ti_Tag = TAG_END;

      object = DoJazzMethod(object, class->meta_superClass, METHOD_META_INIT,
                                                 parent,
                                                 string,
                                                 NULL,
                                                 NULL,
                                                 tag, METHOD_END);
      DropString(string);
      if (!object)
         return NULL;
   }

   mlo->meta = UseObject(meta);

   /*
    * So watch the tree....
    */
   /*
    * Create the watching director object.
    */
   mlo->director = CreateInstance(NULL,
                                  DIRECTORCLASS,
                                  METACLASS,
                                  "Watch Meta",
                                  object,
                                  METHOD_DIRECTOR_NOTIFY,
                                  (W_INSERT_NODE | W_REMOVE) |
                                    (SHADOW_OBJECT << 16) |
                                    W_FLAG_AUTOBREAK |
                                    W_FLAG_AUTOREMOVE,
                                  METHOD_END);

   /*
    * Establish the connection.
    */
   DropObject( DoJazzMethod(mlo->director,
                            NULL,
                            METHOD_DIRECTOR_ESTABLISH,
                            (meta)?ATTR_OBJECTLIST:
                                  &ShadowBase->sb_metaTree,
                            meta,
                            METHOD_END));


   /*
    * Copy all the instance objects into the list.
    */
   {
      W_AVLTREE tree;

      tree = (meta)?FindAttribute(meta, "object list"):&ShadowBase->sb_metaTree;
      DoInOrderBinTree(&tree->wv_value, addFromBinNodes, mlo);
      mlo->lastNode = NULL;
   }

   /*
    * Okay, we have a window.  Now we need gadgets.
    */
   {
      struct TagItem tag[3];
      struct NewGadget ng;

      ng.ng_LeftEdge = 50;
      ng.ng_TopEdge = 45;
      ng.ng_Width = 300;
      ng.ng_Height = 90;
      ng.ng_Flags = PLACETEXT_ABOVE;
      tag[0].ti_Tag = GTLV_Labels;
      tag[0].ti_Data = (ULONG)&mlo->list;

      if (!meta || meta->meta_class == meta)
         tag[1].ti_Tag = GTLV_ShowSelected;
      else
         tag[1].ti_Tag = 0;

      tag[1].ti_Data = NULL;
      tag[2].ti_Tag = TAG_END;
      mlo->listObject = CreateInstance(NULL,
                                       GADGTCLASS,
                                       METACLASS,
                                       object,
                                       (meta)?((meta->meta_class == meta)?
                                                             "Class List:":
                                                             "Instances:")
                                             :"Meta List:",
                                       (!meta || meta->meta_class == meta)?
                                          object:NULL,
                                       METHOD_GADGET_SELECT,
                                       &ng,
                                       LISTVIEW_KIND,
                                       tag,
                                       METHOD_END);

      if (meta && (meta->meta_class != meta))
         return object;

      ng.ng_TopEdge += ng.ng_Height;
      ng.ng_Height = 15;
      ng.ng_Width = 80;
      ng.ng_Flags = PLACETEXT_RIGHT;
      tag[0].ti_Tag = TAG_END;
      mlo->object1 = CreateInstance(NULL,
                                    GADGTCLASS,
                                    METACLASS,
                                    object,
                                    ":Instance size",
                                    object,
                                    METHOD_GADGET_SELECT,
                                    &ng,
                                    NUMBER_KIND,
                                    tag,
                                    METHOD_END);

      ng.ng_TopEdge += ng.ng_Height;
      ng.ng_Height = 15;
      ng.ng_Width = 80;
      ng.ng_Flags = PLACETEXT_RIGHT;
      tag[0].ti_Tag = TAG_END;
      mlo->object2 = CreateInstance(NULL,
                                    GADGTCLASS,
                                    METACLASS,
                                    object,
                                    ":methodTable size",
                                    object,
                                    METHOD_GADGET_SELECT,
                                    &ng,
                                    NUMBER_KIND,
                                    tag,
                                    METHOD_END);

      ng.ng_TopEdge += ng.ng_Height;
      ng.ng_Height = 15;
      ng.ng_Width = 80;
      ng.ng_Flags = PLACETEXT_RIGHT;
      tag[0].ti_Tag = TAG_END;
      mlo->object3 = CreateInstance(NULL,
                                    GADGTCLASS,
                                    METACLASS,
                                    object,
                                    ":attributeTable size",
                                    object,
                                    METHOD_GADGET_SELECT,
                                    &ng,
                                    NUMBER_KIND,
                                    tag,
                                    METHOD_END);

      ng.ng_TopEdge += ng.ng_Height;
      ng.ng_Height = 15;
      ng.ng_Width = 80;
      ng.ng_Flags = PLACETEXT_RIGHT;
      tag[0].ti_Tag = TAG_END;
      mlo->object4 = CreateInstance(NULL,
                                    GADGTCLASS,
                                    METACLASS,
                                    object,
                                    NULL,
                                    object,
                                    METHOD_GADGET_SELECT,
                                    &ng,
                                    TEXT_KIND,
                                    tag,
                                    METHOD_END);

      ng.ng_TopEdge = 45;
      ng.ng_LeftEdge = 370;
      ng.ng_Height = 20;
      ng.ng_Width = 100;
      ng.ng_Flags = 0;
      tag[0].ti_Tag = TAG_END;
      DropObject(CreateInstance(NULL,
                                GADGTCLASS,
                                METACLASS,
                                object,
                                "Methods",
                                object,
                                METHOD_GADGET_OPEN_MWIN,
                                &ng,
                                BUTTON_KIND,
                                tag,
                                METHOD_END));

      ng.ng_TopEdge += ng.ng_Height;
      ng.ng_Height = 20;
      ng.ng_Width = 100;
      ng.ng_Flags = 0;
      tag[0].ti_Tag = TAG_END;
      DropObject(CreateInstance(NULL,
                                GADGTCLASS,
                                METACLASS,
                                object,
                                "Attributes",
                                object,
                                METHOD_GADGET_OPEN_AWIN,
                                &ng,
                                BUTTON_KIND,
                                tag,
                                METHOD_END));

      ng.ng_TopEdge += ng.ng_Height;
      ng.ng_Height = 20;
      ng.ng_Width = 100;
      ng.ng_Flags = 0;
      tag[0].ti_Tag = TAG_END;
      DropObject(CreateInstance(NULL,
                                GADGTCLASS,
                                METACLASS,
                                object,
                                "Instances",
                                object,
                                METHOD_GADGET_OPEN_OWIN,
                                &ng,
                                BUTTON_KIND,
                                tag,
                                METHOD_END));
   }
   return object;
}

void CWinNotifyMethod(METHOD_ARGS, long flags,
                                       W_VALUE watcher,
                                       void *first,
                                       void *second)
{
   struct CWinLocalObjects *mlo;
   struct TagItem tags[2];
   struct MyNode *node;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   if (!mlo->director)
      return;

   tags[0].ti_Tag = GTLV_Labels;
   tags[0].ti_Data = ~0;
   tags[1].ti_Tag = TAG_END;
   DoJazzMethod(mlo->listObject, NULL, METHOD_GADGET_CHANGE,
                                          tags,
                                          METHOD_END);
   if (flags & W_INSERT)
   {

      if (!(node = AllocateItem(&mlo->myMemList)))
         return;
      if (second != first)
      {
         node->node.ln_Name = UseString((char *)second);
      } else
      {
         char buffer[20];

         RawDoFmt("Object at: %lx", &first, SprintfCallback, buffer);

         node->node.ln_Name = UseString(buffer);
      }

      node->object = first;
      UseObject(first);
      AddTail(&mlo->list, node);
   } else if (flags & W_REMOVE)
   {
      char *name;

      if (second != first)
      {
         name = FindString((char *)second);
      } else
      {
         char buffer[20];

         RawDoFmt("Object at: %lx", &first, SprintfCallback, buffer);
         name = FindString(buffer);
      }
      for(node = (struct MyNode *)mlo->list.lh_Head;
          node->node.ln_Succ;
          node = (struct MyNode *)node->node.ln_Succ)
      {
         if (node->node.ln_Name == name && node->object == first)
         {
            QuickDropString(name);
            DropObject(first);
            Remove(node);
            FreeItem(&mlo->myMemList, node);
            if (mlo->lastNode == node)
               mlo->lastNode = NULL;
            break;
         }
      }
   }
   tags[0].ti_Tag = GTLV_Labels;
   tags[0].ti_Data = (ULONG)&mlo->list;
   DoJazzMethod(mlo->listObject, NULL, METHOD_GADGET_CHANGE,
                                          tags,
                                          METHOD_END);
}

void CWinRemoveMethod(METHOD_ARGS)
{
   struct CWinLocalObjects *mlo;
   struct Node *node;


   mlo = FindAttribute(object, ATTR_LOCALWIN);
   RemoveObject(SetObject(&mlo->director, NULL));

   node = mlo->list.lh_Head;

   UseObject(object);         /* Make sure object stays around! */
   CallSuper();               /* Let GadTools know to get rid of gadgets. */

   NewList(&mlo->list);
   for(; node->ln_Succ; node = node->ln_Succ)
   {
      DropObject(((struct MyNode *)node)->object);
      QuickDropString(node->ln_Name);
   }
   DropObject(object);        /* OKAY, now we're done! */
}

void CWinDestroyMethod(METHOD_ARGS)
{
   struct CWinLocalObjects *mlo;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   DropObject(mlo->object1);
   DropObject(mlo->object2);
   DropObject(mlo->object3);
   DropObject(mlo->object4);
   DropObject(mlo->listObject);
   DropObject(mlo->meta);
   QuickDropString(mlo->superClassText);

   FreeTable(&mlo->myMemList);
   CallSuper();
}


/*
 * Selected a new item in the list.
 * So update all of our information.
 * Only called if this is a class information window -- not for an
 *  instances window.
 */
METHOD_REF REF_CWinHitMethod[] = {
                                    'long', sizeof(long), 0,
                                    TAG_DONE
                                 };

void CWinHitMethod(METHOD_ARGS, long code)
{
   struct CWinLocalObjects *mlo;
   META   meta;
   struct TagItem tags[2];

   mlo = FindAttribute(object, ATTR_LOCALWIN);

   {
      struct Node *node;

      for(node = mlo->list.lh_Head; code; --code)
         node = node->ln_Succ;
      mlo->lastNode = (struct MyNode *)node;
   }

   /*
    * Instance size gadget.
    */
   tags[0].ti_Tag = GTNM_Number;
   tags[0].ti_Data = ((META)(mlo->lastNode->object))->meta_size;
   tags[1].ti_Tag = TAG_END;
   DoJazzMethod(mlo->object1, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * Method table size in bytes.
    */
   tags[0].ti_Data = ((META)
                      (mlo->lastNode->object))->meta_verbs.mt_num *
                     sizeof(struct MethodHandler);
   DoJazzMethod(mlo->object2, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * Attribute table size in bytes.
    */
   tags[0].ti_Data = ((META)
                      (mlo->lastNode->object))->meta_attributes.att_num *
                     sizeof(struct Attribute);
   DoJazzMethod(mlo->object3, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * superClass name.
    */
   tags[0].ti_Tag = GTTX_Text;
   meta = ((META)(mlo->lastNode->object))->meta_superClass;
   if (meta)
   {
      QuickDropString(mlo->superClassText);

      tags[0].ti_Data = (ULONG)(mlo->superClassText =
                        UseString(meta->meta_name));
   }
   else
      tags[0].ti_Data = 0L;
   DoJazzMethod(mlo->object4, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);
}

void CWinOpenMWinMethod(METHOD_ARGS)
{
   struct CWinLocalObjects *mlo;
   struct GUIStruct *gui;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   gui = FindAttribute(object, ATTR_GUISTRUCT);

   if (!mlo->lastNode)
      return;

   DropObject(CreateInstance(NULL,
                             METWINCLASS,
                             METACLASS,
                             gui->gui_parent,
                             mlo->lastNode->object,
                             METHOD_END));
}

void CWinOpenAWinMethod(METHOD_ARGS)
{
   struct CWinLocalObjects *mlo;
   struct GUIStruct *gui;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   gui = FindAttribute(object, ATTR_GUISTRUCT);

   if (!mlo->lastNode)
      return;

   DropObject(CreateInstance(NULL,
                             ATTWINCLASS,
                             METACLASS,
                             gui->gui_parent,
                             mlo->lastNode->object,
                             METHOD_END));
}

void CWinOpenOWinMethod(METHOD_ARGS)
{
   struct CWinLocalObjects *mlo;
   struct GUIStruct *gui;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   gui = FindAttribute(object, ATTR_GUISTRUCT);

   if (!mlo->lastNode)
      return;

   DropObject(CreateInstance(NULL,
                             CWINCLASS,
                             METACLASS,
                             gui->gui_parent,
                             mlo->lastNode->object,
                             METHOD_END));
}

/*
 * MetWin Class methods.
 */
METHOD_REF REF_MetWinInitMethod[] = {
                                       {'JOBJ', sizeof(void *),
                                                SHADOW_OBJECT},
                                       {'JOBJ', sizeof(void *),
                                                SHADOW_CLASS},
                                       {TAG_END, SHADOW_RETURN_OBJECT, 0}
                                    };
void *MetWinInitMethod(METHOD_ARGS, OBJECT parent,
                                    CLASS theClass)
{
   struct NewGadget ng;
   struct TagItem tag[8];
   struct MWinLocalObjects *mlo;
   char buffer[128];

   tag[0].ti_Tag = WA_Width;
   tag[0].ti_Data = 500;
   tag[1].ti_Tag = WA_Height;
   tag[1].ti_Data = 200;
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
   tag[7].ti_Tag = TAG_END;

   object = DoJazzMethod(object, class->meta_superClass, MethodID,
                                                 parent,
                                                 "Method Window",
                                                 NULL,
                                                 NULL,
                                                 tag, METHOD_END);
   if (!object)
      return NULL;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   mlo->class = UseObject(theClass);
   NewList(&mlo->list);

   if (theClass->ccl_verbs.mt_num)
   {
      struct MethodHandler *methods;
      struct MyNode *nodes;
      int i;

      mlo->nodes = AllocVec(sizeof(struct MyNode) * theClass->ccl_verbs.mt_num,
                            MEMF_PUBLIC);

      nodes = mlo->nodes;
      for (methods = theClass->ccl_verbs.mt_methods, i = 0;
           i < theClass->ccl_verbs.mt_num;
           i++, methods++)
      {
         nodes->node.ln_Name = UseString(methods->mh_methodID);
         nodes->object = methods;
         AddTail(&mlo->list, nodes);
         nodes++;
      }

   }

   ng.ng_LeftEdge = ng.ng_TopEdge = 50;
   ng.ng_Width = 300;
   ng.ng_Height = 90;
   ng.ng_Flags = PLACETEXT_ABOVE;
   tag[0].ti_Tag = GTLV_Labels;
   tag[0].ti_Data = (ULONG)&mlo->list;
   tag[1].ti_Tag = GTLV_ShowSelected;
   tag[1].ti_Data = NULL;
   tag[2].ti_Tag = TAG_END;
   strcpy(buffer, "Method list for class: ");
   strncat(buffer, theClass->ccl_name, 14);
   strcat(buffer, "...");
   DropObject(CreateInstance(NULL,
                             GADGTCLASS,
                             METACLASS,
                             object,
                             buffer,
                             object,
                             METHOD_GADGET_SELECT,
                             &ng,
                             LISTVIEW_KIND,
                             tag,
                             METHOD_END));

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 170;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object1 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":Controlled",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 TEXT_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 170;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object2 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":Defined",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 TEXT_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 170;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object3 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":Function address",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 170;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object4 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":threadStat",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 TEXT_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge = 50;
   ng.ng_LeftEdge = 370;
   ng.ng_Height = 20;
   ng.ng_Width = 100;
   ng.ng_Flags = 0;
   tag[0].ti_Tag = TAG_END;
   DropObject(CreateInstance(NULL,
                             GADGTCLASS,
                             METACLASS,
                             object,
                             "Arguments",
                             object,
                             METHOD_GADGET_OPEN_RWIN,
                             &ng,
                             BUTTON_KIND,
                             tag,
                             METHOD_END));

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 25;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object5 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":Patches",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);

   /*
    * So watch the Patch list....
    */
   {
      mlo->director = CreateInstance(NULL,
                                     DIRECTORCLASS,
                                     METACLASS,
                                     "Watch Patches",
                                     object,
                                     METHOD_METHOD_UPDATE_INFO,
                                       (W_INSERT_NODE | W_REMOVE) |
                                       (SHADOW_OBJECT << 16) |
                                       W_FLAG_AUTOBREAK |
                                       W_FLAG_AUTOREMOVE,
                                     METHOD_END);
      DropObject( DoJazzMethod(mlo->director,
                               NULL,
                               METHOD_DIRECTOR_ESTABLISH,
                               ATTR_PATCHEDVERBS,
                               theClass,
                               METHOD_END));
   }
   return object;
}

void MetWinDestroyMethod(METHOD_ARGS)
{
   struct MWinLocalObjects *mlo;
   struct Node *node;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   DropObject(mlo->object1);
   DropObject(mlo->object2);
   DropObject(mlo->object3);
   DropObject(mlo->object4);
   DropObject(mlo->object5);
   DropObject(mlo->class);

   if (mlo->nodes)
   {
      for(node = mlo->list.lh_Head; node->ln_Succ; node = node->ln_Succ)
         QuickDropString(node->ln_Name);

      FreeVec(mlo->nodes);
   }

   CallSuper();
}

void MetWinRemoveMethod(METHOD_ARGS)
{
   struct MWinLocalObjects *mlo;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   RemoveObject(SetObject(&mlo->director, NULL));
   mlo->director = NULL;

   CallSuper();
}

void MetWinUpdateInfo(METHOD_ARGS)
{
   struct MWinLocalObjects *mlo;
   struct TagItem tags[2];

   mlo = FindAttribute(object, ATTR_LOCALWIN);

   tags[0].ti_Tag = GTNM_Number;
   tags[1].ti_Tag = TAG_END;

   /*
    * Number of Patches
    */
   tags[0].ti_Data = (ULONG)((struct MethodHandler *)
                      (mlo->lastNode->object))->mh_numPatches;
   DoJazzMethod(mlo->object5, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

}

/*
 * Selected a new method, so update all the method information.
 */
METHOD_REF REF_MetWinHitMethod[] = {
                                      'long', sizeof(long), 0,
                                      TAG_DONE
                                   };

void MetWinHitMethod(METHOD_ARGS, long code)
{
   struct MWinLocalObjects *mlo;
   struct TagItem tags[2];

   mlo = FindAttribute(object, ATTR_LOCALWIN);

   mlo->lastNode = &mlo->nodes[code];

   tags[0].ti_Tag = GTTX_Text;
   tags[1].ti_Tag = TAG_END;

   /*
    * Controlled Process Object.
    */
   {
      OBJECT object;
      struct JazzProcess *jp;

      object = ((struct MethodHandler *)
                (mlo->lastNode->object))->mh_procObject;
      if (!( ((struct MethodHandler *)mlo->lastNode->object)->mh_flags &
            METHOD_FLAG_PORT) &&
          (jp = FindAttribute(object, ATTR_JAZZPROCESS)))
         tags[0].ti_Data = (ULONG)jp->jp_procName;
      else
         tags[0].ti_Data = 0;
   }
   DoJazzMethod(mlo->object1, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * Defined Process Object.
    */
   {
      OBJECT object;
      struct JazzProcess *jp;

      object = ((struct MethodHandler *)
                (mlo->lastNode->object))->mh_defnObject;
      if (jp = FindAttribute(object, ATTR_JAZZPROCESS))
         tags[0].ti_Data = (ULONG)jp->jp_procName;
      else
         tags[0].ti_Data = 0;
   }
   DoJazzMethod(mlo->object2, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * Function Address
    */
   tags[0].ti_Tag = GTNM_Number;
   tags[0].ti_Data = (ULONG)((struct MethodHandler *)
                      (mlo->lastNode->object))->mh_method;
   DoJazzMethod(mlo->object3, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * Number of Patches
    */
   tags[0].ti_Tag = GTNM_Number;
   tags[0].ti_Data = (ULONG)((struct MethodHandler *)
                      (mlo->lastNode->object))->mh_numPatches;
   DoJazzMethod(mlo->object5, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * ThreadStat
    */
   tags[0].ti_Tag = GTTX_Text;
   switch(((struct MethodHandler *)
          (mlo->lastNode->object))->mh_threadStat &
          (SHADOW_MSG_FORCE | SHADOW_MSG_SYNC | SHADOW_MSG_ASYNC))
   {
       case SHADOW_MSG_CALL:
          tags[0].ti_Data = (ULONG)"Function call";
          break;
       case SHADOW_MSG_SYNC:
          tags[0].ti_Data = (ULONG)"Synchronous call";
          break;
       case SHADOW_MSG_ASYNC:
          tags[0].ti_Data = (ULONG)"Asynchronous call";
          break;
       case SHADOW_MSG_FORCE_SYNC:
          tags[0].ti_Data = (ULONG)"forced synch. call";
          break;
       default:
          tags[0].ti_Data = (ULONG)"forced async. call";
          break;
   }
   DoJazzMethod(mlo->object4, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);
}

/*
 * Open the Reference (parameter) Window.
 */
void MWinOpenRWinMethod(METHOD_ARGS)
{
   struct MWinLocalObjects *mlo;

   mlo = FindAttribute(object, ATTR_LOCALWIN);

   if (!mlo->lastNode)
      return;

   DropObject(CreateInstance(NULL,
                             REFWINCLASS,
                             METACLASS,
                             object,
                             mlo->lastNode->object,
                             mlo->class,
                             METHOD_END));
}


/*
 * AttWin Class methods.
 */
METHOD_REF REF_AttWinInitMethod[] = {
                                       {'JOBJ', sizeof(void *),
                                                SHADOW_OBJECT},
                                       {'JOBJ', sizeof(void *),
                                                SHADOW_CLASS},
                                       { TAG_END, SHADOW_RETURN_OBJECT, 0}
                                    };
void *AttWinInitMethod(METHOD_ARGS, OBJECT parent,
                                    CLASS  theClass)
{
   struct NewGadget ng;
   struct TagItem tag[8];
   struct AWinLocalObjects *mlo;
   char buffer[128];

   tag[0].ti_Tag = WA_Width;
   tag[0].ti_Data = 500;
   tag[1].ti_Tag = WA_Height;
   tag[1].ti_Data = 200;
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
   tag[7].ti_Tag = TAG_END;

   object = DoJazzMethod(object, class->meta_superClass, MethodID,
                                                 parent,
                                                 "Attribute Window",
                                                 NULL,
                                                 NULL,
                                                 tag, METHOD_END);

   if (!object)
      return NULL;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   mlo->meta = UseObject(theClass);
   NewList(&mlo->list);

   /*
    * Copy all of the attributes into the allocated list.
    */
   if (theClass->ccl_attributes.att_num)
   {
      struct Attribute *attrs;
      struct MyNode *nodes;
      int i;

      mlo->nodes = AllocVec(sizeof(struct MyNode) *
                                 theClass->ccl_attributes.att_num,
                            MEMF_PUBLIC);

      nodes = mlo->nodes;
      for (attrs = theClass->ccl_attributes.att_attrs, i = 0;
           i < theClass->ccl_attributes.att_num;
           i++, attrs++)
      {
         nodes->node.ln_Name = UseString(attrs->attr_name);
         nodes->object = attrs;
         AddTail(&mlo->list, nodes);
         nodes++;
      }
   }

   ng.ng_LeftEdge = ng.ng_TopEdge = 50;
   ng.ng_Width = 300;
   ng.ng_Height = 90;
   ng.ng_Flags = PLACETEXT_ABOVE;
   tag[0].ti_Tag = GTLV_Labels;
   tag[0].ti_Data = (ULONG)&mlo->list;
   tag[1].ti_Tag = GTLV_ShowSelected;
   tag[1].ti_Data = NULL;
   tag[2].ti_Tag = TAG_END;
   strcpy(buffer, "Attributes for class: ");
   strncat(buffer, theClass->ccl_name, 14);
   strcat(buffer, "...");
   DropObject(CreateInstance(NULL,
                             GADGTCLASS,
                             METACLASS,
                             object,
                             buffer,
                             object,
                             METHOD_GADGET_SELECT,
                             &ng,
                             LISTVIEW_KIND,
                             tag,
                             METHOD_END));

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 80;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object1 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":Attribute offset",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 80;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object2 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":size",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 80;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object3 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":watcher list",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 80;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object4 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":default object",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);
   return object;
}

void AttWinDestroyMethod(METHOD_ARGS)
{
   struct AWinLocalObjects *mlo;
   struct Node *node;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   DropObject(mlo->object1);
   DropObject(mlo->object2);
   DropObject(mlo->object3);
   DropObject(mlo->object4);
   DropObject(mlo->meta);

   if (mlo->nodes)
   {
      for(node = mlo->list.lh_Head; node->ln_Succ; node = node->ln_Succ)
         QuickDropString(node->ln_Name);

      FreeVec(mlo->nodes);
   }

   CallSuper();
}

/*
 * New Attribute selected, display its information.
 */
METHOD_REF  REF_AttWinHitMethod[] = {
                                       'long', sizeof(long), 0,
                                       TAG_DONE
                                    };

void AttWinHitMethod(METHOD_ARGS, long code)
{
   struct AWinLocalObjects *mlo;
   struct TagItem tags[2];

   mlo = FindAttribute(object, ATTR_LOCALWIN);

   mlo->lastNode = &mlo->nodes[code];

   tags[0].ti_Tag = GTNM_Number;
   tags[0].ti_Data = ((struct Attribute *)
                      (mlo->lastNode->object))->attr_offset;
   tags[1].ti_Tag = TAG_END;

   /*
    * Offset.
    */
   DoJazzMethod(mlo->object1, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * Size
    */
   tags[0].ti_Data = ((struct Attribute *)
                      (mlo->lastNode->object))->attr_size;
   if (tags[0].ti_Data & FLAG_ATTR_WATCHED)
      tags[0].ti_Data = sizeof(struct WatchedBinTree);
   DoJazzMethod(mlo->object2, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * if watched (attr->size & FLAG_ATTR_WATCHED), then display it.
    *  else -1.
    */
   if (FLAG_ATTR_WATCHED & ((struct Attribute *)
                            (mlo->lastNode->object))->attr_size)
      tags[0].ti_Data = (ULONG)((struct Attribute *)
                      (mlo->lastNode->object))->attr_first;
   else
      tags[0].ti_Data = -1;
   DoJazzMethod(mlo->object3, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   /*
    * default Object.
    */
   if (FLAG_ATTR_WATCHED & ((struct Attribute *)
                            (mlo->lastNode->object))->attr_size)
      tags[0].ti_Data = (~FLAG_ATTR_WATCHED & ((struct Attribute *)
                          (mlo->lastNode->object))->attr_size);
   else
      tags[0].ti_Data = (ULONG)((struct Attribute *)
                         (mlo->lastNode->object))->attr_value;
   DoJazzMethod(mlo->object4, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);
}


/*
 * RefWin Class methods.
 */
METHOD_REF REF_RefWinInitMethod[] = {
                                       {'JOBJ', sizeof(void *),
                                                SHADOW_OBJECT},
                                       {'MREF', sizeof(void *),
                                                sizeof(struct MethodHandler)},
                                       {'JOBJ', sizeof(void *),
                                                SHADOW_CLASS},
                                       {TAG_END, SHADOW_RETURN_OBJECT, 0}
                                    };
void *RefWinInitMethod(METHOD_ARGS, OBJECT parent,
                                    struct MethodHandler *method,
                                    CLASS mclass)
{
   char *name;
   char buffer[256];
   struct TagItem tag[8];
   struct NewGadget ng;
   struct RWinLocalObjects *mlo;

   strcpy(buffer, "Arguments to: ");
   strncat(buffer, method->mh_methodID, 200);
   name = UseString(buffer);

   {
      OBJECT object2;

      if (object2 =
           FindStringInWatchedBinTree(
              (W_AVLTREE)FindAttribute(parent, ATTR_GUICHILDREN),
              name))
      {
         struct WindowObject *wo;

         /*
          * The window is already up top, so pop it on top of all the
          *  windows.
          */
         if (wo = FindAttribute(object2, ATTR_WINDOW))
            WindowToFront(wo->wo_window);

         DropObject(object2);
         QuickDropString(name);

         /*
          * Destroy this object.
          */
         UseObject(object);
         DropObject(object);
         return NULL;
      }
   }

   tag[0].ti_Tag = WA_Width;
   tag[0].ti_Data = 500;
   tag[1].ti_Tag = WA_Height;
   tag[1].ti_Data = 200;
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
   tag[7].ti_Tag = TAG_END;

   object = DoJazzMethod(object, class->meta_superClass, MethodID,
                                              parent,
                                              name,
                                              NULL,
                                              NULL,
                                              tag, METHOD_END);
   QuickDropString(name);

   if (!object)
      return NULL;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   NewList(&mlo->list);

   /*
    * Copy the method-ref (argument or parameter) designations into
    *  an allocated list.
    */
   if (method->mh_num)
   {
      METHOD_REF *ref;
      struct MyNode *nodes;

      mlo->nodes = AllocVec(sizeof(struct MyNode) * method->mh_num,
                            MEMF_PUBLIC);

      nodes = mlo->nodes;
      buffer[4] = 0;
      for (ref = method->mh_args; ref->mr_tag; ref++)
      {
         *((long *)buffer) = ref->mr_tag;
         nodes->node.ln_Name = UseString(buffer);
         nodes->object = ref;
         AddTail(&mlo->list, nodes);
         nodes++;
      }

   }

   ng.ng_LeftEdge = ng.ng_TopEdge = 50;
   ng.ng_Width = 300;
   ng.ng_Height = 90;
   ng.ng_Flags = PLACETEXT_ABOVE;
   tag[0].ti_Tag = GTLV_Labels;
   tag[0].ti_Data = (ULONG)&mlo->list;
   tag[1].ti_Tag = TAG_END;

   strcpy(buffer, "method in class: ");
   if (mclass)
      strncat(buffer, mclass->ccl_name, 18);
   strcat(buffer, "...");
   name = UseString(buffer);
   DropObject(CreateInstance(NULL,
                             GADGTCLASS,
                             METACLASS,
                             object,
                             name,
                             object,
                             METHOD_GADGET_SELECT,
                             &ng,
                             LISTVIEW_KIND,
                             tag,
                             METHOD_END));
   QuickDropString(name);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 80;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object1 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 ":size of argument",
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 NUMBER_KIND,
                                 tag,
                                 METHOD_END);

   ng.ng_TopEdge += ng.ng_Height;
   ng.ng_Height = 15;
   ng.ng_Width = 80;
   ng.ng_Flags = PLACETEXT_RIGHT;
   tag[0].ti_Tag = TAG_END;
   mlo->object2 = CreateInstance(NULL,
                                 GADGTCLASS,
                                 METACLASS,
                                 object,
                                 NULL,
                                 object,
                                 METHOD_GADGET_SELECT,
                                 &ng,
                                 TEXT_KIND,
                                 tag,
                                 METHOD_END);
   return object;
}

void RefWinDestroyMethod(METHOD_ARGS)
{
   struct RWinLocalObjects *mlo;
   struct Node *node;

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   DropObject(mlo->object1);
   DropObject(mlo->object2);
   DropString(mlo->text);
   if (mlo->nodes)
   {
      for(node = mlo->list.lh_Head; node->ln_Succ; node = node->ln_Succ)
         QuickDropString(node->ln_Name);

      FreeVec(mlo->nodes);
   }
   CallSuper();
}

/*
 * A new METHOD_REF has been hit, show the selected argument's information.
 */
METHOD_REF REF_RefWinHitMethod[] = {
                                      'long', sizeof(long), 0,
                                      TAG_DONE
                                   };
void RefWinHitMethod(METHOD_ARGS, long code)
{
   struct RWinLocalObjects *mlo;
   struct TagItem tags[2];

   mlo = FindAttribute(object, ATTR_LOCALWIN);
   mlo->lastNode = &mlo->nodes[code];

   tags[0].ti_Tag = GTNM_Number;
   tags[0].ti_Data = ((METHOD_REF *)(mlo->lastNode->object))->mr_size;
   tags[1].ti_Tag = TAG_END;

   DoJazzMethod(mlo->object1, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

   {
      char buffer[256];

      switch(((METHOD_REF *)(mlo->lastNode->object))->mr_tag)
      {
         case 'TAGL':
            RawDoFmt("size of tag item: %d",
                     &((METHOD_REF *)(mlo->lastNode->object))->mr_flags,
                     SprintfCallback, buffer);
            break;
         case 'JOBJ':
            switch(((METHOD_REF *)(mlo->lastNode->object))->mr_flags)
            {
               case SHADOW_OBJECT:
                  strcpy(buffer, "Jazz Object");
                  break;
               case SHADOW_CLASSLESSOBJECT:
                  strcpy(buffer, "Jazz Classless");
                  break;
               case SHADOW_META:
                  strcpy(buffer, "Jazz Meta");
                  break;
               case SHADOW_CLASS:
                  strcpy(buffer, "Jazz Class");
                  break;
               case SHADOW_CLUSTER:
                  strcpy(buffer, "Jazz Cluster");
                  break;
               case SHADOW_COMPOSITE:
                  strcpy(buffer, "Jazz Composite");
                  break;
               default:
                  strcpy(buffer, "unknown/unspecified");
                  break;
            }
            break;
         case 'JSTR':
            strcpy(buffer, "String");
            break;
         default:
            RawDoFmt("size of pointer? : %d",
                     &((METHOD_REF *)(mlo->lastNode->object))->mr_flags,
                     SprintfCallback, buffer);
      }

      DropString(mlo->text);
      mlo->text = UseString(buffer);
   }

   tags[0].ti_Tag = GTTX_Text;
   tags[0].ti_Data = (ULONG)mlo->text;
   DoJazzMethod(mlo->object2, NULL, METHOD_GADGET_CHANGE, tags, METHOD_END);

}
