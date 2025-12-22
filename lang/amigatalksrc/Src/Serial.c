/****h* AmigaTalk/Serial.c [3.0] ***************************************
*
* NAME
*    Serial.c
* 
* DESCRIPTION
*    Implement AmigaTalk control over serial devices.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
* TODO
*    Change these functions to use timed serial I/O.
*
* NOTES
*    $VER: AmigaTalk:Src/Serial.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/exec.h>
#include <AmigaDOSErrs.h>
 
#include <devices/serial.h>

#ifdef    __SASC

# include <clib/exec_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "IStructs.h"

#include "FuncProtos.h"
#include "StringConstants.h"

/*
struct eSerial    {

   struct IOExtSer   *SerialPtr;
   struct MsgPort    *SerialMsgPortPtr;
   char              *ReadBuffer;
   char              *WriteBuffer;
   int                ReadBufLen;
   int                WriteBufLen; 
};
*/

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );


#define  SYNC_OFF    0
#define  SYNC_ON     1

PRIVATE struct IOExtSer *IOsp  = NULL;
PRIVATE int             Sync   = SYNC_OFF;

PRIVATE int ReadBufLen  = 0; // Init'd in OpenSerial().
PRIVATE int WriteBufLen = 0;

/****i* CloseSerial() [1.6] ******************************************
*
* NAME
*    CloseSerial()
*
* DESCRIPTION
*    Close the serial.device & remove it from AmigaTalk program space.
**********************************************************************
*
*/

METHODFUNC void CloseSerial( OBJECT *serObj )
{
   struct eSerial *sp = (struct eSerial *) CheckObject( serObj );
   
   if (!sp) // == NULL)
      return;
      
   if (CheckIO( (struct IORequest *) sp->SerialPtr ) == 0)
      AbortIO( (struct IORequest *) sp->SerialPtr );

   WaitIO(      (struct IORequest *) sp->SerialPtr );
   CloseDevice( (struct IORequest *) sp->SerialPtr );

   DeleteIORequest( (struct IORequest *) sp->SerialPtr );

   DeleteMsgPort( sp->SerialMsgPortPtr );

   AT_FreeVec( sp->ReadBuffer,  "serialReadBuff",  TRUE );
   AT_FreeVec( sp->WriteBuffer, "serialWriteBuff", TRUE );
   AT_FreeVec( sp,              "eSerial",         TRUE );

   return;
}

#define  FASTMEM        MEMF_CLEAR | MEMF_PUBLIC | MEMF_FAST

PRIVATE int BufferSize = 0;

