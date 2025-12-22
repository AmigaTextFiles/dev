/*
**	StringGadget.c:	String und Integer-Gadgets
**	13.09.92 - 29.12.92
*/

#include <limits.h>

#include "Gadget.pro"
#include "Element.pro"
#include "StringGadget.pro"
#include "Utility.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "gadget_lib.h"
#else
#ifdef STATIC
#undef STATIC
#endif
#define STATIC
#endif

extern struct TagItem flagsTags[], activationTags[], typeTags[];
extern struct TextFont *topaz8Font;

struct StringGadget
{
	struct GadgetExtend gx;
	struct StringInfo si;
	struct Border bo1, bo2, bo3;
	SHORT data1[10][2], data2[5][2], data3[5][2];
	LONG min, max;				/* for LONGINT Gadgets  */
	void (*callback)(struct Gadget *, struct Window *, struct Requester *, APTR, ULONG);
	BOOL endgadget;
};

extern ULONG hookEntry();

STATIC ULONG EditFunc(struct Hook *hook, struct SGWork *SGWork, ULONG *cmd)
{
	if(*cmd == SGH_KEY)
	{
		struct StringGadget *sg = (struct StringGadget *)SGWork->Gadget;
		struct StringInfo *si = SGWork->StringInfo;
		SHORT code = SGWork->IEvent->ie_Code;
		SHORT qualifier = SGWork->IEvent->ie_Qualifier;

		switch(SGWork->EditOp)
		{
/*			case EO_NOOP:
			case EO_MOVECURSOR:

				if(code == CODE_ARROWUP || code == CODE_ARROWDOWN ||
				(code == CODE_ARROWLEFT && si->BufferPos == 0) ||
				(code == CODE_ARROWRIGHT && si->BufferPos == si->NumChars))
				{
					SGWork->Code = code;
					SGWork->Actions &= ~(SGA_USE | SGA_BEEP);
					SGWork->Actions |= SGA_END;
					return(1L);
				}
				break;	*/

			case EO_NOOP:
			case EO_ENTER:
			case EO_REPLACECHAR:
			case EO_INSERTCHAR:
			case EO_BADFORMAT:

				if((SGWork->Code && (SGWork->Code == ESC || (qualifier & COMMAND))) ||
				(SGWork->EditOp == EO_ENTER && (sg->endgadget || (qualifier & COMMAND))))
				{
					SGWork->Code = 'x';			/* Dummy */
					SGWork->Actions &= ~(SGA_USE | SGA_BEEP);
					SGWork->Actions |= SGA_END | SGA_REUSE;
					return(1L);
				}
/*   			else if((sg->gx.gad.Activation & GACT_LONGINT) &&
				(SGWork->LongInt < sg->min || SGWork->LongInt > sg->max))
				{
					SGWork->Actions &= ~(SGA_USE);
					SGWork->Actions |= SGA_BEEP;
					return(1L);
				} */
				break;
		}
	}
	return(0L);
}

static struct Hook EditHook=
{
	NULL, NULL,
	hookEntry,
	EditFunc,
	NULL,
};

static BYTE UndoBuffer[1000 + 1];
static BYTE WorkBuffer[1000 + 1];

static struct StringExtend StringExtend=
{
	NULL,       /* Textfont */
	1, 0,    	/* pens */
	1, 0,			/* active pens */
	0L,			/* Intial Modes */
	&EditHook,
	(UBYTE *)WorkBuffer,
   0L, 0L, 0L, 0L,   /* reserved */
};


/*
** Funktionen zu StringGadgets:
**	05.09.92 - 29.12.92
*/

void NextStringGadget(struct Gadget *gad, struct Window *w, struct Requester *req)
{
	if(w)
	{
		for(gad = gad? gad->NextGadget : w->FirstGadget;
		gad; gad=gad->NextGadget)
   		if((gad->GadgetType & GTYP_GTYPEMASK) == STRGADGET &&
			!(gad->Flags & GFLG_DISABLED))
			{
				ActivateGadget(gad, w, req);
				return;
			}
	}
}

