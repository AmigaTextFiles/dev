/*
 * $Id: startup.c,v 1.1 2009/06/14 22:03:58 itix Exp $
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

struct ExecBase   *SysBase;
struct DosLibrary *DOSBase;
struct Library    *UtilityBase;

/******************************************************************************/

int start(void)
{
	struct WBStartup *wbmsg;
	struct Process *pr;
	int rc;

	SysBase	= *((APTR *)4);
	pr = (APTR)FindTask(NULL);

	wbmsg = NULL;
	rc = RETURN_FAIL;

	if (pr->pr_CLI == 0)
	{
		WaitPort(&pr->pr_MsgPort);
		wbmsg = (APTR)GetMsg(&pr->pr_MsgPort);
	}

	if ((DOSBase = (APTR)OpenLibrary("dos.library", 36)))
	{
		if ((UtilityBase = OpenLibrary("utility.library", 36)))
		{
			wipeout_main();

			CloseLibrary(UtilityBase);
		}

		CloseLibrary((struct Library *)DOSBase);
	}

	if (wbmsg)
	{
		/* Forbid(); */
		ReplyMsg((struct Message *)wbmsg);
	}

	return rc;
}

const ULONG __abox__ __TEXTSEGMENT__ = 1;
