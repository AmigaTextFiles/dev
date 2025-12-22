
/*
 * [!BGN - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 * Program   : Vivid (A simple program that tracks memory flushes)
 * Version   : 1.0
 * File      : Work:Source/!WIP/Vivid/Vivid.c
 * Author    : Andrew Bell
 * Copyright : Copyright © 1999 Andrew Bell. All rights reserved.
 * Created   : Tuesday 19-Oct-99 02:16:30
 * Modified  : Wednesday 20-Oct-99 00:52:49
 * Comment   : 
 *
 * (Generated with StampSource 1.3 by Andrew Bell)
 *
 * [!END - MACHINE GENERATED - DO NOT EDIT THIS HEADER]
 *
 */

/* Created: Tue/19/Oct/1999 */

/* Includes */

#include <Vivid_rev.h>
#include <string.h>
#include <stdio.h>
#include <exec/types.h>
#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/interrupts.h>
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <intuition/intuition.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <pragma/exec_lib.h>
#include <pragma/dos_lib.h>
#include <pragma/intuition_lib.h>
#pragma header

/* Prototypes */

LONG vivid_LowMemHandlerCode( register __a0 struct MemHandlerData *MHD );
LONG main( void );
BOOL v_InitPrg( void );
void v_EndPrg( void );
void v_DoPrg( void );
UBYTE *v_BuildMEMFStr( ULONG MemFlags );
UBYTE *v_BuildMHFStr( ULONG MHFlags );
BOOL v_DateStampToStr( struct DateStamp *DS, UBYTE *Buf );

/* Defines */

struct FlushMsg
{
  struct Message         fm_Msg;
  struct Task           *fm_Task;
  struct MemHandlerData  fm_MHD;
  UBYTE                  fm_TaskName[256+4];
};

#define LOWMEM_HANDLER_DEFAULT_PRIORITY 25
#define YEAR     "1999"
#define ARGPLATE "PRIORITY/N,REQ/S"

struct ArgLayout
{
  ULONG *arg_PRIORITY;
  ULONG *arg_REQ;
};

/* Variables and data */

struct MsgPort *FlushMP = NULL;
ULONG FlushMP_SigFlag = 0;
struct Task *VTask = NULL;
struct Library *IntuitionBase = NULL;
extern struct ExecBase *SysBase;
BOOL HandlerInstalled = FALSE;
LONG HandlerPriority = LOWMEM_HANDLER_DEFAULT_PRIORITY;
struct ArgLayout Args;
struct RDArgs *ArgInfo = NULL;
UBYTE *VTag = VERSTAG " Copyright © " YEAR " Andrew Bell. All rights reserved.";
BPTR OutputFH = 0;

LONG vivid_LowMemHandlerCode( register __a0 struct MemHandlerData *MHD )
{
  /*********************************************************************
   *
   * This is the actual low memory handler. This handler simply sends
   * a message to the main Vivid task with some information about the
   * memory flush.
   *
   * Remember that this routine is being called on the context of
   * AllocMem() by another task! Stack usage MUST be within 128 bytes.
   *
   *********************************************************************
   *
   */
  
  register struct Task *AlienTask = FindTask(NULL);

  if (AlienTask != VTask) /* We ignore our own task, for now. */
  {
    register struct FlushMsg *FM;

    FM = AllocVec(sizeof(struct FlushMsg), MEMF_CLEAR|MEMF_PUBLIC);

    if (FM)
    {
      /* The actual memory that the message is stored
         in is freed by the main Vivid task, and not
         this task (AlienTask). This allows us to be
         non-blocking. */

      FM->fm_Msg.mn_ReplyPort = NULL;
      FM->fm_Msg.mn_Length = sizeof(struct FlushMsg);
      FM->fm_Task = AlienTask;  
      FM->fm_MHD.memh_RequestSize = MHD->memh_RequestSize;
      FM->fm_MHD.memh_RequestFlags = MHD->memh_RequestFlags;
      FM->fm_MHD.memh_Flags = MHD->memh_Flags;

      if (AlienTask->tc_Node.ln_Name)
      {
        strncpy(FM->fm_TaskName, AlienTask->tc_Node.ln_Name, 255);
      }
      else
      {
        strcpy(FM->fm_TaskName, "<< Unknown >>");
      }
      PutMsg(FlushMP, (struct Message *) FM);
    }
  }
  return MEM_DID_NOTHING;
}

