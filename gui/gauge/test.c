/*
**	$VER: Test.c 1.1 (26.1.97)
**
**	Test.c -- Test for an implementation of a progress requester as
**	          per the Amiga User Interface Style Guide.
**
**	Copyright © 1997 by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
**		Freely Distributable
*/

#include <dos/dos.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#include "gauge.h"

struct Library *IntuitionBase,*GfxBase,*UtilityBase;

int
main()
{
	IntuitionBase	= OpenLibrary("intuition.library",37);
	GfxBase		= OpenLibrary("graphics.library",37);
	UtilityBase	= OpenLibrary("utility.library",37);

	if(IntuitionBase && GfxBase && UtilityBase)
	{
		struct Gauge *g;

		/* Just open the gauge and wait for a response.
		 * Then close the display
		 */
		if(g = NewGauge(
			GAUGE_Title,	"Rendering \"Boing.Ball\"",
			GAUGE_Fill,	50,
		TAG_DONE))
		{
			struct MsgPort *port;

			GetGauge(g,GAUGE_MsgPort,&port,TAG_DONE);

			WaitPort(port);

			DisposeGauge(g);
		}

		if(g = NewGauge(
			GAUGE_ButtonLabel,	"Stop the test",
			GAUGE_Title,		"Testing the fill bar",
		TAG_DONE))
		{
			LONG percent;
			LONG increment;
			LONG stop;

			percent = 0;
			increment = 1;

			do
			{
				percent += increment;

				SetGauge(g,
					GAUGE_Fill,percent,
				TAG_DONE);

				if(percent == 100 || percent == 0)
					increment = -increment;

				Delay(TICKS_PER_SECOND / 10);

				stop = FALSE;

				GetGauge(g,
					GAUGE_Hit,&stop,
				TAG_DONE);
			}
			while(stop == FALSE);

			DisposeGauge(g);
		}
	}

	if(IntuitionBase)
		CloseLibrary(IntuitionBase);

	if(GfxBase)
		CloseLibrary(GfxBase);

	if(UtilityBase)
		CloseLibrary(UtilityBase);

	return(0);
}
