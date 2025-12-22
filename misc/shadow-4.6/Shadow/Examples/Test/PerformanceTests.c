/*
 * These used to be compile-time options to Browser.
 *
 * Obviously this makes no sense for public code, so I have
 *  stuck all of that here.
 *
 * Makes Browser less unintelligble :^/
 *
 * (C) Copyright 1991 David C. Navas
 */
#include <shadow/coreMeta.h>
#include <shadow/coreRoot.h>
#include <shadow/process.h>
#include <shadow/semaphore.h>

#include <ipc.h>
#include <shadow/shadow_proto.h>
#include <shadow/shadow_pragmas.h>
#include <shadow/method.h>
#include <dos/dostags.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <math.h>

extern struct ExecBase * __far SysBase;
struct IPCBase * __far IPCBase;
struct ShadowBase * __far ShadowBase;
struct DosLibrary * __far DOSBase;

struct SignalSemaphore programSemaphore;

/*
 * To test the binary tree speed.
 */
void BinSpeedTest(void);

/*
 * To test the memory speed.
 */
void MemorySpeedTest(void);

/*
 * To test the semaphore speed.
 */
void SemaphoreSpeedTest(void);

/*
 * To test the FindString() speed.
 */
void StringSpeedTest(void);

/*
 * This is for the method testing and patching/attribute tests.
 */

#define METHOD_TEST_SPEED     "Method Tst5"
extern METHOD_REF REF_TestMethod[],
                  REF_SendTestMethod[],
                  REF_SendTest5Method[];

long TestMethod(METHOD_ARGS, char *), SendTestMethod(METHOD_ARGS,
                                                     OBJECT testObject);
long Test5Method(METHOD_ARGS), SendTest5Method(METHOD_ARGS, OBJECT);

#define SPEEDTESTNUMBER  100000

/*
 * Class that is to be run by "testing subprocess..."
 */

/*
 * These methods are called by this test program in main()
 */
METHOD_TAG methods2[] =
                        {
                           {
                              "Method TEST",
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)SendTestMethod, REF_SendTestMethod
                           },
                           {
                              METHOD_TEST_SPEED,
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)SendTest5Method, REF_SendTest5Method
                           },
                           TAG_END
                        };

struct TestDefaultAttribute
{
   long thing;
};

ATTRIBUTE_TAG attrs2[] =
                        {
                           {
                              "A default attribute",
                              sizeof(struct TestDefaultAttribute),
                              NULL
                           },
                           TAG_END
                        };


/*
 * Class that is to be run by the "Fake dos Process..."
 */

/*
 * These are the methods that are called in the inner loop by the
 *  methods defined above.
 */
METHOD_TAG methods[] =
                        {
                           {
                              "Method TEST",
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)TestMethod, REF_TestMethod
                           },
                           {
                              METHOD_TEST_SPEED,
                              NULL, NULL,
                              SHADOW_MSG_CALL,         /* Edit this one! */
                              METHOD_FLAG_PROC, 0,
                              (METHODFUNCTYPE)Test5Method, NULL
                           },
                           TAG_END
                        };

/*
 * The patches
 */
extern double PreTestMethod(METHOD_ARGS);

METHOD_TAG preMethod =
                           {
                              "Method TEST",
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC | METHOD_FLAG_CHECK_CONTINUE, 1,
                              (METHODFUNCTYPE)PreTestMethod, NULL
                           };

extern long PostTestMethod(METHOD_ARGS);

METHOD_TAG postMethod =
                           {
                              "Method TEST",
                              NULL, NULL,
                              SHADOW_MSG_SYNC,
                              METHOD_FLAG_PROC, -1,
                              (METHODFUNCTYPE)PostTestMethod, NULL
                           };



/*
 * A default attribute, just to show you how they work.
 */
struct TestDefaultAttribute theDefAtt = {0xFEED};

