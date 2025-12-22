#include <exec/exec.h>
#include <dos/dos.h>
#include <dos/dosextens.h>
#include <workbench/startup.h>

#include <proto/exec.h>
#include <proto/dos.h>

#include "RawIO2Parallel.h"


LONG Startup(void) {
	struct ExecBase *SysBase = *(struct ExecBase **) 4;

	struct WBStartup *wbStartupMsg = NULL;
	struct Process *thisProcess = (struct Process *) FindTask(NULL);
	struct CommandLineInterface *cli = (void *) BADDR(thisProcess->pr_CLI);
	if (NULL == cli) {
		// If started from Workbench, get the startup message
		WaitPort(&thisProcess->pr_MsgPort);
		wbStartupMsg = (void *) GetMsg(&thisProcess->pr_MsgPort);
		// Make our seglist stay in memory after exit, so patch code can
		// continue to execute
		wbStartupMsg->sm_Segment = NULL;
	}
	else {
		// Make our seglist stay in memory after exit, so patch code can
		// continue to execute
		cli->cli_Module = NULL;
	}

	RawIO2Parallel(SysBase);

	if(NULL != wbStartupMsg) {
		Forbid();
		// If started from Workbench, reply to the startup message
		ReplyMsg((struct Message *) wbStartupMsg);
	}

	return RETURN_OK;
}
