/****h* ReportErrs.c [3.0] *******************************************
*
* NAME
*    ReportErrs.c
*
* DESCRIPTION
*    All error reporting functions are located in this file in 
*    order to put as many strings as possible in one file for
*    simplifyng Localization of the AmigaTalk program.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    03-Jan-2003 - Created this file.
*
* NOTES
*    $VER: ReportErrs.c 3.0 (25-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <rexx/rxslib.h>

#include "FuncProtos.h"

#include "StringIndexes.h"
#include "StringConstants.h"
#include "CantHappen.h"

#include "CPGM:GlobalObjects/CommonFuncs.h"

IMPORT struct Window  *ATWnd;
IMPORT struct Console *st_console;

IMPORT UBYTE *PgmName;

IMPORT UBYTE *ErrMsg;

IMPORT FILE  *TraceFile;
IMPORT BOOL   traceByteCodes;
IMPORT int    TraceIndent;
 
// Added for V1.8+:

PUBLIC STRPTR ArgHelp     = NULL;
PUBLIC STRPTR RDATemplate = NULL;

// ---------- Common Error Requester titles: -------------------------

PUBLIC UBYTE *ATalkProblem     = NULL;
PUBLIC UBYTE *SystemProblem    = NULL;
PUBLIC UBYTE *AllocProblem     = NULL;
PUBLIC UBYTE *UserProblem      = NULL;
PUBLIC UBYTE *UserPgmError     = NULL;

PUBLIC UBYTE *FATAL_ERROR      = NULL;
PUBLIC UBYTE *FATAL_USER_ERROR = NULL;
PUBLIC UBYTE *FATAL_INTERROR   = NULL;

PUBLIC UBYTE *InternalError    = NULL;

// ---------- For The Buttons: ---------------------------------------

PUBLIC UBYTE *AaarrggButton  = NULL;
PUBLIC UBYTE *DefaultButtons = NULL;

// ---------- No Problem-Type messages: ------------------------------

PUBLIC void givepause( void )
{
   UserInfo( RErrsCMsg( MSG_TAKE_A_PAUSE_RERR ), 
             RErrsCMsg( MSG_PRESS_OKAY_TOGO_RERR ) 
           );

   return;
}

// ---------- For AmigaTalk Problems: --------------------------------

/****h* CouldNotPerform() [3.0] **************************************
*
* NAME
*    CouldNotPerform()
*
* DESCRIPTION
*    Inform the User that we had a problem.
**********************************************************************
*
*/

PUBLIC void CouldNotPerform( char *func, char *forMe )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_NOT_PERFORM_RERR ), func, forMe );

   if (ATWnd) // != NULL)
      UserInfo( ErrMsg, ATalkProblem );

   if (st_console) // != NULL)
      APrint( ErrMsg );
   else
      fprintf( stderr, "%s", ErrMsg );
      
   return;
}


/****h* NullFound() [3.0] ********************************************
*
* NAME
*    NullFound()
*
* DESCRIPTION
*    Inform the User that we have an internal AmigaTalk problem.
**********************************************************************
*
*/

PUBLIC BOOL NullFound( char *where )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_NULL_POINTER_RERR ), where );
   
   SetReqButtons( DefaultButtons );
   
   if (Handle_Problem( ErrMsg, FATAL_ERROR, NULL ) == 0)
      return( TRUE );  // Continue pressed
   else
      return( FALSE ); // Abort pressed
}

/****h* InternalProblem() [3.0] **************************************
*
* NAME
*    InternalProblem()
*
* DESCRIPTION
*    Inform the User that we have an internal AmigaTalk problem.
**********************************************************************
*
*/

PUBLIC void InternalProblem( char *msg )
{
   UserInfo( msg, InternalError );

   return;
}

/* cant_happen - report that an impossible condition has occured */

PUBLIC int cant_happen( int n )
{
   IMPORT FILE *TraceFile;
   
   IMPORT void ShutDown( void );

   char t[80] = { 0, }, *s;

   sprintf( &t[0], "%33.02s ", PgmName );
   StringCat( t, FATAL_ERROR );

   // Warning!  Warning!  Danger Will Robinson!!

   if (n > LAST_KNOWN_ERR_STRING || n < 0)
      n = LAST_KNOWN_ERR_STRING;
      
   s = ch_errstrs[n]; // Initialized in CatalogCantHappen(), (Setup.c)

   if (TraceFile && traceByteCodes == TRUE)
      {
      indentTrace();

      fprintf( TraceFile, RErrsCMsg( MSG_FMT_RE_CANT_HAPPEN_RERR ), s );
      }

   UserInfo( s, &t[0] );

   ShutDown();       // Located in Setup.c file

   exit( n + 20 );
}


/* ---------- For User Program Problems: -----------------------------
** Most of these types of problems will be sent to the Status
** Window display:
*/

