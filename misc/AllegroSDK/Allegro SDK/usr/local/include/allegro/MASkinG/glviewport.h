// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifdef			MASKING_GL

#ifndef			MASKING_GLVIEWPORT_H
#define			MASKING_GLVIEWPORT_H

#include "dialog.h"
#include "maskingdll.h"

namespace MAS {
/**
	A simple OpenGL viewport widget.
	This is intended for making small windows containing OpenGL accelerated
	3D graphics. You should use this widget only with the GLDriverDRS screen
	update driver as it won't work properly with any of the others.

	@see GLDialog
	@see GLDriverDRS
*/
class MASKING_DLL_DECLSPEC GLViewport : public Widget {
	protected:
		/**
			Draws the contents of the viewport.
			This function does all the tedious work necessary to setup a
			viewport and calls the Draw(Bitmap &canvas) function. To draw
			into the viewport in a derived widget simply overload the Draw()
			function and put your OpenGL drawing code in it (typically gl_begin(),
			gl_end() and everything that goes in between). The Draw()
			function is passed a Bitmap object but the viewport currently
			doesn't support regular Allegro drawing so this object is
			an invalid null bitmap and should be ignored!
		*/
		void MsgDraw();
};
}

#endif		//MASKING_GLVIEWPORT_H

#endif		//MASKING_GL
