/*
**	viewport.c
**	20.09.92 - 20.09.92
*/

#include "Gadget.pro"
#include "Gadget_stub.pro"
#include "Scrollbar.pro"
#include "Simple.pro"
#include "Viewport.pro"
#include "Message.pro"
#include "Utility.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#endif

extern struct TagItem flagsTags[], activationTags[], typeTags[];
extern struct TextAttr TextAttr;

/*
**	Funktionen zu ViewportGadget
**	20.09.92 - 20.09.92
*/

struct ViewportGadget
{
	struct Gadget gad;
	USHORT num;
	struct Gadget *scrollx, *scrolly;
	struct Gadget **members;
}

struct Gadget *gadAllocViewportGadgetA(struct TagItem *tagList)
{
	SHORT	x=10, y=10,	width = 100, height = 100;
	USHORT flags = 0, activation = 0;
	ULONG allowx = GETTAGDATA(GAVP_AllowHoriz, 1L, tagList),
			allowy = GETTAGDATA(GAVP_AllowVert, 1L, tagList);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
                 **members = (struct Gadget **)GETTAGDATA(GAVP_Members, 0L, tagList);
	struct Gadget *first = NULL;
	struct ViewportGadget *vpg = NULL;
	struct Gadget *scrollx = NULL, *scrolly = NULL, gad = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);

	if((vpg = ALLOCMEM(sizeof(struct ViewportGadget))) &&
   (!allowx || (scrollx = gad = gadAllocScrollbarGadget(
                                    GA_Previous, &first,
												GA_Left, 0L,
												GA_RelBottomTop, -9L,
												GA_RelWidth, -18L,
												GA_Height, 10L,
												GAD_CallBack, NULL,
                                    GA_UserData, vpg,
												GA_BottomBorder, 1L,
												TAG_MORE, tagList))) &&
   (!allowy || (scrolly = gad = gadAllocScrollbarGadget(
                                    GA_Previous, (first? &gad->NextGadget : first),
												GA_RelRight, -17L,
												GA_Top, 11L,
												GA_Width, 18L,
												GA_RelHeight, -11L-10L,
												GAD_CallBack, NULL,
                                    GA_UserData, vpg,
												GA_RightBorder, 1L,
												TAG_MORE, tagList))))
	{
		vpg->num = 2;
		if(first)
			gad->NextGadget = &vpg->gad;
		else
			first = &vpg->gad;
		vpg->gad.NextGadget = NULL;
		vpg->gad.LeftEdge = 0;
		vpg->gad.TopEdge = 0;
		vpg->gad.Width = 0;
		vpg->gad.Height = 0;
		vpg->gad.Flags = flags | GFLG_GADGHNONE;
		vpg->gad.Activation = PACKBOOLTAGS(activation, tagList, activationTags);
		vpg->gad.GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		vpg->gad.GadgetRender = NULL;
		vpg->gad.SelectRender = NULL;
		vpg->gad.GadgetText = NULL;
		vpg->gad.MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		vpg->gad.SpecialInfo = NULL;
		vpg->gad.GadgetID = (VIEWPORT_GADGET << 8);
		vpg->gad.UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		vpg->scrollx = scrollx;
		vpg->scrolly = scrolly;
      vpg->members = members;

		if(scrollx)
			scrollx->GadgetID |= CHILD_GADGET << 8;
		if(scrolly)
			scrolly->GadgetID |= CHILD_GADGET << 8;

		gadSetViewportGadgetAttrs(&vpg->gad, NULL, NULL, tagList);

		if(prev)
			*prev = first;
		return(&vpg->gad);
	}

	if(scrollx)
		gadFreeScrollbarGadget(scrollx);
	if(scrolly)
		gadFreeScrollbarGadget(scrolly);
	if(lvg)
		FREEMEM(lvg, sizeof(struct ViewportGadget));
	return(NULL);
}

void gadFreeViewportGadget(struct Gadget *gad)
{
	struct ViewportGadget *lvg = (struct ViewportGadget *)gad;
	USHORT i;

	if(lvg)
	{
		for(i=0; lvg->bool[i]; i++)
			gadFreeListLabelGadget(lvg->bool[i]);
		if(lvg->buffer)
			FREEMEM(lvg->buffer, lvg->maxlen);
		gadFreeTextGadget(lvg->text);
		gadFreeScrollbarGadget(lvg->scrollbar);
		FREEMEM(lvg, sizeof(struct ViewportGadget));
	}
}