/****i* OpenSerial() [1.6] *******************************************
*
* NAME
*    OpenSerial()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *OpenSerial( int buf_size, char *serialname )
{
   struct eSerial *sp      = NULL;
   struct MsgPort *mp      = NULL;
   char           *readbuf = NULL;
   char           *wrtbuff = NULL;
   OBJECT         *rval    = o_nil;
      
   sp = (struct eSerial *) AT_AllocVec( sizeof( struct eSerial ), 
                                        FASTMEM, "eSerial", TRUE 
                                      );

   readbuf = (char *) AT_AllocVec( buf_size, FASTMEM, "serialReadBuff",  TRUE );
   wrtbuff = (char *) AT_AllocVec( buf_size, FASTMEM, "serialWriteBuff", TRUE );

   if (!sp || !readbuf || !wrtbuff) // == NULL)
      {
      if (sp) // != NULL)
         AT_FreeVec( sp, "eSerial", TRUE );

      if (readbuf) // != NULL)
         AT_FreeVec( readbuf, "serialReadBuff", TRUE );

      if (wrtbuff) // != NULL)
         AT_FreeVec( wrtbuff, "serialWriteBuff", TRUE );

      return( rval );
      }

   sp->ReadBuffer  = readbuf;
   sp->WriteBuffer = wrtbuff;

   if (!(mp = (struct MsgPort *) CreatePort( serialname, 0 ))) // == NULL)
      {
      AT_FreeVec( sp->ReadBuffer,  "serialReadBuff",  TRUE );
      AT_FreeVec( sp->WriteBuffer, "serialWriteBuff", TRUE );
      AT_FreeVec( sp,              "eSerial",         TRUE );
      }

   if (!(sp->SerialPtr = (struct IOExtSer *) CreateIORequest( mp, sizeof( struct IOExtSer )))) // == NULL)
      {
      DeleteMsgPort( mp );

      AT_FreeVec( sp->ReadBuffer,  "serialReadBuff",  TRUE );
      AT_FreeVec( sp->WriteBuffer, "serialWriteBuff", TRUE );
      AT_FreeVec( sp,              "eSerial",         TRUE );
      }

   sp->SerialPtr->io_SerFlags |= (SERF_SHARED | SERF_7WIRE);

   if (OpenDevice( SERIALNAME, 0L, 
                   (struct IORequest *) sp->SerialPtr, 0 ) != 0)
      {
      DeleteIORequest( (struct IORequest *) sp->SerialPtr );
      DeleteMsgPort( mp   );

      AT_FreeVec( sp->ReadBuffer,  "serialReadBuff",  TRUE );
      AT_FreeVec( sp->WriteBuffer, "serialWriteBuff", TRUE );
      AT_FreeVec( sp,              "eSerial",         TRUE );
      }

   BufferSize = buf_size;  // Set global BufferSize here only!

   sp->SerialPtr->io_RBufLen = buf_size;
      
   IOsp = sp->SerialPtr; 

   ReadBufLen  = buf_size; 
   WriteBufLen = buf_size;

   rval = AssignObj( new_address( (ULONG) sp ) );
   
   return( rval );
}

/****i* ReadSerial() [1.6] *******************************************
*
* NAME
*    ReadSerial()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *ReadSerial( OBJECT *serObj, int sync )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;
   OBJECT          *rval = o_nil;
      
   if (!esp) // == NULL)
      return( rval );

   sp                   = esp->SerialPtr;
   sp->IOSer.io_Length  = BufferSize;
   sp->IOSer.io_Data    = esp->ReadBuffer;
   sp->IOSer.io_Command = CMD_READ;

   if (Sync != SYNC_OFF)
      {
      DoIO( (struct IORequest *) sp );
      }
   else
      {
      sp->IOSer.io_Flags |= IOF_QUICK;

      BeginIO( (struct IORequest *) sp );
      WaitIO(  (struct IORequest *) sp ); /* ???? */
      }

   // check IOSer.io_Error field here.

   return( AssignObj( new_str( esp->ReadBuffer ) ) );
}

/****i* WriteSerial() [1.6] ******************************************
*
* NAME
*    WriteSerial()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *WriteSerial( char *str_out, OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;
   OBJECT          *rval = o_nil;
      
   if (!esp) // == NULL)
      return( rval );

   sp                   = esp->SerialPtr;   
   sp->IOSer.io_Length  = -1;
   sp->IOSer.io_Data    = (APTR) str_out;
   sp->IOSer.io_Command = CMD_WRITE;

   if (Sync != SYNC_OFF)
      {
      DoIO( (struct IORequest *) sp );

      rval = AssignObj( new_int( sp->IOSer.io_Error ) );
      }
   else
      {
      sp->IOSer.io_Flags |= IOF_QUICK;
      BeginIO( (struct IORequest *) sp );
      WaitIO(  (struct IORequest *) sp ); /* ???? */

      rval = AssignObj( new_int( sp->IOSer.io_Error ) );
      }      

   return( rval );
}

/****i* GetMaxChar() [1.6] *******************************************
*
* NAME
*    GetMaxChar()
*
* DESCRIPTION
* 
* NOTES
*    Used in InitSerial() & SetTerminators()
**********************************************************************
*
*/

SUBFUNC int GetMaxChar( char *array )
{
   int i, rval;
   
   rval = array[0];

   // Get the largest character:
   for (i = 0; i < sizeof( struct IOTArray ); i++)
      if (array[i] > rval)
         rval = array[i];

   // Kill the largest character:
   for (i = 0; i < sizeof( struct IOTArray ); i++)
      if (array[i] == rval)
         array[i] = '\0';

   return( rval );
}

