/****h* AmigaTalk/Audio.c [3.0] *********************************
*
* NAME
*    Audio.c
*
* WARNINGS
*    This file is NOT completely debugged yet!!
*
* HISTORY
*    24-Oct-2004 - Added AmigaOS4 & gcc support.
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    FUNCTIONAL INTERFACE:
*
*      PUBLIC OBJECT *HandleAudio( int numargs, OBJECT **args );
*
*    $VER: Audio.c V3.0 (24-Oct-2004) by J.T. Steichen
*****************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/io.h>

#include <AmigaDOSErrs.h>

#include <devices/audio.h>

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>

IMPORT struct ExecIFace *IExec;
#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"


#include "StringConstants.h"
#include "StringIndexes.h"

#include "Object.h"

#include "FuncProtos.h"

IMPORT OBJECT *PrintArgTypeError( int primnumber );

# define MAXAUDIO      8
# define CH_ARRAY_SIZE 4

IMPORT OBJECT *o_nil, *o_true, *o_false; 

// In Global.c: ----------------------------

IMPORT UBYTE  *UserPgmError;
IMPORT UBYTE  *ErrMsg;

/*
*    chArray is the channel array for the io_Data field. 
* 
*    Channel 3 Channel 2 Channel 1 Channel 0 Allocation 
*      RIGHT     LEFT      LEFT      RIGHT      MASK
*
*        0         0         1         1        0x03    Stereo
*        0         1         0         1        0x05    Stereo
*        1         0         1         0        0x0A    Stereo
*        1         1         0         0        0x0C    Stereo
*/

// PRIVATE BYTE chArray[ CH_ARRAY_SIZE + 1 ] = { 3, 5, 0x0A, 0x0C, 0 };

PRIVATE ULONG VideoClockFreq = 3579545L; // Default is NTSC Subcarrier frequency

// ------------------------------------------------------------------

/****i* killAudioPort() [2.1] ****************************************
*
* NAME
*    killAudioPort()
*
* DESCRIPTION
*    <primitive 220 0 private1 private3>
**********************************************************************
*
*/

METHODFUNC void killAudioPort( OBJECT *ioaObj, OBJECT *audPortObj )
{
   struct IOAudio *ioa   = (struct IOAudio *) CheckObject( ioaObj );
   struct MsgPort *aPort = (struct MsgPort *) CheckObject( audPortObj );   

   if (!ioa || !aPort) // == NULL)
      return;
      
   AbortIO( (struct IORequest *) ioa );

   WaitIO( (struct IORequest *) ioa );

   (void) GetMsg( aPort );
   
   CloseDevice( (struct IORequest *) ioa );

   DeletePort( aPort );

   return;
}

/****i* allocIOAudio() [2.1] *****************************************
*
* NAME
*    allocIOAudio()
*
* DESCRIPTION
*    ^ private1 <- <primitive 220 1>
**********************************************************************
*
*/

METHODFUNC OBJECT *allocIOAudio( void )
{
#  ifdef  __SASC
   IMPORT struct ExecBase *SysBase;
#  else
   IMPORT struct Library *SysBase;
#  endif

   struct IOAudio *aPtr = NULL;
   OBJECT         *rval = o_nil;

   // SubCarrier is SysBase->ex_EClockFrequency * 5:

   VideoClockFreq = ((struct ExecBase *) SysBase)->ex_EClockFrequency * 5; // Set VideoClockFreq
   
   aPtr = (struct IOAudio *) AT_AllocVec( sizeof( struct IOAudio ),
                                          MEMF_CLEAR | MEMF_PUBLIC, 
                                          "Audio", TRUE
                                        );
   if (!aPtr) // == NULL)
      {
      MemoryOut( AudCMsg( MSG_AU_ALLOC_FUNC_AUDIO ) );

      return( rval );
      }

   rval = AssignObj( new_address( (ULONG) aPtr ) );
   
   return( rval );
}

/****i* freeData() [2.1] *********************************************
*
* NAME
*    freeData()
*
* DESCRIPTION
*    disposeData [private3]
*      <primitive 220 2 private3>
**********************************************************************
*
*/

