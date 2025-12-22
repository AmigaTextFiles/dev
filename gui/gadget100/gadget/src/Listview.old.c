(UBYTE *)/*
** Listview.c
**	20.09.92 - 29.12.92
*/

#include "Gadget.pro"
#include "Gadget_stub.pro"
#include "Scrollbar.pro"
#include "Simple.pro"
#include "TextGadget.pro"
#include "Listview.pro"
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
**	Funktionen zu ListLabelGadget
**	20.09.92 - 29.12.92
*/

#define SetWrMask(rp, mask) (rp)->Mask = (mask)

static struct ListLabelGadget
{
	struct GadgetExtend gx;
	USHORT maxlen;
	BYTE *buffer;
};

/*
**	Non-Standard setattrs:
*/

STATIC void gadSetListLabelGadget(struct Gadget *gad, struct Window *w, struct Requester *req, BYTE *text)
{
	struct ListLabelGadget *llg = (struct ListLabelGadget *)gad;

	gad->GadgetText->IText = (UBYTE *)llg->buffer;
	sprintf(llg->buffer,	"%-*.*s", llg->maxlen, llg->maxlen, (text? text : ""));

	gad->Flags &= ~(GFLG_GADGHIGHBITS);
	gad->Flags |= text? GFLG_GADGHCOMP : GFLG_GADGHNONE;

	if(w)
	{
		UBYTE mask = w->RPort->Mask;

		SetWrMask(w->RPort, 1);				/* Speed up display */
		RefreshGList(gad, w, req, 1L);
		SetWrMask(w->RPort, mask);
	}
}

STATIC void gadFreeListLabelGadget(struct Gadget *gad)
{
	struct ListLabelGadget *llg = (struct ListLabelGadget *)gad;

	if(llg)
	{
		if(llg->buffer)
			FREEMEM(llg->buffer, llg->maxlen+1L);
		gadFreeIntuiText(llg->gx.gad.GadgetText);
      FREEMEM(llg, sizeof(struct ListLabelGadget));
	}
}

STATIC struct Gadget *gadAllocListLabelGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	SHORT x=10, y=10, width=100, height=20, ix, iy, maxlen;
	USHORT flags = GFLG_GADGHCOMP, activation = GACT_RELVERIFY;
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList);
	struct Gadget *gad;
	struct ListLabelGadget *llg = NULL;
	struct IntuiText *itext = NULL;
	BYTE *buffer = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	ix = 0;
	iy = (height+1-8)/2;
	maxlen = width/8;

	if((llg = ALLOCMEM(sizeof(struct ListLabelGadget))) &&
	(itext = gadAllocIntuiText(1, 0, JAM2, ix, iy, &TextAttr, text, NULL)) &&
	(buffer = ALLOCMEM(maxlen+1L)))
	{
		llg->gx.setattrs = NULL;
		llg->gx.getattr = NULL;
		llg->gx.free = gadFreeListLabelGadget;
		gad = &llg->gx.gad;
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
		gad->GadgetRender = NULL;
		gad->SelectRender = NULL;
		gad->GadgetText = itext;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = 0;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		llg->maxlen = maxlen;
		llg->buffer = buffer;

		return(gad);
	}
	if(buffer)
		FREEMEM(buffer, maxlen+1L);
	if(itext)
		gadFreeIntuiText(itext);
   if(llg)
		FREEMEM(llg, sizeof(struct ListLabelGadget));
	return(NULL);
}
STATIC struct Gadget *gadAllocListLabelGadget(ULONG tag1, ...)
{
	return(gadAllocListLabelGadgetA((struct TagItem *)&tag1));
}

/*
**	Funktionen zu ListviewGadget
**	09.09.92 - 09.09.92
*/

#define MAXLABELS 100

struct ListviewGadget
{
	struct ComposedGadget compg;
	struct Gadget *scrollbar, *text, *bool[MAXLABELS+1], *string;
	struct gadListviewInfo lvgi;
};

STATIC ULONG NodesinList(struct List *list)
{
	struct Node *node;
	ULONG anz=0;

	for(node = list->lh_Head; node->ln_Succ; node = node->ln_Succ)
		anz++;
	return(anz);
}

STATIC void setlistlabelgadgets(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   struct ListviewGadget *lvg = (struct ListviewGadget *)gad;
	struct gadListviewInfo *lvgi = &lvg->lvgi;
	register struct Node *n = NULL;
   ULONG i, maxtop;
	BYTE *text;

	if(gad && GADGET_TYPE(gad) == LISTVIEW_GADGET)
	{
		maxtop = (lvgi->total>lvgi->visible)? lvgi->total-lvgi->visible : 0L;
      lvgi->top = MIN(lvgi->top, maxtop);
		if(lvgi->list)
			for(i=0, n=lvgi->list->lh_Head; i<lvgi->top; i++)
				n=n->ln_Succ;
		for(i=0; i<lvgi->visible; i++)
   	{
			text = (n && n->ln_Succ)? n->ln_Name : NULL;
         gadSetListLabelGadget(lvg->bool[i], w, req, text);
			if(n)
				n = n->ln_Succ;
		}
	}
}

