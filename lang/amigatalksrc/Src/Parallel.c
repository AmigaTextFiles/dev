/****h* AmigaTalk/Parallel.c [3.0] *************************************
*
* NAME
*    Parallel.c
*
* DESCRIPTION
*    Amigatalk command wrappers for the parallel device.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
*    07-Mar-2001 - Added testing methods to primitives, since the
*                  message passing overhead of doing 16r0FFFFFFF loops
*                  eats up more than 6 MB of memory!
*
*    05-Mar-2001 - Added PARF_SHARED to opening device code, since
*                  the parallel.device will NOT open without it!
*
*    22-Feb-2001 - Added CleanDevFromList() function.
*
* NOTES
*    $VER: AmigaTalk/Src/Parallel.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>

#include <AmigaDOSErrs.h>

#include <hardware/cia.h>
#include <devices/parallel.h>

#include <resources/cia.h>      // for CIAANAME & CIABNAME
#include <resources/misc.h>

#include <dos/dos.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/Misc_protos.h>

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/misc.h>

IMPORT struct ExecIFace *IExec;

PUBLIC struct MiscIFace *IMisc;

#endif

#include "Constants.h"
#include "Object.h"

#include "FuncProtos.h"

#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *PrintArgTypeError( int primnumber );

// In Global.c: ----------------------------

IMPORT int    debug;

IMPORT UBYTE *AllocProblem;
IMPORT UBYTE *UserProblem;
IMPORT UBYTE *SystemProblem;

IMPORT UBYTE *ErrMsg;

// ------------------------------------------------------------------

PUBLIC  struct Library    *MiscBase;

PRIVATE struct MsgPort    *mp = NULL;
PRIVATE struct IOExtPar   *io = NULL;

PRIVATE ULONG  WaitParMask  = 0L;

PUBLIC  UBYTE  MiscName[32] = { 0, }; // Visible to CatalogParallel();

// ---- Misc Resource functions: -------------------------------------

/****i* FlushDevice() ************************************************
*
* NAME
*    FlushDevice()
*
* DESCRIPTION 
*    Remove the named resource from the ExecBase->DeviceList.
**********************************************************************
*
*/

SUBFUNC void FlushDevice( char *name )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  endif

   struct Device *devptr = NULL;
   
   Forbid();

#    ifdef  __SASC
     if ((devptr = (struct Device *) FindName( &SysBase->DeviceList, name )))
        RemDevice( devptr );
#    else
     if ((devptr = (struct Device *) FindName( &((struct ExecBase *) IExec->Data.LibBase)->DeviceList, name )))
        RemDevice( devptr );
#    endif
         
   Permit();
   
   return;
}

PRIVATE BOOL GotMiscPort = FALSE;
PRIVATE BOOL GotMiscBits = FALSE;

/****i* DeallocMisc() ************************************************
*
* NAME
*    DeallocMisc()
*
* DESCRIPTION 
*    Free the misc resources & call FlushDevice().
**********************************************************************
*
*/

SUBFUNC void DeallocMisc( char *name )
{
   if (GotMiscBits == TRUE)
      {
      GotMiscBits = FALSE;
      FreeMiscResource( MR_PARALLELBITS );
      }
   
   if (GotMiscPort == TRUE)
      {
      GotMiscPort = FALSE;
      FreeMiscResource( MR_PARALLELPORT );
      }
   
   FlushDevice( name );
   
   return;
}

/****i* CleanResourceFromList() **************************************
*
* NAME
*    CleanResourceFromList()
*
* DESCRIPTION 
*    Remove the named resource from the system list if it's open 
*    count is zero.
**********************************************************************
*
*/

SUBFUNC int CleanResourceFromList( char *res_name )
{
   struct List    *DevListPtr = NULL;
   struct Library *CurrentDLR = NULL;

   char  *nm    = NULL;
   int    rval  = 0; // Success = 0, < 0 means Failure of some kind.

   Forbid();
#    ifdef  __SASC
     DevListPtr = &SysBase->ResourceList; 
#    else 
     DevListPtr = &((struct ExecBase *) IExec->Data.LibBase)->ResourceList; 
#    endif

     CurrentDLR = (struct Library *) DevListPtr->lh_Head;

     while (CurrentDLR) // != NULL)
        {
        nm = CurrentDLR->lib_Node.ln_Name;

        if (StringComp( nm, res_name ) == 0)
           {
           if (CurrentDLR->lib_OpenCnt != 0)
              {
              // A Program is still using the resource:
              rval = -1;
              break;
              }
           else // Resource is NOT being used, Remove() it:
              {
              // Remove the Resource from the System List:
              Remove( &CurrentDLR->lib_Node );
              break;
              }              
           }

        CurrentDLR = (struct Library *) ((struct Library *) 
                                         CurrentDLR)->lib_Node.ln_Succ;
        }

   Permit();

   return( rval );
}

