
#ifndef _CHECKBOXLIBRARY_H
#define _CHECKBOXLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class CheckBoxLibrary
{
public:
	CheckBoxLibrary();
	~CheckBoxLibrary();

	static class CheckBoxLibrary Default;

	Class * CHECKBOX_GetClass();

private:
	struct Library *Base;
};

CheckBoxLibrary CheckBoxLibrary::Default;

#endif

