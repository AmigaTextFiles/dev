/***************************************
*  CONsole LINE ERASE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE le__escdata[] = { CSI, 'K' };

void con_line_erase( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &le__escdata[0], 2 );
}