struct Interrupt vivid_LowMemHandlerData =
{ 
  {
    NULL,
    NULL,
    NT_INTERRUPT,
    LOWMEM_HANDLER_DEFAULT_PRIORITY,
    "Vivid's low memory handler"
  },
  NULL,
  (void *) &vivid_LowMemHandlerCode
};

LONG main( void )
{
  /*********************************************************************
   *
   * Program's entry point.
   *
   *********************************************************************
   *
   */

  LONG RC = RETURN_FAIL;

  if (v_InitPrg())
  {
    v_DoPrg(); RC = RETURN_OK;
  }
  v_EndPrg();

  return RC;
}

BOOL v_InitPrg( void )
{
  /*********************************************************************
   *
   * Init program, this includes:
   *
   * ·Check for exec.library 39+ (OS 3.0+).
   * ·Get our task structure.
   * ·Setup output stream.
   * ·Read the CLI args.
   * ·Setup handler's priority.
   * ·Open intuition.library version 39+.
   * ·Allocate a message port & setup signal flags.
   * ·Add a memory handler.
   *
   *********************************************************************
   *
   */

  if (SysBase->LibNode.lib_Version < 39) return FALSE;

  VTask = FindTask(NULL);
  if (!VTask) return FALSE; /* Should not really happen. */

  OutputFH = Output(); /* Get our output stream */

  ArgInfo = ReadArgs(ARGPLATE, (LONG *) &Args, NULL);
  if (!ArgInfo)
  {
    PrintFault(IoErr(), "Vivid error ");
    return FALSE;
  }

  HandlerPriority = LOWMEM_HANDLER_DEFAULT_PRIORITY;

  if (Args.arg_PRIORITY)
  {
    HandlerPriority = *Args.arg_PRIORITY;

    if (HandlerPriority > 127)
      HandlerPriority = 127;
    else if (HandlerPriority < -127)
      HandlerPriority = -127;
  }

  IntuitionBase = OpenLibrary("intuition.library", 39L);
  if (!IntuitionBase) return FALSE;

  FlushMP = CreateMsgPort();
  if (!FlushMP) return FALSE;

  FlushMP_SigFlag = (1 << FlushMP->mp_SigBit);

  vivid_LowMemHandlerData.is_Node.ln_Pri = HandlerPriority;

  AddMemHandler((struct Interrupt *) &vivid_LowMemHandlerData);
  HandlerInstalled = TRUE;

  return TRUE;
}

void v_EndPrg( void )
{
  /*********************************************************************
   *
   * End program, this includes:
   *
   * ·Remove the low memory handler.
   * ·Flush and deallocate the message port.
   * ·Close intuition.library.
   * ·Free the CLI args.
   *
   *********************************************************************
   *
   */

  Forbid();

  if (HandlerInstalled)
  {
    RemMemHandler((struct Interrupt *) &vivid_LowMemHandlerData);
    HandlerInstalled = FALSE;
  }
  
  if (FlushMP)
  {   
    /* Before we remove the message port, we must remove any
       pending messages from the port. */

    register struct Message *TmpMsg;

    while(TmpMsg = GetMsg((struct MsgPort *)FlushMP))
    {
      FreeVec(TmpMsg);
    }

    DeleteMsgPort(FlushMP); FlushMP = NULL;
  }

  Permit();
    
  if (IntuitionBase)
  {
    CloseLibrary(IntuitionBase); IntuitionBase = NULL;
  }

  if (ArgInfo)
  {
    FreeArgs(ArgInfo); ArgInfo = NULL;
  }
} 

