/***************************************
*  CONsole WRITE v1.11
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/functions.h>

void con_write( wreq, string, length )
  struct IOStdReq *wreq;
  UBYTE *string;
  int    length;
{
  long DoIO();  /* exec.library */

  wreq->io_Command = CMD_WRITE;
  wreq->io_Data    = (APTR)string;
  wreq->io_Length  = length;
  DoIO( wreq );
}