/*
 * Here, we not only test the default attribute, but we show that you
 * can give a new class a default attribute for an attribute of the new
 * class' superclass.
 */
ATTRIBUTE_TAG attrs[] =
                        {
                           {
                              "A default attribute",
                              sizeof(struct TestDefaultAttribute),
                              &theDefAtt
                           },
                           TAG_END
                        };


/*
 * Lattice, go away.
 */
int CXBRK(void)
{
   return(0);
}

/*
 * really.
 */
chkabort(void)
{
   return(0);
}


/*
 * Some memory allocation routines.  Dunno why we have these here...
 */
/*
void * __regargs temporaryAlloc(struct MemoryList *list)
{
   return AllocMem(32 * 32 + sizeof(struct MemoryNode), MEMF_PUBLIC);
}

void __regargs temporaryFree(struct MemoryList *list,
                           struct MemoryNode *node)
{
   FreeMem(node, 32 * 32 + sizeof(struct MemoryNode));
}
*/

/*
 * Possible test constants
 */
#define MEMORYTEST   "MEMORY"
#define SPEEDTEST    "METHOD"
#define FEATURETEST  "TEST"
#define AVLTREETEST  "AVL"
#define SEMTEST      "SEMAPHORE"
#define STRINGTEST   "STRING"

#define MEMORYTEST_VAL  1
#define SPEEDTEST_VAL   2
#define FEATURETEST_VAL 4
#define AVLTREETEST_VAL 8
#define SEMTEST_VAL     16
#define STRINGTEST_VAL  32

