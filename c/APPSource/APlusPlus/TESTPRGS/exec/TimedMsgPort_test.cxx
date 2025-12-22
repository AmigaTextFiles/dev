/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/exec/TimedMsgPort_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.5 $
 *    $Date: 1994/07/23 19:14:42 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


//** Creates two living objects of 'MyTask' class which both open a 'TimedMsgPort'
//** and send a message to each other.
//** IMPORTANT NOTE: LvObject class ONLY works compiled and linked with SAS®/C!!


#include <APlusPlus/exec/LvObject.h>
#include <APlusPlus/exec/TimedMsgPort.h>
#include <APlusPlus/exec/MessageC.h>
#include <iostream.h>


volatile static char rcs_id[] = "$Id: TimedMsgPort_test.cxx,v 1.5 1994/07/23 19:14:42 Armin_Vogt Exp Armin_Vogt $";


/**************************** MySRSP ***********************************/
class MySRSP : public SignalResponder
{
   private:
      BOOL running;
   public:
      MySRSP() : SignalResponder(SIGBREAKB_CTRL_C,0)
      { running = TRUE; }
      ~MySRSP() {}

      // overwrite the virtual 'signal received' action callback method.
      void actionCallback()
      {
         cout << "**Break. You pressed CTRL-C.\n";
         running = FALSE;
      }

      BOOL hasNotOccured() { return running==TRUE; }
};


/**************************** MyMsgPort ***********************************/
class TM : public MessageC
{
   public:
      TM(const UBYTE *text) { textString = text; }
      const UBYTE *string() { return textString; }

   private:
      const UBYTE *textString;
};

class MyMsgPort : public TimedMsgPort
{
   public:
      MyMsgPort(const UBYTE *portName,BYTE portPri=0,UWORD sendWindowSize=1)
      : TimedMsgPort(portName,portPri,sendWindowSize) { }
      ~MyMsgPort() {}

      void processMsg(MessageC *msg)
      {
         cout << "msgport("<<(APTR)this << ") : received message '"<<((TM*)msg)->string()<<"'\n";
      }
      void processReply(MessageC *reply)
      {
         cout << "msgport("<<(APTR)this << ") : reply received\n";
      }
};


/**************************** MyTask ***********************************/
class MyTask : public LivingObject
{
   private:
      const UBYTE *portName,*destination;
   protected:
      int main();
   public:
      MyTask(const UBYTE *myName,const UBYTE *destName)
      : portName(myName), destination(destName) { activate(); }
      ~MyTask() {}

};

int MyTask::main()
{
   cout << "\tHello! I'm a living object running on a seperate task.\n"
        << "\tI'm now engaging my SignalResponder which will catch your CTRL-C break signal..\n";

   MySRSP ctrlCBreak;
   MyMsgPort msgPort(portName);

   // create a message object of a class derived from MessageC
   TM textMessage((UBYTE*)"This is a message text.");

   cout << "\tSending..\n";
   msgPort.sendMsgToPort(textMessage,destination);

   cout << "\tWaiting..\n";

   while ( ctrlCBreak.hasNotOccured() )
   {
      SignalResponder::WaitSignal();   // dispatch next signal
   }

   cout << "\tmsgport(" <<(APTR)this << ") says 'Goodbye'.\n\n";
   return 0;
}

main()
{
   {
   cout << "Welcome to TimedMsgPort_test!\n";

   cout << "Now I'm going to create a living object of 'MyTask' class..\n\n";

   MyTask child1((UBYTE*)"child1",(UBYTE*)"child2"),  // create and start task that executes MyTask::main().
          child2((UBYTE*)"child2",(UBYTE*)"child1");

   cout << "This is main: I'm setting up a CTRL-C break SignalResponder.\n"
        << "Press CTRL-C to leave this demo.\n";

   MySRSP ctrlCBreak;   // create a signal responder that catches CTRL-C break signal.


   while ( ctrlCBreak.hasNotOccured() )
   {
      SignalResponder::WaitSignal();   // wait for any signals
   }

   cout << "I got your break signal. Thank You.\n";
   cout << "Waiting for child process..\n";
   }
   cout << "Child process terminated. Goodbye.\nEND\n";
   return 0;
}