STATIC void gadListScrollbarGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class, struct IntuiMessage *message)
{
   struct Gadget *gad = (struct Gadget *)callgad->UserData;
	struct ListviewGadget *lvg = (struct ListviewGadget *)gad;

	if(lvg->lvgi.top != pgi->top)
	{
		lvg->lvgi.top = pgi->top;
		setlistlabelgadgets(gad, w, req);
	}
}

STATIC void setselected(struct Gadget *gad, struct Window *w, struct Requester *req)
{
   struct ListviewGadget *lvg = (struct ListviewGadget *)gad;
	struct gadListviewInfo *lvgi = &lvg->lvgi;
	register struct Node *n = NULL;
	BYTE *text = "";
   ULONG i;

	if(gad && GADGET_TYPE(gad) == LISTVIEW_GADGET)
	{
      if(lvgi->total==0)
			lvgi->selected = ~0;
   	if(lvgi->selected!=~0 && lvgi->list)
		{
			lvgi->selected = MIN(lvgi->selected, lvgi->total-1);
			for(i=0, n=lvgi->list->lh_Head; i<lvgi->selected; i++)
				n=n->ln_Succ;
			text = n->ln_Name;
		}
     	if(lvg->string)
			gadSetGadgetAttrs(lvg->string, w, req,
									GADSTR_TextVal, text,
									TAG_DONE);
		else if(lvg->text)
			gadSetGadgetAttrs(lvg->text, w, req, GA_Text, text,
															 TAG_DONE);
   }
}

STATIC void gadListLabelGadgetCallBack(struct Gadget *callgad, struct Window *w, struct Requester *req, struct gadScrollerInfo *pgi, ULONG class, struct IntuiMessage *message)
{
   struct Gadget *gad = (struct Gadget *)callgad->UserData;
	struct ListviewGadget *lvg = (struct ListviewGadget *)gad;
	ULONG num = (ULONG)callgad->SelectRender,
			selected = num + lvg->lvgi.top;

	if(selected < lvg->lvgi.total)
  	{
		lvg->lvgi.selected = selected;
		setselected(gad, w, req);
		gadDoCallBack(gad, w, req, (APTR)&lvg->lvgi, class, message);
	}
}

STATIC ULONG gadSetListviewGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
   struct ListviewGadget *lvg = (struct ListviewGadget *)gad;
	struct gadListviewInfo *lvgi = &lvg->lvgi;
	struct TagItem *tag, *workList = tagList;
	BOOL refresh = FALSE;

	if(gad && GADGET_TYPE(gad) == LISTVIEW_GADGET)
	{
		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
         	case GADLV_Top: 	lvgi->top = tag->ti_Data;
										refresh = TRUE;
										break;
				case GADLV_Labels:	lvgi->list = (struct List *)tag->ti_Data;
										lvgi->total = NodesinList(lvgi->list);
										lvgi->selected = ~0;
										refresh = TRUE;
                              break;
            case GADLV_Selected:	lvgi->selected = tag->ti_Data;
											refresh = TRUE;
											break;
			}
		}
		if(refresh)
		{
         setlistlabelgadgets(gad, w, req);
			gadSetGadgetAttrs(lvg->scrollbar, w, req,
									GADSC_Top, lvgi->top,
									GADSC_Visible, lvgi->visible,
									GADSC_Total, lvgi->total,
                           TAG_DONE);
			setselected(gad, w, req);
			refresh = FALSE;
		}
	}
	return(refresh);
}

STATIC ULONG gadGetListviewGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
   ULONG ret = FALSE;
	struct ListviewGadget *lvg = (struct ListviewGadget *)gad;
	struct gadListviewInfo *lvgi = &lvg->lvgi;

	if(gad && GADGET_TYPE(gad) == LISTVIEW_GADGET && storage)
	{
		switch(tag)
		{
     		case GADLV_Top: 	*storage = lvgi->top;
                           ret = TRUE;
                           break;
			case GADLV_Labels:	*storage = (ULONG)lvgi->list;
                           ret = TRUE;
                           break;
         case GADLV_Selected:	*storage = lvgi->selected;
	                           ret = TRUE;
   	                        break;
		}
	}
	return(ret);
}

STATIC void gadFreeListviewGadget(struct Gadget *gad)
{
	struct ListviewGadget *lvg = (struct ListviewGadget *)gad;

	if(lvg)
	{
		gadFreeImage(gad->GadgetRender);
		FREEMEM(lvg, sizeof(struct ListviewGadget));
	}
}

