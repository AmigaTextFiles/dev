#ifndef RESOURCES_SERIAL_H
#define RESOURCES_SERIAL_H 1

/*$Id: serial.h,v 1.0 1993/03/22 09:16:30 wjm Exp $*/
/****************************************************************************
*                                                                           *
*     NAME                                                                  *
*        serial.h                                                           *
*                                                                           *
*     FUNCTION                                                              *
*        This file contains structures and defines used by a number of      *
*        modules who have dealings with serial ports.  The modules who      *
*        would import this file are:                                        *
*           - A resource who arbitrates access to the serial hardware.      *
*           - A serial device.                                              *
*           - A debug.library.                                              *
*                                                                           *
*        Everybody else goes through the serial device and hence should     *
*        have no interest whatsoever in this file.                          *
*                                                                           *
*     HISTORY                                                               *
*        WJM  18Mar93 - Created.                                            *
*                                                                           *
****************************************************************************/
#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif


/* A structure for collecting serial port parameters commonly of concern. */

struct SerialSettings
   {
   ULONG baud;                      /* baud rate */
   char  parity;                    /* 'N', 'E' or 'O' */
   UBYTE length;                    /* character length */
   UBYTE stop;                      /* stopbits */
   UBYTE pad;
   BOOL  handshake;                 /* ON means use RTS/CTS handshaking */
   BOOL  tx_enable;                 /* TRUE means enable transmission */
   BOOL  tx_ienable;                /* TRUE means enable transmit interrupts */
   BOOL  rx_enable;                 /* TRUE means enable reception */
   BOOL  rx_ienable;                /* TRUE means enable receive interrupts */
   };

#endif
