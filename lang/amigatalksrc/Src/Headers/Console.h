/****h* AmigaTalk/Console.h [1.5] ***********************************
*
* NAME
*    Console.h
*
* LAST CHANGED:  09-Apr-2000
*
*********************************************************************
*
*/

#ifndef  CONSOLE_H
# define CONSOLE_H 1

# ifndef EXEC_TYPES_H
#  include <exec/types.h>
# endif

# define  MAXLINE  81

/* ---------------------- struct definitions: ------------------------- */

struct   Console  {

   struct MsgPort  *WritePort;
   struct IOStdReq *WriteMsg;
   struct MsgPort  *ReadPort;
   struct IOStdReq *ReadMsg;
   struct Window   *ConWindow;
   char             readbuffer[ MAXLINE - 1 ];
};

/* -------------------- Function Protos: ------------------------------ */

IMPORT struct Console *AttachConsole( struct Window *window, char *name );

IMPORT void ConDumps( struct Console *console, char *string );
IMPORT void ConDumpc( struct Console *console, char ch );
IMPORT int  ConGetc(  struct Console *console );
IMPORT char *ConGets( struct Console *console );

IMPORT void DetachConsole( struct Console *console );

/* -------------------- Console defines: ------------------------------ */

# define  CON_WPORT   0X01
# define  CON_WMSG    0X02
# define  CON_RPORT   0X04
# define  CON_RMSG    0X08
# define  CON_DEVICE  0X10

#endif

/* --------------------- END of Console.h file! ----------------------- */
