/***************************************
*  CURSOR JUMP LEFT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cjl__escdata[] = { CSI, '1', '2', '3', 'D' };

void cursor_jump_left( wreq, positions )
  struct IOStdReq *wreq;
  int    positions;
{
  if (!positions) return;
  /* because will move left default of 1 position if positions==0 */

  cjl__escdata[1] = (positions / 100) + '0';
  cjl__escdata[2] = (positions / 10) % 10 + '0';
  cjl__escdata[3] = (positions % 10) + '0';
  con_write( wreq, &cjl__escdata[0], 5 );
}
