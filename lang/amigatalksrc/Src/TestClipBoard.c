/****h* AmigaTalk/TestClipBoard.c [1.6] *********************************
*
* NAME
*    TestClipBoard.c
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleClipBoard( int numargs, OBJECT **args );
*
* NOTES
*    Entered from RKM Devices manual, pgs. 50-56.  Provide 
*    standard clipboard device interface routines such as
*    Open, Close, Post, Read, Write, etc.
*
*    These functions are useful for writing & reading simple
*    FTXT.  Writing & reading complex FTXT, ILBM, etc., requires
*    more work & usage of the iffparse.library.
*************************************************************************
*
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>          // level 1 access flags.

#include <exec/ports.h>
#include <exec/io.h>
#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/memory.h>

#include <dos/dos.h>

#include <AmigaDOSErrs.h>

#include <devices/clipboard.h>

#include <libraries/dos.h>
#include <libraries/iffparse.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/alib_protos.h>


/****i* clipHook() **************************************************
*
* NAME
*    clipHook()
*********************************************************************
*
*/

PRIVATE ULONG clipHook( struct Hook *h, void *c, struct ClipHookMsg *msg )
{
   struct CHData *ch = (struct CHData *) h->h_Data;

   geta4();   // Make sure that A4 has the Global Data Segment.

   if (ch != NULL)
      {
      ch->ch_ClipID = msg->chm_ClipID;

      Signal( ch->ch_Task, SIGBREAKF_CTRL_E );
      }

   return( 0 );
}

PUBLIC void  main( int argc, char **argv )
{
   ULONG sig_rcvd = 0L;

   printf( "%s\n", argv[0] );

   if (OpenHookedCB( 0L, clipHook ) != 0)
      {
      sig_rcvd = Wait( (SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_E) );

      if (sig_rcvd & SIGBREAKF_CTRL_C)
         printf( "^C received!\n" );

      if (sig_rcvd & SIGBREAKF_CTRL_E)
         printf( "Clipboard change, current ID = %ld\n",
                 CBhookData.ch_ClipID 
               );

      CloseHookedCB( 0 );
      }

   return;
}

/* -------------------- END of TestClipBoard.c file! --------------------- */

