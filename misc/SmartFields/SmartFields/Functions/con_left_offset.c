/***************************************
*  CONsole LEFT OFFSET v1.11
*  © Copyright 1988 Software Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE clo__escdata[] = { CSI, '1', '2', '3', 'x' };

void con_left_offset( wreq, x )
  struct IOStdReq *wreq;
  int    x;
{
  clo__escdata[1] = (x / 100) + '0';
  clo__escdata[2] = (x / 10) % 10 + '0';
  clo__escdata[3] = (x % 10) + '0';
  con_write( wreq, &clo__escdata[0], 5 );
}