struct Gadget *gadAllocListviewGadgetA(struct TagItem *tagList)
{
	ULONG ro = GETTAGDATA(GADLV_ReadOnly, TRUE, tagList); /* not yet supported */
	struct Gadget *show = (struct Gadget *)GETTAGDATA(GADLV_ShowSelected, 0L, tagList);
	struct TagItem *showtag = FINDTAGITEM(GADLV_ShowSelected, tagList);
	SHORT	x=10, y=10,	width = 100, height = 100,	bx, by, bw, bh;
	USHORT flags = 0, i, anz=0, maxlen,
			activation = PACKBOOLTAGS(0, tagList, activationTags);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList);
	struct Gadget *first = NULL;
	struct ListviewGadget *lvg = NULL;
	struct Gadget *scrollbar = NULL, *text=NULL, *border=NULL, *gad;
	struct Image *image = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	maxlen = (width-8-18)/8;
	bw = maxlen*8; bh = 8;
	bx = x + (width-18-bw)/2; by = y + (height - ((height-4)/bh)*bh)/2;

	if((lvg = ALLOCMEM(sizeof(struct ListviewGadget))) &&
	(image = gadAllocImage(0, 0, width-18, height, 2, 3, 0, NULL)) &&
   (scrollbar = gad = gadAllocScrollbarGadget(GA_Immediate, 1L,
												GA_RelVerify, 1L,
                                    GA_Previous, &first,
												GA_Left, x+width-18,
												GA_Top, y,
                                    GA_Height, height,
												GA_Width, 18,
												GAD_CallBack, gadListScrollbarGadgetCallBack,
                                    GA_UserData, lvg,
												TAG_MORE, tagList)) &&
	(!showtag || show ||	(text = gad = gadAllocTextGadget(
												GA_Left, x,
												GA_Top, y+height,
												GA_Width, width,
												GA_Height, 14L,
												GA_Previous, &gad->NextGadget,
												TAG_MORE, tagList))))
	{
		for(anz=0; by+bh<y+height && anz<MAXLABELS; anz++, by+=bh)
		{
			if(!(lvg->bool[anz] = gad = gadAllocListLabelGadget(GA_Left, bx,
                                   	GA_Top, by,
												GA_Width, bw,
												GA_Height, bh,
												GAD_CallBack, gadListLabelGadgetCallBack,
												GA_UserData, lvg,
                                    GA_Previous, &gad->NextGadget,
												TAG_MORE, tagList)))
				goto listviewexit;
			lvg->bool[anz]->GadgetID |= CHILD_GADGET<<8;
			lvg->bool[anz]->SelectRender = (void *)anz;
      }
		lvg->compg.num = anz+2;
		lvg->compg.gx.setattrs = gadSetListviewGadgetAttrs;
		lvg->compg.gx.getattr = gadGetListviewGadgetAttr;
		lvg->compg.gx.free = gadFreeListviewGadget;
		gad = gad->NextGadget = &lvg->compg.gx.gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = x;
		gad->TopEdge = y;
		gad->Width = width;
		gad->Height = height;
		gad->Flags = flags | GFLG_GADGHNONE | GFLG_GADGIMAGE;
		gad->Activation = activation & ~(GACT_IMMEDIATE | GACT_RELVERIFY);
		gad->GadgetType = PACKBOOLTAGS(GTYP_BOOLGADGET, tagList, typeTags);
		gad->GadgetRender = image;
		gad->SelectRender = NULL;
		gad->GadgetText = NULL;
		gad->MutualExclude = GETTAGDATA(GAD_CallBack, 0L, tagList);
		gad->SpecialInfo = NULL;
		gad->GadgetID = (LISTVIEW_GADGET << 8);
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		gadMakeButtonImage(image, 0);
		lvg->scrollbar = scrollbar;
		lvg->string = show;
		lvg->text = text;

		scrollbar->GadgetID |= CHILD_GADGET << 8;
		border->GadgetID |= CHILD_GADGET << 8;
		if(text)
			text->GadgetID |= CHILD_GADGET << 8;

		lvg->lvgi.total = 0;
		lvg->lvgi.visible = anz;
		lvg->lvgi.top = 0;
		lvg->lvgi.selected = ~0;
		lvg->lvgi.list = NULL;

		gadSetListviewGadgetAttrs(gad, NULL, NULL, tagList);

		if(prev)
			*prev = first;
		return(gad);
	}

listviewexit:

	if(lvg)
		for(i=0; i<anz; i++)
			gadFreeGadget(lvg->bool[i]);
	gadFreeGadget(text);
	gadFreeGadget(scrollbar);
	gadFreeImage(image);
	if(lvg)
		FREEMEM(lvg, sizeof(struct ListviewGadget));
	return(NULL);
}
struct Gadget *gadAllocListviewGadget(ULONG tag1, ...)
{
	return(gadAllocListviewGadgetA((struct TagItem *)&tag1));
}

