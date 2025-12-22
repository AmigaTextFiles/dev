/*
** Palette.c
** 02.10.92 - 06.06.93
*/

#include "Gadget.pro"
#include "Gadget_stub.pro"
#include "Simple.pro"
#include "Palette.pro"
#include "Message.pro"
#include "Utility.pro"
#include "Element.pro"

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

/*
**	Funktionen zu ColorGadget
** 02.10.92 - 02.10.92
*/

STATIC void gadFreeColorGadget(struct Gadget *gad)
{
	if(gad)
	{
		gadFreeImage(gad->GadgetRender);
      FREEMEM(gad, sizeof(struct GadgetExtend));
	}
}

STATIC struct Gadget *gadAllocColorGadgetA(struct TagItem *tagList)
{
	USHORT color = GETTAGDATA(GACO_Color, 0, tagList);
	SHORT x=10, y=10, width=40, height=20;
	USHORT flags = GFLG_GADGHCOMP | GFLG_GADGIMAGE, highlight,
			activation = GACT_RELVERIFY;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList);
	struct Gadget *gad;
	struct GadgetExtend *cg = NULL;
	struct Image *image = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	highlight = GETTAGDATA(GA_Highlight, flags, tagList);
	flags = (flags & ~(GFLG_GADGHIGHBITS)) | (highlight & GFLG_GADGHIGHBITS);

	if((cg = ALLOCMEM(sizeof(struct GadgetExtend))) &&
	(image = gadAllocImage(0, 0, width, height, 0, 0, color, NULL)))
	{
		cg->setattrs = NULL;
		cg->getattr = NULL;
		cg->free = gadFreeColorGadget;
		gad = &cg->gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags;
		gad->Activation = PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = image;
		gad->SelectRender = NULL;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = 0;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		return(gad);
	}
   gadFreeImage(image);
	if(cg)
		FREEMEM(cg, sizeof(struct GadgetExtend));
	return(NULL);
}
STATIC struct Gadget *gadAllocColorGadget(ULONG tag1, ...)
{
	return(gadAllocColorGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu PaletteGadget
** 02.10.92 - 06.06.93
*/

#define MAXPALETTEENTRIES 32L

struct PaletteGadget
{
	struct ComposedGadget compg;
	struct Gadget *indicator, *color[MAXPALETTEENTRIES];
	struct gadPaletteInfo pgi;
};

STATIC void gadColorGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class, struct IntuiMessage *message)
{
   struct Gadget *gad = (struct Gadget *)callgad->UserData;
	struct PaletteGadget *pg = (struct PaletteGadget *)gad;
	ULONG color = (ULONG)callgad->SelectRender;

   gadSetGadgetAttrs(gad, w, req, GADPA_Color, color, TAG_DONE);
	gadDoCallBack(gad, w, req, (APTR)&pg->pgi, class, message);
}

STATIC void gadIndicatorGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class, struct IntuiMessage *message)
{
   struct Gadget *gad = (struct Gadget *)callgad->UserData;
	struct PaletteGadget *pg = (struct PaletteGadget *)gad;
   USHORT color = pg->pgi.color;
   USHORT coloroffset = pg->pgi.coloroffset;
   USHORT colors = 1 << pg->pgi.depth;

   color += (message->Qualifier & SHIFT)? -1 : 1;
   if(color >= colors)
      color = coloroffset;
   else if(color < coloroffset)
      color = colors-1;

   gadSetGadgetAttrs(gad, w, req, GADPA_Color, (LONG)color, TAG_DONE);
	gadDoCallBack(gad, w, req, (APTR)&pg->pgi, class, message);
}

STATIC ULONG gadSetPaletteGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
   struct PaletteGadget *pg = (struct PaletteGadget *)gad;
	struct gadPaletteInfo *pgi = &pg->pgi;
	struct TagItem *tag, *workList = tagList;
	BOOL refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == PALETTE_GADGET)
	{
		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
				case GADPA_Color:	pgi->color = tag->ti_Data;
										refresh = TRUE;
										break;
			}
		}
		if(refresh)
		{
			pgi->color = MIN(pgi->color, (1<<pgi->depth));
			pgi->color = MAX(pgi->color, pgi->coloroffset);

			if(refresh = (pg->indicator!=NULL))
         {
				((struct Image *)pg->indicator->GadgetRender)->PlaneOnOff = pgi->color;
				if(w)
				{
					RefreshGList(pg->indicator, w, req, 1L);
               refresh = FALSE;
				}
			}
		}
	}
	return(refresh);
}

STATIC ULONG gadGetPaletteGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
   ULONG ret = FALSE;
	struct PaletteGadget *pg = (struct PaletteGadget *)gad;
	struct gadPaletteInfo *pgi = &pg->pgi;

	if(gad && GADGET_TYPE(gad) == PALETTE_GADGET && storage)
	{
		switch(tag)
		{
         case GADPA_Color:	*storage = pgi->color;
                           ret = TRUE;
  	                        break;
		}
	}
	return(ret);
}

