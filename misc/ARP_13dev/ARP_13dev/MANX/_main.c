/* Created 11/08/87 by -=+SDB+=- from file _main.c provided by Manx */
/* Copyright (C) 1987 by Scott Ballantyne */
/* May be freely used by ARP users/supporters */
/* Memory is allocated for the MANX device buffers, etc., but the
 * ARP tracking functions are used.
 * tweeked for v39
 * further tweeked to handle v1.4 workbench startup
 */

#include <exec/alerts.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <libraries/arpbase.h>
#include <libraries/dosextens.h>
#include <workbench/startup.h>
#include <functions.h>
#include <fcntl.h>

extern long _savsp, _stkbase;

extern int errno, Enable_Abort;

extern int _argc;
extern char **_argv;
extern struct WBStartup *WBenchMsg;

extern struct _dev *_devtab;
extern short _numdev;

extern struct ArpBase *ArpBase;
extern void *IntuitionBase, *GfxBase, *DOSBase;


/* !!! alot of things here depend on receiving WBenchMsg before opening arp.library */

#ifdef DETACH
static long _alen = 0;
#endif

_main(alen, aptr)
long alen;
char *aptr;
{
	register struct Process *pp, *_FindTask();
	void *_GetMsg();
	long _Input(), _Output(), _Open();

	pp = _FindTask(0L);
	if (!pp->pr_CLI
#ifdef DETACH
	    && !_alen	    /* !!! alen is here because pr_CLI is NULL for bg task, but _alen (hopefully) isn't */
#endif
	) {
		_WaitPort(&pp->pr_MsgPort);
		WBenchMsg = _GetMsg(&pp->pr_MsgPort);
	}

	if (!(ArpBase = (struct ArpBase *)OpenLibrary (ArpName,ArpVersion))) {
		complain();
		_Forbid();
		if (WBenchMsg) _ReplyMsg (WBenchMsg);
		return 20;
	}

	DOSBase = ArpBase->DosBase;
	GfxBase = ArpBase->GfxBase;
	IntuitionBase = ArpBase->IntuiBase;

#ifdef DETACH
	{
	    void do_detach();

	    if (!WBenchMsg) do_detach(&alen, &aptr);
	}
#endif

	if ( (_devtab = ArpAlloc( _numdev*(long)sizeof(struct _dev))) == 0)
	{
		Alert(AG_NoMemory, 0L);
		ArpExit(20L, ERROR_NO_FREE_STORE );
	}

	_devtab[0].mode = O_RDONLY;
	_devtab[1].mode = _devtab[2].mode = O_WRONLY;

	_stkbase = _savsp - *((long *)_savsp+1) + 8;
	*(long *)_stkbase = 0x4d414e58L;

	if (!WBenchMsg) {
		_cli_parse(pp, alen, aptr);
		Enable_Abort = 1;
#ifndef DETACH
		_devtab[0].mode |= O_STDIO;		/* shouldn't close if CLI */
		_devtab[1].mode |= O_STDIO;
#endif
	      /* !!! wb 1.4 tweek */
		_devtab[0].fd = _Input();
		if (_devtab[1].fd = _Output())
			_devtab[2].fd = _Open("*", MODE_OLDFILE);
	      /* !!! wb 1.4 tweek */
	}
	else {
	      /* !!! wb 1.4 tweek */
		_devtab[0].mode |= O_STDIO;		/* shouldn't close if WB opened something for us */
		_devtab[1].mode |= O_STDIO;
		_devtab[2].mode |= O_STDIO;
	      /* !!! wb 1.4 tweek */

		if (WBenchMsg->sm_ArgList)
			_CurrentDir(WBenchMsg->sm_ArgList->wa_Lock);
		_wb_parse(pp, WBenchMsg);
		_argv = (char **)WBenchMsg;

	      /* !!! wb 1.4 tweek */
		_devtab[0].fd = _Input();
		_devtab[1].fd = _devtab[2].fd = _Output();
	      /* !!! wb 1.4 tweek */
	}
	main(_argc, _argv);
	exit(0);        /* Need to also close files, etc. */
}


#if (int)ArpVersion != 39
    !!! this needs fixing!
#endif

