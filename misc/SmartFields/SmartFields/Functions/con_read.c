/***************************************
*  CONsole READ v1.01
*  © Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

ULONG con_read( rreq, input_buffer )
  struct IOStdReq *rreq;
  UBYTE *input_buffer;
{
  void SendIO();  /* exec.library */

  rreq->io_Command = CMD_READ;
  rreq->io_Data    = (APTR)input_buffer;
  rreq->io_Length  = CONSOLE_BUFFER_SIZE;
  /* the buffer should be declared to be at least CONSOLE_BUFFER_SIZE */
  SendIO( rreq );

  return (rreq->io_Actual);
}
