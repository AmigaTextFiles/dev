
#ifndef _BUTTONLIBRARY_H
#define _BUTTONLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class ButtonLibrary
{
public:
	ButtonLibrary();
	~ButtonLibrary();

	static class ButtonLibrary Default;

	Class * BUTTON_GetClass();

private:
	struct Library *Base;
};

ButtonLibrary ButtonLibrary::Default;

#endif

