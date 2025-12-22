#include <exec/types.h>
#include <proto/exec.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#ifdef USE_SYSTIME
#include <devices/timer.h>
#include <clib/timer_protos.h>
#include <pragmas/timer_pragmas.h>
#else
#include <time.h>
#endif

#ifdef USE_SYSTIME
struct Library *TimerBase;
static struct timerequest *tr;
#endif

static float measure;
static float elapsed;
extern struct ExecBase *SysBase;

#ifdef USE_SYSTIME
/*
** Close the timer system
** Autmatically called by AtExit
*/
static void TIMER_close(void)
{

	CloseDevice((struct IORequest *)tr);
	free(tr);

}

/*
** Initialize the TIMER system
*/
void TIMER_init(void)
{

	atexit(TIMER_close);

	tr = (struct timerequest *)calloc(1, sizeof(struct timerequest));
	if (OpenDevice(TIMERNAME, UNIT_MICROHZ, (struct IORequest *) tr, 0L) != 0) {
		printf("Error opening timer.device\n");
		exit(1);
	}
	TimerBase = (struct Library *)tr->tr_node.io_Device;
	printf("TimerBase initialized to 0x%lX\n", (ULONG)TimerBase);
}

/*
** Get the current game time
** returns a float, with resolution at microseconds
** Integer part is seconds
** float part is fraction of seconds
*/
float TIMER_GetSeconds(void)
{

	static struct timeval tv;
	float now;

	GetSysTime(&tv);

	now  = (float)tv.tv_secs;
	now += (float)tv.tv_micro/1000000.0;

	return now;
}
#else

void TIMER_init(void)
{
	return;
}

float TIMER_GetSeconds(void)
{
#if 0
	static unsigned int clock[2];
	int x;

	x=timer(clock);
	if (x==0) {
		float now = (float)clock[0];
		now += ((float)clock[1])/1000000.0;
		return now;
	} else return -1.0;
#endif
	return (float)((float)clock() / (float)CLOCKS_PER_SEC);
}

#endif

/*
** Start the timer for measuring time intervals
** This basically sets an internal variable (measure)
** to the current time.
*/
void TIMER_StartInterval(void)
{
	measure = TIMER_GetSeconds();
}

/*
** Stop the interval timer
** Essentially returns the time difference
** to the measure variable
*/
float TIMER_StopInterval(void)
{
	return (float)(TIMER_GetSeconds() - measure);
}

/*
** Set the elapsed timer
**
** This routine (and TIMER_GetElapsed) is for long-timed
** interval timing, i.e.game elapsed time. Uses and internal
** variable
*/
void TIMER_StartElapsed(void)
{
	elapsed = TIMER_GetSeconds();
}

/*
** Return the time interval since the last call
** to TIMER_StartElapsed()
*/
float TIMER_GetElapsed(void)
{
	return (float)(TIMER_GetSeconds() - elapsed);
}
