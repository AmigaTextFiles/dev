
/*
**	tek/examples/dyamicsystem.c
**
**	funny visualization for solving a special kind
**	of cache prediction problem
*/

#include <stdio.h>
#include <tek/visual.h>
#include <tek/exec.h>

#define AREAWIDTH	70
#define AREAHEIGHT	50
#define	FRAMERATE	30

#define BLUR		0.2
#define REDUCE		0.003
#define	ADD			0.8
#define	BEND		0.015
#define FRICTION	0.01


typedef struct
{
	TVISUAL *v;
	TVISUAL *subv;
	TINT brightness;
	TINT optimum;
	TINT hour;
	TFLOAT freq[24];
	TVPEN pentab[20];
	int toggle;

} global;



void setdaytime(global *data)
{
	data->hour++;
	if (data->hour == 24) data->hour = 0;
}

void calcoptimum(global *data)
{
	TUINT i = data->optimum;
	TUINT j = (data->optimum + 1) > 23 ? 0 : data->optimum + 1;
	TUINT k = (data->optimum - 1) < 0 ? 23 : data->optimum - 1;

	if ((data->toggle ^= 1))
	{
		if (data->freq[i] - data->freq[j] + BEND > FRICTION)
		{
			data->optimum++;
			if (data->optimum > 23) data->optimum = 0;
		}
		else if (data->freq[i] - data->freq[k] - BEND > FRICTION)
		{
			data->optimum--;
			if (data->optimum < 0) data->optimum = 23;
		}
	}
}

void reduce(global *data)
{
	TFLOAT temp[24];
	TINT i, j, k;

	for (i = 0; i < 24; ++i)
	{
		temp[i] = data->freq[i];
	}

	for (i = 0; i < 24; ++i)
	{
		j = i - 1 < 0 ? 23 : i - 1;
		k = i + 1 > 23 ? 0 : i + 1;
		
		temp[j] += data->freq[i] * BLUR * 0.5;
		temp[k] += data->freq[i] * BLUR * 0.5;
	}

	for (i = 0; i < 24; ++i)
	{
		temp[i] -= data->freq[i] * BLUR;
	}
		

	for (i = 0; i < 24; ++i)
	{
		data->freq[i] = temp[i] - REDUCE;
		data->freq[i] = TMAX(data->freq[i], 0.0);
	}
}


void paint(global *data)
{
	TINT i;
	TINT pw, ph;
	TINT areawidth, areaheight, blockwidth;

	TTAGITEM tags[3];

	TInitTags(tags);
	TAddTag(tags, TVisual_PixWidth, &pw);
	TAddTag(tags, TVisual_PixHeight, &ph);
							
	TVGetAttrs(data->subv, tags);

	areawidth = pw*AREAWIDTH/100;
	areaheight = ph*AREAHEIGHT/100;
	blockwidth = areawidth/24;

	TVText(data->subv, 1,1, " fetch ", 7, data->pentab[data->brightness + 6], data->pentab[0]);

	for (i = 0; i < 24; ++i)
	{
		TVFRect(data->subv, (pw-areawidth)/2 + i * blockwidth, 
			(TINT)((ph - areaheight) / 2 + areaheight * i * BEND),
			blockwidth, (TINT)((1-data->freq[i]) * areaheight), i == data->hour ? data->pentab[4] : data->pentab[2]);

		TVFRect(data->subv, (pw-areawidth)/2 + i * blockwidth, 
			(TINT)((ph-areaheight)/2 + areaheight - data->freq[i] * areaheight + areaheight * i * BEND),
			blockwidth, (TINT)(data->freq[i] * areaheight), i == data->hour ? data->pentab[5] : data->pentab[1]);

		if (i == data->optimum)
		{
			TVFRect(data->subv, (pw-areawidth)/2 + i * blockwidth + blockwidth/4, 
				(TINT)((ph-areaheight)/2 + areaheight - data->freq[i] * areaheight + areaheight * i * BEND) - blockwidth/2,
				blockwidth/2, blockwidth/2, data->pentab[3]);
		}
	}

	TVFlushArea(data->subv, 0,0,pw,ph);
}


