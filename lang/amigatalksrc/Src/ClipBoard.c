/****h* AmigaTalk/ClipBoard.c [3.0] *************************************
*
* NAME
*    ClipBoard.c
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleClipBoard( int numargs, OBJECT **args );
*
* HISTORY
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    Entered from RKM Devices manual, pgs. 50-56.  Provide 
*    standard clipboard device interface routines such as
*    Open, Close, Post, Read, Write, etc.
*
*    These functions are useful for writing & reading simple
*    FTXT.  Writing & reading complex FTXT, ILBM, etc., requires
*    more work & usage of the iffparse.library.
*
*    $VER: ClipBoard.c 3.0 (08-Jan-2003) by J.T. Steichen
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

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/iffparse_protos.h>
# include <clib/alib_protos.h>

PUBLIC __far struct Library *IFFParseBase = NULL;

IMPORT ULONG SysBase;
IMPORT ULONG DOSBase; // ???????????

#else

# include <amiga_compiler.h>

# define __USE_INLINE__ 

# include <proto/exec.h>
# include <proto/dos.h>
# include <proto/iffparse.h>

PUBLIC struct Library *IFFParseBase;

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "Object.h"

#include "FuncProtos.h"

#include "IStructs.h"

IMPORT OBJECT *PrintArgTypeError( int primnumber );

// ------------------------------------------------------------------

#define HEAD_SIZE 12 // 'FORM' + 'FTXT' + 'CHRS'

#ifndef  MAKE_ID
# define MAKE_ID(a,b,c,d) ((a << 24L) | (b << 16L) | (c << 8L) | d)
#endif
 
#ifndef  ID_FORM
# define ID_FORM   MAKE_ID('F', 'O', 'R', 'M')
#endif

#define ID_FTXT    MAKE_ID('F', 'T', 'X', 'T')
#define ID_CHRS    MAKE_ID('C', 'H', 'R', 'S')

#ifndef  ID_ILBM
# define ID_ILBM   MAKE_ID('I', 'L', 'B', 'M')
#endif

struct CBptr {

   struct IOClipReq *CB_Ptr;
   int               CB_Flag;    
};

#define CBF_HOOKED 1
#define CBF_NORMAL 2

PRIVATE struct CBptr CBUnits[256] = { 0, };

/*
** Text error messages for possible IFFERR_#? returns from various
** IFF routines.  To get the index into this array, take your IFFERR code,
** negate it, and subtract one.
** example: 
**
**   idx = -error - 1;
**   fprintf( stderr, "IFF ERROR:  %s", errormsgs[ idx ] );
*/

PUBLIC char *CBErrMsgs[16] = { NULL, }; // Visible to CatalogClipboard()

/****i* CBGetIFFError() *****************************************
*
* NAME
*    CBGetIFFError()
*
* DESCRIPTION
*    Return an error message for the given error number.
*****************************************************************
*
*/

SUBFUNC char *CBGetIFFError( int errornum )
{
   if ((errornum >= 0) && (errornum <= 14))
      return( CBErrMsgs[ errornum ] ); // Oh, dopey me!
      
   return( CBErrMsgs[ -errornum - 1 ] );
}

/****i* ClipBoard.c/ClearBuffer() *******************************
*
* SYNOPSIS
*     void ClearBuffer( char *buffer, int buffer_length );
*
*****************************************************************
*
*/

SUBFUNC void ClearBuffer( char *buffer, int length )
{
   int i;
   
   for (i = 0; i < length; i++)
      *(buffer + i) = NIL_CHAR;

   return;
}

/****i* ClipBoard.c/CBClose() ************************************
*
* SYNOPSIS
*   void CBClose( int unit );
*
* DESCRIPTION
*   Close the clipboard device unit which was opened via
*   CBOpen().
******************************************************************
*
*/

SUBFUNC void CBClose( int unit )
{
   struct MsgPort *mp;   

   if (!CBUnits[ unit ].CB_Ptr) // == NULL)
      return;   

   mp = CBUnits[ unit ].CB_Ptr->io_Message.mn_ReplyPort;
   
   CloseDevice( (struct IORequest *) CBUnits[ unit ].CB_Ptr );

   DeleteIORequest( (struct IORequest *) CBUnits[ unit ].CB_Ptr );

   if (mp) // != NULL)
      DeletePort( mp );
          
   CBUnits[ unit ].CB_Ptr  = NULL;
   CBUnits[ unit ].CB_Flag = 0;

   return;
}

/****i* ClipBoard.c/CBOpen() ************************************
*
* SYNOPSIS
*     unitchk = CBOpen( ULONG unit );
*
* DESCRIPTION
*     Open the clipboard device.  A clipboard unit number must
*     be given.  By default, the unit number should be 0.  Valid
*     range is 0 to 255.
*****************************************************************
*
*/

PRIVATE int CBOpen( ULONG unit )
{
   struct MsgPort  *mp  = NULL;
   struct IOStdReq *ior = NULL;

   if (unit > 255 || unit < 0)
      unit = 0;
      
   if (!(mp = CreatePort( 0L, 0L ))) // == NULL)
      return( -2 );
      
   if (!(ior = (struct IOStdReq *)
               CreateIORequest( mp, sizeof( struct IOClipReq ) ))) // == NULL)
      {
      DeletePort( mp );

      return( -3 );
      }

   if (OpenDevice( "clipboard.device", unit, //  CB_CLIPBOARD_DEV, unit, 
                   (struct IORequest *) ior, 0L ) != 0)
      {
      DeleteIORequest( (struct IORequest *) ior );
      DeletePort( mp );

      return( -4 );
      }
   else
      {
      CBUnits[ unit ].CB_Ptr  = (struct IOClipReq *) ior;
      CBUnits[ unit ].CB_Flag = CBF_NORMAL;

      return( unit );
      }
}

/****i* ClipBoard.c/CBUpdate() ***********************************
*
* SYNOPSIS
*   int success = CBUpdate( struct IOClipReq *ior );
*
* DESCRIPTION
*   Send a CMD_UPDATE command to the clipboard device.
*   <221 12 unitNumber>
******************************************************************
*
*/

METHODFUNC int CBUpdate( int unit )
{
   int               openchk = CBOpen( unit );
   struct IOClipReq *ior     = NULL;
   int               success = FALSE;

   if (openchk != unit)
      return( success );
      
   if (!(ior = CBUnits[ unit ].CB_Ptr)) // == NULL) 
      return( success );  // Just in case.
      
   ior->io_Command = CMD_UPDATE;

   DoIO( (struct IORequest *) ior );

   success = ior->io_Error ? FALSE : TRUE;

   CBClose( unit );

   return( success );
}

