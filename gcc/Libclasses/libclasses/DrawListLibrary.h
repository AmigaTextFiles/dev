
#ifndef _DRAWLISTLIBRARY_H
#define _DRAWLISTLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class DrawListLibrary
{
public:
	DrawListLibrary();
	~DrawListLibrary();

	static class DrawListLibrary Default;

	Class * DRAWLIST_GetClass();

private:
	struct Library *Base;
};

DrawListLibrary DrawListLibrary::Default;

#endif

