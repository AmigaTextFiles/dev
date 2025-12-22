/*
 *	File:					MoreReq.c
 *	Description:	Amiga RequesterS
 *
 *	(C) 1994,1995, Ketil Hunn
 *
 */

#ifndef	MOREREQ_C
#define	MOREREQ_C

#define	MR_LIB	1

/*** PRIVATE INCLUDES ****************************************************************/
#include <libraries/gadtools.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <utility/utility.h>
#include <utility/tagitem.h>
#include <intuition/imageclass.h>
#include <intuition/intuitionbase.h>

#include <clib/graphics_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/utility_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/graphics_pragmas.h>

#include <stdlib.h>
#include <clib/macros.h>
#include "myinclude:BitMacros.h"
#include "myinclude:myString.h"


/*** DEFINES *************************************************************************/
#define SHIFTPRESSED(msg)	((msg->Qualifier & IEQUALIFIER_LSHIFT) | (msg->Qualifier & IEQUALIFIER_RSHIFT))
#define ALTPRESSED(msg)		((msg->Qualifier & IEQUALIFIER_LALT) | (msg->Qualifier & IEQUALIFIER_RALT))
#define CTRLPRESSED(msg)	(msg->Qualifier & IEQUALIFIER_CONTROL)

#define	W(g)								(g->Width)
#define	H(g)								(g->Height)
#define	X1(g)								(g->LeftEdge)
#define	X2(g)								(X1(g)+W(g))
#define	Y1(g)								(g->TopEdge)
#define	Y2(g)								(Y1(g)+H(g))

#define	MR_Underscorechar		'_'
#define	MR_Underscorestring	"_"

/*** GLOBALS *************************************************************************/
struct IntuitionBase *IntuitionBase;
struct Library	*GadToolsBase,
								*GfxBase,
								*DOSBase,
								*UtilityBase;

struct MR_VarWORDArray
{
	WORD val[0];
};

typedef struct MR_VarWORDArray		varWORD;


/*** PROTOTYPES **********************************************************************/
__asm void mrSpreadGadgets(	register __a0 WORD *posarray,
														register __a1 WORD *sizearray,
														register __d0 WORD x1,
														register __d1 WORD x2,
														register __d2 ULONG count,
														register __d3 BOOL space);
__asm void mrGetTags(	register __d0 unsigned long reqType,
											register __a1 APTR req,
											register __a0 struct TagItem *taglist);
__asm WORD mrTextWidth(	register __a0 struct RastPort *rp,
												register __a1 char *text);
__asm __saveds WORD mrMaxLenA(register __a1 struct RastPort *rp,
															register __a0 char **array);
__asm void mrInitialPercent(register __a0 APTR inreq);
__asm void mrInitialCentre(register __a0 APTR inreq);
__asm void mrCloseRequester(register __a0 APTR inreq);
__asm void mrParseGadgetString(	register __a0 APTR req,
																register __a1 UBYTE *string);
__asm BOOL mrHandleButtonKey(	register __a0 struct Window *window,
															register __a1 struct Gadget *gadget);
__asm ULONG mrCallHook(	register __a0 APTR req,
												register __a1 struct IntuiMessage *msg);


/*** PRIVATE INCLUDES ****************************************************************/
#include "Version.h"
#include "/include/MoreReq.h"
#include "/proto/MoreReq_protos.h"
#include "SleepPointer.h"
#include "CloseWindowSafely.h"
#include "ListviewRequester.h"


