// ************************************************************************** //
//         MASkinG - Miran Amon's Skinnable GUI Library for Allegro           //
//    Copyright (c) 2002-2005 Miran Amon (miranamon@users.sourceforge.net)    //
//          Project websites: http://ferisrv5.uni-mb.si/~ma0747               //
//                  http://sourceforge.net/projects/masking                   //
// ************************************************************************** //

#ifndef			MASKING_SETTINGS_H
#define			MASKING_SETTINGS_H

#include "global.h"
#include "maskingdll.h"

namespace MAS {
/**
	Stores all the settings and preferences for a MASkinG application.
	It has functions for reading the values from an Allegro config file
	and writing them back. If settings can't be read from the given file, sensible
	default values are provided. All the data and methods are static so this acts
	more as a namespace for various preferences that would otherwise be global.
*/
class MASKING_DLL_DECLSPEC Settings {
	public:
		static char fileName[1024];
		static bool haveName;

	public:
		/**
			Path to the skin file the GUI should use.
		*/
		static char skinPath[1024];

		/**
			Screen or window width.
		*/
		static int screenWidth;

		/**
			Screen or window height.
		*/
		static int screenHeight;

		/**
			The gfx mode constant.
			This is platform dependant. You should see the allegro.cfg file in the
			Allegro root directory for a list of all available constants for each
			platform. Normally this should be one of the GFX_AUTODETECT constants.
			In that case the fullscreen variable (see below) is used to determine
			whether GFX_AUTODETECT_FULLSCREEN or GFX_AUTODETECT_WINDOWED should be
			used. In any other case this setting overrides the <I>fullscreen</I> flag.
			The default it GFX_AUTODETECT.
		*/
		static int gfxMode;

		/**
			Should the GUI run in fullscreen or windowed?
			Set to true if the program should run in fullscreen, to false otherwise.
			This only has effect when <I>gfxMode</I> is set to anything other than
			one of the GFX_AUTODETECT constants, otherwise it is ignored.
		*/
		static bool fullscreen;

		/**
			The color depth in fullscreen mode.
			In windowed modes the desktop color depth is used instead.
		*/
		static int colorDepth;

		/**
			The requested monitor refresh rate in fullscreen mode.
			Actual refresh rate depends on the current platform and hardware.
		*/
		static int refreshRate;

		/**
			Should we use hardware acceleration with video bitmaps?
			Set to true if you want the GUI to use video memory for holding skin
			data and the screen buffers. This can improve performance significantly
			in some configurations but doesn't always seem to work for some reason.

			Note: this is currently disabled!
		*/
		static bool useVideoMemory;

		/**
			Show window contents while dragging?

			Note: not currently implemented.
		*/
		static bool fullDrag;

		/**
			Show window contents while resizing?

			Note: not currently implemented.
		*/
		static bool fullResize;

		/**
			The frame rate of the GUI logic loop.
			The default is 50 and should do in most cases.
		*/
		static int logicFrameRate;

		/**
			Should the GUI redraw itself as fast as possible
			or should the redraw frame rate be clipped to the logic frame rate?
			Setting this to true may yield smoother animation on slower computers
			but can hog 100% of the CPU power.
		*/
		static bool unlimitedFrameRate;

		/**
			Should we display FPS?
			Note that this currently has no meaning to the core of the GUI as the
			GUI itself doesn't print FPS in any way. This can be used by the user
			though to determine whether the fps should be displayed or not.
		*/
		static bool showFrameRate;

		/**
			Use antialiasing for text output?
			Antialiased text looks a lot better than normal text but is also somewhat
			slower especially when drawing to video memory.
		*/
		static bool antialiasing;

		/**
			Enable/disable GUI sounds.
		*/
		static bool guiSound;

		/**
			Volume of the rollover sounds.
		*/
		static int soundVolume;

		/**
			The sound driver ID.
			See allegro.cfg in the Allegro direcotry for a list of all possible drivers
			on each platform. Default is DIGI_AUTODETECT.
		*/
		static int soundDriver;

		/**
			The midi driver ID.
			See allegro.cfg in the Allegro direcotry for a list of all possible drivers
			on each platform. Default is MIDI_AUTODETECT.
		*/
		static int midiDriver;

