
/*
**	tek/examples/balls.c
**	networked balls demo
**
**	- use the right mouse button to create/destroy balls
**	(which are actually rectangles, but who cares :)
**
**	- start another client, preferrably on another machine,
**	and contact to either the left or right window border:
**
**	balls left <host-IP> <portnumber-right>    contacts the right window border
**	balls right <host-IP> <portnumber-left>    contacts the left window border
**
*/

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include <tek/debug.h>
#include <tek/visual.h>
#include <tek/sock.h>
#include <tek/array.h>

/******************************************************************** 
**	structs, constants
********************************************************************/

#define LEFT			-1
#define RIGHT			1

#define MSG_WELCOME		1
#define MSG_MIGRATE		2

#define MOUSEACCEL				3.5
#define MOUSEFRICTION			0.4

#define BALLUPDATEPERSECOND		50
#define WORLDUPDATEPERSECOND	50

#define BALLGRAV				0.002
#define BALLFRICTION			0.9985
#define BALLRADIUS				0.06

enum PENS {	PBLACK, PBLUE, PRED, PGREEN, PWHITE, PGREY, NUMPENS };

struct world
{
	THNDL handle;						/* object handle */
	TAPTR task;							/* world maintenance task */
	TVISUAL *visual;					/* visual object */
	TVPEN *pentab;						/* pentable */
	TLIST activeballs;					/* list of active balls */
	TLIST cachedballs;					/* list of cached balls */

	TLOCK lock;							/* child locking */
	TINT width, height;					/* world window width/height */

	TPORT *leftout, *rightout;			/* world portals to outside */

	TPORT *leftin, *rightin;			/* world portals to inside */
	TINT leftport, rightport;			/* world portals to inside - port numbers */
	
	TINT contact;						/* contact to left/right */
	TSTRPTR host;						/* contact to IP number */
	TUINT port;							/* contact port number */
};


/******************************************************************** 
**	ball
********************************************************************/

#define BALLSIG_WAKE			0x80000000
#define BALLSIG_SLEEP			0x40000000
#define BALLSIG_DRAW			0x20000000


struct ball
{
	THNDL handle;			/* object handle */
	struct world *world;	/* this ball's world */
	TVISUAL *parentvisual;	/* parent visual object being attached to */
	TVISUAL *visual;		/* client to the parent visual object */
	TVPEN backpen, pen;		/* background and ball pen */
	TAPTR task;				/* ball maintenance task */
	TLOCK lock;				/* lock for this entity */
	TFLOAT x,y;				/* position */
	TFLOAT vx,vy;			/* motion vector */
	TFLOAT gravity;			/* current gravity factor */
	TFLOAT radius;			/* ball's radius (fraction to visual) */
};

TINT destroyball(struct ball *b);
TBOOL ballinitfunc(TAPTR task);
TVOID ballfunc(TAPTR task);
TBOOL ballupdate(struct ball *b, TFLOAT f);

struct ball *createball(TAPTR parenttask, struct world *world, TVISUAL *visual, TVPEN backpen, TVPEN pen, TFLOAT x, TFLOAT y, TFLOAT vx, TFLOAT vy)
{
	struct ball *b = TTaskAllocHandle0(parenttask, destroyball, sizeof(struct ball));
	if (b)
	{
		TTAGITEM tasktags[3];

		tasktags[0].tag = TTask_InitFunc;
		tasktags[0].value = (TTAG) ballinitfunc;
		tasktags[1].tag = TTask_UserData;
		tasktags[1].value = (TTAG) b;
		tasktags[2].tag = TTAG_DONE;
		
		b->world = world;
		b->parentvisual = visual;
		b->backpen = backpen;
		b->pen = pen;
		b->x = x;
		b->y = y;
		b->vx = vx;
		b->vy = vy;
		b->gravity = BALLGRAV;
		b->radius = BALLRADIUS;

		b->task = TCreateTask(parenttask, ballfunc, tasktags);
		if (b->task)
		{
			return b;
		}

		TDestroy(b);
	}
	return TNULL;
}

TINT destroyball(struct ball *b)
{
	TSignal(b->task, TTASK_SIG_ABORT);
	TDestroy(b->task);
	TMMUFreeHandle(b);
	return 0;
}

