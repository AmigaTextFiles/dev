/*******************************************
*  CONsole CHARacter MULTiple DELETE v1.11
*  © Copyright 1988 Software Timm Martin
*  All Rights Reserved
********************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE cmd__escdata[] = { CSI, '1', '2', '3', 'P' };

void con_char_mult_delete( wreq, chars )
  struct IOStdReq *wreq;
  int    chars;
{
  cmd__escdata[1] = (chars / 100) + '0';
  cmd__escdata[2] = (chars / 10) % 10 + '0';
  cmd__escdata[3] = (chars % 10) + '0';
  con_write( wreq, &cmd__escdata[0], 5 );
}
