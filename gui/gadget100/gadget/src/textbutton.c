/*
** Funktionen zu TextButtongadget:
** 05.09.92 - 25.09.92
*/

#include "Gadget.pro"
#include "TextButton.pro"
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

extern struct Library *IntuitionBase;
extern struct TagItem flagsTags[], activationTags[], typeTags[];
extern struct TextAttr TextAttr, BoldTextAttr;


STATIC void gadFreeTextButtonGadget(struct Gadget *gad)
{
	struct Image *im;

	if(gad)
	{
		gadFreeNewIntuiText(gad->GadgetText);
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
		FREEMEM(gad, sizeof(struct GadgetExtend));
	}
}

struct Gadget *gadAllocTextButtonGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	SHORT len = NEWSTRLEN(text), w = (len+2)*8, h = 14,
			x=10, y=10, width=w, height=h, wperrow, bperrow,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList),
			ix, iy;
	USHORT flags = 0,
			 activation = GACT_RELVERIFY;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
			 *gad;
	struct GadgetExtend *tbg = NULL;
	struct IntuiText *itext = NULL;
	struct Image *im1=NULL, *im2=NULL;
   UWORD *data1=NULL, *data2=NULL, *p;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	wperrow = (width+15)/16;
	bperrow = wperrow*2;
	ix = (width - len*8)/2; iy = (height+1-8)/2;

   if((tbg = ALLOCMEM(sizeof(struct GadgetExtend))) &&
	(im1 = ALLOCMEM(sizeof(struct Image))) &&
	(im2 = ALLOCMEM(sizeof(struct Image))) &&
	(data1 = ALLOCCHIPMEM(2L * height * bperrow)) &&
	(data2 = ALLOCCHIPMEM(2L * height * bperrow)) &&
	(!text || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))))
	{
		tbg->setattrs = NULL;
      tbg->getattr = NULL;
		tbg->free = gadFreeTextButtonGadget;
		gad = &tbg->gad;
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
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (TEXTBUTTON_GADGET << 8) | (UBYTE)shortcut;
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
		gadMakeButtonImage(im1, 0);

		im2->LeftEdge = 0;
		im2->TopEdge = 0;
		im2->Width = width;
		im2->Height = height;
		im2->Depth = 2;
		im2->ImageData = data2;
		im2->PlanePick = 3;
		im2->PlaneOnOff = 0;
		im2->NextImage = NULL;
		gadMakeButtonImage(im2, 1);

		return(gad);
	}
	if(itext)
		gadFreeNewIntuiText(itext);
	if(data2)
		FREECHIPMEM(data2, 2*height*bperrow);
	if(data1)
		FREECHIPMEM(data1, 2*height*bperrow);
	if(im2)
		FREEMEM(im2, sizeof(struct Image));
	if(im1)
		FREEMEM(im1, sizeof(struct Image));
	if(tbg)
		FREEMEM(tbg, sizeof(struct GadgetExtend));
	return(NULL);
}
struct Gadget *gadAllocTextButtonGadget(ULONG tag1, ...)
{
	return(gadAllocTextButtonGadgetA((struct TagItem *)&tag1));
}

