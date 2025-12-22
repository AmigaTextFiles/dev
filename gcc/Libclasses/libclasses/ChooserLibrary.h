
#ifndef _CHOOSERLIBRARY_H
#define _CHOOSERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <utility/tagitem.h>

class ChooserLibrary
{
public:
	ChooserLibrary();
	~ChooserLibrary();

	static class ChooserLibrary Default;

	Class * CHOOSER_GetClass();
	struct Node * AllocChooserNodeA(struct TagItem * tags);
	VOID FreeChooserNode(struct Node * node);
	VOID SetChooserNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID GetChooserNodeAttrsA(struct Node * node, struct TagItem * tags);
	ULONG ShowChooser(Object *obj, struct Window *win, ULONG xpos, ULONG ypos);
	VOID HideChooser(Object *obj, struct Window *win);

private:
	struct Library *Base;
};

ChooserLibrary ChooserLibrary::Default;

#endif

