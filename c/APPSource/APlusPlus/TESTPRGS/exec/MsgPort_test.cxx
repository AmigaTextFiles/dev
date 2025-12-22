/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/exec/MsgPort_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.6 $
 *    $Date: 1994/07/23 19:14:28 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


extern "C" {
#include <dos/dos.h>
}
#include <APlusPlus/exec/TimedMsgPort.h>
#include <APlusPlus/exec/MessageC.h>
#include <iostream.h>


volatile static char rcs_id[] = "$Id: MsgPort_test.cxx,v 1.6 1994/07/23 19:14:28 Armin_Vogt Exp Armin_Vogt $";


class MySRSP:  public SignalResponder
{
   private:
      BOOL running;
   public:
      MySRSP() : SignalResponder(SIGBREAKB_CTRL_C,0)
      { running = TRUE; }
      ~MySRSP() {}

      // overload the virtual 'signal received' action callback method.
      void actionCallback()
      {
         cout << "**Break\n";
         running = FALSE;
      }

      BOOL hasNotOccured() { return running==TRUE; }
};

/**************************** MyMsgPort ***********************************/
class TM : public MessageC
{
   private:
      const UBYTE *textString;
   public:
      TM(const UBYTE *text) { textString = text; }
      const UBYTE *string() { return textString; }

};

class MyMsgPort : public TimedMsgPort
{
   public:
      MyMsgPort(const UBYTE *portName,BYTE portPri=0,UWORD sendWindowSize=1)
      : TimedMsgPort(portName,portPri,sendWindowSize) { }
      ~MyMsgPort() {}

      void processMsg(MessageC *msg)
      {
         char c;
         cout <<"#"<< (APTR)this << ": received message '"<<((TM*)msg)->string()<<"'\n";
         cout <<"Press a key ->"; cin >> c; cout<<endl;
      }
      void processReply(MessageC *reply)
      {
         cout <<"#"<< (APTR)this << ": reply received\n";
      }
};

int main(int argc,char *argv[])
{
   MySRSP ctrlCBreak;

   cout << "SignalResponder - Test: please press CTRL-c to end this programm.\n";

   cout << "waiting..\n";
   MyMsgPort p1((UBYTE*)"Port_1"), p2((UBYTE*)"Port_2");
   TM tmsg1((UBYTE*)"Message_1"),tmsg2((UBYTE*)"Message_2");

   p1.sendMsgToPort(&tmsg1,(UBYTE*)"Port_2");
   p2.sendMsgToPort(&tmsg2,(UBYTE*)"Port_1");   // send after first message has arrived.

   while ( ctrlCBreak.hasNotOccured() )
   {
      SignalResponder::WaitSignal();
   }

   cout << "Thank You. Goodbye.\n";
   return 0;
}
