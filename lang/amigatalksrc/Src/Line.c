/****h* AmigaTalk/Line.c [3.0] ***********************************
*
* NAME
*    Line.c
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/Line.c 3.0 (25-Oct-2004) by J.T Steichen
*
*    IMPORT int AmigaLoop( char *buffer ); // in main.c file.
*
* DESCRIPTION
*    line grabber - does lowest level input for command lines.
******************************************************************
*
*/

#include <stdio.h>
#include <string.h>

/* #include <stdlib.h> */

#include <exec/types.h>
#include <exec/ports.h>
#include <AmigaDOSErrs.h>

#include <dos/dos.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/alib_protos.h>

#else

# define __USE_INLINE__
# include <proto/exec.h>

#endif

#include "object.h"
#include "FuncProtos.h"

#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "CantHappen.h"

IMPORT OBJECT *o_tab;
IMPORT int     inisstd; // In Global.c where all good globals are.
IMPORT char    outmsg[];

PRIVATE FILE *fdstack[ MAXINCLUDE ] = { NULL, };
PRIVATE int   fdtop    = -1;

#define  EMPTY  0
#define  HALF   1
#define  FILLED 2

PRIVATE int bufstate = EMPTY;

/****h* set_file() [1.7] *********************************************
*
* NAME
*    set_file()
*
* DESCRIPTION
*    Set a file on the file descriptor stack
**********************************************************************
*
*/

PUBLIC void set_file( FILE *fd )
{
   if ((++fdtop) > MAXINCLUDE)
      cant_happen( INTERNAL_BUFF_OVF );       // Die, you abomination!!

   fdstack[ fdtop ] = fd;

   if (fd == stdin) 
      inisstd = TRUE;
   else 
      inisstd = FALSE;

   return;
}

/****h* line_grabber() [1.7] *****************************************
*
* NAME
*    line_grabber()
*
* RETURNS
*    -1 = Error condition.
*     0 = block was FALSE or bufstate == FILLED == FALSE.
*     1 = bufstate == FILLED == TRUE.
*
* DESCRIPTION
*    Read a line of text, do blocked i/o if block is nonzero, 
*    otherwise do non-blocking i/o. 
**********************************************************************
*
*/

PUBLIC int line_grabber( int block, char *inbuff )
{
   IMPORT int AmigaLoop( char *buffer ); // in main.c file.
     
   char  *topof_buff = inbuff;
   char  *buftop     = inbuff;
   int    rval       = -1;
   
   FBEGIN( printf( "line_grabber( %d, %20.20s )\n", block, inbuff ) );

   // if it was filled last time, it is now empty:
   if (bufstate == FILLED) 
      {
      bufstate  = EMPTY;
      buftop    = inbuff;
      buftop[0] = NIL_CHAR;
      }

   if (block == FALSE)
      {
      rval = FALSE;
      
      goto exitLineGrabber;  // for now, only respond to blocked requests.
      }
   else 
      while (bufstate != FILLED) 
         {
         if (fdtop < 0) 
            {
            sprintf( outmsg, LineCMsg( MSG_NO_FILES_LINE ) );

            APrint( outmsg );

            goto exitLineGrabber;
            }

         if ((inisstd != FALSE) && (o_tab != 0))
            primitive( RAWPRINT, 1, &o_tab );

         if (inisstd == TRUE) // get input from ATWnd CmdStr gadget.
            {
            if (AmigaLoop( buftop ) == USER_COMMAND)
               {
               bufstate = FILLED;
               inbuff   = topof_buff;
               }
            else
               {
               // User closed the main GUI, get ready to exit program.
               goto exitLineGrabber;
               }
            }
         else              // read from a file:
            {
            if (!fgets( buftop, MAXBUFFER, fdstack[fdtop] )) // == NULL)
               {
               bufstate = EMPTY; // Why doesn't this work internally??

               if (fdstack[fdtop] != stdin)
                  fclose( fdstack[ fdtop ] );

               if (--fdtop < 0) 
                  goto exitLineGrabber;

               inisstd = (fdstack[fdtop] == stdin) ? TRUE : FALSE;

               rval = FALSE; // Get outta here!!

               goto exitLineGrabber;
               }
            else 
               {
               bufstate = HALF;

               while (*buftop != NIL_CHAR) 
                  buftop++;

               if (*(buftop - 1) == NEWLINE_CHAR) 
                  {
                  if (*(buftop - 2) == BACK_CHAR) // '\\')  // continued line.
                     buftop -= 2;
                  else 
                     {
                     if ((buftop - inbuff) > MAXBUFFER)
                        {
                        fprintf( stderr, LineCMsg( MSG_BUF_OVFLW_LINE ), MAXBUFFER );

                        cant_happen( INTERNAL_BUFF_OVF ); // Die, you abomination!!
                        }

                     *buftop  = NIL_CHAR;
                     bufstate = FILLED;
                     }
                  }
               }
            }   
         }

   rval = (bufstate == FILLED); // Only place where rval can be > 0

exitLineGrabber:

   FEND( printf( "%d = line_grabber() exits\n", bufstate == FILLED ) );

   return( rval );
}

/* ----------------- END of Line.c file! ----------------------------- */
