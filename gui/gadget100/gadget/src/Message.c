/*
**	Message.c:	Message-Behandlung
**	14.09.92 - 13.04.93
*/

#include "Gadget.pro"
#include "StringGadget.pro"
#include "Message.pro"
#include <pragma/console_lib.h>
#include <intuition/intuitionbase.h>

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#else
#ifdef STATIC
#undef STATIC
#endif
#define STATIC
#endif

#define INITTICK 3

extern struct IntuitionBase *IntuitionBase;
extern struct InputEvent inputevent;

static struct Gadget *moveGadget = NULL, *tickGadget = NULL;
static USHORT tickcount;

/*
**	gadDoCallBack:	Aufruf eines CallBacks eines Gadgets
**	14.09.92 - 14.09.92
*/

void gadDoCallBack(struct Gadget *gad, struct Window *w, struct Requester *req, APTR special, ULONG code, struct IntuiMessage *message)
{
   if(gad->MutualExclude && !(gad->Flags & GFLG_DISABLED))
   	((void (*)(struct Gadget *, struct Window *, struct Requester *, APTR, ULONG, struct IntuiMessage *))
		(gad->MutualExclude))(gad, w, req, special, code, message);
}

/*
**	Hilfsfunktionen:
**	19.09.92 - 19.09.92
*/

STATIC void settickgadget(struct Gadget *gad)
{
	if((gad->GadgetType & GTYP_GTYPEMASK) == BOOLGADGET &&
	!(gad->Activation & GACT_TOGGLESELECT) &&
	(gad->Activation & GACT_IMMEDIATE) &&
	(gad->Flags & SELECTED))
	{
		tickcount = INITTICK;
		tickGadget = gad;
	}
	else
		tickGadget = NULL;
}

STATIC BOOL FindWindow(struct Window *w)
{
   struct Screen *screen;
   struct Window *window;

   for(screen = IntuitionBase->FirstScreen; screen; screen = screen->NextScreen)
      for(window = screen->FirstWindow; window; window = window->NextWindow)
         if(window == w)
            return(TRUE);

   return(FALSE);
}

STATIC BOOL FindGadget(struct Window *w, struct Gadget *find)
{
	register struct Gadget *gad;

	if(w && find)
		for(gad = w->FirstGadget; gad; gad = gad->NextGadget)
			if(gad == find)
				return(TRUE);
	return(FALSE);
}

STATIC BOOL removeRepeatMessages(struct IntuiMessage *message)
{
	struct MsgPort *msgport = message->IDCMPWindow->UserPort;
   struct IntuiMessage *im1, *im2;
	BOOL ret = FALSE, ok;

   for(im1=(struct IntuiMessage *)msgport->mp_MsgList.lh_Head;
	(im2 = (struct IntuiMessage *)im1->ExecMessage.mn_Node.ln_Succ) &&
	im2->ExecMessage.mn_Node.ln_Succ != NULL;	im1 = im2)
   {
   	if(im1->Class != message->Class || im2->Class !=message->Class)
      	break;
		switch(message->Class)
		{
			case GADGETUP:
			case GADGETDOWN:	ok = (im1->IAddress == message->IAddress);
                           break;
			case RAWKEY:		ok = ((im1->Qualifier & IEQUALIFIER_REPEAT)!=0);
									break;
			default:				ok = TRUE;
									break;
		}
		if(!ok)
			break;
      if(!(im1 = (struct IntuiMessage *)GetMsg(msgport)))
         break;
      ReplyMsg((struct Message *)im1);
		ret = TRUE;
   }
	return(ret);
}

/*
**	SoftActivateGadget:  Simuliert Gadgetclick
** 06.09.92 - 30.03.93
*/

STATIC BOOL SoftActivateGadget(struct Window *w, LONG code, LONG qualifier, LONG key, struct IntuiMessage *message)
{
	struct Gadget *gad;
 	BOOL down = !(code & IECODE_UP_PREFIX);
	BOOL repeat = (qualifier & IEQUALIFIER_REPEAT) != 0;
	BOOL selected;

	for(gad = w->FirstGadget; gad; gad = gad->NextGadget)
		if(!(gad->GadgetType & SYSGADGET) &&
		!(gad->Flags & GFLG_DISABLED) &&
		TOUPPER((UBYTE)gad->GadgetID) == TOUPPER(key))
		{
			switch(gad->GadgetType & GTYP_GTYPEMASK)
			{
				case BOOLGADGET:

					if(repeat)
						return(TRUE);
					selected = (gad->Flags & SELECTED) != 0;
					if(!(gad->Activation & GACT_TOGGLESELECT))	/* Bool Gadget */
					{
						if(!down && !selected)		/* Gadget war nicht aktiviert */
							return(FALSE);
						gadSetSelectedFlag(gad, w, NULL, down);
					}
					else if(down)
						gadSetSelectedFlag(gad, w, NULL, !selected);
               if(down && (gad->Activation & GACT_IMMEDIATE))
						gadDoCallBack(gad, w, NULL, NULL, GADGETDOWN, message);
  		         if(!down && (gad->Activation & GACT_RELVERIFY))
						gadDoCallBack(gad, w, NULL, NULL, GADGETUP, message);
					settickgadget(gad);
					return(TRUE);
					break;

				case STRGADGET:	ActivateGadget(gad, w, NULL);
										return(TRUE);
										break;
			}
		}
	return(FALSE);
}

