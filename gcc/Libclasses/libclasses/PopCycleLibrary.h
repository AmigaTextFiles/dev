
#ifndef _POPCYCLELIBRARY_H
#define _POPCYCLELIBRARY_H

#include <intuition/intuition.h>
#include <intuition/classes.h>

class PopCycleLibrary
{
public:
	PopCycleLibrary();
	~PopCycleLibrary();

	static class PopCycleLibrary Default;

	Class * POPCYCLE_GetClass();
	struct Node * AllocPopCycleNodeA(struct TagItem * tags);
	VOID FreePopCycleNode(struct Node * node);
	VOID SetPopCycleNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID GetPopCycleNodeAttrsA(struct Node * node, struct TagItem * tags);

private:
	struct Library *Base;
};

PopCycleLibrary PopCycleLibrary::Default;

#endif

