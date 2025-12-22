
#ifndef _BULLETLIBRARY_H
#define _BULLETLIBRARY_H

#include <utility/tagitem.h>
#include <diskfont/glyph.h>

class BulletLibrary
{
public:
	BulletLibrary();
	~BulletLibrary();

	static class BulletLibrary Default;

	struct GlyphEngine * OpenEngine();
	VOID CloseEngine(struct GlyphEngine * glyphEngine);
	ULONG SetInfoA(struct GlyphEngine * glyphEngine, struct TagItem * tagList);
	ULONG ObtainInfoA(struct GlyphEngine * glyphEngine, struct TagItem * tagList);
	ULONG ReleaseInfoA(struct GlyphEngine * glyphEngine, struct TagItem * tagList);

private:
	struct Library *Base;
};

BulletLibrary BulletLibrary::Default;

#endif

