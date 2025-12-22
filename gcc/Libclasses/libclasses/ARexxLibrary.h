
#ifndef _AREXXLIBRARY_H
#define _AREXXLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class ARexxLibrary
{
public:
	ARexxLibrary();
	~ARexxLibrary();

	static class ARexxLibrary Default;

	Class * AREXX_GetClass();

private:
	struct Library *Base;
};

ARexxLibrary ARexxLibrary::Default;

#endif