METHODFUNC void freeData( OBJECT *dataObj )
{
   char *data = (char *) CheckObject( dataObj );
   
   if (NullChk( (OBJECT *) data ) == FALSE)
      AT_FreeVec( data, "AudioData", TRUE );
      
   return;
}

/****i* allocAudioMsgPort() [2.1] ************************************
*
* NAME
*    allocAudioMsgPort()
*
* DESCRIPTION
*    ^ private3 <- <primitive 220 3 private1
*                   portName flags priority channelBytes>
**********************************************************************
*
*/

METHODFUNC OBJECT *allocAudioMsgPort( OBJECT *ioaObj, 
                                      char   *portName, 
                                      ULONG   flags,
                                      BYTE    priority,  
                                      OBJECT *chBytesObj
                                    )
{
   struct IOAudio *ioa      = (struct IOAudio *) CheckObject( ioaObj );
   struct MsgPort *aPort    = NULL;
   UBYTE          *channels = ((BYTEARRAY *) chBytesObj)->bytes;
   OBJECT         *rval     = o_nil;
   int             errval;
      
   aPort = (struct MsgPort *) CreatePort( portName, 0 );

   if (!aPort) // == NULL)
      {
      CannotCreatePort( AudCMsg( MSG_AU_AUDIO_MSG_AUDIO ) );
      
      if (ioa) // != NULL)
         {
         AT_FreeVec( ioa, "Audio", TRUE );

         KillObject( ioaObj );
         }

      return( rval );
      }

   ioa->ioa_Request.io_Message.mn_ReplyPort   = aPort;
   ioa->ioa_Request.io_Message.mn_Node.ln_Pri = priority;

   ioa->ioa_Request.io_Flags = flags;

   ioa->ioa_AllocKey = 0;
   ioa->ioa_Data     = channels;      // which audio channels.
   ioa->ioa_Length   = CH_ARRAY_SIZE; // 4 bytes.
   
   if ((errval = OpenDevice( AUDIONAME, 0L,
                             (struct IORequest *) ioa, 0 )) != 0)
      {
      CannotOpenDevice( AUDIONAME );

      DeletePort( aPort );

      if (ioa) // != NULL)
         {
         AT_FreeVec( ioa, "Audio", TRUE );

         KillObject( ioaObj );
         }

      return( rval );
      }

   rval = AssignObj( new_address( (ULONG) aPort ) );

   return( rval );
}

/****i* killIOAudio() [2.1] ******************************************
*
* NAME
*    killIOAudio()
*
* DESCRIPTION
*    <primitive 220 5 private1>
**********************************************************************
*
*/

METHODFUNC void killIOAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   if (!ioa) // == NULL)
      return;

   AT_FreeVec( ioa, "Audio", TRUE );
 
   return;
}

/****i* IssueCommand() [1.8] *****************************************
*
* NAME
*    IssueCommand()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC BOOL IssueCommand( struct IOAudio *ioa, int command, int flags )
{
   if (!ioa) // == NULL)
      return( FALSE );
      
   ioa->ioa_Request.io_Command = command;
   ioa->ioa_Request.io_Flags   = flags;
   
   BeginIO( (struct IORequest *) ioa );

   return( TRUE );
}

/****i* SetPriority() [1.8] ******************************************
*
* NAME
*    SetPriority()
*
* DESCRIPTION
*    ^ <primitive 220 6 private1 newPriority>
**********************************************************************
*
*/

METHODFUNC BOOL SetPriority( OBJECT *ioaObj, int priority )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   if (!ioa) // == NULL)
      return( FALSE );
      
   ioa->ioa_Request.io_Message.mn_Node.ln_Pri = priority & 0xFF;

   ioa->ioa_Request.io_Command = ADCMD_SETPREC;
   ioa->ioa_Request.io_Flags   = IOF_QUICK | ADIOF_PERVOL;
   
   BeginIO( (struct IORequest *) ioa );

   return( TRUE );
}


/****i* GetAudioLock() ***********************************************
*
* NAME
*    GetAudioLock()
*
* DESCRIPTION
*    ^ <primitive 220 7 private1>
**********************************************************************
*
*/

METHODFUNC BOOL GetAudioLock( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, ADCMD_LOCK, IOF_QUICK ) );
}


