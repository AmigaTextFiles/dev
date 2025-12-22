/*
**	PropGadget.c
**	21.09.92 - 04.02.93
*/

#include "Element.pro"
#include "Gadget.pro"
#include "PropGadget.pro"
#include "Simple.pro"
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

extern struct IntuitionBase *IntuitionBase;
extern struct TagItem flagsTags[], activationTags[], typeTags[];

/*
**	Funktionen zu PropGadget
**	09.09.92 - 09.09.92
*/

static struct PropGadget
{
	struct GadgetExtend gx;
	struct PropInfo pi;
	struct gadScrollerInfo pgi;
	struct Border bo1;
	void (*callback)(struct Gadget *, struct Window *, struct Requester *, APTR, ULONG);
};

STATIC USHORT gettop(USHORT pot, USHORT total, USHORT visible)
{
   USHORT max = 0xffff;

	if(total > visible)
		return((((ULONG)pot * (total - visible)) + (max>>1)) / max);
	else
		return(0);
}

STATIC void gadPropGadgetCallBack(struct Gadget *gad, struct Window *w, struct Requester *req, APTR special, ULONG code)
{
   struct PropGadget *pg = (struct PropGadget *)gad;

	if(pg->callback)
	{
		struct PropInfo *pi = (struct PropInfo *)gad->SpecialInfo;
		struct gadScrollerInfo *pgi = &pg->pgi;
   	USHORT max = 0xffff, pot;

      pot = (pi->Flags & FREEVERT)? pi->VertPot : pi->HorizPot;
		pgi->top = gettop(pot, pgi->total, pgi->visible);

		pg->callback(gad, w, req, (APTR)pgi, code);
	}
}

STATIC void getpotbody(USHORT *pot, USHORT *body, USHORT total, USHORT visib, USHORT top)
{
	USHORT max = 0xffff;

	if(total > visib)
	{
		top = MIN(top, total-visib);
		*pot = ((ULONG)top * max) / (total - visib);
		*body = ((ULONG)visib * max) / total;
	}
	else
	{
		*pot = 0;
		*body = max;
	}
}

STATIC ULONG gadSetPropGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
   struct PropInfo *pi;
	struct PropGadget *pg = (struct PropGadget *)gad;
	struct TagItem *tag, *workList = tagList;
	BOOL refresh = FALSE;
	USHORT body, pot;

	if(gad && GADGET_TYPE(gad) == PROP_GADGET &&
	(pi = (struct PropInfo *)gad->SpecialInfo))
	{
      while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
				case GADSC_Total:		pg->pgi.total = tag->ti_Data;
											break;
				case GADSC_Visible:	pg->pgi.visible = tag->ti_Data;
										break;
				case GADSC_Top:		pg->pgi.top = tag->ti_Data;
										break;
			}
		}
      getpotbody(&pot, &body, pg->pgi.total, pg->pgi.visible, pg->pgi.top);
		if((pi->Flags & FREEVERT) && (pi->VertPot != pot || pi->VertBody != body))
		{
			pi->VertPot = pot;
			pi->VertBody = body;
			refresh = TRUE;
      }
		if((pi->Flags & FREEHORIZ) && (pi->HorizPot != pot || pi->HorizBody != body))
		{
			pi->HorizPot = pot;
			pi->HorizBody = body;
			refresh = TRUE;
		}
   }
	return(refresh);
}

STATIC ULONG gadGetPropGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
	ULONG ret = FALSE;
	struct PropGadget *pg = (struct PropGadget *)gad;
	struct PropInfo *pi;
	USHORT pot;

	if(gad && GADGET_TYPE(gad) == PROP_GADGET &&
	(pi = (struct PropInfo *)gad->SpecialInfo) && storage)
	{
		switch(tag)
		{
			case GADSC_Total:	*storage = pg->pgi.total;
                           ret = TRUE;
                           break;
			case GADSC_Visible: *storage = pg->pgi.visible;
                           ret = TRUE;
                           break;
			case GADSC_Top:		pot = (pi->Flags & FREEVERT)? pi->VertPot : pi->HorizPot;
									*storage = gettop(pot, pg->pgi.total, pg->pgi.visible);
                           ret = TRUE;
                           break;
		}
	}
	return(ret);
}

STATIC void gadFreePropGadget(struct Gadget *gad)
{
	if(gad)
		FREEMEM(gad, sizeof(struct PropGadget));
}

struct Gadget *gadAllocPropGadgetA(struct TagItem *tagList)
{
   LONG freedom = GETTAGDATA(PGA_Freedom, FREEVERT, tagList);
	SHORT x = 10, y = 10,
			width = (freedom == FREEVERT? 10 : 100),
			height = (freedom == FREEVERT? 100 : 6);
	USHORT borderless = GETTAGDATA(PGA_Borderless, 0L, tagList),
			total = 1, visible = 1, top = 0,
			newlook = GETTAGDATA(GADSC_NewLook, 0, tagList),
			pot, body,
			flags = 0, piflags = AUTOKNOB,
			activation = GACT_RELVERIFY | GACT_IMMEDIATE | GACT_FOLLOWMOUSE;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
					  *gad;
	struct PropGadget *pg = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	if(borderless && (!newlook || !ISKICK20))
		piflags |= PROPBORDERLESS;
	if(newlook)
		piflags |= PROPNEWLOOK;
	getpotbody(&pot, &body, total, visible, top);

	if(pg = ALLOCMEM(sizeof(struct PropGadget)))
	{
		pg->gx.setattrs = gadSetPropGadgetAttrs;
		pg->gx.getattr = gadGetPropGadgetAttr;
		pg->gx.free = gadFreePropGadget;
		gad = &pg->gx.gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags;
		gad->Activation =	PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_PROPGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)&pg->bo1;
		gad->SelectRender = NULL;
		gad->GadgetText = NULL;
		gad->MutualExclude = (ULONG)gadPropGadgetCallBack;
		gad->SpecialInfo = (APTR) &pg->pi;
		gad->GadgetID =  (PROP_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		pg->callback = (void *)GETTAGDATA(GAD_CallBack, 0L, tagList);

		pg->pi.Flags = piflags | freedom;
		pg->pi.HorizPot = (freedom == FREEVERT)? 0 : pot;
		pg->pi.VertPot = (freedom == FREEVERT)? pot : 0;
		pg->pi.HorizBody = (freedom == FREEVERT)? 0xffff : body;
		pg->pi.VertBody = (freedom == FREEVERT)? body : 0xffff;

		pg->pgi.total = total;
		pg->pgi.visible = visible;
		pg->pgi.top = top;

      pg->bo1.LeftEdge = 0;
		pg->bo1.TopEdge  = 0;
      pg->bo1.FrontPen = 1;
		pg->bo1.BackPen = 0;
		pg->bo1.DrawMode = JAM1;
		pg->bo1.Count = 0;
		pg->bo1.XY = NULL;
		pg->bo1.NextBorder = NULL;

      gadSetPropGadgetAttrs(gad, NULL, NULL, tagList);
		return(gad);
	}
	if(pg)
		FREEMEM(pg, sizeof(struct PropGadget));
	return(NULL);
}
struct Gadget *gadAllocPropGadget(ULONG tag1, ...)
{
	return(gadAllocPropGadgetA((struct TagItem *)&tag1));
}

