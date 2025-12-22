
#ifndef _DISKFONTLIBRARY_CPP
#define _DISKFONTLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/DiskfontLibrary.h>

DiskfontLibrary::DiskfontLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("diskfont.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open diskfont.library") );
	}
}

DiskfontLibrary::~DiskfontLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

struct TextFont * DiskfontLibrary::OpenDiskFont(struct TextAttr * textAttr)
{
	register struct TextFont * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = textAttr;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct TextFont *) _res;
}

LONG DiskfontLibrary::AvailFonts(STRPTR buffer, LONG bufBytes, LONG flags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = buffer;
	register int d0 __asm("d0") = bufBytes;
	register int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

struct FontContentsHeader * DiskfontLibrary::NewFontContents(BPTR fontsLock, STRPTR fontName)
{
	register struct FontContentsHeader * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int a0 __asm("a0") = fontsLock;
	register char * a1 __asm("a1") = fontName;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct FontContentsHeader *) _res;
}

VOID DiskfontLibrary::DisposeFontContents(struct FontContentsHeader * fontContentsHeader)
{
	register void * a6 __asm("a6") = Base;
	register void * a1 __asm("a1") = fontContentsHeader;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a1)
	: "a1");
}

struct DiskFont * DiskfontLibrary::NewScaledDiskFont(struct TextFont * sourceFont, struct TextAttr * destTextAttr)
{
	register struct DiskFont * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = sourceFont;
	register void * a1 __asm("a1") = destTextAttr;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (struct DiskFont *) _res;
}


#endif

