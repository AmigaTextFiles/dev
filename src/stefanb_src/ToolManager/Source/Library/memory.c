/*
 * memory.c  V3.1
 *
 * Memory management routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Local data structures */
static struct LowMemoryData {
 struct Interrupt  lmd_Interrupt;
 LONG              lmd_Signal;
 struct Task      *lmd_Task;
 ULONG             lmd_Mask;
};

/* Low memory handler */
__geta4 static ULONG LowMemoryHandler(__a1 struct LowMemoryData *lmd,
                                      __a6 struct Library *SysBase)
{
 /* Send low memory signal to handler */
 Signal(lmd->lmd_Task, lmd->lmd_Mask);

 /* That is all we can do */
 return(MEM_ALL_DONE);
}

/* Interrupt structure for low memory handler */
static struct LowMemoryData LowMemoryInterrupt = {
 NULL, NULL, NT_INTERRUPT, 50, ToolManagerName,
 &LowMemoryInterrupt, (VOID *()) &LowMemoryHandler,
 NULL, 0
};

/* Install low memory handler */
#define DEBUGFUNCTION StartLowMemoryWarning
LONG StartLowMemoryWarning(void)
{
 MEMORY_LOG(LOG0(Entry))

 /* Allocate Signal for file notification */
 if ((LowMemoryInterrupt.lmd_Signal = AllocSignal(-1)) != -1) {

  MEMORY_LOG(LOG1(Signal, "%ld", LowMemoryInterrupt.lmd_Signal))

  /* Initialize interrupt structure */
  LowMemoryInterrupt.lmd_Task = FindTask(NULL);
  LowMemoryInterrupt.lmd_Mask = (1 << LowMemoryInterrupt.lmd_Signal);

  /* Add low memory handler */
  AddMemHandler((struct Interrupt *) &LowMemoryInterrupt);
 }

 MEMORY_LOG(LOG1(Result, "%ld", LowMemoryInterrupt.lmd_Signal))

 return(LowMemoryInterrupt.lmd_Signal);
}

/* Remove low memory handler */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopLowMemoryWarning
void StopLowMemoryWarning(void)
{
 MEMORY_LOG(LOG1(Signal, "%ld", LowMemoryInterrupt.lmd_Signal))

 /* Remove low memory handler */
 RemMemHandler((struct Interrupt *) &LowMemoryInterrupt);

 /* Free signal */
 FreeSignal(LowMemoryInterrupt.lmd_Signal);
}

/* Handle low memory situations */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleLowMemory(void)
void HandleLowMemory(void)
{
 struct MinNode *n = GetHead(GetHandleList());

 MEMORY_LOG(LOG0(Entry))

 /* Traverse handle list to purge image caches */
 while (n) {
  Object *obj1 = (Object *) TMHANDLE(n)
                             ->tmh_ObjectLists[TMOBJTYPE_IMAGE].mlh_Head;
  Object *obj2;

  MEMORY_LOG(LOG1(Handle, "0x%08lx", n))

  /* Scan image object list */
  while (obj2 = NextObject(&obj1)) {

   MEMORY_LOG(LOG1(Object, "0x%08lx", obj2))

   /* Send screen open/close method to object */
   DoMethod(obj2, TMM_PurgeCache);
  }

  /* Get next entry in handle list */
  n = GetSucc(n);
 }
}

/* Include global memory code */
#include "/global_memory.c"
