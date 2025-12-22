/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/SignalResponder.cxx,v $
 **   $Revision: 1.8 $
 **   $Date: 1994/08/27 13:23:26 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


extern "C" {
#ifdef __GNUG__
#include <inline/exec.h>
#endif

#ifdef __SASC
#include <proto/exec.h>
#endif
}

#include <APlusPlus/exec/SignalResponder.h>


static const char rcs_id[] = "$Id: SignalResponder.cxx,v 1.8 1994/08/27 13:23:26 Armin_Vogt Exp Armin_Vogt $";

//runtime type inquiry support
typeinfo(SignalResponder, no_bases, rcs_id)

// initialising static members
PriorityList SignalResponder::sigRespChain;
ULONG SignalResponder::waitSignalSet = 0;


SignalResponder::SignalResponder(UBYTE signal_nr,BYTE pri)
{
   initSR(signal_nr, pri);
}

void SignalResponder::initSR(BYTE signal_nr, BYTE pri)
{
   waitSignalSet |= (waitSignal = 1L<<(waitSigNr=signal_nr));
   sigRespChain.enqueue(this,pri);
   hasAllocatedSig = FALSE;
   setID(SIGRESPONDER_CLASS);
}

SignalResponder::SignalResponder( BYTE pri)
{
   BYTE sig;

   if (!(-1 == (sig = AllocSignal(-1))))
   {
      initSR(sig,pri);
      hasAllocatedSig = TRUE;
   }
   else _ierror(SIGNALRESPONDER_ALLOCSIGNAL_FAILED);
}

SignalResponder::~SignalResponder()
{
   if (hasAllocatedSig == TRUE)
      FreeSignal(waitSigNr);

   remove();
}

void SignalResponder::changeSignalBit(UBYTE signal_nr)
   /* Change the signal bit which the SRSP is waiting for.
   */
{
   waitSignalSet |= (waitSignal = 1L<<(waitSigNr=signal_nr));
}

BOOL SignalResponder::applyNodeC(void *receivedSig)
   /* On an incoming signal WaitSignal() applies this routine to every
      SignalResponder created in this application. Each Responder with corresponding
      wait signals set will be activated via the virtual actionCallback().
   */
{
   if (waitSignal & (ULONG)receivedSig)
      actionCallback();

   return TRUE; // go on applying
}

void SignalResponder::WaitSignal()
   /* Set the task into wait state until further signals are incoming.
   */
{
   // wait for the set of signals from all responder objects
   ULONG receivedSig = Wait(waitSignalSet);

   // spread the received signal to all SignalResponders.
   sigRespChain.apply((void*)receivedSig);
   _dprintf("SignalResponder::WaitSignal returned.\n");
}
