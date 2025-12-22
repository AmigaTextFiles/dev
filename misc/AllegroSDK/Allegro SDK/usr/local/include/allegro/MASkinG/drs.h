// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_DRS_H
#define			MASKING_DRS_H

#include "doublebuffer.h"
#include "rect.h"
#include "maskingdll.h"

namespace MAS {
/**
	The Dirty Rectangle Syste (DRS) screen update driver.
	DRS is similar to normal double buffering except that it doesn't blit the
	entire buffer to the screen every frame but instead keeps a list of rectangles
	that have been chaged since the last update (dirty rectangles) and only
	blits them. This means that when only a small portion of the screen changes
	there is little or no overdaraw which in turn means that for applications where
	most of the screen is static most of the time (like most utility programs,
	editors, etc.) this is by far the fastest screen update method often producing
	thousands of "frames" per second. However when large portions of the screen
	or even the entire screen is updated all the time (like in most games) this
	driver is no faster than regular double buffering. In fact it might even be
	very slightly slower.
*/
class MASKING_DLL_DECLSPEC DRS : public DoubleBuffer {
	protected:
		/**
			The actual list of dirty rectangles.
		*/
		std::list<Rect> rectlist;

		/**
			Checks whether a rectangle can safely be added to the dirty list
			without inducing overdraw. It returns a pointer to the rectangle that
			is in the way of the recatangle being added if it finds one, NULL
			otherwise.
		*/
		Rect *CanAdd(const Rect& r);

	public:

		/**
			Paints the screen
			by going through the dirty rectangles list, blitting them to the screen
			and removing them from the list.
		*/
		void Redraw();

		/**
			DRS obviously doesn't require the screen to be redrawn every frame
			so this functions returns false.
		*/
		bool RequiresFullRedraw();

		/**
			Attempts to add a rectangle to the dirty rectangles list.
			If there is	already another rectangle in the way it splits the rectangle
			being added into smaller rectangles and recursively invalidates them
			instead thus preventing parts of the screen to be drawn more than once.
		*/
		void InvalidateRect(const Rect& r);

		char *GetDescription();
};
}

#endif		//MASKING_DRS_H
