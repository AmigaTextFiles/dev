/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/TimerC.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/27 11:52:33 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C"
{
#ifdef __GNUG__
#include <inline/timer.h>
#include <inline/exec.h>
#endif

#ifdef __SASC
#include <proto/timer.h>
#include <proto/exec.h>
#endif

#include <string.h>
}
#include <APlusPlus/devices/TimerC.h>


static const char rcs_id[] = "$Id: TimerC.cxx,v 1.7 1994/07/27 11:52:33 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
typeinfo(TimerC, no_bases, rcs_id)


TimerC::TimerC(UWORD unit,struct MsgPort* replyPort)
{
   set(0,0);
   create(unit,replyPort);
}

TimerC::~TimerC()
{
   dispose();
}

BOOL TimerC::create(UWORD unit,struct MsgPort* replyPort)
   /* create a timer object to a msgport.
   */
{
   memset((APTR)&timerIO,0,sizeof(timerequest));
   timerIO.tr_node.io_Message.mn_ReplyPort = replyPort;

   if ( !(OpenDevice((UBYTE*)TIMERNAME,(ULONG)unit,(struct IORequest*)&timerIO,(ULONG)0L)) )
   {
      timerIO.tr_node.io_Command = TR_ADDREQUEST;
      timerIO.tr_time = time;   // copy time values to Timer IORequest.
      sent = FALSE;
      setID(TIMER_CLASS);
      return TRUE;
   }
   else
   {
      _ierror(TIMER_OPENDEVICE_FAILED);
      return FALSE;
   }
}

void TimerC::dispose()
   /* Dispose of the timerequest, no matter if it is sent or in the replyport's message queue.
   */
{
   if (Ok())
   {
      abort();  // make sure the Timer is no longer in use.
      CloseDevice((struct IORequest*)&timerIO);
      setID(APPOBJECT_INVALID);
   }
}

BOOL TimerC::start(ULONG secs,ULONG micros)
{
   if (Ok())
      if (sent==FALSE)
      {
         if (secs || micros)  set(secs,micros);

         timerIO.tr_time = time;    // copy time values to Timer IORequest.
         SendIO((struct IORequest*)&timerIO);
         sent = TRUE;
         return TRUE;
      }

   return FALSE;
}

void TimerC::abort()
   /* Abort a started Timer. If the Timer has not been started yet, nothing will happen.
      After execution the Timer is ready to be started again.
   */
{
   if (Ok())
      if (sent==TRUE)
      {
         AbortIO((struct IORequest*)&timerIO);  // tell timer device to send back request if not done.
         WaitIO((struct IORequest*)&timerIO);   // wait for arrival, then remove from message queue.
         sent = FALSE;
      }
}

BOOL TimerC::reuse()
   /* Make a Timer that has returned from the Timer.device useable for subsequent start().
      Usually call reuse() after having received and identified a timer reply message.
      An already sent Timer that has not been replied yet will fail being reused and return FALSE.
      To reuse an already sent Timer without waiting for it any longer use abort().
   */
{
   if (Ok())
      if (sent == FALSE)   // timer is not in use.
         return TRUE;
      else
         if (CheckIO((struct IORequest*)&timerIO))  // request already replied ?
         {
            // the replied request is assumed be removed from the port queue via getMsg().
            sent = FALSE;
            return TRUE;
         }

   return FALSE;
}

void TimerC::changeReplyPort(UWORD unit,struct MsgPort* newReplyPort)
{
   dispose();
   create(unit,newReplyPort);
}
