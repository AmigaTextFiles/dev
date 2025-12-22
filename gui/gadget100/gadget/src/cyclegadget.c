/*
**	CycleGadget.c
**	22.09.92 - 30.12.92
*/

#include "CycleGadget.pro"
#include "Gadget.pro"
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
extern struct TextAttr TextAttr, BoldTextAttr;

struct CycleGadget
{
	struct GadgetExtend gx;
	struct IntuiText *it;
	struct gadCycleInfo cgi;
	void (*callback)(struct Gadget *, struct Window *, struct Requester *, struct gadCycleInfo *, ULONG);
};

STATIC void cyclecallback(struct Gadget *gad, struct Window *w, struct Requester *req, APTR special, ULONG class, struct IntuiMessage *message)
{
	struct CycleGadget *cg = (struct CycleGadget *)gad;
	BYTE **s;
	LONG anz=0, newactive;

	if(class == GADGETUP && (s = cg->cgi.labels))
	{
		for(; *s; s++)
			anz++;

		newactive = cg->cgi.active + ((message->Qualifier & SHIFT)? -1 : 1);
		if(newactive >= anz)
			newactive = 0;
		else if(newactive < 0)
			newactive = anz-1;

		gadSetGadgetAttrs(gad, w, req, GADCYC_Active, newactive, TAG_DONE);
	}
	if(cg->callback)
		cg->callback(gad, w, req, &cg->cgi, class);
}

STATIC ULONG gadSetCycleGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
	BOOL refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == CYCLE_GADGET)
	{
	   struct CycleGadget *cg = (struct CycleGadget *)gad;
		struct gadCycleInfo *cgi = &cg->cgi;
		struct IntuiText *it = cg->it;
		struct TagItem *tag, *workList = tagList;
		BYTE **s, *show;
		USHORT anz;

		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
				case GADCYC_Labels:   cgi->labels = (BYTE **)tag->ti_Data;
											refresh = TRUE;
											break;
				case GADCYC_Active:   cgi->active = tag->ti_Data;
											refresh = TRUE;
											break;
			}
		}
      if(refresh)
		{
			if(s = cgi->labels)
			{
				for(anz=0; *s; s++)
					anz++;
				if(cgi->active >= anz)
					cgi->active = 0;
			}
			else
				cgi->active = 0;
			show = (cgi->labels && anz>0)? cgi->labels[cgi->active] : "";
			it->IText = (UBYTE *)show;
			it->LeftEdge = 22 + (gad->Width - 22 - strlen(show)*8)/2;
		}
	}
	return(refresh);
}

STATIC ULONG gadGetCycleGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
	BOOL ret = FALSE;

	if(gad && GADGET_TYPE(gad) == CYCLE_GADGET && storage)
	{
	   struct CycleGadget *cg = (struct CycleGadget *)gad;
		struct gadCycleInfo *cgi = &cg->cgi;

		switch(tag)
		{
			case GADCYC_Labels:   *storage = (ULONG)cgi->labels;
										ret = TRUE;
										break;
			case GADCYC_Active:   *storage = cgi->active;
										ret = TRUE;
										break;
		}
	}
	return(ret);
}

STATIC void gadFreeCycleGadget(struct Gadget *gad)
{
	struct Image *im;

	if(gad)
	{
		if(gad->GadgetText)
			gadFreeNewIntuiText(gad->GadgetText->NextText);
		gadFreeIntuiText(gad->GadgetText);
		if(im = (struct Image *)gad->GadgetRender)
		{
			if(im->ImageData)
				FREECHIPMEM(im->ImageData, im->Depth*im->Height*2*((im->Width+15)/16));
			FREEMEM(im, sizeof(struct Image));
		}
		if(im = (struct Image *)gad->SelectRender)
		{
			if(im->ImageData)
				FREECHIPMEM(im->ImageData, im->Depth*im->Height*2*((im->Width+15)/16));
			FREEMEM(im, sizeof(struct Image));
		}
		FREEMEM(gad, sizeof(struct CycleGadget));
	}
}

