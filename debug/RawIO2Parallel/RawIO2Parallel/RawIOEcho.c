#include <exec/exec.h>
#include <dos/dos.h>

#include <proto/exec.h>
#include <proto/dos.h>
// Redefining inline to pass string pointer in adress register to make vbcc
// emit pc-relative code, thus avoiding relocations
struct RDArgs * __pcrel_ReadArgs(__reg("a6") void *, __reg("a0") CONST_STRPTR arg_template, __reg("d2") LONG * array, __reg("d3") struct RDArgs * args)="\tmove.l\ta0,d1\n\tjsr\t-798(a6)";
#undef ReadArgs
#define ReadArgs(arg_template, array, args) __pcrel_ReadArgs(DOSBase, (arg_template), (array), (args))

#include <stdbool.h>

#include "MinimalDebug.h"

const char Version[] = "$VER: RawIOEcho 1.1 (24.10.2022) by Patrik Axelsson";

LONG RawIOEcho(__reg("d0") LONG dosCmdLen, __reg("a0") char *dosCmdBuf) {
	struct ExecBase *SysBase = *(struct ExecBase **) 4;
	// If started from Workbench through an .info file, get and reply to the
	// startup message and exit to not crash or use up workbench resources.
	//
	// I only added this because I added an .info file for this command to
	// the release archive.
	//
	// This would not have been a concern in 2.0+ as the .info file has the
	// CLI tooltype, so the user gets a prompt and can enter what to echo
	// and it is started as a proper CLI command.
	//
	// However, in 1.x, the CLI tooltype does not work so this is needed.
	struct Process *thisProcess = (void *) SysBase->ThisTask;
	if (0 == thisProcess->pr_CLI) {
		WaitPort(&thisProcess->pr_MsgPort);
		struct WBStartup *wbStartupMsg = (void *) GetMsg(&thisProcess->pr_MsgPort);
		Forbid();
		ReplyMsg((void *) wbStartupMsg);
		return RETURN_OK;
	}

	LONG retVal = RETURN_FAIL;
	
	struct RDArgs *argsResult = NULL;
	struct DosLibrary *DOSBase = (void *) OpenLibrary("dos.library", 0);
	if (NULL == DOSBase) {
		goto cleanup;
	}

	const char *dosCmdStrings[] = {dosCmdBuf, NULL};
	struct {
		const char **strings;
		const void *noLine;
	} args = { 0 };

	if (DOSBase->dl_lib.lib_Version >= 36) {
		argsResult = ReadArgs("/M,NOLINE/S", (void *) &args, NULL);
		if (NULL == argsResult) {
			PrintFault(IoErr(), NULL);
			goto cleanup;
		}
	}
	else {
		if (dosCmdLen > 1) {
			args.strings = dosCmdStrings;
			// A newline is always included, but 1.x does not always
			// terminate the string with a zero, so overwrite the
			// newline with a zero to be sure to not write after the
			// allocated space plus then we can use the default
			// behaviour of args.noLine to print the newline instead.
			dosCmdBuf[dosCmdLen - 1] = '\0';
		}
	}

	if (NULL != args.strings) {
		const char **strings = args.strings;
		const char *string = *strings++;
		if (NULL != string) {
			while (true) {
				KPutStr(string);
				string = *strings++;
				if (NULL == string) {
					break;
				}
				KPutChar(' ');
			}
			if (!args.noLine) {
				KPutChar('\n');
			}
		}
	}

	retVal = RETURN_OK;

cleanup:
	if (NULL != argsResult) {
		FreeArgs(argsResult);
	}
	if (NULL != DOSBase) {
		CloseLibrary((void *) DOSBase);
	}

	return retVal;
}

