
#ifndef _TRANSLATORLIBRARY_H
#define _TRANSLATORLIBRARY_H

#include <exec/types.h>

class TranslatorLibrary
{
public:
	TranslatorLibrary();
	~TranslatorLibrary();

	static class TranslatorLibrary Default;

	LONG Translate(CONST_STRPTR inputString, LONG inputLength, STRPTR outputBuffer, LONG bufferSize);

private:
	struct Library *Base;
};

TranslatorLibrary TranslatorLibrary::Default;

#endif

