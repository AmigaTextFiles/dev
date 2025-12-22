// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_FPSLABEL_H
#define			MASKING_FPSLABEL_H

#include "label.h"
#include "maskingdll.h"

namespace MAS {

/**
A simple widget that displays the current redraw frame rate. The frame rate is
measured by the globalFpsCounter object.

@see CFPS
*/
class MASKING_DLL_DECLSPEC FPS : public Label {
	protected:
		// Message functions
		/**
		Records a MSG_TICK message and makes sure the widget is redrawn in every frame.
		*/
		void MsgTick();
		/**
		Initializes the text and sets the text background colour to the default skin background colour.
		*/
		void MsgInitSkin();
		/**
		Renders the frame rate as text.
		*/
		void Draw(Bitmap &canvas);

	public:
		/**
		default constructor.
		*/
		FPS();
		/**
		destructor
		*/
		~FPS();

		/**
		Returns the current FPS (stands for 'Frames Per Second'). Actually the frame rate is a
		running average over the last second.
		*/
		int Get();

};
}

#endif		//MASKING_FPSLABEL_H
