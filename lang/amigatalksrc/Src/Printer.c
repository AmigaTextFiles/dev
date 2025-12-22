/****h* AmigaTalk/Printer.c [3.0] *************************************************
*
* NAME
*    Printer.c
*
* DESCRIPTION
*    Implement AmigaTalk control over printer.device.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES 
*    Functional Interface:
*       PUBLIC OBJECT *HandlePrinter( int numargs, OBJECT **args );
*
*    $VER: AmigaTalk:Src/Printer.c 3.0 (25-Oct-2004) by J.T Steichen
***********************************************************************************
*
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/exec.h>

#include <AmigaDOSErrs.h>

#include <devices/printer.h>
#include <devices/prtbase.h> // For obtaining information about the printer.

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/alib_protos.h>

#else

# define __USE_INLINE__
# include <proto/exec.h>

IMPORT struct ExecIFace *IExec;

#endif

#include <proto/locale.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "IStructs.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

// -------------- From Global.c: -------------------------------------------

IMPORT UBYTE  *SystemProblem;
IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *UserPgmError;

IMPORT UBYTE  *ErrMsg;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT OBJECT *o_nil, o_true, o_false;

// -------------------------------------------------------------------------

// From TagFuncs.c:

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

// -------------------------------------------------------------------------

//#ifndef __amigaos4__

union myPrinterIO {

   struct IOStdReq     ios;
   struct IODRPTagsReq iodrpt; // Longest structure.
   struct IODRPReq     iodrp; 
   struct IOPrtCmdReq  iopc;
   struct IOPrtErrReq  ioperr;

};
//#endif

struct pstruct {

   union  myPrinterIO *ps_pio;
   struct MsgPort     *ps_MsgPort;
   int                 ps_ErrorNum;

};

// Printer-specific variables:

PRIVATE ULONG WaitPrtMask   = 0L;
PRIVATE ULONG PrinterSignal = 0L;

PRIVATE struct PrinterData         *pdata  = NULL;
PRIVATE struct PrinterExtendedData *pedata = NULL;

PRIVATE char *pname         = NULL; // Irrational values!!
PRIVATE int   prtMaxColumns = 0;
PRIVATE int   prtCharSets   = 0;
PRIVATE int   prtNumRows    = 0;
PRIVATE int   prtMaxXDots   = 0;
PRIVATE int   prtMaxYDots   = 0;
PRIVATE int   prtXDotsInch  = 0;
PRIVATE int   prtYDotsInch  = 0;

// ---------------------------------------------------------------------

/****i* GetPrinterClass() [1.9] **************************************
*
* NAME
*    GetPrinterClass()
*
* DESCRIPTION
*    Translate the ped_PrinterClass number into a descriptive string.
**********************************************************************
*
*/

PUBLIC char *PrtClasses[] = {  // Visible to CatalogPrinter();

         // ped_PrinterClass values:
   NULL, // PPC_BWALPHA    == 0x00
   NULL, // PPC_BWGFX      == 0x01
   NULL, // PPC_COLORALPHA == 0x02
   NULL, // PPC_COLORGFX   == 0x03
   NULL, // PPCF_EXTENDED  == 0x04
   NULL, 
   NULL,
   NULL,
   NULL, // PPCF_NOSTRIP   == 0x08
   NULL
};

PRIVATE char *GetPrinterClass( int classnum )
{
   return( PrtClasses[ classnum ] );
}

/****i* GetPrinterColorClass() [1.9] *********************************
*
* NAME
*    GetPrinterColorClass()
*
* DESCRIPTION
*    Translate the ped_ColorClass number into a descriptive string.
**********************************************************************
*
*/

PUBLIC char *PrtCClasses[ 18 ] = { NULL, }; // Visible to CatalogPrinter();

PRIVATE char *GetPrinterColorClass( int classnum )
{
   return( PrtCClasses[ classnum ] );   
}

/****i* TranslateErrorNum() [1.9] ************************************
*
* NAME
*    TranslateErrorNum()
*
* DESCRIPTION
*    Translate the io_Error number into a descriptive string.
**********************************************************************
*
*/

PUBLIC char *PrtErrors[ 15 ] = { NULL, }; // Visible to CatalogPrinter();

PRIVATE char *TranslateErrorNum( int errnum )
{
   return( PrtErrors[ errnum + 4 ] ); // Offset to the correct string. 
}