/****i* AllocMisc() **************************************************
*
* NAME
*    AllocMisc()
*
* DESCRIPTION 
*    Grab the misc resources for our use with the Parallel port.
**********************************************************************
*
*/

SUBFUNC int AllocMisc( char *name )
{
   UBYTE *owner = NULL;
   int    rval  = 0; // Success = 0, < 0 means Failure of some kind.

   if (CleanResourceFromList( MISCNAME ) < 0)
      {
      rval = -1;

      if (debug != 0)
         fprintf( stderr, ParCMsg( MSG_PA_MISC_REMOVE_PAR ) );
      }

   if (!(MiscBase= (struct Library *) OpenResource( MISCNAME ))) // == NULL)
      {
      rval        = -2;
      GotMiscPort = FALSE;
      GotMiscBits = FALSE;
      goto LeaveAllocPort;
      }
#  ifdef __amigaos4__
   else
      {
      if (!(IMisc = (struct MiscIFace *) GetInterface( MiscBase, "main", 1, NULL )))
         {
         rval        = -3;
         GotMiscPort = FALSE;
         GotMiscBits = FALSE;

         goto LeaveAllocPort;
	 }
      }
#  endif

   if (!(owner = (UBYTE *) AllocMiscResource( MR_PARALLELPORT, name ))) // == NULL)
      {
      rval        = -3;
      GotMiscPort = FALSE;
      GotMiscBits = FALSE;

      FlushDevice( name );

#     ifdef __amigaos4__
      if (IMisc)
         DropInterface( (struct Interface *) IMisc );
#     endif
      goto LeaveAllocPort;
      }

   GotMiscPort = TRUE;

   if (!(owner = (UBYTE *) AllocMiscResource( MR_PARALLELBITS, name ))) // == NULL)
      {
      rval        = -4;
      GotMiscPort = FALSE;
      GotMiscBits = FALSE;

      FreeMiscResource( MR_PARALLELPORT );
      FlushDevice( name );

#     ifdef __amigaos4__
      if (IMisc)
         DropInterface( (struct Interface *) IMisc );
#     endif

      goto LeaveAllocPort;
      }

   GotMiscBits = TRUE;

LeaveAllocPort:

   return( rval );
}

// -------------------------------------------------------------------

PUBLIC char *errors[12] = { NULL, }; // Visible to CatalogParallel();
   
/****i* TranslateErrorNumber() [1.6] *********************************
*
* NAME
*    TranslateErrorNumber()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC char *TranslateErrorNumber( int errnum )
{
   if (errnum <= 10 && errnum >= 0 )
      return( errors[ errnum ] );
   else
      {
      sprintf( ErrMsg, ParCMsg( MSG_PAERR_BADNUMBER_PAR ), errnum );
      
      return( ErrMsg );
      }
}

/****i* CloseParallel() [1.6] ****************************************
*
* NAME
*    CloseParallel()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void CloseParallel( void )
{
   DeallocMisc( &MiscName[0] );

#  ifdef __amigaos4__
   if (IMisc)
      DropInterface( (struct Interface *) IMisc );
#  endif

   if (io) // != NULL)
      {
      CloseDevice(     (struct IORequest *) io );
      DeleteIORequest( (struct IORequest *) io );
      io = NULL;
      }

   if (mp) // != NULL)
      {
      DeletePort( mp );
      mp = NULL;
      }

   return;
}

/****i* CleanDevFromList() [1.6] *************************************
*
* NAME
*    CleanDevFromList()
*
* DESCRIPTION
*    Remove a device from the system device list if it's open count
*    is zero.
**********************************************************************
*
*/

