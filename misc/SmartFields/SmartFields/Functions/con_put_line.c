/***************************************
*  CONsole PUT LINE v1.11
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/functions.h>

void con_put_line( wreq, string, max )
  struct IOStdReq *wreq;
  UBYTE *string;
  int   max;
{
  UBYTE c;       /* to store replaced character */
  UBYTE *cp;     /* points to where string should end */
  long  DoIO();  /* exec.library */

  cp  = string + max;        /* find where string should end */
  c   = *cp;                 /* store character at that position */
  *cp = '\0';                /* replace with NULL to guarantee end */

  wreq->io_Command = CMD_WRITE;
  wreq->io_Data    = (APTR)string;
  wreq->io_Length  = -1;     /* end when encounter NULL */
  DoIO( wreq );

  *cp = c;                   /* replace NULL with character */
}