/****i* GetPrinterErrorString() [1.9] ********************************
*
* NAME
*    GetPrinterErrorString()
*
* DESCRIPTION
*    Translate the io_Error number into a String.
*    ^ <primitive 225 18 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetPrinterErrorString( OBJECT *pObj )
{
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   OBJECT         *rval = o_nil;

   if (!pio) // == NULL)
      {
      return( rval = AssignObj( new_str( PrtCMsg( MSG_PRT_PDERR_NOERR_PRT ))));
      }

   if (pio->ps_ErrorNum > PDERR_LASTSTANDARD)
      {
      sprintf( ErrMsg, PrtCMsg( MSG_FMT_PRT_DRIVE_ERR_PRT ), pio->ps_ErrorNum );

      rval = AssignObj( new_str( ErrMsg ) );

      return( rval );
      }   

   if (pio->ps_ErrorNum > PDERR_BADPREFERENCES)
      {
      sprintf( ErrMsg, PrtCMsg( MSG_FMT_PRT_PDERR_UNK_PRT ), pio->ps_ErrorNum );

      rval = AssignObj( new_str( ErrMsg ) );
      }   
   else
      rval = AssignObj( new_str( TranslateErrorNum( pio->ps_ErrorNum )));
      
   return( rval );
}


/****i* ClosePrinter() [1.9] ******************************************
*
* NAME
*    ClosePrinter()
*
* DESCRIPTION
*    Close the printer.device & remove it from AmigaTalk program space.
*    <primitive 225 0 private>
***********************************************************************
*
*/

METHODFUNC void ClosePrinter( OBJECT *pObj )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );

   if (pio) // != NULL)
      {
      if (CheckIO( (struct IORequest *) pio->ps_pio ) == 0)
         AbortIO(  (struct IORequest *) pio->ps_pio );

      WaitIO( (struct IORequest *) pio->ps_pio );

      // Now, shut down the printer:

      CloseDevice( (struct IORequest *) pio->ps_pio );

      DeleteIORequest( (struct IORequest *) pio->ps_pio );

      DeletePort( pio->ps_MsgPort );

      AT_FreeVec( pio, "PrinterIO", TRUE );

      pio = NULL;
      }
   else
      {
      UserInfo( PrtCMsg( MSG_PRT_INVALID_OBJ_PRT ), UserPgmError );
      }

   WaitPrtMask   = 0L;   // Kill everything!
   pdata         = NULL;
   pedata        = NULL;
   pname         = NULL;
   prtMaxColumns = 0;
   prtCharSets   = 0;
   prtNumRows    = 0;
   prtMaxXDots   = 0;
   prtMaxYDots   = 0;
   prtXDotsInch  = 0;
   prtYDotsInch  = 0;
   
   return;
}

/****i* OpenPrinter() [1.9] *******************************************
*
* NAME
*    OpenPrinter()
*
* DESCRIPTION
*    Allocate the internal memory & structures needed for opening
*    the printer.device.  Return an Integer Object which points to the
*    structure.
*
*    private <- <primitive 225 1 printerName>
***********************************************************************
*
*/

METHODFUNC OBJECT *OpenPrinter( char *printername )
{
   struct pstruct *pio  = NULL;
   OBJECT         *rval = o_nil;
   int             chk  = 0;

   if (!(pio = (struct pstruct *) AT_AllocVec( sizeof( struct pstruct ),
                                               MEMF_CLEAR | MEMF_PUBLIC,
                                               "PrinterIO", TRUE ))) // == NULL)
      {
      MemoryOut( PrtCMsg( MSG_OPENPRT_FUNC_PRT ) );

      return( rval );
      }

   if (!(pio->ps_MsgPort = (struct MsgPort *) CreatePort( printername, 0 ))) // == NULL)
      {
      CannotCreatePort( printername );

      AT_FreeVec( pio, "PrinterIO", TRUE );

      return( rval );
      }

   if (!(pio->ps_pio = (union myPrinterIO *) 
                       CreateIORequest( pio->ps_MsgPort, 
		                        sizeof( union myPrinterIO )))) // == NULL)
      {
      CannotCreateExtIO( "printer.device" );

      DeletePort( pio->ps_MsgPort );

      AT_FreeVec( pio, "PrinterIO", TRUE );

      return( rval );
      }   

   if ((chk = OpenDevice( "printer.device", 0, (struct IORequest *) pio->ps_pio, 0L )) != 0)
      {
      CannotOpenDevice( "printer.device" );

      DeleteIORequest( (struct IORequest *) pio->ps_pio );

      DeletePort( pio->ps_MsgPort );

      AT_FreeVec( pio, "PrinterIO", TRUE );

      return( rval );
      }

   PrinterSignal = 1L << pio->ps_MsgPort->mp_SigBit;
   WaitPrtMask   = SIGBREAKF_CTRL_C | SIGBREAKF_CTRL_D | PrinterSignal;

   pio->ps_ErrorNum = PDERR_NOERR;

   // Get Printer Information set up:
   pdata  = (struct PrinterData         *) pio->ps_pio->iodrp.io_Device;
   pedata = (struct PrinterExtendedData *) &pdata->pd_SegmentData->ps_PED;

   pname         = pedata->ped_PrinterName;
   prtMaxColumns = pedata->ped_MaxColumns;
   prtCharSets   = pedata->ped_NumCharSets;
   prtNumRows    = pedata->ped_NumRows;
   prtMaxXDots   = pedata->ped_MaxXDots;
   prtMaxYDots   = pedata->ped_MaxYDots;
   prtXDotsInch  = pedata->ped_XDotsInch;
   prtYDotsInch  = pedata->ped_YDotsInch;
               
   rval = AssignObj( new_address( (ULONG) pio ) ); // private <- <primitive 225 1 printerName>

   return( rval );
}

