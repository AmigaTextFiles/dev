
#ifndef _DISKFONTLIBRARY_H
#define _DISKFONTLIBRARY_H

#include <dos/dos.h>
#include <libraries/diskfont.h>

class DiskfontLibrary
{
public:
	DiskfontLibrary();
	~DiskfontLibrary();

	static class DiskfontLibrary Default;

	struct TextFont * OpenDiskFont(struct TextAttr * textAttr);
	LONG AvailFonts(STRPTR buffer, LONG bufBytes, LONG flags);
	struct FontContentsHeader * NewFontContents(BPTR fontsLock, STRPTR fontName);
	VOID DisposeFontContents(struct FontContentsHeader * fontContentsHeader);
	struct DiskFont * NewScaledDiskFont(struct TextFont * sourceFont, struct TextAttr * destTextAttr);

private:
	struct Library *Base;
};

DiskfontLibrary DiskfontLibrary::Default;

#endif

