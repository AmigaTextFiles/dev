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

static struct TextButtonGadget
{
	struct GadgetExtend gx;
	struct Image images[5];
};

static struct BoolInfo BoolInfo =
{
   0, NULL, 0L,
};

STATIC void gadMakeButtonImage2(struct Image *images, SHORT width, SHORT height)
{
	register struct Image *im;

	/* left line */
	im = images;
	im->LeftEdge = 0;
	im->TopEdge = 0;
	im->Width = 2;
	im->Height = height;
	im->Depth = 2;
	im->ImageData = NULL;
	im->PlanePick = 0;
	im->PlaneOnOff = 2;
	im->NextImage = im+1;

   /* top line */
	im++;
	im->LeftEdge = 2;
	im->TopEdge = 0;
	im->Width = width-4;
	im->Height = 1;
	im->Depth = 2;
	im->ImageData = NULL;
	im->PlanePick = 0;
	im->PlaneOnOff = 2;
	im->NextImage = im+1;

	/* right line */
	im++;
	im->LeftEdge = width-2;
	im->TopEdge = 0;
	im->Width = 2;
	im->Height = height;
	im->Depth = 2;
	im->ImageData = NULL;
	im->PlanePick = 0;
	im->PlaneOnOff = 1;
	im->NextImage = im+1;

	/* bottom line */
	im++;
	im->LeftEdge = 2;
	im->TopEdge = height-1;
	im->Width = width-4;
	im->Height = 1;
	im->Depth = 2;
	im->ImageData = NULL;
	im->PlanePick = 0;
	im->PlaneOnOff = 1;
	im->NextImage = im+1;

	/* inner field */
	im++;
	im->LeftEdge = 2;
	im->TopEdge = 1;
	im->Width = width-4;
	im->Height = height-2;
	im->Depth = 2;
	im->ImageData = NULL;
	im->PlanePick = 0;
	im->PlaneOnOff = 0;
	im->NextImage = NULL;
}

STATIC void gadFreeTextButtonGadget(struct Gadget *gad)
{
	if(gad)
	{
		gadFreeNewIntuiText(gad->GadgetText);
		FREEMEM(gad, sizeof(struct TextButtonGadget));
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
	struct TextButtonGadget *tbg = NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	wperrow = (width+15)/16;
	bperrow = wperrow*2;
	ix = (width - len*8)/2; iy = (height+1-8)/2;

   if((tbg = ALLOCMEM(sizeof(struct TextButtonGadget))) &&
	(!text || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))))
	{
		tbg->gx.setattrs = NULL;
      tbg->gx.getattr = NULL;
		tbg->gx.free = gadFreeTextButtonGadget;
		gad = &tbg->gx.gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGHCOMP | GFLG_GADGIMAGE;
		gad->Activation =	PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)tbg->images;
		gad->SelectRender = NULL;
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (TEXTBUTTON_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		gadMakeButtonImage2(tbg->images, gad->Width, gad->Height);

		return(gad);
	}
	if(itext)
		gadFreeNewIntuiText(itext);
	if(tbg)
		FREEMEM(tbg, sizeof(struct TextButtonGadget));
	return(NULL);
}
struct Gadget *gadAllocTextButtonGadget(ULONG tag1, ...)
{
	return(gadAllocTextButtonGadgetA((struct TagItem *)&tag1));
}