/****i* InitSerial() [1.6] *******************************************
*
* NAME
*    InitSerial()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void InitSerial( char *breakstring, OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   char   NIL[9] = { 0, }, *TArray = &NIL[0];
   int    i;
      
   if (!esp) // == NULL)
      return;

   sp                   = esp->SerialPtr;
   sp->IOSer.io_Command = CMD_STOP;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   sp->IOSer.io_Command = CMD_FLUSH;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );
   
   sp->IOSer.io_Command = CMD_CLEAR;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   esp->ReadBuffer[0]  = '\0';
   esp->WriteBuffer[0] = '\0';

   // Place all 8 termination characters in descending order:
   for (i = 0; i < sizeof( struct IOTArray ); i++)
      {
      char *tarray = (char *) &(sp->io_TermArray);

      *(TArray + i) = GetMaxChar( breakstring );
      *(tarray + i) = *(TArray + i);
      }

   TArray[8] = '\0'; // Terminate the Terminator list.

   sp->io_SerFlags     |= SERF_EOFMODE;
   sp->IOSer.io_Command = SDCMD_SETPARAMS;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   return;
}

/****i* ResetSerial() [1.6] ******************************************
*
* NAME
*    ResetSerial()
*
* DESCRIPTION
*    Send CMD_RESET to serial.device.
**********************************************************************
*
*/

METHODFUNC void ResetSerial( OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   if (!esp) // == NULL)
      return;

   sp                   = esp->SerialPtr;   
   sp->IOSer.io_Length  = -1;
   sp->IOSer.io_Command = CMD_RESET;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   esp->ReadBuffer[0]  = NIL_CHAR;
   esp->WriteBuffer[0] = NIL_CHAR;

   return;
}

/****i* PauseSerial() [1.6] ******************************************
*
* NAME
*    PauseSerial()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void PauseSerial( OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   if (!esp) // == NULL)
      return;

   sp                   = esp->SerialPtr;   
   sp->IOSer.io_Length  = -1;
   sp->IOSer.io_Command = CMD_STOP;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp ); /* ???? */

   return;
}

/****i* RestartSerial() [1.6] ****************************************
*
* NAME
*    RestartSerial()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void RestartSerial( OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   if (!esp) // == NULL)
      return;

   sp                   = esp->SerialPtr;   
   sp->IOSer.io_Length  = -1;
   sp->IOSer.io_Command = CMD_START;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp ); /* ???? */

   return;
}

/****i* SendBreak() [1.6] ********************************************
*
* NAME
*    SendBreak()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void SendBreak( int duration, OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   if (!esp) // == NULL)
      return;

   sp                   = esp->SerialPtr;   
   sp->io_SerFlags     &= ~SERF_QUEUEDBRK;
   sp->io_BrkTime       = (ULONG) duration;

   sp->IOSer.io_Command = SDCMD_SETPARAMS;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   sp->IOSer.io_Command = SDCMD_BREAK;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   return;
}

/****i* GetStatus() [1.6] ********************************************
*
* NAME
*    GetStatus()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *GetStatus( OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;
   OBJECT          *rval = o_nil;
   
   if (!esp) // == NULL)
      return( rval );

   sp                   = esp->SerialPtr;   
   sp->IOSer.io_Command = SDCMD_QUERY;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   return( AssignObj( new_int( sp->io_Status ) ) );
}

/****i* FlushSerial() [1.6] ******************************************
*
* NAME
*    FlushSerial()
*
* DESCRIPTION
*    Send CMD_FLUSH to serial.device.
**********************************************************************
*
*/

METHODFUNC void FlushSerial( OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   if (!esp) // == NULL)
      return;

   sp                   = esp->SerialPtr;   
   sp->IOSer.io_Command = CMD_FLUSH;
   sp->IOSer.io_Flags  |= IOF_QUICK;

   BeginIO( (struct IORequest *) sp );
   WaitIO(  (struct IORequest *) sp );

   return;
}

