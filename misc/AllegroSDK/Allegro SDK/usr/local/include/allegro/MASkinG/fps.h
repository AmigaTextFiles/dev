// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef		__CFPS_H_
#define		__CFPS_H_

#include <allegro.h>
#include "maskingdll.h"

namespace MAS {

/**
A simple helper class that measures the frame rate of a MASkinG program. The
frame rate is measured by calculating a running average over a short period of
time. There is a global instance of this class defined in the MAS namespace
named globalFpsCounter. This object is initialized and updated automatically
by the dialog that is being executed and is queried by any instance of the
FPS widget that is present in the dialog. Note that the calculations this
class performs depend on the value of Settings::logicFramerate. The Init method
is called in Dialog::MsgStart() and the update methods are called in Dialog::MsgIdle().
This means that if you don't use the Settings class and/or run your own main
loop, the globalFpsCounter object won't work unless you initialize and update
it yourself as is indicated in this documentation.

	@see Settings
	@see FPS
*/
class CFPS {
	protected:
		int *samples;
		int nSamples;
		int curSample;
		int frameCounter;
		int framesPerSecond;

	public:
		CFPS();
		~CFPS();

		/**
		Initializes the object.
		This function should be called at the same time as when the timer
		that runs the main loop is started.
		@param samples The target logic framerate. This is the number of times
		per second that the logic portion of the main loop is executed.
		*/
		void Init(int samples);

		/**
		Records a logic tick.
		This function must be called exactly once per logic update.
		*/
		void Tick();

		/**
		Records a frame.
		This function must be called exactly once every time a new frame has
		been rendered. Typically this is after blitting the backbuffer to the
		screen or flipping video pages.
		*/
		void Frame();

		/**
		Returns the framerate.
		@return The average framerate over the last second.
		*/
		int Get();

		void Draw(BITMAP *buffer);
};

/**
	A global instance of the CFPS class used for measuring the framerate of
	a MASkinG application. This object is initialized and updated by the
	Dialog class in the MsgStart() and MsgIdle() methods and can be queried
	for current framerate at any time while a dialog is executing.
*/
extern MASKING_DLL_DECLSPEC CFPS globalFpsCounter;

}

#endif		//__CFPS_H_