TBOOL ballinitfunc(TAPTR task)
{
	struct ball *b = TTaskGetData(task);
	if (TAllocSignal(task, BALLSIG_WAKE | BALLSIG_SLEEP | BALLSIG_DRAW))
	{
		if (TInitLock(task, &b->lock, TNULL))
		{
			b->visual = TAttachVisual(task, b->parentvisual, TNULL);
			if (b->visual)
			{
				return TTRUE;
			}
			TDestroy(&b->lock);
		}
	}
	return TFALSE;
}


TVOID ballfunc(TAPTR task)
{
	struct ball *b = TTaskGetData(task);
	TUINT signals;
	TTIME delay, lasttime, now;
	TBOOL awake = TFALSE;
	TINT ox = -1, oy = 0, ow = 0, oh = 0;
	TFLOAT f = 1.0;

	TFTOTIME(1.0f/BALLUPDATEPERSECOND, &delay);

	TTimeQuery(task, &lasttime);

	do
	{
		signals = TTimedWait(task, 
			TTASK_SIG_ABORT | BALLSIG_WAKE | BALLSIG_SLEEP | BALLSIG_DRAW, &delay);

		TTimeQuery(task, &now);
		f = (TTIMETOF(&now) - TTIMETOF(&lasttime)) * BALLUPDATEPERSECOND;
		lasttime = now;

		if (signals & BALLSIG_WAKE)
		{
			awake = TTRUE;
		}

		if (signals & BALLSIG_SLEEP)
		{
			if (ox >= 0)
			{
				TVFRect(b->visual, ox, oy, ow, oh, b->backpen);
				TVSync(b->visual);
				ox = -1;
			}
			awake = TFALSE;
		}

		if (awake)
		{	
			if (signals & BALLSIG_DRAW)
			{
				TINT width = 600, height = 400;
				TINT nw, nh, nx, ny;
	
				TLock(&b->lock);
	
				nw = b->radius * 2 * width;
				nh = b->radius * 2 * height;
				nx = (b->x - b->radius) * width;
				ny = b->y * (height - nh);
	
				if (nx < 0)
				{
					nw += nx;
					nx = 0;
				}
				else if (nx + nw > width)
				{
					nw += width - (nx + nw);
				}
	
				if (ox >= 0)
				{
					TVFRect(b->visual, ox, oy, ow, oh, b->backpen);
					ox = -1;
				}
				if (b->y >= 0)
				{
					TVFRect(b->visual, nx, ny, nw, nh, b->pen);
					ox = nx; oy = ny; ow = nw; oh = nh;
				}

				TVSync(b->visual);
					
				TUnlock(&b->lock);
			}

			awake = ballupdate(b, f);
		}

	} while (!(signals & TTASK_SIG_ABORT));

	TDestroy(b->visual);
	TDestroy(&b->lock);
}


TBOOL ballmigrate(struct ball *b, TINT direction)
{
	TUINT *msg = TTaskAllocMsg(b->task, 32);
	if (msg)
	{
		TFLOAT newx = direction == LEFT ? b->x + 1.0f : b->x - 1.0f;

		*(msg + 0) = THTON32(MSG_MIGRATE);
		*(msg + 1) = (TUINT) b;
		*(msg + 2) = direction;
		*((TFLOAT *) (msg + 3)) = newx; *(msg + 3) = THTON32(*(msg + 3));
		*((TFLOAT *) (msg + 4)) = b->y; *(msg + 4) = THTON32(*(msg + 4));
		*((TFLOAT *) (msg + 5)) = b->vx; *(msg + 5) = THTON32(*(msg + 5));
		*((TFLOAT *) (msg + 6)) = b->vy; *(msg + 6) = THTON32(*(msg + 6));
		TPutReplyMsg(direction == LEFT ? b->world->leftout : b->world->rightout, TTaskPort(b->world->task), msg);
		TSignal(b->task, BALLSIG_SLEEP);
		return TTRUE;
	}
	return TFALSE;
}

