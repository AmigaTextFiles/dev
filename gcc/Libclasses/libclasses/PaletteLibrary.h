
#ifndef _PALETTELIBRARY_H
#define _PALETTELIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class PaletteLibrary
{
public:
	PaletteLibrary();
	~PaletteLibrary();

	static class PaletteLibrary Default;

	Class * PALETTE_GetClass();

private:
	struct Library *Base;
};

PaletteLibrary PaletteLibrary::Default;

#endif