void ActivateFirstStringGadget(struct Window *w, struct Requester *req)
{
	NextStringGadget(NULL, w, req);
}

STATIC void gadStringGadgetCallBack(struct Gadget *gad, struct Window *w,
struct Requester *req, APTR special, ULONG class, struct IntuiMessage *message)
{
   struct StringGadget *sg = (struct StringGadget *)gad;

	if(!message->Code && !sg->endgadget)
		NextStringGadget(gad, w, req);

	if(sg->callback)
		sg->callback(gad, w, req, special, class);
}

STATIC ULONG gadSetStringGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
   struct StringGadget *sg = (struct StringGadget *)gad;
	struct StringInfo *si;
	struct TagItem *tag, *workList = tagList;
	BOOL refresh = FALSE;
	BYTE buffer[21];

	if(gad && (gad->GadgetType & GTYP_GTYPEMASK) == STRGADGET &&
   (si = (struct StringInfo *)gad->SpecialInfo))
	{
		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
				case	GADSTR_TextVal:	if(si->MaxChars >= 1 && tag->ti_Data)
                                    {
													strncpy((BYTE *)si->Buffer, (BYTE *)tag->ti_Data, si->MaxChars-1);
													si->Buffer[si->MaxChars-1] = 0;
												}
												refresh = TRUE;
                                    break;
				case	GADSTR_LongVal:  sprintf(buffer, "%ld", tag->ti_Data);
												if(strlen(buffer) < si->MaxChars)
												{
                                    	strcpy((BYTE *)si->Buffer, buffer);
													si->LongInt = tag->ti_Data;
												}
												refresh = TRUE;
                                    break;
				case	GADSTR_BufferPos:	si->BufferPos = tag->ti_Data;
													refresh = TRUE;
													break;
				case	GADSTR_DispPos:		si->DispPos = tag->ti_Data;
													refresh = TRUE;
													break;
				case GADSTR_EndGadget:	sg->endgadget = (tag->ti_Data != 0);
                                    break;
      	}
		}
	}
	return(refresh);
}

STATIC ULONG gadGetStringGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
   ULONG ret = FALSE;
   struct StringInfo *si;
	struct StringGadget *sg = (struct StringGadget *)gad;

	if(gad && (gad->GadgetType & GTYP_GTYPEMASK) == STRGADGET &&
	storage && (si = (struct StringInfo *)gad->SpecialInfo))
	{
		switch(tag)
		{
			case GADSTR_DispPos:	*storage = si->DispPos;
											ret = TRUE;
											break;
			case GADSTR_BufferPos:	*storage = si->BufferPos;
												ret = TRUE;
												break;
			case GADSTR_LongVal:	*storage = si->LongInt;
											ret = TRUE;
											break;
			case GADSTR_TextVal:	*storage = (ULONG)si->Buffer;
											ret = TRUE;
											break;
			case GADSTR_MaxChars:	*storage = si->MaxChars;
											ret = TRUE;
											break;
    		case GADSTR_DispCount:	*storage = si->DispCount;
											ret = TRUE;
											break;
		}
	}
	return(ret);
}

STATIC void gadFreeStringGadget(struct Gadget *gad)
{
	struct StringInfo *si;

	if(gad)
	{
		si = (struct StringInfo *)gad->SpecialInfo;
		if(si && si->Buffer)
			FREEMEM(si->Buffer, si->MaxChars);
		gadFreeNewIntuiText(gad->GadgetText);
		FREEMEM(gad, sizeof(struct StringGadget));
	}
}

