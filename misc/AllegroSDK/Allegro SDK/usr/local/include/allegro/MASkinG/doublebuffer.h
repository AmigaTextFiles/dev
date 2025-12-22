// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_DOUBLEBUFFER_H
#define			MASKING_DOUBLEBUFFER_H

#include "screenupdate.h"
#include "maskingdll.h"

namespace MAS {
/**
	The Double Buffering screen update driver.
	It imlpements simple double buffering by creating either a memory or video
	bitmap buffer the size of the screen. The user then draws to this buffer
	and the driver shows the buffer by blitting it to the actual screen.
*/
class MASKING_DLL_DECLSPEC DoubleBuffer : public ScreenUpdate {
	public:
		/**
			Creates either a memory or a video bitmap buffer depending on the current settings.
			If creating a video bitmap fails, it falls back to a memory bitmap.
		*/
		Error Create();

		/**
			Destroys the buffer.
		*/
		void Destroy();

		/**
			Shows the buffer by blitting it to the screen.
		*/
		void Redraw();

		/**
			Double buffering requires full redraw so this function returns true.
		*/
		bool RequiresFullRedraw();

		char *GetDescription();
};
}

#endif		//MASKING_DOUBLEBUFFER_H
