#ifndef _INLINE_CONSOLE_H
#define _INLINE_CONSOLE_H

#ifndef CLIB_CONSOLE_PROTOS_H
#define CLIB_CONSOLE_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif
#ifndef  DEVICES_INPUTEVENT_H
#include <devices/inputevent.h>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <devices/keymap.h>
#endif

#ifndef CONSOLE_BASE_NAME
#define CONSOLE_BASE_NAME ConsoleDevice
#endif

#define CDInputHandler(events, consoleDevice) \
	LP2(0x2a, struct InputEvent *, CDInputHandler, const struct InputEvent *, events, a0, struct Library *, consoleDevice, a1, \
	, CONSOLE_BASE_NAME)

#define RawKeyConvert(events, buffer, length, keyMap) \
	LP4(0x30, LONG, RawKeyConvert, const struct InputEvent *, events, a0, STRPTR, buffer, a1, LONG, length, d1, const struct KeyMap *, keyMap, a2, \
	, CONSOLE_BASE_NAME)

#endif /*  _INLINE_CONSOLE_H  */