struct Gadget *gadAllocStringGadgetA(struct TagItem *tagList)
{
	BYTE *text = (BYTE *)GETTAGDATA(GA_Text, 0L, tagList);
	SHORT len = NEWSTRLEN(text)+1,
			maxchars = GETTAGDATA(GADSTR_MaxChars, SG_DEFAULTMAXCHARS, tagList),
			maxlen = MAX(MIN(1000, maxchars), 2),
			w, h = 14, x=10, y=10, width=(1+maxlen+1)*8, height=h,
			shortcut = GETTAGDATA(GAD_ShortCut, 0, tagList),
			dy, dx, gx, gy, ix, iy;
	USHORT flags = GFLG_TABCYCLE,
			 activation = GACT_RELVERIFY,
			 justification = GETTAGDATA(GADSTR_Justification, GACT_STRINGCENTER, tagList);
	struct Gadget **prev = (struct Gadget **)GETTAGDATA(GA_Previous, 0L, tagList),
						*gad;
	struct StringGadget *sg = NULL;
	BYTE *buffer = NULL;
	struct IntuiText *itext = NULL;

	getxywhf(&x, &y, &width, &height, &flags, tagList);
	dy = (height-h)/2, dx = 0,
	gx = x+6, gy = y + dy + 3,
	ix = -6 -len*8, iy = y + (height+1-8)/2 - gy;
	w = width;

   if((sg = ALLOCMEM(sizeof(struct StringGadget))) &&
	(buffer = ALLOCMEM(maxlen)) &&
	(!text || (itext = gadAllocNewIntuiText(text, ix, iy, 1, &shortcut))))
	{
		sg->gx.setattrs = gadSetStringGadgetAttrs;
		sg->gx.getattr = gadGetStringGadgetAttr;
		sg->gx.free = gadFreeStringGadget;
		gad = &sg->gx.gad;
      if(prev)
			*prev = gad;
		gad->NextGadget = NULL;
		gad->LeftEdge = gx;
		gad->TopEdge = gy;
		gad->Width = w-12;
		gad->Height = h - 6;
		gad->Flags = flags | GFLG_STRINGEXTEND;
		gad->Activation = justification |
									PACKBOOLTAGS(activation, tagList, activationTags);
		gad->GadgetType = PACKBOOLTAGS(GTYP_STRGADGET, tagList, typeTags);
		gad->GadgetRender = &sg->bo1;
		gad->SelectRender = NULL;
		gad->GadgetText = itext;
		gad->MutualExclude = (ULONG)gadStringGadgetCallBack;
		gad->SpecialInfo = (APTR)&sg->si;
		gad->GadgetID = (STRING_GADGET << 8) | (UBYTE)shortcut;
		gad->UserData = (APTR)GETTAGDATA(GA_UserData, 0L, tagList);
		sg->callback = (void *)GETTAGDATA(GAD_CallBack, 0L, tagList);
		sg->endgadget = FALSE;

		buffer[0] = 0;
		sg->si.Buffer = (UBYTE *)buffer;
      sg->si.UndoBuffer = (UBYTE *)UndoBuffer;
		sg->si.BufferPos = 0;
      sg->si.MaxChars = maxlen;
		sg->si.DispPos = 0;
		sg->si.Extension = &StringExtend;
		sg->si.LongInt = 0L;
		sg->si.AltKeyMap = NULL;
		StringExtend.Font = topaz8Font;

		sg->bo1.LeftEdge = -6;
		sg->bo1.TopEdge = -3;
		sg->bo1.FrontPen = 2;
		sg->bo1.BackPen = 0;
		sg->bo1.DrawMode = JAM2;
		sg->bo1.Count = 10;
		sg->bo1.XY = (WORD *)sg->data1;
		sg->bo1.NextBorder = &sg->bo2;
		sg->data1[0][0] = 0; sg->data1[0][1] = 0;
		sg->data1[1][0] = 0; sg->data1[1][1] = h-3;
		sg->data1[2][0] = 1; sg->data1[2][1] = h-3;
		sg->data1[3][0] = 1; sg->data1[3][1] = 0;
		sg->data1[4][0] = w-4; sg->data1[4][1] = 0;
		sg->data1[5][0] = w-4; sg->data1[5][1] = h-3;
		sg->data1[6][0] = w-3; sg->data1[6][1] = h-3;
		sg->data1[7][0] = w-3; sg->data1[7][1] = 0;
		sg->data1[8][0] = w-3; sg->data1[8][1] = h-2;
		sg->data1[9][0] = 0; sg->data1[9][1] = h-2;

		sg->bo2.LeftEdge = -6;
		sg->bo2.TopEdge = -3;
		sg->bo2.FrontPen = 1;
		sg->bo2.BackPen = 0;
		sg->bo2.DrawMode = JAM2;
		sg->bo2.Count = 5;
		sg->bo2.XY = (WORD *)sg->data2;
		sg->bo2.NextBorder = &sg->bo3;
      sg->data2[0][0] = 2;	sg->data2[0][1] = 1;
      sg->data2[1][0] = 2;	sg->data2[1][1] = h-3;
      sg->data2[2][0] = 3;	sg->data2[2][1] = h-3;
      sg->data2[3][0] = 3;	sg->data2[3][1] = 1;
      sg->data2[4][0] = w-5;	sg->data2[4][1] = 1;

		sg->bo3.LeftEdge = -6;
		sg->bo3.TopEdge = -3;
		sg->bo3.FrontPen = 1;
		sg->bo3.BackPen = 0;
		sg->bo3.DrawMode = JAM2;
		sg->bo3.Count = 5;
		sg->bo3.XY = (WORD *)sg->data3;
		sg->bo3.NextBorder = NULL;
      sg->data3[0][0] = 2;	sg->data3[0][1] = h-1;
      sg->data3[1][0] = w-2;	sg->data3[1][1] = h-1;
      sg->data3[2][0] = w-2;	sg->data3[2][1] = 1;
      sg->data3[3][0] = w-1;	sg->data3[3][1] = 1;
      sg->data3[4][0] = w-1;	sg->data3[4][1] = h-1;

		gadSetStringGadgetAttrs(&sg->gx.gad, NULL, NULL, tagList);
		return(gad);
	}
	if(itext)
		gadFreeNewIntuiText(itext);
	if(buffer)
		FREEMEM(buffer, maxlen + 1L);
	if(sg)
		FREEMEM(sg, sizeof(struct StringGadget));
	return(NULL);
}
struct Gadget *gadAllocStringGadget(ULONG tag1, ...)
{
	return(gadAllocStringGadgetA((struct TagItem *)&tag1));
}


