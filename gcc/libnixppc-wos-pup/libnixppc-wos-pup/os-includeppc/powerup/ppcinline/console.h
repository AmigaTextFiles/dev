/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_CONSOLE_H
#define _PPCINLINE_CONSOLE_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef CONSOLE_BASE_NAME
#define CONSOLE_BASE_NAME ConsoleDevice
#endif /* !CONSOLE_BASE_NAME */

#define CDInputHandler(events, consoleDevice) \
	LP2(0x2a, struct InputEvent *, CDInputHandler, CONST struct InputEvent *, events, a0, struct Library *, consoleDevice, a1, \
	, CONSOLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RawKeyConvert(events, buffer, length, keyMap) \
	LP4(0x30, LONG, RawKeyConvert, CONST struct InputEvent *, events, a0, STRPTR, buffer, a1, LONG, length, d1, CONST struct KeyMap *, keyMap, a2, \
	, CONSOLE_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_CONSOLE_H */
