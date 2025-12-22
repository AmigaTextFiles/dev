/* StackCheck V1.0 written by Günther Röhrich */
/* This program is Public Domain              */

/* To compile with Aztec C 5.2a:                                */
/*   cc -so stackcheck.c                                        */
/*   ln stackcheck -lc                                          */
/* To compile with GNU C 2.3.3:                                 */
/*   gcc -O2 stackcheck.c -lamy -o stackcheck                   */

/* If you want to adjust to another compiler you have to turn   */
/* off the compiler's CTRL-C handler                            */
/* NOTE: when using Aztec C or GNU C a short inline assembler   */
/*       routine is used to get maximum speed                   */

#include <exec/execbase.h>
#include <dos/dosextens.h>
#include <string.h>
#include <stdio.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#ifdef AZTEC_C
#include <pragmas/exec_lib.h>
#include <pragmas/dos_lib.h>
#endif

#ifdef __GNUC__
#include <signal.h>
#define MYSTRCMP strcasecmp
#define MYSTRNCMP strncasecmp
#else
#define MYSTRCMP strcmp
#define MYSTRNCMP strncmp
#endif

#define WHITE  "\x1B[32m"
#define NORMAL "\x1B[39m"
#define CTRL_C (SetSignal(0L,0L)&SIGBREAKF_CTRL_C)
#define MAXSTRSIZE 80         /* maximum string size */
#define FILLED_UNKNOWN 0
#define FILLED_PATTERN 1
#define FILLED_ZERO    2
#define STATUS_OK              0
#define STATUS_OTHER_STACK     1
#define STATUS_STACK_OVERFLOW  2


#ifdef DEBUG
BOOL PrintFlag = TRUE;
#endif

char        *ver = "\0$VER: StackCheck 1.0 (2.5.93)";
UBYTE        OSVersion;

/* NOTE: all 680x0 processors keep A7 word-aligned                  */
/* WARNING: the last word on the stack has the address SPUpper - 2  */ 
APTR         SPReg;           /* register A7 of the task we check */
USHORT      *SPUpper;         /* upper bound of the stack we are checking */
USHORT      *SPUpperFirst;
USHORT      *GlobalSPLower;   /* a copy of the local SPLower */
struct Task *Task = NULL;     /* the structure of the task we check */      
ULONG        UsedMax;         /* the maximum stack used so far */
USHORT       StackBase[8];    /* the last 8 words on the stack */
ULONG        LongStackBase[4];

/* default values */
ULONG        CheckDelay = 2L;
LONG         Pri = 1L;
LONG         Size=0L;         /* default for SIZE option */
LONG         Num = 0L;        /* number of CLI           */
SHORT        Filled = FILLED_UNKNOWN;
USHORT       StackStatus = STATUS_OK;
USHORT       AbortFlag = 0;   /* indicates what to do at CTRL-C */

#ifdef AZTEC_C
extern int Enable_Abort;     /* indicates if CTRL-C handling allowed */
#endif
extern struct ExecBase *SysBase;

/* forward declarations */
                              
void         AbortUsage(void);    
void         PrintFilled(void);
struct Task *FindTaskEnhanced(UBYTE *name); 
void         BConvert(BSTR BString); 
void         Abort(void);

UBYTE ConvertedString[MAXSTRSIZE]; /* needed by BConvert */

