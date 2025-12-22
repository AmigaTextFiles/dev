
#ifndef _KEYMAPLIBRARY_H
#define _KEYMAPLIBRARY_H

#include <devices/inputevent.h>
#include <devices/keymap.h>

class KeymapLibrary
{
public:
	KeymapLibrary();
	~KeymapLibrary();

	static class KeymapLibrary Default;

	VOID SetKeyMapDefault(CONST struct KeyMap * keyMap);
	struct KeyMap * AskKeyMapDefault();
	WORD MapRawKey(CONST struct InputEvent * event, STRPTR buffer, LONG length, CONST struct KeyMap * keyMap);
	LONG MapANSI(CONST_STRPTR string, LONG count, STRPTR buffer, LONG length, CONST struct KeyMap * keyMap);

private:
	struct Library *Base;
};

KeymapLibrary KeymapLibrary::Default;

#endif

