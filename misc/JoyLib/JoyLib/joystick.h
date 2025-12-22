/*
    joystick.h

    ---------------------------------------------------
    definitions for "joylink.lib" or "joystick.library"
    ---------------------------------------------------

    written by Olli

    #define JOYLIB_SHARED to get definitions
			  for shared library

*/

#define JOY_LEFT 1
#define JOY_RIGHT 2
#define JOY_UP 4
#define JOY_DOWN 8
#define JOY_FIRE 16

#define JOY_EAST 1
#define JOY_WEST 2
#define JOY_NORTH 4
#define JOY_SOUTH 8
#define JOY_BUTTON 16

short joy0(),joy1();

#ifdef JOYLIB_SHARED
struct Library *JoystickBase;
#endif

#ifdef LATTICE
short joy0(void),joy1(void);

#ifdef JOYLIB_SHARED
#pragma libcall JoystickBase joy0 1e 0
#pragma libcall JoystickBase joy1 24 0
#endif

#endif
