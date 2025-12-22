
#ifndef _INPUTLIBRARY_H
#define _INPUTLIBRARY_H

#include <exec/types.h>

class InputLibrary
{
public:
	InputLibrary();
	~InputLibrary();

	static class InputLibrary Default;

	UWORD PeekQualifier();

private:
	struct Library *Base;
};

InputLibrary InputLibrary::Default;

#endif