void main(int argc, char *argv[])
{
   CLASS root,
         dosTaskClass,
         testClass,
         dosClass,
         proc;

   OBJECT procObject,
          testObject,
          dosTask,
          dosObject,
          preObject,
          postObject;
   ULONG args[10], test = 0, i;

   InitSemaphore(&programSemaphore);

   if (!(DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 37)))
   {
      DOSBase = (struct DosLibrary *)OpenLibrary("dos.library", 0);
      Write(Output(), "Sorry, use 2.0\n", 15);
      CloseLibrary(DOSBase);
      return;
   }

   if (argc == 0)
   {
      VPrintf("Run this from the Shell\n", NULL);
      CloseLibrary(DOSBase);
      return;
   }

   if ((argc == 1) || !stricmp(argv[1], "?"))
   {
      VPrintf("\nOkay, this is how you want to run this program:\n\t%s ",
              (ULONG *)&argv[0]);
      VPrintf(MEMORYTEST"/S,"SPEEDTEST"/S,"FEATURETEST"/S,"
              AVLTREETEST"/S,"SEMTEST"/S,"STRINGTEST"/S\n\n", NULL);
      CloseLibrary(DOSBase);
      return;
   }

   for(i = 1; i < argc; i++)
   {
      if (!stricmp(argv[i], MEMORYTEST))
         test |= MEMORYTEST_VAL;
      else
         if (!stricmp(argv[i], SPEEDTEST))
            test |= SPEEDTEST_VAL;
      else
         if (!stricmp(argv[i], FEATURETEST))
            test |= FEATURETEST_VAL;
      else
         if (!stricmp(argv[i], AVLTREETEST))
            test |= AVLTREETEST_VAL;
      else
         if (!stricmp(argv[i], SEMTEST))
            test |= SEMTEST_VAL;
      else
         if (!stricmp(argv[i], STRINGTEST))
            test |= STRINGTEST_VAL;
      else
         VPrintf("Disregarding Parameter <%s>\n", (ULONG *)&argv[i]);
   }

   if (!(IPCBase = OpenLibrary("ppipc.library", 0)))
   {
      VPrintf("requires ppipc.library in libs:\n", NULL);
      CloseLibrary(DOSBase);
      return;
   }

   if (!(ShadowBase = (struct ShadowBase *)
                       OpenLibrary("shadow.library", 4)))
   {
      VPrintf("requires shadow.library 4.3 in libs:\n", NULL);
      CloseLibrary(IPCBase);
      CloseLibrary(DOSBase);
      return;
   }

   if (!InitOOProgram("Performance Tester Program"))
   {
      CloseLibrary(IPCBase);
      CloseLibrary(ShadowBase);
      CloseLibrary(DOSBase);
      return;
   }

   if (test & AVLTREETEST_VAL)
      BinSpeedTest();

   if (test & MEMORYTEST_VAL)
      MemorySpeedTest();

   if (test & SEMTEST_VAL)
      SemaphoreSpeedTest();

   if (test & STRINGTEST_VAL)
      StringSpeedTest();

   /*
    * What follows below is a complete mess.
    * The author realizes it, but doesn't care enough about this
    *  particular stretch of code to do much about it.
    * Please, refer to the other examples provided for better use of
    *  the shadow.lib functions.
    * If you like, think of this as an example of more direct mucking
    *  about with creating classes and objects, without
    *  Create[Instance|SubClass]
    */
   proc = FindJazzClass(PROCESSCLASS);
   root = FindJazzClass(ROOTCLASS);

   if (test & (SPEEDTEST_VAL | FEATURETEST_VAL))
   {
      struct Meta *MHClass;

      dosTaskClass = DoJazzMethod(proc, NULL, METHOD_META_SUB,
                                              "dos process class",
                                              NULL,
                                              NULL,
                                              NULL,
                                              METHOD_END);

      args[0] = (ULONG)proc;
      args[1] = proc->ccl_size;
      args[2] = (ULONG)dosTaskClass;
      VPrintf("Defined procClass:<%lx> : %ld bytes :: dosProcClass:<%lx>\n",
              args);

      args[0] = NP_Output;
      args[1] = (ULONG)Open("CONSOLE:", MODE_OLDFILE);
      args[2] = TAG_END;
      dosTask = DoJazzMethod(dosTaskClass, NULL, METHOD_META_CREATE,
                                                 METHOD_END);
      dosTask = DoJazzMethod(dosTask, NULL, METHOD_META_INIT,
                                            "Fake dos Task",
                                            NULL,
                                            &programSemaphore,
                                            args,
                                            METHOD_END);

      /*
       * if didn't Open, then free the resources.
       */
      if (args[0] != TAG_IGNORE)
      {
         VPrintf("Couldn't start the Fake dos Task\n", NULL);
         Close(args[1]);
      }

      args[0] = NP_Output;
      args[1] = (ULONG)Open("CONSOLE:", MODE_OLDFILE);
      args[2] = TAG_END;
      procObject = DoJazzMethod(proc, NULL, METHOD_META_CREATE, METHOD_END);
      procObject = DoJazzMethod(procObject, NULL, METHOD_META_INIT,
                                                  "testing subprocess...",
                                                  NULL,
                                                  &programSemaphore,
                                                  args,
                                                  METHOD_END);
      /*
       * if didn't Open, then free the resources.
       */
      if (args[0] != TAG_IGNORE)
      {
         VPrintf("Couldn't start the testing subprocess...", NULL);
         Close(args[1]);
      }


      args[0] = (ULONG)procObject;
      args[1] = (ULONG)dosTask;
      VPrintf("Proc Objects %lx %lx\n\n", args);

      SetupMethodTags(methods2, procObject, (void *)-1);
      SetupMethodTags(methods, dosTask, (void *)-1);

      testClass = DoJazzMethod(root, NULL, METHOD_META_SUB,
                                                      "Test Class",
                                                      NULL,
                                                      attrs2,
                                                      methods2,
                                                      METHOD_END);

      testObject = DoJazzMethod( DoJazzMethod(testClass,
                                              NULL,
                                              METHOD_META_CREATE,
                                              METHOD_END),
                                 NULL,
                                 METHOD_META_INIT,
                                 METHOD_END);

      dosClass = DoJazzMethod(testClass, NULL, METHOD_META_SUB,
                                                        "Test Class Dest",
                                                        NULL,
                                                        attrs,
                                                        methods,
                                                        METHOD_END);

      dosObject = DoJazzMethod(dosClass, NULL, METHOD_META_CREATE, METHOD_END);

      if (test & FEATURETEST_VAL)
      {
         /*
          * Well, did the attribute turn out okay?
          */
         VPrintf("Default Attribute Value :: %lx\n\n",
                 FindAttribute(dosObject, "A default attribute"));

      }
      dosObject = DoJazzMethod(dosObject, NULL, METHOD_META_INIT, METHOD_END);


      AddAutoResource(NULL, testClass, NULL);
      AddAutoResource(NULL, dosTaskClass, NULL);
      AddAutoResource(NULL, UseObject(dosObject), NULL);
      AddAutoResource(NULL, UseObject(dosClass), NULL);
      AddAutoResource(NULL, UseObject(testObject), NULL);
      AddAutoResource(NULL, procObject, NULL);
      AddAutoResource(NULL, UseObject(dosTask), NULL);

      if (test & FEATURETEST_VAL)
      {
         MHClass = FindJazzClass(PATCHERCLASS);

         /*
          * Add pre and post patches
          */
         preMethod.mtag_procObject = dosTask;
         preMethod.mtag_defnObject = (OBJECT)FindTask(NULL)->tc_UserData;

         preObject = DoJazzMethod(MHClass, NULL, METHOD_META_CREATE,
                                                 METHOD_END);
         preObject = DoJazzMethod(preObject, NULL, METHOD_META_INIT,
                                                   &preMethod,
                                                   dosClass,
                                                   METHOD_END);
         VPrintf("Added prePatch %lx\n", (ULONG *)&preObject);

         postMethod.mtag_procObject = dosTask;
         postMethod.mtag_defnObject = (OBJECT)FindTask(NULL)->tc_UserData;

         postObject = DoJazzMethod(MHClass, NULL, METHOD_META_CREATE,
                                                  METHOD_END);
         postObject = DoJazzMethod(postObject, NULL, METHOD_META_INIT,
                                                     &postMethod,
                                                     dosClass,
                                                     METHOD_END);
         VPrintf("Added postPatch %lx\n", (ULONG *)&postObject);

         DropObject(MHClass);

         /*
          * Method patching tests.
          */
         VPrintf("\nMETHOD TESTING\n", NULL);
         DoJazzMethod(testObject, NULL, "Method TEST", dosObject,
                                                       METHOD_END);
         DoJazzMethod(preObject, NULL, METHOD_META_REMOVE, METHOD_END);
         DropObject(preObject);
         VPrintf("Removed prePatch\n\n", NULL);

         DoJazzMethod(testObject, NULL, "Method TEST", dosObject,
                                                       METHOD_END);

         DoJazzMethod(postObject, NULL, METHOD_META_REMOVE, METHOD_END);
         DropObject(postObject);
         VPrintf("Removed postPatch\n\n", NULL);

         DoJazzMethod(testObject, NULL, "Method TEST", dosObject,
                                                      METHOD_END);
         VPrintf("METHOD TESTING DONE\n\n", NULL);
      }

      if (test & SPEEDTEST_VAL)
      {
         /*
          * A3000 tests under moderate system usage (maky apps Open, nothing
          *  running) shows 31000+ for methods/sec, and 240000 for funcs/sec.
          */
         DoJazzMethod(testObject, NULL, METHOD_TEST_SPEED, dosObject,
                                                           METHOD_END);
      }

      DropObject(dosObject);
      DropObject(dosClass);
      DropObject(testObject);
      DropObject(dosTask);
   }
   DropObject(root);
   DropObject(proc);

   VPrintf("Removing current program\n", NULL);

   RemoveCurrentProgram(&programSemaphore);

   VPrintf("Closing libraries\n", NULL);

   CloseLibrary(ShadowBase);
   CloseLibrary(IPCBase);

   VPrintf("Attempting to purge SHADOW and PPIPC libraries.\n", NULL);
   CloseLibrary(DOSBase);

   /*
    * Purge everything.
    */

   AllocMem(-1, MEMF_ANY);
}

