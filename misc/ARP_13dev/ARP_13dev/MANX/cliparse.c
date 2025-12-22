/* Copyright (C) 1986,1987 by Manx Software Systems, Inc. */

/*
 *	This routine is called from the _main() routine and is used to
 *	parse the arguments passed from the CLI to the program. It sets
 *	up an array of pointers to arguments in the global variables and
 *	and sets up _argc and _argv which will be passed by _main() to
 *	the main() procedure. If no arguments are ever going to be
 *	parsed, this routine may be replaced by a stub routine to reduce
 *	program size.
 *
 *	If _arg_lin is non-zero, the _exit() routine will call FreeMem()
 *	with _arg_lin as the memory to free and _arg_len as the size.
 *
 */

#include <libraries/dosextens.h>

extern int _argc;
extern char **_argv;
extern char *_detach_name;			/* for DETACHED programs */

_cli_parse(pp, alen, aptr)
struct Process *pp;
long alen;
register char *aptr;
{
	register char *cp;
	register struct CommandLineInterface *cli;
	register int c;
	void *ArpAlloc();
	int _arg_len;
	char *_arg_lin;

	if (pp->pr_CLI) {
		cli = (struct CommandLineInterface *) ((long)pp->pr_CLI << 2);
		cp = (char *)((long)cli->cli_CommandName << 2);
	}
	else
		cp = _detach_name;
	_arg_len = cp[0]+alen+2;
	if ((_arg_lin = ArpAlloc((long)_arg_len)) == 0) ArpExit(20L,ERROR_NO_FREE_STORE);

	c = cp[0];
	strncpy(_arg_lin, cp+1, c);
	strcpy(_arg_lin+c, " ");
	strncat(_arg_lin, aptr, (int)alen);
	_arg_lin[c] = 0;
	for (_argc=1,aptr=cp=_arg_lin+c+1;;_argc++) {
		while ((c=*cp) == ' ' || c == '\t' || c == '\f' ||
												c == '\r' || c == '\n')
			cp++;
		if (*cp < ' ')
			break;
		if (*cp == '"') {
			cp++;
			while (c = *cp++) {
				*aptr++ = c;
				if (c == '"') {
					if (*cp == '"')
						cp++;
					else {
						aptr[-1] = 0;
						break;
					}
				}
			}
		}
		else {
			while ((c=*cp++) && c != ' ' && c != '\t' && c != '\f' &&
												c != '\r' && c != '\n')
				*aptr++ = c;
			*aptr++ = 0;
		}
		if (c == 0)
			--cp;
	}
	*aptr = 0;
	if ((_argv = ArpAlloc((long)(_argc+1)*sizeof(*_argv))) == 0) {
		ArpExit(20L, ERROR_NO_FREE_STORE);
	}
	for (c=0,cp=_arg_lin;c<_argc;c++) {
		_argv[c] = cp;
		cp += strlen(cp) + 1;
	}
	_argv[c] = 0;
}

