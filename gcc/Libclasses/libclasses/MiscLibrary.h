
#ifndef _MISCLIBRARY_H
#define _MISCLIBRARY_H

#include <exec/types.h>

class MiscLibrary
{
public:
	MiscLibrary();
	~MiscLibrary();

	static class MiscLibrary Default;

	UBYTE * AllocMiscResource(ULONG unitNum, CONST_STRPTR name);
	VOID FreeMiscResource(ULONG unitNum);

private:
	struct Library *Base;
};

MiscLibrary MiscLibrary::Default;

#endif

