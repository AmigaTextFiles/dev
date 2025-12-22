/*
 * $Id: main.c 1.8 1999/06/27 09:52:19 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

#include "Blowup_rev.h"

/******************************************************************************/

#include "blowupsemaphore.h"

/******************************************************************************/

const STRPTR VersTag = VERSTAG;

/******************************************************************************/

STATIC BOOL ShowBannerMessage = TRUE;

/******************************************************************************/

STATIC struct BlowupSemaphore *	BlowupSemaphore;
STATIC BOOL						BlowupSemaphoreCreated;

/******************************************************************************/

STATIC struct BlowupSemaphore *
FindBlowupSemaphore(VOID)
{
	struct BlowupSemaphore * bs;

	/* look for the semaphore; this call must be made under Forbid() */
	bs = (struct BlowupSemaphore *)FindSemaphore(BLOWUPSEMAPHORENAME);

	return(bs);
}

STATIC VOID
DeleteBlowupSemaphore(struct BlowupSemaphore * bs)
{
	if(bs != NULL)
	{
		Forbid();

		/* gain exclusive access to the semaphore and remove it */
		RemSemaphore((struct SignalSemaphore *)bs);

		ObtainSemaphore((struct SignalSemaphore *)bs);
		ReleaseSemaphore((struct SignalSemaphore *)bs);

		Permit();

		/* release the memory allocated for the semaphore */
		FreeMem(bs,sizeof(*bs));
	}
}

STATIC struct BlowupSemaphore *
CreateBlowupSemaphore(VOID)
{
	struct BlowupSemaphore * bs;

	/* allocate memory for the semaphore and initialize it */
	bs = AllocMem(sizeof(*bs),MEMF_ANY|MEMF_PUBLIC|MEMF_CLEAR);
	if(bs != NULL)
	{
		bs->bs_SignalSemaphore.ss_Link.ln_Name	= bs->bs_SemaphoreName;
		bs->bs_SignalSemaphore.ss_Link.ln_Pri	= 1;

		bs->bs_Version = BLOWUPSEMAPHOREVERSION;

		strcpy(bs->bs_SemaphoreName,BLOWUPSEMAPHORENAME);

		bs->bs_Owner		= FindTask(NULL);
		bs->bs_ARegCheck	= &ARegCheck;
		bs->bs_DRegCheck	= &DRegCheck;
		bs->bs_StackCheck	= &StackCheck;
		bs->bs_StackLines	= &StackLines;

		/* add the semaphore to the public list */
		AddSemaphore((struct SignalSemaphore *)bs);
	}

	return(bs);
}

/******************************************************************************/

STATIC VOID
Cleanup(VOID)
{
	/* delete the semaphore, if we created it */
	if(BlowupSemaphoreCreated)
	{
		DeleteBlowupSemaphore(BlowupSemaphore);
		BlowupSemaphore = NULL;
	}

	/* release the semaphore; this is done only if we did
	 * not create the semaphore ourselves
	 */
	if(BlowupSemaphore != NULL)
	{
		ReleaseSemaphore((struct SignalSemaphore *)BlowupSemaphore);
		BlowupSemaphore = NULL;
	}

	/* shut down the timer */
	DeleteTimer();

	/* close intuition.library */
	if(IntuitionBase != NULL)
	{
		CloseLibrary(IntuitionBase);
		IntuitionBase = NULL;
	}

	/* close utility.library, if this is necessary */
	#if !defined(__SASC) || defined(_M68020)
	{
		if(UtilityBase != NULL)
		{
			CloseLibrary(UtilityBase);
			UtilityBase = NULL;
		}
	}
	#endif
}

