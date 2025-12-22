
#ifndef _RADIOBUTTONLIBRARY_H
#define _RADIOBUTTONLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <utility/tagitem.h>

class RadioButtonLibrary
{
public:
	RadioButtonLibrary();
	~RadioButtonLibrary();

	static class RadioButtonLibrary Default;

	Class * RADIOBUTTON_GetClass();
	struct Node * AllocRadioButtonNodeA(UWORD columns, struct TagItem * tags);
	VOID FreeRadioButtonNode(struct Node * node);
	VOID SetRadioButtonNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID GetRadioButtonNodeAttrsA(struct Node * node, struct TagItem * tags);

private:
	struct Library *Base;
};

RadioButtonLibrary RadioButtonLibrary::Default;

#endif