TBOOL ballupdate(struct ball *b, TFLOAT f)
{
	TBOOL awake = TTRUE;
	
	TLock(&b->lock);

	b->x += b->vx * f;
	b->y += b->vy * f;

	if (b->y >= 1.0f)
	{
		b->y += 1.0f - b->y;
		b->vy = -b->vy;
	}
	

	TLock(&b->world->lock);
	
	if (b->x >= 1.0f)
	{
		if (b->world->rightout)
		{
			if (ballmigrate(b, RIGHT))
			{
				awake = TFALSE;
			}
		}
		else
		{
			b->x += 1.0f - b->x;
			b->vx = -b->vx;
		}
	}

	if (b->x < 0.0f)
	{
		if (b->world->leftout)
		{
			if (ballmigrate(b, LEFT))
			{
				awake = TFALSE;
			}
		}
		else
		{
			b->x -= b->x;
			b->vx = -b->vx;
		}
	}

	TUnlock(&b->world->lock);

	if (awake)
	{
		b->vx *= BALLFRICTION;
		b->vy *= BALLFRICTION;
		b->vy += b->gravity;
		if (TABS(b->vx) < 0.000001f) b->vx = 0.0;
		if (TABS(b->vy) < 0.000001f) b->vx = 0.0;
	}
	
	TUnlock(&b->lock);

	return awake;
}


/******************************************************************** 
**	world
********************************************************************/

TINT destroyworld(struct world *w);
TBOOL worldinitfunc(TAPTR task);
TVOID worldfunc(TAPTR task);
struct ball *newball(struct world *w, TINT mousex, TINT mousey);
TVOID setballpos(struct world *w, struct ball *b, TINT mousex, TINT mousey);
TVOID setballv(struct world *w, struct ball *b, TFLOAT mousevx, TFLOAT mousevy);
struct ball *pickball(struct world *w, TINT mousex, TINT mousey);
TVOID destroyballlist(struct world *w, TLIST *list);
TVOID sigballlist(struct world *w, TLIST *list, TUINT sig);
TBOOL handlenetmsg(struct world *w, TPORT *inport, TPORT **outport);
struct ball *newnetball(struct world *w, TFLOAT x, TFLOAT y, TFLOAT vx, TFLOAT vy);
TVOID handlenetreply(struct world *w);

struct world *createworld(TAPTR parenttask, TINT contact, TSTRPTR host, TUINT port)
{
	struct world *w = TTaskAllocHandle0(parenttask, destroyworld, sizeof(struct world));
	if (w)
	{
		TTAGITEM tasktags[3];

		tasktags[0].tag = TTask_InitFunc;
		tasktags[0].value = (TTAG) worldinitfunc;
		tasktags[1].tag = TTask_UserData;
		tasktags[1].value = (TTAG) w;
		tasktags[2].tag = TTAG_DONE;

		w->contact = contact;
		w->host = host;
		w->port = port;

		w->task = TCreateTask(parenttask, worldfunc, tasktags);
		if (w->task)
		{
			return w;
		}

		TDestroy(w);
	}
	return TNULL;
}

TINT destroyworld(struct world *w)
{
	TDestroy(w->task);
	TMMUFreeHandle(w);
	return 0;
}

