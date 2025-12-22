/*
**	Gadget_Stub.c
**	13.09.92 - 25.12.92
*/

#include "Gadget.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#endif

struct Gadget *gadAllocGadget(ULONG kind, ULONG tag1, ...)
{
	return(gadAllocGadgetA(kind, (struct TagItem *)&tag1));
}
ULONG gadSetGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, ULONG tag1, ...)
{
	return(gadSetGadgetAttrsA(gad, w, req, (struct TagItem *)&tag1));
}