PUBLIC int ChkArgCount( int need, int numargs, int primnumber )
{
   IMPORT char *errp;

   IMPORT const int MAX_PRIM_BUFFER_SIZE;
    
   if (need != numargs)
      {
      sprintf( ErrMsg, RErrsCMsg( MSG_PR_ARGCNT_ERR_RERR ),
                       numargs, primnumber 
             );

      StringNCopy( errp, ErrMsg, MAX_PRIM_BUFFER_SIZE - 1 );   

      UserInfo( ErrMsg, RErrsCMsg( MSG_RQTITLE_ARGCNT_ERR_RERR ) );

      return( -1 );
      }
   else
      return( 0 );
}

/****i* _DisplayUPgmMsg() [3.0] **************************************
*
* NAME
*    _DisplayUPgmMsg()
*
* DESCRIPTION
*    Send the message to whatever's open.
**********************************************************************
*
*/

SUBFUNC void _DisplayUPgmMsg( char *msg )
{
   if (ATWnd) // != NULL)
      UserInfo( msg, UserPgmError );

   if (st_console) // != NULL)
      {
      APrint( msg );
      }
   else
      {
      fprintf( stderr, "%s", msg );
      }
      
   return;
}

/****h* OutOfRange() [3.0] *******************************************
*
* NAME
*    OutOfRange()
*
* DESCRIPTION
*    Inform the User that a number was out of range.
**********************************************************************
*
*/

PUBLIC void OutOfRange( char *item, int lower, int upper, int actual )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_OUTOF_RANGE_RERR ), 
                    actual, lower, upper, item
          );

   _DisplayUPgmMsg( ErrMsg );
   
   return;
}

/****h* FoundNullPtr() [3.0] *****************************************
*
* NAME
*    FoundNullPtr()
*
* DESCRIPTION
*    Inform the User that a NULL Pointer was encountered.
**********************************************************************
*
*/

PUBLIC void FoundNullPtr( char *funcName )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_FOUND_NULLPTR_RERR ), funcName );

   _DisplayUPgmMsg( ErrMsg );
   
   return;
}

/****h* AlreadyOpen() [3.0] ******************************************
*
* NAME
*    AlreadyOpen()
*
* DESCRIPTION
*    Inform the User that an object is already open.
**********************************************************************
*
*/

PUBLIC void AlreadyOpen( char *whatIs )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_ALREADYOPEN_RERR ), whatIs );
   
   _DisplayUPgmMsg( ErrMsg );
   
   return;
}

/****h* ObjectWasZero() [3.0] ****************************************
*
* NAME
*    ObjectWasZero()
*
* DESCRIPTION
*    Inform the User that an object was NULL.
**********************************************************************
*
*/

PUBLIC void ObjectWasZero( char *whatIs )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_ZERO_OBJ_RERR ), whatIs );
   
   _DisplayUPgmMsg( ErrMsg );
   
   return;
}

// ---------- For User (Bonehead!) Problems: -------------------------

/****i* _DisplayUserMsg() [3.0] **************************************
*
* NAME
*    _DisplayUserMsg()
*
* DESCRIPTION
*    Send the message to whatever's open.
**********************************************************************
*
*/

SUBFUNC void _DisplayUserMsg( char *msg )
{
   if (ATWnd) // != NULL)
      UserInfo( msg, UserProblem );

   if (st_console) // != NULL)
      APrint( msg );
   else
      fprintf( stderr, "%s", msg );
      
   return;
}


PUBLIC void CheckToolType( char *whichOne )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_CHKTOOL_RERR ), whichOne );
      
   _DisplayUserMsg( ErrMsg );
}

PUBLIC void NotFound( char *what )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_NOT_FOUND_RERR ), what );
   
   _DisplayUserMsg( ErrMsg );
   
   return;
}

PUBLIC void InvalidItem( char *what )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_ASK_INVALID_RERR ), what );
   
   _DisplayUserMsg( ErrMsg );
   
   return;
}
     
// ---------- For System Problems: -----------------------------------

/****i* _DisplaySysMsg() [3.0] ***************************************
*
* NAME
*    _DisplaySysMsg()
*
* DESCRIPTION
*    Send the message to whatever's open.
**********************************************************************
*
*/

SUBFUNC void _DisplaySysMsg( char *msg, char *title )
{
   if (ATWnd) // != NULL)
      UserInfo( msg, title );

   if (st_console) // != NULL)
      APrint( msg );
   else
      fprintf( stderr, "%s", msg );
      
   return;
}

/****h* MemoryOut() [3.0] ********************************************
*
* NAME
*    MemoryOut()
*
* DESCRIPTION
*    Inform the User that we ran out of memory & where it happened.
**********************************************************************
*
*/

PUBLIC void MemoryOut( char *whereAt )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_NO_MEMORY_RERR ), whereAt );

   _DisplaySysMsg( ErrMsg, AllocProblem );

   return;
}

/****h* Unsupported() [3.0] ******************************************
*
* NAME
*    Unsupported()
*
* DESCRIPTION
*    Inform the User that we found an unsupported operation.
**********************************************************************
*
*/

PUBLIC void Unsupported( char *what, char *operation )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_NO_SUPPORT_RERR ), 
                    what, operation
          );
   
   _DisplaySysMsg( ErrMsg, SystemProblem );
   
   return;
}