void subtaskfunc(TAPTR task)
{
	TTIME t1, t2;
	TFLOAT delayf;
	global *data = TTaskGetData(task);

	for(;;)
	{
		TTimeQuery(task, &t1);				

		setdaytime(data);
		reduce(data);
		calcoptimum(data);
		if (data->optimum == data->hour)
		{
			data->brightness = 6;
		}

		paint(data);


		if (data->brightness)
		{
			data->brightness--;
		}

		TTimeQuery(task, &t2);

				delayf = 1.0f/FRAMERATE - (TTIMETOF(&t2) - TTIMETOF(&t1));
				if (delayf > 0.00001f)
				{
					TTimeDelayF(task, delayf);
				}

		if (TSetSignal(task, 0, TTASK_SIG_ABORT) & TTASK_SIG_ABORT) break;
	}

	TDestroy(data->subv);
}


TBOOL initfunc(TAPTR task)
{
	global *data = TTaskGetData(task);
	data->subv = TAttachVisual(task, data->v, TNULL);
	return (TBOOL) !!data->subv;
}



int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TTAGITEM tags[3];
		
		global data;
		data.brightness = 0;
		data.optimum = 0;
		data.hour = 0;
		data.toggle = 0;
		
		TInitTags(tags);
		TAddTag(tags, TVisual_Title, "Dynamic System");
		
		
		data.v = TCreateVisual(basetask, tags);
		if (data.v)
		{
			TTAGITEM tasktags[3];
			TINT i;
			TAPTR subtask;

			TVSetInput(data.v, TITYPE_NONE, TITYPE_VISUAL_CLOSE | TITYPE_KEY | TITYPE_MOUSEBUTTON | TITYPE_VISUAL_NEWSIZE);

			data.pentab[0] = TVAllocPen(data.v, 0x000000);
			data.pentab[1] = TVAllocPen(data.v, 0x66bb00);
			data.pentab[2] = TVAllocPen(data.v, 0x660066);
			data.pentab[3] = TVAllocPen(data.v, 0xff0000);
			data.pentab[4] = TVAllocPen(data.v, 0x990099);
			data.pentab[5] = TVAllocPen(data.v, 0xbbff77);
			data.pentab[6] = TVAllocPen(data.v, 0x112233);
			data.pentab[7] = TVAllocPen(data.v, 0x334455);
			data.pentab[8] = TVAllocPen(data.v, 0x556677);
			data.pentab[9] = TVAllocPen(data.v, 0x778899);
			data.pentab[10] = TVAllocPen(data.v, 0x99aabb);
			data.pentab[11] = TVAllocPen(data.v, 0xbbccdd);
			data.pentab[12] = TVAllocPen(data.v, 0xddeeff);

			TVClear(data.v, data.pentab[0]);

			for (i = 0; i < 24; ++i) data.freq[i] = 0.0;

		
			tasktags[0].tag = TTask_UserData;
			tasktags[0].value = &data;
			tasktags[1].tag = TTask_InitFunc;
			tasktags[1].value = (TTAG) initfunc;
			tasktags[2].tag = TTAG_DONE;

			subtask = TCreateTask(basetask, subtaskfunc, tasktags);
			if (subtask)
			{
				TBOOL abort = TFALSE;
				TIMSG *imsg;

				do
				{
					TWait(basetask, data.v->iport->signal);

					while ((imsg = (TIMSG *) TGetMsg(data.v->iport)))
					{
						switch (imsg->type)
						{
							case TITYPE_MOUSEBUTTON:
								if (imsg->code == TMBCODE_LEFTDOWN)
								{
									data.freq[data.hour] += ADD;
									data.freq[data.hour] = TMIN(data.freq[data.hour], 1.0);
								}
								break;

							case TITYPE_VISUAL_NEWSIZE:
								TVClear(data.v, data.pentab[0]);
								TVFlush(data.v);
								break;
						
							case TITYPE_VISUAL_CLOSE:
								abort = TTRUE;
								break;
	
							case TITYPE_KEY:
								abort = (imsg->code == TKEYCODE_ESC);
								break;
						}
						TAckMsg(imsg);
					}
				} while (!abort);

				TSignal(subtask, TTASK_SIG_ABORT);
				TDestroy(subtask);
			}
			TDestroy(data.v);
		}
		TDestroy(basetask);
	}

	return 0;
}

