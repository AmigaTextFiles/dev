
#ifndef _INTEGERLIBRARY_H
#define _INTEGERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class IntegerLibrary
{
public:
	IntegerLibrary();
	~IntegerLibrary();

	static class IntegerLibrary Default;

	Class * INTEGER_GetClass();

private:
	struct Library *Base;
};

IntegerLibrary IntegerLibrary::Default;

#endif

