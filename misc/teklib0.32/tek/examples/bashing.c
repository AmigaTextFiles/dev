
/*
**	tek/examples/bashing.c
**
**	visual multibashing demo
**
**	demonstrates multiple threads drawing to
**	a single visual at different framerates
**
*/


#include <math.h>
#include <stdio.h>

#include <tek/array.h>
#include <tek/debug.h>
#include <tek/visual.h>

#define NUMLINES	40

struct efxdata
{
	TINT x, y;
	TVPEN pen, backpen, whitepen, blackpen;
	TVISUAL *visual;
	TINT framerate;
};


TBOOL efxinitfunc(TAPTR task)
{
	struct efxdata *initdata = TTaskGetData(task);
	struct efxdata *data = TTaskAlloc(task, sizeof(struct efxdata));

	if (data)
	{
		TMemCopy(initdata, data, sizeof(struct efxdata));

		data->visual = TAttachVisual(task, initdata->visual, TNULL);
		if (data->visual)
		{
			TTaskSetData(task, data);
			return TTRUE;
		}
	}
	return TFALSE;
}


TVOID efxfunc(TAPTR task)
{
	struct efxdata *data = TTaskGetData(task);
	TINT i, j;
	TINT seed = TGetRandomSeed(task);
	TFLOAT s[6], ss[6], ds[6], dss[6];
	TTIME t1;
	TFLOAT difftime, fps = 1.0;
	TUINT signals;
	char buf[30];

	struct { TINT x, y; } xyarray[NUMLINES + 1];

	TINT fw,fh;
	TTAGITEM tags[3];
	
	tags[0].tag = TVisual_FontWidth;
	tags[0].value = &fw;
	tags[1].tag = TVisual_FontHeight;
	tags[1].value = &fh;
	tags[2].tag = TTAG_DONE;

	TVGetAttrs(data->visual, tags);

	

	for (i = 0; i < 6; ++i)
	{
		s[i] = 0.0; 
		
		ds[i] = (((TFLOAT) ((seed = TGetRandom(seed))%1000000)) / (TFLOAT) 1000000) * 0.3f + 0.03f;
		dss[i] = (((TFLOAT) ((seed = TGetRandom(seed))%1000000)) / (TFLOAT) 1000000) * 0.5f + 0.07f;
	}

	do
	{
		TTimeReset(task);

		TVFRect(data->visual, data->x, data->y, 200, 200, data->backpen);

		for (i = 0; i < 6; ++i) ss[i] = s[i];

		for (j = 0; j < NUMLINES + 1; ++j)
		{
			xyarray[j].x = (sin(ss[0]) + sin(ss[1]) + sin(ss[2])) * 200 / 6 + 200 / 2 + data->x;
			xyarray[j].y = (sin(ss[3]) + sin(ss[4]) + sin(ss[5])) * 200 / 6 + 200 / 2 + data->y;
			for (i = 0; i < 6; ++i)
			{
				ss[i] += dss[i];
				if (ss[i] > 2*TPI) ss[i] -= 2*TPI;
			}
		}

		for (i = 0; i < 6; ++i)
		{
			s[i] += ds[i];
			if (s[i] > 2*TPI) s[i] -= 2*TPI;
		}

		TVLineArray(data->visual, (TINT *) xyarray, NUMLINES + 1, data->pen);

		sprintf(buf, "FPS: %d/%d/%d%% ", (TINT) fps, data->framerate, (TINT) (fps * 100 / data->framerate));
		TVText(data->visual,(data->x+fw-1)/fw,(data->y+fh-1)/fh,buf,TStrLen(buf),data->blackpen,data->whitepen);

		TVFlushArea(data->visual, data->x, data->y,200,200);

		TTimeQuery(task, &t1);

		difftime = 1.0f / (TFLOAT) data->framerate - TTIMETOF(&t1);

		if (difftime > 0.0001f)
		{
			TFTOTIME(difftime, &t1);
			signals = TTimedWait(task, TTASK_SIG_ABORT, &t1);
		}
		else
		{
			signals = TSetSignal(task, 0, TTASK_SIG_ABORT);
		}
		
		TTimeQuery(task, &t1);
		
		fps = 1.0f/TTIMETOF(&t1);
		
	
	} while (!(signals & TTASK_SIG_ABORT));

	TDestroy(data->visual);
	TTaskFree(task, data);
}


int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TINT seed = TGetRandomSeed(basetask);

		TVISUAL *v = TCreateVisual(basetask, TNULL);
		if (v)
		{
			TIMSG *imsg;
			TBOOL abort = TFALSE;

			TINT x, y, i = 0;
			TVPEN pentab[8];
			TAPTR tasks[6] = {TNULL, TNULL, TNULL, TNULL, TNULL, TNULL};

			pentab[0] = TVAllocPen(v, 0xffffff);
			pentab[1] = TVAllocPen(v, 0xff00ff);
			pentab[2] = TVAllocPen(v, 0xff0000);
			pentab[3] = TVAllocPen(v, 0x0000ff);
			pentab[4] = TVAllocPen(v, 0x00ff00);
			pentab[5] = TVAllocPen(v, 0x00ffff);
			pentab[6] = TVAllocPen(v, 0x112233);
			pentab[7] = TVAllocPen(v, 0x000000);
			
			TVClear(v, pentab[7]);
			
			for (y = 0; y < 2; ++y)
			{
				for (x = 0; x < 3; ++x)
				{
					TTAGITEM tasktags[3];
					struct efxdata init;
					init.x = 20 + x * 220;
					init.y = 20 + y * 220;
					init.pen = pentab[i];
					init.backpen = pentab[6];
					init.whitepen = pentab[0];
					init.blackpen = pentab[7];
					init.framerate = (seed = TGetRandom(seed)) % 40 + 10;
					init.visual = v;
					tasktags[0].tag = TTask_InitFunc;
					tasktags[0].value = (TTAG) efxinitfunc;
					tasktags[1].tag = TTask_UserData;
					tasktags[1].value = &init;
					tasktags[2].tag = TTAG_DONE;
					tasks[i] = TCreateTask(basetask, efxfunc, tasktags);
					i++;
				}
			}

			TVSetInput(v, TITYPE_NONE, TITYPE_VISUAL_CLOSE | TITYPE_KEY | TITYPE_VISUAL_NEWSIZE);

			do
			{			
				TWait(basetask, v->iport->signal);

				while ((imsg = (TIMSG *) TGetMsg(v->iport)))
				{
					switch (imsg->type)
					{
						case TITYPE_VISUAL_NEWSIZE:
							TVClear(v, pentab[7]);
							TVFlush(v);
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
					}
					TAckMsg(imsg);
				}

			} while (!abort);


			for (i = 0; i < 6; ++i)
			{
				TSignal(tasks[i], TTASK_SIG_ABORT);
				TDestroy(tasks[i]);
			}

			for (i = 0; i < 8; ++i)
			{
				TVFreePen(v, pentab[i]);
			}

			TDestroy(v);
		}

		TDestroy(basetask);
	}

	return 0;
}

