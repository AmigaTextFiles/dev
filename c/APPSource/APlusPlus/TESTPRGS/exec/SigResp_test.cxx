/******************************************************************************
 *
 *    $Source: apphome:RCS/testprgs/exec/SigResp_test.cxx,v $
 *
 *    Demo for the A++ Library
 *    Copyright (C) 1994 by Armin Vogt, EMail: armin@uni-paderborn.de
 *
 *    $Revision: 1.5 $
 *    $Date: 1994/07/23 19:14:35 $
 *    $Author: Armin_Vogt $
 *
 ******************************************************************************/


extern "C" {
#include <dos/dos.h>
}
#include <stdio.h>
#include <APlusPlus/exec/SignalResponder.h>


volatile static char rcs_id[] = "$Id: SigResp_test.cxx,v 1.5 1994/07/23 19:14:35 Armin_Vogt Exp Armin_Vogt $";


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
         puts("**Break\n");
         running = FALSE;
      }

      BOOL hasNotOccured() { return running==TRUE; }
};


int main(int argc,char *argv[])
{
   MySRSP ctrlCBreak;

   puts("SignalResponder - Test: please press CTRL-c to end this programm.\n");

   puts("waiting..\n");

   while ( ctrlCBreak.hasNotOccured() )
   {
      SignalResponder::WaitSignal();
   }

   puts("Thank You. Goodbye.\n");
   return 0;
}