void BinSpeedTest(void)
{
   AVLTREE bt = NULL;
   int i, j;
   struct DateStamp ds1, ds2;
   struct ClasslessObject object[256];

   for(i = 0;i < 256; i++)
   {
      object[i].clb_class = NULL;
      object[i].clb_useCount = object[i].clb_size = 0;
   }


   for (i = 0; i < 256; i++)
   {
      AddNodeBinTree(&bt, &object[i], i);
   }

   VPrintf("Beginning SHADOW AVLTree speed test of FindBinNode:\n", NULL);

   DateStamp((void *)&ds1);
   for(j = 0; j < 100; j++)
   {
      for (i = 0; i < 256; i++)
      {
         DropObject(FindBinNode(&bt, i));
      }

   }
   DateStamp((void *)&ds2);

   for (i = 0; i < 256; i++)
   {
      RemoveBinNode(&bt, &object[i], i);
   }

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW AVLTree speed test completed.\n", NULL);
   i = 50 * 25600;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld SHADOW AVLTree FindBinNode()/second\n\n", &i);


   VPrintf("Beginning SHADOW AVLTree speed test Add/Remove:\n", NULL);

   DateStamp((void *)&ds1);
   for(j = 0; j < 50; j++)
   {
      for (i = 0; i < 256; i++)
      {
         AddNodeBinTree(&bt, &object[i], i);
      }
      for (i = 0; i < 256; i++)
      {
         RemoveBinNode(&bt, &object[i], i);
      }

   }
   DateStamp((void *)&ds2);
   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW AVLTree speed test completed.\n", NULL);
   i = 50 * 12800;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld SHADOW AVLTree Adds-Removes/second\n\n", &i);

}

