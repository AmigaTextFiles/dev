/*
** NAME: ModemLinkTask.c
** DESC: This routine contains all the code for the built-in Stop & Wait
**       protocol.  This is spawned by modemlink from the Link.c module.
**       Other routines in this file are support routines for the protocol.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  06 Apr 1997 Created
*/


#include <exec/errors.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <devices/serial.h>
#include <devices/timer.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>

#include <proto/dos.h>
#include <proto/exec.h>

#include <string.h>
#include <stdio.h>
#include <dos.h>

#include "ModemLinkTask.h"
#include "Link.h"
#include "ModemLinkAPI.h"
#include "CRC.h"
#include "DeviceStuff.h"

char ReadPacketNum(struct IOExtSer *SerReadIO)
{
  char PktLong = 0;

  if (SerReadIO) {
    SerReadIO->IOSer.io_Command = CMD_READ;
    SerReadIO->IOSer.io_Length = sizeof(char);
    SerReadIO->IOSer.io_Data = (APTR)&PktLong;

    // To be changed to TimedIO() later on
    DoIO((struct IORequest *) SerReadIO);
  }

  return (PktLong);
}

int ReadPacketWord(struct IOExtSer *SerReadIO)
{
  int PktWord = -1;

  if (SerReadIO) {
    SerReadIO->IOSer.io_Command = CMD_READ;
    SerReadIO->IOSer.io_Length = sizeof(int);
    SerReadIO->IOSer.io_Data = (APTR)&PktWord;

    // To be changed to TimedIO() later on
    DoIO((struct IORequest *) SerReadIO);
  }

  return (PktWord);
}

LONG ReadPacketLong(struct IOExtSer *SerReadIO)
{
  LONG PktLong = -1;

  if (SerReadIO) {
    SerReadIO->IOSer.io_Command = CMD_READ;
    SerReadIO->IOSer.io_Length = sizeof(LONG);
    SerReadIO->IOSer.io_Data = (APTR)&PktLong;

    // To be changed to TimedIO() later on
    DoIO((struct IORequest *) SerReadIO);
  }

  return (PktLong);
}

BYTE *ReadPacketData(struct IOExtSer *SerReadIO, LONG Length)
{
  BYTE *PktData = NULL;

  if (SerReadIO && Length > 0) {
    if (PktData = (char *)AllocMem(Length, MEMF_PUBLIC)) {
      SerReadIO->IOSer.io_Command = CMD_READ;
      SerReadIO->IOSer.io_Length = Length;
      SerReadIO->IOSer.io_Data = (APTR)PktData;

      // To be changed to TimedIO() later on
      DoIO((struct IORequest *) SerReadIO);
    }
  }

  return (PktData);
}

int ReadPacket(struct IOExtSer *SerIO, struct LinkPkt **Pkt, UBYTE CurPktNum)
{
  UBYTE PktNum;
  ULONG CRC;
  int err = 0;

  if (*Pkt = ML_AllocPkt()) {
    PktNum = ReadPacketNum(SerIO);

    SerIO->IOSer.io_Command = CMD_READ;
    SerIO->IOSer.io_Length = (ULONG)&((*Pkt)->Data) - (ULONG)&((*Pkt)->Length);
    SerIO->IOSer.io_Data = &((*Pkt)->Length);
    DoIO((struct IORequest *) SerIO);

    (*Pkt)->Data = ReadPacketData(SerIO, (*Pkt)->Length);

    if (PktNum != CurPktNum)
      err = RPERR_PKTNUM;

    CRC = GetCRC((*Pkt)->Data, (*Pkt)->Length);

    if (CRC != (*Pkt)->CRC)
      err = RPERR_PKTCRC;
 
    if (err) {
      ML_FreePkt(*Pkt);
    }
  }
  else
    err = RPERR_NOPKT;

  return (err);
}

