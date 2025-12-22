
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT numattrs = TVGetAttrs(TAPTR visual, TTAGITEM *tags)
**
**	get visual attributes
*/

TUINT TVGetAttrs(TAPTR visual, TTAGITEM *tags)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			TAPTR attp;
			TUINT numatt = 0;
			
			msg->jobcode = TVJOB_GETATTRS;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

	
			if ((attp = TGetTagValue(TVisual_PixWidth, TNULL, tags)))
			{
				*((TINT *) attp) = msg->op.attrs.pixwidth;
				numatt++;
			}
			if ((attp = TGetTagValue(TVisual_PixHeight, TNULL, tags)))
			{
				*((TINT *) attp) = msg->op.attrs.pixheight;
				numatt++;
			}
			if ((attp = TGetTagValue(TVisual_FontWidth, TNULL, tags)))
			{
				*((TINT *) attp) = msg->op.attrs.fontwidth;
				numatt++;
			}
			if ((attp = TGetTagValue(TVisual_FontHeight, TNULL, tags)))
			{
				*((TINT *) attp) = msg->op.attrs.fontheight;
				numatt++;
			}
			if ((attp = TGetTagValue(TVisual_TextWidth, TNULL, tags)))
			{
				*((TINT *) attp) = msg->op.attrs.textwidth;
				numatt++;
			}
			if ((attp = TGetTagValue(TVisual_TextHeight, TNULL, tags)))
			{
				*((TINT *) attp) = msg->op.attrs.textheight;
				numatt++;
			}

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			kn_unlock(&v->asyncport->lock);

			return numatt;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
