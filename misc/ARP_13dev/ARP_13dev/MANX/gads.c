/* Created 11/08/87 by -=+SDB+=- from cliparse.c provided by Manx */
/* Copyright (C) 1987 by Scott Ballantyne */
/* May be freely used by arp supporters/users */

/* This routine is called from _main() and parses the arguments passed from
 * the CLI to the program.  It uses the ARP tracking functions to allocate
 * memory for the argv array, and sets up _argc and _argv (using GADS)
 * which will eventually be passed as parameters to main().
 *
 * It uses the Global variables CLI_Template and CLI_Help to set the command
 * templates and extra help string for GADS() - if you don't set these up
 * yourself, you get the defaults.
 */

#include <libraries/dosextens.h>

extern int _argc;
extern char **_argv;
extern char *CLI_Template;
extern char *CLI_Help;
extern char *_detach_name;			/* for DETACHED programs */

_cli_parse(pp, alen, aptr)
struct Process *pp;
long alen;
char *aptr;
{
	register char *cp;
	register struct CommandLineInterface *cli;
	register char *c;
	register int argcount;
	int length;
	void *ArpAlloc();
	long GADS();

	if (pp->pr_CLI) {
		cli = (struct CommandLineInterface *) ((long)pp->pr_CLI << 2);
		cp = (char *)((long)cli->cli_CommandName << 2);
	}
	else
		cp = _detach_name;

	length = cp[0]; 		/* Length of command name */

	/* argcount *must* start at 3, do not change this.
	 * we need one for argv[0] = progname, and GADS() always
	 * requires one arg entry (for error messages, etc.)
	 * Then it is quasi standard for 'C' to have a final NULL as
	 * the argv array...
	 */
	for (argcount = 3, c = CLI_Template; *c; c++ ) /* Size we need for argv */
		if (*c == ',')
			argcount++;

	if ((c = ArpAlloc((long)length)) == 0)  /* Get mem for name */
		ArpExit(20L, ERROR_NO_FREE_STORE);
	strncpy(c, cp+1, cp[0]);

	if ( (_argv = ArpAlloc( (long)(argcount * sizeof(*_argv)))) == 0)
		ArpExit(20L, ERROR_NO_FREE_STORE);

	_argv[0] = c;
	_argc = (int)GADS(aptr, alen, CLI_Help, (_argv+1), CLI_Template);
	if (_argc < 0 )
	{
		Printf("Bad Args for %s: %s\n", _argv[0], _argv[1] );
		ArpExit(20L, ERROR_LINE_TOO_LONG);
	}
	_argc++;

#if 0
	if (GADS(aptr, alen, CLI_Help, (_argv+1), CLI_Template) < 0) {
		Printf("Bad Args for %s: %s\n", _argv[0], _argv[1] );
		ArpExit(20L, ERROR_LINE_TOO_LONG);
	}

	_argc = countargs(argcount-1,_argv);
#endif
}

#if 0

static
countargs (argc,argv)
register int argc;
register char **argv;
{
    argv += argc;

    while (--argc)
	if (*(--argv)) break;

    return argc+1;
}

#endif
