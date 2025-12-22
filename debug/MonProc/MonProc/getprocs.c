/*
 *  GETPROCS.C - Grab all available processes and return them to you in a
 *               simple exec list. The list is made up of  nodes--the "name"
 *               fields pointing to the process structure. 
 *
 *             Phillip Lindsay (c) 1987 Commodore-Amiga Inc. 
 *  You may use this source as long as the copyright notice is left intact.
 *
 *  Re-organized and re-worked by Davide P. Cervone, 4/25/87
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/tasks.h>
#include <exec/execbase.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <stdio.h>

#ifdef MANX
   #include <functions.h>
#endif

#define NODESIZE        ((ULONG)sizeof(struct Node))
#define MEMFLAGS        (MEMF_PUBLIC | MEMF_CLEAR)

extern struct Node *AllocMem(), *RemTail();

/*
 *   GetNode()
 *
 *  Allocates a node structure for you and initializes the node
 *  with the given values.
 */     

struct Node *GetNode(name,type,pri)
char *name;
UBYTE type,pri;
{
   register struct Node *theNode;

   theNode =  AllocMem(NODESIZE,MEMFLAGS); 
   if (theNode != NULL)
   {
      theNode->ln_Name = name;
      theNode->ln_Type = type;
      theNode->ln_Pri  = pri;
   }
   return(theNode);
}


/*
 *  FreeNode()
 *
 *  Frees a given Exec node.  You must remove it from any list before
 *  calling FreeNode()
 */

void FreeNode(theNode)
struct Node *theNode;
{
   FreeMem(theNode,NODESIZE);
}


/*
 *  AddProcs()
 *
 *  Adds the processes from the ProcList onto the end of the list 'plist'.
 */

void AddProcs(plist,ProcList)
struct List *plist;
struct List *ProcList;
{
   register struct Node  *aProc,*bProc;

   if (ProcList->lh_TailPred != (struct Node *)ProcList)
   {
      for (aProc=ProcList->lh_Head; aProc->ln_Succ; aProc=aProc->ln_Succ)
      { 
         if (aProc->ln_Type == NT_PROCESS)
         { 
            if (bProc = GetNode(aProc,0,0)) AddTail(plist,bProc);
         }
      }
   }    
}


/*
 *  GetProcList()
 *
 *  For each process in the system's task list, GetProcList appends an exec
 *  node to the given list and fills in the node name field with a pointer
 *  to the process strcuture.
 *
 *        plist     is an initialized Exec List.
 *
 *  WARNING:  This isn't a casual subroutine.  The returned list is valid as
 *  long as a process is not ended or added after this subroutine is
 *  called.  To be real safe you should probably check to see if the
 *  process is still around before trying to look at the data structure.  
 */

void GetProcList(plist)
struct List *plist;
{
   extern   struct ExecBase   *SysBase;
   register struct ExecBase   *execbase=SysBase;
   register struct Node       *aProc;

/*
 * I haven't clocked this code, but as a rule, you shouldn't stay disabled for
 * more than 250ms.  I have no doubt I'm illegal, but you can't be too safe
 * when dealing with something that changes with a blink of an interrupt.
 */

   Disable();

   /*
    *  Add our own process to the list
    */
   if (execbase->ThisTask->tc_Node.ln_Type == NT_PROCESS)
   {
      if (aProc = GetNode(execbase->ThisTask,0,0)) AddTail(plist,aProc);
   }

   /*
    *  Add the process from the ExecBase queues
    */
   AddProcs(plist,&execbase->TaskReady);
   AddProcs(plist,&execbase->TaskWait);

   Enable();
}


/*
 *  FreeProcList()
 *
 *  Frees all nodes in the given list.   FreeProcList() assumes the nodes
 *  where initialized with GetNode().
 */

void FreeProcList(plist)
struct List *plist;
{
   register struct Node *theProc;

   while (theProc = RemTail(plist)) FreeNode(theProc);
}
