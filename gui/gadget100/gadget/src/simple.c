/*
**	Simple.c:	einfache Gadgets
**	13.09.92 - 29.12.92
*/

#include "Gadget.pro"
#include "Simple.pro"
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
extern struct Image 	checkimage0, checkimage1,
                     leftimage0, leftimage1, rightimage0, rightimage1,
							upimage0, upimage1, downimage0, downimage1,
							*upimage2, *downimage2, *leftimage2, *rightimage2,
							getfileimage0, getfileimage1;


/*
** Funktionen für BevelBorder
**	05.09.92 - 25.09.92
*/

struct BevelBorder
{
	struct GadgetExtend gx;
	struct Border bo1, bo2;
	SHORT data1[5][2], data2[5][2];
};

STATIC void gadFreeBevelBorder(struct Gadget *gad)
{
	if(gad)
   {
		gadFreeIntuiText(gad->GadgetText);
		FREEMEM(gad, sizeof(struct BevelBorder));
	}
}

struct Gadget *gadAllocBevelBorderA(struct TagItem *tagList)
{
	SHORT x = 10, y = 10, width=100, height=100, shortcut = 0;
	USHORT flags = 0;
   LONG recessed = GETTAGDATA(GADBB_Recessed, 1L, tagList);
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
			 *gad;
	struct BevelBorder *bb = NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);

   if((bb = (struct BevelBorder *)ALLOCMEM(sizeof(struct BevelBorder))) &&
	(!text || (itext = gadAllocIntuiText(1, 0, JAM2, x+16, y, &TextAttr, text, NULL))))
	{
		bb->gx.setattrs = NULL;
		bb->gx.getattr = NULL;
		bb->gx.free = gadFreeBevelBorder;
		gad = &bb->gx.gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = 0;
		gad->TopEdge = 0;
		gad->Width = 1;
		gad->Height = 1;
		gad->Flags = flags | GFLG_GADGHNONE;
		gad->Activation = 0;
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)&bb->bo1;
		gad->SelectRender = NULL;
		gad->GadgetText = itext;
		gad->MutualExclude = 0L;
		gad->SpecialInfo = NULL;
		gad->GadgetID = (BEVELBORDER << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		bb->bo1.XY = (WORD *)bb->data1;
		bb->bo2.XY = (WORD *)bb->data2;
		gadInitBorder(&bb->bo1, &bb->bo2, x+4, y+4, width-8, height-8, recessed != 0);

		return(gad);
	}
	if(itext)
		gadFreeIntuiText(itext);
	if(bb)
		FREEMEM(bb, sizeof(struct BevelBorder));
	return(NULL);
}
struct Gadget *gadAllocBevelBorder(ULONG tag1, ...)
{
	return(gadAllocBevelBorderA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu BorderGadget:
**	25.09.92 - 25.09.92
*/

STATIC void gadFreeBorderGadget(struct Gadget *gad)
{
	if(gad)
	{
		gadFreeImage(gad->GadgetRender);
		FREEMEM(gad, sizeof(struct GadgetExtend));
	}
}

struct Gadget *gadAllocBorderGadgetA(struct TagItem *tagList)
{
	SHORT	x = 10, y = 10, width = 100, height = 100;
	USHORT flags = 0, activation = 0;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct GadgetExtend *bg = NULL;
	struct Image *image;

	getxywhf(&x, &y, &width, &height, &flags, tagList);

   if((bg = ALLOCMEM(sizeof(struct GadgetExtend))) &&
	(image = gadAllocImage(0, 0, width, height, 2, 3, 0, NULL)))
	{
		bg->setattrs = NULL;
		bg->getattr = NULL;
		bg->free = gadFreeBorderGadget;
		gad = &bg->gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGIMAGE | GADGHNONE;
		gad->Activation = PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)image;
		gad->SelectRender = NULL;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (BORDER_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		gadMakeButtonImage(image, 0);

		return(gad);
	}
	if(image)
		gadFreeImage(image);
	if(bg)
		FREEMEM(bg, sizeof(struct GadgetExtend));
	return(NULL);
}
struct Gadget *gadAllocBorderGadget(ULONG tag1, ...)
{
	return(gadAllocBorderGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu CheckMarkGadget:
**	05.09.92 - 29.12.92
*/

STATIC void gadFreeCheckMarkGadget(struct Gadget *gad)
{
	if(gad)
	{
		gadFreeNewIntuiText(gad->GadgetText);
		FREEMEM(gad, sizeof(struct GadgetExtend));
	}
}

struct Gadget *gadAllocCheckMarkGadgetA(struct TagItem *tagList)
{
	SHORT w = checkimage0.Width, h = checkimage0.Height;
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	SHORT len = text? NEWSTRLEN(text)+1 : 0,
			x = 10, y = 10, width = w, height = h,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList),
			dy, dx, gx, gy, ix, iy;
	USHORT flags = 0, activation = GACT_RELVERIFY | GACT_TOGGLESELECT;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct GadgetExtend *cmg = NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	dy = (height - h)/2; dx = (width - w)/2;
   gx = x + dx; gy = y + dy;
	ix = -dx-len*8; iy = y + (height+1-8)/2 - gy;

   if((cmg = ALLOCMEM(sizeof(struct GadgetExtend))) &&
	(!text || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))))
	{
		cmg->setattrs = NULL;
		cmg->getattr = NULL;
		cmg->free = gadFreeCheckMarkGadget;
		gad = &cmg->gad;
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
		gad->GadgetRender = (APTR)&checkimage0;
		gad->SelectRender = (APTR)&checkimage1;
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (CHECKMARK_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		return(gad);
	}
	if(itext)
		gadFreeNewIntuiText(itext);
	if(cmg)
		FREEMEM(cmg, sizeof(struct GadgetExtend));
	return(NULL);
}
struct Gadget *gadAllocCheckMarkGadget(ULONG tag1, ...)
{
	return(gadAllocCheckMarkGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu ArrowGadget:
**	09.09.92 - 09.09.92
*/

STATIC void gadFreeArrowGadget(struct Gadget *gad)
{
	if(gad)
		FREEMEM(gad, sizeof(struct GadgetExtend));
}

struct Gadget *gadAllocArrowGadgetA(struct TagItem *tagList)
{
   struct Image *image0 = ISKICK20? leftimage2 : &leftimage0,
					 *image1 = ISKICK20? leftimage2 : &leftimage1;
   ULONG which = GETTAGDATA(GADAR_Which, LEFTIMAGE, tagList);
	SHORT w, h, width, height, x=10, y=10,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList);
	USHORT flags = 0,
			 activation = PACKBOOLTAGS(GACT_RELVERIFY, tagList, activationTags),
          border = (activation & BORDER) != 0,
			 use20 = (ISKICK20 && border);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct GadgetExtend *ag = NULL;

	switch(which)
	{
		case LEFTIMAGE:	image0 = use20? leftimage2 : &leftimage0;
								image1 = use20? leftimage2 : &leftimage1;
								break;
		case RIGHTIMAGE:	image0 = use20? rightimage2 : &rightimage0;
								image1 = use20? rightimage2 : &rightimage1;
								break;
		case UPIMAGE:		image0 = use20? upimage2 : &upimage0;
								image1 = use20? upimage2 : &upimage1;
								break;
		case DOWNIMAGE:	image0 = use20? downimage2 : &downimage0;
								image1 = use20? downimage2 : &downimage1;
								break;
	}
	width = w = image1->Width; height = h = image1->Height;
	getxywhf(&x, &y, &width, &height, &flags, tagList);

	if(ag = ALLOCMEM(sizeof(struct GadgetExtend)))
	{
		ag->setattrs = NULL;
		ag->getattr = NULL;
		ag->free = gadFreeArrowGadget;
		gad = &ag->gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x + (width - w)/2;
		gad->TopEdge = y + (height - h)/2;
		gad->Width = w;
		gad->Height = h;
		gad->Flags = flags | GFLG_GADGHIMAGE | GFLG_GADGIMAGE;
		gad->Activation =	activation;
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)image0;
		gad->SelectRender = (APTR)image1;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID =  (ARROW_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		return(gad);
	}
	if(ag)
		FREEMEM(ag, sizeof(struct GadgetExtend));
	return(NULL);
}
struct Gadget *gadAllocArrowGadget(ULONG tag1, ...)
{
	return(gadAllocArrowGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu GetFileGadget:
**	26.09.92 - 26.12.92
*/

STATIC void gadFreeGetFileGadget(struct Gadget *gad)
{
	if(gad)
		FREEMEM(gad, sizeof(struct GadgetExtend));
}

struct Gadget *gadAllocGetFileGadgetA(struct TagItem *tagList)
{
	SHORT w = getfileimage0.Width, h = getfileimage0.Height,
			x=10, y=10, width=w, height=h,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList);
	USHORT flags = 0,
			 activation = PACKBOOLTAGS(GACT_RELVERIFY, tagList, activationTags);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct GadgetExtend *gfg = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	if(gfg = ALLOCMEM(sizeof(struct GadgetExtend)))
	{
		gfg->setattrs = NULL;
		gfg->getattr = NULL;
		gfg->free = gadFreeGetFileGadget;
		gad = &gfg->gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x + (width - w)/2;
		gad->TopEdge = y + (height - h)/2;
		gad->Width = w;
		gad->Height = h;
		gad->Flags = flags | GFLG_GADGHIMAGE | GFLG_GADGIMAGE;
		gad->Activation =	activation;
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = (APTR)&getfileimage0;
		gad->SelectRender = (APTR)&getfileimage1;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID =  (GETFILE_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);

		return(gad);
	}
	if(gfg)
		FREEMEM(gfg, sizeof(struct GadgetExtend));
	return(NULL);
}
struct Gadget *gadAllocGetFileGadget(ULONG tag1, ...)
{
	return(gadAllocGetFileGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu BoolGadget
**	09.09.92 - 29.12.92
*/

struct BoolGadget
{
	struct GadgetExtend gx;
   ULONG newitext:1;
};

STATIC void gadFreeBoolGadget(struct Gadget *gad)
{
	struct BoolGadget *bg = (struct BoolGadget *)gad;

	if(bg)
	{
		if(bg->newitext)
			gadFreeNewIntuiText(bg->gx.gad.GadgetText);
		FREEMEM(bg, sizeof(struct BoolGadget));
	}
}

struct Gadget *gadAllocBoolGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	SHORT x=10, y=10, width=100, height=20, ix, iy,
			len = NEWSTRLEN(text);
	USHORT flags = GFLG_GADGHCOMP, highlight,
			 activation = GACT_RELVERIFY;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct IntuiText *useitext = (struct IntuiText *)GETTAGDATA(GA_IntuiText, 0L, tagList);
	struct BoolGadget *bg = NULL;
	struct IntuiText *itext = NULL;
   APTR 	border = (APTR)GETTAGDATA(GA_Border, 0L, tagList),
         image = (APTR)GETTAGDATA(GA_Image, 0L, tagList),
         selectrender = (APTR)GETTAGDATA(GA_SelectRender, 0L, tagList);
	SHORT shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList);

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	ix = (width-len*8)/2;
	iy = (height+1-8)/2;
	if(image)
		flags |= GFLG_GADGIMAGE;
	if(selectrender)
		flags |= GFLG_GADGHIMAGE;
	highlight = GETTAGDATA(GA_Highlight, flags, tagList);
	flags = (flags & ~(GFLG_GADGHIGHBITS)) | (highlight & GFLG_GADGHIGHBITS);

	if((bg = ALLOCMEM(sizeof(struct BoolGadget))) &&
	(!text || useitext || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))))
	{
		bg->gx.setattrs = NULL;
		bg->gx.getattr = NULL;
		bg->gx.free = gadFreeBoolGadget;
		gad = &bg->gx.gad;
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
		gad->GadgetRender = image? image : border;
		gad->SelectRender = selectrender;
		gad->GadgetText = useitext? useitext : itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (BOOL_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		bg->newitext = (text && !useitext);

		return(gad);
	}
	if(itext)
		gadFreeNewIntuiText(itext);
   if(bg)
		FREEMEM(bg, sizeof(struct BoolGadget));
	return(NULL);
}
struct Gadget *gadAllocBoolGadget(ULONG tag1, ...)
{
	return(gadAllocBoolGadgetA((struct TagItem *)&tag1));
}