SUBFUNC int CleanDevFromList( char *devname )
{
   struct List    *DevListPtr = NULL;
   struct Library *CurrentDvc = NULL;
   char           *nm         = NULL;
   int             rval       = 0;

   Forbid();

#    ifdef  __SASC
     DevListPtr = &SysBase->DeviceList;
#    else
     DevListPtr = &((struct ExecBase *) IExec->Data.LibBase)->DeviceList;
#    endif

     CurrentDvc = (struct Library *) DevListPtr->lh_Head;

     while (CurrentDvc) // != NULL)
        {
        nm = CurrentDvc->lib_Node.ln_Name;

        if (StringComp( nm, devname ) == 0)
           {
           if (CurrentDvc->lib_OpenCnt != 0)
              {
              // A Program is still using the device:
              rval = -1;
              break;
              }
           else // Device is NOT being used, Remove() it:
              {
              // Remove the device from the System List:
              Remove( &CurrentDvc->lib_Node );
              rval = 0;

              break;
              }              
           }

        // Point to next device list entry
        CurrentDvc = (struct Library *) ((struct Library *) 
                                         CurrentDvc)->lib_Node.ln_Succ;
        }

OpenTheResource:

   Permit();

   return( rval );
}


/* flags == PARF_ACKMODE | PARF_SLOWMODE; No sharing. */

/****i* OpenParallel() [1.6] *****************************************
*
* NAME
*    OpenParallel()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC int OpenParallel( int flags ) 
{
   int result = 0;

   if (!(mp = (struct MsgPort *) CreatePort( NULL, 0 ))) // == NULL)
      {
      result = 8;

      if (debug != 0)
         CannotCreatePort( ParCMsg( MSG_PARALLEL_CLASSNAME_PAR ) );

      goto ExitOpenParallel;
      }

   if (!(io = (struct IOExtPar *) CreateIORequest( mp, sizeof( struct IOExtPar ) ))) // == NULL)
      {
      if (debug != 0)
         CannotCreateExtIO( ParCMsg( MSG_PARALLEL_CLASSNAME_PAR ) );
   
      result = 9;
      DeletePort( mp );

      goto ExitOpenParallel;
      }

   // PARF_SHARED is required for the device to open!
   io->io_ParFlags = PARF_SHARED;
/*
   if (CleanResourceFromList( CIAANAME ) < 0)
      {
      if (debug != 0)
         fprintf( stderr, "%s in use!\n", CIAANAME );
      }
   
   if (CleanResourceFromList( CIABNAME ) < 0)
      {
      if (debug != 0)
         fprintf( stderr, "%s in use!\n", CIABNAME );
      }
   
   if (CleanResourceFromList( MISCNAME ) < 0)
      {
      if (debug != 0)
         fprintf( stderr, "%s in use!\n", MISCNAME );
      }
   
   if (CleanDevFromList( PARALLELNAME ) < 0)
      {
      if (debug != 0)
         fprintf( stderr, "%s in use!\n", PARALLELNAME );

//      (void) CleanDevFromList( "printer.device" );
//      (void) CleanDevFromList( PARALLELNAME );     // Try again! 
      }
//   else 
//      (void) CleanDevFromList( "printer.device" );
*/

   io->io_ParFlags |= flags; // PARF_ACKMODE | PARF_SLOWMODE

   if (OpenDevice( "parallel.device", 0L, (struct IORequest *) io, 0 ) != 0)
      {
      if (debug != 0)
         CannotOpenDevice( "parallel.device" ); // PARALLELNAME );

      sprintf( ErrMsg, ParCMsg( MSG_FMT_PA_ODEVICE_PAR ), io->IOPar.io_Error );

      UserInfo( ErrMsg, SystemProblem );
      
      result = 10; // result = IoErr(); // ????
      DeleteIORequest( (struct IORequest *) io );
      DeletePort( mp );
      }

   // Might not be necessary (or possible!):
   if (AllocMisc( &MiscName[0] ) < 0)
      {
      if (debug != 0)
         fprintf( stderr, ParCMsg( MSG_PA_MISC_ALLOC_PAR ) );
      }
         
   WaitParMask = SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D | 1L << mp->mp_SigBit;

ExitOpenParallel:

   return( result ); 
}

