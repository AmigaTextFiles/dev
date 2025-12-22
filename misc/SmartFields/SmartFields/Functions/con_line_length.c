/***************************************
*  CONsole LINE LENGTH v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cll__escdata[] = { CSI, '1', '2', '3', 'u' };

void con_line_length( wreq, length )
  struct IOStdReq *wreq;
  int    length;
{
  cll__escdata[1] = (length / 100) + '0';
  cll__escdata[2] = (length / 10) % 10 + '0';
  cll__escdata[3] = (length % 10) + '0';
  con_write( wreq, &cll__escdata[0], 5 );
}
