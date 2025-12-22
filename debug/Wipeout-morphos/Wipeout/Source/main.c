/*
 * $Id: main.c,v 1.8 2009/06/14 22:03:58 itix Exp $
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
#include <exec/system.h>
#endif	/* _GLOBAL_H */

/******************************************************************************/

#include "Wipeout_rev.h"

/******************************************************************************/

CONST TEXT __TEXTSEGMENT__ VersTag[] = VERSTAG;

/******************************************************************************/

STATIC CONST TEXT Separator[] = "======================================="
                                "=======================================";

/******************************************************************************/

STATIC struct WipeoutSemaphore *	WipeoutSemaphore;
STATIC BOOL							WipeoutSemaphoreCreated;

/******************************************************************************/

STATIC BOOL ShowBannerMessage = TRUE;

/******************************************************************************/

STATIC BYTE TimerSignal;

/******************************************************************************/
STATIC LONG ControlFuncPPC(void)
{
	struct TagItem * list = (struct TagItem *)REG_A0;
	struct TagItem * ti;
	struct TrackHeader * th;
	APTR address = NULL;
	LONG result = 0;

	Forbid();

	while((ti = NextTagItem(&list)) != NULL)
	{
		switch(ti->ti_Tag)
		{
			case WOT_Address:

				address = (APTR)ti->ti_Data;
				break;

			case WOT_SetPC:

				if((th=IsTrackedAllocation((ULONG)address)) ||
				   (th=IsTrackedAllocation((ULONG)(address)-sizeof(LONG))))
				{
					#warning "what's this weird interface's purpose..collides with my changed PC handling"
					memset(th->th_PC,0,sizeof(th->th_PC));
					th->th_PC[0] = ti->ti_Data;
					th->th_ShowPC = TRUE;
					FixTrackHeaderChecksum(th);
				}

				break;
		}
	}

	Permit();

	return(result);
}

STATIC struct EmulLibEntry	ControlFunc	= { TRAP_LIB, 0, (void (*)())&ControlFuncPPC	};
/******************************************************************************/

STATIC struct WipeoutSemaphore *
FindWipeoutSemaphore(VOID)
{
	struct WipeoutSemaphore * ws;

	ws = (struct WipeoutSemaphore *)FindSemaphore(WIPEOUTSEMAPHORENAME);

	return(ws);
}

STATIC VOID
DeleteWipeoutSemaphore(struct WipeoutSemaphore * ws)
{
	if(ws != NULL)
	{
		/* remove the semaphore from the public list */
		RemSemaphore((struct SignalSemaphore *)ws);

		/* gain ownership over it */
		ObtainSemaphore((struct SignalSemaphore *)ws);
		ReleaseSemaphore((struct SignalSemaphore *)ws);

		/* and release it */
		FreeMem(ws,sizeof(*ws));
	}
}

STATIC struct WipeoutSemaphore *
CreateWipeoutSemaphore(VOID)
{
	struct WipeoutSemaphore * ws;

	ws = AllocMem(sizeof(*ws),MEMF_ANY|MEMF_PUBLIC|MEMF_CLEAR);
	if(ws != NULL)
	{
		/* fill in name and priority; AddSemaphore() will take
		 * care of the rest
		  */
		ws->ws_SignalSemaphore.ss_Link.ln_Name	= ws->ws_SemaphoreName;
		ws->ws_SignalSemaphore.ss_Link.ln_Pri	= 1;

		strcpy(ws->ws_SemaphoreName,WIPEOUTSEMAPHORENAME);

		/* for compatibility checking, if the semaphore
		 * needs to grow
		 */
		ws->ws_Version			= WIPEOUTSEMAPHOREVERSION;
		ws->ws_Revision			= WIPEOUTSEMAPHOREREVISION;

		/* fill in references to changeable parameters */
		ws->ws_IsActive			= &IsActive;
		ws->ws_ShowFail			= &ShowFail;
		ws->ws_WaitAfterHit		= &WaitAfterHit;
		ws->ws_NameTag			= &NameTag;
		ws->ws_NameTag			= &NameTag;
		ws->ws_CheckConsistency	= &CheckConsistency;
		ws->ws_ARegCheck		= &ARegCheck;
		ws->ws_DRegCheck		= &DRegCheck;
		ws->ws_StackCheck		= &StackCheck;
		ws->ws_StackLines		= &StackLines;
		ws->ws_CheckDelay		= &CheckDelay;
		ws->ws_WipeoutTask		= FindTask(NULL);
		ws->ws_WakeupMask		= (1UL << WakeupSignal);
		ws->ws_CheckOrphaned	= (APTR)&CheckOrphaned;
		ws->ws_ControlFunc		= (WipeoutControlFunc)&ControlFunc;

		/* and finally make the semaphore public */
		AddSemaphore((struct SignalSemaphore *)ws);
	}

	return(ws);
}

