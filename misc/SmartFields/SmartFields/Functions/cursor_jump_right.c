/***************************************
*  CURSOR JUMP RIGHT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cjr__escdata[] = { CSI, '1', '2', '3', 'C' };

void cursor_jump_right( wreq, positions )
  struct IOStdReq *wreq;
  int    positions;
{
  if (!positions) return;
  /* because will move right default 1 position if positions==0 */

  cjr__escdata[1] = (positions / 100) + '0';
  cjr__escdata[2] = (positions / 10) % 10 + '0';
  cjr__escdata[3] = (positions % 10) + '0';
  con_write( wreq, &cjr__escdata[0], 5 );
}
