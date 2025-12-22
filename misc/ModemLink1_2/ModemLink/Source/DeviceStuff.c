/*
** NAME: DeviceStuff.c
** DESC: Routines which make dealing with devices a little easier.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  06 Apr 1997 Created
*/

#include "DeviceStuff.h"

#include <exec/types.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <devices/serial.h>
#include <devices/timer.h>

#include <proto/exec.h>

#include <stdio.h>

int OpenTimerDevice(struct MsgPort **TimerMP, struct timerequest **TimerIO)
{
  if (*TimerMP = CreateMsgPort()) {
    if (*TimerIO = CreateIORequest(*TimerMP, sizeof(struct timerequest))) {
      if (!OpenDevice(TIMERNAME, UNIT_VBLANK, (struct IORequest *)*TimerIO, 0))
        return(1);
      DeleteIORequest((struct IORequest *) *TimerIO);
    }
    DeleteMsgPort(*TimerMP);
  }

  return(0);
}

int OpenSerialDevice(struct MsgPort **SerMP, struct IOExtSer **SerIO, char *SerName, LONG Unit)
{
  ULONG err;

  if (*SerMP = CreateMsgPort()) {
    if (*SerIO = CreateIORequest(*SerMP, sizeof(struct IOExtSer))) {
      (*SerIO)->io_SerFlags = SERF_SHARED;
      err = OpenDevice(SerName, Unit, (struct IORequest *)*SerIO, 0L);
      if (!err)
        return(1);
      DeleteIORequest((struct IORequest *) *SerIO);
    }
    DeleteMsgPort(*SerMP);
  }

  return(0);
}

int TimedIO(struct IORequest *IOReq, int TimeOut)
{
  struct timerequest *TimerIO = NULL;
  struct MsgPort *TimerMP = NULL;
  ULONG IOBit, TimerBit;
  int ReturnCode = NULL;

  if (IOReq && OpenTimerDevice(&TimerMP, &TimerIO)) {
    IOBit = 1 << IOReq->io_Message.mn_ReplyPort->mp_SigBit;
    TimerBit = 1 << TimerMP->mp_SigBit;

    TimerIO->tr_node.io_Command = TR_ADDREQUEST;
    TimerIO->tr_time.tv_secs = TimeOut;
    TimerIO->tr_time.tv_micro = 0;

    SendIO((struct IORequest *) TimerIO);
    SendIO(IOReq);

    for (;;) {
      Wait(IOBit | TimerBit);

      if (CheckIO(IOReq)) {
        ReturnCode = 1;
        break;
      }

      if (CheckIO((struct IORequest *)TimerIO))
        break;
    }
    DoAbortIO(IOReq);
    DoAbortIO((struct IORequest *)TimerIO);

    SafeCloseDevice(TimerMP, (struct IORequest *)TimerIO);
  }

  return(ReturnCode);
}

void DoAbortIO(struct IORequest *IO)
{
  if (CheckIO(IO) == 0)
    AbortIO(IO);
  WaitIO(IO);
}

void SafeCloseDevice(struct MsgPort *MP, struct IORequest *IO)
{
  if (IO) {
    CloseDevice(IO);
    DeleteIORequest(IO);
  }

  if (MP)
    DeleteMsgPort(MP);
}

int CloneIO(struct IORequest *IO, struct MsgPort **NewMP, struct IORequest **NewIO)
{
  if (IO && NewMP && NewIO) {
    if (*NewMP = CreateMsgPort()) {
      if (*NewIO = CreateIORequest(*NewMP, IO->io_Message.mn_Length)) {
        CopyMem(IO, *NewIO, IO->io_Message.mn_Length);
        (*NewIO)->io_Message.mn_ReplyPort = *NewMP;
        return(1);
      }
      DeleteMsgPort(*NewMP);
    }
  }

  *NewMP = NULL;
  *NewIO = NULL;

  return(0);
}

void DeleteIO_MP(struct MsgPort *MP, struct IORequest *IO)
{
  if (IO)
    DeleteIORequest(IO);

  if (MP)
    DeleteMsgPort(MP);
}
