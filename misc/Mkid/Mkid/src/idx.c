static char copyright[] = "@(#)Copyright (c) 1986, Greg McGary";
static char sccsid[] = "@(#)idx.c	1.2 86/10/17";

#include	<stdio.h>
#include	"string.h"
#include	"id.h"
#include	"extern.h"

void idxtract();

char	*MyName;
static void
usage()
{
	fprintf(stderr, "Usage: %s [-u] [+/-a<ccc>] [-c<ccc>] files\n", MyName);
	exit(1);
}
main(argc, argv)
	int		argc;
	char		**argv;
{
	char		*arg;
	int		op;
	char		*sccsDir = NULL;
	char		*rcsDir = NULL;

	MyName = basename(GETARG(argc, argv));
	while (argc) {
		arg = GETARG(argc, argv);
		switch (op = *arg++)
		{
		case '-':
		case '+':
			break;
		default:
			UNGETARG(argc, argv);
			goto argsdone;
		}
		switch (*arg++)
		{
		case 's': sccsDir = arg; break;
		case 'r': rcsDir = arg; break;
		case 'S': setScanArgs(op, arg); break;
		default: usage();
		}
	}
argsdone:

	if (argc == 0)
		usage();
	while (argc)
		idxtract(GETARG(argc, argv), sccsDir, rcsDir);
	exit(0);
}

void
idxtract(path, sccsDir, rcsDir)
	char		*path;
	char		*sccsDir;
	char		*rcsDir;
{
	register char	*key;
	register char	*(*getId)();
	register FILE	*srcFILE;
	char		*(*getScanner())();
	int		flags;

	if ((getId = getScanner(getLanguage(strrchr(path, '.')))) == NULL)
		return;
	if ((srcFILE = openSrcFILE(path, sccsDir, rcsDir)) == NULL)
		return;

	while ((key = (*getId)(srcFILE, &flags)) != NULL)
		puts(key);

	fclose(srcFILE);
}