TBOOL worldinitfunc(TAPTR task)
{
	struct world *w = TTaskGetData(task);
	
	w->leftin = TCreatePort(task, TNULL);
	w->rightin = TCreatePort(task, TNULL);
	if (w->leftin && w->rightin)
	{
		TTAGITEM tags[2];
		TTIME timeout;
		TFTOTIME(1000000, &timeout);
		TInitTags(tags);
		TAddTag(tags, TSock_IdleTimeout, (TTAG) &timeout);

		w->leftport = TAddSockPort(w->leftin, 0, tags);
		w->rightport = TAddSockPort(w->rightin, 0, tags);
		if (w->leftport && w->rightport)
		{
			TBOOL success = TTRUE;
			
			if (w->contact)
			{
				TPORT *contactport = TNULL;
				TUINT callbackport = 0;

				success = TFALSE;

				TFTOTIME(1.0f, &timeout);
				TInitTags(tags);
				TAddTag(tags, TSock_ReplyTimeout, (TTAG) &timeout);
		
				if (w->contact == LEFT)
				{
					contactport = w->leftout = TFindSockPort(task, w->host, w->port, tags);
					callbackport = w->leftport;
				}
				else if (w->contact == RIGHT)
				{
					contactport = w->rightout = TFindSockPort(task, w->host, w->port, tags);
					callbackport = w->rightport;
				}

				if (contactport)
				{
					TBYTE *welcomemsg = TTaskAllocMsg(task, 32);
					if (welcomemsg)
					{
						*((TUINT *) (welcomemsg + 0)) = THTON32(MSG_WELCOME);
						*((TUINT *) (welcomemsg + 4)) = THTON32(callbackport);
						TPutReplyMsg(contactport, TTaskPort(task), welcomemsg);
						TWaitPort(TTaskPort(task));
						welcomemsg = TGetMsg(TTaskPort(task));
						success = (TGetMsgStatus(welcomemsg) == TMSG_STATUS_ACKD);
						TFreeMsg(welcomemsg);
					}
				}
			}
			
			if (success)
			{
				if (TInitLock(task, &w->lock, TNULL))
				{
					w->visual = TCreateVisual(task, TNULL);
					if (w->visual)
					{
						w->pentab = TTaskAlloc(task, sizeof(TVPEN) * NUMPENS);
						if (w->pentab)
						{
							w->pentab[PBLACK] = TVAllocPen(w->visual, 0x000000);
							w->pentab[PRED] = TVAllocPen(w->visual, 0xaa0000);
							w->pentab[PBLUE] = TVAllocPen(w->visual, 0x2222ff);
							w->pentab[PGREEN] = TVAllocPen(w->visual, 0x00ff00);
							w->pentab[PWHITE] = TVAllocPen(w->visual, 0xffffff);
							w->pentab[PGREY] = TVAllocPen(w->visual, 0x556677);
							TVSetInput(w->visual, TITYPE_NONE, TITYPE_VISUAL_CLOSE | TITYPE_KEY | TITYPE_MOUSEBUTTON | TITYPE_VISUAL_NEWSIZE);
							TInitList(&w->activeballs);
							TInitList(&w->cachedballs);
							w->width = 600;
							w->height = 400;
							return TTRUE;
						}
						TDestroy(w->visual);
					}
					TDestroy(&w->lock);
				}
			}
			
			TDestroy(w->leftout);
			TDestroy(w->rightout);
		}
		TDestroy(w->leftin);
		TDestroy(w->rightin);
	}
	return TFALSE;
}

