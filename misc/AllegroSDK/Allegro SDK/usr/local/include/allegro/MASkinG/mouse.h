// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_MOUSE_H
#define			MASKING_MOUSE_H

#include <allegro.h>
#include "cursor.h"
#include "screenupdate.h"
#include "point.h"
#include "maskingdll.h"

namespace MAS {
/**
	The mouse input handling class.
	The mouse system is quite simple in MASkinG and there's lots of room for
	optimization. The mouse class hold variables for the current mouse position,
	cursor and the background of the cursor. The user is required to hide the
	mouse before every drawing operation and then show it again when they're
	finished. Actually the dialog manager does this already so you don't really
	need to worry about it. In fact you don't need to know this class even exists
	as the dialog manager either does all work for you or provides its own
	interface for doing things like changing the mouse cursor and so on.
*/
class MASKING_DLL_DECLSPEC Mouse {
	protected:
		static Cursor *globalCursor;

		/**
			A pointer to the currently selected cursor.
		*/
		Cursor *cur;

		/**
			The stored background of the cursor.
		*/
		Bitmap back;

		/**
			Position of the main cursor sprite.
		*/
		Point spritePos;

		/**
			Position of the cursor shadow.
		*/
		Point shadowPos;

		/**
			Position of the stored background.
		*/
		Point backPos;

		/**
			A pointer to the screen update driver (canvas).
		*/
		ScreenUpdate *parent;

		/**
			True when the mouse cursor is hidden, false otherwise.
		*/
		bool hidden;

		/**
			Cleans up when the mouse functionality is no longer needed (i.e. at the end of the program).
		*/
		virtual void Destroy();

		/**
			Updates the state of the mouse system.
			This includes the position, button states and wheel position. The default
			driver simply mirrors the global Allegro mouse variables (mouse_x, mouse_y,
			mouse_b and mouse_z). If you want to modify the bahaviour of your mouse
			you should derive a new class from Mouse and overload this function so that
			it does whatever you want. For example you might want to invert the left and
			right buttons.
		*/
		virtual void UpdateState();

		/**
			Calculates the relative positions of the main cursor sprite, its shadow and the background.
		*/
		virtual void CalculateGeometry();

	public:
		Mouse();
		virtual ~Mouse();

		/**
			Sets the mouse's parent screen zpdate driver.
			This lets the mouse know who to ask to get the canvas bitmap
			where it can draw itself.
		*/
		void SetParent(ScreenUpdate *p);

		/**
			Changes the current mouse cursor. First it hides the cursor, then
			makes the switch and the shows the new one.
		*/
		virtual void SetCursor(Cursor &cur);

		/**
			Returns a pointer to the currently active cursor.
		*/
		virtual Cursor *GetCursor();

		/**
			Draws the cursor to the canvas. Prior to that it makes a backup of what
			is behind the cursor so it is vital that the mouse has been hidden before
			calling this function.
		*/
		virtual void Show();

		/**
			Hides the mouse cursor. It does so by restoring the previously saved backup
			of the cursor background in place of the cursor.
		*/
		virtual void Hide();

		/**
			Updates the cursor (which can be animated) and the mouse position.
		*/
		virtual void Update();

		/**
			The current position of the mouse cursor on the screen. You should always
			read this value instead of relying directly on mouse_x and mouse_y. You
			should not change this value.
		*/
		Point pos;

		/**
			The state of the mouse buttons. This variable mirrors the Allegro mouse_b
			variable but you should always read this value instead of using mouse_b directly.
		*/
		int flags;

		/**
			The current position of the mouse wheel. Always use this value instead of using
			mouse_z directly.
		*/
		int z;
};
}

#endif		//MASKING_MOUSE_H
