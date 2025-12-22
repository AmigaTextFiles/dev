
#ifndef _TEXTFIELDLIBRARY_H
#define _TEXTFIELDLIBRARY_H

#include <intuition/intuition.h>
#include <intuition/classes.h>

class TextFieldLibrary
{
public:
	TextFieldLibrary();
	~TextFieldLibrary();

	static class TextFieldLibrary Default;

	Class * TEXTFIELD_GetClass();

private:
	struct Library *Base;
};

TextFieldLibrary TextFieldLibrary::Default;

#endif

