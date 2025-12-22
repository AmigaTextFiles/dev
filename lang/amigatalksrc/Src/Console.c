/****h* AmigaTalk/Console.c [3.0] *************************************
*
* NAME
*    Console.c
*
* DESCRIPTION
*    The console I/O functions.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* TODO
*    This whole file will have to be re-done so that RawKeys are
*    decoded correctly.
*
* NOTES
*    $VER: AmigaTalk:Src/Console.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <AmigaDOSErrs.h>

#include <libraries/dosextens.h>

#include <intuition/intuitionbase.h>

#include <clib/alib_protos.h>

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/dos.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;

IMPORT struct ExecIFace   *IExec;
IMPORT struct DOSIFace    *IDOS;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Console.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

//IMPORT struct MsgPort  *CreatePort();
//IMPORT struct IOStdReq *CreateStdIO();

IMPORT UBYTE *AllocProblem;

PUBLIC UBYTE *ConsProblem = NULL; // Visible to CatalogConsole();

/* ------------------- Console Routines: ------------------------------ */

/****h* AttachConsole() [1.5] **************************************
*
* NAME
*    AttachConsole()
*
* DESCRIPTION
*    Add a Console device to the given Window struct.
********************************************************************
*
*/

PUBLIC struct Console *AttachConsole( struct Window *window, char *name )
{
   static   char  nill[40], *string = &nill[0];

   int      consize, error;
   register UBYTE    con_flags = 0;
   struct   Console  *console;

   if (!window) // == NULL)
      goto error_exit;

   consize = sizeof( struct Console );

   if (!(console = (struct Console *) AT_calloc( 1, consize, "Console", TRUE ))) // == 0)  
      {
      MemoryOut( ConCMsg( MSG_CN_ATTACH_FUNC_CON ) );

      goto error_exit;
      }

   console->ConWindow = window;
   StringCopy( string, name );
   StringCat(  string, ".write" ); // CN_DOT_WRITE );

   if (!(console->WritePort = CreatePort( string, 0L ))) // == 0)
      {
      CannotCreatePort( ConCMsg( MSG_CN_CONSOLECLASSNAME_CON ) );

      goto error_exit;
      }

   con_flags |= CON_WPORT;

   if (!(console->WriteMsg = (struct IOStdReq *) CreateStdIO( console->WritePort ))) // == 0)   
      {
      CannotCreateStdIO( ConCMsg( MSG_CN_CONSOLECLASSNAME_CON ) );

      goto error_exit;
      }

   con_flags |= CON_WMSG;
                                      /* Console Read stuff! */
   StringCopy( string, name );
   StringCat(  string, ".read" ); // CN_DOT_READ );

   if (!(console->ReadPort = CreatePort( string, 0L ))) // == 0)   
      {
      CannotCreatePort( ConCMsg( MSG_CN_CONSOLECLASSNAME_CON ) );

      goto error_exit;
      }

   con_flags |= CON_RPORT;

   if (!(console->ReadMsg = (struct IOStdReq *) CreateStdIO( console->ReadPort ))) // == 0)   
      {
      CannotCreateStdIO( ConCMsg( MSG_CN_CONSOLECLASSNAME_CON ) );

      goto error_exit;
      }

   con_flags |= CON_RMSG;

   console->WriteMsg->io_Data   = (APTR) window;
   console->WriteMsg->io_Length = sizeof( *window );

   if ((error = OpenDevice( "console.device", 0, (struct IORequest *) console->WriteMsg, 0 )) != 0) // CN_CONSOLE_DEV
      {
      CannotOpenDevice( "console.device" );

      goto error_exit;
      }

   console->ReadMsg->io_Device  = console->WriteMsg->io_Device;
   console->ReadMsg->io_Unit    = console->WriteMsg->io_Unit;

   console->ReadMsg->io_Command = CMD_READ;
   console->ReadMsg->io_Data    = (APTR) &console->readbuffer[0];
   console->ReadMsg->io_Length  = 1;

   SendIO( (struct IORequest *) console->ReadMsg ); // ???????????????

   return( console );

error_exit:

   if (con_flags & CON_RMSG)    
      DeleteStdIO( console->ReadMsg );
   
   if (con_flags & CON_RPORT)   
      DeletePort(  console->ReadPort );
   
   if (con_flags & CON_WMSG)    
      DeleteStdIO( console->WriteMsg );
   
   if (con_flags & CON_WPORT)   
      DeletePort(  console->WritePort );

   return( NULL );
}

