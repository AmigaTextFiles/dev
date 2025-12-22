
#ifndef _LOCALELIBRARY_CPP
#define _LOCALELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/LocaleLibrary.h>

LocaleLibrary::LocaleLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("locale.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open locale.library") );
	}
}

LocaleLibrary::~LocaleLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

VOID LocaleLibrary::CloseCatalog(struct Catalog * catalog)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = catalog;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

VOID LocaleLibrary::CloseLocale(struct Locale * locale)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG LocaleLibrary::ConvToLower(struct Locale * locale, ULONG character)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

ULONG LocaleLibrary::ConvToUpper(struct Locale * locale, ULONG character)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

VOID LocaleLibrary::FormatDate(struct Locale * locale, STRPTR fmtTemplate, struct DateStamp * date, struct Hook * putCharFunc)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register char * a1 __asm("a1") = fmtTemplate;
	register void * a2 __asm("a2") = date;
	register void * a3 __asm("a3") = putCharFunc;

	__asm volatile ("jsr a6@(-60)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
}

APTR LocaleLibrary::FormatString(struct Locale * locale, STRPTR fmtTemplate, APTR dataStream, struct Hook * putCharFunc)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register char * a1 __asm("a1") = fmtTemplate;
	register void * a2 __asm("a2") = dataStream;
	register void * a3 __asm("a3") = putCharFunc;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (APTR) _res;
}

STRPTR LocaleLibrary::GetCatalogStr(struct Catalog * catalog, LONG stringNum, STRPTR defaultString)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = catalog;
	register int d0 __asm("d0") = stringNum;
	register char * a1 __asm("a1") = defaultString;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
	return (STRPTR) _res;
}

STRPTR LocaleLibrary::GetLocaleStr(struct Locale * locale, ULONG stringNum)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = stringNum;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (STRPTR) _res;
}

BOOL LocaleLibrary::IsAlNum(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsAlpha(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsCntrl(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsDigit(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsGraph(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsLower(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsPrint(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsPunct(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsSpace(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsUpper(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

BOOL LocaleLibrary::IsXDigit(struct Locale * locale, ULONG character)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register unsigned int d0 __asm("d0") = character;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

struct Catalog * LocaleLibrary::OpenCatalogA(struct Locale * locale, STRPTR name, struct TagItem * tags)
{
	register struct Catalog * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register char * a1 __asm("a1") = name;
	register void * a2 __asm("a2") = tags;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (struct Catalog *) _res;
}

struct Locale * LocaleLibrary::OpenLocale(STRPTR name)
{
	register struct Locale * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Locale *) _res;
}

BOOL LocaleLibrary::ParseDate(struct Locale * locale, struct DateStamp * date, STRPTR fmtTemplate, struct Hook * getCharFunc)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register void * a1 __asm("a1") = date;
	register char * a2 __asm("a2") = fmtTemplate;
	register void * a3 __asm("a3") = getCharFunc;

	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
	: "a0", "a1", "a2", "a3");
	return (BOOL) _res;
}

ULONG LocaleLibrary::StrConvert(struct Locale * locale, STRPTR string, APTR buffer, ULONG bufferSize, ULONG type)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register char * a1 __asm("a1") = string;
	register void * a2 __asm("a2") = buffer;
	register unsigned int d0 __asm("d0") = bufferSize;
	register unsigned int d1 __asm("d1") = type;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
	: "a0", "a1", "a2", "d0", "d1");
	return (ULONG) _res;
}

LONG LocaleLibrary::StrnCmp(struct Locale * locale, STRPTR string1, STRPTR string2, LONG length, ULONG type)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = locale;
	register char * a1 __asm("a1") = string1;
	register char * a2 __asm("a2") = string2;
	register int d0 __asm("d0") = length;
	register unsigned int d1 __asm("d1") = type;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
	: "a0", "a1", "a2", "d0", "d1");
	return (LONG) _res;
}


#endif

