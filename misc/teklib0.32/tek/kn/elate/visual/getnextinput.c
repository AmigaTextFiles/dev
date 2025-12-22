
#include "tek/visual.h"
#include "tek/kn/visual.h"
#include "tek/kn/elate/visual.h"

#include <elate/taort.h>
#include <elate/elate.h>
#include <elate/ave.h>

#include <stdio.h>

/* 
**	TEKlib
**	(C) 1999-2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_getnextinput(TAPTR v, TIMSG *newimsg, TUINT eventmask)
**
*/

#define	EV_DIALOG_RESIZE	8196
#define	EV_QUIT				9

#define	EV_TRACKING			3
#define	EV_BUTTONUP			4
#define	EV_BUTTONDOWN		5


TBOOL kn_getnextinput(TAPTR vis, TIMSG *newimsg, TUINT eventmask)
{
	TINT ev;
	TINT x,y;
	TUINT keycooked, buttonstate;
	TBOOL resize = TFALSE;
	TBOOL newevent;
	
	struct visual_elate *v = (struct visual_elate *) vis;
	
	newimsg->type = TITYPE_NONE;


	if (v->evtpending)
	{
		ev = v->pendingevent;
		x = v->pendingx;
		y = v->pendingy;
		keycooked = v->pendingkeycooked;
		resize = v->pendingresize;
		buttonstate = v->pendingbuttonstate;
		newevent = TTRUE;
		v->evtpending = TFALSE;
	}
	else
	{
		newevent = getevent(vis, &ev, &x, &y, &keycooked, &resize, &buttonstate);
	}
		
	
	if (newevent)
	{

		if (resize)
		{
			newimsg->type = TITYPE_VISUAL_NEWSIZE;
			goto skip;
		}
		
		switch (ev)
		{
			case EV_QUIT:
				newimsg->type = TITYPE_VISUAL_CLOSE;
				break;
	
			case EV_TRACKING:
				newimsg->type = TITYPE_MOUSEMOVE;
				newimsg->mousex = x;
				newimsg->mousey = y;
				break;
	
			case EV_BUTTONUP:
				if (buttonstate == 1)
				{
					newimsg->code = TMBCODE_LEFTUP;
				}
				else if (buttonstate == 2)
				{
					newimsg->code = TMBCODE_RIGHTUP;
				}
				else break;
				
				newimsg->type = TITYPE_MOUSEBUTTON;
				newimsg->mousex = x;
				newimsg->mousey = y;
				break;
	
			case EV_BUTTONDOWN:
				if (buttonstate == 1)
				{
					newimsg->code = TMBCODE_LEFTDOWN;
				}
				else if (buttonstate == 2)
				{
					newimsg->code = TMBCODE_RIGHTDOWN;
				}
				else break;
				
				newimsg->type = TITYPE_MOUSEBUTTON;
				newimsg->mousex = x;
				newimsg->mousey = y;
				break;
		
			case EV_KEYDOWN:
				switch (keycooked)
				{
					case 27:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_ESC;
						break;
	
					case 8:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_BCKSPC;
						break;
	
					case 9:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_TAB;
						break;
	
					case 13:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_ENTER;
						break;
	
					case 127:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_DEL;
						break;
	
					default:
						newimsg->type = TITYPE_KEY;
						newimsg->code = keycooked;
						break;
				}
				break;
		}
	}

skip:

	return (newimsg->type & eventmask);
}


