/* Copyright (C) 1986,1987 by Manx Software Systems, Inc. */

/*
 *	This routine is called from the _main() routine and is used to
 *	open a window for standard I/O to use. The window is actually
 *	defined by setting the ToolType, "WINDOW", to the desired window
 *	specification. If this is not required, this routine may be
 *	replaced by a stub in the users main program. Note that even if
 *	this code is called by _main(), if the WINDOW tool type is not
 *	defined, there will be no window.
 *
 *	EXAMPLE:	WINDOW=CON:0/0/640/200/Test Window
 */

/* tweeked to handle v1.4 wbench startup */

#include <libraries/dosextens.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>
#include <workbench/icon.h>

#include <fcntl.h>

void *IconBase;

_wb_parse(pp, wbm)
register struct Process *pp;
struct WBStartup *wbm;
{
	register char *cp;
	register struct DiskObject *dop;
	register struct FileHandle *fhp;
	register long wind;
	void *_OpenLibrary();
	long _Open();

	if ((IconBase = _OpenLibrary("icon.library", 0L)) == 0)
		return;
	if ((dop = GetDiskObject(wbm->sm_ArgList->wa_Name)) == 0)
		goto closeit;
	if (cp = FindToolType(dop->do_ToolTypes, "WINDOW")) {
		if (wind = _Open(cp, MODE_OLDFILE)) {
			fhp = (struct FileHandle *) (wind << 2);
			pp->pr_ConsoleTask = (APTR) fhp->fh_Type;
			pp->pr_CIS = (BPTR)wind;
			pp->pr_COS = (BPTR)_Open("*", MODE_OLDFILE);
		     /* !!! 1.4 tweek */
			_devtab[0].mode &= ~O_STDIO;	/* setup for exit to close these if we succeeded */
			_devtab[1].mode &= ~O_STDIO;
		     /* !!! 1.4 tweek */
		}
	}
	FreeDiskObject(dop);
closeit:
	CloseLibrary(IconBase);
	IconBase = 0;
}

