// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifdef			MASKING_GL

#ifndef			MASKING_GLDIALOG_H
#define			MASKING_GLDIALOG_H

#include "dialog.h"
#include "maskingdll.h"

namespace MAS {
/**
	A simple dialog with an OpenGL context.
	This is similar to a GLViewport except that it is a dialog and should
	typically be used as the master dialog of an OpenGL application.

	@see GLViewport
	@see GLDriverDRS
*/
class MASKING_DLL_DECLSPEC GLDialog : public Dialog {
	protected:
		/**
			Draws the contents of the dialog.
			Does all the same things as GLViewport::MsgDraw() except that
			when it calls Draw(Bitmap &canvas) it passes a valid bitmap
			you can draw to with the regular Allegro drawing functions.
			Note however that some of those functions are not supported
			and others can be very slow.
		*/
		void MsgDraw();
		void MsgStart();
};
}

#endif		//MASKING_GLDIALOG_H

#endif		//MASKING_GL
