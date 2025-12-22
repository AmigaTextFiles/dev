
#ifndef _CONSOLEDEVICE_H
#define _CONSOLEDEVICE_H

#include <exec/libraries.h>
#include <devices/inputevent.h>
#include <devices/keymap.h>

class ConsoleDevice
{
public:
	ConsoleDevice();
	~ConsoleDevice();

	static class ConsoleDevice Default;

	struct InputEvent * CDInputHandler(CONST struct InputEvent * events, struct Library * consoleDevice);
	LONG RawKeyConvert(CONST struct InputEvent * events, STRPTR buffer, LONG length, CONST struct KeyMap * keyMap);

private:
	struct Library *Base;
};

ConsoleDevice ConsoleDevice::Default;

#endif