STATIC BOOL
Setup(BOOL * offPtr)
{
	LONG error = OK;
	int i;

	(*offPtr) = FALSE;

	/* Kickstart 2.04 or higher required */
	if(SysBase->LibNode.lib_Version < 37)
	{
		const STRPTR message = "This program requires Kickstart 2.04 or better.\n";

		Write(Output(),message,strlen(message));
		return(FAILURE);
	}

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

	/* set up the busy semaphore */
	InitSemaphore(&BusySemaphore);

	/* open intuition.library */
	IntuitionBase = OpenLibrary("intuition.library",37);
	if(IntuitionBase == NULL)
	{
		Printf("%s: Could not open intuition.library V37.\n",ProgramName);
		return(FAILURE);
	}

	/* open utility.library, if this is necessary */
	#if !defined(__SASC) || defined(_M68020)
	{
		UtilityBase = OpenLibrary("utility.library",37);
		if(UtilityBase == NULL)
		{
			Printf("%s: Could not open utility.library V37.\n",ProgramName);
			return(FAILURE);
		}
	}
	#endif

	/* allocate the timer data */
	if(CreateTimer() == -1)
	{
		Printf("%s: Could not create timer.\n",ProgramName);
		return(FAILURE);
	}

	/* initialize default options */
	DRegCheck	= FALSE;
	ARegCheck	= FALSE;
	StackCheck	= FALSE;
	StackLines	= 2;

	/* rendezvous with the global semaphore or create it */
	Forbid();

	BlowupSemaphore = FindBlowupSemaphore();
	if(BlowupSemaphore != NULL)
	{
		ObtainSemaphore((struct SignalSemaphore *)BlowupSemaphore);
	}
	else
	{
		BlowupSemaphore = CreateBlowupSemaphore();
		if(BlowupSemaphore != NULL)
		{
			BlowupSemaphoreCreated = TRUE;
		}
		else
		{
			error = ERROR_NO_FREE_STORE;
		}
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
			SWITCH	Off;
			SWITCH	Parallel;
			SWITCH	NoBanner;
			SWITCH	DRegCheck;
			SWITCH	NoDRegCheck;
			SWITCH	ARegCheck;
			SWITCH	NoARegCheck;
			SWITCH	StackCheck;
			SWITCH	NoStackCheck;
			NUMBER	StackLines;
		} params;

		/* this is the command template, as required by ReadArgs() below;
		 * its contents must match the "params" data structure above
		 */
		const STRPTR cmdTemplate =
			"QUIT=OFF/S,"
			"PARALLEL/S,"
			"QUIET=NOBANNER/S,"
			"DREGCHECK/S,"
			"NODREGCHECK/S,"
			"AREGCHECK/S,"
			"NOAREGCHECK/S,"
			"STACKCHECK/S,"
			"NOSTACKCHECK/S,"
			"STACKLINES/K/N";

		memset(&params,0,sizeof(params));

		/* read the command line parameters */
		rda = ReadArgs((STRPTR)cmdTemplate,(LONG *)&params,NULL);
		if(rda != NULL)
		{
			struct BlowupSemaphore * bs = BlowupSemaphore;

			/* shut down Blowup? */
			if(params.Off)
			{
				if(NOT BlowupSemaphoreCreated)
				{
					Signal(bs->bs_Owner,SIG_Stop);
				}

				(*offPtr) = TRUE;
			}

			/* enable parallel port output? */
			if(params.Parallel)
			{
				ChooseParallelOutput();
			}

			/* do not show the banner message? */
			if(params.NoBanner)
			{
				ShowBannerMessage = FALSE;
			}

			/* enable data register check? */
			if(params.DRegCheck)
			{
				(*bs->bs_DRegCheck) = TRUE;
			}

			/* disable data register check? */
			if(params.NoDRegCheck)
			{
				(*bs->bs_DRegCheck) = FALSE;
			}

			/* enable address register check? */
			if(params.ARegCheck)
			{
				(*bs->bs_ARegCheck) = TRUE;
			}

			/* disable address register check? */
			if(params.NoARegCheck)
			{
				(*bs->bs_ARegCheck) = FALSE;
			}

			/* enable stack check? */
			if(params.StackCheck)
			{
				(*bs->bs_StackCheck) = TRUE;
			}

			/* disable stack check? */
			if(params.NoStackCheck)
			{
				(*bs->bs_StackCheck) = FALSE;
			}

			/* set the number of stack lines to display? */
			if(params.StackLines != NULL)
			{
				LONG value;

				value = (*params.StackLines);
				if(value < 0)
					value = 0;

				(*bs->bs_StackLines) = value;
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
		return(SUCCESS);
	}
	else
	{
		PrintFault(error,ProgramName);

		return(FAILURE);
	}
}

/******************************************************************************/

int
main(
	int		argc,
	char **	argv)
{
	int result = RETURN_FAIL;
	BOOL switchedOff;

	/* set up all the data we need */
	if(Setup(&switchedOff))
	{
		result = RETURN_OK;

		if(NOT switchedOff)
		{
			/* do something useful if we are the owner of the semaphore */
			if(BlowupSemaphoreCreated)
			{
				BOOL done;
		    
				/* show the welcome message */
				if(ShowBannerMessage)
				{
					DPrintf("%s -- Catches and displays task errors\n",ProgramName);
					DPrintf("Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>\n");
					DPrintf("Public Domain\n");
				}

				Forbid();

				/* plant the monitoring patches */
				AddPatches();

				done = FALSE;
				do
				{
					/* wait for something to happen */
					if(FLAG_IS_SET(Wait(SIG_Stop),SIG_Stop))
					{
						done = TRUE;

						/* wait until it is safe to quit */
						ObtainSemaphore(&BusySemaphore);

						DPrintf("%s terminated.\n",ProgramName);
					}
		    	}
		    	while(NOT done);

				/* remove the patches again */
				RemovePatches();

				Permit();
			}
		}
	}

	Cleanup();

	return(result);
}
