// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_TIMER_H
#define			MASKING_TIMER_H

#include "maskingdll.h"

namespace MAS {
/**
	The timer system.
	The timer class is not really a proper class. It is just a bunch of static
	functions which provide basic timer functionality at a level just slightly
	above the level of the underlaying Allegro timer functions. It can install
	up to 8 separate timers (more than anyone should ever need), it has wrapper
	functions for the Allegro timer functions and a nice little function for
	checking when a timer has ticked.
*/
class MASKING_DLL_DECLSPEC Timer {
	public:
		/**
			Locks all the static timer functions and variables. This is necessary
			on some platforms. This should be called at the beginning of the
			program and is called by the InstallMASkinG() function right after
			installing the Allegro timer module.
		*/
		static void Lock();

		/**
			Checks if an installed timer has ticked. If it has it returns the
			timer's ID otherwise it returns -1.
		*/
		static int Check();

		/**
			Updates the timer with the passed ID.
			It does so by decrementing the appropriate timer variable and should
			be called whenever Check() returns a value other than -1. It should
			be passed the value Check() returns.
		*/
		static void Update(int timerID);

		/**
			Resets the frame skipping counters for all timers.
			Check() among other things also counts how many frames are waiting to
			be processed and if this number goes over a certain threshold (defined
			in the Settings class) it skips frames. This function resets this counter.

			Typically the above three functions are used together in the main loop like this:
<pre>
      int timerID = -1;
      while (!done) {
         while (timerID = Timer::Check()) {
			switch (timerID) {
               case 0:            // suppose 0 is the ID of the main logic timer
                  DoLogic();
                  break;

               case 1:            // supopse 1 is the ID of the timer used to measure FPS
                  MeasureFPS();
                  break;

               case 2:
                  ...
                  ...
            }

		    Timer::Update(timerID);
         }

         Timer::ResetFrameSkip();
         Render();
      }
</pre>
			The dialog manager does roughly something like this so unless you're not using
			the dialog manager, you don't really need to know about this.
		*/
		static void ResetFrameSkip();

		/**
			Attempts to install a timer that will tick at the specified interval.
			Interval is the time between timer ticks in milisecond. For example if you want
			the timer to tick once per second you would pass 1000 to this function. Returns
			the ID of the installed timer or -1 if it fails to install a timer. You are
			required to remember the ID because you need to know it to be able to detect a
			timer tick and to change and kill the timer.
		*/
		static int Install(int interval);

		/**
			Attempts to install a timer that will tick at the specified frequency.
			Frequency is in beats per second. So if you want a timer that ticks once per
			second you can install it by passing 1 to this function.
		*/
		static int InstallEx(int bps);

		/**
			Changes the speed of a timer. The first parameter should be the ID that was
			returned by the Install() or InstallEx() functions. The second parameter is
			the interval between timer ticks.
		*/
		static void Adjust(int timerID, int interval);

		/**
			Changes the speed of a timer. The first parameter should be the ID that was
			returned by the Install() or InstallEx() functions. The second parameter is
			the desired timer frequency.
		*/
		static void AdjustEx(int timerID, int bps);

		/**
			Stops a timer with the given ID.
		*/
		static void Kill(int timerID);
};
}

#endif			//MASKING_TIMER
