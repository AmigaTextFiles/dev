/****h* AmigaTalk/Timer.c [3.0] *****************************************
*
* NAME
*    Timer.c
*
* DESCRIPTION 
*    This file contains the code to control the Amiga timer device.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleTimers( int numargs, OBJECT **args ); // 228
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    04-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    There is a function in NewPrimitive that's related to 
*    the timer stuff (GetCurrentTime() #160).  It returns a string
*    of the form:
*       
*       'DDD MMM dd hh:mm:ss YYYY\n\0'   -> 26 bytes long.
*        
*    Any User that expects to use AmigaTalk to get accurate
*    time measurements has a hole in their head - there is too
*    much overhead associated with interpreting the AmigaTalk
*    commands for ReadEClockLow() calls to be meaningful.
*
*    $VER: AmigaTalk:Src/Timer.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <string.h>

#include <AmigaDOSErrs.h>

#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <devices/timer.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/alib_protos.h>
# include <clib/dos_protos.h>

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/timer.h>

IMPORT  struct ExecIFace  *IExec;
PRIVATE struct TimerIFace *ITimer;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "Object.h"
#include "FuncProtos.h"
#include "IStructs.h"

#include <proto/locale.h>

IMPORT struct Catalog *catalog;

#define  CATCOMP_ARRAY 1
#include "ATalkLocale.h"

//#define    TIMER_C
# include "StringConstants.h"
//#undef     TIMER_C

IMPORT OBJECT *PrintArgTypeError( int primnumber );

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *UserProblem;
IMPORT UBYTE  *ErrMsg;

#ifdef __SASC
PUBLIC struct Library *TimerBase = NULL;
#else
PUBLIC struct Device  *TimerBase = NULL;
#endif

/* manifest constants -- "never will change" */

#define   SECSPERMIN   (60)
#define   SECSPERHOUR  (60*60)
#define   SECSPERDAY   (60*60*24)

/****i* NotRegistered() **********************************************
*
* NAME
*    Notregistered()
**********************************************************************
*
*/

SUBFUNC void NotRegistered( void )
{
   UserInfo( CMsg( MSG_TIMER_UNREGISTERED, MSG_TIMER_UNREGISTERED_STR ),
             UserProblem
           );
   
   return;
}