// Write a 4-byte string to the Clipboard:

SUBFUNC int WriteLong( struct IOClipReq *ior, long *ldata )
{
   ior->io_Data    = (STRPTR) ldata;
   ior->io_Length  = 4L;
   ior->io_Command = CMD_WRITE;

   DoIO( (struct IORequest *) ior );
   
   if (ior->io_Actual == 4)
      return( ior->io_Error ? FALSE : TRUE );

   return( FALSE );
}

/****i* ClipBoard.c/WriteFTXTHeader() **********************************
*
* SYNOPSIS
*   int success = WriteFTXTHeader( struct IOClipReq *ior, int textlen );
*
* DESCRIPTION
*   Write the IFF identification header to the clipboard.
************************************************************************
*
*/

SUBFUNC int WriteFTXTHeader( struct IOClipReq *ior, int textlength )
{
   LONG length  = 0L;
   BOOL odd     = (textlength & 1);

   length  = (odd != 0) ? textlength + 1 : textlength;

   length += HEAD_SIZE;   // Header size == 'FORM' + 'FTXT' + 'CHRS'.

   // Multiview has a problem with odd textlengths (??)
//   textlength = (odd != 0) ? textlength++ : textlength;
   
   if (WriteLong( ior, (long *) "FORM" ) == FALSE)
      return( -1 );
      
   if (WriteLong( ior, &length ) == FALSE)
      return( -2 );

   if (WriteLong( ior, (long *) "FTXT" ) == FALSE)
      return( -3 );
      
   if (WriteLong( ior, (long *) "CHRS" ) == FALSE)
      return( -4 );
      
   if (WriteLong( ior, (long *) &textlength ) == FALSE)
      return( -5 );

   return( 0 );
}

/****i* ClipBoard.c/AsciiStringToClip() ******************************
*
* SYNOPSIS
*   int success = AsciiStringToClip( struct IOClipReq *ior, char *string );
*
* DESCRIPTION
*   Write a NULL-terminated string of text to the clipboard.
*   The string will be written in simple FTXT format.  Note that
*   this function pads odd length strings automatically to
*   conform to the IFF standard.
**********************************************************************
*
*/

PRIVATE int AsciiStringToClip( int unitnum, char *string )
{
   struct IOClipReq *ior     = NULL;
   LONG              slen    = strlen( string );
   BOOL              odd     = (slen & 1);
   int               unitchk = CBOpen( unitnum );
   
   if (unitchk != unitnum)
      return( FALSE );
   
   if (!(ior = CBUnits[ unitnum ].CB_Ptr)) // == NULL)
      return( FALSE );   

   ior->io_Offset = 0;
   ior->io_Error  = 0;
   ior->io_ClipID = 0; // Initial write

   if (WriteFTXTHeader( ior, slen ) < 0) // ????
      {
      CBClose( unitnum );
      return( FALSE );
      }

   ior->io_Data    = (STRPTR) string;
   ior->io_Length  = slen;
   ior->io_Command = CMD_WRITE;

   DoIO( (struct IORequest *) ior );

   if (odd != 0)
      {
      // Send out a pad byte:
      ior->io_Data   = (STRPTR) EMPTY_STRING;
      ior->io_Length = 1;

      DoIO( (struct IORequest *) ior );
      }

   ior->io_Command = CMD_UPDATE;

   DoIO( (struct IORequest *) ior );

   CBClose( unitnum ); 

   return( (ior->io_Error != 0) ? FALSE : TRUE );
}

/****i* ClipBoard.c/CBReadDone() *************************************
*
* SYNOPSIS
*   void CBReadDone( struct IOClipReq *ior );
*
* DESCRIPTION
*   Reads the clipboard file until io_Actual is zero.
*
*   THIS TELLS THE CLIPBOARD THAT WE ARE DONE READING!
* 
* SEE ALSO
*   CBQueryFTXT()
**********************************************************************
*
*/

SUBFUNC void CBReadDone( struct IOClipReq *ior )
{
   char buffer[256] = { 0, };
   
   ior->io_Command = CMD_READ;
   ior->io_Data    = (STRPTR) buffer;
   ior->io_Length  = 254;

   while (ior->io_Actual > 0)
      {
      if (DoIO( (struct IORequest *) ior ))
         break;
      }

   return;
}

/****i* ClipBoard.c/CBQueryFTXT() ************************************
*
* SYNOPSIS
*   int result = CBQueryFTXT( struct IOClipReq *ior );
*
* DESCRIPTION
*   Check to see if the clipboard contains FTXT.  If so, call
*   CBReadCHRS() one or more times until all CHRS chunks have
*   been read.
*
*   METHOD:  clipTypeIs <221 7 private>
**********************************************************************
*
*/

METHODFUNC int CBQueryFTXT( int unit )
{
   int               unitchk = CBOpen( unit );
   struct IOClipReq *ior     = NULL;
   ULONG             cbuff[4] = { 0, };

   if (unitchk != unit)
      return( -1 );

   if (!(ior = CBUnits[ unit ].CB_Ptr)) // == NULL)
      return( -2 );
      
   ior->io_Offset  = 0;
   ior->io_Error   = 0;
   ior->io_ClipID  = 0;
   ior->io_Command = CMD_READ;
   ior->io_Data    = (STRPTR) cbuff;
   ior->io_Length  = 12;

   DoIO( (struct IORequest *) ior );
      
   if (ior->io_Actual == 12L)
      {
      if (cbuff[0] == ID_FORM)
         {
         if (cbuff[2] == ID_FTXT)
            {
            return TRUE;
            }
         }
      }

   CBReadDone( ior );

   CBClose( unit );

   return FALSE; // NOT FTXT!!
}

/****i* ClipBoard.c/ReadLong() **************************************
*
* DESCRIPTION
*   Read a 4-byte string from the Clipboard. 
*********************************************************************
*
*/

SUBFUNC int ReadLong( struct IOClipReq *ior, ULONG *ldata )
{
   ior->io_Command = CMD_READ;
   ior->io_Data    = (STRPTR) ldata;
   ior->io_Length  = 4L;

   DoIO( (struct IORequest *) ior );

   if (ior->io_Actual == 4)
      return( (ior->io_Error != 0) ? FALSE : TRUE );

   return( FALSE );
}