/****i* DoPrtCommand() [1.9] *****************************************
*
* NAME
*    DoPrtCommand()
*
* DESCRIPTION
*    DoIO() a printer command to the printer.device.
**********************************************************************
*
*/

SUBFUNC int DoPrtCommand( struct pstruct *pio, int cmd, char *str, int length )
{
   pio->ps_pio->ios.io_Command = (UWORD) cmd;
   pio->ps_pio->ios.io_Data    = (APTR)  str;
   pio->ps_pio->ios.io_Length  = (ULONG) length;

   DoIO( (struct IORequest *) pio->ps_pio );
   
   pio->ps_ErrorNum = pio->ps_pio->ios.io_Error;

   return( pio->ps_pio->ios.io_Actual );
}

SUBFUNC void NoPrinterObject( void )
{
   ObjectWasZero( PrtCMsg( MSG_PRINTER_CLASSNAME_PRT ) );
   
   return;
}

/****i* InitPrinter() [1.9] *******************************************
*
* NAME
*    InitPrinter()
*
* DESCRIPTION
*    Send an initialization string to the printer.device.
*    <primitive 225 2 private initString>
**********************************************************************
*
*/

METHODFUNC void InitPrinter( OBJECT *pObj, char *initString )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return;
      }

   (void) DoPrtCommand( pio, CMD_WRITE, initString, -1 );

   return;
}

/****i* WritePrinter() [1.9] ******************************************
*
* NAME
*    WritePrinter()
*
* DESCRIPTION
*    Write a string of size 'length' to the printer.device.
*    actual <- <primitive 225 3 private strOut length>
**********************************************************************
*
*/

METHODFUNC OBJECT *WritePrinter( OBJECT *pObj, char *strOut, int length )
{
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   OBJECT         *rval = o_nil;
        
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return( rval );
      }

   rval = AssignObj( new_int( DoPrtCommand( pio, CMD_WRITE, strOut, length )));
   
   return( rval );
}

/****i* sendPrtCommand() [1.9] ***************************************
*
* NAME
*    sendPrtCommand()
*
* DESCRIPTION
*    Do a SendIO() to the printer.device
**********************************************************************
*
*/

PRIVATE int sendPrtCommand( struct pstruct *pio, int cmd, char *data, int length )
{
   ULONG temp = 0L;

   pio->ps_pio->iopc.io_Parm0  = 0;
   pio->ps_pio->iopc.io_Parm1  = 0;
   pio->ps_pio->iopc.io_Parm2  = 0;
   pio->ps_pio->iopc.io_Parm3  = 0;

   pio->ps_pio->ios.io_Command = cmd;
   pio->ps_pio->ios.io_Data    = (APTR)  data;
   pio->ps_pio->ios.io_Length  = (ULONG) length;
   pio->ps_pio->ios.io_Flags  |= IOF_QUICK;      // Fix the Wait() problem??
   pio->ps_pio->ios.io_Error   = PDERR_NOERR;
   	
   SendIO( (struct IORequest *) pio->ps_pio );

   while (1)
      {
      temp = Wait( WaitPrtMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if ((temp & PrinterSignal) == PrinterSignal)
         {
         // Printer is either ready or an error has occurred:
         while (GetMsg( pio->ps_MsgPort )) // != NULL)
            ; // Remove any messages.
         }
         
      if (CheckIO( (struct IORequest *) pio->ps_pio ))
         {
         WaitIO( (struct IORequest *) pio->ps_pio );
         
         pio->ps_ErrorNum = pio->ps_pio->ios.io_Error;

         if (pio->ps_ErrorNum != PDERR_NOERR)
            {
            AbortIO( (struct IORequest *) pio->ps_pio );
            WaitIO(  (struct IORequest *) pio->ps_pio );

            UserInfo( TranslateErrorNum( pio->ps_ErrorNum ), SystemProblem );

            return( pio->ps_ErrorNum );
            }

         return( (int) pio->ps_pio->ios.io_Actual );
         }
      }
   
   // User pressed Ctrl-C to break I/O:
   AbortIO( (struct IORequest *) pio->ps_pio );
   WaitIO(  (struct IORequest *) pio->ps_pio );

   pio->ps_ErrorNum = pio->ps_pio->ios.io_Error;

   return( (int) pio->ps_pio->ios.io_Actual );
}

/****i* QueueWritePrinter() [1.9] ************************************
*
* NAME
*    QueueWritePrinter()
*
* DESCRIPTION
*    Write a string of size 'length' to the printer.device with
*    asynchronous IO.
*    <primitive 225 4 private strOut length>
**********************************************************************
*
*/

METHODFUNC void QueueWritePrinter( OBJECT *pObj, char *strOut, int length )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();

      return;
      }

   (void) sendPrtCommand( pio, CMD_WRITE, strOut, length );

   return;
}

