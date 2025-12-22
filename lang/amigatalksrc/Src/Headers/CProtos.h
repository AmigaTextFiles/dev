/****h* AmigaTalk/CProtos.h [1.5] **********************************
*
* NAME
*    CProtos.h
********************************************************************
*
*/

#ifndef  CONSOLEPROTOS_H
# define CONSOLEPROTOS_H 1

# ifndef EXEC_TYPES_H
#  include <exec/types.h>
# endif

# ifndef INTUITION_INTUITION_H
#  include <intuition/intuition.h>
# endif
 
# define  MAXLINE     81

/* ---------------------- struct definitions: ------------------------- */

struct   Console  {

   struct MsgPort  *WritePort;
   struct IOStdReq *WriteMsg;
   struct MsgPort  *ReadPort;
   struct IOStdReq *ReadMsg;
   char             readbuffer[ MAXLINE - 1 ];
};

/* -------------------- Function Protos: ------------------------------ */

IMPORT struct Console *AttachConsole( struct Window *window, char *name );

IMPORT void  ConDumps( struct Console *console, char *string );
IMPORT void  ConDumpc( struct Console *console, char ch );
IMPORT int   ConGetc(  struct Console *console );
IMPORT char *ConGets( struct Console *console );

IMPORT void DetachConsole( struct Console *console );

/* -------------------- Console defines: ------------------------------ */

# define  CON_WPORT   0X01
# define  CON_WMSG    0X02
# define  CON_RPORT   0X04
# define  CON_RMSG    0X08
# define  CON_DEVICE  0X10

#endif

/* ------------------- END of ConsoleProtos.h file! -------------------- */
