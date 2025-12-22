/***************************************
*  CURSOR POSition v1.12
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cpos__escdata[] = { CSI, '1', '2', ';', '1', '2', 'H' };

void cursor_pos( wreq, row, col )
  struct IOStdReq *wreq;
  int    row, col;
{
  cpos__escdata[1] = row / 10 + '0';
  cpos__escdata[2] = row % 10 + '0';
  cpos__escdata[4] = col / 10 + '0';
  cpos__escdata[5] = col % 10 + '0';
  con_write( wreq, &cpos__escdata[0], 7 );
}