/****i* ClipBoard.c/FillCBData() ************************************
*
* SYNOPSIS
*   char *FillCBData( struct IOClipReq *ior, ULONG size );
*********************************************************************
*
*/

SUBFUNC char *FillCBData( struct IOClipReq *ior, ULONG size )
{
   register UBYTE *to; //, *from;
//   register ULONG i;
   
   char  *buf = NULL, *success = NULL;
   ULONG  length;

   if ((size & 1) != 0)
      length = size + 1; // length has to be even!
   else
      length = size;

   if (!(buf = (char *) AT_AllocVec( length, 
                                     MEMF_PUBLIC | MEMF_CLEAR, 
                                     "fillCBDataBuff", TRUE ))) // == NULL)
      {
      return( NULL );
      }

   ior->io_Command = CMD_READ;
   ior->io_Data    = (STRPTR) buf;
   ior->io_Length  = length;

   to              = buf; // might be yanked out later.

   if (DoIO( (struct IORequest *) ior ) != 0)
      {
      if (buf) // != NULL)
         {
         AT_FreeVec( buf, "fillCBDataBuff", TRUE );

         buf = NULL;
         }

      return( buf );
      }
   else
      success = buf;

   if (!success) // == NULL)
      {
      if (buf) // != NULL)
         {
         AT_FreeVec( buf, "fillCBDataBuff", TRUE );

         buf = NULL;
         }
      }

   return( success );
}

/****i* ClipBoard.c/CBReadCHRS() ************************************
*
* SYNOPSIS
*   char *CBReadCHRS( struct IOClipReq *ior );
*
* DESCRIPTION
*   Read & return the text in the next CHRS chunk (if any)
*   from the clipboard.  Allocates memory to hold data in the
*   next CHRS chunk.
*
* NOTES
*
*  The caller MUST free the returned buffer when done with the
*  data by calling CBFreeBuf().
*********************************************************************
*
*/

SUBFUNC char *CBReadCHRS( struct IOClipReq *ior )
{
   char  *buf = NULL;
   ULONG  chunk, size;
   int    looking = TRUE;
   
   while (looking == TRUE)
      {
      looking = FALSE;

      if (ReadLong( ior, &chunk ))
         {
         if (chunk == ID_CHRS)
            {
            if (ReadLong( ior, &size ))
               if (size != 0)
                  buf = FillCBData( ior, size ); // + 12 ???
            }
         else
            {
            if (ReadLong( ior, &size ))
               {
               looking = TRUE;
               if (size & 1)
                  size++;        /* pad odd length */

               ior->io_Offset += size;
               }
            }
         }
      }

   if (!buf) // == NULL)
      CBReadDone( ior );

   return( buf );
}

/****i* ClipBoard.c/CBFreeBuf() ************************************
*
* SYNOPSIS
*   void CBFreeBuf( char *buf );
*
* DESCRIPTION
*   Frees a buffer allocated by CBReadCHRS().
********************************************************************
*
*/

SUBFUNC void CBFreeBuf( char *buf )
{
   if (buf) // != NULL)
      {
      AT_FreeVec( buf, "fillCBDataBuff", TRUE );

      buf = NULL;
      }

   return;
}

/****i* FTXTFileToClip() *****************************************
*
* NAME
*    FTXTFileToClip()
*
* DESCRIPTION
*    Read an FTXT file & send its contents to the clipboard.
*    <221 11 unitNumber fileName>
******************************************************************
*
*/

METHODFUNC int FTXTFileToClip( char *filename, int clipnumber )
{
   struct IOClipReq *outclip = NULL;
   char              buffer[ 512 ] = { 0, };
   int               unitchk, infile = 0;
   int               readsize, rval = 0;
   
   if ((infile = open( filename, O_RDONLY, 0 )) < 0)
      return( IFFERR_READ );

   if ((unitchk = CBOpen( clipnumber )) != clipnumber)
      {
      close( infile );

      return( IFFERR_WRITE );
      }
      
   if (!(outclip = CBUnits[ clipnumber ].CB_Ptr)) // == NULL)
      {
      close( infile );

      return( IFFERR_WRITE );
      }

   readsize = read( infile, buffer, 512 );

   if (readsize > 0)
      {
      int chk = 0;
      
      if (StringNComp( buffer, "FORM", 4 ) == 0)
         chk = 0;
      else
         {
         rval = IFFERR_NOTIFF;
         goto ExitFTXTFileToClip;
         }   
      
      if (StringNComp( &buffer[8], "FTXT", 4 ) == 0)
         chk = 0;
      else
         {
         rval = IFFERR_NOTIFF;
         goto ExitFTXTFileToClip;
         }   
      
      if (StringNComp( &buffer[12], "CHRS", 4 ) == 0)
         chk = 0;
      else
         {
         rval = IFFERR_NOTIFF;
         goto ExitFTXTFileToClip;
         }   
      
      if (chk == 0)
         {
         outclip->io_Data    = (STRPTR) buffer;
         outclip->io_Length  = readsize;
         outclip->io_Command = CMD_WRITE;
         outclip->io_ClipID  = 0;

         DoIO( (struct IORequest *) outclip );
         }
      }

   // Now, do the rest of the file:

   while ((readsize = read( infile, buffer, 512 )) > 0)
      {
      outclip->io_Data    = (STRPTR) buffer;
      outclip->io_Length  = readsize;
      outclip->io_Command = CMD_WRITE;

      DoIO( (struct IORequest *) outclip );
      }

   outclip->io_Command = CMD_UPDATE;

   DoIO( (struct IORequest *) outclip );

   rval = outclip->io_Error;

ExitFTXTFileToClip:

   close( infile );
   CBClose( clipnumber );

   return( rval );
}

/****i* ILBMFileToClip() **********************************************
*
* NAME
*    ILBMFileToClip()
*
* DESCRIPTION
*    Read an ILBM file & send its contents to the clipboard.
*    <221 12 unitNumber fileName>
***********************************************************************
*
*/

