/***************************************
*  CONsole GRAPHIC RENDition v1.12
*  © Copyright Timm Martin
*  All Rights Reserved
****************************************/

#include <exec/io.h>
#include <exec/types.h>
#include <console/console.h>
#include <console/functions.h>

UBYTE gr__escdata[] = { CSI, '0', ';', '3', '1', ';', '4', '0', 'm' };
UBYTE gr__escstyl[] = { CSI, '1', 'm' };

void con_graphic_rend( wreq, style, foreground, background )
  struct IOStdReq *wreq;
  USHORT style, foreground, background;
{
  gr__escdata[4] = foreground % 10 + '0';
  gr__escdata[7] = background % 10 + '0';
  con_write( wreq, &gr__escdata[0], 9 );

  if (style & CON_BOLD) {
    gr__escstyl[1] = '1';
    con_write( wreq, &gr__escstyl[0], 3 );
  }
  if (style & CON_ITALIC) {
    gr__escstyl[1] = '3';
    con_write( wreq, &gr__escstyl[0], 3 );
  }
  if (style & CON_UNDERSCORE) {
    gr__escstyl[1] = '4';
    con_write( wreq, &gr__escstyl[0], 3 );
  }
  if (style & CON_INVERSE) {
    gr__escstyl[1] = '7';
    con_write( wreq, &gr__escstyl[0], 3 );
  }
}