void main(argc, argv)
int argc;
char *argv[];
{
 /* local variables to get maximum speed                        */
 /* this is needed to increase performance because Aztec C does */
 /* not put global variables and constants into registers       */
 /* NOTE: GNU C does it when using -O2 option                   */
 ULONG   i=0L;        
 ULONG   Free;     /* amount of free stack (in words) */
 USHORT *SPLower;  /* lower bound of the stack we are checking */
 USHORT  ConstFill = 0xBEEF; /* value to fill the unused stack area */

 OSVersion = SysBase->LibNode.lib_Version;

 #ifdef AZTEC_C             /* Disable Aztec C CTRL-C handling */
 Enable_Abort = 0;         
 #endif
 #ifdef __GNUC__            /* Disable GNU C CTRL-C handling */
 signal(SIGINT, SIG_IGN);
 #endif

 printf("StackCheck V1.0 by Günther Röhrich\n"
        "This program is Public Domain. Press CTRL-C to abort.\n\n");

 if(argc < 2) AbortUsage();
 
 for(i = 2; i < argc; i++) 
 {
   #ifndef __GNUC__
   strupr(argv[i]);
   #endif
   if(!MYSTRNCMP(argv[i], "DELAY=", 6))
   {
     CheckDelay = strtoul(&argv[i][6], NULL, 0);
     if(CheckDelay == 0 || CheckDelay > 3000)
     {
       printf("DELAY must be between 1 and 3000\n");
       exit(10);
     }
   }
   else if(!MYSTRNCMP(argv[i], "PRI=", 4))
   {
     Pri = strtol(&argv[i][4], NULL, 0);
     if(Pri > 5 || Pri < 0)
     {
       printf("PRI must be between 0 and 5\n");
       exit(10);
     }
   }
   else if(!MYSTRNCMP(argv[i], "STACK=", 6))
   {
     Size = strtol(&argv[i][6], NULL, 0);
     /* make Size divisible by 4 */
     /* the OS does the same     */ 
     Size = Size & 0xFFFFFFFC;
   }
   else if(!MYSTRNCMP(argv[i], "NUM=", 4))
   {
     Num = strtol(&argv[i][4], NULL, 0);
   }
   else AbortUsage();
 }


 #ifndef DEBUG
 SetTaskPri(FindTask(NULL), Pri); /* set our task to the desired priority */
 #endif

 while(Task == NULL)  /* waits until the task is found */
 {
   Forbid();
   Task = FindTaskEnhanced((UBYTE *)argv[1]);
   #ifdef DEBUG
   PrintFlag = FALSE;
   #endif
   Permit(); 
   if(Task) break;   /* if task is found exit the loop */
   if(CTRL_C) Abort();   /* handle CTRL-C                  */
   Delay(CheckDelay); 
 }

 Forbid(); 
 SPUpperFirst = SPUpper;

 /* ensure that the task is still there */
 Task = FindTaskEnhanced((UBYTE *)argv[1]);  
 if(Task)
 {
   /* ensure we still have the same stack area */
   if(SPUpper == SPUpperFirst)
   {
     SPReg = Task->tc_SPReg;
     SPLower = GlobalSPLower;
     if(SPReg < SPLower || SPReg > SPUpper)
     {
        Permit();
        printf("Could not fill unused stack area.\n");
        printf("Task uses alternative stack or stack already overflowed.\n");
        exit(5);
     }
     Free = ((ULONG)SPReg - (ULONG)SPLower)/2L;

     for(i=0; i < 8; i++) StackBase[i] = SPLower[i];
     /* Let's fill up the unused stack area (if it's not already done) */
     /* we assume that the unused area contains 0 bytes                */
     if((SPLower[0] == 0) && (SPLower[1] == 0) && (Free > 2))
     {
       i=0;
       Filled = FILLED_ZERO;
       while((SPLower[i] == 0) && (i < Free)) SPLower[i++] = ConstFill;
     }

     /* if the unused area is filled with an unknown pattern,      */
     /* let's fill it with our own pattern                         */
     /* WARNING: by doing that UsedMax becomes inaccurate          */
     else if((SPLower[0] != ConstFill) || (SPLower[1] != ConstFill))
     {
       for(i = 0; i < Free; i++) SPLower[i] = ConstFill;
     }
     else Filled = FILLED_PATTERN;
   }
 }

 AbortFlag = 1; /* Use Break1() in case of CTRL-C */

 while(Task) /* this loop ends if the task finishes or CTRL-C is pressed */
 {
   /* ensure that the task is still there */
   Task = FindTaskEnhanced((UBYTE *)argv[1]); 
   if(Task == NULL)
   {
     Permit();              
     break;
   }
   /* ensure we still have the same stack area */   
   if(SPUpper == SPUpperFirst)
   {
     SPReg = Task->tc_SPReg;
     SPLower = GlobalSPLower;
     Free = ((ULONG)SPUpper - (ULONG)SPLower) / 2;

     for(i=0; i < 4; i++) LongStackBase[i] = *(ULONG *)&SPLower[i*2];
     /* count the undamaged area from SPLower to SPUpper   */
     /* written in assembler to get maximum speed          */
     /* (This is of course not the fastest solution, I am  */
     /* a C programmer, not an assembler freak. Some minor */
     /* enhancements are still possible.)                  */
     #if defined AZTEC_C
     /* a0 and d0 are scratch registers when Aztec C is used, */
     /* there is no need to preserve them                     */
     #asm
                move.l   _GlobalSPLower,a0
                move.l   #$BEEFBEEF,d0     
        asm1:   cmp.l    (a0)+,d0          
                beq      asm1              
                lea      -4(a0),a0         ;decrement a0 by 4
                cmp.w    #$BEEF,(a0)       
                beq      asm2
                lea      -2(a0),a0         ;decrement a0 by 2
        asm2:   move.l   _SPUpper,d0
                sub.l    a0,d0
                subq.l   #2,d0
                move.l   d0,_UsedMax
     #endasm
     #elif defined __GNUC__
     /* let the compiler determine what registers to use          */
     /* NOTE: GNU C does not have scratch registers like Aztec C  */
     /* NOTE: we have to use a different syntax                   */
     asm ("
                movel    #0xBEEFBEEF,%0;
        asm1:   cmpl     %1@+,%0;
                jeq      asm1;
                lea      %1@(-4),%1;
                cmpw     #0xBEEF,%1@;       
                jeq      asm2;
                lea      %1@(-2),%1;   
        asm2:   movel    %2,%0;
                subl     %1,%0;
                subql    #2,%0;"
     /* tell the compiler about register usage */
           : "=d" (UsedMax) : "a" (GlobalSPLower) , "a" (SPUpper)
     /* tell the compiler that we modified the condition codes */
     /* and register %1                                        */
           : "cc", "%1");                 
     #else
     /* for those who don't have an inline assembler: */
     /* this piece of code does the same job          */
     /* (but is a lot slower)                         */    
     for(i = 0; i < Free; i++) if(SPLower[i] != ConstFill) break;
     UsedMax = (ULONG)SPUpper - (ULONG)SPLower - i * 2;
     #endif
     
     if((SPReg < SPLower || SPReg > SPUpper) && StackStatus == STATUS_OK)
        StackStatus = STATUS_OTHER_STACK;
     if(UsedMax == Free * 2) StackStatus = STATUS_STACK_OVERFLOW;
   }
   Permit();
   Delay(CheckDelay);
   if(CTRL_C) Abort();  /* handle CTRL-C */
   Forbid();
 }

 #ifndef DEBUG
 SetTaskPri(FindTask(NULL), 0L); /* set back to normal priority */
 #endif

 PrintFilled();
 #ifdef DEBUG
 printf("SPReg:   %lX\n", SPReg);
 printf("SPUpper: %lX\n", SPUpper);
 printf("SPLower: %lX\n", SPLower);
 #endif
 printf("Stacksize: %lu\n", (ULONG)SPUpper - (ULONG)SPLower);
 if(StackStatus != STATUS_STACK_OVERFLOW) printf("Used max:  %lu\n", UsedMax);
 exit(0L);
}


