/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_KEYMAP_H
#define _PPCINLINE_KEYMAP_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef KEYMAP_BASE_NAME
#define KEYMAP_BASE_NAME KeymapBase
#endif /* !KEYMAP_BASE_NAME */

#define AskKeyMapDefault() \
	LP0(0x24, struct KeyMap *, AskKeyMapDefault, \
	, KEYMAP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define MapANSI(string, count, buffer, length, keyMap) \
	LP5(0x30, LONG, MapANSI, CONST_STRPTR, string, a0, LONG, count, d0, STRPTR, buffer, a1, LONG, length, d1, CONST struct KeyMap *, keyMap, a2, \
	, KEYMAP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define MapRawKey(event, buffer, length, keyMap) \
	LP4(0x2a, WORD, MapRawKey, CONST struct InputEvent *, event, a0, STRPTR, buffer, a1, LONG, length, d1, CONST struct KeyMap *, keyMap, a2, \
	, KEYMAP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SetKeyMapDefault(keyMap) \
	LP1NR(0x1e, SetKeyMapDefault, CONST struct KeyMap *, keyMap, a0, \
	, KEYMAP_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_KEYMAP_H */