// ------- Commands to complete printer access: ------------------------

/****i* QueryPrinter() [1.9] *****************************************
*
* NAME
*    QueryPrinter()
*
* DESCRIPTION
*    Ask the printer.device to return two bytes of status (PRD_QUERY).
*    statusString <- <primitive 225 5 private>
**********************************************************************
*
*/

PRIVATE char stat[3] = { 0, }, *ret_status = &stat[0];

METHODFUNC OBJECT *QueryPrinter( OBJECT *pObj )
{
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   OBJECT         *rval = o_nil;
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return;
      }

   (void) DoPrtCommand( pio, PRD_QUERY, ret_status, 2 );

   rval = AssignObj( new_str( ret_status ) );

   return( rval ); // pio->ios.io_Actual ); // return the type of printer.
}

/****i* SendCommand() [1.9] ******************************************
*
* NAME
*    SendCommand()
*
* DESCRIPTION
*    Send an extended command to the printer.device.
*    <primitive 225 6 private command parm1 parm2 parm3 parm4>
**********************************************************************
*
*/

METHODFUNC void SendCommand( OBJECT *pObj,
                             UWORD   command, 
                             UBYTE   parm1, 
                             UBYTE   parm2, 
                             UBYTE   parm3,
                             UBYTE   parm4
                           )
{
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   ULONG           temp = 0L;
        
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return;
      }

   pio->ps_pio->iopc.io_PrtCommand = command;
   pio->ps_pio->iopc.io_Parm0      = parm1;
   pio->ps_pio->iopc.io_Parm1      = parm2;
   pio->ps_pio->iopc.io_Parm2      = parm3;
   pio->ps_pio->iopc.io_Parm3      = parm4;
   pio->ps_pio->iopc.io_Command    = PRD_PRTCOMMAND;

   SendIO( (struct IORequest *) pio->ps_pio );

   while (1)
      {
      temp = Wait( WaitPrtMask );

      if ((SIGBREAKF_CTRL_C & temp) == SIGBREAKF_CTRL_C)
         break;

      if ((temp & PrinterSignal) == PrinterSignal)
         {
         // Printer is either ready or an error has occurred:
         while (GetMsg( pio->ps_MsgPort )) // != NULL)
            ; // Remove any messages.
         }
         
      if (CheckIO( (struct IORequest *) pio->ps_pio ))
         {
         WaitIO( (struct IORequest *) pio->ps_pio );
         
         pio->ps_ErrorNum = pio->ps_pio->ios.io_Error;

         if (pio->ps_ErrorNum != PDERR_NOERR)
            {
            AbortIO( (struct IORequest *) pio->ps_pio );
            WaitIO(  (struct IORequest *) pio->ps_pio );

            UserInfo( TranslateErrorNum( pio->ps_ErrorNum ), SystemProblem );

            return; // ( pio->ps_ErrorNum );
            }

         return; // ( (int) pio->ps_pio->ios.io_Actual );
         }
      }

   AbortIO( (struct IORequest *) pio->ps_pio );
   WaitIO(  (struct IORequest *) pio->ps_pio );

   pio->ps_ErrorNum = pio->ps_pio->ios.io_Error;

   return;
}

/****i* QueueRawWrite() [1.9] ****************************************
*
* NAME
*    QueueRawWrite()
*
* DESCRIPTION
*    Send a Raw buffer of data to the printer.device.
*    <primitive 225 7 private buffer length>
**********************************************************************
*
*/

METHODFUNC void QueueRawWrite( OBJECT *pObj, char *buffer, int length )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();

      return;
      }

   (void) sendPrtCommand( pio, PRD_RAWWRITE, buffer, length );

   return;
}

/****i* FlushPrinter() [1.9] *****************************************
*
* NAME
*    FlushPrinter()
*
* DESCRIPTION
*    Send CMD_FLUSH to printer.device.
*    <primitive 225 8 private>
**********************************************************************
*
*/

METHODFUNC void SendFlushPrinter( OBJECT *pObj )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();

      return;
      }

   (void) DoPrtCommand( pio, CMD_FLUSH, NULL, -1 );

   return;
}

/****i* ResetPrinter() [1.9] *****************************************
*
* NAME
*    ResetPrinter()
*
* DESCRIPTION
*    Send CMD_RESET to printer.device.
*    <primitive 225 9 private>
**********************************************************************
*
*/

METHODFUNC void ResetPrinter( OBJECT *pObj )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();

      return;
      }

   (void) DoPrtCommand( pio, CMD_RESET, NULL, -1 );

   return;
}

/****i* StartPrinter() [1.9] *****************************************
*
* NAME
*    StartPrinter()
*
* DESCRIPTION
*    Send CMD_START to printer.device.
*    <primitive 225 10 private>
**********************************************************************
*
*/

METHODFUNC void StartPrinter( OBJECT *pObj )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();

      return;
      }

   (void) DoPrtCommand( pio, CMD_START, NULL, -1 );

   return;
}