static
complain()
{
    long _Output(), output;
    static char complaint1[] = "You need arp.library V39+";
    static char complaint2[] = "\n";
    static struct IntuiText comptext = { AUTOFRONTPEN, 0, JAM1, 30, 15, NULL, (void *)complaint1 };
    static struct IntuiText oktext = { AUTOFRONTPEN, AUTOBACKPEN, AUTODRAWMODE, AUTOLEFTEDGE, AUTOTOPEDGE, NULL, (void *)"Ok" };
    struct Process *pp, *_FindTask();

    pp = _FindTask(0L);

    if (pp->pr_CLI && (DOSBase = OpenLibrary ("dos.library",LIBRARY_VERSION)) && (output = _Output())) {
	_Write (output, complaint1, (long)sizeof complaint1-1);
	_Write (output, complaint2, (long)sizeof complaint2-1);
    }
    else if (IntuitionBase = OpenLibrary ("intuition.library",LIBRARY_VERSION)) {
	AutoRequest (NULL,&comptext,NULL,&oktext,0L,0L,320L,72L);
	CloseLibrary (IntuitionBase);
    }
    else {
	Alert (AG_OpenLib | AO_ArpLib, 0L);
    }

    if (DOSBase) {
	CloseLibrary (DOSBase);
	DOSBase = NULL;
    }
}


#ifdef DETACH
extern long _stack, _priority, _BackGroundIO;
extern char *_procname;
BPTR _Backstdout = 0;
extern BPTR _detach_curdir;
extern char *_detach_name;
static char *_aptr = 0;

static void
do_detach(alen, aptr)
long *alen;
char **aptr;
{
	struct Process *pp, *_FindTask();
	void /* *sav, */ *_OpenLibrary(), *_GetMsg(), *_AllocMem();
	long _Open();
/*	  long l;  */
/*	  struct MemList *mm;  */
/*	  register unsigned short c;  */

	pp = _FindTask(0L);
	if (pp->pr_CLI) {                       /* first time through!! */
		register char *cp;
		register struct CommandLineInterface *cli;

		CurrentDir(_detach_curdir = CurrentDir(0L));
		_detach_curdir = DupLock(_detach_curdir);

		cli = (struct CommandLineInterface *) ((long)pp->pr_CLI << 2);

	    #if 0
		l = cli->cli_Module;
		if ((sav = _OpenLibrary(DOSNAME, 33L)) == 0) {

			lp = (long *)*((long *)*((long *)*((long *)*((long *)
											_savsp+2)+1)-3)-3)+107;
			if (*lp != cli->cli_Module)
				exit(100);
		}
		else {
			_CloseLibrary(sav);
			lp = 0;
		}
		if (lp)
			*lp = 0;
	    #endif

		if (_stack == 0)
			_stack = cli->cli_DefaultStack * 4;
		if (_BackGroundIO)
			_Backstdout = (BPTR)_Open("*", MODE_OLDFILE);
		_alen = *alen;

		if (!(_aptr = DosAllocMem(_alen))) goto clean;
		CopyMem(*aptr, _aptr, _alen);
		cp = (char *)((long)cli->cli_CommandName << 2);
		if (!(_detach_name = DosAllocMem((long)cp[0]+1))) goto clean;
		CopyMem(cp, _detach_name, (long)cp[0]+1);

		if (CreateProc(_procname, _priority, cli->cli_Module, _stack)) {
		    cli->cli_Module = 0;
		    ArpExit (0L);
		}

	    clean:
		if (_aptr) DosFreeMem (_aptr);
		if (_detach_name) DosFreeMem (_detach_name);
		ArpExit (20L,ERROR_NO_FREE_STORE);
	}
		    /* !!! why is this strcmp() here??? */
	else if (strcmp(pp->pr_Task.tc_Node.ln_Name, _procname) == 0) { /* second time */
		register long *lp;
		register struct DefaultTracker *tr;

		if (tr = GetTracker (TRAK_SEGLIST)) {
		    lp = (long *)((long)pp->pr_SegList << 2);
		    tr->dt_Object.dt_Resource = (CPTR)lp[3];
		}
		if (tr = GetTracker (TRAK_DAMEM))
		    tr->dt_Object.dt_Resource = (CPTR)_aptr;
		if (tr = GetTracker (TRAK_DAMEM))
		    tr->dt_Object.dt_Resource = (CPTR)_detach_name;
		if (tr = GetTracker (TRAK_LOCK))
		    tr->dt_Object.dt_Resource = (CPTR)_detach_curdir;

		CurrentDir(_detach_curdir);

		pp->pr_COS = _Backstdout;

		*alen = _alen;
		*aptr = _aptr;
	}
}
#endif
