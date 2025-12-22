
#ifndef _WINDOWLIBRARY_H
#define _WINDOWLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class WindowLibrary
{
public:
	WindowLibrary();
	~WindowLibrary();

	static class WindowLibrary Default;

	Class * WINDOW_GetClass();

private:
	struct Library *Base;
};

WindowLibrary WindowLibrary::Default;

#endif

