/***************************************
*  CONsole CHARacter DELETE v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cd__escdata[] = { CSI, 'P' };

void con_char_delete( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &cd__escdata[0], 2 );
}
