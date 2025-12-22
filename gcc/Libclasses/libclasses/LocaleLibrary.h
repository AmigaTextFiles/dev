
#ifndef _LOCALELIBRARY_H
#define _LOCALELIBRARY_H

#include <exec/types.h>
#include <libraries/locale.h>
#include <dos/dos.h>
#include <utility/hooks.h>
#include <utility/tagitem.h>
#include <rexx/storage.h>

class LocaleLibrary
{
public:
	LocaleLibrary();
	~LocaleLibrary();

	static class LocaleLibrary Default;

	VOID CloseCatalog(struct Catalog * catalog);
	VOID CloseLocale(struct Locale * locale);
	ULONG ConvToLower(struct Locale * locale, ULONG character);
	ULONG ConvToUpper(struct Locale * locale, ULONG character);
	VOID FormatDate(struct Locale * locale, STRPTR fmtTemplate, struct DateStamp * date, struct Hook * putCharFunc);
	APTR FormatString(struct Locale * locale, STRPTR fmtTemplate, APTR dataStream, struct Hook * putCharFunc);
	STRPTR GetCatalogStr(struct Catalog * catalog, LONG stringNum, STRPTR defaultString);
	STRPTR GetLocaleStr(struct Locale * locale, ULONG stringNum);
	BOOL IsAlNum(struct Locale * locale, ULONG character);
	BOOL IsAlpha(struct Locale * locale, ULONG character);
	BOOL IsCntrl(struct Locale * locale, ULONG character);
	BOOL IsDigit(struct Locale * locale, ULONG character);
	BOOL IsGraph(struct Locale * locale, ULONG character);
	BOOL IsLower(struct Locale * locale, ULONG character);
	BOOL IsPrint(struct Locale * locale, ULONG character);
	BOOL IsPunct(struct Locale * locale, ULONG character);
	BOOL IsSpace(struct Locale * locale, ULONG character);
	BOOL IsUpper(struct Locale * locale, ULONG character);
	BOOL IsXDigit(struct Locale * locale, ULONG character);
	struct Catalog * OpenCatalogA(struct Locale * locale, STRPTR name, struct TagItem * tags);
	struct Locale * OpenLocale(STRPTR name);
	BOOL ParseDate(struct Locale * locale, struct DateStamp * date, STRPTR fmtTemplate, struct Hook * getCharFunc);
	ULONG StrConvert(struct Locale * locale, STRPTR string, APTR buffer, ULONG bufferSize, ULONG type);
	LONG StrnCmp(struct Locale * locale, STRPTR string1, STRPTR string2, LONG length, ULONG type);

private:
	struct Library *Base;
};

LocaleLibrary LocaleLibrary::Default;

#endif