void v_DoPrg( void )
{
  /*********************************************************************
   *
   * This is the main program loop. It simply waits for messages to
   * arrive from the memory handler. 
   *
   * The program will always quit when it encounters a SIGBREAKF_CTRL_C.
   *
   *********************************************************************
   *
   */

  register BOOL Running = TRUE;
  register ULONG HitCnt = 0;

  Printf(VERS " (" DATE "), Copyright © " YEAR " Andrew Bell. All rights reserved.\n"
        "Vivid has been installed. Press `Control + C' to break out.\n");

  while (Running)
  {
    register ULONG SigEvent = Wait(SIGBREAKF_CTRL_C | FlushMP_SigFlag);

    if (SigEvent & SIGBREAKF_CTRL_C)
    {
      Running = FALSE;
    }
    else if (SigEvent & FlushMP_SigFlag)
    {
      register struct FlushMsg *FM = NULL;
      register UBYTE *MEMFStr = NULL;
      register UBYTE *MHFStr = NULL;

      while (FM = (struct FlushMsg *) GetMsg((struct MsgPort *)FlushMP))
      {       
        MEMFStr = v_BuildMEMFStr(FM->fm_MHD.memh_RequestFlags);
        MHFStr = v_BuildMHFStr(FM->fm_MHD.memh_Flags);

        if (Args.arg_REQ)
        {, and I can
          struct EasyStruct EZS =
          {
            sizeof(struct EasyStruct), 0, VERS,
            "The memory was flushed by task:\n"
            "`%.64s' (TaskPtr = 0x%08lx)\n"
            "\n"
            "These parameters were passed to the low memory handler:\n"
            "\n"
            "memh_RequestSize  = 0x%08lx\n"
            "memh_RequestFlags = 0x%08lx\n"
            "[%s]\n"
            "memh_Flags        = 0x%08lx\n"
            "[%s]",
            "Continue|Quit",
          };

          switch(EasyRequest(NULL, (struct EasyStruct *) &EZS, NULL,
            FM->fm_TaskName, FM->fm_Task, FM->fm_MHD.memh_RequestSize,
            FM->fm_MHD.memh_RequestFlags, (MEMFStr ? MEMFStr : "???"),
            FM->fm_MHD.memh_Flags, (MHFStr ? MHFStr : "???") ))
          {           
             /* Quit */     default: case 0: Running = FALSE; break;
             /* Continue */ case 1: break;
          }
        }
        else
        {
          UBYTE DateStrBuf[128+4];
          struct DateStamp DS;
          DateStamp((struct DateStamp *) &DS);

          if (!v_DateStampToStr( (struct DateStamp *) &DS, DateStrBuf))
          {
            strcpy(DateStrBuf, "<< Unknown >>");
          }

          FPrintf(OutputFH,
            "\n"
            "A memory flush has been detected (no. %03lu) : %s\n"
            "Low mem handler was triggered by task: 0x%08lx (%s)\n"
            "memh_RequestSize  = 0x%08lx\n"
            "memh_RequestFlags = 0x%08lx (%s)\n"
            "memh_Flags        = 0x%08lx (%s)\n",
              ++HitCnt,
              DateStrBuf,
              FM->fm_Task, FM->fm_TaskName,
              FM->fm_MHD.memh_RequestSize,
              FM->fm_MHD.memh_RequestFlags, (MEMFStr ? MEMFStr : "???"),
              FM->fm_MHD.memh_Flags, (MHFStr ? MHFStr : "???"));
        }

        if (MEMFStr) FreeVec(MEMFStr);
        if (MHFStr) FreeVec(MHFStr);
        FreeVec(FM);

        if (!Running) break;

      } /* while() */
    } /* else if () */
  } /* for (;;) */
}

