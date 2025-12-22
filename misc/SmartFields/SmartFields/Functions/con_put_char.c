/***************************************
*  CONsole PUT CHARacter v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/functions.h>

void con_put_char( wreq, character )
  struct IOStdReq *wreq;
  UBYTE  character;
{
  long DoIO();  /* exec.library */

  wreq->io_Command = CMD_WRITE;
  wreq->io_Data    = (APTR)&character;
  wreq->io_Length  = 1;
  DoIO( wreq );
}
