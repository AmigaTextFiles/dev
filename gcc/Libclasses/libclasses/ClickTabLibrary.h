
#ifndef _CLICKTABLIBRARY_H
#define _CLICKTABLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <utility/tagitem.h>

class ClickTabLibrary
{
public:
	ClickTabLibrary();
	~ClickTabLibrary();

	static class ClickTabLibrary Default;

	Class * CLICKTAB_GetClass();
	struct Node * AllocClickTabNodeA(struct TagItem * tags);
	VOID FreeClickTabNode(struct Node * node);
	VOID SetClickTabNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID GetClickTabNodeAttrsA(struct Node * node, struct TagItem * tags);

private:
	struct Library *Base;
};

ClickTabLibrary ClickTabLibrary::Default;

#endif