/****i* SetupTimer() [1.0] *******************************************
*
* NAME
*    SetupTimer()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *SetupTimer( int unitType, int secs, int micros, char *tname )
{
   struct eTimer *t    = NULL;
   OBJECT        *rval = o_nil;
      
   if (!(t = (struct eTimer *) AT_AllocVec( sizeof( struct eTimer ), 
                                            MEMF_CLEAR | MEMF_ANY,
                                            "eTimer", TRUE ))) // == NULL)
      {
      MemoryOut( CMsg( MSG_TIMEROPEN_FUNC, MSG_TIMEROPEN_FUNC_STR ) );

      return( rval );
      }

#  ifdef __SASC
   if (!(t->TimeMsgPort = (struct MsgPort *) CreatePort( tname, 0 ))) // == NULL)
#  else
   if (!(t->TimeMsgPort = AllocSysObjectTags(  ASOT_PORT, ASOPORT_Name, tname, TAG_DONE )))
#  endif
      {
      CannotCreatePort( CMsg( MSG_TIMER_CLASSNAME, MSG_TIMER_CLASSNAME_STR ) );

      AT_FreeVec( t, "eTimer", TRUE );

      return( rval );
      }

#  ifdef __amigaos4__
   if (!(t->TimerPtr = (struct timerequest *) 
                        AllocSysObjectTags( ASOT_IOREQUEST, 
                                            ASOIOR_Size,      sizeof( struct timerequest ),
		 		            ASOIOR_ReplyPort, t->TimeMsgPort, 
			 	            TAG_DONE
				           )))
      {
      CannotCreatePort( CMsg( MSG_TIMER_CLASSNAME, MSG_TIMER_CLASSNAME_STR ) );

      FreeSysObject( ASOT_PORT, (APTR) t->TimeMsgPort );
      
      AT_FreeVec( t, "eTimer", TRUE );

      return( rval );
      }
#  else
   if (!(t = (struct timerequest *) AT_AllocVec( sizeof( struct timerequest ), 
                                                 MEMF_CLEAR | MEMF_ANY,
                                                 "timerequest", TRUE ))) // == NULL)
      {
      MemoryOut( CMsg( MSG_TIMEROPEN_FUNC, MSG_TIMEROPEN_FUNC_STR ) );

      DeletePort( t->TimeMsgPort );

      AT_FreeVec( t, "eTimer", TRUE );

      return( rval );
      }

   t->TimerPtr->tr_node.io_Message.mn_Node.ln_Type = NT_MESSAGE;
   t->TimerPtr->tr_node.io_Message.mn_Node.ln_Pri  = 0;
   t->TimerPtr->tr_node.io_Message.mn_ReplyPort    = t->TimeMsgPort;
#  endif

   if (OpenDevice( TIMERNAME, unitType, (struct IORequest *) &t->TimerPtr, 0 ) != 0)
      {
      CannotOpenDevice( TIMERNAME );

#     ifdef __amigaos4__
      FreeSysObject( ASOT_IOREQUEST, (APTR) t->TimerPtr    ); 
      FreeSysObject( ASOT_PORT,      (APTR) t->TimeMsgPort ); 
#     else
      DeletePort( t->TimeMsgPort );
#     endif

      AT_FreeVec( t->TimerPtr, "timerequest", TRUE );
      AT_FreeVec( t,           "eTimer",      TRUE );

      return( rval );
      }
 
   t->TimerPtr->tr_time.tv_secs  = secs;
   t->TimerPtr->tr_time.tv_micro = micros;

#  ifndef __amigaos4__
   TimerBase = (struct Library *) t->TimerPtr->tr_node.io_Device;
#  else
   TimerBase = (struct Device *) t->TimerPtr->tr_node.io_Device;

   if (!(ITimer = (struct TimerIFace *) GetInterface( (struct Library *) TimerBase, "main", 1, NULL )))
      {
      ObjectWasZero( "struct TimerIFace *ITimer" );

      CloseDevice( (struct IORequest *) t->TimerPtr );

      FreeSysObject( ASOT_IOREQUEST, (APTR) t->TimerPtr    ); 
      FreeSysObject( ASOT_PORT,      (APTR) t->TimeMsgPort ); 

      AT_FreeVec( t,           "eTimer",      TRUE );

      TimerBase = (struct Device *) (-1);

      return( rval );
      }
#  endif

   rval = AssignObj( new_address( (ULONG) t ) );
   
   return( rval );
}

/****i* KillTimer() [1.0] ********************************************
*
* NAME
*    KillTimer()
*
* DESCRIPTION
*    Halt the timer's operation.
**********************************************************************
*
*/

METHODFUNC void KillTimer( OBJECT *timerObj )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return;
      }

   AbortIO( (struct IORequest *) t->TimerPtr );

   (void) GetMsg( t->TimeMsgPort );

   return;
}

/****i* CloseTimer() [1.0] *******************************************
*
* NAME
*    CloseTimer()
*
* DESCRIPTION
*    Free the Timer's resources.
**********************************************************************
*
*/

METHODFUNC void CloseTimer( OBJECT *timerObj )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return;
      }

   KillTimer( timerObj );

   CloseDevice( (struct IORequest *) t->TimerPtr );

#  ifdef __SASC
   DeletePort( t->TimeMsgPort );

   AT_FreeVec( t->TimerPtr, "timerequest", TRUE );

   TimerBase = (struct Library *) (-1);

