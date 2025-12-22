
#ifndef _LISTBROWSERLIBRARY_H
#define _LISTBROWSERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <utility/tagitem.h>

class ListBrowserLibrary
{
public:
	ListBrowserLibrary();
	~ListBrowserLibrary();

	static class ListBrowserLibrary Default;

	Class * LISTBROWSER_GetClass();
	struct Node * AllocListBrowserNodeA(UWORD columns, struct TagItem * tags);
	VOID FreeListBrowserNode(struct Node * node);
	VOID SetListBrowserNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID GetListBrowserNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID ListBrowserSelectAll(struct List * list);
	VOID ShowListBrowserNodeChildren(struct Node * node, WORD depth);
	VOID HideListBrowserNodeChildren(struct Node * node);
	VOID ShowAllListBrowserChildren(struct List * list);
	VOID HideAllListBrowserChildren(struct List * list);
	VOID FreeListBrowserList(struct List * list);

private:
	struct Library *Base;
};

ListBrowserLibrary ListBrowserLibrary::Default;

#endif

