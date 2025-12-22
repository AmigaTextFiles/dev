
#ifndef _TEXTEDITORLIBRARY_H
#define _TEXTEDITORLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class TextEditorLibrary
{
public:
	TextEditorLibrary();
	~TextEditorLibrary();

	static class TextEditorLibrary Default;

	Class * TEXTEDITOR_GetClass();

private:
	struct Library *Base;
};

TextEditorLibrary TextEditorLibrary::Default;

#endif