/****i* _Cannot() [3.0] **********************************************
*
* NAME
*    _Cannot()
*
* DESCRIPTION
*    Inform the User that we could not do something.
**********************************************************************
*
*/

SUBFUNC void _Cannot( char *what, char *forName )
{
   sprintf( ErrMsg, RErrsCMsg( MSG_FMT_RE_CANNOT_RERR ), 
                    what, forName
          );

   _DisplaySysMsg( ErrMsg, AllocProblem );   

   return;
}

/****h* CannotOpenFile() [2.4] ***************************************
*
* NAME
*    CannotOpenFile()
*
* DESCRIPTION
*    Inform the User that we could not open a file.
**********************************************************************
*
*/

PUBLIC void CannotOpenFile( char *fileName )
{
   _Cannot( RErrsCMsg( MSG_RE_OPENFILE_RERR ), fileName );

   return;
}

/****h* CannotCreatePort() [3.0] *************************************
*
* NAME
*    CannotCreatePort()
*
* DESCRIPTION
*    Inform the User that we could not create a Port.
**********************************************************************
*
*/

PUBLIC void CannotCreatePort( char *portType )
{
   _Cannot( RErrsCMsg( MSG_RE_CREATEPORT_RERR ), portType );

   return;
}

/****h* CannotCreateStdIO() [3.0] ************************************
*
* NAME
*    CannotCreateStdIO()
*
* DESCRIPTION
*    Inform the User that we could not create a StdIO
**********************************************************************
*
*/

PUBLIC void CannotCreateStdIO( char *forWho )
{
   _Cannot( RErrsCMsg( MSG_RE_CREATESTDIO_RERR ), forWho );

   return;
}

/****h* CannotCreateExtIO() [3.0] ************************************
*
* NAME
*    CannotCreateExtIO()
*
* DESCRIPTION
*    Inform the User that we could not create an ExtIO
**********************************************************************
*
*/

PUBLIC void CannotCreateExtIO( char *forWho )
{
   _Cannot( RErrsCMsg( MSG_RE_CREATEEXTIO_RERR ), forWho );

   return;
}

/****h* CannotOpenDevice() [3.0] *************************************
*
* NAME
*    CannotOpenDevice()
*
* DESCRIPTION
*    Inform the User that we could not open a Device.
**********************************************************************
*
*/

PUBLIC void CannotOpenDevice( char *deviceType )
{
   _Cannot( RErrsCMsg( MSG_RE_OPENDEVICE_RERR ), deviceType );
   
   return;
}

/****h* CannotCreate() [3.0] *****************************************
*
* NAME
*    CannotCreate()
*
* DESCRIPTION
*    Inform the User that we could not create something.
**********************************************************************
*
*/

PUBLIC void CannotCreate( char *what )
{
   _Cannot( RErrsCMsg( MSG_RE_CREATE_STR_RERR ), what );
      
   return;
}

/****h* CannotSetup() [3.0] ******************************************
*
* NAME
*    CannotSetup()
*
* DESCRIPTION
*    Inform the User that we could not setup something.
**********************************************************************
*
*/

PUBLIC void CannotSetup( char *what )
{
   _Cannot( RErrsCMsg( MSG_RE_SETUP_STR_RERR ), what );
      
   return;
}

/****h* NotOpened() [3.0] ********************************************
*
* NAME
*    NotOpened()
*
* DESCRIPTION
*    Inform the User that we could not open something.
**********************************************************************
*
*/

SUBFUNC void _NotOpened( char *what )
{
   _Cannot( RErrsCMsg( MSG_RE_OPEN_STR_RERR ), what );

   return;
}

PUBLIC void NotOpened( int what )
{
   switch (what)
      {
      case 0: // Screen
         _NotOpened( RErrsCMsg( MSG_RE_ASCREEN_RERR ) );
         
         break;
         
      case 1: // Window
         _NotOpened( RErrsCMsg( MSG_RE_AWINDOW_RERR ) );

         break;

      case 2: // File
         _NotOpened( RErrsCMsg( MSG_RE_AFILE_RERR ) );
         
         break;
         
      case 3: // Image File
         _NotOpened( RErrsCMsg( MSG_RE_ANIMAGEFILE_RERR ) );
         
         break;
        
      case 4: // Library
         _NotOpened( RErrsCMsg( MSG_RE_ALIBRARY_RERR ) );
         
         break;

      case 5: // RXSNAME
         _NotOpened( RXSNAME );
         
         break;

      case 6: // status Window
         _NotOpened( RErrsCMsg( MSG_RE_STATUSWINDOW_RERR ) );
         
         break;
          
      case 7: // Disk font
         _NotOpened( RErrsCMsg( MSG_RE_ADISKFONT_RERR ) );
         
         break;
          
      default:
         _NotOpened( RErrsCMsg( MSG_RE_ANOBJECT_RERR ) );
         
         break;
      }

   return;
}

/* ------------------ END of ReportErrs.c file! ------------------------ */
