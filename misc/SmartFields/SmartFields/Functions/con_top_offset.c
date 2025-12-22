/***************************************
*  CONsole TOP OFFSET v1.11
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cto__escdata[] = { CSI, '1', '2', '3', 'y' };

void con_top_offset( wreq, y )
  struct IOStdReq *wreq;
  int    y;
{
  cto__escdata[1] = (y / 100) + '0';
  cto__escdata[2] = (y / 10) % 10 + '0';
  cto__escdata[3] = (y % 10) + '0';
  con_write( wreq, &cto__escdata[0], 5 );
}
