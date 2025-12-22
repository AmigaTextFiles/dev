/*
**	MXGadget.c:	mutually exclusive, radio buttons
**	27.12.92 - 29.12.92
*/

#include "Gadget.pro"
#include "Gadget_stub.pro"
#include "mx.pro"
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
extern struct TextAttr TextAttr;
extern struct Image 	radioimage0, radioimage1;

/*
**	Funktionen zu RadioButtonGadget:
**	05.09.92 - 29.12.92
*/

STATIC void gadFreeRadioButtonGadget(struct Gadget *gad)
{
	if(gad)
	{
		gadFreeNewIntuiText(gad->GadgetText);
		FREEMEM(gad, sizeof(struct GadgetExtend));
	}
}

struct Gadget *gadAllocRadioButtonGadgetA(struct TagItem *tagList)
{
	SHORT w = radioimage0.Width, h = radioimage0.Height;
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	SHORT len = text? NEWSTRLEN(text)+1 : 0,
			x = 10, y=10, width=w, height=h,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList),
			dy, dx, gx, gy, ix, iy;
	USHORT flags = 0, activation = GACT_RELVERIFY | GACT_TOGGLESELECT;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct GadgetExtend *rbg = NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	dy = (height - h)/2; dx = (width - w)/2;
   gx = x + dx; gy = y + dy;
	ix = -dx-len*8; iy = y + (height+1-8)/2 - gy;

   if((rbg = ALLOCMEM(sizeof(struct GadgetExtend))) &&
	(!text || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))))
	{
		rbg->setattrs = NULL;
		rbg->getattr = NULL;
		rbg->free = gadFreeRadioButtonGadget;
		gad = &rbg->gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = gx;
		gad->TopEdge = gy;
		gad->Width = w;
		gad->Height = h;
		gad->Flags = flags | GFLG_GADGHIMAGE | GFLG_GADGIMAGE;
		gad->Activation = PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)&radioimage0;
		gad->SelectRender = (APTR)&radioimage1;
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (RADIOBUTTON_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		return(gad);
	}
	if(itext)
		gadFreeNewIntuiText(itext);
	if(rbg)
		FREEMEM(rbg, sizeof(struct GadgetExtend));
	return(NULL);
}
struct Gadget *gadAllocRadioButtonGadget(ULONG tag1, ...)
{
	return(gadAllocRadioButtonGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu MXGadget
**	09.09.92 - 27.12.92
*/

#define MAXLABELS 100

struct MXGadget
{
	struct ComposedGadget compg;
	struct Gadget *radiobutton[MAXLABELS+1];
	struct gadMXInfo mxi;
};

STATIC ULONG setactive(struct Gadget *gad, struct Window *w, struct Requester *req, USHORT active)
{
   struct MXGadget *mxg = (struct MXGadget *)gad;
	BOOL refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == MX_GADGET &&
	active>=0 && active<MAXLABELS && mxg->radiobutton[active])
	{
		refresh |= gadSetSelectedFlag(mxg->radiobutton[mxg->mxi.active], w, req, FALSE);
		mxg->mxi.active = active;
		refresh |= gadSetSelectedFlag(mxg->radiobutton[active], w, req, TRUE);
	}
	return(refresh);
}

STATIC void RadioButtonGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, APTR special, ULONG class, struct IntuiMessage *message)
{
	struct Gadget *gad = (struct Gadget *)callgad->UserData;
	struct MXGadget *mxg = (struct MXGadget *)gad;
	USHORT active;

	for(active = 0; mxg->radiobutton[active]; active++)
		if(mxg->radiobutton[active] == callgad)
			break;

	setactive(gad, w, req, active);
	gadDoCallBack(gad, w, req, (APTR)&mxg->mxi, class, message);
}

STATIC ULONG gadSetMXGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
	BOOL refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == MX_GADGET)
	{
	   struct MXGadget *mxg = (struct MXGadget *)gad;
		struct gadMXInfo *mxi = &mxg->mxi;
		struct TagItem *tag, *workList = tagList;
		USHORT newactive = mxi->active;

		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
				case GADMX_Active:	newactive = tag->ti_Data;
											break;
			}
		}
		if(newactive != mxi->active)
			refresh = setactive(gad, w, req, newactive);
	}
	return(refresh);
}

STATIC ULONG gadGetMXGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
   ULONG ret = FALSE;

	if(gad && GADGET_TYPE(gad) == MX_GADGET && storage)
	{
		struct MXGadget *mxg = (struct MXGadget *)gad;
		struct gadMXInfo *mxi = &mxg->mxi;

		switch(tag)
		{
			case GADMX_Active:	*storage = mxi->active;
                              ret = TRUE;
										break;
		}
	}
	return(ret);
}

STATIC void gadFreeMXGadget(struct Gadget *gad)
{
	struct MXGadget *mxg = (struct MXGadget *)gad;

	if(mxg)
	{
		FREEMEM(mxg, sizeof(struct MXGadget));
	}
}

struct Gadget *gadAllocMXGadgetA(struct TagItem *tagList)
{
	BYTE **labels = (BYTE **)GETTAGDATA(GADMX_Labels, NULL, tagList);
	SHORT	x=10, y=10,	width, height;
	USHORT flags = 0, i, anz=0,
			activation = PACKBOOLTAGS(0, tagList, activationTags);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList);
	struct Gadget *first = NULL, *gad = NULL;
	struct MXGadget *mxg = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);

	if(mxg = ALLOCMEM(sizeof(struct MXGadget)))
	{
		if(labels)
			for(anz=0; anz<MAXLABELS && labels[anz]; anz++)
			{
				if(!(mxg->radiobutton[anz] = gad = gadAllocRadioButtonGadget(
										GA_Left, x,
                             	GA_Top, y + anz * (radioimage0.Height+1),
										GAD_CallBack, RadioButtonGadgetCallBack,
										GA_RelVerify, FALSE,
										GA_Immediate, TRUE,
										GA_UserData, mxg,
                              GA_Previous, gad? &gad->NextGadget : &first,
                              GA_Text, labels[anz],
										GA_Selected, anz==0,
										TAG_MORE, tagList)))
					goto mxexit;
				mxg->radiobutton[anz]->GadgetID |= CHILD_GADGET<<8;
      	}
		mxg->compg.num = anz;
		mxg->compg.gx.setattrs = gadSetMXGadgetAttrs;
		mxg->compg.gx.getattr = gadGetMXGadgetAttr;
		mxg->compg.gx.free = gadFreeMXGadget;
		if(gad)
			gad = gad->NextGadget = &mxg->compg.gx.gad;
		else
			gad = first = &mxg->compg.gx.gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = 0;         /* value required? */
		gad->Height = 0;        /* value required? */
		gad->Flags = flags | GFLG_GADGHNONE;
		gad->Activation = activation & ~(GACT_IMMEDIATE | GACT_RELVERIFY);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = NULL;
		gad->SelectRender = NULL;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (MX_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		mxg->mxi.active = 0;

		gadSetMXGadgetAttrs(gad, NULL, NULL, tagList);

		if(prev)
			*prev = first;
		return(gad);
	}

mxexit:

	if(mxg)
	{
		for(i=0; i<anz; i++)
			gadFreeGadget(mxg->radiobutton[i]);
		FREEMEM(mxg, sizeof(struct MXGadget));
	}
	return(NULL);
}
struct Gadget *gadAllocMXGadget(ULONG tag1, ...)
{
	return(gadAllocMXGadgetA((struct TagItem *)&tag1));
}