/******************************************************************************/

STATIC LONG
SendWipeoutCmd(LONG command,APTR parameter)
{
	WipeoutSemaphore->ws_Client		= FindTask(NULL);
	WipeoutSemaphore->ws_Command	= command;
	WipeoutSemaphore->ws_Parameter	= parameter;
	WipeoutSemaphore->ws_Error		= OK;

	/* wake up the wipeout semaphore owner and exchange
	 * data or information with it
	 */
	SetSignal(0,SIG_Handshake);
	Signal(WipeoutSemaphore->ws_WipeoutTask,WipeoutSemaphore->ws_WakeupMask);
	Wait(SIG_Handshake);

	return(WipeoutSemaphore->ws_Error);
}

/******************************************************************************/

STATIC VOID
Cleanup(VOID)
{
	/* shut down the timer */
	DeleteTimer();

	/* dispose of the semaphore */
	if(WipeoutSemaphoreCreated)
	{
		DeleteWipeoutSemaphore(WipeoutSemaphore);
		WipeoutSemaphore = NULL;
	}

	/* release the semaphore */
	if(WipeoutSemaphore != NULL)
	{
		ReleaseSemaphore((struct SignalSemaphore *)WipeoutSemaphore);
		WipeoutSemaphore = NULL;
	}

	/* clear the allocation filters */
	ClearFilterList();

	/* get rid of the wakeup signal */
	if(WakeupSignal != -1)
	{
		FreeSignal(WakeupSignal);
		WakeupSignal = -1;
	}
}