/****h* ConDumps() [1.5] *******************************************
*
* NAME
*    ConDumps()
*
* DESCRIPTION
*    Write a string to the given Console.
********************************************************************
*
*/

PUBLIC void ConDumps( struct Console *console, char *string )
{
   Forbid(); // No interruptions, please!

      console->WriteMsg->io_Command = CMD_WRITE;
      console->WriteMsg->io_Data    = (APTR) string;
      console->WriteMsg->io_Length  = StringLength( string );

      DoIO( (struct IORequest *) console->WriteMsg );
   
   Permit();
   
   return;
}

/****h* ConDumpc() [1.5] *******************************************
*
* NAME
*    ConDumpc()
*
* DESCRIPTION
*    Write a character to the given Console.
********************************************************************
*
*/

PUBLIC void ConDumpc( struct Console *console, char ch )
{
   Forbid(); // No interruptions, please!

      console->WriteMsg->io_Command = CMD_WRITE;
      console->WriteMsg->io_Data    = (APTR) &ch;
      console->WriteMsg->io_Length  = 1;

      DoIO( (struct IORequest *) console->WriteMsg );

   Permit();

   return;
}

/****h* ConGetc() [1.5] ********************************************
*
* NAME
*    ConGetc()
*
* DESCRIPTION
*    Get a character from the given Console.
********************************************************************
*
*/

PUBLIC int ConGetc( struct Console *console )
{
   struct IOStdReq *msg;
   int              temp;

   console->ReadMsg->io_Command = CMD_READ;
   console->ReadMsg->io_Data    = (APTR) &console->readbuffer[0];
   console->ReadMsg->io_Length  = 1;

   SendIO( (struct IORequest *) console->ReadMsg );

   while (!(long) (msg = (struct IOStdReq *)
                         GetMsg( console->ReadPort ))) // == NULL)
      WaitPort( console->ReadPort );

   temp  = console->readbuffer[0];
   temp &= 0xFF;

   if (temp == RETURN_CHAR)   // convert Carriage Returns into newlines!
      temp = NEWLINE_CHAR;

   ConDumpc( console, temp ); // Echo the character.

   return( temp );
}

/****i* search() [1.0] *********************************************
*
* NAME
*    search()
*
* DESCRIPTION
*    Find the given character in the given buffer.
********************************************************************
*
*/

PRIVATE int search( char *buffer, char ch )
{
   int i = 0, len;
   
   len = StringLength( buffer );

   while (i < len)
      {
      if (buffer[i] == ch)
         return( i );

      i++;
      }

   return( 0 );
}

/****i* CheckForFKeys() [1.0] **************************************
*
* NAME
*    CheckForFKeys()
*
* DESCRIPTION
*    See if the buffer has a Function key in it.
********************************************************************
*
*/

PRIVATE BOOL CheckForFKeys( char *buff )
{
   if ((0xFF & buff[0]) == 0x9B)
      {
      if (search( buff, TILDE_CHAR ) > 0)
         return( TRUE );
      }
   else 
      return( FALSE );
}

PRIVATE char  nil[128];

char         *strbuff = &nil[0];

/****h* ConGets() [1.5] ********************************************
*
* NAME
*    ConGets()
*
* DESCRIPTION
*    Get a string from the given Console.
********************************************************************
*
*/

PUBLIC char *ConGets( struct Console *console )
{
   int   i  = 0, j, len;
   int   ch = 0, chk = 0;

   len = StringLength( strbuff );   

   if (len > 0)
      {
      for (j = 0; j < len; j++)  // Reset buffer to '\0's!
         strbuff[j] = NIL_CHAR; 
      }

   while (ch != NEWLINE_CHAR)
      {
      ch           = ConGetc( console );
      strbuff[i++] = ch;

      if (i > 2)
         chk = CheckForFKeys( strbuff ); // This no longer works!

      if (chk > 0)
         break;

      if (i >= 128)
         break;
      }

   return( strbuff );   // <ENTER> or <CR> will terminate ConGets().
}

/****h* DetachConsole() [1.5] **************************************
*
* NAME
*    DetachConsole()
*
* DESCRIPTION
*    Remove the given Console from the program.
********************************************************************
*
*/

PUBLIC void DetachConsole( struct Console *console )
{
   CloseDevice( (struct IORequest *) console->WriteMsg );

   DeleteStdIO( console->ReadMsg );
   DeletePort(  console->ReadPort );

   DeleteStdIO( console->WriteMsg );
   DeletePort(  console->WritePort );

   AT_free( console, "Console", TRUE );
   
   return;
}

/* -------------------- End of Console.c ---------------------- */
