
#ifndef _STRINGLIBRARY_H
#define _STRINGLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class StringLibrary
{
public:
	StringLibrary();
	~StringLibrary();

	static class StringLibrary Default;

	Class * STRING_GetClass();

private:
	struct Library *Base;
};

StringLibrary StringLibrary::Default;

#endif