void AbortUsage(void)
{
 printf("Usage: StackCheck Name|* [DELAY=n][PRI=n][STACK=n][NUM=n]\n");
 exit(10L);
}

/* We dont't know anything about the task and its stack usage */ 
void Break0(void)
{
 printf("StackCheck aborted, task not found.\n");
 exit(0L);
}

/* We know a little more */
void Break1(void)
{
 printf("StackCheck aborted, results so far:\n");
 PrintFilled();
 #ifdef DEBUG 
 printf("SPReg:   %lX\n", SPReg);
 printf("SPUpper: %lX\n", SPUpper);
 printf("SPLower: %lX\n", GlobalSPLower);
 #endif
 printf("Stacksize: %lu,", (ULONG)SPUpper - (ULONG)GlobalSPLower);
 printf(" Used now: %lu\n", (ULONG)SPUpper - (ULONG)SPReg);
 if(StackStatus != STATUS_STACK_OVERFLOW) printf("Used max:  %lu\n", UsedMax);
 exit(0L);
}

/* This function is called when CTRL-C is pressed   */
/* it overrides the default CTRL-C handler          */
/* AbortFlag indicates what function we should call */
void Abort(void)
{
 #ifndef DEBUG
 SetTaskPri(FindTask(NULL), 0L);
 #endif
 if(AbortFlag == 0) Break0();
 if(AbortFlag == 1) Break1();
 exit(0L);
}