/****i* FinishAudio() ************************************************
*
* NAME
*    FinishAudio()
*
* DESCRIPTION
*    ^ <primitive 220 8 private1>
**********************************************************************
*
*/

METHODFUNC BOOL FinishAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, ADCMD_FINISH, IOF_QUICK ) );
}

/****i* FlushAudio() *************************************************
*
* NAME
*    FlushAudio()
*
* DESCRIPTION
*    ^ <primitive 220 9 private1>
**********************************************************************
*
*/

METHODFUNC BOOL FlushAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, CMD_FLUSH, IOF_QUICK ) );
}


/****i* ResetAudio() *************************************************
*
* NAME
*    ResetAudio()
*
* DESCRIPTION
*    ^ <primitive 220 10 private1>
**********************************************************************
*
*/

METHODFUNC BOOL ResetAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, CMD_RESET, IOF_QUICK ) );
}


/****i* StopAudio() **************************************************
*
* NAME
*    StopAudio()
*
* DESCRIPTION
*    ^ <primitive 220 11 private1>
**********************************************************************
*
*/

METHODFUNC BOOL StopAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, CMD_STOP, IOF_QUICK ) );
}


/****i* StartAudio() *************************************************
*
* NAME
*    StartAudio()
*
* DESCRIPTION
*    ^ <primitive 220 12 private1>
**********************************************************************
*
*/

METHODFUNC BOOL StartAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, CMD_START, IOF_QUICK ) );
}


/****i* SetAudioPeriod() *********************************************
*
* NAME
*    SetAudioPeriod()
*
* DESCRIPTION
*    ^ <primitive 220 13 private1 newPeriod>
**********************************************************************
*
*/

METHODFUNC BOOL SetAudioPeriod( OBJECT *ioaObj, int period )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   
   
   if (!ioa) // == NULL)
      {
      NotFound( AudCMsg( MSG_AU_AUDIOCLASSNAME_AUDIO ) );

      return( FALSE );
      }

   ioa->ioa_Request.io_Command = ADCMD_PERVOL;
   ioa->ioa_Request.io_Flags   = IOF_QUICK | ADIOF_PERVOL;
   ioa->ioa_Period             = period;

   BeginIO( (struct IORequest *) ioa );

   return( TRUE );
}


/****i* SetAudioVolume() *********************************************
*
* NAME
*    SetAudioVolume()
*
* DESCRIPTION
*    ^ <primitive 220 14 private1 newVolume>
**********************************************************************
*
*/

METHODFUNC BOOL SetAudioVolume( OBJECT *ioaObj, int volume )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   
   
   if (!ioa) // == NULL)
      {
      NotFound( AudCMsg( MSG_AU_AUDIOCLASSNAME_AUDIO ) );

      return( FALSE );
      }

   ioa->ioa_Request.io_Command = ADCMD_PERVOL;
   ioa->ioa_Request.io_Flags   = IOF_QUICK | ADIOF_PERVOL;
   ioa->ioa_Volume             = volume;
   
   BeginIO( (struct IORequest *) ioa );

   return( TRUE );
}

/* ------------------ One-Channel commands: ---------------------- */

/****i* WriteAudio() *************************************************
*
* NAME
*    WriteAudio()
*
* DESCRIPTION
*    playAt: [private1] volume for: duration [aChannel]
*      ^ <primitive 220 15 private1 volume duration chNumber>
**********************************************************************
*
*/

METHODFUNC BOOL WriteAudio( OBJECT *ioaObj, int volume, 
                            int duration, UBYTE chNumber
                          )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   
   int             frequency;
      
   if (!ioa) // == NULL)
      {
      NotFound( AudCMsg( MSG_AU_AUDIOCLASSNAME_AUDIO ) );

      return( FALSE );
      }

   ioa->ioa_Request.io_Command = CMD_WRITE;
   ioa->ioa_Request.io_Flags   = IOF_QUICK | ADIOF_PERVOL;
   ioa->ioa_Volume             = volume;
   ioa->ioa_Request.io_Unit    = (struct Unit *) ((long) (chNumber & 0x0F));

   // Head off any Divide-by-zero errors:

   if (ioa->ioa_Period == 0)
      ioa->ioa_Period = 1;

   if (ioa->ioa_Length == 0)
      ioa->ioa_Length = 1;
      
   // Look at the frequency that it is to play by backwards calc.
   frequency = VideoClockFreq / (ioa->ioa_Length 
                                 * ioa->ioa_Period);

   /* Calculate cycles from duration in 1000ths of a second
   ** Multiply all-in-one to maintain max precision possible
   ** (all integer arithmetic.) 
   */

   ioa->ioa_Cycles = ((LONG) (frequency * duration) / 1000);
   
   BeginIO( (struct IORequest *) ioa );

   return( TRUE );
}