		/**
			Should the GUI use the mouse or not?
			This doesn't just hide the mouse cursor but disables mouse tracking comepletely.
			But the Allegro mouse module is still installed even if showMouse is false, this
			setting enables you to dynamically turn the mouse on and off during the execution
			of the program.
		*/
		static bool showMouse;

		/**
			Should we render the mouse shadow or not?
			Generating mouse shadow can take quite a lot of time especially if you use large
			animated cursors (several seconds on slower systems) and drawing them is quite
			slow too, especially on video memory. Mouse shadow are automatically disabled
			in 8 bpp mode.
		*/
		static bool mouseShadow;

		/**
			Double click delay in miliseconds.
		*/
		static int doubleClickDelay;

		/**
			The speed at which the mouse cursor moves.
			Higher values make the cursor move slower. Default is 2.

			Note: only seems to work on some platforms.
		*/
		static int mouseSpeed;

		/**
			Should the GUI handle keyboard input?
			If turned off joystick input will be turned off too as it is simulated as
			keyboard input.
		*/
		static bool useKeyboard;

		/**
			The keyboard delay in miliseconds.
			If set to -1, keyboard delay will not be altered and whatever is the default
			on the currecnt platform will be used.
		*/
		static int keyDelay;

		/**
			The keyboard repeat rate.
			If set to -1, keyboard repeat will not be altered and whatever is the default
			on the currecnt platform will be used.
		*/
		static int keyRepeat;

		/**
			Should the GUI use the joystick for simulating keybord input?
		*/
		static bool useJoystick;

		/**
			Which screen update driver to use?
			Possible options are:
<PRE>
      0 - double buffering
      1 - page flipping
      2 - triple buffering
      3 - dirty rectangles system (DRS)
</PRE>
		*/
		static int screenUpdateMethod;

		/**
			Should the driver wait for vsync or not?
			This only applies to the double buffering driver.
		*/
		static bool vsync;

		/**
			Should the GUI yield timeslices when idle?
			This significantly reduces the CPU usage but also reduces the performance a
			bit. Set to true for normal applications that run in a window and when running
			on a laptop and set to false for games that run in fullscreen and require all
			the CPU power they can get.
		*/
		static bool yield;

		/**
			Should the program keep running while tabbed away?
			If true the program will try to continue to run even when tabbed away. This is
			done by passing SWITCH_BACKGROUND to set_display_switch_mode() after the
			graphics mode is set. Note that this setting doesn't take effect immediately,
			only when the graphics mode is changed (i.e. when calling InstallMAskinG()  or
			ChangeResolution()). The default is true.
		*/
		static bool runInBackground;

		/**
			Maximum number of logic frames that are processed before a frame is skipped
			if the computer is too slow to run the logic at the requested logic frame rate.
			This is extremely rare as modern CPUs are easily powerfull enough to process even
			the most demanding logic at a very high frame rate and the rendering will be the
			bottleneck but if you run a program with very complex logic on a very slow CPU,
			this variable will make sure that even though all the logic won't be processed at
			the desired frame rate (i.e. time will appear to be stretched and the physics
			won't be accurate), the program will at least run. The value of this variable
			determines how fast frames will be skipped. The lower this value, the smoother
			will the program run as more frames will be skipped. Make this value higher and
			the program will skip less frames but will be choppier on slow CPUs. The optimal
			values are probably around 5-10. The default is 5.
		*/
		static int maxFrameSkip;

		/**
			The tooltip delay in miliseconds.
			This is the time the mouse has to be completely still before a tooltip help bubble
			is shown. The default is 200.
		*/
		static int tooltipDelay;

		/**
			The delay before a tooltip automatically hides itself.
		*/
		static int tooltipAutohideDelay;

		/**
			The scrooling speed of the mouse wheel as number of items scrolled at a time.
		*/
		static int scrollingSpeed;

		/**
			Target graphics frame rate. If unlimitedFrameRate is set to false, the screen will
			be updated no faster as this setting defines, otherwise it has no effect.
		*/
		static int gfxFrameRate;

		static bool useOpenGLMouseHack;

	public:
		/**
			Attempts to load the settings from the given config file.
			If a value can't be read, the default is used.
		*/
		static void Load(const char *fileName);

		/**
			Saves all the settings to the file from which they were read.
		*/
		static void Save();
};
}

#endif			//MASKING_SETTINGS_H