BOOL CheckTask(struct Process *TaskFound, UBYTE *name)
{
 BOOL Found=FALSE;
 struct CommandLineInterface *CLIinfo;
 UBYTE TaskState;
 ULONG StackSize;

 TaskState = ((struct Process *)TaskFound)->pr_Task.tc_State;
 /* ensure Task is in a legal state */
 if(TaskState == TS_RUN || TaskState == TS_READY || TaskState == TS_WAIT)
 {
   StackSize = (ULONG)TaskFound->pr_Task.tc_SPUpper - 
               (ULONG)TaskFound->pr_Task.tc_SPLower;
   #ifdef DEBUG
   if(PrintFlag)
   {
     printf("Taskname: %s\n", TaskFound->pr_Task.tc_Node.ln_Name);
     printf("TaskStackSize: %ld\n", StackSize);
     printf("SPUpper: %lX\n", (ULONG)TaskFound->pr_Task.tc_SPUpper);
     printf("SPReg:   %lX\n", TaskFound->pr_Task.tc_SPReg);
     if(TaskFound->pr_Task.tc_Node.ln_Type == NT_PROCESS)
     {
       printf("ProcessStackSize: %ld\n", TaskFound->pr_StackSize);
       printf("TaskNum: %ld\n", TaskFound->pr_TaskNum);
       if(TaskFound->pr_TaskNum != 0L)
       {
         /* WARNING: pr_CLI is a BPTR */
         CLIinfo = (struct CommandLineInterface *)BADDR(TaskFound->pr_CLI);
         /* WARNING: cli_CommandName is a BSTR */
         BConvert(CLIinfo->cli_CommandName);
         printf("CommandName: %s\n", ConvertedString);
         printf("DefaultStack: %ld\n", CLIinfo->cli_DefaultStack * 4L);
       }
     }
     printf("\n");
   }
   #endif

   /* check if it is a process */
   if(TaskFound->pr_Task.tc_Node.ln_Type == NT_PROCESS)
   { 
     /* check if it is a CLI/Shell process */
     if(TaskFound->pr_TaskNum != 0L)
     {
       CLIinfo = (struct CommandLineInterface *)BADDR(TaskFound->pr_CLI);
       if(Num == 0L || Num == TaskFound->pr_TaskNum)
       {
         if((OSVersion >= 36) && (Size == 0L || Size == TaskFound->pr_StackSize)) 
         {
           /* WARNING: cli_CommandName is a BSTR */
           BConvert(CLIinfo->cli_CommandName);
           if(!strcmp((char *)name, (char *)ConvertedString) || name[0] == '*')
             if(StackSize == (ULONG)CLIinfo->cli_DefaultStack * 4L) Found = TRUE;
         }
       }
     }
     else
     {
       if((Num == 0) && (Size == 0L || Size == TaskFound->pr_StackSize) &&
          (strcmp((char *)name, TaskFound->pr_Task.tc_Node.ln_Name) == 0 ||
           name[0] == '*'))
         Found = TRUE;
     }
   }
   else
   {
     if(Size == 0L || Size == StackSize)
     {
       if((Num == 0) &&
          (strcmp((char *)name, TaskFound->pr_Task.tc_Node.ln_Name) == 0 ||
           name[0] == '*'))
         Found = TRUE;
     }
   }
 }
 if(Found)
 {
   SPUpper = TaskFound->pr_Task.tc_SPUpper;
   GlobalSPLower = TaskFound->pr_Task.tc_SPLower;
 }
 return(Found);
}

