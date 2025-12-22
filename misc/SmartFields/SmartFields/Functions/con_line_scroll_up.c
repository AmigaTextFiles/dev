/***************************************
*  CONsole LINE SCROLL UP v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE lsu__escdata[] = { CSI, 'S' };

void con_line_scroll_up( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &lsu__escdata[0], 2 );
}
