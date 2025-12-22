
#ifndef _GLYPHLIBRARY_H
#define _GLYPHLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class GlyphLibrary
{
public:
	GlyphLibrary();
	~GlyphLibrary();

	static class GlyphLibrary Default;

	Class * GLYPH_GetClass();

private:
	struct Library *Base;
};

GlyphLibrary GlyphLibrary::Default;

#endif

