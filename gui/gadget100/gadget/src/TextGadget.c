/*
**	Funktionen zu TextGadget:
**	20.09.92 - 29.12.92
*/

#include "Element.pro"
#include "Gadget.pro"
#include "TextGadget.pro"
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

static struct TextGadget
{
	struct GadgetExtend gx;
	BYTE *buffer;
	USHORT maxlen;
};

STATIC ULONG gadSetTextGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
   struct TextGadget *tg = (struct TextGadget *)gad;
	struct TagItem *tag, *workList = tagList;
	struct IntuiText *it;
	BYTE *s;
	ULONG refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == TEXT_GADGET && (it=gad->GadgetText))
	{
		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
            case GA_Text:

					s = (BYTE *)tag->ti_Data;
					sprintf(tg->buffer, "%-.*s", tg->maxlen, s? s : "");
					it->LeftEdge = (gad->Width - strlen(tg->buffer)*8)/2;
					refresh = TRUE;
					break;
			}
		}
	}
	return(refresh);
}

STATIC ULONG gadGetTextGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
   ULONG ret = FALSE;
	struct TextGadget *sbg = (struct TextGadget *)gad;

	if(gad && GADGET_TYPE(gad) == TEXT_GADGET && gad->GadgetText && storage)
	{
		switch(tag)
		{
			case GA_Text:	*storage = (ULONG)gad->GadgetText->IText;
                        ret = TRUE;
                        break;
		}
	}
	return(ret);
}

STATIC void gadFreeTextGadget(struct Gadget *gad)
{
	struct TextGadget *tg = (struct TextGadget *)gad;

	if(gad)
	{
		gadFreeImage(gad->GadgetRender);
		if(tg->buffer)
			FREEMEM(tg->buffer, tg->maxlen+1L);
		gadFreeIntuiText(gad->GadgetText);
		FREEMEM(gad, sizeof(struct TextGadget));
	}
}

struct Gadget *gadAllocTextGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList),
        *buffer;
	SHORT len = text? strlen(text) : 0,
			x = 10, y = 10, w = len*8, h = 8,
			width = w+16, height = 14, dx, dy;
	USHORT flags = 0, activation = 0, maxlen;
	ULONG border = GETTAGDATA(GA_Border, 1L, tagList);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct TextGadget *tg = NULL;
	struct Image *image = NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	dx = (width - w)/2; dy = (height+1 - h)/2;
	maxlen = (width-16)/8;

   if((tg = ALLOCMEM(sizeof(struct TextGadget))) &&
	(buffer = ALLOCMEM(maxlen + 1L))	&&
	(itext = gadAllocIntuiText(1, 0, JAM1, dx, dy, &TextAttr, buffer, NULL)) &&
	(image = gadAllocImage(0, 0, width, height, 2, 3, 0, NULL)))
	{
		tg->gx.setattrs = gadSetTextGadgetAttrs;
		tg->gx.getattr = gadGetTextGadgetAttr;
		tg->gx.free = gadFreeTextGadget;
		gad = &tg->gx.gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGIMAGE | GFLG_GADGHNONE;
		gad->Activation = PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)image;
		gad->SelectRender = NULL;
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (TEXT_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		gadMakeRecessedImage(image, border!=0);
		tg->buffer = buffer;
		buffer[0] = 0;
		tg->maxlen = maxlen;

		gadSetTextGadgetAttrs(gad, NULL, NULL, tagList);
		return(gad);
	}
	if(image)
		gadFreeImage(image);
	if(itext)
		gadFreeIntuiText(itext);
	if(buffer)
		FREEMEM(buffer, maxlen+1L);
	if(tg)
		FREEMEM(tg, sizeof(struct TextGadget));
	return(NULL);
}
struct Gadget *gadAllocTextGadget(ULONG tag1, ...)
{
	return(gadAllocTextGadgetA((struct TagItem *)&tag1));
}

