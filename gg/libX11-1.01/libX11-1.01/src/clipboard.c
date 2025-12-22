/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     clipboard
   PURPOSE
     
   NOTES
     Cut & Paste from amiga dev cd.

   HISTORY
     Terje Pedersen - Sep 28, 1997: Created.
***/

#include <exec/io.h>

#include "exec/types.h"
#include "exec/ports.h"
#include "exec/io.h"
#include "exec/memory.h"
#include "devices/clipboard.h"

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>

#include <proto/exec.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern struct DosLibrary *DOSBase;

/********************************************************************************/
/* prototypes */
/********************************************************************************/

struct IOClipReq        *CBOpen         ( ULONG );
void                    CBClose         (struct IOClipReq *);

int                     CBWriteFTXT     (struct IOClipReq *, char *);
int                     WriteLong       (struct IOClipReq *, long *);

/********************************************************************************/

WriteLong( struct IOClipReq *ior, long *ldata )
{
  ior->io_Data    = (STRPTR)ldata;
  ior->io_Length  = 4L;
  ior->io_Command = CMD_WRITE;
  DoIO( (struct IORequest *) ior);
  
  if (ior->io_Actual == 4){
    return( ior->io_Error ? FALSE : TRUE);
  }
  
  return(FALSE);
}

/****** cbio/CBWriteFTXT *********************************************
*
*   NAME
*       CBWriteFTXT() -- Write a string of text to the clipboard.device
*
*   SYNOPSIS
*       success = CBWriteFTXT( ior, string)
*
*       int CBWriteFTXT(struct IOClipReq *, char *)
*
*   FUNCTION
*       Write a NULL terminated string of text to the clipboard.
*       The string will be written in simple FTXT format.
*
*       Note that this function pads odd length strings automatically
*       to conform to the IFF standard.
*
*   RESULTS
*       TRUE if the write succeeded, else FALSE.
*
*********************************************************************/

int
CBWriteFTXT( struct IOClipReq *ior, char *string )
{
  ULONG length, slen;
  BOOL odd;
  int success;
  
  slen = strlen(string);
  odd = (slen & 1);               /* pad byte flag */
  
  length = (odd) ? slen+1 : slen;
  
  /* initial set-up for Offset, Error, and ClipID */
  
  ior->io_Offset = 0;
  ior->io_Error  = 0;
  ior->io_ClipID = 0;
  
  /* Create the IFF header information */
  
  WriteLong(ior, (long *) "FORM");     /* "FORM"             */
  length+=12L;                         /* + "[size]FTXTCHRS" */
  WriteLong(ior, &length);             /* total length       */
  WriteLong(ior, (long *) "FTXT");     /* "FTXT"             */
  WriteLong(ior, (long *) "CHRS");     /* "CHRS"             */
  WriteLong(ior, &slen);               /* string length      */
  
  /* Write string */
  ior->io_Data    = (STRPTR)string;
  ior->io_Length  = slen;
  ior->io_Command = CMD_WRITE;
  DoIO( (struct IORequest *) ior);
  
  /* Pad if needed */
  if( odd ){
    ior->io_Data   = (STRPTR)"";
    ior->io_Length = 1L;
    DoIO( (struct IORequest *) ior);
  }
  
  /* Tell the clipboard we are done writing */
  
  ior->io_Command=CMD_UPDATE;
  DoIO( (struct IORequest *) ior);
  
  /* Check if io_Error was set by any of the preceding IO requests */
  success = ior->io_Error ? FALSE : TRUE;
  
  return(success);
}

/*
 * Write a string to the clipboard
 *
 */

WriteClip( char *string )
{
  struct IOClipReq *ior;
  
  if (string == NULL){
    return(0L);
  }
  
  /* Open clipboard.device unit 0 */
  
  if (ior = CBOpen(0L)){
    CBWriteFTXT(ior,string);
    CBClose(ior);
  }
  
  return(0);
}

/****** cbio/CBOpen *************************************************
*
*   NAME
*       CBOpen() -- Open the clipboard.device
*
*   SYNOPSIS
*       ior = CBOpen(unit)
*
*       struct IOClipReq *CBOpen( ULONG )
*
*   FUNCTION
*       Opens the clipboard.device.  A clipboard unit number
*       must be passed in as an argument.  By default, the unit
*       number should be 0 (currently valid unit numbers are
*       0-255).
*
*   RESULTS
*       A pointer to an initialized IOClipReq structure, or
*       a NULL pointer if the function fails.
*
*********************************************************************/

struct IOClipReq *
CBOpen( ULONG unit )
{
  struct MsgPort *mp;
  struct IOStdReq *ior;
  
  if (mp = CreatePort(0L,0L)){
    if (ior=(struct IOStdReq *)CreateExtIO(mp,sizeof(struct IOClipReq))){
      if (!(OpenDevice("clipboard.device",unit,ior,0L))){
	return((struct IOClipReq *)ior);
      }
      DeleteExtIO(ior);
    }
    DeletePort(mp);
  }
  return(NULL);
}

/****** cbio/CBClose ************************************************
*
*   NAME
*       CBClose() -- Close the clipboard.device
*
*   SYNOPSIS
*       CBClose()
*
*       void CBClose()
*
*   FUNCTION
*       Close the clipboard.device unit which was opened via
*       CBOpen().
*
*********************************************************************/

void CBClose( struct IOClipReq* ior )
{
  struct MsgPort *mp;
  
  mp = ior->io_Message.mn_ReplyPort;
  
  CloseDevice((struct IOStdReq *)ior);
  DeleteExtIO((struct IOStdReq *)ior);
  DeletePort(mp);
}
