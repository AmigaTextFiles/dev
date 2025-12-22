/***************************************
*  CONsole LINE SCROLL DOWN v1.1
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE lsd__escdata[] = { CSI, 'T' };

void con_line_scroll_down( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &lsd__escdata[0], 2 );
}
