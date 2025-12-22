
#ifndef _GETSCREENMODELIBRARY_H
#define _GETSCREENMODELIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class GetScreenModeLibrary
{
public:
	GetScreenModeLibrary();
	~GetScreenModeLibrary();

	static class GetScreenModeLibrary Default;

	Class * GETSCREENMODE_GetClass();

private:
	struct Library *Base;
};

GetScreenModeLibrary GetScreenModeLibrary::Default;

#endif

