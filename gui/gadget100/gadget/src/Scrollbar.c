/*
** Scrollbar.c
**	13.09.92 - 10.10.92
*/

#include "Gadget.pro"
#include "Gadget_stub.pro"
#include "PropGadget.pro"
#include "Simple.pro"
#include "Scrollbar.pro"
#include "Message.pro"
#include "Element.pro"
#include "Utility.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#else
#ifdef STATIC
#undef STATIC
#endif
#define STATIC
#endif

extern struct TagItem flagsTags[], activationTags[], typeTags[];

struct ScrollbarGadget
{
	struct ComposedGadget compg;
	struct Gadget *prop, *arrowpos, *arrowneg;
	USHORT jump;
};

STATIC void gadScrollbarGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, APTR special, ULONG code, struct IntuiMessage *message)
{
   struct Gadget *gad = (struct Gadget *)callgad->UserData;

   if(gad)
		gadDoCallBack(gad, w, req, special, code, message);
}

STATIC void gadArrowNegGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, APTR special, ULONG code, struct IntuiMessage *message)
{
	struct ScrollbarGadget *sbg = (struct ScrollbarGadget *)callgad->UserData;
	struct Gadget *prop;
	ULONG top, newtop;

	if(code!=GADGETUP && sbg && (prop = sbg->prop) &&
	gadGetGadgetAttr(GADSC_Top, prop, &top) && top>0)
	{
		newtop = (sbg->jump > top)? 0L : top - sbg->jump;
   	gadSetGadgetAttrs(prop, w, req, GADSC_Top, newtop, TAG_DONE);
		gadDoCallBack(prop, w, req, special, code, message);
	}
}

STATIC void gadArrowPosGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, APTR special, ULONG code, struct IntuiMessage *message)
{
	struct ScrollbarGadget *sbg = (struct ScrollbarGadget *)callgad->UserData;
	struct Gadget *prop;
	ULONG top, total, visible, newtop;

	if(code!=GADGETUP && sbg && (prop = sbg->prop) &&
	gadGetGadgetAttr(GADSC_Top, prop, &top) &&
	gadGetGadgetAttr(GADSC_Total, prop, &total) &&
	gadGetGadgetAttr(GADSC_Visible, prop, &visible) &&
	top < (total-visible))
	{
		newtop = top+sbg->jump;
   	gadSetGadgetAttrs(prop, w, req, GADSC_Top, newtop, TAG_DONE);
		gadDoCallBack(prop, w, req, special, code, message);
	}
}

STATIC ULONG gadSetScrollbarGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
   struct ScrollbarGadget *sbg = (struct ScrollbarGadget *)gad;
	struct TagItem *tag, *workList = tagList;
	ULONG refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == SCROLLBAR_GADGET)
	{
		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
            case GADSC_Jump:  	sbg->jump = tag->ti_Data;
										break;
			}
		}
	}
	return(refresh);
}

STATIC ULONG gadGetScrollbarGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
   ULONG ret = FALSE;
	struct ScrollbarGadget *sbg = (struct ScrollbarGadget *)gad;

	if(gad && GADGET_TYPE(gad) == SCROLLBAR_GADGET && storage)
	{
		switch(tag)
		{
			case GADSC_Jump:	*storage = sbg->jump;
                           ret = TRUE;
                           break;
		}
	}
	return(ret);
}

STATIC void gadFreeScrollbarGadget(struct Gadget *gad)
{
	if(gad)
	{
      gadFreeImage(gad->GadgetRender);
		FREEMEM(gad, sizeof(struct ScrollbarGadget));
	}
}

struct Gadget *gadAllocScrollbarGadgetA(struct TagItem *tagList)
{
	ULONG freedom = GETTAGDATA(GADSC_Freedom, FREEVERT, tagList);
	SHORT isvert = (freedom == FREEVERT);
	SHORT	x=10, y=10,
			width = isvert? 18 : 100, height = isvert? 100 : 10,
			w1, w2, h1, h2, bw, bh, rw, rh;
	USHORT flags = 0, arrowflags=0,
			activation = PACKBOOLTAGS(0, tagList, activationTags),
			isrel;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct Gadget *first = NULL;
	struct ScrollbarGadget *sbg = NULL;
	struct Gadget *arrowneg = NULL, *arrowpos = NULL, *prop = NULL;
	struct Image *image = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	if(rw = ((flags & GFLG_RELWIDTH) != 0))
		arrowflags |= GFLG_RELRIGHT;
	if(rh = ((flags & GFLG_RELHEIGHT) != 0))
		arrowflags |= GFLG_RELBOTTOM;
	isrel = ((flags & (GFLG_RELWIDTH | GFLG_RELHEIGHT)) != 0);

