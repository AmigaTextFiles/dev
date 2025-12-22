// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_GLOBAL_H
#define			MASKING_GLOBAL_H

#include <alfont.h>
#include "error.h"
#include "maskingdll.h"

namespace MAS {
	class Settings;
	class Error;
	class Dialog;

	/**
		Initializes MASkinG. It does so by initializing Allegro, installing all
		the required modules (keyboard, mouse, timer and sound), loading a skin
		and setting the graphics mode. It reads all the settings from an Allegro
		config file the path to which you have to provide. This path should be
		relative to the location of the executable. This function will convert
		it to an absolute path automatically. You should call this
		function once somewhere near the beginning of your program. If you don't
		want to do that you must manually install Allegro and AllegroFont, set
		the color depth, set the gfx mode and then load a skin. If the gfx mode
		can't be set with the specified color depth this function will attempt
		to set a mode with an alternative color depth. If 16bpp doesn't work,
		it will try 15bpp and vice versa and if 32 fails it will try 24 and
		vice versa. The only parameter is the path to the Allegro config file
		from which this function should read the preferences. If you pass NULL
		or don't pass anything (the default is NULL) no config file will be read
		and the currently valid settings will be used. This allows you to setup
		your program without using the config files before actually installing
		MASkinG. If the file you specify can't be found a new one will be created
		and the currently valid settings will be used. The function returns an
		Error you should check after calling InstallMASkinG().
	*/
	Error MASKING_DLL_DECLSPEC InstallMASkinG(const char *settings = NULL);

	/**
		Attempts to change the graphics driver and the screen resolution to the
		requested settings. If the function fails it changes the resolution back
		to the original settings if available and returns an error. If you're
		changing the resolution on the fly when a dialog is executing you should
		pass a pointer to the main dialog of the program so it can be resized
		according to the new settings.

		Note: if mode is anything other than one of the GFX_AUTODETECT constants,
		fullscreen is ignored. Otherwise mode is ignored and set to either
		GFX_AUTODETECT_FULLSCREEN or GFX_AUTODETECT_WINDOWED depending on the
		value of fullscreen.
	*/
	Error MASKING_DLL_DECLSPEC ChangeResolution(int mode, bool fullscreen, int w, int h, int bpp, Dialog *mainDlg = NULL);

	/**
		Cleans up after the GUI. If you loaded settings from a config file it
		also saves any changes to it. Call this function just before the end of
		your program (or when you're done with MASkinG and don't want to use it
		anymore).
	*/
	void MASKING_DLL_DECLSPEC ExitMASkinG();

	/**
		Constructs an absolute path from the path of the executable and the
		relative path you specify and writes it to the destination string. You
		are responsible for creating and destroying the destination string.
	*/
	void MASKING_DLL_DECLSPEC MakeFullPath(char *dest, const char *relative);
}

#endif			//MASKING_GLOBAL_H