void MemorySpeedTest(void)
{
   int i, j;
   void *table[128];
   struct DateStamp ds1, ds2;
   struct MemoryList globalMemList;

   VPrintf("Beginning SHADOW memory allocation speed test:\n", NULL);

   InitTable(&globalMemList, NULL, NULL, 16);

   DateStamp((void *)&ds1);

   for(j = 0; j < 500; j++)
   {
      for (i = 0; i < 128; i++)
      {
         table[i] = AllocateItem(&globalMemList);
      }
      for (i = 0; i < 128; i++)
      {
         FreeItem(&globalMemList, table[i]);
      }
   }
   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW memory test completed.\n", NULL);
   i = 50 * 64000;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld SHADOW memory allocs-frees/second\n\n", &i);

   /*
    * A3000 tests after decent memory usage by other programs
    * shows a bit over 12700 a second.
    */

   VPrintf("Beginning Exec allocation speed test:\n", NULL);

   DateStamp((void *)&ds1);

   for(j = 0; j < 500; j++)
   {
      for (i = 0; i < 128; i++)
      {
         table[i] = AllocMem(16, MEMF_PUBLIC);
      }
      for (i = 0; i < 128; i++)
      {
         FreeMem(table[i], 16);
      }
   }
   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("Exec memory test completed.\n", NULL);
   i = 50 * 64000;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld system memory allocs-frees/second\n\n", &i);

   /*
    * A3000 tests after decent memory usage by other programs
    *  shows a bit under 8000 a second.
    *
    * The comparisons are even more disparate for slightly larger
    *  memory block sizes.  After all, very few fragments need be
    *  searched for blocks of 16bytes -- smallest frag. size is 8!
    */
   FreeTable(&globalMemList);
}