/****i* WaitCycleAudio() *********************************************
*
* NAME
*    WaitCycleAudio()
*
* DESCRIPTION
*    waitCycle [private1 aChannel]
*      ^ <primitive 220 16 private1 channel>
**********************************************************************
*
*/

METHODFUNC BOOL WaitCycleAudio( OBJECT *ioaObj, int channelnumber )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   
   
   if (!ioa) // == NULL)
      {
      NotFound( AudCMsg( MSG_AU_AUDIOCLASSNAME_AUDIO ) );

      return( FALSE );
      }

   ioa->ioa_Request.io_Command = ADCMD_WAITCYCLE;
   ioa->ioa_Request.io_Flags   = IOF_QUICK | ADIOF_PERVOL;
   ioa->ioa_Request.io_Unit    = (struct Unit *) ((long) (channelnumber & 0x0F));
   
   BeginIO( (struct IORequest *) ioa );

   return( TRUE );
}


/****i* ReadAudio() **************************************************
*
* NAME
*    ReadAudio()
*
* DESCRIPTION
*    ^ <primitive 220 17 private1 channel>
**********************************************************************
*
*/

METHODFUNC OBJECT *ReadAudio( OBJECT *ioaObj, int channelnumber )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   
   
   if (!ioa) // == NULL)
      {
      NotFound( AudCMsg( MSG_AU_AUDIOCLASSNAME_AUDIO ) );

      return( o_nil );
      }

   ioa->ioa_Request.io_Command = CMD_READ;
   ioa->ioa_Request.io_Flags   = IOF_QUICK;
   ioa->ioa_Request.io_Unit    = (struct Unit *) ((long) (channelnumber & 0x0F));
   
   BeginIO( (struct IORequest *) ioa );

   if (!ioa->ioa_Data) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_address( (int) ioa->ioa_Data )));
}

/* --------------------------------------------------------------- */


/****i* ReadAudioFile() **********************************************
*
* NAME
*    ReadAudioFile()
*
* DESCRIPTION
*    ^ <primitive 220 18 private1 filename size>
**********************************************************************
*
*/

METHODFUNC BOOL ReadAudioFile( OBJECT *ioaObj, char *filename, int size )
{
   struct IOAudio *ioa    = (struct IOAudio *) CheckObject( ioaObj );
   FILE           *infile = fopen( filename, FILE_READ_STR );
   char           *buf    = NULL;
   int             i;
      
   if (!ioa) // == NULL)
      return( FALSE );
      
   if (!infile) // == NULL)
      return( FALSE );
      
   if (size > 1)
      {
      if (size % 2 != 0)
         buf = (char *) AT_AllocVec( size + 1, MEMF_CHIP | MEMF_CLEAR, 
                                     "AudioBuff", TRUE 
                                   );
      else
         buf = (char *) AT_AllocVec( size, MEMF_CHIP | MEMF_CLEAR, 
                                     "AudioBuff", TRUE 
                                   );
      }
   else
      {
      UserInfo( AudCMsg( MSG_AU_TOO_SMALL_AUDIO ), UserPgmError );

      fclose( infile );
      
      return( FALSE );
      }

   if (!buf) // == NULL)
      {
      fclose( infile );

      return( FALSE );
      }

   if ((size % 2) != 0)
      {
      for (i = 0; i < (size + 1); i++)
         *(buf + i) = fgetc( infile );
      }
   else
      {
      for (i = 0; i < size; i++)
         *(buf + i) = fgetc( infile );
      }

   ioa->ioa_Length = size;
   ioa->ioa_Data   = buf;

   fclose( infile );

   return( TRUE );
}


