// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_TRIPLEBUFFER_H
#define			MASKING_TRIPLEBUFFER_H

#include "pageflipping.h"
#include "maskingdll.h"

namespace MAS {
/**
	The Triple Buffering screen update driver.
	Triple buffering is very similar to page flipping. In fact triple buffering
	is just an extension of page flipping where a third video page is used to
	eliminate the need to wait for vertical synchronisation. In a triple buffering
	scheme one page is available for drawing (the active page), one contains the
	last completely drawn frame and is waiting for the next vertical retrace so it
	can be shown on screen and the third contains the previous frame and is at the
	time being drawn by the hardware onto the physical screen. Triple buffering is
	in most cases where the entire screen needs to be fully redrawn the fastest
	screen update method but is not available on all systems.
*/
class MASKING_DLL_DECLSPEC TripleBuffer : public PageFlipping {
	protected:
		/**
			The third video page.
		*/
		BITMAP *page3;

		/**
			An index storing the number of the currently active page.
		*/
		int page;

	public:
		TripleBuffer();

		/**
			If triple buffering is available, this function tries to turn it on and creates three video pages.
		*/
		Error Create();

		/**
			Destroys the video pages.
		*/
		void Destroy();

		/**
			Requests the active page to be shown on screen,
			advances to the next page and returns without waiting for a
			vertical retrace.
		*/
		void Redraw();

		BITMAP *GetCanvas();
		char *GetDescription();
};
}

#endif			//MASKING_TRIPLEBUFFER_H
