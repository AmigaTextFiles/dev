
#ifndef _DATEBROWSERLIBRARY_H
#define _DATEBROWSERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class DateBrowserLibrary
{
public:
	DateBrowserLibrary();
	~DateBrowserLibrary();

	static class DateBrowserLibrary Default;

	Class * DATEBROWSER_GetClass();
	UWORD JulianWeekDay(UWORD day, UWORD month, LONG year);
	void JulianMonthDays(int month, int year);
	BOOL JulianLeapYear(LONG year);

private:
	struct Library *Base;
};

DateBrowserLibrary DateBrowserLibrary::Default;

#endif

