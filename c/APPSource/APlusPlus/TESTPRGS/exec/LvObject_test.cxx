/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/exec/LvObject_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.5 $
 *    $Date: 1994/07/23 19:14:20 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


//** IMPORTANT NOTE: LvObject class ONLY works compiled and linked with SAS®/C!!
#ifdef __SASC

#include <APlusPlus/exec/LvObject.h>
#include <APlusPlus/exec/SignalResponder.h>
#include <iostream.h>


volatile static char rcs_id[] = "$Id: LvObject_test.cxx,v 1.5 1994/07/23 19:14:20 Armin_Vogt Exp Armin_Vogt $";


class MySRSP : public SignalResponder
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
         cout << "**Break. You pressed CTRL-C.\n";
         running = FALSE;
      }

      BOOL hasNotOccured() { return running==TRUE; }
};


class MyTask : public LivingObject
{
   protected:
      int main();
   public:
      MyTask() { activate(); }   // start task on creation
      ~MyTask() {}

};

int MyTask::main()
{
   cout << "\tHello! I'm a living object running on a seperate task.\n"
        << "\tI'm now engaging my SignalResponder which will catch your CTRL-C break signal..\n";

   MySRSP ctrlCBreak;

   while ( ctrlCBreak.hasNotOccured() )
   {
      SignalResponder::WaitSignal();
   }

   cout << "\tThanks. Bye.\n\n";
   return 0;
}

main()
{{
   cout << "Welcome to Task_test!\n"
        << "IMPORTANT NOTE: if the program does not respond to your CTRL-C key press,\n"
        << "send it a break signal from a shell with the command 'break <process-no>'\n";

   cout << "Now I'm going to create a living object of 'MyTask' class..\n\n";

   MyTask child;  // create and start task that executes MyTask::main().

   cout << "This is main: I'm setting up a CTRL-C break SignalResponder.\n"
        << "Press CTRL-C to leave this demo.\n";

   MySRSP ctrlCBreak;   // create a signal responder that catches CTRL-C break signal.


   while ( ctrlCBreak.hasNotOccured() )
   {
      SignalResponder::WaitSignal();   // wait for any signals
   }

   cout << "I got your break signal. Thank You.\nNow, waiting for child process to terminate..\n";
   }
   cout << "Child process terminated. Goodbye.\n";
   return 0;
}
#endif