
#ifndef _SCROLLERLIBRARY_H
#define _SCROLLERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class ScrollerLibrary
{
public:
	ScrollerLibrary();
	~ScrollerLibrary();

	static class ScrollerLibrary Default;

	Class * SCROLLER_GetClass();

private:
	struct Library *Base;
};

ScrollerLibrary ScrollerLibrary::Default;

#endif