/****i* SaveAudioFile() **********************************************
*
* NAME
*    SaveAudioFile()
*
* DESCRIPTION
*    ^ <primitive 220 19 private1 filename size>
**********************************************************************
*
*/

METHODFUNC BOOL SaveAudioFile( OBJECT *ioaObj, char *filename, int size )
{
   struct IOAudio *ioa  = (struct IOAudio *) CheckObject( ioaObj );
   FILE           *fout = fopen( filename, FILE_WRITE_STR );

   if (!ioa || !fout) // == NULL)
      {
      fclose( fout );
      
      return( FALSE );
      }

   (void) fwrite( ioa->ioa_Data, size, 1, fout );
            
   fclose( fout );

   return( TRUE );
}

/****i* FreeAudio() [2.1] ********************************************
*
* NAME
*    FreeAudio()
*
* DESCRIPTION
*    <primitive 220 20 private1 private2 chNumber>
**********************************************************************
*
*/

METHODFUNC void FreeAudio( OBJECT *ioaObj, OBJECT *aPortObj, int chNumber )
{
   struct IOAudio *ioa   = (struct IOAudio *) CheckObject( ioaObj );
   struct MsgPort *aPort = (struct MsgPort *) CheckObject( aPortObj );   

   if (!ioa || !aPort) // == NULL)
      return;

   ioa->ioa_Request.io_Command = ADCMD_FREE;
   ioa->ioa_Request.io_Unit    = (struct Unit *) ((long) (chNumber & 0x0F));
   ioa->ioa_Request.io_Flags   = IOF_QUICK;

   BeginIO( (struct IORequest *) ioa );

   WaitPort( aPort );

   (void) GetMsg( aPort );

   return;
}

/****i* openChannel() [2.1] ******************************************
*
* NAME
*    openChannel()
*
* DESCRIPTION
*    ^ <primitive 220 21 private1 newPriority chByteArray>
**********************************************************************
*
*/

METHODFUNC BOOL openChannel( OBJECT *ioaObj, BYTE priority, OBJECT *chBytes )
{
   struct IOAudio *ioa      = (struct IOAudio *) CheckObject( ioaObj );   
   UBYTE          *channels = ((BYTEARRAY *) chBytes)->bytes;

   if (!ioa) // == NULL)
      return( FALSE );
      
   ioa->ioa_Request.io_Message.mn_Node.ln_Pri = priority;

   ioa->ioa_Request.io_Command = ADCMD_ALLOCATE;
   ioa->ioa_Data               = channels;
   ioa->ioa_Request.io_Flags   = IOF_QUICK;
   ioa->ioa_Length             = CH_ARRAY_SIZE;
   
   BeginIO( (struct IORequest *) ioa );
   
   return( TRUE );
}

/****i* GetAudioKey() [2.1] ******************************************
*
* NAME
*    GetAudioKey()
*
* DESCRIPTION
*    ^ <primitive 220 22 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetAudioKey( OBJECT *ioaObj )
{
   struct IOAudio *aPtr = (struct IOAudio *) CheckObject( ioaObj );   
   OBJECT         *rval = o_nil;

   if (!aPtr) // == NULL)
      {
      return( rval );
      }
      
   rval = AssignObj( new_int( (int) aPtr->ioa_AllocKey ) );

   return( rval );
}

/****i* setChannel() [2.1] *******************************************
*
* NAME
*    setChannel()
*
* DESCRIPTION
*    <primitive 220 23 private1 chNumber>
**********************************************************************
*
*/

METHODFUNC void setChannel( OBJECT *ioaObj, int chNumber )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   if (!ioa) // == NULL)
      return;

   ioa->ioa_Request.io_Unit = (struct Unit *) ((long) (chNumber & 0x0F));
   
   return;   
}

/****i* ClearAudio() *************************************************
*
* NAME
*    ClearAudio()
*
* DESCRIPTION
*    ^ <primitive 220 24 private1>
**********************************************************************
*
*/

METHODFUNC BOOL ClearAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, CMD_CLEAR, IOF_QUICK ) );
}

