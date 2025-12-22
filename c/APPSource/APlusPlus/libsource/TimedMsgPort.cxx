/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/TimedMsgPort.cxx,v $
 **   $Revision: 1.8 $
 **   $Date: 1994/07/27 11:52:26 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/

extern "C"
{
#include <string.h>
}
#include <APlusPlus/exec/MessageC.h>
#include <APlusPlus/devices/TimerC.h>
#include <APlusPlus/exec/TimedMsgPort.h>


#define TIMEOUT_SECS 5
// timeout is 5 seconds after sending


static const char rcs_id[] = "$Id: TimedMsgPort.cxx,v 1.8 1994/07/27 11:52:26 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
typeinfo(TimedMsgPort, derived(from(SignalResponder)), rcs_id)


TimedMsgPort::TimedMsgPort(struct MsgPort* port,UWORD sendWindowSize)
   : SignalResponder((BYTE)port->mp_SigBit,0),sendWindow(sendWindowSize),hasCreatedPort(FALSE)
{
   setID(MSGRESPONDER_CLASS);
}

TimedMsgPort::TimedMsgPort(const UBYTE* portName,BYTE portPri,UWORD sendWindowSize)
   : SignalResponder(0,0), sendWindow(sendWindowSize)
{
   if (port = CreateMsgPort())
   {
      changeSignalBit(port->mp_SigBit);
      port->mp_Node.ln_Name = (char*)portName;
      port->mp_Node.ln_Pri  = portPri;
      if (portName)  AddPort(port);
      hasCreatedPort = TRUE;
      setID(MSGRESPONDER_CLASS);
   }
   else _ierror(MSGPORTRESPONDER_CREATEMSGPORT_FAILED);
}

TimedMsgPort::~TimedMsgPort()
{
   if (hasCreatedPort == TRUE)
   {
      // if port is public remove from public port list
      if (FindPort((UBYTE*)port->mp_Node.ln_Name)) RemPort(port);

      // reply all messages still in the message queue
      MessageC* msg;
      Forbid();
      while (NULL != (msg = (MessageC*)GetMsg(port))) msg->replyMsg();
      DeleteMsgPort(port);
      Permit();
   }
}

void TimedMsgPort::actionCallback()
   /* get the message from the port an call the virtual message processing method.
      The message will not be replied from this instance. This must be done in processMsg()
      or somewhere later.
   */
{
   MessageC* msg;

   while (NULL != (msg = (MessageC*)GetMsg(port)))
   {
      msg->signRemoved();  // change MessageC MsgState from MSG_SENT to MSG_IN_PROCESS

      if (msg->getMsgState() == MSG_REPLIED)
      {
         // remove the replied message from the sending window
         if (sendWindow.remove(msg))
         {
            processReply(msg);
         }
         else // Timer message replied
         {
            if (sendWindow.timeout(msg))
            {
               puterr("TimedMsgPort : message timed out!\n");
            }
            else // was no timer message !?
            {
               puterr("TimedMsgPort : Foreign message received.\n");
            }
         }
      }
      else // no reply message
      {
         processMsg(msg);
         msg->replyMsg();
      }
   }
}

BOOL TimedMsgPort::sendMsgToPort(MessageC* msg,struct MsgPort* mp)
{
   TimerC* timeout;
   msg->setReplyPort(port);   // set reply port before inserting the message!

   if (NULL != (timeout = sendWindow.insert(msg)) )
   {
      if (mp->mp_Node.ln_Type == NT_MSGPORT && mp->mp_MsgList.lh_Head != (struct Node*)-1)
      {
         timeout->start();
         PutMsg(mp,msg);
         return TRUE;
      }
      else puterr("TimedMsgPort::sendMsgToPort : destination port is not valid!\n");
   }
   return FALSE;
}

BOOL TimedMsgPort::sendMsgToPort(MessageC* message,const UBYTE* destinationName)
{
   struct MsgPort* mp;
   BOOL rv = FALSE;
   Forbid();
   if (NULL != (mp = FindPort((UBYTE*)destinationName)) )
      rv = sendMsgToPort(message,mp);
   Permit();
   return rv;
}

//--------------------- SendingWindow -------------------------------
struct MsgEntry
{
   MessageC* message;   // sent message
   TimerC*   timeout;   // timer set up for time out on the message
};

TimedMsgPort::SendingWindow::SendingWindow(UWORD size)
{
   entryTable = new MsgEntry[entries=size];
   memset(entryTable,0,sizeof(MsgEntry)*size);
}

TimedMsgPort::SendingWindow::~SendingWindow()
{
   MsgEntry* entry = entryTable;
   for (UWORD n=entries; n>0; n--,entry++)
      if (entry->timeout) delete entry->timeout;

   delete [] entryTable;
}

TimerC* TimedMsgPort::SendingWindow::insert(MessageC* msg)
{
   MsgEntry* entry = entryTable;
   for (UWORD n=entries; n>0; n--,entry++)
      if (entry->message==NULL)
      {
         if (entry->timeout==NULL)
            if ( !(entry->timeout = new TimerC(UNIT_VBLANK,msg->getReplyPort())) )
               return NULL;
            else entry->timeout->set(TIMEOUT_SECS);

         entry->message = msg;
         return entry->timeout;
      }

   return NULL;
}

BOOL TimedMsgPort::SendingWindow::remove(MessageC* msg)
{
   MsgEntry* entry = entryTable;
   for (UWORD n=entries; n>0; n--,entry++)
      if (entry->message == msg)
      {
         entry->timeout->abort();
         entry->message == NULL;
         return TRUE;
      }

   return FALSE;
}

MessageC* TimedMsgPort::SendingWindow::timeout(MessageC* timerMsg)
{
   MsgEntry* entry = entryTable;
   for (UWORD n=entries; n>0; n--,entry++)
      if (entry->timeout->getMessage() == timerMsg)
      {
         entry->timeout->reuse();
         MessageC* timedOutMsg = entry->message;
         entry->message = NULL;
         return timedOutMsg;
      }

   return NULL;
}