TVOID worldfunc(TAPTR task)
{
	struct world *w = TTaskGetData(task);

	TINT i;
	TIMSG *imsg;
	TFLOAT f, delayf = 1.0f/WORLDUPDATEPERSECOND;
	TBOOL mousemove;
	TTIME delay, now, lasttime;
	TBOOL abort = TFALSE;
	TINT mousex = 0, mousey = 0, omx = 0, omy = 0;		/* current, old mouse position */
	struct ball *control = TNULL;						/* ball under mouse, or TNULL */
	TFLOAT mousevx = 0, mousevy = 0;					/* mouse vector */
	TUINT signals;

	TVClear(w->visual, w->pentab[PGREY]);
	TVFRect(w->visual, 0,0,600,400, w->pentab[PBLACK]);
	
	TTimeQuery(task, &lasttime);
	
	TFTOTIME(1.0f/WORLDUPDATEPERSECOND, &delay);

	do
	{
		TBOOL newsize = TFALSE;
	
		if (delayf > 0.00001f)
		{
			TFTOTIME(delayf, &delay);
			signals = TTimedWait(task, 
				w->visual->iport->signal | w->leftin->signal | w->rightin->signal | TTaskPort(task)->signal, &delay);
		}
		else
		{
			signals = TSetSignal(task, 0, w->visual->iport->signal | w->leftin->signal | w->rightin->signal | TTaskPort(task)->signal);
		}
		
		TTimeQuery(task, &now);
		f = TTIMETOF(&now) - TTIMETOF(&lasttime);
		delayf = 1.0f/WORLDUPDATEPERSECOND - f;
		lasttime = now;
		f *= WORLDUPDATEPERSECOND;

		sigballlist(w, &w->activeballs, BALLSIG_DRAW);

		mousemove = TFALSE;

		if (signals & w->visual->iport->signal)
		{
			while ((imsg = (TIMSG *) TGetMsg(w->visual->iport)))
			{
				switch (imsg->type)
				{
					case TITYPE_VISUAL_NEWSIZE:
						newsize = TTRUE;
						break;
				
					case TITYPE_VISUAL_CLOSE:
						abort = TTRUE;
						break;
	
					case TITYPE_KEY:
						if (imsg->code == TKEYCODE_ESC)
						{
							abort = TTRUE;
						}
						break;
	
					case TITYPE_MOUSEMOVE:
						mousex = imsg->mousex;
						mousey = imsg->mousey;
						mousemove = TTRUE;
						break;
	
					case TITYPE_MOUSEBUTTON:
						switch (imsg->code)
						{
							case TMBCODE_LEFTUP:
								if (control)
								{
									/* lose ball control */
	
									setballv(w, control, mousevx, mousevy);
									TVSetInput(w->visual, TITYPE_MOUSEMOVE, TITYPE_NONE);
									control = TNULL;		
								}
								break;
	
							case TMBCODE_LEFTDOWN:
							{
								if (!control)
								{
									/* get ball control */
	
									struct ball *b = pickball(w, imsg->mousex, imsg->mousey);
									if (b)
									{
										control = b;
										b->vx = 0; b->vy = 0; b->gravity = 0;
										TVSetInput(w->visual, TITYPE_NONE, TITYPE_MOUSEMOVE);
									}
								}
								break;
							}
							
							case TMBCODE_RIGHTDOWN:
								if (control)
								{
									/* remove ball */
	
									TSignal(control->task, BALLSIG_SLEEP);
									TRemove((TNODE *) control);
									TAddTail(&w->cachedballs, (TNODE *) control);
									control = TNULL;
									TVSetInput(w->visual, TITYPE_MOUSEMOVE, TITYPE_NONE);
								}
								else 
								{
									/* new ball */
									
									struct ball *b = newball(w, imsg->mousex, imsg->mousey);
									if (b)
									{
										control = b;
										TVSetInput(w->visual, TITYPE_NONE, TITYPE_MOUSEMOVE);
									}
								}
								break;
	
							case TMBCODE_RIGHTUP:
								if (control)
								{
									setballv(w, control, mousevx, mousevy);
									TVSetInput(w->visual, TITYPE_MOUSEMOVE, TITYPE_NONE);
									control = TNULL;
								}
								break;
						}
						break;
				}
				TAckMsg(imsg);
			}
		}

		if (newsize)
		{
			newsize = TFALSE;
			TVClear(w->visual, w->pentab[PGREY]);
			TVFRect(w->visual, 0,0,600,400, w->pentab[PBLACK]);
			TVFlush(w->visual);
		}

		mousevx = (mousevx + (mousex - omx) * f * MOUSEACCEL) * MOUSEFRICTION;
		mousevy = (mousevy + (mousey - omy) * f * MOUSEACCEL) * MOUSEFRICTION;
		omx = mousex;
		omy = mousey;
		
		if (control && mousemove)
		{
			setballpos(w, control, mousex, mousey);
			TSignal(control->task, BALLSIG_DRAW);
		}

		if (signals & w->leftin->signal)
		{
			TVFRect(w->visual, 0,404,40,10, w->pentab[PGREEN]);
			handlenetmsg(w, w->leftin, &w->leftout);
		}
		else
		{
			TVFRect(w->visual, 0,404,40,10, w->pentab[PGREY]);
		}

		if (signals & w->rightin->signal)
		{
			TVFRect(w->visual, 560,404,40,10, w->pentab[PGREEN]);
			handlenetmsg(w, w->rightin, &w->rightout);
		}
		else
		{
			TVFRect(w->visual, 560,404,40,10, w->pentab[PGREY]);
		}

		if (signals & TTaskPort(task)->signal)
		{
			handlenetreply(w);
		}

		TVFlushArea(w->visual, 0,0,620,420);

	} while (!abort);

	destroyballlist(w, &w->activeballs);
	destroyballlist(w, &w->cachedballs);

	for (i = 0; i < NUMPENS; ++i)
	{
		TVFreePen(w->visual, w->pentab[i]);
	}

	TDestroy(w->visual);
	TDestroy(&w->lock);
	TDestroy(w->leftout);
	TDestroy(w->rightout);
	TDestroy(w->leftin);
	TDestroy(w->rightin);
}


