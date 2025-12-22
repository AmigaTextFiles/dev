/***************************************
*  CONsole DISPLAY ERASE v1.11
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE de__escdata[] = { CSI, 'J' };

void con_display_erase( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &de__escdata[0], 2 );
}