/****i* StopPrinter() [1.9] ******************************************
*
* NAME
*    StopPrinter()
*
* DESCRIPTION
*    Send CMD_STOP to printer.device.
*    <primitive 225 11 private>
**********************************************************************
*
*/

METHODFUNC void StopPrinter( OBJECT *pObj )
{
   struct pstruct *pio = (struct pstruct *) CheckObject( pObj );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();

      return;
      }

   (void) DoPrtCommand( pio, CMD_STOP, NULL, -1 );

   return;
}

/****i* DumpRPortPrinter() [1.9] *************************************
*
* NAME
*    DumpRPortPrinter()
*
* DESCRIPTION
*    Send PRD_DUMPRPORT to printer.device in order to print a screen
*    dump.
*
*    <primitive 225 12 private rpObj cm modeID xOffset yOffset w h dc dr flags>
*
*    The parameters needed are as follows:
*
*      rpObj   = struct RastPort *io_RastPort;  // raster port
*      cm      = struct ColorMap *io_ColorMap;  // color map
*      modeID  = ULONG            io_Modes;     // graphics viewport modes
*      xOffset = UWORD            io_SrcX;      // source x origin
*      yOffset = UWORD            io_SrcY;      // source y origin
*      w       = UWORD            io_SrcWidth;  // source x width
*      h       = UWORD            io_SrcHeight; // source x height
*      dc      = LONG             io_DestCols;  // destination x width
*      dr      = LONG             io_DestRows;  // destination y height
*      flags   = UWORD            io_Special;   // option flags
**********************************************************************
*
*/

METHODFUNC void DumpRPortPrinter( OBJECT *pObj, 
                                  OBJECT *rpObj, 
                                  OBJECT *cm,
                                  ULONG   modeID,
                                  UWORD   xOffset,
                                  UWORD   yOffset,
                                  UWORD   width,
                                  UWORD   height,
                                  LONG    destCols,
                                  LONG    destRows,
                                  UWORD   flags
                                )
{
   struct pstruct  *pio   = (struct pstruct  *) CheckObject( pObj  );
   struct RastPort *rport = (struct RastPort *) CheckObject( rpObj );
   struct ColorMap *cmap  = (struct ColorMap *) CheckObject( cm    );
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return;
      }

   if (!rport) // == NULL)
      {
      ObjectWasZero( PrtCMsg( MSG_RASTPORT_CLASSNAME_PRT ) );

      return;
      }

   if (!cmap) // == NULL)
      {
      ObjectWasZero( PrtCMsg( MSG_COLORMAP_CLASSNAME_PRT ) );

      return;
      }

   pio->ps_pio->iodrp.io_RastPort  = rport;
   pio->ps_pio->iodrp.io_ColorMap  = cmap;
   pio->ps_pio->iodrp.io_Modes     = modeID;
   pio->ps_pio->iodrp.io_SrcX      = xOffset;
   pio->ps_pio->iodrp.io_SrcY      = yOffset;
   pio->ps_pio->iodrp.io_SrcWidth  = width;
   pio->ps_pio->iodrp.io_SrcHeight = height;
   pio->ps_pio->iodrp.io_DestCols  = destCols;
   pio->ps_pio->iodrp.io_DestRows  = destRows;
   pio->ps_pio->iodrp.io_Special   = flags;
   
   (void) sendPrtCommand( pio, PRD_DUMPRPORT, NULL, 0 );

   return;
}

/****i* DumpRPortPrinterTags() [1.9] *********************************
*
* NAME
*    DumpRPortPrinterTags()
*
* DESCRIPTION
*    Send PRD_DUMPRPORTTAGS to printer.device in order to print a screen
*    dump.
*
*    <primitive 225 13 private rpObj cm modeID xOffset yOffset w h dc dr flags tags>
*
*    The parameters needed are as follows:
*
*      rpObj   = struct RastPort *io_RastPort;  // raster port
*      cm      = struct ColorMap *io_ColorMap;  // color map
*      modeID  = ULONG            io_Modes;     // graphics viewport modes
*      xOffset = UWORD            io_SrcX;      // source x origin
*      yOffset = UWORD            io_SrcY;      // source y origin
*      w       = UWORD            io_SrcWidth;  // source x width
*      h       = UWORD            io_SrcHeight; // source x height
*      dc      = LONG             io_DestCols;  // destination x width
*      dr      = LONG             io_DestRows;  // destination y height
*      flags   = UWORD            io_Special;   // option flags
*      tags    = struct TagItem  *io_
**********************************************************************
*
*/

