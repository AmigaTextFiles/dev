
#ifndef _SPACELIBRARY_H
#define _SPACELIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class SpaceLibrary
{
public:
	SpaceLibrary();
	~SpaceLibrary();

	static class SpaceLibrary Default;

	Class * SPACE_GetClass();

private:
	struct Library *Base;
};

SpaceLibrary SpaceLibrary::Default;

#endif

