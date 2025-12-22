#ifndef _INLINE_KEYMAP_H
#define _INLINE_KEYMAP_H

#ifndef CLIB_KEYMAP_PROTOS_H
#define CLIB_KEYMAP_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  DEVICES_INPUTEVENT_H
#include <devices/inputevent.h>
#endif
#ifndef  DEVICES_KEYMAP_H
#include <devices/keymap.h>
#endif

#ifndef KEYMAP_BASE_NAME
#define KEYMAP_BASE_NAME KeymapBase
#endif

#define SetKeyMapDefault(keyMap) \
	LP1NR(0x1e, SetKeyMapDefault, const struct KeyMap *, keyMap, a0, \
	, KEYMAP_BASE_NAME)

#define AskKeyMapDefault() \
	LP0(0x24, struct KeyMap *, AskKeyMapDefault, \
	, KEYMAP_BASE_NAME)

#define MapRawKey(event, buffer, length, keyMap) \
	LP4(0x2a, WORD, MapRawKey, const struct InputEvent *, event, a0, STRPTR, buffer, a1, LONG, length, d1, const struct KeyMap *, keyMap, a2, \
	, KEYMAP_BASE_NAME)

#define MapANSI(string, count, buffer, length, keyMap) \
	LP5(0x30, LONG, MapANSI, CONST_STRPTR, string, a0, LONG, count, d0, STRPTR, buffer, a1, LONG, length, d1, const struct KeyMap *, keyMap, a2, \
	, KEYMAP_BASE_NAME)

#endif /*  _INLINE_KEYMAP_H  */
