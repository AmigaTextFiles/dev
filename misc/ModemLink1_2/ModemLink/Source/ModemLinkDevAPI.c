/*
** NAME: ModemLinkDevAPI.c
** DESC: This file contains the two basic parts to any device, BeginIO and
**       AbortIO.  These get linked into both the device and linked lib
**       verisons.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  23 Mar 1997 Created
*/


#include <exec/errors.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <exec/nodes.h>
#include <dos/dos.h>

#include <proto/exec.h>

#include <stdio.h>

#include "ModemLinkAPI.h"
#include "Link.h"

void __saveds __asm ML_BeginIO(register __a1 struct IORequest *IOReq)
{
  struct IOExtLink *LinkIO;
  struct MsgPort *LinkPort;

  if (LinkIO = (struct IOExtLink *)IOReq) {
    IOReq->io_Flags &= ~IOF_QUICK;
    IOReq->io_Error = LinkErr_OK;

    switch (IOReq->io_Command) {
      case CMD_READ:
      case MLCMD_READ:
        Forbid();

        LinkIO->Flags = (LinkIO->Flags & ~ML_PIPE2) | ML_PIPE0;
        if (LinkPort = FindPort(LinkIO->LinkPortName))
          PutMsg(LinkPort, (struct Message *)LinkIO);
        else {
          IOReq->io_Error = LinkErr_NOPROC;
          ML_ReplyMsg(LinkIO);
        }

        Permit();

        break;
      case CMD_WRITE:
      case MLCMD_WRITE:
        Forbid();

        LinkIO->Flags = (LinkIO->Flags & ~ML_PIPE2) | ML_PIPE0;
        if (LinkPort = FindPort(LinkIO->LinkPortName))
          PutMsg(LinkPort, (struct Message *)LinkIO);
        else {
          IOReq->io_Error = LinkErr_NOPROC;
          ML_ReplyMsg(LinkIO);
        }

        Permit();

        break;
      case CMD_CLEAR:
        Forbid();

        if (FindTask(LinkIO->LinkProcName))
          Signal(FindTask(LinkIO->LinkProcName), SIGBREAKF_CTRL_E);
        else
          IOReq->io_Error = LinkErr_NOPROC;

        Permit();
        ML_ReplyMsg(LinkIO);
        break;
      case MLCMD_QUERY:
        if (!FindPort(LinkIO->LinkPortName))
          IOReq->io_Error = LinkErr_NOPROC;
        else
          IOReq->io_Error = LinkErr_OK;

        ML_ReplyMsg(LinkIO);
        break;
      case MLCMD_INIT:
        Forbid();

        if (LinkPort = FindPort(LinkIO->LinkPortName))
          PutMsg(LinkPort, (struct Message *)LinkIO);
        else {
          IOReq->io_Error = LinkErr_NOPROC;
          ML_ReplyMsg(LinkIO);
        }

        Permit();

        break;
    }
  }
}

void __saveds __asm ML_AbortIO(register __a1 struct IORequest *IOReq)
{
  struct IOExtLink *LinkIO;
  struct Task *LinkProc;

  if (LinkIO = (struct IOExtLink *)IOReq) {
    IOReq->io_Error = IOERR_ABORTED;

    Forbid();

    if ((LinkIO->Flags & ML_PIPE2) == ML_PIPE0) {
      Remove((struct Node *)LinkIO);
      ML_ReplyMsg(LinkIO);
    }

    if (LinkProc = FindTask(LinkIO->LinkProcName))
      Signal(LinkProc, SIGBREAKF_CTRL_D);
    else
      ML_ReplyMsg(LinkIO);

    Permit();

  }
}
