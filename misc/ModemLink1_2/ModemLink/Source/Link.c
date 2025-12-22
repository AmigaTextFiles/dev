/*
** NAME: Link.c
** DESC: Routines deaing with the modem link protocol and packets.  Many
**       of the routines in this file are to be called by the user program.
**       These routines will be linked into both the device and linked lib
**       versions of modemlink.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  06 Apr 1997 Created
*/


#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <devices/serial.h>
#include <devices/timer.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <utility/tagitem.h>

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/utility.h>

#include <string.h>
#include <stdio.h>

#include "Link.h"
#include "CRC.h"
#include "DeviceStuff.h"
#include "ModemLinkAPI.h"
#include "ModemLinkTask.h"

// These defines are used exclusively by the automatom in Establish()
#define Q0 0
#define Q1 1
#define Q2 2
#define Q3 3
#define Qf 4

ULONG __saveds __asm
ML_LaunchTask
(
  register __a0 struct IOExtLink *LinkIO,
  register __a1 struct IOExtSer *SerIO
)
{
  struct MsgPort *Port;
  ULONG ResultCode = 0;
  int i = 0;

  stcl_h(LinkIO->LinkProcName, LinkIO->Unit);
  strcpy(LinkIO->LinkPortName, LinkIO->LinkProcName);
  strins(LinkIO->LinkProcName, "LinkProc");
  strins(LinkIO->LinkPortName, "LinkPort");

  Port = FindPort(LinkIO->LinkPortName);
  if (!Port) {
    CreateNewProcTags(
        NP_Entry, AckTask,
        NP_StackSize, 4096,
        NP_Name, LinkIO->LinkProcName,
        NP_Arguments, LinkIO->LinkPortName,
        NP_CopyVars, TRUE,
        TAG_END);

    do {
      Delay(5);
      Port = FindPort(LinkIO->LinkPortName);
    } while (!Port && ++i < 20);

    if (Port) {
      LinkIO->IOLink.io_Command = MLCMD_INIT;
      LinkIO->IOLink.io_Data = (APTR)SerIO;
      ML_BeginIO((struct IORequest *)LinkIO);
      WaitIO((struct IORequest *)LinkIO);

      ResultCode++;
    }
  }

  return(ResultCode);
}

ULONG __saveds __asm
ML_EstablishTagList
(
  register __a0 struct IOExtLink *LinkIO,
  register __a1 struct IOExtSer *SerIO,
  register __a2 struct TagItem *tagList
)
{
  struct timerequest *TimerIO = NULL;
  struct MsgPort *TimerMP = NULL;
  ULONG ReturnStatus;
  char ACKStates[4] = {Q3, Q3, Qf, Q3};
  char ENQStates[4] = {Q2, Q2, Q2, Qf};
  char buf[3] = {ENQ, ACK, 0};
  char State = Q0;

  if (OpenTimerDevice(&TimerMP, &TimerIO)) {
    TimerIO->tr_node.io_Command = TR_ADDREQUEST;
    TimerIO->tr_time.tv_secs = 5;
    TimerIO->tr_time.tv_micro = 0;
    SendIO((struct IORequest *) TimerIO);

    SerIO->IOSer.io_Command = CMD_WRITE;
    SerIO->IOSer.io_Length = 1;
    SerIO->IOSer.io_Data = &(buf[0]);
    DoIO((struct IORequest *) SerIO);

    State = Q1;

    while (State != Qf) {
      SerIO->IOSer.io_Command = CMD_READ;
      SerIO->IOSer.io_Length = 1;
      SerIO->IOSer.io_Data = &(buf[2]);

      if (TimedIO((struct IORequest *) SerIO, 1)) {
        if (buf[2] == ACK)
          State = ACKStates[State];
        else if (buf[2] == ENQ) {
          SerIO->IOSer.io_Command = CMD_WRITE;
          SerIO->IOSer.io_Length = 1;
          SerIO->IOSer.io_Data = &(buf[1]);
          DoIO((struct IORequest *) SerIO);

          State = ENQStates[State];
        }
      }
      else if (State == Q1 || State == Q2) {
        SerIO->IOSer.io_Command = CMD_WRITE;
        SerIO->IOSer.io_Length = 1;
        SerIO->IOSer.io_Data = &(buf[0]);
        DoIO((struct IORequest *) SerIO);
      }

      if (CheckIO((struct IORequest *) TimerIO))
        break;
    }

    if (!CheckIO((struct IORequest *) TimerIO))
      AbortIO((struct IORequest *) TimerIO);
    WaitIO((struct IORequest *) TimerIO);

    SafeCloseDevice(TimerMP, (struct IORequest *)TimerIO);
  }

  if (State == Qf)
    if (ML_LaunchTask(LinkIO, SerIO))
      ReturnStatus = EstErr_OK;
    else
      ReturnStatus = EstErr_TASK_ERR;
  else
    ReturnStatus = EstErr_TIMEOUT;

  return(ReturnStatus);
}

