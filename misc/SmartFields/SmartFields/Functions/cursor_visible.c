/***************************************
*  CURSOR VISIBLE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cvis__escdata[] = { CSI, 0x20, 0x70 };

void cursor_visible( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &cvis__escdata[0], 3 );
}