/****i* ClearReadBuffer() [1.6] **************************************
*
* NAME
*    ClearReadBuffer()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void ClearReadBuffer( OBJECT *serObj )
{
   struct eSerial *esp = (struct eSerial *) CheckObject( serObj );
   int             j;

   if (!esp) // == NULL)
      return;

   for (j = 0; j < BufferSize; j++)
      esp->ReadBuffer[j] = NIL_CHAR;

   return;   
}

/****i* SetSyncType() [1.6] ******************************************
*
* NAME
*    SetSyncType()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC int SetSyncType( int sync )
{
   Sync = (sync == 0) ? SYNC_OFF : SYNC_ON; // Sync is a Global var.

   return( Sync );
}

/****i* SetSerialParameters() [1.6] **********************************
*
* NAME
*    SetSerialParameters()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *SetSerialParameter( int type, int value, OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;
   OBJECT          *rval = o_nil;
   
   if (!esp) // == NULL)
      return( rval );

   sp = esp->SerialPtr;

   WaitIO( (struct IORequest *) sp );

   sp->IOSer.io_Command = SDCMD_SETPARAMS;
 
   switch (type)
      {
      case 0:  // Set Baud rate:
         sp->io_Baud = value;
         DoIO( (struct IORequest *) sp );
         break;

      case 1:  // Set read buffer length:
         if (value <= BufferSize)
            sp->io_RBufLen = value;
         else
            sp->io_RBufLen = BufferSize;

         DoIO( (struct IORequest *) sp );
         break;

      case 2:  // Set number of Stop bits:
         if (value > 0 && value < 3)
            sp->io_StopBits = value;
         else if (sp->io_WriteLen > 7)
            sp->io_StopBits = 1;
         else
            sp->io_StopBits = 2;
                     
         DoIO( (struct IORequest *) sp );
         break;

      case 3:  // Set Break time duration:
         sp->io_BrkTime = value;

         DoIO( (struct IORequest *) sp );
         break;

      case 4:  // Set Read Buffer size:
         if (value != BufferSize)
            {
            AT_FreeVec( esp->ReadBuffer,  "serialReadBuff",  TRUE );
            AT_FreeVec( esp->WriteBuffer, "serialWriteBuff", TRUE );

            esp->ReadBuffer  = (char *) AT_AllocVec( value, 
                                                     FASTMEM, 
                                                     "serialReadBuff", 
                                                     TRUE 
                                                   );
                                                   
            esp->WriteBuffer = (char *) AT_AllocVec( value, 
                                                     FASTMEM, 
                                                     "serialWriteBuff", 
                                                     TRUE 
                                                   );

            if (!esp->ReadBuffer || !esp->WriteBuffer) // == NULL)
               {
               if (esp->ReadBuffer) // != NULL)
                  AT_FreeVec( esp->ReadBuffer, "serialReadBuff", TRUE );

               if (esp->WriteBuffer) // != NULL)
                  AT_FreeVec( esp->WriteBuffer, "serialWriteBuff", TRUE );

               return( rval );
               }

            esp->ReadBufLen  = BufferSize;
            esp->WriteBufLen = BufferSize;
            }

         sp->io_RBufLen = value;
         BufferSize     = value;

         DoIO( (struct IORequest *) sp );
         break;

      case 5:  // Set Serial Flags:
         sp->io_SerFlags = value;

         DoIO( (struct IORequest *) sp );
         break;

      default:
         break;            
      }

   return( AssignObj( new_int( value ) ) );
}

/****i* SetTerminators() [1.6] ***************************************
*
* NAME
*    SetTerminators()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *SetTerminators( char *terminators, OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;
   OBJECT          *rval = o_nil;
   int             j;
   char            NIL[9] = { 0, }, *TArray = &NIL[0];

   if (!esp) // == NULL)
      return( rval );
   
   sp = esp->SerialPtr;

   // Place all 8 termination characters in descending order:
   for (j = 0; j < sizeof( struct IOTArray ); j++)
      {
      char *tarray = (char *) &(sp->io_TermArray);
      
      *(TArray + j) = GetMaxChar( terminators );
      *(tarray + j) = *(TArray + j);
      }

   TArray[8] = '\0'; // Terminate the Terminator array.

   sp->io_SerFlags     |= SERF_EOFMODE;
   sp->IOSer.io_Command = SDCMD_SETPARAMS;

   DoIO( (struct IORequest *) sp );

   return( AssignObj( new_str( (char *) &(sp->io_TermArray) )));
}

/****i* SetParity() [1.6] ********************************************
*
* NAME
*    SetParity()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void SetParity( int type, int OnFlag, OBJECT *serObj )
{
   struct eSerial  *esp  = (struct eSerial *) CheckObject( serObj );
   struct IOExtSer *sp   = NULL;

   if (!esp) // == NULL)
      return;

   sp = esp->SerialPtr;

   WaitIO( (struct IORequest *) sp );

   switch (type)
      {
      case 0:  // Space Parity:
         sp->io_ExtFlags     |=  SEXTF_MSPON;
         sp->io_SerFlags     &= ~SERF_PARTY_ON;
         sp->IOSer.io_Command = SDCMD_SETPARAMS;

         DoIO( (struct IORequest *) sp );
         break;

      case 1:  // Mark  Parity:
         sp->io_ExtFlags     |=  SEXTF_MARK;
         sp->io_SerFlags     &= ~SERF_PARTY_ON;
         sp->IOSer.io_Command = SDCMD_SETPARAMS;

         DoIO( (struct IORequest *) sp );
         break;
         
      case 2:  // Even  Parity:
         if (OnFlag != 0)
            sp->io_SerFlags |=  SERF_PARTY_ON;
         else
            sp->io_SerFlags &= ~SERF_PARTY_ON;

         sp->io_ExtFlags      =  0;
         sp->io_SerFlags     &= ~SERF_PARTY_ODD;
         sp->IOSer.io_Command = SDCMD_SETPARAMS;

         DoIO( (struct IORequest *) sp );
         break;

      case 3:
         if (OnFlag != 0)
            sp->io_SerFlags |=  SERF_PARTY_ON;
         else
            sp->io_SerFlags &= ~SERF_PARTY_ON;

         sp->io_ExtFlags      =  0;
         sp->io_SerFlags     |= SERF_PARTY_ODD;
         sp->IOSer.io_Command = SDCMD_SETPARAMS;

         DoIO( (struct IORequest *) sp );
         break;

      default:
         break;      
      }

   return;
}

/****h* HandleSerial() [1.6] *****************************************
*
* NAME
*    HandleSerial()
*
* DESCRIPTION
*    Translate the primitive 227 calls to serial.device functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleSerial( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 227 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0:
         if (NullChk( args[1] ) == FALSE)
            {         
            CloseSerial( args[1] );
            }

         break;
         
      case 1: // METHODFUNC OBJECT *OpenSerial( int buf_size, char *serialname )
         if (!is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 227 );
         else
            rval = OpenSerial(    int_value( args[1] ),
                               string_value( (STRING *) args[2] )
                             );

         break;
         
      case 2:
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 227 );
         else
            InitSerial( string_value( (STRING *) args[1] ), args[2] ); 

         break;
         
      case 3:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 227 );
         else
            rval = ReadSerial( args[2], int_value( args[1] ) );

         break;
         
      case 4: // METHODFUNC OBJECT *WriteSerial( char *str_out, OBJECT *serObj )
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 227 );
         else
            rval = WriteSerial( string_value( (STRING *) args[1]), args[2] );

         break;

      case 5:
         ResetSerial( args[1] );
         
         break;
         
      case 6:
         PauseSerial( args[1] );
         
         break;
         
      case 7:
         RestartSerial( args[1] );
         
         break;
         
      case 8:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 227 );
         else
            SendBreak( int_value( args[1] ), args[2] ); 

         break;
         
      case 9:
         rval = GetStatus( args[1] );

         break;
         
      case 10:
         FlushSerial( args[1] );
         break;
         
      case 11:
         ClearReadBuffer( args[1] );

         break;
         
      case 12:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 227 );
         else
            rval = new_int( SetSyncType( int_value( args[1] ) ) );

         break;
         
      case 13:
         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 227 );
         else
            rval = SetSerialParameter( int_value( args[1] ), 
                                       int_value( args[2] ),
                                                  args[3]
                                     );
         break;
         
      case 14:
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 227 );
         else
            rval = SetTerminators( string_value( (STRING *) args[1] ), args[2] ); 

         break;
         
      case 15:
         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 227 );
         else
            SetParity( int_value( args[1] ), int_value( args[2] ),
                                  args[3]
                     );
         break;
         
      default:
         (void) PrintArgTypeError( 227 );
         break;
      }

   return( rval );
}

/* --------------------- END of Serial.c file! ----------------------- */
