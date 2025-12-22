/***************************************
*  CURSOR LEFT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cl__escdata[] = { CSI, 'D' };

void cursor_left( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &cl__escdata[0], 2 );
}