METHODFUNC void DumpRPortPrinterTags( OBJECT *pObj, 
                                      OBJECT *rpObj, 
                                      OBJECT *cm,
                                      ULONG   modeID,
                                      UWORD   xOffset,
                                      UWORD   yOffset,
                                      UWORD   width,
                                      UWORD   height,
                                      LONG    destCols,
                                      LONG    destRows,
                                      UWORD   flags,
                                      OBJECT *tagObj
                                    )
{
   struct pstruct  *pio   = (struct pstruct  *) CheckObject( pObj  );
   struct RastPort *rport = (struct RastPort *) CheckObject( rpObj );
   struct ColorMap *cmap  = (struct ColorMap *) CheckObject( cm    );
   
   struct TagItem  *tags  = ArrayToTagList( tagObj );
          
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return;
      }

   if (!rport) // == NULL)
      {
      ObjectWasZero( PrtCMsg( MSG_RASTPORT_CLASSNAME_PRT ) );

      return;
      }

   if (!cmap) // == NULL)
      {
      ObjectWasZero( PrtCMsg( MSG_COLORMAP_CLASSNAME_PRT ) );

      return;
      }

   pio->ps_pio->iodrpt.io_RastPort  = rport;
   pio->ps_pio->iodrpt.io_ColorMap  = cmap;
   pio->ps_pio->iodrpt.io_Modes     = modeID;
   pio->ps_pio->iodrpt.io_SrcX      = xOffset;
   pio->ps_pio->iodrpt.io_SrcY      = yOffset;
   pio->ps_pio->iodrpt.io_SrcWidth  = width;
   pio->ps_pio->iodrpt.io_SrcHeight = height;
   pio->ps_pio->iodrpt.io_DestCols  = destCols;
   pio->ps_pio->iodrpt.io_DestRows  = destRows;
   pio->ps_pio->iodrpt.io_Special   = flags;
   pio->ps_pio->iodrpt.io_TagList   = tags; // NULL is valid (== TAG_DONE)
   
   (void) sendPrtCommand( pio, PRD_DUMPRPORTTAGS, NULL, 0 );

   return;
}

/****i* ReadPrinterPrefs() [1.9] *************************************
*
* NAME
*    ReadPrinterPrefs()
*
* DESCRIPTION
*    Get the driver preferences into the given buffer.
*    ^ <primitive 225 14 private buffer length>
**********************************************************************
*
*/

METHODFUNC OBJECT *ReadPrinterPrefs( OBJECT *pObj, char *buffer, int length )
{
   OBJECT         *rval = o_nil;
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   int             chk  = 0;
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return( rval );
      }

   if ((chk  = DoPrtCommand( pio, PRD_READPREFS, buffer, length )) != length)
      {
      Unsupported( PrtCMsg( MSG_PRINTER_DRIVER_PRT ),
                   PrtCMsg( MSG_READ_PRINTERPREFS_PRT )
                 );
      }
   else
      rval = AssignObj( new_int( chk ) );
   
   return( rval );
}

/****i* WritePrinterPrefs() [1.9] ************************************
*
* NAME
*    WritePrinterPrefs()
*
* DESCRIPTION
*    Write the driver preferences from the given buffer.
*    ^ <primitive 225 15 private buffer length>
**********************************************************************
*
*/

METHODFUNC OBJECT *WritePrinterPrefs( OBJECT *pObj, char *buffer, int length )
{
   OBJECT         *rval = o_nil;
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   int             chk  = 0;

   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return( rval );
      }

   if ((chk = DoPrtCommand( pio, PRD_WRITEPREFS, buffer, length )) != length)
      {
      Unsupported( PrtCMsg( MSG_PRINTER_DRIVER_PRT ), 
                   PrtCMsg( MSG_WRITE_PRINTERPREFS_PRT )
                 );
      }
   else
      rval = AssignObj( new_int( chk ) );
   
   return( rval );
}

/****i* EditPrinterPrefs() [1.9] *************************************
*
* NAME
*    EditPrinterPrefs()
*
* DESCRIPTION
*    Get the driver to open a preferences requester.
*    ^ <primitive 225 16 private tagArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *EditPrinterPrefs( OBJECT *pObj, OBJECT *tagsObj )
{
   OBJECT         *rval = o_nil;
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   struct TagItem *tags = ArrayToTagList( tagsObj );
   int             chk  = 0;
         
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return( rval );
      }
   
   pio->ps_pio->iodrpt.io_TagList = tags;
         
   if ((chk  = sendPrtCommand( pio, PRD_EDITPREFS, NULL, 0 )) < 0)
      {
      Unsupported( PrtCMsg( MSG_PRINTER_DRIVER_PRT ), 
                   PrtCMsg( MSG_EDIT_PRINTERPREFS_PRT )
                 );
      }
   
   rval = AssignObj( new_int( chk ) );
   
   return( rval );
}

/****i* SetPrinterErrHook() [1.9] ************************************
*
* NAME
*    SetPrinterErrHook()
*
* DESCRIPTION
*    Set a hook to use if the printer.device returns with an error
*    from any other I/O command.
*    ^ <primitive 225 17 private hookObj>
**********************************************************************
*
*/

