///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////                                        ////////////////////
///////////////////           file : cfont.cc              ////////////////////
///////////////////                                        ////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

#include <intuition/intuitionbase.h>
#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/diskfont_protos.h>

#include <string.h>

//extern struct Library *OpenLibrary(char *, long);
//extern void *CloseLibrary(struct Library *);
//struct IntuitionBase *IntuitionBase=NULL;
//struct GfxBase *GfxBase=NULL;
//struct DiskFontBase *DiskFontBase=NULL;


#include "cfont.h"


BOOL CFont :: initlibs()
{
//	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
//	if (IntuitionBase == NULL) return FALSE;
//	GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0);
//	if (GfxBase == NULL)
//	{
//		CloseLibrary((struct Library *)IntuitionBase);
//		return FALSE;
//	}
//	DiskFontBase = (struct DiskFontBase *)OpenLibrary("diskfont.library", 0);
//	if (DiskFontBase == NULL) return FALSE;
	return TRUE;
}

CFont :: CFont()
{
	if (!initlibs()) return;
	font=NULL;
}

CFont :: CFont(STRPTR fontname, UWORD fontsize, UBYTE style, UBYTE flags)
{
	if (!initlibs()) return;
	font=NULL;
	open(fontname, fontsize, style, flags);
}

CFont :: ~CFont()
{
	if (font) CloseFont(font);
//	if (DiskFontBase) CloseLibrary((struct Library *)DiskFontBase);
}

BOOL CFont :: open(STRPTR fontname, UWORD fontsize, UBYTE style, UBYTE flags)
{
	if (isopen()) close();
	fontattr.ta_Name=fontname;
	fontattr.ta_YSize=fontsize;
	fontattr.ta_Style=style;
	fontattr.ta_Flags=flags;
	font=OpenDiskFont(&fontattr);
	return isopen();
}

void CFont :: close(void)
{
	if (font) CloseFont(font);
	font=NULL;
}

BOOL CFont :: isopen()
{
	return (font!=NULL);
}

