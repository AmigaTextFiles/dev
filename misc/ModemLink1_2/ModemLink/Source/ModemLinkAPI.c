/*
** NAME: ModemLinkAPI.c
** DESC: These routines provide a standard device like interface, yet should
**       never be used when dealing with the actual device.  Since modemlink
**       can be compiled as a linked lib as well, these routines are necessary
**       to allow for an identical API as the standard device interface.  Only
**       use these when using the linked lib version of modemlink (use
**       exec.library routines when using the device).
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  13 Mar 1997 Created
*/


#include <exec/io.h>
#include <exec/ports.h>
#include <exec/nodes.h>
#include <dos/dos.h>

#include <proto/exec.h>

#include <stdio.h>

#include "ModemLinkAPI.h"
#include "Link.h"

BYTE ML_DoIO(struct IORequest *IOReq)
{
  IOReq->io_Flags |= IOF_QUICK;
  ML_BeginIO(IOReq);
  WaitIO(IOReq);

  return IOReq->io_Error;
}

void ML_SendIO(struct IORequest *IOReq)
{
  IOReq->io_Flags = 0;
  ML_BeginIO(IOReq);
}