	if((sbg = ALLOCMEM(sizeof(struct ScrollbarGadget))) &&
   (arrowneg = gadAllocArrowGadget(GA_Immediate, 1L,
												GA_RelVerify, 1L,
												GADAR_Which, (isvert? UPIMAGE : LEFTIMAGE),
                                    GA_Previous, &first,
												GAD_CallBack, gadArrowNegGadgetCallBack,
                                    GA_UserData, sbg,
												TAG_MORE, tagList)) 	&&
	(arrowpos = gadAllocArrowGadget(GA_Immediate, 1L,
											GA_RelVerify, 1L,
											GADAR_Which, (isvert? DOWNIMAGE : RIGHTIMAGE),
											GA_Previous, &arrowneg->NextGadget,
											GAD_CallBack, gadArrowPosGadgetCallBack,
											GA_UserData, sbg,
											TAG_MORE, tagList))		&&
	(prop = gadAllocPropGadget(GA_Previous, &arrowpos->NextGadget,
									GAD_CallBack, gadScrollbarGadgetCallBack,
									GA_UserData, sbg,
									PGA_Borderless, (LONG)!isrel,
									TAG_MORE, tagList)))
	{
		sbg->compg.gx.setattrs = gadSetScrollbarGadgetAttrs;
  	   sbg->compg.gx.getattr = gadGetScrollbarGadgetAttr;
		sbg->compg.gx.free = gadFreeScrollbarGadget;
		gad = &sbg->compg.gx.gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGHNONE;
		gad->Activation = activation & ~(GACT_IMMEDIATE | GACT_RELVERIFY);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = NULL;
		gad->SelectRender = NULL;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (SCROLLBAR_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		sbg->compg.num = 3;
		sbg->prop = prop;
		sbg->arrowpos = arrowpos;
		sbg->arrowneg = arrowneg;
		sbg->jump = 1;

		w1 = arrowneg->Width; h1 = arrowneg->Height;
		w2 = arrowpos->Width; h2 = arrowpos->Height;

		if(isvert)
		{
			arrowneg->LeftEdge = x + (width - w1)/2 + rw;
			arrowneg->TopEdge = y + height - h2 - h1 + rh;
			arrowpos->LeftEdge = x + (width - w2)/2 + rw;
			arrowpos->TopEdge = y + height - h2 + rh;
			bw = width;
			bh = height - h1 - h2;
		}
		else
		{
			arrowneg->LeftEdge = x + width - w2 - w1 + rw;
			arrowneg->TopEdge = y + (height - h1)/2 + rh;
			arrowpos->LeftEdge = x + width - w2 + rw;
			arrowpos->TopEdge = y + (height - h2)/2 + rh;
			bw = width - w1 - w2;
			bh = height;
		}
		arrowflags |= arrowpos->Flags & ~(GFLG_RELWIDTH | GFLG_RELHEIGHT);
		arrowpos->Flags = arrowflags;
		arrowneg->Flags = arrowflags;
		arrowpos->GadgetID |= CHILD_GADGET << 8;
		arrowneg->GadgetID |= CHILD_GADGET << 8;

		prop->LeftEdge += 4;
		prop->TopEdge += 2;
		prop->Width = bw - 8;
		prop->Height = bh - 4;
		prop->GadgetID |= CHILD_GADGET << 8;
		prop->NextGadget = gad;

		if(prev)
			*prev = first;
      gadSetScrollbarGadgetAttrs(gad, NULL, NULL, tagList);
      if(isrel)
			return(gad);
		else if(image = gadAllocImage(0, 0, bw, bh, 2, 3, 0, NULL))
		{
			gadMakeButtonImage(image, 0);
			gad->Flags |= GFLG_GADGIMAGE;
			gad->GadgetRender = image;
			return(gad);
		}
	}
	gadFreeImage(image);
	gadFreeGadget(prop);
	gadFreeGadget(arrowpos);
	gadFreeGadget(arrowneg);
	if(sbg)
		FREEMEM(sbg, sizeof(struct ScrollbarGadget));
	return(NULL);
}
struct Gadget *gadAllocScrollbarGadget(ULONG tag1, ...)
{
	return(gadAllocScrollbarGadgetA((struct TagItem *)&tag1));
}

