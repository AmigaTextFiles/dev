/*
 *  MONPROC.C    - Monitor AmigaDOS process packet activity.
 *
 *        Phillip Lindsay (c) 1987 Commodore-Amiga, Inc.
 *  You may use this source as long as this copywrite notice is left intact.
 *
 *  re-organized and slightly re-worked by Davide P. Cervone, 4/25/87.
 */

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/semaphores.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <stdio.h>

#ifdef MANX
#include <functions.h>
#endif

#define ONE         1L

/*
 * AmigaDOS uses task signal bit 8 for message signaling
 */

#define DOS_SIGNAL   8
#define DOS_MASK     (ONE<<DOS_SIGNAL)

#define PTR(x,p)     ((struct x *)(p))

extern void GetProcList(),FreeProcList(),PrintPkt();
extern LONG AllocSignal(), Wait();
extern struct Message *PacketWait(), *GetMsg();
extern struct Process *FindTask();
extern struct DosLibrary *DOSBase;
extern int Dump_OK, Lock_OK;


struct MsgPort         *thePort;        /* the port we will be monitoring */
struct Process         *myProcess;      /* pointer to our own process */
ULONG                  WaitMask;        /* the task signal mask */
struct SignalSemaphore CanReturn = {0}; /* coordinates PacketWait */
struct Message         *theMessage;     /* the message we received */
APTR                   OldPktWait;      /* the old pr_PktWait routine */


#ifdef MANX
   LONG PWait();        /* this is the ASM stub that calls PacketWait() */
#else
   #define PWait   PacketWait
#endif

#ifndef MANX
   Ctrl_C()             /* Control-C Trap routine for Lattice */
   {
      return(0);
   }
#endif


/*
 *  PacketWait()
 *
 *  This is the routine placed in the pr_PktWait field of the monitored
 *  precess.  It is run asynchronously by the monitored process, and is
 *  called whenever AmigaDOS does a taskwait().  PacketWait() waits for
 *  a message to come in and then signals the monitoring task that one has
 *  arrived.  It then attempts to obtain the semaphore, which will not be
 *  released by the monitoring process until it is finished printing the 
 *  contents of the packet.
 */

struct Message *PacketWait()
{
#ifdef MANX
   /*
    *  if MANX, make sure we can see our data
    */
   geta4();
#endif

   SetSignal(FALSE,DOS_MASK);

   while(!(theMessage = GetMsg(thePort)))  Wait(DOS_MASK);

   Signal(myProcess,WaitMask);
   ObtainSemaphore(&CanReturn);
   ReleaseSemaphore(&CanReturn);

   return(theMessage);
} 


/*
 *  DoArguments()
 *
 *  Parses the command line to make sure it contains only valid arguments,
 *  and sets the flag variables to their proper values (they are initialized
 *  in printpkt.c).  The legal options are:
 *
 *      [NO]DUMP        To control hex dumps of long buffers
 *      [NO]LOCK        To control the display of LOCK parameters
 *                      (you should use NOLOCK if you are monitoring a
 *                      file system process).
 */

void DoArguments(argc,argv)
int argc;
char **argv;
{
   while (--argc)
   {
      argv++;
      if (stricmp(*argv,"NODUMP") == 0)      Dump_OK = FALSE;
      else if (stricmp(*argv,"DUMP") == 0)   Dump_OK = TRUE;
      else if (stricmp(*argv,"NOLOCK") == 0) Lock_OK = FALSE;
      else if (stricmp(*argv,"LOCK") == 0)   Lock_OK = TRUE;
      else
      {
         printf("Bad Argument:  '%s'\n",*argv);
         printf("Usage:  MONPROC [NO]DUMP [NO]LOCK\n");
         exit(5);
      }
   }
}


/*
 *  GetProcToMonitor()
 *
 *  Lists the processes currently running and lets the user choose one.
 *  Returns a pointer the the chosen process.
 */

struct Process *GetProcToMonitor()
{
   struct List           ProcList;
   struct Node           *theProc;
   struct Process        *ChosenProcess = NULL;
   ULONG                 count,choice;
   char                  s[80];

/*
 *  Set up ProcList and a list header and read the process list into it
 *  (we assume the process list won't change).
 */
   NewList(&ProcList);
   GetProcList(&ProcList);

/*
 *  If there are any processes, list them and let the user chose one by 
 *  number.  If he choses a legal number, find the process in the list
 *  and return a pointer to the process structure for that process.
 *  Finally, free the process list.
 */
   if (ProcList.lh_TailPred == PTR(Node,&ProcList))
   {
      printf("No Processes.\n");
   } else {
      do
      {
         printf("\nEnter NUMBER for process to monitor:\n"); 
         printf("Pick# Process  MsgPort  Name\n");    
         for (count=1,theProc=ProcList.lh_Head;    /* start at the list head */
              theProc->ln_Succ;                    /* while there are more */
              theProc=theProc->ln_Succ,count++)    /* go on to the next */
         {
            printf("%4ld. %08lX %08lX %s\n",count,
               theProc->ln_Name,
               &(PTR(Process,theProc->ln_Name)->pr_MsgPort),
               PTR(Process,theProc->ln_Name)->pr_Task.tc_Node.ln_Name);
         }
         printf("\nNUMBER: ");
         gets(s);
      } while (sscanf(s,"%ld",&choice) != 1);
  
      if (choice < 1 || choice >= count)
      {
         printf("Operation Aborted.\n");
      } else {
         for (count=1,theProc=ProcList.lh_Head;
              count < choice;
              theProc=theProc->ln_Succ,count++);
         ChosenProcess = PTR(Process,theProc->ln_Name);
      }
      FreeProcList(&ProcList);
   }
   return(ChosenProcess);
}


