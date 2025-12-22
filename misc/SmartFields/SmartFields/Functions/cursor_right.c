/***************************************
*  CURSOR RIGHT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cr__escdata[] = { CSI, 'C' };

void cursor_right( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &cr__escdata[0], 2 );
}
