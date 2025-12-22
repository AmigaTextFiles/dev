// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_SCREENUPDATE_H
#define			MASKING_SCREENUPDATE_H

#include "error.h"
#include "rect.h"
#include <allegro.h>
#include <list>
#include "maskingdll.h"

namespace MAS {
/**
  The base of the screen update driver system.
  This is the base class for the screen update driver system. All screen update
  drivers should inherit from this class and implement the relevant virtual
  functions. Although this isn't an abstract class with pure virtual functions
  it shouldn't really be used in most cases as it implements no special screen
  update functionality - it just exposes the global Allegro screen bitmap which
  means drawing with this driver will produce <I><B>a lot</B></I> of flicker.
*/
class MASKING_DLL_DECLSPEC ScreenUpdate {
	protected:
		/// The canvas bitmap the user can draw to.
		BITMAP *canvas;

	public:
		ScreenUpdate();
		virtual ~ScreenUpdate();

		/**
			Creates the canvas on which the user can draw.
			This driver just makes a subbitmap of the global Allegro screen
			BITMAP. Should return an error code.
		*/
		virtual Error Create();

		/**
			Destroy the canvas bitmap.
		*/
		virtual void Destroy();

		/**
			Shows the canvas on the screen.
			In this driver this function is empty because the canvas IS the screen.
		*/
		virtual void Redraw();

		/**
			Returns a pointer to the canvas BITMAP on which the user can draw.
		*/
		virtual BITMAP *GetCanvas();

		/**
			Acquires the drawing canvas.
			This is necessary on some platforms to get optimal performance.
		*/
		virtual void AcquireCanvas();

		/**
			Releases the drawing canvas.
			This is necessary on some platforms to get optimal performance.
		*/
		virtual void ReleaseCanvas();

		/**
			Returns a string containing a short description of the driver.
		*/
		virtual char *GetDescription();

		/**
			Returns true if the driver requires the entire screen to be redrawn every frame.
			All regular double buffering schemes do, but this driver of course doesn't.
		*/
		virtual bool RequiresFullRedraw();

		/**
			Marks a rectangle dirty and schedules it for rerawing.
			All drivers except for the Dirty Rectangle System (DRS) driver ignore this.
		*/
		virtual void InvalidateRect(const Rect &r);

		/**
			Like InvalidateRect(const Rect &r) except that it accepts individual coordinates.
		*/
		virtual void InvalidateRect(int x, int y, int w, int h);
};
}


#endif			//MASKING_SCREENUPDATE_H
