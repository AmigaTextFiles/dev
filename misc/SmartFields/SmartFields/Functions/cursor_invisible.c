/***************************************
*  CURSOR INVISIBLE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cinvis__escdata[] = { CSI, 0x30, 0x20, 0x70 };

void cursor_invisible( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &cinvis__escdata[0], 4 );
}
