/***************************************
*  CONsole PUT STRING v1.01
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/functions.h>

void con_put_string( wreq, string )
  struct IOStdReq *wreq;
  UBYTE *string;
{
  long DoIO();  /* exec.library */

  wreq->io_Command = CMD_WRITE;
  wreq->io_Data    = (APTR)string;
  wreq->io_Length  = -1;  /* end when encounter NULL */
  DoIO( wreq );
}