METHODFUNC OBJECT *SetPrinterErrHook( OBJECT *pObj, OBJECT *hookObj )
{
   OBJECT         *rval = o_nil;
   struct pstruct *pio  = (struct pstruct *) CheckObject( pObj );
   struct Hook    *hook = (struct Hook    *) CheckObject( hookObj );
   int             chk  = 0;
      
   if (!pio) // == NULL)
      {
      NoPrinterObject();
      return( rval );
      }

   if (!hook) // == NULL)
      {
      ObjectWasZero( PrtCMsg( MSG_PRT_ERROR_HOOK_PRT ) );

      return( rval );
      }

   // The only time ioperr gets used (for now):
   pio->ps_pio->ioperr.io_Hook = hook;
   
   chk  = DoPrtCommand( pio, PRD_SETERRHOOK, NULL, 0 );
   rval = AssignObj( new_int( chk ) );

   return( rval );
}

/****i* getPrinterClass() [1.9] **************************************
*
* NAME
*    getPrinterClass()
*
* DESCRIPTION
*    get a string describing the printer class.
*    ^ <primitive 225 19>
**********************************************************************
*
*/

METHODFUNC char *getPrinterClass( void )
{
   if (!pedata) // == NULL)
      return( PrtCMsg( MSG_PRINTER_UNOPENED_PRT ) );
   else
      return( GetPrinterClass( pedata->ped_PrinterClass ) ); 
}

/****i* getPrinterColorClass() [1.9] *********************************
*
* NAME
*    getPrinterColorClass()
*
* DESCRIPTION
*    Get a string describing the printer's color capabilities (if any).
*    ^ <primitive 225 20>
**********************************************************************
*
*/

METHODFUNC char *getPrinterColorClass( void )
{
   if (!pedata) // == NULL)
      return( PrtCMsg( MSG_PRINTER_UNOPENED_PRT ) );
   else
      return( GetPrinterColorClass( pedata->ped_ColorClass ) ); 
}