struct Task *FindTaskEnhanced(UBYTE *name)
{
 struct Node *TaskFound;
 BOOL Found=FALSE; 

 Forbid();    /* nested Forbid() calls are allowed */

 if(SysBase->TaskReady.lh_TailPred != (struct Node *)&SysBase->TaskReady)
 {
   for(TaskFound = SysBase->TaskReady.lh_Head; TaskFound->ln_Succ;
       TaskFound = TaskFound->ln_Succ)
   {
     Found = CheckTask((struct Process *)TaskFound, name);
     if(Found) break;
   }
 }
 
 if(SysBase->TaskWait.lh_TailPred != (struct Node *)&SysBase->TaskWait &&
    Found == FALSE)
 {
   for(TaskFound = SysBase->TaskWait.lh_Head; TaskFound->ln_Succ;
       TaskFound = TaskFound->ln_Succ)
   {
     Found = CheckTask((struct Process *)TaskFound, name);
     if(Found) break;
   }
 }
 
 if(Found == FALSE)
 {
   TaskFound = (struct Node *)SysBase->ThisTask;
   Found = CheckTask((struct Process *)TaskFound, name);
 }


 if(Found)
 {
   Permit();
   return((struct Task *)TaskFound);
 }
 else
 {
   Permit();
   return(NULL);
 }
}


/* convert a BCPL-string to a C-string */
void BConvert(BSTR BString)
{
 UBYTE *String;
 UBYTE i=0;

 String = (UBYTE *)BADDR(BString);
 while(i < String[0] && i < MAXSTRSIZE - 1)
 {
   ConvertedString[i] = String[i+1];
   i++;
 }
 ConvertedString[i] = 0;
}

void PrintPattern(void)
{
 USHORT i;
 printf("%08lX: ", GlobalSPLower);
 for(i=0; i < 8; i = i + 2)
 printf("%04hX%04hX ", StackBase[i], StackBase[i+1]);
 printf("\n");
}   

void PrintDamaged(void)
{
 USHORT i;
 printf("%08lX: ", GlobalSPLower);
 for(i=0; i < 4; i++)
 printf("%08lX ", LongStackBase[i]);
 printf("\n");
}

void PrintFilled(void)
{
 switch(Filled)
 {
   case FILLED_UNKNOWN: printf("Free stack area contained unknown pattern:\n");
                        PrintPattern();                               
                        break;
   case FILLED_PATTERN: printf("Free stack area contained known pattern:\n");
                        PrintPattern();
                        break;
   case FILLED_ZERO   : printf("Free stack area was cleared:\n");
                        PrintPattern();
 }
 switch(StackStatus)
 {
   case STATUS_OK            :
                               printf("Stack OK:\n");
                               PrintDamaged();
                               break;

   case STATUS_OTHER_STACK   : printf(WHITE
                                 "Task used alternative stack!\n" NORMAL);
                               printf("Status of normal stack area:\n");
                               PrintDamaged();

                               break;
   case STATUS_STACK_OVERFLOW: printf(WHITE  "Task stack overflowed:\n" NORMAL);
                               PrintDamaged();                          
 }
}
