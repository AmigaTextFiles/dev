/***************************************
*  CURSOR PLACE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

void cursor_place( wreq, x, y )
  struct IOStdReq *wreq;
  int    x, y;
{
  con_left_offset( wreq, x );
  con_top_offset( wreq, y );
  cursor_pos( wreq, 1, 1 );
}