STATIC BOOL
Setup(VOID)
{
	LONG error = OK;
	int i;

	WakeupSignal = -1;

	#if defined(__M68K__)
	/* Kickstart 2.04 or higher required */
	if(SysBase->LibNode.lib_Version < 37)
	{
		const STRPTR message = "This program requires Kickstart 2.04 or better.\n";

		Write(Output(),message,strlen(message));
		return(FAILURE);
	}
	#endif

	/* determine the program name */
	StrcpyN(sizeof(ProgramName),ProgramName,VERS);

	for(i = strlen(ProgramName) - 1 ; i >= 0 ; i--)
	{
		if(ProgramName[i] == ' ')
		{
			ProgramName[i] = '\0';
			break;
		}
	}

	/* allocate the timer data */
	TimerSignal = CreateTimer();
	if(TimerSignal == -1)
	{
		Printf("%s: Could not create timer.\n", (ULONG)ProgramName);
		return(FAILURE);
	}

	/* allocate the wakeup signal */
	WakeupSignal = AllocSignal(-1);
	if(WakeupSignal == -1)
	{
		Printf("%s: Could not allocate wakeup signal.\n", (ULONG)ProgramName);
		return(FAILURE);
	}

	/* establish default options */
	PreWallSize		= 32;
	PostWallSize	= 32;
	IsActive		= TRUE;
	CheckOrphaned	= FALSE;
	StackLines		= 2;

	NewGetSystemAttrs(&ModuleStart,sizeof(ModuleStart),SYSTEMINFOTYPE_MODULE_START,TAG_END);
	NewGetSystemAttrs(&ModuleSize,sizeof(ModuleStart),SYSTEMINFOTYPE_MODULE_SIZE,TAG_END);
	NewGetSystemAttrs(&EmulationStart,sizeof(EmulationStart),SYSTEMINFOTYPE_EMULATION_START,TAG_END);
	NewGetSystemAttrs(&EmulationSize,sizeof(EmulationStart),SYSTEMINFOTYPE_EMULATION_SIZE,TAG_END);

	Forbid();

	/* try to find the global wipeout semaphore */
	WipeoutSemaphore = FindWipeoutSemaphore();
	if(WipeoutSemaphore == NULL)
	{
		/* it does not exist yet; create it */
		WipeoutSemaphore = CreateWipeoutSemaphore();
		if(WipeoutSemaphore != NULL)
		{
			WipeoutSemaphoreCreated = TRUE;
		}
		else
		{
			error = ERROR_NO_FREE_STORE;
		}
	}
	else if (WipeoutSemaphore->ws_Version != WIPEOUTSEMAPHOREVERSION)
	{
		error = ERROR_OBJECT_WRONG_TYPE;
	}
	else
	{
		/* obtain ownership of the semaphore */
		ObtainSemaphore((struct SignalSemaphore *)WipeoutSemaphore);
	}

	Permit();

	if(error == OK)
	{
		struct RDArgs * rda;

		/* these are the command line parameters, later
		 * filled in by ReadArgs() below
		 */
		struct
		{
			/* the following options control the startup defaults
			 * and cannot be changed by subsequent invocations
			 * of Wipeout
			 */
			NUMBER	PreSize;
			NUMBER	PostSize;
			KEY		FillChar;
			SWITCH	NoBanner;

			/* the following options can be changed at run-time */
			SWITCH	Remunge;
			SWITCH	Check;
			SWITCH	Mark;
			SWITCH	Unmark;
			SWITCH	ShowUnmarked;
			KEY		Name;
			SWITCH	NameTag;
			SWITCH	NoNameTag;
			SWITCH	Active;
			SWITCH	Inactive;
			SWITCH	Wait;
			SWITCH	NoWait;
			SWITCH	ConsistenceCheck;
			SWITCH	NoConsistenceCheck;
			SWITCH	Reuse;
			SWITCH	NoReuse;
			SWITCH	ShowFail;
			SWITCH	NoShowFail;
			SWITCH	ARegCheck;
			SWITCH	NoARegCheck;
			SWITCH	DRegCheck;
			SWITCH	NoDRegCheck;
			SWITCH	StackCheck;
			SWITCH	NoStackCheck;
			SWITCH	CheckOrphaned;
			SWITCH	NoCheckOrphaned;
			NUMBER	StackLines;
			NUMBER	CheckDelay;
		} params;
	
		/* this is the command template, as required by ReadArgs() below;
		 * its contents must match the "params" data structure above
		 */
		const STRPTR cmdTemplate =
			"PRESIZE/K/N,"
			"POSTSIZE/K/N,"
			"FILLCHAR/K,"
			"QUIET=NOBANNER/S,"
			"REMUNGE=REMUNG/S,"
			"CHECK/S,"
			"MARK/S,"
			"UNMARK/S,"
			"SHOWUNMARKED/S,"
			"NAME=TASK/K,"
			"NAMETAG/S,"
			"NONAMETAG/S,"
			"ACTIVE=ENABLE/S,"
			"INACTIVE=DISABLE/S,"
			"WAIT/S,"
			"NOWAIT/S,"
			"CONSISTENCECHECK/S,"
			"NOCONSISTENCECHECK/S,"
			"REUSE/S,"
			"NOREUSE/S,"
			"SHOWFAIL/S,"
			"NOSHOWFAIL/S,"
			"AREGCHECK/S,"
			"NOAREGCHECK/S,"
			"DREGCHECK/S,"
			"NODREGCHECK/S,"
			"STACKCHECK/S,"
			"NOSTACKCHECK/S,"
			"CHECKORPHANED/S,"
			"NOCHECKORPHANED/S,"
			"STACKLINES/K/N,"
			"CHECKDELAY/K/N";

		memset(&params,0,sizeof(params));

		/* read the command line parameters */
		rda = ReadArgs((STRPTR)cmdTemplate,(LONG *)&params,NULL);
		if(rda != NULL)
		{
			struct WipeoutSemaphore * ws = WipeoutSemaphore;

			/* set the pre-wall allocation size */
			if(params.PreSize != NULL)
			{
				LONG value;

				value = (*params.PreSize);
				if(value < MEM_BLOCKSIZE)
					value = MEM_BLOCKSIZE;
				else if (value > 65536)
					value = 65536;

				PreWallSize = (value + MEM_BLOCKMASK) & ~MEM_BLOCKMASK;
			}

			/* set the post-wall allocation size */
			if(params.PostSize != NULL)
			{
				LONG value;

				value = (*params.PostSize);
				if(value < MEM_BLOCKSIZE)
					value = MEM_BLOCKSIZE;
				else if (value > 65536)
					value = 65536;

				PostWallSize = (value + MEM_BLOCKMASK) & ~MEM_BLOCKMASK;
			}

			/* use a special fill character? */
			if(params.FillChar != NULL)
			{
				LONG number;

				/* this can either be a decimal or a
				 * hexadecimal number; the latter is
				 * indicated by a preceding "$" or "0x"
				 */
				if(DecodeNumber(params.FillChar,&number))
				{
					if(0 <= number && number <= 255)
						SetFillChar(number);
					else
						error = ERROR_BAD_NUMBER;
				}
				else
				{
					error = ERROR_BAD_NUMBER;
				}
			}

			#ifndef __MORPHOS__
			/* enable parallel port output? */
			if(params.Parallel)
				ChooseParallelOutput();
			#endif

			/* do not show the banner message? */
			if(params.NoBanner)
				ShowBannerMessage = FALSE;

			/* remunge memory? */
			if(params.Remunge)
			{
				/* tell the semaphore owner to munge the memory */
				if(NO WipeoutSemaphoreCreated)
					SendWipeoutCmd(WIPEOUTCMD_Remunge,NULL);
			}

			/* trigger a memory check? */
			if(params.Check)
				Signal(ws->ws_WipeoutTask,SIG_Check);

			/* mark all allocations? */
			if(params.Mark)
			{
				/* tell the semaphore owner to mark the allocations */
				if(NO WipeoutSemaphoreCreated)
					SendWipeoutCmd(WIPEOUTCMD_Mark,NULL);
			}

			/* clear all allocation marks? */
			if(params.Unmark)
			{
				/* tell the semaphore owner to clear the marks */
				if(NO WipeoutSemaphoreCreated)
					SendWipeoutCmd(WIPEOUTCMD_Unmark,NULL);
			}

			/* show all unmarked allocations? */
			if(params.ShowUnmarked)
			{
				/* tell the semaphore owner to clear the marks */
				if(NO WipeoutSemaphoreCreated)
					SendWipeoutCmd(WIPEOUTCMD_ShowUnmarked,NULL);
			}

			/* put together a list of tasks to filter out
			 * when making memory allocations?
			 */
			if(params.Name != NULL)
			{
				if(WipeoutSemaphoreCreated)
				{
					/* we created the semaphore, so we can
					 * fill in the filter lists all by
					 * ourselves.
					 */
					if(CANNOT UpdateFilter(params.Name))
						error = ERROR_NO_FREE_STORE;
				}
				else
				{
					/* we did not create the semaphore,
					 * so we will have to tell the semaphore
					 * owner to update the filter lists.
					 */
					error = SendWipeoutCmd(WIPEOUTCMD_UpdateFilterList,params.Name);
				}
			}

			if(params.NameTag)
				(*ws->ws_NameTag) = TRUE;

			if(params.NoNameTag)
				(*ws->ws_NameTag) = FALSE;

			/* enable wipeout? */
			if(params.Active)
				Signal(ws->ws_WipeoutTask,SIG_Enable);

			/* disable wipeout? */
			if(params.Inactive)
				Signal(ws->ws_WipeoutTask,SIG_Disable);

			if(params.Wait)
				(*ws->ws_WaitAfterHit) = TRUE;

			if(params.NoWait)
				(*ws->ws_WaitAfterHit) = FALSE;

			if(params.ConsistenceCheck)
				(*ws->ws_CheckConsistency) = TRUE;

			if(params.NoConsistenceCheck)
				(*ws->ws_CheckConsistency) = FALSE;

			if(params.Reuse)
				(*ws->ws_NoReuse) = FALSE;

			if(params.NoReuse)
				(*ws->ws_NoReuse) = TRUE;

			if(params.ShowFail)
				(*ws->ws_ShowFail) = TRUE;

			if(params.NoShowFail)
				(*ws->ws_ShowFail) = FALSE;

			if(params.ARegCheck)
				(*ws->ws_ARegCheck) = TRUE;

			if(params.NoARegCheck)
				(*ws->ws_ARegCheck) = FALSE;

			if(params.DRegCheck)
				(*ws->ws_DRegCheck) = TRUE;

			if(params.NoDRegCheck)
				(*ws->ws_DRegCheck) = FALSE;

			if(params.StackCheck)
				(*ws->ws_StackCheck) = TRUE;

			if(params.NoStackCheck)
				(*ws->ws_StackCheck) = FALSE;

			if(params.CheckOrphaned)
				(*ws->ws_CheckOrphaned) = TRUE;

			if(params.NoCheckOrphaned)
				(*ws->ws_CheckOrphaned) = FALSE;

			if(params.StackLines != NULL)
			{
				LONG value;

				value = (*params.StackLines);
				if(value < 0)
					value = 0;

				(*ws->ws_StackLines) = value;
			}

			/* set or update the automatic check delay? */
			if(params.CheckDelay != NULL)
			{
				LONG value;

				value = (*params.CheckDelay);
				if(value < 0)
					value = 0;

				CheckDelay = value;

				/* notify the semaphore owner of the
				 * new check delay; this will automatically
				 * trigger a new memory check
				 */
				if(NO WipeoutSemaphoreCreated)
					error = SendWipeoutCmd(WIPEOUTCMD_NewCheckDelay,(APTR)CheckDelay);
			}

			FreeArgs(rda);
		}
		else
		{
			error = IoErr();
		}
	}

	if(error == OK)
	{
		/* set up the tracking lists */
		SetupPoolList();

		return(SUCCESS);
	}
	else
	{
		if(error == ERROR_OBJECT_WRONG_TYPE)
			Printf("%s: Global semaphore version mismatch; please reinstall 'Wipeout' and reboot.\n", (ULONG)ProgramName);
		else
			PrintFault(error,ProgramName);

		return(FAILURE);
	}
}

