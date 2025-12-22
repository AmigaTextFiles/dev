#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/wait.h>
#include <signal.h>
#include "global.h"
#include "config.h"

bool		usage_only, unique_vars, tdmap_fmt;
char		*sourcefile;

static bool issource (char *f)
{
	char *e = f + strlen (f) - 1;
	if (*(e-1) == '.')
		return *e == 'c' || *e == 'h' || *e == 'C' || *e == 'i';
	return *(e-3) == '.' && (*(e-2) == 'c' || *(e-2) == 'C');
}

static void openout (char *f)
{
	if (!f) return;
	char *c = (char*) alloca (strlen (f) + sizeof OUTPUT_EXT);
	freopen (strcat (strcpy (c, f), OUTPUT_EXT), "w", stdout);
}

static void RUN (char *outfile, char **argv)
{
	int i;
	fprintf (stderr, "Running: ");
	for (i = 0; argv [i]; i++)
		fprintf (stderr, "%s ", argv [i]);
	fprintf (stderr, "\n");

	int pid = fork ();
	if (pid == 0) {
		if (outfile) if(!freopen (outfile, "w", stdout))
			exit (127);
		execvp (argv [0], argv);
		exit (127);
	}
	waitpid (pid, NULL, 0);
}

const char help [] =
"ncc 0.5  -  The new generation C compiler\n"
"The user is the only one responsible for any damages\n"
"Written by Stelios Xanthakis\n"
"Homepage: http://students.ceid.upatras.gr/~sxanth/ncc/\n"
"\n"
"Options starting with '-nc' are ncc options, while the rest gcc:\n"
"	-ncgcc : also run gcc compiler (produces useful object file)\n"
"	-nccc : compile and produce virtual bytecode\n"
"	-ncmv : display all uses of variables (not once per function)\n"
"	-ncoo : write the output to sourcefile.c"OUTPUT_EXT"\n"
"	-mc2dm : produce output suitable for the 2dmap viewer\n"
"	-nc00 : do not include constant values (faster)\n"
;

void preproc (int argc, char**argv)
{
	char **gccopt, **cppopt, **nccopt, **files, **nofileopt;
	int gccno, cppno, nccno, filesno, nofileno, i;
	cppopt = (char**) alloca ((8 + argc) * sizeof (char*));
	nccopt = (char**) alloca ((3 + argc) * sizeof (char*));
	gccopt = (char**) alloca ((3 + argc) * sizeof (char*));
	files = (char**) alloca (argc * sizeof (char*));
	nofileopt = (char**) alloca ((3 + argc) * sizeof (char*));
	gccopt [0] = "gcc";
	cppopt [0] = "gcc";
	cppopt [1] = "-E";
	cppopt [2] = "-D__NCC__";
	cppopt [3] = "-imacros";
	cppopt [4] = NOGNU_MACROS;
	nofileopt [0] = "ncc";
	files [0] = NULL;
	cppno = 5;
	gccno = 1;
	nccno = 0;
	nofileno = 1;
	filesno = 0;
	for (i = 1; i < argc; i++)
		if (argv [i][0] == '-' && argv [i][1] == 'n'
		&& argv [i][2] == 'c')
			nccopt [nccno++] =
			 (nofileopt [nofileno++] = argv[i]) + 3;
		else {
			gccopt [gccno++] = argv [i];
			if (issource (argv [i]))
				cppopt [cppno++] = files [filesno++] = argv [i];
			else {
				nofileopt [nofileno++] = argv [i];
				if (argv [i][0] == '-')
				if (argv [i][1] == 'D' || argv [i][1] == 'I')
					cppopt [cppno++] = argv [i];
			}
		}
	nccopt [nccno] = gccopt [gccno] = cppopt [cppno] = NULL;

	if (filesno > 1) {
		int i;
		fprintf (stderr, "Multiple files. Forking\n");
		nofileopt [nofileno + 1] = NULL;
		for (i = 0; i < filesno; i++) {
			nofileopt [nofileno] = files [i];
			RUN (NULL, nofileopt);
		}
		exit (0);
	}

	tdmap_fmt = false;
	include_values = usage_only = unique_vars = true;
	for (i = 0; i < nccno; i++)
		if (!strcmp (nccopt [i], "gcc")) RUN (NULL, gccopt);
		else if (!strcmp (nccopt [i], "cc")) usage_only = false;
		else if (!strcmp (nccopt [i], "mv")) unique_vars = false;
		else if (!strcmp (nccopt [i], "oo")) openout (files [0]);
		else if (!strcmp (nccopt [i], "2dm")) tdmap_fmt = true;
		else if (!strcmp (nccopt [i], "00")) include_values = false;
		else {
			fputs (help, stderr);
			exit (0);
		}

	if (!(sourcefile = files [0])) {
		fprintf (stderr, "No C source file\n");
		exit (0);
	}

	if (usage_only) set_usage_report ();
	else set_compilation ();

	RUN (PREPROCESSOR_OUTPUT, cppopt);
}
