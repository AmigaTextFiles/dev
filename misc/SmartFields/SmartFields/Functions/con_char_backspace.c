/***************************************
*  CONsole CHARacter BACKSPACE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cb__escdata[] = { BACKSPACE_CODE, CSI, 'P' };

void con_char_backspace( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &cb__escdata[0], 3 );
}
