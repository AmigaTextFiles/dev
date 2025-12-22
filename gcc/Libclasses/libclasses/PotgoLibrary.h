
#ifndef _POTGOLIBRARY_H
#define _POTGOLIBRARY_H

#include <exec/types.h>

class PotgoLibrary
{
public:
	PotgoLibrary();
	~PotgoLibrary();

	static class PotgoLibrary Default;

	UWORD AllocPotBits(ULONG bits);
	VOID FreePotBits(ULONG bits);
	VOID WritePotgo(ULONG word, ULONG mask);

private:
	struct Library *Base;
};

PotgoLibrary PotgoLibrary::Default;

#endif