/****i* GetStatus() [1.6] ********************************************
*
* NAME
*    GetStatus()
*
* DESCRIPTION
*
* NOTES
*    The returned status has the following meaning:
*
*    BIT:  ACTIVE:  FUNCTION:
*
*     0      HIGH   Printer Busy toggle (offline).
*     1      HIGH   Paper out.
*     2      HIGH   Printer Select.
*     3      ----   Read = 0, Write = 1
*     4-7    ----   Reserved.
**********************************************************************
*
*/

METHODFUNC UBYTE GetStatus( void )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Command = PDCMD_QUERY;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );
         return( io->io_Status );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( io->io_Status );
}

/****i* ReadData() [1.6] *********************************************
*
* NAME
*    ReadData()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC int ReadData( int howmuch, char *readbuffer )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Length  = howmuch;
   io->IOPar.io_Data    = readbuffer;
   io->IOPar.io_Command = CMD_READ;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );

         return( (int) io->IOPar.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( (int) io->IOPar.io_Actual );
}

/****i* WriteData() [1.6] ********************************************
*
* NAME
*    WriteData()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC int WriteData( int howmuch, char *writebuffer )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Length  = howmuch;
   io->IOPar.io_Data    = writebuffer;
   io->IOPar.io_Command = CMD_WRITE;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );

         return( (int) io->IOPar.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( (int) io->IOPar.io_Actual );
}

/****i* ResetPort() [1.6] ********************************************
*
* NAME
*    ResetPort()
*
* DESCRIPTION
*    Send CMD_RESET to the Parallel device
**********************************************************************
*
*/

METHODFUNC int ResetPort( void )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Command = CMD_RESET;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );

         return( (int) io->IOPar.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( (int) io->IOPar.io_Actual );
}

/****i* FlushPort() [1.6] ********************************************
*
* NAME
*    FlushPort()
*
* DESCRIPTION
*    Send a CMD_FLUSH to the parallel.device.
**********************************************************************
*
*/

METHODFUNC int FlushPort( void )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Command = CMD_FLUSH;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );

         return( (int) io->IOPar.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( (int) io->IOPar.io_Actual );
}

/****i* StopPort() [1.6] *********************************************
*
* NAME
*    StopPort()
*
* DESCRIPTION
*    Send a CMD_STOP to the parallel.device.
**********************************************************************
*
*/

METHODFUNC int StopPort( void )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Command = CMD_STOP;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );

         return( (int) io->IOPar.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( (int) io->IOPar.io_Actual );
}

/****i* StartPort() [1.6] ********************************************
*
* NAME
*    StartPort()
*
* DESCRIPTION
*    Send a CMD_START to the parallel.device.
**********************************************************************
*
*/

