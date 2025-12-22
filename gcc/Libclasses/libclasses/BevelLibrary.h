
#ifndef _BEVELLIBRARY_H
#define _BEVELLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class BevelLibrary
{
public:
	BevelLibrary();
	~BevelLibrary();

	static class BevelLibrary Default;

	Class * BEVEL_GetClass();

private:
	struct Library *Base;
};

BevelLibrary BevelLibrary::Default;

#endif

