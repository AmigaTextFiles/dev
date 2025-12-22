/*
 * $Id: timer.c 1.3 1998/04/12 17:30:13 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

#define BUSY (0)

/******************************************************************************/

STATIC struct MsgPort *		TimerPort;
STATIC struct timerequest *	TimerRequest;
STATIC BOOL					TimerTicking;

/******************************************************************************/

VOID
StopTimer(VOID)
{
	/* stop a ticking timer */
	if(TimerTicking)
	{
		if(CheckIO((struct IORequest *)TimerRequest) == BUSY)
			AbortIO((struct IORequest *)TimerRequest);

		WaitIO((struct IORequest *)TimerRequest);
		TimerTicking = FALSE;
	}
}

/******************************************************************************/

VOID
StartTimer(ULONG seconds,ULONG micros)
{
	/* restart the timer */

	StopTimer();

	if(seconds > 0 || micros > 0)
	{
		TimerRequest->tr_node.io_Command	= TR_ADDREQUEST;
		TimerRequest->tr_time.tv_secs		= seconds;
		TimerRequest->tr_time.tv_micro		= micros;

		SetSignal(0,PORT_MASK(TimerPort));
		SendIO((struct IORequest *)TimerRequest);

		TimerTicking = TRUE;
	}
}

/******************************************************************************/

VOID
DeleteTimer(VOID)
{
	/* clean up all timer resources */

	StopTimer();

	if(TimerRequest != NULL)
	{
		if(TimerRequest->tr_node.io_Device != NULL)
			CloseDevice((struct IORequest *)TimerRequest);

		DeleteIORequest((struct IORequest *)TimerRequest);
		TimerRequest = NULL;
	}

	if(TimerPort != NULL)
	{
		DeleteMsgPort(TimerPort);
		TimerPort = NULL;
	}
}

BYTE
CreateTimer(VOID)
{
	BYTE result = -1;

	/* allocate all timer resources */

	TimerPort = CreateMsgPort();
	if(TimerPort != NULL)
	{
		TimerRequest = (struct timerequest *)CreateIORequest(TimerPort,sizeof(*TimerRequest));
		if(TimerRequest != NULL)
		{
			if(OpenDevice(TIMERNAME,UNIT_VBLANK,(struct IORequest *)TimerRequest,0) == OK)
			{
				/* required for GetSysTime() */
				TimerBase = TimerRequest->tr_node.io_Device;

				result = TimerPort->mp_SigBit;
			}
		}
	}

	if(result == -1)
	{
		DeleteTimer();
	}

	return(result);
}
