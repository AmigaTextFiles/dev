/***************************************
*  CONsole LINE NEXT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE ln__escdata[] = { CSI, 'E' };

void con_line_next( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &ln__escdata[0], 2 );
}
