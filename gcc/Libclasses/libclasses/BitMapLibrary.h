
#ifndef _BITMAPLIBRARY_H
#define _BITMAPLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class BitMapLibrary
{
public:
	BitMapLibrary();
	~BitMapLibrary();

	static class BitMapLibrary Default;

	Class * BITMAP_GetClass();

private:
	struct Library *Base;
};

BitMapLibrary BitMapLibrary::Default;

#endif

