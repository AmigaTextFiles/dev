/***************************************
*  CONsole LINE PREVious v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE lp__escdata[] = { CSI, 'F' };

void con_line_prev( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &lp__escdata[0], 2 );
}
