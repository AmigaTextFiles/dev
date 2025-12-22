
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVISUAL *TCreateVisual(TAPTR task, TTAGITEM *tags)
**
**	create visual object.
**
**	tags
**		TTask_MMU, user mmu
**
*/


static TINT destroyvisual(TVISUAL *visual);
static TBOOL initvisualtask(TAPTR task);
static TVOID visualtask(TAPTR task);

TVISUAL *TCreateVisual(TAPTR task, TTAGITEM *tags)
{
	if (task)
	{
		TAPTR mmu = TGetTagValue(TTask_MMU, &((TTASK *) task)->heapmmu, tags);
		TVISUAL *visual = TMMUAllocHandle(mmu, (TDESTROYFUNC) destroyvisual, sizeof(TVISUAL));
		if (visual)
		{
			visual->asyncport = TCreatePort(task, TNULL);
			visual->iport = TCreatePort(task, TNULL);
			
			visual->prefwidth = (TINT) TGetTagValue(TVisual_PixWidth, (TTAG) -1, tags);
			visual->prefheight = (TINT) TGetTagValue(TVisual_PixHeight, (TTAG) -1, tags);
			visual->preftitle = (TSTRPTR) TGetTagValue(TVisual_Title, (TTAG) TNULL, tags);

			if (visual->asyncport && visual->iport)
			{
				TINT i;
				TAPTR msg;
				TBOOL success = TTRUE;
				
				for (i = 0; i < TVISUAL_NUMDRMSG && success; ++i)
				{
					msg = TTaskAllocMsg(task, sizeof(TDRAWMSG));
					if (msg)
					{
						TAddTail(&visual->asyncport->msglist, (TNODE *)(((TMSG *) msg) - 1));
					}
					else
					{
						success = TFALSE;
						break;
					}
				}

				if (success)
				{
					if (kn_initlock(&visual->lock))
					{
						TTAGITEM tasktags[3];
						tasktags[0].tag = TTask_UserData;
						tasktags[0].value = (TTAG) visual;
						tasktags[1].tag = TTask_InitFunc;
						tasktags[1].value = (TTAG) initvisualtask;
						tasktags[2].tag = TTAG_DONE;
						
						visual->task = TCreateTask(task, (TTASKFUNC) visualtask, tasktags);
						if (visual->task)
						{
							visual->parenttask = task;
							visual->refcount = 0;
							visual->main = TTRUE;
							return visual;
						}
						
						kn_destroylock(&visual->lock);
					}
				}
				
				while ((msg = TRemHead(&visual->asyncport->msglist)))
				{
					TFreeMsg(((TMSG *) msg) + 1);
				}
			}
			
			TDestroy(visual->iport);
			TDestroy(visual->asyncport);
			TMMUFreeHandle(visual);
		}
	}

	return TNULL;
}