/*
**	Funktionen zu IntGadget
**	05.09.92 - 25.09.92
*/

struct Gadget *gadAllocIntGadgetA(struct TagItem *tagList)
{
	struct Gadget *gad;
	BYTE buffer[21];
   LONG l1, l2, len;
	LONG 	min = GETTAGDATA(GADSTR_Min, LONG_MIN, tagList),
         max = GETTAGDATA(GADSTR_Max, LONG_MAX, tagList);

	sprintf(buffer, "%ld", min);
	l1 = strlen(buffer);
	sprintf(buffer, "%ld", max);
	l2 = strlen(buffer);
	len = MAX(l1, l2) + 1;
	len = GETTAGDATA(GADSTR_MaxChars, len, tagList);

	if(gad = gadAllocStringGadget(GADSTR_MaxChars, (LONG)len,
											TAG_MORE, tagList))
	{
   	gad->Activation |= GACT_LONGINT;
      gad->GadgetID = (INT_GADGET << 8) | (UBYTE)gad->GadgetID;
		((struct StringGadget *)gad)->min = min;
		((struct StringGadget *)gad)->max = max;
	}
	return(gad);
}
struct Gadget *gadAllocIntGadget(ULONG tag1, ...)
{
	return(gadAllocIntGadgetA((struct TagItem *)&tag1));
}