#  else
   DropInterface( (struct Interface *) ITimer );

   FreeSysObject( ASOT_IOREQUEST, t->TimerPtr    );
   FreeSysObject( ASOT_PORT,      t->TimeMsgPort );

   TimerBase = (struct Device *) (-1);
#  endif


   AT_FreeVec( t, "eTimer", TRUE );
   
   return;
}

/****i* StartTimer() [1.0] *******************************************
*
* NAME
*    StartTimer()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void StartTimer( OBJECT *timerObj, int secs, int micros )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return;
      }

   t->TimerPtr->tr_time.tv_secs    = secs;
   t->TimerPtr->tr_time.tv_micro   = micros;
   t->TimerPtr->tr_node.io_Command = TR_ADDREQUEST;

   SendIO( (struct IORequest *) t->TimerPtr );

   return;
}

/****i* TimerDelay() [1.0] *******************************************
*
* NAME
*    TimerDelay()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC void TimerDelay( OBJECT *timerObj, int delayseconds, int micros )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return;
      }

   StartTimer( timerObj, delayseconds, micros );

   Wait( 1L << t->TimeMsgPort->mp_SigBit );

   (void) GetMsg( t->TimeMsgPort );

   return;
}

/****i* TestTimer() [1.0] ********************************************
*
* NAME
*    TestTimer()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *TestTimer( OBJECT *timerObj )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return( o_nil );
      }

   return( AssignObj( new_int( CheckIO( (struct IORequest *) t->TimerPtr ) 
                               && ( !t->TimerPtr->tr_node.io_Error)
                             )
                    ) 
         );
}

/****i* SetSystemTime() [1.0] ****************************************
*
* NAME
*    SetSystemTime()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *SetSystemTime( OBJECT *timerObj, int secs, int micros )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return( o_false );
      }

   t->TimerPtr->tr_time.tv_secs    = secs;
   t->TimerPtr->tr_time.tv_micro   = micros;
   t->TimerPtr->tr_node.io_Command = TR_SETSYSTIME;

   DoIO( (struct IORequest *) t->TimerPtr );

   return( o_true );
}

/****i* GetSystemSeconds() [1.0] *************************************
*
* NAME
*    GetSystemSeconds()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *GetSystemSeconds( OBJECT *timerObj )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return( o_nil );
      }

   t->TimerPtr->tr_node.io_Command = TR_GETSYSTIME;

   DoIO((struct IORequest *) t->TimerPtr );

   return( AssignObj( new_int( t->TimerPtr->tr_time.tv_secs ) ) );
}

/****i* GetSystemMicroSeconds() [1.0] ********************************
*
* NAME
*    GetSystemMicroSeconds()
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *GetSystemMicroSeconds( OBJECT *timerObj )
{
   struct eTimer *t = (struct eTimer *) CheckObject( timerObj );
   
   if (!t) // == NULL
      {
      NotRegistered();

      return( o_nil );
      }

   t->TimerPtr->tr_node.io_Command = TR_GETSYSTIME;

   DoIO((struct IORequest *) t->TimerPtr );

   return( AssignObj( new_int( t->TimerPtr->tr_time.tv_micro ) ) );
}

/****i* CompareTime() [1.0] ***************************************
*
* NAME
*    CompareTime()
*
* DESCRIPTION
*
* NOTES
*    if      t1 >  t2, return -1
*    else if t1 <  t2, return +1
*    else if t1 == t2, return 0
*******************************************************************
*
*/

METHODFUNC OBJECT *CompareTime( int secs1, int micros1, int secs2, int micros2 )
{
   struct timeval t1 = { 0, };
   struct timeval t2 = { 0, };

   t1.tv_secs  = secs1;
   t1.tv_micro = micros1;

   t2.tv_secs  = secs2;
   t2.tv_micro = micros2;
   
   return( AssignObj( new_int( CmpTime( &t1, &t2 ) ) ) );
}