static TBOOL initvisualtask(TAPTR task)
{
	TVISUAL *visual = TTaskGetData(task);

	visual->ireplyport = TCreatePort(task, TNULL);
	if (visual->ireplyport)
	{
		TINT i;
		TAPTR msg;
		TBOOL success = TTRUE;

		for (i = 0; i < TVISUAL_NUMIMSG && success; ++i)
		{
			msg = TTaskAllocMsg(task, sizeof(TIMSG));
			if (msg)
			{
				TAddTail(&visual->ireplyport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			}
			else
			{
				success = TFALSE;
				break;
			}
		}

		if (success)
		{		
			visual->knvisual = kn_createvisual(&((TTASK *) task)->heapmmu, visual->preftitle, visual->prefwidth, visual->prefheight);	
			if (visual->knvisual)
			{
				return TTRUE;
			}
		}

		TDestroy(visual->ireplyport);
	}
	
	return TFALSE;
}



static TVOID visualtask(TAPTR task)
{
	TUINT signals = 0;
	TBOOL visualevent = TFALSE;
	TVISUAL *visual = TTaskGetData(task);
	TPORT *drawport = TTaskPort(task);
	TPORT *ireplyport = visual->ireplyport;
	TMSG *rawmsg;
	TDRAWMSG *drawmsg;
	TINT numprocessed;

	TUINT eventmask = TITYPE_VISUAL_CLOSE;			/* initial event mask */

	kn_setinputmask(visual->knvisual, eventmask);


	do
	{
		visualevent = kn_waitvisual(visual->knvisual, &((TTASK *) task)->timer, &((TTASK *) task)->sigevent);
		signals = TSetSignal(task, 0, drawport->signal | TTASK_SIG_ABORT);
		if (visualevent) dbvprintf(1,"TEKLIB visualtask: event\n");

		/* 
		**	generate input messages
		*/

		if (visualevent)
		{
			kn_lock(&ireplyport->lock);
			
			for (;;)
			{
				rawmsg = (TMSG *) TRemHead(&ireplyport->msglist);
				if (rawmsg)
				{
					if (kn_getnextinput(visual->knvisual, (TIMSG *) (rawmsg + 1), eventmask))
					{
						TPutReplyMsg(visual->iport, ireplyport, rawmsg + 1);
						continue;
					}
					else
					{
						TAddHead(&ireplyport->msglist, (TNODE *) rawmsg);
					}
				}
				break;
			}
	
			kn_unlock(&ireplyport->lock);
		}


		/* 
		**	process draw messages
		*/

		if (signals & drawport->signal)
		{
			numprocessed = 0;
	
			while ((drawmsg = TGetMsg(drawport)))
			{
				switch (drawmsg->jobcode)
				{
					case TVJOB_ALLOCPEN:
						drawmsg->op.rgbpen.pen = kn_allocpen(visual->knvisual, drawmsg->op.rgbpen.rgb);
						TReplyMsg(drawmsg);
						break;
	
					case TVJOB_FREEPEN:
						kn_freepen(visual->knvisual, drawmsg->op.pen.pen);
						TAckMsg(drawmsg);
						break;
	
					case TVJOB_RECT:
						kn_setfgpen(visual->knvisual, drawmsg->op.colrect.pen);
						kn_rect(visual->knvisual, 
							drawmsg->op.colrect.x, drawmsg->op.colrect.y,
							drawmsg->op.colrect.w, drawmsg->op.colrect.h);
						TAckMsg(drawmsg);
						break;
	
					case TVJOB_FRECT:
						kn_setfgpen(visual->knvisual, drawmsg->op.colrect.pen);
						kn_frect(visual->knvisual, 
							drawmsg->op.colrect.x, drawmsg->op.colrect.y,
							drawmsg->op.colrect.w, drawmsg->op.colrect.h);
						TAckMsg(drawmsg);
						break;
	
					case TVJOB_LINE:
						kn_setfgpen(visual->knvisual, drawmsg->op.colrect.pen);
						kn_line(visual->knvisual,
							drawmsg->op.colrect.x, drawmsg->op.colrect.y,
							drawmsg->op.colrect.w, drawmsg->op.colrect.h);
						TAckMsg(drawmsg);
						break;
	
					case TVJOB_PLOT:
						kn_setfgpen(visual->knvisual, drawmsg->op.plot.pen);
						kn_plot(visual->knvisual, drawmsg->op.plot.x, drawmsg->op.plot.y);
						TAckMsg(drawmsg);
						break;
	
					case TVJOB_CLEAR:
					{
						struct knvisual_parameters param;
						kn_getparameters(visual->knvisual, &param);
						kn_setfgpen(visual->knvisual, drawmsg->op.pen.pen);
						kn_frect(visual->knvisual, 0,0, param.pixelwidth, param.pixelheight);
						TAckMsg(drawmsg);
						break;
					}

					case TVJOB_LINEARRAY:
					{
						TINT i, x1, y1, x2, y2, *p;
						kn_setfgpen(visual->knvisual, drawmsg->op.array.pen);
						p = drawmsg->op.array.array;
						x1 = *p++;
						y1 = *p++;
						for (i = 1; i < drawmsg->op.array.num; ++i)
						{
							x2 = *p++;
							y2 = *p++;
							kn_line(visual->knvisual, x1, y1, x2, y2);
							x1 = x2;
							y1 = y2;
						}
						TAckMsg(drawmsg);
						break;
					}
	
					case TVJOB_SCROLL:
						kn_scroll(visual->knvisual, 
							drawmsg->op.scroll.x, drawmsg->op.scroll.y,
							drawmsg->op.scroll.w, drawmsg->op.scroll.h,
							drawmsg->op.scroll.dx, drawmsg->op.scroll.dy);
						TAckMsg(drawmsg);
						break;
	
					case TVJOB_TEXT:
						kn_setfgpen(visual->knvisual, drawmsg->op.text.fgpen);
						kn_setbgpen(visual->knvisual, drawmsg->op.text.bgpen);
						kn_drawtext(visual->knvisual, drawmsg->op.text.x, drawmsg->op.text.y,
							drawmsg->op.text.text, drawmsg->op.text.len);
						TAckMsg(drawmsg);
						break;

					case TVJOB_FLUSHAREA:
						kn_flush(visual->knvisual, 
							drawmsg->op.rect.x, drawmsg->op.rect.y,
							drawmsg->op.rect.w, drawmsg->op.rect.h);
						TAckMsg(drawmsg);
						break;
					
					case TVJOB_FLUSH:
						kn_flush(visual->knvisual, -1, -1, -1, -1);
						TAckMsg(drawmsg);
						break;

					case TVJOB_SYNC:
						TAckMsg(drawmsg);		/* synchronization only */
						break;

					case TVJOB_SETINPUT:
						drawmsg->op.input.oldmask = eventmask;
						eventmask &= ~drawmsg->op.input.clearmask;
						eventmask |= drawmsg->op.input.setmask;
						if (eventmask != drawmsg->op.input.oldmask)
						{
							kn_setinputmask(visual->knvisual, eventmask);
						}
						TReplyMsg(drawmsg);
						break;
	
					case TVJOB_DRAWRGB:
						kn_drawrgb(visual->knvisual, 
							drawmsg->op.rgb.rgbbuf,
							drawmsg->op.rgb.x,
							drawmsg->op.rgb.y,
							drawmsg->op.rgb.w,
							drawmsg->op.rgb.h,
							drawmsg->op.rgb.totw);
						TAckMsg(drawmsg);
						break;

					case TVJOB_GETATTRS:
					{
						struct knvisual_parameters p;
						kn_getparameters(visual->knvisual, &p);
						drawmsg->op.attrs.pixwidth = p.pixelwidth;
						drawmsg->op.attrs.pixheight = p.pixelheight;
						drawmsg->op.attrs.textwidth = p.textwidth;
						drawmsg->op.attrs.textheight = p.textheight;
						drawmsg->op.attrs.fontwidth = p.fontwidth;
						drawmsg->op.attrs.fontheight = p.fontheight;
						TReplyMsg(drawmsg);
						break;
					}
	
					default:
						tdbprintf(20, "TEKLIB visualtask: unknown drawmsg\n");
						TAckMsg(drawmsg);
				}
	
				numprocessed++;
				if (numprocessed >= TVISUAL_NUMDRMSG)
				{
					break;					/* give input events a chance */
				}
			}
		}

	
	} while (!(signals & TTASK_SIG_ABORT));


	{
		/* not really required - task allocations will be freed automatically */
	
		TAPTR msg;
		TUINT numfreed = 0;
		while ((msg = TRemHead(&visual->ireplyport->msglist)))
		{
			TFreeMsg(((TMSG *) msg) + 1);
			numfreed++;
		}
		tdbprintf1(2, "TEKLIB visualtask: freed %d imessages\n", numfreed);
	}


	kn_destroyvisual(visual->knvisual);
	TDestroy(visual->ireplyport);
}




static TINT destroyvisual(TVISUAL *visual)
{
	TAPTR msg;
	TBOOL done = TFALSE;
	TTIME delay = {0,5000};
	
	for (;;)
	{
		kn_lock(&visual->lock);
		done = (visual->refcount == 0);
		kn_unlock(&visual->lock);
		if (done)
		{
			break;
		}
		TTimeDelay(visual->parenttask, &delay);
	}
	
	
	kn_destroylock(&visual->lock);
	

	TSignal(visual->task, TTASK_SIG_ABORT);
	TDestroy(visual->task);

	while ((msg = TRemHead(&visual->asyncport->msglist)))
	{
		TFreeMsg(((TMSG *) msg) + 1);
	}

	TDestroy(visual->iport);
	/*TDestroy(visual->syncport);*/
	TDestroy(visual->asyncport);

	TMMUFreeHandle(visual);
	
	return 0;
}
