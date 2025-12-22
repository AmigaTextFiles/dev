#ifndef GADLAYOUT_GADLAYOUT_PROTOS_H
#define GADLAYOUT_GADLAYOUT_PROTOS_H
/*
**	$Filename: gadlayout/gadlayout_protos.h $
**	$Release: 1.7 $
**	$Revision: 36.4 $
**	$Date: 93/07/09 $
**
**	GadLayout function definitions.
**
**	(C) Copyright 1993, Timothy J. Aston
**	All Rights Reserved
*/

APTR LayoutGadgets(struct Gadget **, struct LayoutGadget *, struct Screen *, Tag *, ...);
APTR LayoutGadgetsA(struct Gadget **gad_list, struct LayoutGadget *g, struct Screen *, struct TagItem *);
VOID GL_SetGadgetAttrs(APTR, struct Gadget *, struct Window *, struct Requester *, Tag *, ...);
VOID GL_SetGadgetAttrsA(APTR, struct Gadget *, struct Window *, struct Requester *, struct TagItem *taglist);
WORD GadgetArrayIndex(WORD, struct LayoutGadget *);
struct Gadget * GetGadgetInfo(WORD, struct LayoutGadget *);
UBYTE GadgetKeyCmd(APTR pi, WORD, struct LayoutGadget *);
VOID FreeLayoutGadgets(APTR);

#endif /* GADLAYOUT_GADLAYOUT_PROTOS_H */

