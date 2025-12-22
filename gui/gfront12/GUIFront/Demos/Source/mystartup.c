
/* Tinystartup.c - some very crude startup code for SAS/C */

#include <proto/exec.h>
#include <proto/dos.h>
#include <workbench/startup.h>
#include <dos/dosextens.h>

struct ExecBase *SysBase;
struct DosLibrary *DOSBase;

extern main(void);

__saveds startup(void)
{
	int rv = 0;

	SysBase = *((struct ExecBase **)4);

	if (DOSBase = (struct DosLibrary *)OpenLibrary("dos.library",36))
	{
		struct WBStartup *WBenchMsg;
		struct Process *pr;

		pr = (struct Process *)FindTask(0);
		if (!pr->pr_CLI)
		{
			WaitPort(&pr->pr_MsgPort);
			WBenchMsg = (struct WBStartup *)GetMsg(&pr->pr_MsgPort);
		}

		rv = main();

		CloseLibrary((struct Library *)DOSBase);

		if (!pr->pr_CLI)
		{
			Forbid();
			ReplyMsg((struct Message *)WBenchMsg);
		}
	}

	return(rv);
}