METHODFUNC int StartPort( void )
{
   ULONG temp = 0L;
   
   io->IOPar.io_Command = CMD_START;

   SendIO( (struct IORequest *) io );

   while (1)
      {
      temp = Wait( WaitParMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if (CheckIO( (struct IORequest *) io ))
         {
         WaitIO( (struct IORequest *) io );

         return( (int) io->IOPar.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) io );
   WaitIO(  (struct IORequest *) io );

   return( (int) io->IOPar.io_Actual );
}

PRIVATE struct IOPArray TermChars = { 0, };

/****i* SetTermChars() [1.6] *****************************************
*
* NAME
*    SetTermChars()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void SetTermChars( ULONG *terminators )
{
   TermChars.PTermArray0 = *terminators;

   terminators++;

   TermChars.PTermArray1 = *terminators;

   return;   
}

/****i* SetPortParameters() [1.6] ************************************
*
* NAME
*    SetPortParameters()
*
* DESCRIPTION
*    Change the parallel.device port parameters.
*
* NOTES
*    parms can have any of the following values:
*
*    PARF_EOFMODE  - check I/O against the TermChars array.
*    PARF_ACKMODE  - use ACK handshaking.
*    PARF_FASTMODE - Send out data as long as BUSY is low. 
*    PARF_SLOWMODE - For transfers to slow printers.
*    PARF_SHARED   - Allow sharing of the parallel device.
**********************************************************************
*
*/

METHODFUNC int SetPortParameters( int parms )
{
   if (CheckIO( (struct IORequest *) io ) == 0)
      AbortIO( (struct IORequest *) io );

   WaitIO( (struct IORequest *) io );
      
   (void) StopPort();
   (void) ResetPort();

   CloseParallel();
         
   if (OpenParallel( parms ) < 0)
      {
      if (debug != 0)
         fprintf( stderr, ParCMsg( MSG_PAERR_NO_REOPEN_PAR ) );

      return( -1 );
      }

   return( 0 );
}

#ifdef  __SASC
IMPORT struct CIA ciaa; // $BFE001
IMPORT struct CIA ciab; // $BFD000
#else
// This is probably bogus:
struct CIA ciaa; // $BFE001 
struct CIA ciab; // $BFD000
#endif

/****i* SetPortCtrlDirection() [1.6] *********************************
*
* NAME
*    SetPortCtrlDirection()
*
* DESCRIPTION
*    Set the Parallel Port Control bit directions.
**********************************************************************
*
*/

SUBFUNC int SetPortCtrlDirection( int pbits )
{
   UBYTE outbits = (pbits & 0x07);
   
   ciab.ciaddra  = outbits;

   return( (int) outbits );
}

/****i* SetPortBitsDirection() [1.6] *********************************
*
* NAME
*    SetPortBitsDirection()
*
* DESCRIPTION
*    Set the Parallel Port Data bit directions.
**********************************************************************
*
*/

METHODFUNC int SetPortBitsDirection( int pbits )
{
   UBYTE outbits = (pbits & 0xFF );
   
   ciaa.ciaddrb  = outbits;
   
   return( (int) outbits );
}

/****i* WritePortControl() [1.6] *************************************
*
* NAME
*    WritePortControl()
*
* DESCRIPTION
*    Write Parallel port control bits to the hardware.
**********************************************************************
*
*/

METHODFUNC int WritePortControl( int ctrlbits )
{
   UBYTE outbits = (ctrlbits & 0x07);

   (void) SetPortCtrlDirection( 0x07 );
   
   ciab.ciapra   = outbits;

   return( (int) outbits );
}
    
/****i* ReadPortControl() [1.6] **************************************
*
* NAME
*    ReadPortControl()
*
* DESCRIPTION
*    Read the Parallel port control bits.
**********************************************************************
*
*/

METHODFUNC int ReadPortControl( int ctrlbitmask )
{
   UBYTE inbits;
   
   (void) SetPortCtrlDirection( 0 );

   inbits = ciab.ciapra & ctrlbitmask;
    
   return( (int) inbits );                         
}

/****i* testToggleCtrlBits() [1.6] ***********************************
*
* NAME
*    testToggleCtrlBits()
*
* DESCRIPTION
*    Change all the control bits from 0 to 1 for numloops times.
*    a value of EA60 (60,000) for numloops will run for over an 
*    hour on a 25MHz 68040, since each loop is around 60mSecs long.
**********************************************************************
*
*/

METHODFUNC void testToggleCtrlBits( int numloops )
{
   int i;
   
   (void) FlushPort();
   (void) StopPort();
   (void) ResetPort();
   (void) StartPort();
   
   for (i = 0; i < numloops; i++)
      {
      (void) WritePortControl( 0 );
      Delay( 1 );

      (void) WritePortControl( 0xFF );
      Delay( 1 );
      }

   return;
}

/****i* WriteDataBits() [1.6] ****************************************
*
* NAME
*    WriteDataBits()
*
* DESCRIPTION
*    Write data to the parallel hardware directly.  Used only by
*    testToggleDataBits().
**********************************************************************
*
*/

SUBFUNC int WriteDataBits( UBYTE data )
{
   (void) SetPortBitsDirection( 0xFF );
   
   ciaa.ciaprb = data;
   
   return( data );
}

/****i* testToggleDataBits() [1.6] ***********************************
*
* NAME
*    testToggleDataBits()
*
* DESCRIPTION
*    Change all the data bits from 0 to 1 for numloops times.
*    a value of EA60 (60,000) for numloops will run for over an 
*    hour on a 25MHz 68040, since each loop is around 60mSecs long.
**********************************************************************
*
*/

METHODFUNC void testToggleDataBits( int numloops )
{
   int  i;

   (void) FlushPort();
   (void) StopPort();
   (void) ResetPort();
   (void) StartPort();
   
   for (i = 0; i < numloops; i++)
      {
      (void) WriteDataBits( 0x55 );
      Delay( 1 );

      (void) WriteDataBits( 0xAA );
      Delay( 1 );
      }

   return;
}

/****h* HandleParallel() [1.6] ***************************************
*
* NAME
*    HandleParallel()
*
* DESCRIPTION
*    Translate AmigaTalk primitives (224) to Parallel Port commands.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleParallel( int numargs, OBJECT **args )
{
   IMPORT OBJECT *o_nil;
   IMPORT OBJECT *o_true;
   IMPORT OBJECT *o_false;

   OBJECT *rval = o_nil;
   int     temp = 0;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 224 );

      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0: // close
         CloseParallel();
         break;
      
      case 1: // open: paraFlags
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            {
            temp = OpenParallel( int_value( args[1] ) ); 
            rval = AssignObj( new_int( temp ) );
            }
            
         break;

      case 2: // <primitive 2 errNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            {
            rval = AssignObj( new_str( TranslateErrorNumber( int_value( args[1] ))));
            }
            
         break;  

      case 3: // status
         rval = AssignObj( new_int( GetStatus() ) );
         break;

      case 4: // resetPort
         rval = AssignObj( new_int( ResetPort() ) );
         break;

      case 5: // flushPort         
         rval = AssignObj( new_int( FlushPort() ) );
         break;

      case 6: // stopPort
         rval = AssignObj( new_int( StopPort() ) );
         break;

      case 7: // startPort
         rval = AssignObj( new_int( StartPort() ) );
         break;

      case 8: // setPortParametersTo: newParms
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else   
            rval = AssignObj( new_int( SetPortParameters( int_value( args[1] ))));
         
         break;
       
      case 9: // readThisMany: numChars
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else   
            {
            int   num  = int_value( args[1] );
            char *tbuf = (char *) AT_AllocVec( num + 1,
                                               MEMF_CLEAR | MEMF_ANY, 
                                               "ParallelBuff", TRUE 
                                             );

            if (!tbuf) // == NULL)
               {
               if (debug != 0)
                  fprintf( stderr, ParCMsg( MSG_FMT_PA_NOTEMP_PAR ),
                                   num + 1 
                         );
                  
               return( rval = o_nil );
               }
                           
            temp = ReadData( num, tbuf );

            if (temp == num)
               rval = AssignObj( new_str( tbuf ));
            else
               {
               if (debug != 0)
                  fprintf( stderr, ParCMsg( MSG_PAERR_WRONG_AMT_PAR ) ); 
               }

            AT_FreeVec( tbuf, "ParallelBuff", TRUE );
            }
         
         break;               

      case 10: // writeToPort: aString thisLong: numChars
         if (is_integer( args[1] ) == FALSE || !is_string( args[2] ))
            (void) PrintArgTypeError( 224 );
         else
            {
            temp = WriteData( int_value( args[1] ), 
                              string_value( (STRING *) args[2] )
                            );

            rval = AssignObj( new_int( temp ) );
            }
            
         break;    

      case 11: // setTerminatorsTo: aString
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            {
            char  *tch   = string_value( (STRING *) args[1] );

            ULONG  terms = tch[0] << 24 + tch[1] << 16 
                                        + tch[2] << 8
                                        + tch[3];
                                        
            SetTermChars( &terms );
            }

         break;    

      case 12: // setPortDirectionAtomic: rwFlag
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            rval = AssignObj( new_int( SetPortBitsDirection( int_value( args[1] ))));

         break;    

      case 13: // sendPortControlBits: newBits
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            rval = AssignObj( new_int( WritePortControl( int_value( args[1] ))));

         break;    

      case 14: // readControlBitsMaskedBy: ctrlMask
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            rval = AssignObj( new_int( ReadPortControl( int_value( args[1] ))));

         break;    
      
      case 15: // testToggleCtrlBits: loopCount
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            testToggleCtrlBits( int_value( args[1] ) );
   
         break;
         
      case 16: // testToggleDataBits: loopCount
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 224 );
         else
            testToggleDataBits( int_value( args[1] ) );
   
         break;
         
      default:
         (void) PrintArgTypeError( 224 );
         break;
      }

   return( rval );
}

/* ---------------------- END of Parallel.c file! ----------------- */
