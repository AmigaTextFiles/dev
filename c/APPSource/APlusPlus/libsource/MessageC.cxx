/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/MessageC.cxx,v $
 **   $Revision: 1.7 $
 **   $Date: 1994/07/27 11:51:09 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <string.h>
#include <APlusPlus/exec/List.h>
#include <APlusPlus/exec/MessageC.h>


static const char rcs_id[] = "$Id: MessageC.cxx,v 1.7 1994/07/27 11:51:09 Armin_Vogt Exp Armin_Vogt $";


MessageC::MessageC()
{
   memset(this,0,sizeof(*this));
   signRemoved(); mn_Node.ln_Type = NT_FREEMSG;
}

MessageC::~MessageC()
{
   mn_Node.ln_Type = NT_DEATHMESSAGE;
}

void MessageC::signRemoved()
{
   mn_Node.ln_Succ = mn_Node.ln_Pred = (struct Node*)(struct Message*)this;
}

BOOL MessageC::isRemoved()
{
   return ((NodeC*)this)->isLonelyNode();
}

MsgState MessageC::getMsgState()
{
   switch (mn_Node.ln_Type)
   {
      case NT_MESSAGE :

         if (isRemoved()) return MSG_IN_PROCESS; else return MSG_SENT;
         break;

      case NT_REPLYMSG :

         if (isRemoved()) return MSG_FREE; else return MSG_REPLIED;
         break;
   }
   return MSG_FREE;
}

void MessageC::setReplyPort(struct MsgPort *port)
{
   if (getMsgState()&MSG_FREE) mn_ReplyPort = port;
}

BOOL MessageC::replyMsg()
{
   if (getMsgState()&MSG_SENT)
   {
      ReplyMsg(this);
      return TRUE;
   }
   else return FALSE;
}