TVOID destroyballlist(struct world *w, TLIST *list)
{
	TNODE *nextnode, *node = list->head;
	while ((nextnode = node->succ))
	{
		TRemove(node);
		TDestroy(node);
		node = nextnode;
	}
}

TVOID sigballlist(struct world *w, TLIST *list, TUINT sig)
{
	TNODE *nextnode, *node = list->head;
	while ((nextnode = node->succ))
	{
		TSignal(((struct ball *) node)->task, sig);
		node = nextnode;
	}
}

struct ball *newball(struct world *w, TINT mousex, TINT mousey)
{
	struct ball *b = (struct ball *) TRemHead(&w->cachedballs);
	if (!b)
	{
		b = createball(w->task, w, w->visual, w->pentab[PBLACK], w->pentab[PBLUE], 0.5f, 0.5f, 0.0f, 0.0f);
	}
	if (b)
	{
		b->vx = 0; b->vy = 0; b->gravity = 0;
		setballpos(w, b, mousex, mousey);
		TAddTail(&w->activeballs, (TNODE *) b);
		TSignal(b->task, BALLSIG_WAKE);
	}

	return b;
}

struct ball *newnetball(struct world *w, TFLOAT x, TFLOAT y, TFLOAT vx, TFLOAT vy)
{
	struct ball *b = (struct ball *) TRemHead(&w->cachedballs);
	if (!b)
	{
		b = createball(w->task, w, w->visual, w->pentab[PBLACK], w->pentab[PBLUE], x, y, vx, vy);
	}
	if (b)
	{
		TLock(&b->lock);
		b->x = x;
		b->y = y;
		b->vx = vx;
		b->vy = vy;
		b->gravity = BALLGRAV;
		TUnlock(&b->lock);
		TAddTail(&w->activeballs, (TNODE *) b);
		TSignal(b->task, BALLSIG_WAKE);
	}

	return b;
}

TVOID setballpos(struct world *w, struct ball *b, TINT mousex, TINT mousey)
{
	TINT bw, bh;

	TLock(&b->lock);

	bw = b->radius * 2 * w->width;
	bh = b->radius * 2 * w->height;
	b->x = (TFLOAT) (mousex/*-bw/2*/) / (TFLOAT) (w->width/* - bw*/);
	b->y = (TFLOAT) (mousey-bh/2) / (TFLOAT) (w->height - bh);
	b->x = TCLAMP(0.0f, b->x, 1.0f);
	b->y = TCLAMP(0.0f, b->y, 1.0f);
	b->gravity = 0.0f;

	TUnlock(&b->lock);
}

TVOID setballv(struct world *w, struct ball *b, TFLOAT mousevx, TFLOAT mousevy)
{
	TINT bw, bh;

	TLock(&b->lock);

	bw = b->radius * 2 * w->width;
	bh = b->radius * 2 * w->height;
	b->vx = mousevx / (TFLOAT) (w->width - bw);
	b->vy = mousevy / (TFLOAT) (w->height - bh);
	b->gravity = BALLGRAV;

	TUnlock(&b->lock);
}

struct ball *pickball(struct world *w, TINT mousex, TINT mousey)
{
	TINT bw, bh, bx, by;
	struct ball *b;
	TNODE *nextnode, *node = w->activeballs.tailpred;
	while ((nextnode = node->pred))
	{
		b = (struct ball *) node;
		TLock(&b->lock);

		bw = b->radius * 2 * w->width;
		bh = b->radius * 2 * w->height;
		bx = b->x * (w->width - bw);
		by = b->y * (w->height - bh);

		TUnlock(&b->lock);
		
		if (mousex >= bx && mousex < bx+bw && mousey >= by && mousey < by+bh)
		{
			return b;
		}

		node = nextnode;
	}
	return TNULL;
}