PRIVATE int ILBMFileToClip( char *filename, int clipnumber )
{
   struct IOClipReq *outclip = NULL;

   char buffer[ 512 ] = { 0, };
   int  unitchk, infile = 0;
   int  readsize, rval = 0;
   
   if ((infile = open( filename, O_RDONLY, 0 )) < 0)
      return( IFFERR_READ );

   if ((unitchk = CBOpen( clipnumber )) != clipnumber)
      {
      close( infile );

      return( IFFERR_WRITE );
      }
      
   if (!(outclip = CBUnits[ clipnumber ].CB_Ptr)) // == NULL)
      {
      close( infile );

      return( IFFERR_WRITE );
      }

   readsize = read( infile, buffer, 512 );

   if (readsize > 0)
      {
      int chk = -1;
      
      if (StringNComp( buffer, "FORM", 4 ) == 0)
         chk = 0;
      else
         {
         rval = IFFERR_NOTIFF;
         goto ExitILBMFileToClip;
         }   
      
      if (StringNComp( &buffer[8], "ILBM", 4 ) == 0)
         chk = 0;
      else
         {
         rval = IFFERR_NOTIFF;
         goto ExitILBMFileToClip;
         }   
      
      if (chk == 0)
         {
         outclip->io_Data    = (STRPTR) buffer;
         outclip->io_Length  = readsize;
         outclip->io_Command = CMD_WRITE;
         outclip->io_ClipID  = 0;
         
         DoIO( (struct IORequest *) outclip );
         }
      }

   // Now, do the rest of the file:

   while ((readsize = read( infile, buffer, 512 )) > 0)
      {
      outclip->io_Data    = (STRPTR) buffer;
      outclip->io_Length  = readsize;
      outclip->io_Command = CMD_WRITE;

      DoIO( (struct IORequest *) outclip );
      }

   outclip->io_Command = CMD_UPDATE;

   DoIO( (struct IORequest *) outclip );

   rval = outclip->io_Error;

ExitILBMFileToClip:

   close( infile );
   CBClose( clipnumber );

   return( rval );
}

/****i* ILBMClipToFile() *****************************************
*
* NAME
*    ILBMFileToClip()
*
* DESCRIPTION
*    Read an ILBM clipboard & send to a file.  No checking is 
*    done to see if the clip is really an ILBM.
*    <221 14 unitNumber fileName>
******************************************************************
*
*/

METHODFUNC int ILBMClipToFile( char *filename, int clipnumber )
{
   struct IOClipReq *inclip  = NULL;
   int               outfile = -1;
   char              buffer[ 512 ] = { 0, };
   int               unitchk, rval = 0;
   
   if ((outfile = open( filename, O_WRONLY | O_CREAT, 0 )) < 0)
      return( -1 );

   if ((unitchk = CBOpen( clipnumber )) != clipnumber)
      {
      close( outfile );

      return( IFFERR_READ );
      }

   if (!(inclip = CBUnits[ clipnumber ].CB_Ptr)) // == NULL)
      {
      close( outfile );

      return( IFFERR_READ );
      }

   ClearBuffer( buffer, 512 );

   inclip->io_Data    = (STRPTR) buffer;
   inclip->io_Length  = 512;
   inclip->io_Command = CMD_READ;
   inclip->io_ClipID  = 0;
    
   DoIO( (struct IORequest *) inclip );

   while (inclip->io_Actual > 0)
      {
      rval = write( outfile, buffer, 512 );

      if (rval < 0)
         {
         close(      outfile );
         CBReadDone( inclip  ); // Probably not necessary.

         CBClose( clipnumber );
         return( IFFERR_WRITE );
         }

      ClearBuffer( buffer, 512 ); // Clean out old stuff

      inclip->io_Data    = (STRPTR) buffer;
      inclip->io_Length  = 512;
      inclip->io_Command = CMD_READ;

      DoIO( (struct IORequest *) inclip );
      }
   
   close(      outfile );
   CBReadDone( inclip  ); // Probably not necessary.

   CBClose( clipnumber );

   return( 0 );   
}

/****i* ClipToFTXTFile() ****************************************
*
* NAME
*    ClipToFTXTFile()
*
* DESCRIPTION
*    Read a clipboard & send its contents to an FTXT file.
*    <221 6 unitNumber fileName>
*****************************************************************
*
*/

METHODFUNC int ClipToFTXTFile( int clipnumber, char *filename )
{
   struct IOClipReq *inclip  = NULL;
   int               outfile = -1;
   char              buffer[ 512 ] = { 0, };
   int               unitchk, rval = 0;
   
   if ((outfile = open( filename, O_WRONLY | O_CREAT, 0 )) < 0)
      return( -1 );

   if ((unitchk = CBOpen( clipnumber )) != clipnumber)
      {
      close( outfile );

      return( IFFERR_READ );
      }

   if (!(inclip = CBUnits[ clipnumber ].CB_Ptr)) // == NULL)
      {
      close( outfile );

      return( IFFERR_READ );
      }

   ClearBuffer( buffer, 512 );

   inclip->io_Data    = (STRPTR) buffer;
   inclip->io_Length  = 512;
   inclip->io_Command = CMD_READ;
   inclip->io_ClipID  = 0;
   
   DoIO( (struct IORequest *) inclip );

   while (inclip->io_Actual > 0)
      {
      if (inclip->io_Actual < 512)
         rval = write( outfile, buffer, inclip->io_Actual );
      else
         rval = write( outfile, buffer, 512 );
      
      if (rval < 0)
         {
         close(      outfile );
         CBReadDone( inclip  ); // Probably not necessary.

         CBClose( clipnumber );
         return( IFFERR_WRITE );
         }

      ClearBuffer( buffer, 512 ); // Clean out old stuff

      inclip->io_Data    = (STRPTR) buffer;
      inclip->io_Length  = 512;
      inclip->io_Command = CMD_READ;

      DoIO( (struct IORequest *) inclip );
      }
   
   close(      outfile );
   CBReadDone( inclip  ); // Probably not necessary.

   CBClose( clipnumber );

   return( 0 );   
}

/****i* ClipBoard.c/GetFileLength() *********************************
*
* DESCRIPTION
*   Determine the length of a level-1 file (in bytes), then
*   rewind the file.
*********************************************************************
*
*/

SUBFUNC int GetFileLength( int filenumber )
{
   char buffer[512] = { 0, };
   int  rval = 0, size = 0;
   
   while ((size = read( filenumber, buffer, 512 )) > 0)
      rval += size;
      
   (void) lseek( filenumber, -rval, 1 );
   
   return( rval ); 
}

/****i* ClipBoard.c/AsciiFileToClip() *******************************
*
* SYNOPSIS
*   int AsciiFileToClip( int unitnum, char *filename );
*
* DESCRIPTION
*   Sends ASCII file to the Clipboard as FTXT.  This is basically
*   a means to translate ASCII to a clip.
*********************************************************************
*
*/