/****i* UpdateAudio() ************************************************
*
* NAME
*    UpdateAudio()
*
* DESCRIPTION
*    ^ <primitive 220 25 private1>
**********************************************************************
*
*/

METHODFUNC BOOL UpdateAudio( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );   

   return( IssueCommand( ioa, CMD_UPDATE, IOF_QUICK ) );
}

/****i* setData() [2.1] **********************************************
*
* NAME
*    setData()
*
* DESCRIPTION
*    <primitive 220 26 private1 aByteArray>
**********************************************************************
*
*/

METHODFUNC OBJECT *setData( OBJECT *ioaObj, OBJECT *byteObj )
{
   struct IOAudio *ioa  = (struct IOAudio *) CheckObject( ioaObj );
   char           *buf  = NULL;
   int             size = ((BYTEARRAY *) byteObj)->bsize;
   OBJECT         *rval = o_nil;
   int             i;
         
   if (!ioa) // == NULL)
      return( rval );

   if (size > 1)
      {
      if ((size % 2) != 0)
         buf = (char *) AT_AllocVec( size + 1, MEMF_CHIP | MEMF_CLEAR,
                                     "AudioBuff", TRUE 
                                   );
      else
         buf = (char *) AT_AllocVec( size, MEMF_CHIP | MEMF_CLEAR, 
                                     "AudioBuff", TRUE
                                   );
      }
   else
      {
      UserInfo( AudCMsg( MSG_AU_TOO_SMALL_AUDIO ), UserPgmError );
      
      return( rval );
      }

   if (!buf) // == NULL)
      {
      return( rval );
      }

   for (i = 0; i < size; i++)
       *(buf + i) = ((BYTEARRAY *) byteObj)->bytes[i];

   if ((size % 2) != 0)
      *(buf + size + 1) = NIL_CHAR;
      
   ioa->ioa_Data   = buf;
   ioa->ioa_Length = (size % 2 == 0) ? size : size + 1;
   
   return( AssignObj( new_address( (ULONG) buf ) ) );
}

/****i* getChannel() [2.1] *******************************************
*
* NAME
*    getChannel()
*
* DESCRIPTION
*    ^ <primitive 220 27 private1>
**********************************************************************
*
*/

METHODFUNC OBJECT *getChannel( OBJECT *ioaObj )
{
   struct IOAudio *ioa = (struct IOAudio *) CheckObject( ioaObj );
   
   if (!ioa) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_int( (int) ioa->ioa_Request.io_Unit & 0x0F )));
}

/****i* HandleAudio() [2.1] ******************************************
*
* NAME
*    HandleAudio() <220>
*
* DESCRIPTION
**********************************************************************
*
*/

