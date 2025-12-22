
#ifndef _LABELLIBRARY_H
#define _LABELLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class LabelLibrary
{
public:
	LabelLibrary();
	~LabelLibrary();

	static class LabelLibrary Default;

	Class * LABEL_GetClass();

private:
	struct Library *Base;
};

LabelLibrary LabelLibrary::Default;

#endif