/*** FUNCTIONS ***********************************************************************/
int __saveds __UserLibInit(void)
{
	if(IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", 37L))
		if(UtilityBase=OpenLibrary("utility.library", 37L))
			if(GadToolsBase=OpenLibrary("gadtools.library", 37L))
				if(GfxBase=OpenLibrary("graphics.library", 37L))
					if(DOSBase=OpenLibrary("dos.library", 37L))
						return 0;

	if(DOSBase)
		CloseLibrary(DOSBase);
	if(GfxBase)
		CloseLibrary(GfxBase);
	if(GadToolsBase)
		CloseLibrary(GadToolsBase);
	if(UtilityBase)
		CloseLibrary(UtilityBase);
	if(IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
	return 1;
}

void __saveds __UserLibCleanup(void)
{
	CloseLibrary(DOSBase);
	CloseLibrary(GfxBase);
	CloseLibrary(GadToolsBase);
	CloseLibrary(UtilityBase);
	CloseLibrary((struct Library *)IntuitionBase);
}

/* ********************************************************************************* */

__asm void mrSetReqFont(register __a0 APTR inreq,
												register __a1 struct TextAttr *textattr)
{
	struct ListviewRequester *req=(struct ListviewRequester *)inreq;

#ifdef MYDEBUG_H
	DebugOut("mrSetReqFont");
#endif

	if(textattr==NULL & req->screen!=NULL)
		req->textattr=req->screen->Font;
	else
		req->textattr=textattr;

	if(req->font)
		CloseFont(req->font);
	req->font=OpenFont(req->textattr);

	InitBitMap(&req->bm, 1, 1, 1);
	InitRastPort(&req->rp);
	req->rp.BitMap=&req->bm;

	if(req->font)
		SetFont(&req->rp, req->font);
}

__asm __saveds APTR mrAllocRequestA(register __d0 unsigned long reqType,
																		register __a0 struct TagItem *taglist)
{
	register struct ListviewRequester		*req=NULL;

#ifdef MYDEBUG_H
	DebugOut("AllocRequestA");
#endif

	switch(reqType)
	{
		case MR_ListviewRequest:
			req=(struct ListviewRequester *)AllocVec(sizeof(struct ListviewRequester), MEMF_CLEAR|MEMF_PUBLIC);
			mrGetTags(MR_ListviewRequest, req, taglist);
			break;
	}

	if(req!=NULL)
	{
		if(req->screen==NULL & req->pwindow!=NULL)
			req->screen=req->pwindow->WScreen;

		if(req->screen==NULL)
		{
			struct Screen *wbscreen;

			if(wbscreen=LockPubScreen(NULL))
			{
				req->screen=wbscreen;
				UnlockPubScreen(NULL, wbscreen);
			}
		}

		if(req->font==NULL)
			mrSetReqFont(req, NULL);

		if(req->titletext==NULL)
			req->titletext=StrDup(MR_DefTitleText);

		req->type=reqType;

		switch(reqType)
		{
			case MR_ListviewRequest:
				{
//					register struct ListviewRequester	*lvreq=(struct ListviewRequester *)req;
//					lvreq->IntuitionBase=(struct IntuitionBase *)OpenLibrary("intuition.library", 37L);
					return (struct ListviewRequester *)req;
				}
				break;
		}	
	}

	return NULL;
}

__asm __saveds void mrFreeRequest(register __a0 APTR req)
{
#ifdef MYDEBUG_H
	DebugOut("FreeRequest");
#endif

	if(req)
	{
		struct ListviewRequester	*tmpreq=(struct ListviewRequester *)req;
		register ULONG i;

		Free(tmpreq->titletext);

		for(i=0; i<tmpreq->numgads; i++)
			Free(tmpreq->gadgettexts->text[i]);
		FreeVec(tmpreq->gadgettexts);

		CloseFont(tmpreq->font);
/*
		switch(tmpreq->type)
		{
			case MR_ListviewRequest:
//				CloseLibrary((struct Library *)((struct ListviewRequester *)tmpreq)->IntuitionBase);
				break;
		}
*/
		FreeVec(tmpreq);
	}
}

/* ********************************************************************************** */

__asm void mrGetTags(	register __d0 unsigned long reqType,
											register __a1 APTR req,
											register __a0 struct TagItem *taglist)
{
	struct ListviewRequester	*lvreq=(struct ListviewRequester *)req;
	struct TagItem *tstate;
	struct TagItem *tag;

#ifdef MYDEBUG_H
	DebugOut("mrGetTags");
#endif

		tstate=taglist;
		while(tag=NextTagItem(&tstate))
			switch(tag->ti_Tag)
			{
				case MR_Window:
					lvreq->pwindow=(struct Window *)tag->ti_Data;
					if(lvreq->pwindow)
						lvreq->screen	=lvreq->pwindow->WScreen;
					break;
				case MR_Screen:
					lvreq->screen=(struct Screen *)tag->ti_Data;
					break;
				case MR_InitialLeftEdge:
					lvreq->LeftEdge	=(WORD)tag->ti_Data;
					break;
				case MR_InitialTopEdge:
					lvreq->TopEdge	=(WORD)tag->ti_Data;
					break;
				case MR_InitialWidth:
					lvreq->Width	=(WORD)tag->ti_Data;
					break;
				case MR_InitialHeight:
					lvreq->Height	=(WORD)tag->ti_Data;
					break;
				case MR_InitialPercentV:
					lvreq->percentv	=(BOOL)tag->ti_Data;
					break;
				case MR_InitialPercentH:
					lvreq->percenth	=(BOOL)tag->ti_Data;
					break;
				case MR_InitialCentreH:
					lvreq->centreh=	(BOOL)tag->ti_Data;
					break;
				case MR_InitialCentreV:
					lvreq->centrev=	(BOOL)tag->ti_Data;
					break;
				case MR_TitleText:
					if(lvreq->titletext)
						Free(lvreq->titletext);
					lvreq->titletext=StrDup((UBYTE *)tag->ti_Data);
					break;
				case MR_CloseGadget:
					lvreq->closegadget=	(BOOL)tag->ti_Data;
					break;
				case MR_SizeGadget:
					lvreq->sizegadget=	(BOOL)tag->ti_Data;
					break;
				case MR_TextAttr:
					mrSetReqFont(lvreq, (struct TextAttr *)tag->ti_Data);
					break;
				case MR_SameGadgetWidth:
					lvreq->samegadgetwidth=	(BOOL)tag->ti_Data;
					break;
				case MR_SimpleRefresh:
					lvreq->simplerefresh=	(BOOL)tag->ti_Data;
					break;
				case MR_Gadgets:
					if(lvreq->numgads)
					{
						register ULONG i;

						for(i=0; i<lvreq->numgads; i++)
							Free(lvreq->gadgettexts->text[i]);
						FreeVec(lvreq->gadgettexts);
						lvreq->numgads=0;
					}
					mrParseGadgetString(lvreq, (UBYTE *)tag->ti_Data);
					break;
				case MR_SleepWindow:
					lvreq->sleepwindow=	(BOOL)tag->ti_Data;
					break;
				case MR_PrivateIDCMP:
					lvreq->privateidcmp=	(BOOL)tag->ti_Data;
					break;
				case MR_IntuiMsgFunc:
					lvreq->func=(void *)tag->ti_Data;
					break;
				case MR_UserData:
					lvreq->mr_UserData	=(APTR)tag->ti_Data;
					break;
			}

		switch(lvreq->type)
		{
			case MR_ListviewRequest:
				tstate=taglist;
				while(tag=NextTagItem(&tstate))
					switch(tag->ti_Tag)
					{
						case MRLV_Labels:
							lvreq->list	=(struct List *)tag->ti_Data;
							break;
						case MRLV_Selected:
							lvreq->selectednum	=(LONG)tag->ti_Data;
							break;
						case MRLV_ReadOnly:
							lvreq->readonly=	(BOOL)tag->ti_Data;
							break;
						case MRLV_DropDown:
							lvreq->dropdown=	(BOOL)tag->ti_Data;
							break;
					}
				break;
		}
}

__asm WORD mrTextWidth(	register __a0 struct RastPort *rp,
												register __a1 char *text)
{
	register WORD length=TextLength(rp, text, StrLen(text));
	register UBYTE *c;

#ifdef MYDEBUG_H
	DebugOut("mrTextWidth");
#endif

	c=text;
	while(*c!='\0')
		if(*c++==MR_Underscorechar)
		{
			length-=TextLength(rp, MR_Underscorestring, 1);
			break;
		}
	return length;
}

__asm __saveds WORD mrMaxLenA(register __a1 struct RastPort *rp,
															register __a0 char **array)
{
	register WORD	maxlen=0;
	register int	i=0;
	register char	*c;

#ifdef MYDEBUG_H
	DebugOut("mrMaxLen");
#endif

	while(c=array[i++])
	{
		register WORD textwidth=mrTextWidth(rp, c);
		maxlen=MAX(maxlen, textwidth);
	}

	return maxlen;
}

LONG mrMaxLen(struct RastPort *rp, char *text1, ...)
{
	return mrMaxLenA(rp, &text1);
}

__asm void mrParseGadgetString(	register __a0 APTR req,
																register __a1 UBYTE *string)
{
	register struct ListviewRequester	*lvreq=(struct ListviewRequester *)req;
	register UBYTE *text, *t, *c;
	register ULONG numgads;

#ifdef MYDEBUG_H
	DebugOut("mrParseGadgetString");
#endif

	if(string!=NULL)
	{
		numgads=1L;

		if(text=t=StrDup(string))
		{
			while(*t!='\0')
			{
				if(*t=='|')
					numgads++;
				t++;
			}
			lvreq->numgads=numgads;

			if(lvreq->gadgettexts=AllocVec(sizeof(varCHAR)+sizeof(UBYTE *)*(numgads+1), MEMF_CLEAR))
			{
				register ULONG i=0;
				t=text;
				while(*t!='\0')
				{
					c=t;
					while(*t!='|' & *t!='\0')
						t++;

					if(*t!='\0')
						*t++='\0';

					lvreq->gadgettexts->text[i++]=StrDup(c);
				}
			}
			Free(text);
		}
	}
	else
		lvreq->numgads=0;
}

__asm void mrSpreadGadgets(	register __a0 WORD *posarray,
														register __a1 WORD *sizearray,
														register __d0 WORD x1,
														register __d1 WORD x2,
														register __d2 ULONG count,
														register __d3 BOOL space)
{
	register	WORD	totalsize=0, width=x2-x1, gadspace=0;
	register	ULONG last=count-1, i;

#ifdef MYDEBUG_H
	DebugOut("mrSpreadGadgets");
#endif

	if(count==1)
		posarray[0]=x1+((x2-x1)/2-sizearray[0]/2);
	else
	{
		for(i=0; i<count; i++)
			totalsize+=sizearray[i];
		if(space==TRUE)
			gadspace=(width-totalsize)/(count-1);

		posarray[0]=x1;

		if(count>2)
			for(i=1; i<last; i++)
				posarray[i]=posarray[i-1]+sizearray[i-1]+gadspace;

		posarray[last]=x2-sizearray[last];
	}
}

__asm void mrCloseRequester(register __a0 APTR inreq)
{
	register struct ListviewRequester *req=(struct ListviewRequester *)inreq;
	register struct Window	*win=req->window;

#ifdef MYDEBUG_H
	DebugOut("mrCloseRequester");
#endif
//	RemoveGList(win, req->glist, -1);

	req->LeftEdge	=win->LeftEdge;
	req->TopEdge	=win->TopEdge;
	req->Width		=win->Width-win->BorderLeft-win->BorderRight;
	req->Height		=win->Height-win->BorderTop-win->BorderBottom;

	mrCloseWindowSafely(win);
	FreeGadgets(req->glist);
	req->window=NULL;
}

__asm __saveds UWORD mrRequestA(register __a1 APTR req,
																register __a0 struct TagItem *taglist)
{
	struct ListviewRequester *lvreq=(struct ListviewRequester *)req;
	UWORD retvalue=0;

#ifdef MYDEBUG_H
	DebugOut("mrRequestA");
#endif

	lvreq->visualinfo=GetVisualInfo(lvreq->screen, TAG_END);

	switch(lvreq->type)
	{
		case MR_ListviewRequest:
			retvalue=mrLVRequestA(lvreq, taglist);
			break;
	}

	FreeVisualInfo(lvreq->visualinfo);
	return retvalue;
}

__asm void mrInitialPercent(register __a0 APTR inreq)
{
	register struct ListviewRequester	*req=(struct ListviewRequester *)inreq;

#ifdef MYDEBUG_H
	DebugOut("mrInitialPercent");
#endif

	if(req->percenth)
		req->Width	=req->screen->Width/100*req->percenth;
	if(req->percentv)
		req->Height	=req->screen->Height/100*req->percentv;

	req->percentv=req->percenth=0;
}

__asm void mrInitialCentre(register __a0 APTR inreq)
{
	register struct ListviewRequester	*req=(struct ListviewRequester *)inreq;

#ifdef MYDEBUG_H
	DebugOut("mrInitialCentre");
#endif

	if(req->centreh)
		req->LeftEdge	=req->screen->Width/2-req->Width/2;
	if(req->centrev)
		req->TopEdge	=req->screen->Height/2-req->Height/2;

	req->centrev=req->centreh=FALSE;
}

__asm int mrFindVanillaKey(register __a0 char *text)
{
	register UBYTE *c;

#ifdef MYDEBUG_H
	DebugOut("mrFindVanillaKey");
#endif

	if(c=StrChr(text, MR_Underscorechar))
			return(ToUpper(*(c+1)));

	return 1;
}

__asm __saveds UWORD mrMatchVanillaKeyA(register __d0 int inkey,
																				register __a0 char **array)
{
	register UWORD i=1;
	register int	key=ToUpper(inkey);

#ifdef MYDEBUG_H
	DebugOut("mrMatchVanillaKey");
#endif

	while(array[i-1]!=NULL)
	{
		if(key==mrFindVanillaKey(array[i-1]))
			return i;
		++i;
	}
	return 0;
}

__asm BOOL mrHandleButtonKey(	register __a0 struct Window *window,
															register __a1 struct Gadget *gadget)
{
	if(gadget)
	{
		UWORD gadpos=RemoveGadget(window, gadget);

		SETBIT(gadget->Flags, GFLG_SELECTED);
		AddGadget(window, gadget, gadpos);
		RefreshGList(gadget, window, NULL, 1);

		Delay(5L);
		return TRUE;
	}
	return FALSE;
}

__asm ULONG mrHookEntry(register __a0 struct Hook *hook,
												register __a2 VOID *o,
												register __a1 VOID *msg)
{
#ifdef MYDEBUG_H
	DebugOut("mr_HookEntry");
#endif
	return ((*(ULONG (*)(struct Hook *,VOID *,VOID *))(hook->h_SubEntry))(hook, o, msg));
}

__asm VOID mrInitHook(register __a0 struct Hook *h,
											register __a2 ULONG (*func)(),
											register __a1 VOID *data)
{
#ifdef MYDEBUG_H
	DebugOut("mrInitHook");
#endif
	if(h)
	{
		h->h_Entry		=(ULONG (*)()) mrHookEntry;
		h->h_SubEntry	=func;
		h->h_Data			=data;
	}
}

__asm ULONG mrCallHook(	register __a0 APTR req,
												register __a1 struct IntuiMessage *msg)
{
	struct Hook	hook;
	ULONG retvalue=1;

#ifdef MYDEBUG_H
	DebugOut("mrCallHook");
#endif

	if(((struct ListviewRequester *)req)->func)
	{
		mrInitHook(&hook, ((struct ListviewRequester *)req)->func, msg);
		retvalue=CallHookPkt(&hook, NULL, NULL);
	}
	return retvalue;
}

#endif