void WritePacket(struct IOExtSer *SerIO, struct LinkPkt *Pkt, UBYTE CurPktNum)
{
  UBYTE buf[2];

  if (SerIO && Pkt) {
    buf[0] = SOH;
    buf[1] = CurPktNum;

    Pkt->CRC = GetCRC(Pkt->Data, Pkt->Length);

    SerIO->IOSer.io_Command = CMD_WRITE;
    SerIO->IOSer.io_Length = 2 * sizeof(char);
    SerIO->IOSer.io_Data = (APTR)buf;
    DoIO((struct IORequest *) SerIO);

    SerIO->IOSer.io_Command = CMD_WRITE;
    SerIO->IOSer.io_Length = (ULONG)&(Pkt->Data) - (ULONG)&(Pkt->Length);
    SerIO->IOSer.io_Data = &(Pkt->Length);
    DoIO((struct IORequest *) SerIO);


    SerIO->IOSer.io_Command = CMD_WRITE;
    SerIO->IOSer.io_Length = Pkt->Length;
    SerIO->IOSer.io_Data = (APTR)Pkt->Data;
    DoIO((struct IORequest *) SerIO);
  }
}

void SendCode(struct IOExtSer *SerWriteIO,  BYTE Code, BYTE CurPktNum)
{
  UBYTE buf[2];

  if (SerWriteIO) {
    buf[0] = Code;
    buf[1] = CurPktNum;

    SerWriteIO->IOSer.io_Command = CMD_WRITE;
    SerWriteIO->IOSer.io_Data = (APTR)buf;
    if (CurPktNum < 0)
      SerWriteIO->IOSer.io_Length = 1;
    else
      SerWriteIO->IOSer.io_Length = 2;

    // To be changed to TimedIO() later on
    DoIO((struct IORequest *) SerWriteIO);
  }
}

void ResetTimer(struct timerequest *TimerIO)
{
  DoAbortIO((struct IORequest *) TimerIO);

  TimerIO->tr_node.io_Command = TR_ADDREQUEST;
  TimerIO->tr_time.tv_secs = 3;
  TimerIO->tr_time.tv_micro = 0;
  SendIO((struct IORequest *) TimerIO);
}


void SetTimer(struct timerequest *TimerIO)
{
  TimerIO->tr_node.io_Command = TR_ADDREQUEST;
  TimerIO->tr_time.tv_secs = 3;
  TimerIO->tr_time.tv_micro = 0;
  SendIO((struct IORequest *) TimerIO);
}

