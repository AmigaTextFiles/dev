// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifdef			MASKING_GL

#ifndef			MASKING_GLDRIVER_H
#define			MASKING_GLDRIVER_H

#include "drs.h"
#include <vector>
#include <alleggl.h>
#include "maskingdll.h"

namespace MAS {
/**
	Simple OpenGL/AllegroGL driver.
	Draws to the screen and does an allegro_gl_flip() for every frame.
	This driver is most useful for applications that use OpenGL in a
	fullscreen context (i.e. games). It's the fastest OpenGL driver you'll
	get (for pure OpenGL graphics) but has a few drawbacks. Some Allegro
	drawing primitives are not supported and others are very slow. This
	means that for this	driver font antialiasing and mouse shadows have
	to be turned off (this is done automatically).

	Note: At present (v0.80) there seem to be some problems with this
	driver that prevent most normal Allegro graphics features from working
	when this driver is used.
*/
class MASKING_DLL_DECLSPEC GLDriver : public ScreenUpdate {
	public:
		/**
			This driver requires full redraw.
		*/
		bool RequiresFullRedraw();

		char *GetDescription();

		/**
			Performs a GL flip.
		*/
		void Redraw();
};

/**
	Simple OpenGL/AllegroGL driver for use with DRS.
	This driver is the prefered method of using OpenGL with MASkinG. It is
	most suitable for applications that use OpenGL in a small viewport
	of some sort (e.g. 3D editors) as well as for full screen OpenGL programs
	such as 3D games that require a bit of GUI. It may not be quite as fast as
	the normal GLDriver but it comes pretty close and it allows you to use
	all Allegro	gfx routines without problems alongside fully accelerated
	OpenGL.

	Note: With the DRS driver in some cases transparent edges of windows and
	other GUI elements may not work. Solution needed!
*/
class MASKING_DLL_DECLSPEC GLDriverDRS : public DRS {
	public:
		/**
			Redraws the dirty rectangles and flips the buffers.
		*/
		void Redraw();

		char *GetDescription();
		void AcquireCanvas();

		static std::vector<MAS::Rect> mouse_back;
};

/**
	Simple software double buffered OpenGL/AllegroGL driver.
	This driver used to be a fallback driver for the DRS driver in fullscreen mode.
	It's a lot slower than the video double buffered drivers and is probably
	useless if the DRS driver works.
*/
class MASKING_DLL_DECLSPEC GLDriverDoubleBuffer : public DoubleBuffer {
	public:
		/**
			Redraws the dirty rectangles and flips the buffers.
		*/
		void Redraw();

		char *GetDescription();
		bool RequiresFullRedraw();
};
}


#endif			//MASKING_GLDRIVER_H

#endif			//MASKING_GL