struct Gadget *gadAllocCycleGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList),
			**labels = (BYTE **)GETTAGDATA(GADCYC_Labels, 0L, tagList), **s;
	SHORT len1 = text? NEWSTRLEN(text)+1 : 0, len2 = 0,
			x=10, y=10, width, height=14, wperrow, bperrow,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList),
			ix1, iy1, ix2, iy2;
	USHORT flags = 0,
			 activation = GACT_RELVERIFY;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList);
	struct CycleGadget *cg = NULL;
	struct Gadget *gad = NULL;
	struct IntuiText *itext1=NULL, *itext2=NULL;
	struct Image *im1=NULL, *im2=NULL;
   UWORD *data1=NULL, *data2=NULL;

   for(s = labels; s && *s; s++)
      len2 = MAX(len2, strlen(*s));
	width = 22 + (1+len2+1)*8;
	getxywhf(&x, &y, &width, &height, &flags, tagList);
	wperrow = (width+15)/16;
	bperrow = wperrow*2;
	ix1 = -len1*8+1; iy1 = (height+1-8)/2;
	ix2 = 22; iy2 = iy1;

   if((cg = ALLOCMEM(sizeof(struct CycleGadget))) &&
	(im1 = ALLOCMEM(sizeof(struct Image))) &&
	(im2 = ALLOCMEM(sizeof(struct Image))) &&
	(data1 = ALLOCCHIPMEM(2L * height * bperrow)) &&
	(data2 = ALLOCCHIPMEM(2L * height * bperrow)) &&
	(!text || (itext1 = gadAllocNewIntuiText(text, ix1, iy1, 1, &shortcut))) &&
	(itext2 = gadAllocIntuiText(-1, -1, JAM1, ix2, iy2, &TextAttr, "", itext1)))
	{
		cg->gx.setattrs = gadSetCycleGadgetAttrs;
		cg->gx.getattr = gadGetCycleGadgetAttr;
		cg->gx.free = gadFreeCycleGadget;
		gad = &cg->gx.gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGHIMAGE | GFLG_GADGIMAGE;
		gad->Activation =	PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)im1;
		gad->SelectRender = (APTR)im2;
		gad->GadgetText = itext2;
		gad->MutualExclude = (ULONG)cyclecallback;
		gad->SpecialInfo = NULL;
		gad->GadgetID = (CYCLE_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		im1->LeftEdge = 0;
		im1->TopEdge = 0;
		im1->Width = width;
		im1->Height = height;
		im1->Depth = 2;
		im1->ImageData = data1;
		im1->PlanePick = 3;
		im1->PlaneOnOff = 0;
		im1->NextImage = NULL;
		gadMakeCycleImage(im1, 0);

		im2->LeftEdge = 0;
		im2->TopEdge = 0;
		im2->Width = width;
		im2->Height = height;
		im2->Depth = 2;
		im2->ImageData = data2;
		im2->PlanePick = 3;
		im2->PlaneOnOff = 0;
		im2->NextImage = NULL;
		gadMakeCycleImage(im2, 1);

		cg->cgi.labels = NULL;
		cg->cgi.active = 0;
		cg->it = itext2;
		cg->callback = (void *)GETTAGDATA(GAD_CallBack, 0L, tagList);
		gadSetCycleGadgetAttrs(gad, NULL, NULL, tagList);
		return(gad);
	}
	if(itext2)
		gadFreeIntuiText(itext2);
	if(itext1)
		gadFreeNewIntuiText(itext1);
	if(data2)
		FREECHIPMEM(data2, 2*height*bperrow);
	if(data1)
		FREECHIPMEM(data1, 2*height*bperrow);
	if(im2)
		FREEMEM(im2, sizeof(struct Image));
	if(im1)
		FREEMEM(im1, sizeof(struct Image));
	if(cg)
		FREEMEM(gad, sizeof(struct CycleGadget));
	return(NULL);
}
struct Gadget *gadAllocCycleGadget(ULONG tag1, ...)
{
	return(gadAllocCycleGadgetA((struct TagItem *)&tag1));
}

