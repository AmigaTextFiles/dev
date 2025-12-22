
#ifndef _PENMAPLIBRARY_H
#define _PENMAPLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class PenMapLibrary
{
public:
	PenMapLibrary();
	~PenMapLibrary();

	static class PenMapLibrary Default;

	Class * PENMAP_GetClass();

private:
	struct Library *Base;
};

PenMapLibrary PenMapLibrary::Default;

#endif

