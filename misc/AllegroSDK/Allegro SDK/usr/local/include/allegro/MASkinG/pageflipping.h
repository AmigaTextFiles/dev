// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_PAGEFLIPPING_H
#define			MASKING_PAGEFLIPPING_H

#include "screenupdate.h"
#include "maskingdll.h"

namespace MAS {
/**
	The Page Flipping screen update driver.
	It imlpements double buffering by creating two video pages. It exposes one
	page to the user so he can draw to it while the other page is shown on the
	screen. When drawing a frame is finished the pages are flipped - the one
	the user was drawing on gets shown on screen and the other one becomes
	available for drawing. Page flipping is very fast but not all systems
	support it.
*/
class MASKING_DLL_DECLSPEC PageFlipping : public ScreenUpdate {
	protected:
		/**
			Video page 1.
		*/
		BITMAP *page1;
		/**
			Video page 2.
		*/
		BITMAP *page2;

		/**
			Currently active page.
			Page1 and page2 are the two video pages used for page flipping
			and activePage is a pointer which at any given time points either
			to page1 or page2. The active page is available for drawing and is
			exposed to the user through GetCanvas() while the other page is being
			displayed on the screen.
		*/
		BITMAP *activePage;

	public:
		PageFlipping();

		/**
			Creates two video pages and shows one on screen
			while the other is available for drawing.
		*/
		Error Create();

		/**
			Destroys the video pages.
		*/
		void Destroy();

		/**
			Shows the active page on screen and flips the pages.
		*/
		void Redraw();

		/**
			Returns a pointer to the currently active page
			which is the page that is available for drawing.
		*/
		BITMAP *GetCanvas();

		/**
			Acquires the currently active page.
			This is important because the pages are video bitmaps which
			need to be acquired prior to drawing on them on some platforms
			to ensure optimal performance.
		*/
		void AcquireCanvas();

		/**
			Releases the currently active page.
			This is important because the pages are video bitmaps which
			need to be acquired prior to drawing on them on some platforms
			to ensure optimal performance.
		*/
		void ReleaseCanvas();

		/**
			Page flipping requires full redraw so this function returns true.
		*/
		bool RequiresFullRedraw();

		char *GetDescription();
};
}

#endif			//MASKING_PAGEFLIPPING_H
