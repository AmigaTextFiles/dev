
#ifndef _SPEEDBARLIBRARY_H
#define _SPEEDBARLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>
#include <utility/tagitem.h>

class SpeedBarLibrary
{
public:
	SpeedBarLibrary();
	~SpeedBarLibrary();

	static class SpeedBarLibrary Default;

	Class * SPEEDBAR_GetClass();
	struct Node * AllocSpeedButtonNodeA(UWORD number, struct TagItem * tags);
	VOID FreeSpeedButtonNode(struct Node * node);
	VOID SetSpeedButtonNodeAttrsA(struct Node * node, struct TagItem * tags);
	VOID GetSpeedButtonNodeAttrsA(struct Node * node, struct TagItem * tags);

private:
	struct Library *Base;
};

SpeedBarLibrary SpeedBarLibrary::Default;

#endif