STATIC BOOL gadGadgetUpDownMessage(struct IntuiMessage *message)
{
	struct Gadget *gad = (struct Gadget *)message->IAddress;

	if((gad->GadgetType & GTYP_GTYPEMASK) == PROPGADGET &&
	gad->SpecialInfo &&
	(((struct PropInfo *)gad->SpecialInfo)->Flags & KNOBHIT))
		moveGadget = gad;
	else
		moveGadget = NULL;
	settickgadget(gad);

	removeRepeatMessages(message);
	gadDoCallBack(gad, message->IDCMPWindow, NULL, NULL, message->Class, message);

	return(TRUE);
}

STATIC BOOL gadMouseMoveMessage(struct IntuiMessage *message)
{
	struct Gadget *gad = moveGadget;
	struct Window *w = message->IDCMPWindow;

	removeRepeatMessages(message);
	if(gad && FindGadget(w, gad) && (gad->Flags & GFLG_SELECTED))
   /*
   ** Do NOT count on the value of
   ** ((struct PropInfo *)gad->SpecialInfo)->Flags & KNOBHIT
   ** it does not work!
   */
		gadDoCallBack(gad, w, NULL, NULL, message->Class, message);
	else
		moveGadget = NULL;

	return(moveGadget != NULL);
}

STATIC BOOL gadRawKeyMessage(struct IntuiMessage *message, ULONG amigakeys)
{
	static BYTE rawconvertbuf[21];
	LONG l;
	BYTE key;
	BOOL ret = FALSE;

	removeRepeatMessages(message);
   inputevent.ie_Code = (message->Code & (~(IECODE_UP_PREFIX)));
   inputevent.ie_Qualifier = message->Qualifier;
	if((l = RawKeyConvert(&inputevent, (UBYTE *)rawconvertbuf, 20L, NULL))>0)
	{
  		rawconvertbuf[l]=0;
		key = rawconvertbuf[0];
		if(!amigakeys || (message->Qualifier & COMMAND) || key == ESC)
			ret = SoftActivateGadget(message->IDCMPWindow,
					message->Code, message->Qualifier, key, message);
	}
	return(ret);
}

STATIC BOOL gadIntuiTicksMessage(struct IntuiMessage *message)
{
	struct Gadget *gad = tickGadget;
	struct Window *w=message->IDCMPWindow;

	removeRepeatMessages(message);
	if(!tickcount)
	{
		if(gad && FindGadget(w, gad) && (gad->Flags & GFLG_SELECTED))
			gadDoCallBack(gad, w, NULL, NULL, message->Class, message);
		else
			tickGadget = NULL;
	}
	if(tickcount > 0)
		tickcount--;
	return(tickGadget != NULL);
}

STATIC void gadCheckActivate(struct IntuiMessage *message)
{
   struct Window *w = NULL;
	struct Gadget *gad;

	if(message->Class == GADGETUP &&
      FindWindow(message->IDCMPWindow) &&
	   (gad = (struct Gadget *)message->IAddress) &&
      FindGadget(message->IDCMPWindow, gad) &&
	   ((gad->GadgetType & GTYP_GTYPEMASK) != STRGADGET))
   		w = message->IDCMPWindow;
	else if(message->Class == ACTIVEWINDOW &&
      FindWindow(message->IAddress))
   		w = (struct Window *)message->IAddress;
	else if(message->Class == RAWKEY &&
      (message->Code & IECODE_UP_PREFIX) &&
      FindWindow(message->IDCMPWindow))
   		w = message->IDCMPWindow;
	else if(message->Class == MOUSEBUTTONS &&
      FindWindow(message->IDCMPWindow))
   		w = message->IDCMPWindow;

	if(w)
		ActivateFirstStringGadget(w, NULL);
}

BOOL gadFilterMessage(struct IntuiMessage *message, ULONG amigakeys)
{
	BOOL ret = FALSE;

	switch(message->Class)
	{
		case IDCMP_GADGETUP:
		case IDCMP_GADGETDOWN:	ret = gadGadgetUpDownMessage(message);
										break;

		case IDCMP_MOUSEMOVE:	ret = gadMouseMoveMessage(message);
                              break;

		case IDCMP_RAWKEY:		ret = gadRawKeyMessage(message, amigakeys);
										break;

		case IDCMP_INTUITICKS:	ret = gadIntuiTicksMessage(message);
										break;
	}
   gadCheckActivate(message);
	return(ret);
}