/******************************************************************************/

int wipeout_main(void)
{
	int result = RETURN_FAIL;

	/* set up all the data we need */
	if(Setup())
	{
#if 0
		DPrintf("PreSize %ld PostSize %ld\n",PreWallSize,PostWallSize);
		DPrintf("NameTag %ld WaitAfterHit %ld ConsistenceCheck %ld Reuse %ld ShowFail %ld\n",NameTag,WaitAfterHit,CheckConsistency,NoReuse,ShowFail);
		DPrintf("ARegCheck %ld DRegCheck %ld StackCheck %ld StackLines %ld CheckDelay %ld\n",ARegCheck,DRegCheck,StackCheck,StackLines,CheckDelay);
		DPrintf("CheckOrphaned %ld\n",CheckOrphaned);
#endif
		result = RETURN_OK;

		/* are we the owner of the semaphore? if
		 * so, do something useful
		 */
		if(WipeoutSemaphoreCreated)
		{
			ULONG signalsReceived;
			ULONG sigWakeup = (1UL<<WakeupSignal);
			ULONG sigTimer = (1UL<<TimerSignal);
    
			/* munge all free memory */
			if(ShowBannerMessage)
			{
				DPrintf("%s -- Traces and munges memory and detects memory trashing\n",ProgramName);
				DPrintf("Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>\n");
				DPrintf("Public Domain\n\n");

				#ifdef __MORPHOS__
				DPrintf("MorphOS port by Ilkka Lehtoranta, Harry Sintonen and Ralph Schmidt\n\n");
				#endif

				DPrintf("Munging memory... ");
			}

			BeginMemMung();

			if(ShowBannerMessage)
			{
				struct timeval tv;

				Forbid();
				GetSysTime(&tv);
				ConvertTimeAndDate(&tv,GlobalDateTimeBuffer);
				DPrintf("done (%s).\n",GlobalDateTimeBuffer);
				Permit();
			}
	
			/* plant the monitoring patches */
			InstallPatches();

			/* if we are to check the memory list periodically,
			 * start the timer now
			 */
			if(CheckDelay > 0)
				StartTimer(CheckDelay / 10,(CheckDelay % 10) * (MILLION / 10));
    
			while(TRUE)
			{
				/* wait for something to happen */
				signalsReceived = Wait(SIG_Check | SIG_Disable | SIG_Enable | sigWakeup | sigTimer);

				/* received a command? */
				if(FLAG_IS_SET(signalsReceived,sigWakeup))
				{
					APTR parameter = WipeoutSemaphore->ws_Parameter;
					LONG error = OK;

					/* what are we to do now? */
					switch(WipeoutSemaphore->ws_Command)
					{
						/* update the filter list? */
						case WIPEOUTCMD_UpdateFilterList:

							if(CANNOT UpdateFilter((STRPTR)parameter))
								error = ERROR_NO_FREE_STORE;

							break;

						/* change the check timer delay? */
						case WIPEOUTCMD_NewCheckDelay:

							CheckDelay = (LONG)parameter;

							/* re-check the check timer delay */
							signalsReceived |= sigTimer;
							break;

						/* remunge unallocated memory? */
						case WIPEOUTCMD_Remunge:

							DPrintf("Remunging memory... ");
							BeginMemMung();
							DPrintf("done.\n");

							break;

						/* mark all "current" memory allocations? */
						case WIPEOUTCMD_Mark:

							DPrintf("Marking memory... ");
							ChangeMemoryMarks(TRUE);
							ChangePuddleMarks(TRUE);
							DPrintf("done.\n");
							break;

						/* clear all memory marks? */
						case WIPEOUTCMD_Unmark:

							DPrintf("Clearing memory marks... ");
							ChangeMemoryMarks(FALSE);
							ChangePuddleMarks(FALSE);
							DPrintf("done.\n");
							break;

						/* show all memory marks? */
						case WIPEOUTCMD_ShowUnmarked:

							DPrintf("%s\nShowing all unmarked memory allocations\n",Separator);
							ShowUnmarkedMemory();
							ShowUnmarkedPools();
							DPrintf("%s\n\n",Separator);
							break;
					}
    
					/* let the client task go */
					WipeoutSemaphore->ws_Error = error;
					Signal(WipeoutSemaphore->ws_Client,SIG_Handshake);
				}
    
				/* start or stop the timer, depending on the
				 * check delay length
				 */
				if(FLAG_IS_SET(signalsReceived,sigTimer))
				{
					if(CheckDelay > 0)
					{
						StartTimer(CheckDelay / 10,(CheckDelay % 10) * (MILLION / 10));

						signalsReceived |= SIG_Check;
					}
					else
					{
						StopTimer();
					}
				}

				/* check all memory allocations */
				if(FLAG_IS_SET(signalsReceived,SIG_Check))
				{
					struct timeval tv;

					Forbid();

					GetSysTime(&tv);
					ConvertTimeAndDate(&tv,GlobalDateTimeBuffer);

					DPrintf("%s\nChecking all memory allocations (%s)\n%s\n",
						Separator,GlobalDateTimeBuffer,Separator);

					CheckAllocatedMemory();
					CheckPools();
					CheckFilter();

					DPrintf("%s\n\n",Separator);

					Permit();
				}
    
				/* stop monitoring memory allocations */
				if(FLAG_IS_SET(signalsReceived,SIG_Disable))
				{
					if(IsActive)
					{
						struct timeval tv;
	
						Forbid();
	
						GetSysTime(&tv);
						ConvertTimeAndDate(&tv,GlobalDateTimeBuffer);
	
						DPrintf("%s\n%s deactivated (%s)\n%s\n",
							Separator,ProgramName,GlobalDateTimeBuffer,Separator);
	
						IsActive = FALSE;
	
						Permit();
					}
				}
    
				/* restart monitoring memory allocations */
				if(FLAG_IS_SET(signalsReceived,SIG_Enable))
				{
					if(NOT IsActive)
					{
						struct timeval tv;

						Forbid();

						GetSysTime(&tv);
						ConvertTimeAndDate(&tv,GlobalDateTimeBuffer);

						DPrintf("%s\n%s activated (%s)\n%s\n",
							Separator,ProgramName,GlobalDateTimeBuffer,Separator);

						IsActive = TRUE;

						Permit();
					}
				}
    		}
		}
	}

	/* note that we never arrive here if we are the owner
	 * of the wipeout semaphore
	 */
	Cleanup();

	return(result);
}
