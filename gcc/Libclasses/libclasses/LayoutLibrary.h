
#ifndef _LAYOUTLIBRARY_H
#define _LAYOUTLIBRARY_H

#include <intuition/intuition.h>
#include <intuition/classes.h>

class LayoutLibrary
{
public:
	LayoutLibrary();
	~LayoutLibrary();

	static class LayoutLibrary Default;

	Class * LAYOUT_GetClass();
	BOOL ActivateLayoutGadget(struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG object);
	VOID FlushLayoutDomainCache(struct Gadget * gadget);
	BOOL RethinkLayout(struct Gadget * gadget, struct Window * window, struct Requester * requester, LONG refresh);
	VOID LayoutLimits(struct Gadget * gadget, struct LayoutLimits * limits, struct TextFont * font, struct Screen * screen);
	Class * PAGE_GetClass();
	ULONG SetPageGadgetAttrsA(struct Gadget * gadget, Object * object, struct Window * window, struct Requester * requester, struct TagItem * tags);
	VOID RefreshPageGadget(struct Gadget * gadget, Object * object, struct Window * window, struct Requester * requester);

private:
	struct Library *Base;
};

LayoutLibrary LayoutLibrary::Default;

#endif