/****i* ReadEClockHigh() [1.0] ***************************************
*
* NAME
*    ReadEClockHigh()
*
* DESCRIPTION
*    Read the high word from the EClock.
**********************************************************************
*
*/

METHODFUNC OBJECT *ReadEClockHigh( OBJECT *timerObj )
{
   struct eTimer    *t = (struct eTimer *) CheckObject( timerObj );
   struct EClockVal  ev;
   
   if (!t) // == NULL
      {
      NotRegistered();

      return( o_nil );
      }
      
   (void) ReadEClock( &ev );

   return( AssignObj( new_int( t->EClockValPtr.ev_hi ) ) );
}

/****i* ReadEClockLow() [1.0] ****************************************
*
* NAME
*    ReadEClockLow()
*
* DESCRIPTION
*    Read the low word from the EClock.
**********************************************************************
*
*/

METHODFUNC OBJECT *ReadEClockLow( OBJECT *timerObj )
{
   struct eTimer    *t = (struct eTimer *) CheckObject( timerObj );
   struct EClockVal  ev;
   
   if (!t) // == NULL
      {
      NotRegistered();

      return( o_nil );
      }

   (void) ReadEClock( &ev );

   return( AssignObj( new_int( t->EClockValPtr.ev_lo ) ) );
}

/****i* HandleTimers() [1.6] *****************************************
*
* NAME
*    HandleTimers()
*
* DESCRIPTION
*    Translate primitive 228 calls into Timer functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleTimers( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 228 );
      return( o_nil );
      }
         
   switch (int_value( args[0] ))
      {
      case 0:  
         if (NullChk( args[1] ) == FALSE)
            {
            CloseTimer( args[1] );
            }

         break;
      
      case 1:
         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_string(  args[4] )) 
            (void) PrintArgTypeError( 228 );
         else
            {
            rval = SetupTimer( int_value( args[1] ),              // unitType
                               int_value( args[2] ),              // seconds
                               int_value( args[3] ),              // micros
                               string_value( (STRING *) args[4] ) // timerName
                             );
            }

         break;

      case 2:
         KillTimer( args[1] );

         break;
      
      case 3:
         if (!is_integer( args[2] ) || !is_integer( args[3] )) 
            (void) PrintArgTypeError( 228 );
         else
            {
            StartTimer(            args[1],   // timerObj
                        int_value( args[2] ), // seconds
                        int_value( args[3] )  // micros
                      );
            }

         break;
      
      case 4:
         if ( !is_integer( args[2] ) || !is_integer( args[3] )) 
            (void) PrintArgTypeError( 228 );
         else
            {
            TimerDelay(            args[1]  , // timerObj
                        int_value( args[2] ), // seconds
                        int_value( args[3] )  // micros
                      );
            }

         break;

      case 5:
         rval = TestTimer( args[1] );

         break;
      
      case 6:
         rval = GetSystemSeconds( args[1] );

         break;

      case 7:
         rval = GetSystemMicroSeconds( args[1] );

         break;

      case 8:
         if ( !is_integer( args[2] ) || !is_integer( args[3] )) 
            (void) PrintArgTypeError( 228 );
         else
            rval = SetSystemTime(            args[1],
                                  int_value( args[2] ),
                                  int_value( args[3] )
                                );
         break;

      case 9:
      
         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_integer( args[4] )) 
            (void) PrintArgTypeError( 228 );
         else
            rval = CompareTime( int_value( args[1] ), // seconds1
                                int_value( args[2] ), // micros1
                                int_value( args[3] ), // seconds2 
                                int_value( args[4] )  // micros2
                              );

         break;

      case 10:
         rval = ReadEClockHigh( args[1] );
   
         break;
    
      case 11:
         rval = ReadEClockLow( args[1] );

         break;

      default:
         (void) PrintArgTypeError( 228 );
         break;
      }

   return( rval );
}

/* ------------------- END of Timer.c file! ----------------------- */