void SemaphoreSpeedTest(void)
{
   int i, j;
   ULONG table[12];
   struct DateStamp ds1, ds2;

   VPrintf("Beginning SHADOW semaphore speed test:\n", NULL);

   for(i = 0; i < 12; i++)
   {
      table[i] = lrand48();
   }

   DateStamp((void *)&ds1);

   for(j = 0; j < 1000; j++)
   {
      for (i = 0; i < 12; i++)
      {
         PSem((void *)table[i], SHADOW_EXCLUSIVE_SEMAPHORE);
      }
      for (i = 0; i < 12; i++)
      {
         VSem((void *)table[i]);
      }
   }
   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW semaphore test completed.\n", NULL);
   i = 50 * 12000;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld SHADOW semaphore Psem()-VSem()/second\n\n", &i);

   /*
    * A3000 tests shows a bit over 8500 a second.
    */
}

#define STRINGTESTER "Find this string in Table"

void StringSpeedTest(void)
{
   int i;
   struct DateStamp ds1, ds2;

   VPrintf("Beginning SHADOW word-aligned FindString() speed test:\n", NULL);

   UseString(STRINGTESTER);

   DateStamp((void *)&ds1);

   for(i = 0; i < 50000; i++)
   {
      FindString(STRINGTESTER);
   }
   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW FindString() test completed.\n", NULL);
   i = 50 * 50000;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld SHADOW FindString()/second\n\n", &i);

   DropString(STRINGTESTER);

   /*
    * A3000 tests shows a bit under 21000 a second.
    */

   VPrintf("Beginning SHADOW unaligned FindString() speed test:\n", NULL);

   UseString(STRINGTESTER + 1);

   DateStamp((void *)&ds1);

   for(i = 0; i < 50000; i++)
   {
      FindString(STRINGTESTER + 1);
   }
   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW FindString() test completed.\n", NULL);
   i = 50 * 50000;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld SHADOW FindString()/second\n\n", &i);

   DropString(STRINGTESTER + 1);

   /*
    * A3000 tests shows around 17000 a second -- 15%-20% slower!.
    */
}

/*
 * The speed and testing test methods.
 */
double PreTestMethod(METHOD_ARGS)
{
   static myLocalVar = 0;
   union {
      double tempD;
      ULONG  tempV[2];
   } retval;

   VPrintf("Pretest called\n", NULL);

   if (!(retval.tempV[1] = (myLocalVar++ & 1)))
      VPrintf("PreTest will block this call:\n", NULL);

   /*
    * Try to fool it into returning 100.  It won't.
    */
   retval.tempV[0] = 100;
   return retval.tempD;
}

long PostTestMethod(METHOD_ARGS)
{
   VPrintf("Post test called\n", NULL);
   return 200;
}

METHOD_REF REF_TestMethod[] = {
                                 {'JSTR', sizeof(char *), 0},
                                 {TAG_DONE, SHADOW_RETURN_BLANK, 0}
                              };

long TestMethod(METHOD_ARGS, char *string)
{
   long args[10];

   if (!string)
      string = "NULL";

   args[0] = (long)MethodID;
   if (!msg)
      args[1] = (ULONG)"SMET";
   else
      args[1] = (long)&msg->ipc_Id;
   args[2] = (long)FindTask(NULL)->tc_Node.ln_Name;
   VPrintf("Method <%s> called via <%s> Message recv'd by task <%s>.\n", args);

   args[0] = (long)class->meta_name;
   args[1] = (long)object;
   VPrintf("\tClass = '%s', OBJECT = '%lx'\n", args);

   args[0] = (long)string;
   args[1] = *(long *)(((ULONG)&string) + 4);
   VPrintf("\tArgument STRING sent <%s> :: %lx\n", args);

   return TRUE;

}

long Test5Method(METHOD_ARGS)
{
   return TRUE;
}

METHOD_REF REF_SendTestMethod[] = {
                                     {'JOBJ', sizeof(char *), SHADOW_OBJECT},
                                     {TAG_DONE, SHADOW_RETURN_BLANK, 0}
                                  };