PUBLIC OBJECT *HandleAudio( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
      
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 220 );
      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0:  // disposePort
               //   <primitive 220 0 private1 private2>
         killAudioPort( args[1], args[2] );
   
         break;

      case 1: // allocIOAudio
              // ^ private1 <- <primitive 220 1>
         rval = allocIOAudio();
         break;

      case 2: // freeData [private3]
              //   <primitive 220 2 private3>
         freeData( args[1] );
         
         break;

      case 3: // allocAudioMsgPort
              // ^ private2 <- <primitive 220 3 private1 portName flags 
              //                                newPriority channelBytes>
         if (!is_string( args[2] ) || !is_integer( args[3] )
                                   || !is_integer( args[4] )
                                   || !is_bytearray( args[5] ))
            (void) PrintArgTypeError( 220 );
         else
            rval = allocAudioMsgPort( args[1],
                                           string_value( (STRING *) args[2] ),
                                      (ULONG) int_value( args[3] ),
                                      (BYTE)  int_value( args[4] ),
                                      args[5]
                                    );
         break;

      case 5: // killIOAudio
              //   <primitive 220 5 private1>
         killIOAudio( args[1] );
         break;

      case 6: // setPriority: [private1] newPriority
              // ^ <primitive 220 6 private1 newPriority>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            {
            if (SetPriority( args[1], int_value( args[2] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }
            
         break;
         
      case 7: // audioLock [private1]
              // ^ <primitive 220 7 private1>
         if (GetAudioLock( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
            
         break;
         
      case 8: // finishAudio [private1]
              // ^ <primitive 220 8 private1>
         if (FinishAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
            
         break;

      case 9: // flush [private1] 
              // ^ <primitive 220 9 private1>
         if (FlushAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
            
         break;

      case 10: // reset [private1]
               // ^ <primitive 220 10 private1>
         if (ResetAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
            
         break;

      case 11: // stop [private1]
               // ^ <primitive 220 11 private1>
         if (StopAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
            
         break;

      case 12: // start [private1]
               // ^ <primitive 220 12 private1>
         if (StartAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
            
         break;

      case 13: // setAudioPeriod: [private1] newPeriod
               // ^ <primitive 220 13 private1 newPeriod>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            {
            if (SetAudioPeriod( args[1], int_value( args[2] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }

         break;

      case 14: // setAudioVolume: [private1] volume
               // ^ <primitive 220 14 private1 volume>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            {
            if (SetAudioVolume( args[1], int_value( args[2] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }

         break;

      case 15: // play: [private1] volume for: duration in: chNumber
               // ^ <primitive 220 15 private1 volume duration chNumber>
         if (!is_integer( args[2] ) || !is_integer( args[3] )
                                    || !is_integer( args[4] ))
            (void) PrintArgTypeError( 220 );
         else
            {
            if (WriteAudio( args[1], int_value( args[2] ),
                                     int_value( args[3] ),
                            (UBYTE)  int_value( args[4] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }

         break;

      case 16: // waitCycle: [private1] channel
               // ^ <primitive 220 16 private1 channel>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            {
            if (WaitCycleAudio( args[1], int_value( args[2] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }

         break;

      case 17: // read: [private1] channel
               // ^ <primitive 220 17 private1 channel>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            rval = ReadAudio( args[1], int_value( args[2] ) );

         break;

      case 18: // readFile: [private1] fileName size: size
               // ^ <primitive 220 18 fileName aBuffer size>
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 220 );
         else
            {
            if (ReadAudioFile( args[1], string_value( (STRING *) args[2] ),
                                           int_value( args[3] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }

         break;

      case 19: // writeFile: [private1] fileName size: size
               // ^ <primitive 220 19 private1 fileName size>
         if (!is_string( args[2] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 220 );
         else
            {
            if (SaveAudioFile( args[1], string_value( (STRING *) args[2] ),
                                           int_value( args[3] ) ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }

         break;

      case 20: // freeChannel: [private1 private2] channelNumber
               //   <primitive 220 20 private1 private2 chNumber>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            FreeAudio( args[1], args[2], int_value( args[3] ) );
    
         break;
            
      case 21: // openChannel: [private1] chByteArray priority: pri
               // ^ <primitive 220 21 private1 newPriority chByteArray>
         if (!is_integer( args[2] ) || !is_bytearray( args[3] ))
            (void) PrintArgTypeError( 220 );
         else
            {
            if (openChannel( args[1], 
                             (BYTE) int_value( args[2] ), args[3] ) == TRUE)
               rval = o_true;
            else
               rval = o_false;
            }
         
         break;
         
      case 22: // audioKey
               // ^ <primitive 220 22 private1>
         rval = GetAudioKey( args[1] );
         break;

      case 23: // setChannel: chNumber 
               //   <primitive 220 23 private1 chNumber>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            setChannel( args[1], int_value( args[2] ) );
         
         break;
      
      case 24: // clear
               // ^ <primitive 220 24 private1>
         if (ClearAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
         
         break;
         
      case 25: // update   
               // ^ <primitive 220 25 private1>
         if (UpdateAudio( args[1] ) == TRUE)
            rval = o_true;
         else
            rval = o_false;
         
         break;
      
      case 26: // setData: [private1] aByteArray
               //   <primitive 220 26 private1 aByteArray>
         if (is_bytearray( args[2] ) == FALSE)
            (void) PrintArgTypeError( 220 );
         else
            rval = setData( args[1], args[2] );

         break;

      case 27: // getChannel: [private1]
               //   ^ <primitive 220 27 private1>
         rval = getChannel( args[1] );

         break;
         
      default:
         (void) PrintArgTypeError( 220 );

         break;
      }

   return( rval );
}

/* -------------------- END of Audio.c file! -------------- */