/*
 *  SetupSignal()
 *
 *  Allocate a signal to use for our inter-task communication, and
 *  set up the mask for using it.
 */

void SetupSignal(theSignal)
LONG *theSignal;
{
   *theSignal = AllocSignal(-ONE);
   if (*theSignal == -ONE)
   {
      printf("Can't Allocate a Task Signal.");
      exit(10);
   }
   WaitMask = (ONE << (*theSignal));
}


/*
 *  SetupProcess()
 *
 *  Copy the process name, and gets it Message port.  Set our priority
 *  higher than the monitored process so we will be able to react to its
 *  signals.  Then set the pr_PktWait field so that we begin monitoring 
 *  the other task.  Save the old one so we can put it back.
 */

void SetupProcess(theProcess,name)
struct Process *theProcess;
char *name;
{
   strcpy(name,theProcess->pr_Task.tc_Node.ln_Name);
   thePort = &theProcess->pr_MsgPort;

   Forbid();
   SetTaskPri(myProcess,(ULONG)(theProcess->pr_Task.tc_Node.ln_Pri + 1)); 
   OldPktWait = theProcess->pr_PktWait;
   theProcess->pr_PktWait = (APTR) PWait;
   Permit();
}


/*
 *  MonitorProcess()
 *
 *  Wait for the monitored process to receive a message (our PacketWait()
 *  function signals us via theSignal when it has received a message), then
 *  print out the contents of the message.  A semaphore is used to coordinate
 *  this routine with the PacketWait() routine (which is run asynchonously
 *  by the monitored process).  Phillip Lindsay says "there are probably a
 *  hundred better was of doing this.  I just went with the first one [that]
 *  came to mind."  I couldn't think of a better one, so I still use it.
 *  Since our process is running at a higher priority than the monitored one,
 *  we should obtain the semaphore first.  The other process wil block until
 *  we release it (when we are done printing the contents).
 */

void MonitorProcess(name,theSignal)
char *name;
ULONG theSignal;
{
   ULONG                signals;
   struct DosPacket     *thePacket;

   do 
   {
      signals = Wait(SIGBREAKF_CTRL_C | WaitMask); 
      ObtainSemaphore(&CanReturn); 
      if (signals & WaitMask)
      {
         /*
          *  PacketWait() signalled us so print the message it put in
          *  theMessage.
          */
         thePacket = PTR(DosPacket,theMessage->mn_Node.ln_Name);
         printf("\n%s: ",name);     
         PrintPkt(thePacket);
      }
      ReleaseSemaphore(&CanReturn);
   } while(!(signals & SIGBREAKF_CTRL_C)); 
}


/*
 *  ClenUpProcess()
 *
 *  Put everything back the way we found it, except that the monitored process
 *  is still running our code...
 */

void CleanUpProcess(theProcess)
struct Process *theProcess;
{
   Forbid();
   theProcess->pr_PktWait = OldPktWait;
   Permit();
   SetTaskPri(myProcess,0L);
}


/*
 *  WaitForLastPacket()
 *
 *  Since the monitored process is still running our PacketWait() code, we
 *  can't quit yet.  Since we already put back the old pr_PktWait pointer,
 *  our code will not be called after the next packet is received, so we have
 *  to wait for one more packet before we can quit.  Note that PacketWait()
 *  will still signal us, so we know when it will be safe to remove the code.
 *  Just in case we goof, let CTRL-E cancel, too.
 */

void WaitForLastPacket(theSignal)
ULONG theSignal;
{
   ULONG signals;

   printf("\nThe process must receive another message before we can safely\n");
   printf("remove the packet wait code.  We will wait for one more packet.\n");
   printf("Press CTRL-E if you want to quit early, but that will likely\n");
   printf("crash the monitored process!\n");

   signals = Wait(SIGBREAKF_CTRL_E | WaitMask);
   if (signals & WaitMask)
   {
      ObtainSemaphore(&CanReturn);
      ReleaseSemaphore(&CanReturn);
   }
}

void main(argc,argv)
int argc;
char **argv;
{
   struct Process    *ChosenProcess;
   LONG              TaskSignal;
   UBYTE             ProcessName[81];
   
   if (argc > 1) DoArguments(argc,argv);

   printf("\n%s - monitor AmigaDOS process packet activity.\n",*argv);

   myProcess = FindTask(NULL);
   ChosenProcess = GetProcToMonitor();
   if (ChosenProcess != NULL)
   {
      #ifndef MANX
         onbreak(&Ctrl_C);    /* Turn off CTRL-C for Lattice:  we do our own */
      #endif

      SetupSignal(&TaskSignal);
      InitSemaphore(&CanReturn);
      SetupProcess(ChosenProcess,ProcessName);
      printf("Monitor Installed, press CTRL-C to quit monitoring\n"); 
   
      MonitorProcess(ProcessName,TaskSignal);
      
      CleanUpProcess(ChosenProcess);
      WaitForLastPacket(TaskSignal);
      FreeSignal(TaskSignal);

      printf("\nAll done.\n");
   }
}


/*
 *  This code stub has been known to save lives... 
 */

#if MANX        
#asm
        XREF _PacketWait

        XDEF _PWait
_PWait:
        movem.l a2/a3/a4,-(sp)
        jsr _PacketWait
        movem.l (sp)+,a2/a3/a4
        rts
#endasm
#endif