/****h* HandlePrinter() [1.9] *****************************************
*
* NAME
*    HandlePrinter()
*
* DESCRIPTION
*    Translate the primitive 225 calls to printer.device functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandlePrinter( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 225 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // close {private} <primitive 225 0 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            {
            ClosePrinter( args[1] );
            }

         break;         

      case 1: // private <- <primitive 225 1 printerName>
         if ( is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            rval = OpenPrinter( string_value( (STRING *) args[1] ) );

         break;
         
      case 2: // <primitive 225 2 private initString>
         if ( !is_address( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 225 );
         else
            InitPrinter( args[1], string_value( (STRING *) args[2] ) );

         break;
         
      case 3: // actual <- <primitive 225 3 private strOut length>
         if ( !is_address( args[1] ) || !is_string(  args[2] )
                                     || !is_integer( args[3] ))
            (void) PrintArgTypeError( 225 );
         else
            rval = WritePrinter( args[1], string_value( (STRING *) args[2] ),
                                             int_value( args[3] )
                               );
         break;
         
      case 4: // <primitive 225 4 private strOut length>
         if ( !is_address( args[1] ) || !is_string(  args[2] )
                                     || !is_integer( args[3] ))
            (void) PrintArgTypeError( 225 );
         else
            QueueWritePrinter( args[1], string_value( (STRING *) args[2]),
                                           int_value( args[3] ) 
                             );
         break;

      case 5: // statusString <- <primitive 225 5 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            rval = QueryPrinter( args[1] );
         break;
         
      case 6: // <primitive 225 6 private command parm1 parm2 parm3 parm4>
         if (ChkArgCount( 7, numargs, 225 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_integer( args[2] )
                                    || !is_integer( args[3] )
                                    || !is_integer( args[4] )
                                    || !is_integer( args[5] )
                                    || !is_integer( args[6] ))
            (void) PrintArgTypeError( 225 );
         else
            SendCommand( args[1], (UWORD) int_value( args[2] ),
                                  (UBYTE) int_value( args[3] ),
                                  (UBYTE) int_value( args[4] ),
                                  (UBYTE) int_value( args[5] ),
                                  (UBYTE) int_value( args[6] )
                       );
         break;
         
      case 7: // <primitive 225 7 private buffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 225 );
         else
            QueueRawWrite( args[1], string_value( (STRING *) args[2] ),
                                       int_value( args[3] ) 
                         );
         break;
         
      case 8: // <primitive 225 8 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            SendFlushPrinter( args[1] );

         break;
         
      case 9: // <primitive 225 9 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            ResetPrinter( args[1] );

         break;
         
      case 10: // <primitive 225 10 private>

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            StartPrinter( args[1] );
         break;
         
      case 11: // <primitive 225 11 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            StopPrinter( args[1] );

         break;

      case 12: // <primitive 225 12 private rpObj cm modeID xOffset yOffset w h dc dr flags>
         if (ChkArgCount( 12, numargs, 225 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_address( args[2 ] )
                                    || !is_address( args[3 ] )
                                    || !is_integer( args[4 ] )
                                    || !is_integer( args[5 ] )
                                    || !is_integer( args[6 ] )
                                    || !is_integer( args[7 ] )
                                    || !is_integer( args[8 ] )
                                    || !is_integer( args[9 ] )
                                    || !is_integer( args[10] )
                                    || !is_integer( args[11] ))
            (void) PrintArgTypeError( 225 );
         else
            DumpRPortPrinter( args[1],                       // OBJECT *pObj, 
                              args[2],                       // OBJECT *rpObj, 
                              args[3],                       // OBJECT *cm,

                              (ULONG) int_value( args[4]  ), // ULONG   modeID,
                              (UWORD) int_value( args[5]  ), // UWORD   xOffset,
                              (UWORD) int_value( args[6]  ), // UWORD   yOffset,
                              (UWORD) int_value( args[7]  ), // UWORD   width,
                              (UWORD) int_value( args[8]  ), // UWORD   height,
                              (LONG)  int_value( args[9]  ), // LONG    destCols,
                              (LONG)  int_value( args[10] ), // LONG    destRows,
                              (UWORD) int_value( args[11] )  // UWORD   flags
                            );

         break;

      case 13: // <primitive 225 13 private rpObj cm modeID xOff yOff w h dc dr flags tags>
         if (ChkArgCount( 13, numargs, 225 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] ) || !is_address( args[2 ] )
                                    || !is_address( args[3 ] )
                                    || !is_integer( args[4 ] )
                                    || !is_integer( args[5 ] )
                                    || !is_integer( args[6 ] )
                                    || !is_integer( args[7 ] )
                                    || !is_integer( args[8 ] )
                                    || !is_integer( args[9 ] )
                                    || !is_integer( args[10] )
                                    || !is_integer( args[11] ))
            (void) PrintArgTypeError( 225 );
         else
            DumpRPortPrinterTags( args[1],                       // OBJECT *pObj, 
                                  args[2],                       // OBJECT *rpObj, 
                                  args[3],                       // OBJECT *cm,
   
                                  (ULONG) int_value( args[4]  ), // ULONG   modeID,
                                  (UWORD) int_value( args[5]  ), // UWORD   xOffset,
                                  (UWORD) int_value( args[6]  ), // UWORD   yOffset,
                                  (UWORD) int_value( args[7]  ), // UWORD   width,
                                  (UWORD) int_value( args[8]  ), // UWORD   height,
                                  (LONG)  int_value( args[9]  ), // LONG    destCols,
                                  (LONG)  int_value( args[10] ), // LONG    destRows,
                                  (UWORD) int_value( args[11] ), // UWORD   flags
                                  args[12]                       // OBJECT *Tags
                                );

         break;

      case 14: // <primitive 225 14 private aBuffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 225 );
         else
            rval = ReadPrinterPrefs( args[1], string_value( (STRING *) args[2] ),
                                                 int_value( args[3] )
                                   ); 
         break;

      case 15: // <primitive 225 15 private aBuffer length>
         if (!is_address( args[1] ) || !is_string(  args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 225 );
         else
            rval = WritePrinterPrefs( args[1], string_value( (STRING *) args[2] ),
                                                  int_value( args[3] )
                                    ); 
         break;

      case 16: // <primitive 225 16 private tagArray>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            rval = EditPrinterPrefs( args[1], args[2] );
            
         break;

      case 17: // <primitive 225 17 private hookObject>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 225 );
         else
            rval = SetPrinterErrHook( args[1], args[2] );
            
         break;

      case 18: // <primitive 225 18 private>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 225 );
         else
            rval = GetPrinterErrorString( args[1] );
             
         break;

      case 19: // getPrinterClassString <primitive 225 19>
         rval = AssignObj( new_str( getPrinterClass() ) );
         break;

      case 20: // getPrinterColorClassString <primitive 225 20>
         rval = AssignObj( new_str( getPrinterColorClass() ) );
         break;

      case 21: // getPrinterName <primitive 225 21>
         rval = AssignObj( new_str( pname ) );
         break;

      case 22: // getNumberOfCharSets <primitive 225 22>
         rval = AssignObj( new_int( prtCharSets ) );
         break;

      case 23: // getHorizontalDPI <primitive 225 23>
         rval = AssignObj( new_int( prtXDotsInch ) );
         break;

      case 24: // getVerticalDPI <primitive 225 24>
         rval = AssignObj( new_int( prtYDotsInch ) );
         break;

      case 25: // getNumberOfPrintColumns <primitive 225 25>
         rval = AssignObj( new_int( prtMaxColumns ) );
         break;

      case 26: // getNumberOfHeadPins <primitive 225 26>
         rval = AssignObj( new_int( prtNumRows ) );
         break;

      case 27: // getMaxXRasterDump <primitive 225 27>
         rval = AssignObj( new_int( prtMaxXDots ) );
         break;

      case 28: // getMaxYRasterDump <primitive 225 28>
         rval = AssignObj( new_int( prtMaxYDots ) );
         break;

      default:
         (void) PrintArgTypeError( 225 );
         break;
      }

   return( rval );
}

/* --------------------- END of Printer.c file! ----------------------- */