void __saveds __asm
ML_Terminate
(
  register __a0 struct IOExtLink *LinkIO
)
{
  struct Task *LinkProc;

  if (LinkIO && (LinkProc = FindTask(LinkIO->LinkProcName))) {
    Signal((struct Task *)LinkProc, SIGBREAKF_CTRL_C);

    do {
      Delay(10);
    } while (FindTask(LinkIO->LinkProcName));
  }
}

struct LinkPkt __saveds __asm
*ML_AllocPkt(void)
{
  struct LinkPkt *Pkt;
  if (Pkt =  (struct LinkPkt *)AllocMem(sizeof(struct LinkPkt), MEMF_PUBLIC | MEMF_CLEAR)) {
    Pkt->Data = NULL;
    Pkt->Length = 0;
  }

  return Pkt;
}

void __saveds __asm
ML_FreePkt
(
  register __a0 struct LinkPkt *Pkt
)
{
  if (Pkt) {
    if (Pkt->Data && (Pkt->Length > 0))
      FreeMem(Pkt->Data, Pkt->Length);
    FreeMem(Pkt, sizeof(struct LinkPkt));
  }
}

void __saveds __asm
ML_FreePktList
(
  register __a0 struct MinList *PktList
)
{
  struct LinkPkt *Pkt, *TmpPkt;

  if (PktList) {
    Pkt = (struct LinkPkt *)PktList->mlh_Head;

    while (Pkt->ml_Node.mln_Succ) {
      TmpPkt = (struct LinkPkt *)Pkt->ml_Node.mln_Succ;
      ML_FreePkt(Pkt);
      Pkt = TmpPkt;
    }
  }
}


ULONG __saveds __asm
ML_PacketizeData
(
  register __a0 struct MinList *PktList,
  register __a1 UBYTE *Data,
  register __d0 ULONG Length,
  register __d1 ULONG PktSize
)
{
  struct LinkPkt *tmp;

  if (PktSize <= 0)
    PktSize = Length;

  while (Length > 0) {
    if (tmp = ML_AllocPkt()) {
      tmp->Length = PktSize;
      if (tmp->Data = AllocMem(PktSize, MEMF_CLEAR | MEMF_PUBLIC)) {
        CopyMem(Data, tmp->Data, PktSize);
        Length -= PktSize;

        if (PktSize > Length)
          PktSize = Length;
        Data += PktSize;

        AddTail((struct List *)PktList, (struct Node *)tmp);
      }
      else {
        FreeMem(tmp, sizeof(struct LinkPkt));
        tmp = NULL;
      }
    }
    if (!tmp) {
      while (tmp = (struct LinkPkt *) RemHead((struct List *)PktList)) {
        if (tmp->Data)
          FreeMem(tmp->Data, tmp->Length);
        FreeMem(tmp, sizeof(struct LinkPkt));
      }
      Length = -1L;
    }
  }

  return (ULONG)(Length == 0);
}

ULONG __saveds __asm
ML_DePacketizeData
(
  register __a0 struct MinList *PktList,
  register __a1 UBYTE *Data,
  register __d0 ULONG Length
)
{
  struct LinkPkt *Pkt;
  ULONG TotalSize = 0L;
  ULONG PktSize;
  UBYTE *CurBuf = Data;

  if (PktList && Data && Length) {
    Pkt = (struct LinkPkt *)PktList->mlh_Head;

    while (Length > 0 && Pkt->ml_Node.mln_Succ) {
      PktSize = Pkt->Length;

      if (PktSize > Length)
        PktSize = Length;

      CopyMem(Pkt->Data, CurBuf, PktSize);

      Length -= PktSize;
      CurBuf += PktSize;
      TotalSize += PktSize;

      Pkt = (struct LinkPkt *)Pkt->ml_Node.mln_Succ;
    }
  }

  return(TotalSize);
}

ULONG __saveds __asm
ML_PacketDataSize
(
  register __a0 struct MinList *PktList
)
{
  struct LinkPkt *Pkt;
  ULONG TotalSize = 0L;

  if (PktList) {
    Pkt = (struct LinkPkt *)PktList->mlh_Head;

    while (Pkt->ml_Node.mln_Succ) {
      TotalSize += Pkt->Length;
      Pkt = (struct LinkPkt *)Pkt->ml_Node.mln_Succ;
    }
  }

  return(TotalSize);
}

struct IOExtLink *ML_GetMsg(struct MsgPort *MPort, ULONG PipeBit)
{
  struct IOExtLink *LinkIO;

  Forbid();

  if (LinkIO = (struct IOExtLink *)GetMsg(MPort))
    LinkIO->Flags = (LinkIO->Flags & (~ML_PIPE2)) | PipeBit;

  Permit();

  return (LinkIO);
}

void ML_ReplyMsg(struct IOExtLink *LinkReq)
{
  Forbid();

  if (LinkReq) {
    LinkReq->Flags &= ~ML_PIPE2;
    ReplyMsg((struct Message *)LinkReq);
  }

  Permit();
}
