
#ifndef _GETFILELIBRARY_H
#define _GETFILELIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class GetFileLibrary
{
public:
	GetFileLibrary();
	~GetFileLibrary();

	static class GetFileLibrary Default;

	Class * GETFILE_GetClass();

private:
	struct Library *Base;
};

GetFileLibrary GetFileLibrary::Default;

#endif