long SendTestMethod(METHOD_ARGS, OBJECT testObject)
{
   long test, args[3];

   args[0] = (long)MethodID;
   if (!msg)
      args[1] = (ULONG)"SMET";
   else
      args[1] = (long)&msg->ipc_Id;
   args[2] = (long)FindTask(NULL)->tc_Node.ln_Name;
   VPrintf("Method <%s> called via <%s> Message recv'd by task <%s>.\n", args);

   args[0] = (long)class->meta_name;
   args[1] = (long)object;
   VPrintf("\tClass = '%s', OBJECT = '%lx'\n", args);

   args[0] = (long)testObject;
   VPrintf("\tArgument OBJECT sent <%lx>\n\n", args);

   test = (long)DoJazzMethod(testObject, NULL, MethodID,
                                                   "Testing", METHOD_END);

   VPrintf("Method Call first Returned %ld\n\n", &test);

   test = (long)DoJazzMethod(testObject, NULL, MethodID, METHOD_END);

   VPrintf("Method Call second Returned %ld\n\n", &test);

   return TRUE;

}

METHOD_REF REF_SendTest5Method[] = {
                                      {'JOBJ', sizeof(char *),SHADOW_OBJECT},
                                      {TAG_DONE, SHADOW_RETURN_BLANK, 0}
                                   };

long SendTest5Method(METHOD_ARGS, OBJECT testObject)
{
   int i;
   struct DateStamp ds1, ds2;
/*
 * Use this for testing the DJM() call, which is a bit faster than
 *  DoJazzMethod() [maybe 10% faster].
 *
 * void *args[4];
 *
 * args[0] = testObject;
 * args[1] = testObject->cob_class;
 * args[2] = METHOD_TEST_SPEED;
 * args[3] = METHOD_END;
 */


   VPrintf("Beginning SHADOW method speed test:\n", NULL);

   Delay(30);  /* let things settle a bit */

   DateStamp((void *)&ds1);
   for (i = 0; i< SPEEDTESTNUMBER; i++)
   {
      /*
       * The following would be a little bit faster than the DoJazzMethod
       *  call.
       * DJM(args, SHADOW_MSG_FINDMETHOD);
       */

      DoJazzMethod(testObject, NULL, METHOD_TEST_SPEED, METHOD_END);
   }

   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("SHADOW method test completed.\n", NULL);
   i = 50 * SPEEDTESTNUMBER;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld methods/second\n\n", &i);

   /*
    * A3000 tests under moderate system usage (maky apps Open, nothing
    *  running) shows 30000+.
    */

   VPrintf("Beginning function call speed test:\n", NULL);
   DateStamp((void *)&ds1);
   for (i = 0; i< SPEEDTESTNUMBER; i++)
      Test5Method(NULL, testObject, testObject->cob_class, METHOD_TEST_SPEED);

   DateStamp((void *)&ds2);

   ds2.ds_Tick -= ds1.ds_Tick;
   ds2.ds_Minute -= ds1.ds_Minute;
   if (ds2.ds_Tick < 0)
   {
      --ds2.ds_Minute;
      ds2.ds_Tick += (60 * 50);
   }
   ds2.ds_Days = ds2.ds_Minute;
   ds2.ds_Minute = ds2.ds_Tick / 50;
   ds2.ds_Tick -= (ds2.ds_Minute * 50);

   VPrintf("Function call test completed.\n", NULL);
   i = 50 * SPEEDTESTNUMBER;
   i = i / ((ds2.ds_Days * 60 + ds2.ds_Minute) * 50 + ds2.ds_Tick);
   VPrintf("\t%ld functio calls/second\n\n", &i);

   /*
    * A3000 tests under moderate system usage (many apps Open, nothing
    *  running) shows 230000 for funcs/sec.
    */

   return TRUE;
}

