
#ifndef _GETFONTLIBRARY_H
#define _GETFONTLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class GetFontLibrary
{
public:
	GetFontLibrary();
	~GetFontLibrary();

	static class GetFontLibrary Default;

	Class * GETFONT_GetClass();

private:
	struct Library *Base;
};

GetFontLibrary GetFontLibrary::Default;

#endif

