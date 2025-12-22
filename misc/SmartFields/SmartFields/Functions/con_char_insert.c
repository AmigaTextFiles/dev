/***************************************
*  CONsole CHARacter INSERT v1.11
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE ci__escdata[] = { CSI, '@' };

void con_char_insert( wreq )
  struct IOStdReq *wreq;
{
  con_write( wreq, &ci__escdata[0], 2 );
}