TBOOL handlenetmsg(struct world *w, TPORT *inport, TPORT **outport)
{
	TUINT *msg, type, callbackport;
	TSTRPTR sender;

	TLock(&w->lock);

	while ((msg = TGetMsg(inport)))
	{
		type = TNTOH32(*(msg + 0));
		switch (type)
		{
			case MSG_WELCOME:
				if (*outport == TNULL)
				{
					callbackport = TNTOH32(*((TUINT *) (msg + 1)));
					sender = TGetMsgSender(msg);
					if (sender)
					{
						TTAGITEM tags[2];
						TTIME timeout;
						TFTOTIME(1.0f, &timeout);
						tags[0].tag = TSock_ReplyTimeout;
						tags[0].value = (TTAG) &timeout;
						tags[1].tag = TTAG_DONE;
						if ((*outport = TFindSockPort(w->task, sender, callbackport, TNULL)))
						{
							TAckMsg(msg);
							break;
						}
					}
				}
				TDropMsg(msg);
				break;

			case MSG_MIGRATE:
			{
				TFLOAT x,y,vx,vy;
				*(msg + 3) = TNTOH32(*(msg + 3)); x = *((TFLOAT *) (msg + 3));
				*(msg + 4) = TNTOH32(*(msg + 4)); y = *((TFLOAT *) (msg + 4));
				*(msg + 5) = TNTOH32(*(msg + 5)); vx = *((TFLOAT *) (msg + 5));
				*(msg + 6) = TNTOH32(*(msg + 6)); vy = *((TFLOAT *) (msg + 6));
				if (newnetball(w, x,y,vx,vy))
				{
					TAckMsg(msg);
				}
				else
				{
					TDropMsg(msg);
				}
				break;
			}
			
			default:
				TDropMsg(msg);
		}
	}

	TUnlock(&w->lock);

	return TTRUE;
}

TVOID handlenetreply(struct world *w)
{
	TUINT *msg, type;
	struct ball *b;

	TLock(&w->lock);

	while ((msg = TGetMsg(TTaskPort(w->task))))
	{
		type = TNTOH32(*(msg + 0));
		switch (type)
		{
			case MSG_MIGRATE:

				b = (struct ball *) *(msg + 1);
				if (TGetMsgStatus(msg) == TMSG_STATUS_FAILED)
				{
					if (msg[2] == LEFT)
					{
						TDestroy(w->leftout);
						w->leftout = TNULL;
					}
					else
					{
						TDestroy(w->rightout);
						w->rightout = TNULL;
					}
					TSignal(b->task, BALLSIG_WAKE);
				}
				else
				{
					TSignal(b->task, BALLSIG_SLEEP);
					TRemove((TNODE *) b);
					TAddTail(&w->cachedballs, (TNODE *) b);
				}
				break;
		}
		TFreeMsg(msg);
	}

	TUnlock(&w->lock);
}



/******************************************************************** 
**	main
********************************************************************/

int main(int argc, char **argv)
{
	TSTRPTR host = TNULL;
	TUINT port = 0;
	TINT contact = 0;

	if (argc == 4)
	{
		if (!TStrCmp("left", argv[1]))
		{
			host = argv[2];
			port = atoi(argv[3]);
			contact = LEFT;
		}
		if (!TStrCmp("right", argv[1]))
		{
			host = argv[2];
			port = atoi(argv[3]);
			contact = RIGHT;
		}
	}

	if (host || argc == 1)
	{
		TAPTR task = TCreateTask(TNULL, TNULL, TNULL);
		if (task)
		{
			struct world *w = createworld(task, contact, host, port);
			if (w)
			{
				printf("\nportnumber-left:  %d\n", w->leftport);
				printf("portnumber-right: %d\n\n", w->rightport);
				printf("right mousebutton to create/destroy a ball.\n");
				printf("to connect to another instance via network:\n\n");
				printf("%s left <host-IP> <portnumber-right> - connect to the right window border\n", argv[0]);
				printf("%s right <host-IP> <portnumber-left> - connect to the left window border\n", argv[0]);
				fflush(NULL);
				TDestroy(w);
			}
			
			TDestroy(task);
		}
	}

	return 0;
}