STATIC void gadFreePaletteGadget(struct Gadget *gad)
{
	struct PaletteGadget *pg = (struct PaletteGadget *)gad;
	struct Image *image;

	if(pg)
	{
		if(image = (struct Image *)gad->GadgetRender)
			gadFreeImage(image->NextImage);
		gadFreeImage(image);
		gadFreeNewIntuiText(gad->GadgetText);
		FREEMEM(pg, sizeof(struct PaletteGadget));
	}
}

struct Gadget *gadAllocPaletteGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0, tagList);
	SHORT	x=10, y=10,	width = 100, height = 20,
			len = text? NEWSTRLEN(text)+1 : 0,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList),
			depth = GETTAGDATA(GADPA_Depth, 1, tagList),
			coloff = GETTAGDATA(GADPA_ColorOffset, 0, tagList),
			indiw = GETTAGDATA(GADPA_IndicatorWidth, 0, tagList),
         numcol, ix, iy, w, h, dx, dy, indx, indy;
	USHORT flags = 0, i, anz=0,
			activation = PACKBOOLTAGS(0, tagList, activationTags);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList);
	struct Gadget *first = NULL;
	struct PaletteGadget *pg = NULL;
	struct Gadget *indi=NULL, *gad = NULL;
	struct Image *button=NULL, *bevel=NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	ix = -len*8-indiw; iy = (height+1-8)/2;
   depth = MIN(8, depth); depth = MAX(1, depth);
	numcol = (1<<depth);
   coloff = MIN(numcol-1, coloff);	coloff = MAX(0, coloff);
	numcol -= coloff;
	w = (width-8) / numcol;
	dx = (width-w*numcol)/2;
	dy = dx/2;
	h = height - 2*dy;
	indx = x - indiw;
	indy = y;

	if((pg = ALLOCMEM(sizeof(struct PaletteGadget))) &&
	(!text || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))) &&
	(!indiw || ((bevel=gadAllocImage(indx-x, indy-y, indiw, height, 2, 3, 0, NULL)) &&
	(indi = gad = gadAllocColorGadget(GA_Left, (LONG)indx+dx,
   	GA_Top, (LONG)indy+dy,
		GA_Width, (LONG)indiw-2*dx,
      GA_Height, (LONG)h,
	   GACO_Color, (LONG)coloff,
      GA_Previous, &first,
		GA_Highlight, GADGHNONE,
      GA_Immediate, 1L,
      GA_RelVerify, 0L,
      GA_UserData, pg,
      GAD_CallBack, gadIndicatorGadgetCallBack,
      TAG_MORE, tagList)))) &&
	(button = gadAllocImage(0, 0, width, height, 2, 3, 0, bevel)))

	{
      for(i=coloff, anz=0; i<(1<<depth); i++, anz++)
		{
			if(!(pg->color[anz] = gad = gadAllocColorGadget(
										GA_Left, (LONG)x+anz*w+dx,
                              GA_Top, (LONG)y+dy,
                              GA_Width, (LONG)w,
										GA_Height, (LONG)h,
										GA_Previous, gad? &gad->NextGadget : &first,
										GACO_Color, (LONG)i,
										GA_UserData, pg,
										GAD_CallBack, gadColorGadgetCallBack,
										TAG_MORE, tagList)))
				goto gadAllocPaletteGadgetExit;

			gad->GadgetID |= CHILD_GADGET<<8;
			gad->SelectRender = (void *)i;
      }
		pg->compg.num = anz+1;
		pg->compg.gx.setattrs = gadSetPaletteGadgetAttrs;
		pg->compg.gx.getattr = gadGetPaletteGadgetAttr;
		pg->compg.gx.free = gadFreePaletteGadget;
		gad = gad->NextGadget = &pg->compg.gx.gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGHNONE | GFLG_GADGIMAGE;
		gad->Activation = (activation | GACT_IMMEDIATE) & ~(GACT_RELVERIFY);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = button;
		gad->SelectRender = NULL;
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (PALETTE_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		if(button)
			gadMakeButtonImage(button, 0);
		if(bevel)
			gadMakeRecessedImage(bevel, 1);
		pg->indicator = indi;
		if(indi)
			indi->GadgetID |= (CHILD_GADGET << 8) | shortcut;
		pg->pgi.color = coloff;
		pg->pgi.coloroffset = coloff;
		pg->pgi.depth = depth;
		gadSetPaletteGadgetAttrs(gad, NULL, NULL, tagList);
		if(prev)
			*prev = first;
		return(gad);
	}

gadAllocPaletteGadgetExit:

	if(pg)
		for(i=0; i<anz; i++)
			gadFreeGadget(pg->color[i]);
	gadFreeGadget(indi);
	gadFreeImage(bevel);
	gadFreeImage(button);
	gadFreeNewIntuiText(itext);
	if(pg)
		FREEMEM(pg, sizeof(struct PaletteGadget));
	return(NULL);
}
struct Gadget *gadAllocPaletteGadget(ULONG tag1, ...)
{
	return(gadAllocPaletteGadgetA((struct TagItem *)&tag1));
}