void __saveds __asm AckTask(register __d0 ULONG Len, register __a0 char *PortName)
{
  struct IOExtSer *SerIO;          // points to the SerIO req. that's passed to us
  struct IOExtSer *SerWriteIO;     // is used exclusively for writing to serial device
  struct IOExtSer *SerReadIO;      // is used exclusively for reading from serial device
  struct timerequest *TimerIO = NULL; // used for TIMEOUTs when waiting for ACK
  struct MsgPort *SerWriteMP;      // message port for SerWriteIO
  struct MsgPort *SerReadMP;       // message port for SerReadIO
  struct MsgPort *TimerMP = NULL;  // message port for TimerIO
  struct MsgPort *LinkMP;          // we get all our IO reqs through this port
  struct LinkPkt OutPkt;           // contents of packet to write to serial device
  struct LinkPkt *InPkt = NULL;    // points to packet just read from serial device
  struct List InPktList;           // list of packets read, but not yet sent to user
  struct IOExtLink *ReadReq = NULL;   // current user read IO request structure
  struct IOExtLink *WriteReq = NULL;  // current user write IO request structure
  struct IOExtLink *Req;           // next read/write IO request structure

  ULONG SerWriteBit, SerReadBit;   // signal bits for serial read/write
  ULONG TimerBit, PktBit;          // signal bits for timer and new LinkIO packet
  ULONG WaitMask, Sig = 0;         // Mask for Wait()

  int err;

  UBYTE CurInPktNum = 0;
  UBYTE CurOutPktNum = 0;
  UBYTE WaitACK = 0;
  UBYTE WaitPacket = 0;
  UBYTE ReadyToSend = 1;
  UBYTE PktType;


  NewList(&InPktList);

  if (LinkMP = CreateMsgPort()) {
    LinkMP->mp_Node.ln_Name = PortName;
    LinkMP->mp_Node.ln_Pri = 0;
    AddPort(LinkMP);

    WaitPort(LinkMP);
    Req = (struct IOExtLink *)GetMsg(LinkMP);
    SerIO = (struct IOExtSer *)Req->IOLink.io_Data;

    if (Req->IOLink.io_Device) {
      putreg(REG_A6, (long)Req->IOLink.io_Device); 
      geta4();
    }

    ReplyMsg((struct Message *)Req);

    if (OpenTimerDevice(&TimerMP, &TimerIO)) {

      Req = NULL;

      if (CloneIO((struct IORequest *)SerIO, &SerReadMP, (struct IORequest **)&SerReadIO)) {
        if (CloneIO((struct IORequest *)SerIO, &SerWriteMP, (struct IORequest **)&SerWriteIO)) {

          SerWriteBit = 1 << SerWriteMP->mp_SigBit;
          SerReadBit = 1 << SerReadMP->mp_SigBit;
          TimerBit = 1 << TimerMP->mp_SigBit;
          PktBit = 1 << LinkMP->mp_SigBit;

          WaitMask = SerWriteBit | SerReadBit | TimerBit | PktBit | SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D | SIGBREAKF_CTRL_E;

          SerReadIO->IOSer.io_Command = CMD_READ;
          SerReadIO->IOSer.io_Length = ID_LENGTH;
          SerReadIO->IOSer.io_Data = (APTR)&PktType;
          SendIO((struct IORequest *) SerReadIO);

          while (!(Sig & SIGBREAKF_CTRL_C)) {
            Sig = Wait(WaitMask);

            if (WaitACK && CheckIO((struct IORequest *) TimerIO)) {
              WaitIO((struct IORequest *) TimerIO);
              WritePacket(SerWriteIO, &OutPkt, CurOutPktNum);
              WaitACK = 1;
              ResetTimer(TimerIO);
            }

            if (CheckIO((struct IORequest *) SerReadIO)) {
              WaitIO((struct IORequest *) SerReadIO);
              // remember, PktType is set by io_Data above
              switch (PktType) {
                case SOH:
                  err = ReadPacket(SerReadIO, &InPkt, CurInPktNum);
                  if (!err) {
                    AddTail(&InPktList, (struct Node *)InPkt);
                    SendCode(SerWriteIO, ACK, CurInPktNum);
                    CurInPktNum ^= 1;
                  }
                  else if (err == RPERR_PKTNUM) 
                    SendCode(SerWriteIO, ACK, CurInPktNum ^ 1);
                  else
                    SendCode(SerWriteIO, GACK, -1);

                  if (WaitACK)
                    ResetTimer(TimerIO);

                  break;
                case ACK:
                  if (CurOutPktNum == ReadPacketNum(SerReadIO)) {
                    DoAbortIO((struct IORequest *) TimerIO);
                    CurOutPktNum ^= 1;
                    ReadyToSend = 1;
                    ML_ReplyMsg(WriteReq);
                    WriteReq = NULL;
                    WaitACK = 0;
                  }
                  break;
                case GACK:
                  WritePacket(SerWriteIO, &OutPkt, CurOutPktNum);
                  WaitACK = 1;
                  ResetTimer(TimerIO);
                  break;
                case ENQ:
                  SendCode(SerWriteIO, ACK, -1);
                  break;
                case CAN:
                  Signal(FindTask(NULL), SIGBREAKF_CTRL_C);
                  break;
              }
              SerReadIO->IOSer.io_Command = CMD_READ;
              SerReadIO->IOSer.io_Length = ID_LENGTH;
              SerReadIO->IOSer.io_Data = (APTR)&PktType;
              SendIO((struct IORequest *) SerReadIO);
            }

            /*
            ** Check for aborted requests...
            */
            if (Req && Req->IOLink.io_Error == IOERR_ABORTED) {
              ML_ReplyMsg(Req);
              Req = NULL;
            }

            if (ReadReq && ReadReq->IOLink.io_Error == IOERR_ABORTED) {
              ML_ReplyMsg(ReadReq);
              ReadReq = NULL;
              WaitPacket = 0;
            }

            /*
            ** Read incomming packets
            */
            if (!Req) {
              Req = ML_GetMsg(LinkMP, ML_PIPE1);
            }

            if (Req && !ReadReq &&
                (Req->IOLink.io_Command == MLCMD_READ ||
                Req->IOLink.io_Command == CMD_READ)) {
              ReadReq = Req;
              Req = ML_GetMsg(LinkMP, ML_PIPE1);
              WaitPacket = 1;
            }

            if (!WriteReq &&
                (Req && Req->IOLink.io_Command == MLCMD_WRITE ||
                Req && Req->IOLink.io_Command == CMD_WRITE)) {
              WriteReq = Req;
              Req = NULL;

              if (Req && Req->IOLink.io_Command == MLCMD_WRITE)
                CopyMem(WriteReq->IOLink.io_Data, &OutPkt, sizeof(struct LinkPkt));
              else {
                if (WriteReq->IOLink.io_Length < 0)
                  OutPkt.Length = strlen(WriteReq->IOLink.io_Data);
                else
                  OutPkt.Length = WriteReq->IOLink.io_Length;

                OutPkt.Data = WriteReq->IOLink.io_Data;
              }
            }

            /*
            ** If ready to send Pkt and out going packet exists, send it.
            */
            if (ReadyToSend && WriteReq) {
              WriteReq->Flags = WriteReq->Flags | ML_PIPE2;
              WritePacket(SerWriteIO, &OutPkt, CurOutPktNum);

              if (WaitACK)
                ResetTimer(TimerIO);
              else
                SetTimer(TimerIO);

              WaitACK = 1;
              ReadyToSend = 0;
            }

            /*
            ** If incomming Pkt is queued and we have Read req, reply it.
            */
            if (ReadReq && WaitPacket && !(IsListEmpty(&InPktList))) {
              InPkt = (struct LinkPkt *)RemHead(&InPktList);

              if (ReadReq->IOLink.io_Command == CMD_READ) {
                ReadReq->IOLink.io_Data = InPkt->Data;
                ReadReq->IOLink.io_Length = InPkt->Length;
                FreeMem(InPkt, sizeof (struct LinkPkt));
              }
              else
                ReadReq->IOLink.io_Data = InPkt;

              ML_ReplyMsg(ReadReq);
              InPkt = NULL;
              ReadReq = NULL;
              WaitPacket = 0;
            }

            /*
            ** Check CTRL-C -- shut down if CTRL-C detected.
            */
            if (Sig & SIGBREAKF_CTRL_C) {
              if (WaitACK)
                DoAbortIO((struct IORequest *) TimerIO);

              SendCode(SerWriteIO, CAN, EOT);

              if (WriteReq) {
                WriteReq->IOLink.io_Error = IOERR_ABORTED;
                ML_ReplyMsg(WriteReq);
              }

              if (ReadReq) {
                ReadReq->IOLink.io_Error = IOERR_ABORTED;
                ML_ReplyMsg(ReadReq);
              }
            }

            /*
            ** ^C or ^E arrives
            ** this continues the shut down process from above and since the
            ** CLEAR command issued by ^E does the same thing, they share
            ** the same code:
            ** deallocate all buffered incomming packets
            */
            if ((Sig & SIGBREAKF_CTRL_C) || (Sig & SIGBREAKF_CTRL_E)) {
              while (InPkt = (struct LinkPkt *)RemHead(&InPktList)) {
                FreeMem(InPkt->Data, InPkt->Length);
                FreeMem(InPkt, sizeof(struct LinkPkt));
              }
            }

            SerWriteIO->IOSer.io_Command = SDCMD_QUERY;
            DoIO((struct IORequest *) SerWriteIO);

            if (SerWriteIO->io_Status & (1 << 5))
              Signal(FindTask(NULL), SIGBREAKF_CTRL_C);
          }

          DeleteIO_MP(SerWriteMP, (struct IORequest *) SerWriteIO);
        }

        DoAbortIO((struct IORequest *) SerReadIO);
        DeleteIO_MP(SerReadMP, (struct IORequest *) SerReadIO);
      }

      if (WaitACK)
        DoAbortIO((struct IORequest *)TimerIO);
      SafeCloseDevice(TimerMP, (struct IORequest *)TimerIO);

    }

    /*
    ** remove all queued IO requests and remove MsgPort as well
    */
    Forbid();
    if (!Req) 
      Req = ML_GetMsg(LinkMP, ML_PIPE1);

    while (Req) {
      Req->IOLink.io_Error = IOERR_ABORTED;
      ML_ReplyMsg(Req);
      Req = ML_GetMsg(LinkMP, ML_PIPE1);
    }

    RemPort(LinkMP);
    DeleteMsgPort(LinkMP);
    Permit();
  }
}
