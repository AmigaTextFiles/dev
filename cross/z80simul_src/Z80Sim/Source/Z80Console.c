/****h* Z80Simulator/Z80Console.c [2.0] *************************
*
* NAME
*    Z80CONSOLE.c
*
* DESCRIPTION
*    The console I/O functions.
*
* LAST CHANGED:  03/04/94 - Added Z80FuncProtos.h
*****************************************************************
*
*/

#define  Z80CONSOLE_C   1

#include <ctype.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <libraries/dosextens.h>

#include <intuition/intuitionbase.h>

#include <clib/exec_protos.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Z80Sim.h"
#include "Z80FuncProtos.h"

//extern struct  MsgPort    *CreatePort();
//extern struct  IOStdReq   *CreateStdIO();


PUBLIC struct Console *AttachConsole( struct Window *window, char *name )
{
   static   char    *string, nill[40];
   register UBYTE    con_flags = 0;
   struct   Console *console;
   int               consize, error;

   string = &nill[0];
   consize = sizeof( struct Console );

   if ((console = (struct Console *) malloc( consize )) == 0)  
      {
      if (Handle_Problem( "malloc() in AttachConsole",
                              "returned a zero", NULL ) == TRUE)
         goto error_exit;
      }

   string = strcpy( string, name );
   string = strcat( string, ".write" );

   if ((console->WritePort = CreatePort( string, 0L )) == 0)   
      {
      if (Handle_Problem( "CreatePort() in AttachConsole",
                              "returned a zero", NULL ) == TRUE)
         goto error_exit;
      }

   con_flags |= CON_WPORT;

   if ((console->WriteMsg = CreateStdIO( console->WritePort )) == 0)   
      {
      if (Handle_Problem( "CreateStdIO() in AttachConsole",
                              "returned a zero", NULL ) == TRUE)
         goto error_exit;
      }
   con_flags |= CON_WMSG;
                                      /* Console Read stuff! */
   string = strcpy( string, name );
   string = strcat( string, ".read" );

   if ((console->ReadPort = CreatePort( string, 0L )) == 0)   
      {
      if (Handle_Problem( "CreatePort() in AttachConsole",
                              "returned a zero", NULL ) == TRUE)
         goto error_exit;
      }

   con_flags |= CON_RPORT;

   if ((console->ReadMsg = CreateStdIO( console->ReadPort )) == 0)   
      {
      if (Handle_Problem( "CreateStdIO() in AttachConsole",
                              "returned a zero", NULL ) == TRUE)
         goto error_exit;
      }
   con_flags                   |= CON_RMSG;

   console->WriteMsg->io_Data   = (APTR) window;
   console->WriteMsg->io_Length = sizeof( *window );

   if ((error = OpenDevice( "console.device",0,console->WriteMsg,0)) != 0)
      {
      if (Handle_Problem( "OpenDevice() in AttachConsole",
                              "returned a zero", NULL ) == TRUE)
         goto error_exit;
      }

   console->ReadMsg->io_Device = console->WriteMsg->io_Device;
   console->ReadMsg->io_Unit   = console->WriteMsg->io_Unit;
   console->ReadMsg->io_Command = CMD_READ;
   console->ReadMsg->io_Data = (APTR) &console->readbuffer[0];
   console->ReadMsg->io_Length = 1;

   SendIO( console->ReadMsg );

   return( console );

error_exit:

   if (con_flags & CON_RMSG)    DeleteStdIO( console->ReadMsg );
   if (con_flags & CON_RPORT)   DeletePort(  console->ReadPort );
   if (con_flags & CON_WMSG)    DeleteStdIO( console->WriteMsg );
   if (con_flags & CON_WPORT)   DeletePort(  console->WritePort );

   return( NULL );
}

PUBLIC void ConDumps( struct Console *console, char *string )
{
   console->WriteMsg->io_Command = CMD_WRITE;
   console->WriteMsg->io_Data    = (APTR) string;
   console->WriteMsg->io_Length  = strlen( string );

   DoIO( console->WriteMsg );
   
   return;
}

PUBLIC void ConDumpc( struct Console *console, char ch )
{
   console->WriteMsg->io_Command = CMD_WRITE;
   console->WriteMsg->io_Data    = (APTR) &ch;
   console->WriteMsg->io_Length  = 1;

   DoIO( console->WriteMsg );

   return;
}

PUBLIC int ConGetc( struct Console *console )
{
   struct   IOStdReq    *msg;
   int      temp;

   while ((long) (msg = (struct IOStdReq *)
                        GetMsg( console->ReadPort )) == NULL)
      WaitPort( console->ReadPort );

   temp  = console->readbuffer[0];
   temp &= 0xFF;

   console->ReadMsg->io_Command = CMD_READ;
   console->ReadMsg->io_Data    = (APTR) &console->readbuffer[0];
   console->ReadMsg->io_Length  = 1;

   SendIO( console->ReadMsg );

   ConDumpc( console, temp );

   return( temp );
}

PUBLIC void DetachConsole( struct Console *console )
{
   CloseDevice( console->WriteMsg );
   DeleteStdIO( console->ReadMsg );
   DeletePort(  console->ReadPort );
   DeleteStdIO( console->WriteMsg );
   DeletePort(  console->WritePort );

   free( console );

   return;
}

/* -------------------- End of Z80Console.c ---------------------- */