UBYTE *v_BuildMEMFStr( ULONG MemFlags )
{
  /*********************************************************************
   *
   * Construct a readable memory flag string. The result is actually
   * a memory vector, use FreeVec() to free it.
   *
   *********************************************************************
   *
   */

  register ULONG MF = MemFlags;
  register UBYTE *StrVec = AllocVec(512, MEMF_CLEAR);

  if (StrVec)
  {
    if (MF == MEMF_ANY)
      strcpy(StrVec, "MEMF_ANY");
    else
    {
      if (MEMF_PUBLIC & MF)
        strcat(StrVec, "MEMF_PUBLIC, ");

      if (MEMF_CHIP & MF)
        strcat(StrVec, "MEMF_CHIP, ");

      if (MEMF_FAST & MF)
        strcat(StrVec, "MEMF_FAST, ");

      if (MEMF_LOCAL & MF)
        strcat(StrVec, "MEMF_LOCAL, ");

      if (MEMF_24BITDMA & MF)
        strcat(StrVec, "MEMF_24BITDMA, ");

      if (MEMF_KICK & MF)
        strcat(StrVec, "MEMF_KICK, ");

      if (MEMF_CLEAR & MF)
        strcat(StrVec, "MEMF_CLEAR, ");

      if (MEMF_LARGEST & MF)
        strcat(StrVec, "MEMF_LARGEST, ");

      if (MEMF_REVERSE & MF)
        strcat(StrVec, "MEMF_REVERSE, ");

      /* These two have been added for completeness. They'll probably
         come in handy when debugging programs. */

      if (MEMF_TOTAL & MF)
        strcat(StrVec, "MEMF_TOTAL, ");

      if (MEMF_NO_EXPUNGE & MF)
        strcat(StrVec, "MEMF_NO_EXPUNGE, "); 

      if (strlen(StrVec) >= 2)
      {
        StrVec[strlen(StrVec) - 2] = 0;
      }
    }
  }
  return StrVec;
}

UBYTE *v_BuildMHFStr( ULONG MHFlags )
{
  /*********************************************************************
   *
   * Same as v_BuildMEMFStr(), but is used on MemHandlerData->memh_Flags
   *
   *********************************************************************
   *
   */

  register ULONG MHF = MHFlags;
  register UBYTE *StrVec = AllocVec(512, MEMF_CLEAR);

  if (StrVec)
  {
    if (MHF == 0)
      strcpy(StrVec, "No flags given");
    else
    {
      if (MEMHF_RECYCLE & MHF)
        strcat(StrVec, "MEMHF_RECYCLE")
    }
  }
  return StrVec;
}

BOOL v_DateStampToStr( struct DateStamp *DS, UBYTE *Buf )
{
  /*********************************************************************
   *
   * Construct a date string using a standard dos.library DateStamp
   * structure. Example output: Friday 15-Oct-99 18:00:00
   *
   * Notes
   * -----
   * Buf should point to a buffer at least 128 bytes long!
   *
   *********************************************************************
   *
   */

  UBYTE DayPart[LEN_DATSTRING];
  UBYTE DatePart[LEN_DATSTRING];
  UBYTE TimePart[LEN_DATSTRING];

  struct DateTime MyDT =
  {
    { 0, 0, 0 },
    FORMAT_DOS,
    0,
    (UBYTE *) &DayPart,
    (UBYTE *) &DatePart,
    (UBYTE *) &TimePart
  };

  DayPart[0] = 0; DatePart[0] = 0; TimePart[0] = 0;

  MyDT.dat_Stamp.ds_Days   = DS->ds_Days;
  MyDT.dat_Stamp.ds_Minute = DS->ds_Minute;
  MyDT.dat_Stamp.ds_Tick   = DS->ds_Tick;

  if ( DateToStr( (struct DateTime *) &MyDT ) )
  {
    sprintf(Buf, "%s %s %s", (UBYTE *) &DayPart, (UBYTE *) &DatePart, (UBYTE *) &TimePart );
    return TRUE;
  }

  return FALSE;
}