METHODFUNC int AsciiFileToClip( int clipunitnum, char *filename )
{
   struct IFFHandle *iff = NULL;
   long              error = 0;
   char              buffer[ 512 ] = { 0, };
   int               infile = 0;
   int               readsize, filelength = 0;
       
   if ((clipunitnum < 0) || (clipunitnum > 255))
      clipunitnum = 0;


#  ifdef  __SASC
   if (!(IFFParseBase = OpenLibrary( "iffparse.library", 0L ))) // == NULL)
      return( -1 );
#  else
   if ((IFFParseBase = OpenLibrary( "iffparse.library", 50L ))) // != NULL)
      {
      if (!(IIFFParse = (struct IFFParseIFace *) GetInterface( IFFParseBase, "main", 1, NULL )))
         {
	 CloseLibrary( IFFParseBase );
	 
	 IFFParseBase = NULL;

	 return( -1 );
	 }
      }
   else
      return( -1 );
#  endif
      
   if ((infile = open( filename, O_RDONLY, 0 )) < 0)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( IFFERR_READ );
      }

   /* * Allocate IFF_File structure. */
   if (!(iff = AllocIFF())) // == NULL)
      {
      close( infile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );
      return( -3 );
      }

   /* * Set up IFF_File for Clipboard I/O. */
   if (!(iff->iff_Stream = (ULONG) OpenClipboard( clipunitnum ))) // == NULL)
      {
      FreeIFF( iff );
      close( infile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( -4 );
      }

   InitIFFasClip( iff );

   /* * Start the IFF transaction. */
   if ((error = OpenIFF( iff, IFFF_WRITE )) != 0)
      {
      CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
      FreeIFF( iff );
      close( infile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( error );
      }

   /* Write our text to the clipboard as CHRS chunk in FORM FTXT
   ** 
   ** First, write the FORM ID (FTXT) 
   */

   if ((error = PushChunk( iff, ID_FTXT, ID_FORM, IFFSIZE_UNKNOWN )) != 0)
      {
      CloseIFF( iff );
      CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );

      FreeIFF( iff );

      close( infile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( error );
      }

   filelength = GetFileLength( infile );

   /* Now the CHRS chunk ID followed by the chunk data We'll 
   ** just write one CHRS chunk. You could write more chunks. 
   */
   if ((error = PushChunk( iff, 0, ID_CHRS, filelength )) != 0)
      {
      CloseIFF( iff );
      CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );

      FreeIFF( iff );

      close( infile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( error );
      }

   ClearBuffer( buffer, 512 );

   /* Now the actual data (the text) */
   while ((readsize = read( infile, buffer, 512 )) > 0)
      {
      if (WriteChunkBytes( iff, buffer, readsize ) != readsize)
         {
         error = IFFERR_WRITE;
         CloseIFF( iff );
         CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
         FreeIFF( iff );
         close( infile );

#        ifdef __amigaos4__
         DropInterface( (struct Interface *) IIFFParse );
#        endif

         CloseLibrary( IFFParseBase );

         return( error );
         }

      ClearBuffer( buffer, 512 );
      }

   if (error == 0)
      error = PopChunk( iff );

   if (error == 0)
      error = PopChunk( iff );

   if (error != 0)
      {
      CloseIFF( iff );
      CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
      FreeIFF( iff );
      close( infile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( error );
      }

   CloseIFF( iff );
   CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
   FreeIFF( iff );
   close( infile );

#  ifdef __amigaos4__
   DropInterface( (struct Interface *) IIFFParse );
#  endif
 
   CloseLibrary( IFFParseBase );

   return( 0 );
}

/****i* ClipBoard.c/FTXTToAsciiFile() ******************************
*
* SYNOPSIS
*   int FTXTToAsciiFile( int unitnum, char *filename );
*
* DESCRIPTION
*   Sends the FTXT in the Clipboard to an ASCII file.  This is
*   a means to translate an FTXT Clip to ASCII.
*   <221 8 filename private>
*
* WARNING
*   This function assumes that there is only one simple CHRS-type
*   chunk in the clip.
********************************************************************
*
*/

METHODFUNC int FTXTToAsciiFile( int clipunitnum, char *filename )
{
   struct IFFHandle   *iff = NULL;
   struct ContextNode *cn  = NULL;

   long                error = 0, rlen = 0;
   char                buffer[ 512 ] = { 0, };
   int                 outfile = 0;
   int                 rval = 0;
   
   if ((clipunitnum < 0) || (clipunitnum > 255))
      clipunitnum = 0;
      
#  ifdef  __SASC
   if (!(IFFParseBase = OpenLibrary( "iffparse.library", 0L ))) // == NULL)
      return( -1 );
#  else
   if ((IFFParseBase = OpenLibrary( "iffparse.library", 50L ))) // != NULL)
      {
      if (!(IIFFParse = (struct IFFParseIFace *) GetInterface( IFFParseBase, "main", 1, NULL )))
         {
	 CloseLibrary( IFFParseBase );
	 
	 IFFParseBase = NULL;

	 return( -1 );
	 }
      }
   else
      return( -1 );
#  endif

   if ((outfile = open( filename, O_WRONLY | O_CREAT, 0 )) < 0)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( IFFERR_WRITE );
      }

   /* * Allocate IFF_File structure. */
   if (!(iff = AllocIFF())) // == NULL)
      {
      close( outfile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( -3 );
      }

   if (!(iff->iff_Stream = (ULONG) OpenClipboard( clipunitnum ))) // == NULL)
      {
      FreeIFF( iff );
      close( outfile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( -4 );
      }

   InitIFFasClip( iff );

   if ((error = OpenIFF( iff, IFFF_READ )) != 0)
      {
      CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
      FreeIFF( iff );
      close( outfile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( error );
      }

   /* Tell iffparse we want to stop on FTXT CHRS chunks */
   if ((error = StopChunk( iff, ID_FTXT, ID_CHRS )) != 0)
      {
      CloseIFF( iff );
      CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
      FreeIFF( iff );
      close( outfile );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( error );
      }


   while (1)
      {
      /* Find all of the FTXT CHRS chunks */      
      
      error = ParseIFF( iff, IFFPARSE_SCAN );
 
      if (error == IFFERR_EOC)
         continue;   /* enter next context */

      else if (error != 0)
         break;

      /* We only asked to stop at FTXT CHRS chunks.  If no error,
      ** we've hit a stop chunk.  Read the CHRS chunk data:
      */
      cn = CurrentChunk( iff );

      if (cn && (cn->cn_Type == ID_FTXT) 
             && (cn->cn_ID == ID_CHRS))
         {
         ClearBuffer( buffer, 512 );

         while ((rlen = ReadChunkBytes( iff, buffer, 512 )) > 0)
            {
            rval = write( outfile, buffer, rlen );

            if (rval < 0)
               {
               CloseIFF( iff );

               CloseClipboard( (struct ClipboardHandle *) 
                               iff->iff_Stream 
                             );

               FreeIFF( iff );
               close( outfile );

#              ifdef __amigaos4__
               DropInterface( (struct Interface *) IIFFParse );
#              endif
 
               CloseLibrary( IFFParseBase );

               return( IFFERR_WRITE );
               }

            ClearBuffer( buffer, 512 );
            }

         if (rlen < 0)
            error = rlen;
         }
      }

   rval = 0; 

   if ((error != 0) && (error != IFFERR_EOF))
      rval = error;

   CloseIFF( iff );
   CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );
   FreeIFF( iff );
   close( outfile );

#  ifdef __amigaos4__
   DropInterface( (struct Interface *) IIFFParse );
#  endif
 
   CloseLibrary( IFFParseBase );

   return( rval );
}

/****i* ClipFuncs/FindCurrentWriteID() *****************************
*
* NAME
*    FindCurrentWriteID()
*
* SYNOPSIS
*    ULONG FindCurrentWriteID( void )
********************************************************************
* 
*/

SUBFUNC ULONG FindCurrentWriteID( void )
{
   struct IOClipReq ior = { 0, };
   
   ior.io_Command = CBD_CURRENTWRITEID;

   DoIO( (struct IORequest *) &ior );

   return( (ULONG) ior.io_ClipID );
}

/****i* ClipFuncs/FindCurrentReadID() ******************************
*
* NAME
*    FindCurrentReadID()
*
* SYNOPSIS
*    ULONG FindCurrentReadID( void )
*
* NOTES
*    NOT currently used.
********************************************************************
*
*/

SUBFUNC ULONG FindCurrentReadID( void )
{
   struct IOClipReq ior = { 0, };
   
   ior.io_Command = CBD_CURRENTREADID;

   DoIO( (struct IORequest *) &ior );

   return( (ULONG) ior.io_ClipID );
}


/****i* ClipBoard.c/PostFTXTClip() *********************************
*
* SYNOPSIS
*   int PostFTXTClip( int unitnum, char *buffer );
*
* DESCRIPTION
*   Sends an FTXT to the Clipboard & waits for a SatisfyMsg.
*   <221 13 unitNumber ftxtString>
********************************************************************
*
*/

METHODFUNC int PostFTXTClip( int unitnum, char *buffer )
{
   struct MsgPort    *satisfy = NULL;
   struct SatisfyMsg *sm      = NULL;
   struct IOClipReq  *ior     = NULL;
   int                unitchk, mustwrite;
   ULONG              postID, writeID;
   
   if (!buffer) // == NULL)
      return( -1 );

   if (!(satisfy = CreatePort( 0L, 0L ))) // == NULL)
      return( -2 );

   if ((unitchk = CBOpen( unitnum )) != unitnum)
      {
      DeletePort( satisfy );

      return( -3 );
      }      

   if (!(ior = CBUnits[ unitnum ].CB_Ptr)) // == NULL)
      {
      DeletePort( satisfy );

      return( -4 );
      }

   mustwrite       = FALSE;
   ior->io_Data    = (STRPTR) satisfy;
   ior->io_ClipID  = 0L;
   ior->io_Command = CBD_POST;

   DoIO( (struct IORequest *) ior );

   postID = ior->io_ClipID;

   Wait( SIGBREAKF_CTRL_C | (1L << satisfy->mp_SigBit) );
        
   if (sm = (struct SatisfyMsg *) GetMsg( satisfy ))
      mustwrite = TRUE;
   else
      {
      writeID = FindCurrentWriteID();

      if (postID >= writeID)
         mustwrite = TRUE;
      }

   if (mustwrite == TRUE)
      {
      CBClose( unitnum ); // AsciiStringToClip() will open it again.
      
      if (AsciiStringToClip( unitnum, buffer ) == FALSE)
         {
         CBClose( unitnum );
         DeletePort( satisfy );

         return( -4 );
         }
      }

   CBClose( unitnum );
   DeletePort( satisfy );

   return( 0 );
}

/****i* ChangeHookFunctions ******************************************
*
* NOTES 
*    Modified the ChangeHook_Test.c file from RKM Devices manual,
*    pgs. 48-49.
*
* The DEBUG code will set a hook & wait for the clipboard data to
* change.  You must put something in the clipboard in order for
* it to return.  Run from the CLI only!
*
**********************************************************************
*
*/

struct CHData  {
   
   struct Task *ch_Task;
   LONG         ch_ClipID;
};


/****i* hookEntry() **************************************************
*
* NAME
*    hookEntry();
*
* NOTES
*    Register calling convention:
*
*      A0 - pointer to the hook itself.
*      A1 - pointer to the parameter packed ("message")
*      A2 - Hook-specific address data ("object", such as gadget)
**********************************************************************
*
*/
#ifdef  __SASC
PRIVATE ULONG __asm hookEntry( register __a0 struct Hook *h, 
                               register __a2 void        *obj, 
                               register __a1 void        *msg
                             )
#else
PRIVATE ULONG ASM hookEntry( REG( a0, struct Hook *h   ), 
                             REG( a2, void        *obj ), 
                             REG( a1, void        *msg )
                           )
#endif
{
   return( (ULONG) (*h->h_SubEntry)( h, obj, msg ) );
}

/****i* InitHook() ***************************************************
*
* NAME
*    InitHook()
* 
* DESCRIPTION
*    Setup the hook structure.
**********************************************************************
*
*/

PRIVATE void InitHook( struct Hook *h, 
                       ULONG      (*func)( struct Hook *, void *, void * ),
                       void        *data
                     )
{
   if (h != NULL)
      {
      h->h_Entry    = (ULONG (*)( struct Hook *, 
                                  void *, 
                                  void * )) hookEntry;
      h->h_SubEntry = func;
      h->h_Data     = data;
      }

   return;
}

// Arrrggghhh!!!! Global variables:

PRIVATE struct Hook    CBhook;
PRIVATE struct CHData  CBhookData;

/****i* OpenHookedCB() *******************************************
*
* NAME
*    OpenHookedCB()
*
* DESCRIPTION
*    Open the clipboard with a change hook.
******************************************************************
*
*/

METHODFUNC int OpenHookedCB( LONG unit,  
                             ULONG(*hookfunc)( struct Hook *, 
                                                      void *, 
                                                      void * 
                                             )
                           )
{
   struct IOClipReq *clipIO  = NULL;
   int               unitchk = CBOpen( unit );

   if (unitchk != unit)
      return( -1 );
            
   if ((clipIO = CBUnits[ unit ].CB_Ptr)) // != NULL)
      {
      clipIO->io_Data    = (char *) &CBhook;
      clipIO->io_Length  = 1;
      clipIO->io_Command = CBD_CHANGEHOOK;
      
      CBhookData.ch_Task = FindTask( NULL );
      
      InitHook( &CBhook, hookfunc, &CBhookData );

      if (DoIO( (struct IORequest *) clipIO ) != 0)
         fprintf( stderr, ClipCMsg( MSG_CB_ERR_NO_HOOK_CLIP ) );
//      else
//         printf( "hook set.\n" );

      CBUnits[ unit ].CB_Flag = CBF_HOOKED; 

      return( unit );
      }

   return( -2 );
}

/****i* CloseHookedCB() *********************************************
*
* NAME
*    CloseHookedCB()
* 
* DESCRIPTION
*    Close the clipboard & kill the change hook.
*********************************************************************
*
*/

METHODFUNC void CloseHookedCB( int unit )
{
   struct IOClipReq *clipIO = CBUnits[ unit ].CB_Ptr;
    
   if (clipIO) // != NULL)
      {
      clipIO->io_Data    = (char *) &CBhook;
      clipIO->io_Length  = 0;
      clipIO->io_Command = CBD_CHANGEHOOK;
   
      if (DoIO( (struct IORequest *) clipIO ) != 0)
         printf( ClipCMsg( MSG_CB_ERR_HOOK_CTRL_CLIP ) );

      CBClose( unit );
      }
      
   return;
}      

// ---- Clipboard access using iffparse.library: ------------------------

/****i* ClipBoard.c/CBCloseIFF() *********************************
*
* SYNOPSIS
*   void CBCloseIFF( struct IFFHandle *iffh );
*
* DESCRIPTION
*   Close the clipboard device unit which was opened via
*   CBOpenIFF().
******************************************************************
*
*/

SUBFUNC void CBCloseIFF( struct IFFHandle *iffh )
{
   if (iffh) // != NULL)
      {
      CloseIFF( iffh );

      if (iffh->iff_Stream)
         CloseClipboard( (struct ClipboardHandle *) iffh->iff_Stream );

      FreeIFF( iffh );

      iffh = NULL;
      }

   if (IFFParseBase) // != NULL)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      IFFParseBase = NULL;
      }

   return;
}

/****i* Clipboard.c/CBOpenIFF() **************************************
*
* NAME
*    CBOpenIFF()
*
* DESCRIPTION
**********************************************************************
* 
*/

SUBFUNC struct IFFHandle *CBOpenIFF( ULONG unit, int RWFlag )
{
   struct IFFHandle *iff   = NULL;
   int               error = 0;
    
#  ifdef  __SASC
   if (!(IFFParseBase = OpenLibrary( "iffparse.library", 0L ))) // == NULL)
      return( iff );
#  else
   if ((IFFParseBase = OpenLibrary( "iffparse.library", 50L ))) // != NULL)
      {
      if (!(IIFFParse = (struct IFFParseIFace *) GetInterface( IFFParseBase, "main", 1, NULL )))
         {
	 CloseLibrary( IFFParseBase );
	 
	 IFFParseBase = NULL;

	 return( iff );
	 }
      }
   else
      return( iff );
#  endif

   if (!(iff = AllocIFF())) // == NULL)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( NULL );
      }

   /* * Set up IFF_File for Clipboard I/O. */
   if (!(iff->iff_Stream = (ULONG) OpenClipboard( unit ))) // == NULL)
      {
      FreeIFF( iff );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( NULL );
      }

   InitIFFasClip( iff );

   if ((error = OpenIFF( iff, RWFlag )) != 0)
      {
      if (iff->iff_Stream)
         CloseClipboard( (struct ClipboardHandle *) iff->iff_Stream );

      FreeIFF( iff );

#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IIFFParse );
#     endif

      CloseLibrary( IFFParseBase );

      return( NULL );
      }

   return( iff );
}

/****i* Clipboard.c/CBWriteFTXT_IFF() ********************************
*
* NAME
*     CBWriteFTXT_IFF()
*
* DESCRIPTION
*    Write an FTXT string to the clipboard. 
*    <221 14 unitNumber ftxtString>
**********************************************************************
* 
*/

METHODFUNC int CBWriteFTXT_IFF( ULONG unit, char *text )
{
   struct IFFHandle *stream = NULL;
   int               rval   = 0;
   
   if ((stream = CBOpenIFF( unit, IFFF_WRITE )) != 0) 
      {
      return( rval = IFFERR_WRITE );
      }

   if ((rval = PushChunk( stream, ID_FTXT, ID_FORM, IFFSIZE_UNKNOWN)) == 0)
      {
      if ((rval = PushChunk( stream, 0, ID_CHRS, IFFSIZE_UNKNOWN )) == 0)
         {
         int textlen = strlen( text );

         if (WriteChunkBytes( stream, text, textlen ) != textlen)
            {
            rval = IFFERR_WRITE;
            }
         }

      if (rval == 0)
         rval = PopChunk( stream );
      }

   if (rval == 0)
      rval = PopChunk( stream );

   CBCloseIFF( stream );

   return( rval );
}

/****i* Clipboard.c/CBReadFTXT_IFF() *********************************
*
* NAME
*     CBReadFTXT_IFF()
*
* DESCRIPTION
*    Read an FTXT from the clipboard to the buffer.
*    <221 15 unitNumber size buffer>
**********************************************************************
* 
*/

METHODFUNC int CBReadFTXT_IFF( ULONG unit, char *buffer, int readsize )
{
   struct ContextNode *cn     = NULL;
   struct IFFHandle   *stream = NULL;
   int                 rval   = 0;
   
   if ((stream = CBOpenIFF( unit, IFFF_READ )) != 0) 
      {
      return( IFFERR_READ );
      }

   if ((rval = StopChunk( stream, ID_FTXT, ID_CHRS )) != 0)
      {
      return( rval );
      }

   /* Find all of the FTXT CHRS chunks */
   while (1)
      {
      rval = ParseIFF( stream, IFFPARSE_SCAN );
 
      if (rval == IFFERR_EOC)
         continue;            /* enter next context */
      else if (rval != 0)
         break;

      /* We only asked to stop at FTXT CHRS chunks If no error 
      ** we've hit a stop chunk Read the CHRS chunk data 
      */
      cn = CurrentChunk( stream );

      if ((cn) && (cn->cn_Type == ID_FTXT) && (cn->cn_ID == ID_CHRS))
         {
         int rlen = 0;
         
         // printf( "CHRS chunk contains:\n" );

         while ((rlen = ReadChunkBytes( stream, buffer, readsize )) > 0)
            buffer += readsize;

         if (rlen < 0)
            rval = rlen; // An Error code??
         }
      }

   if (rval == IFFERR_EOF)
      rval = 0;

   CBCloseIFF( stream );
         
   return( rval );
}

// ---------------------------------------------------------------------

/****i* HandleClipBoard() [1.6] **************************************
*
* NAME
*    HandleClipBoard()
*
* DESCRIPTION
*    AmigaTalk primitive 221 handler for the OS Clipboard(s).
**********************************************************************
*
*/

PUBLIC OBJECT *HandleClipBoard( int numargs, OBJECT **args )
{
   IMPORT OBJECT *o_nil; 

   OBJECT *rval = o_nil;
   int     temp = 0;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 221 );
      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0: // postAsciiFileToClip: fileName
         if (is_string( args[2] ) == FALSE || !is_integer( args[1] ))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = AsciiFileToClip(    int_value( args[1] ),
                                    string_value( (STRING *) args[2] ) 
                                  );

            rval = AssignObj( new_int( temp ) );
            }
          
         break;

      case 1: // postAsciiStringToClip: clipString
         if (is_string( args[1] ) == FALSE || !is_integer( args[2] ))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = AsciiStringToClip(    int_value(            args[2] ),
                                      string_value( (STRING *) args[1] )
                                    );

            rval = AssignObj( new_int( temp ) );
            }
         
         break;

      case 2: // writeFTXTClipToFTXTFile: fileName
         if (!is_integer( args[1] ) || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = ClipToFTXTFile(    int_value( args[1] ),
                                   string_value( (STRING *) args[2] )
                                 );

            rval = AssignObj( new_int( temp ) );
            }
            
         break;
         
      case 3: // clipTypeIs <unitNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = CBQueryFTXT( int_value( args[1] ));

            if (temp == TRUE)
               rval = o_true;  // FTXT
            else if (temp == FALSE)
               rval = o_false; // Something else (ILBM??)
            else
               rval = o_nil;   // error condition!!
            }
            
         break;

      case 4: // writeFTXTClipToASCIIFile: filename
         if (is_string( args[1] ) == FALSE || !is_integer( args[2] ))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = FTXTToAsciiFile( int_value(               args[2] ),
                                    string_value( (STRING *) args[1] )
                                  );

            rval = AssignObj( new_int( temp ) );
            }

         break;

      case 5: // openHookedClipboard: clipNumber withHook: aHook
         if ( !is_integer( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = (int) OpenHookedCB( (LONG) int_value( args[1] ),  
                                       (ULONG(*)( struct Hook *, 
                                                         void *, 
                                                         void * 
                                                )
                                       ) addr_value( args[2] )
                                     );
            if (!temp) // == NULL)
               rval = o_nil;
            else
               rval = AssignObj( new_int( temp ) );
            }

         break;

      case 6: // closeHookedClipboard
         if (is_integer( args[1] ) == FALSE)
           (void) PrintArgTypeError( 221 );
         else
            CloseHookedCB( int_value( args[1] ) );
          
         break;

      case 7: // postFTXTFileToClip: fileName
         if (is_string( args[2] ) == FALSE || !is_integer( args[1] ))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = FTXTFileToClip( string_value( (STRING *) args[2] ),
                                      int_value( args[1] )
                                 );

            rval = AssignObj( new_int( temp ) );
            }
        
         break;

      case 8: //postILBMFileToClip: <unitNumber> fileName 
         if (!is_integer( args[1] ) || (is_string( args[2] ) == FALSE))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = ILBMFileToClip( string_value( (STRING *) args[2] ),
                                      int_value(            args[1] )
                                 );
                                 
            rval = AssignObj( new_int( temp ) );
            }
      
         break;

      case 14: // writeILBMClipToFile: fileName <unitNumber>
         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            {         
            (void) PrintArgTypeError( 221 );
            }
         else
            {

            temp = ILBMClipToFile( string_value( (STRING *) args[2] ),
                                      int_value(            args[1] )
                                 );
            
            rval = AssignObj( new_int( temp ) );
            }

         break;        

      case 9: // <221 9 errnumber> Translate error number to string.
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 221 );
         else
            rval = AssignObj( new_str( CBGetIFFError( int_value( args[1] ) )));
            
         break;

      case 12: // update <unitNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = CBUpdate( int_value( args[1] ) );
            
            if (temp == TRUE)
               rval = o_true;
            else if (temp == FALSE)
               rval = o_false;
            else
               rval = o_nil;
            }

         break;

      case 13: // postFTXTToClip: ftxtString <unitNumber> EXPERIMENTAL!
         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            {         
            (void) PrintArgTypeError( 221 );
            }
         else
            {
            temp = PostFTXTClip(    int_value(            args[1] ),
                                 string_value( (STRING *) args[2] )
                               );
            
            rval = AssignObj( new_int( temp ) );
            }

         break;

      // iffparse.library functions: -----------------------------------

      case 10: // postToClipUnit: unit fromFTXTString: ftxtString 
         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 221 );
         else
            {
            temp = CBWriteFTXT_IFF( (ULONG) int_value( args[1] ),
                                         string_value( (STRING *) args[2] )
                                  );
                                  
            rval = AssignObj( new_int( temp ) );
            }

         break;

      case 11: // writeFTXTClip: unit toFTXTString string size: numBytes
         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_string(  args[3] ))
            {         
            (void) PrintArgTypeError( 221 );
            }
         else
            {
            temp = CBReadFTXT_IFF( (ULONG) int_value(    args[1] ),
                                   string_value( (STRING *) args[3] ),
                                           int_value(    args[2] )
                                 );
            
            rval = AssignObj( new_int( temp ) );
            }

         break;
      // ------------------------------------------------------------

      default:
         (void) PrintArgTypeError( 221 );

         break;
      }

   return( rval );
}

/* -------------------- END of ClipBoard.c file! --------------------- */
