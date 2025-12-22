#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <ctype.h>

#include "global.h"


class ncci * ncc;

//
int*		CODE;
int		C_Ntok;
char**		C_Syms;
int		C_Nsyms;
char**		C_Strings;
int		C_Nstrings;
cfile_i*	C_Files;
int		C_Nfiles;

double*		C_Floats;
signed char*	C_Chars;
short int*	C_Shortints;
long int*	C_Ints;
unsigned long*	C_Unsigned;
// *********** --------- ***********


struct __builtins__ ccbuiltins;

int syntax_error (int i, char *c = NULL)
{
	if (c) fprintf (stderr, "{ %s }\n", c);
	debug ("syntax error:", i - 20, 110);
	exit (1);
}

int syntax_error (char *a1, char *a2)
{
	fprintf (stderr, "error: %s %s\n", a1, a2);
	exit (1);
}

int syntax_error (int i, char *p, char *t)
{
	fprintf (stderr, "Error %s --> [%s]\n", p, t);
	debug ("syntax error:", i - 20, 50);
	exit (1);
}

static	int nhe = 0;
void half_error (char *m1, char *m2)
{
#define STDDBG stderr
	if (m2) fprintf (STDDBG, "std %s %s\n", m1, m2);
	else fprintf (STDDBG, "std %s\n", m1);
	debug ("expression error:", ExpressionPtr - 10, 30);
	if (nhe++ > 20) syntax_error ("Maximum number of errors", "aborted");
	throw EXPR_ERROR ();
}

void warning (char *m1, char m2)
{
	if (m2) fprintf (stderr, "warning:%s %c\n", m1, m2);
	else fprintf (stderr, "warning:%s\n", m1);
}

FILE *output;

void yylex_open (char *file)
{
	struct stat statbuf;
	if (stat (file, &statbuf) == -1) exit (1);
	int Clen = statbuf.st_size;
	char *Cpp = mmap (0, Clen, PROT_READ, MAP_PRIVATE, open (file, O_RDONLY), 0);
	if (Cpp == MAP_FAILED) exit (1);
	yynorm (Cpp, Clen);
}

extern void showdb ();

int main (int argc, char **argv)
{
	preproc (argc, argv);

	output = stdout;

	// initialize lexical analyser
	prepare ();

	// lexical analysis
	yylex_open (PREPROCESSOR_OUTPUT);

	// sum up into the big normalized array of tokens
	make_norm ();

	// initialize syntactical analyser database
	init_cdb ();

	// syntactical analysis
	parse_C ();
	if (nhe) syntax_error ("Compilation errors", "in expressions");

	if (tdmap_fmt) functions_of_file ();

	// print out what we learned from all this
	showdb ();
	fprintf (stderr, "%i Tokens\n%i symbols\n%i expressions\n",
		 C_Ntok, C_Nsyms, last_result);
}

char *StrDup (char *c)
{
	return strcpy (new char [strlen (c) + 1], c);
}

char *StrDup (char *c, int i)
{
	char *d = new char [i + 1];
	d [i] = 0;
	return strncpy (d, c, i);
}

#ifdef EFENCE
// ###### Electric Fence ######
// These activate efence on our C++ allocations.
// #############################################

void *operator new (size_t s)
{
	return malloc (s);
}

void operator delete (void *p)
{
	free (p);
}

void *operator new[] (size_t s)
{
	return malloc (s);
}

void operator delete[] (void *p)
{
	free (p);
}

#endif

//***********************************************************************
//		definitions
//***********************************************************************

void intcpycat (int *d, int *s1, int *s2)
{
	while ((*d++ = *s1++) != -1);
	d -= 1;
	while ((*d++ = *s2++) != -1);
}

int *intdup (int *i)
{
	int *r = new int [intlen (i) + 1];
	intcpy (r, i);
	return r;
}

int intcmp (int *x, int *y)
{
	while (*x == *y && *x != -1) x++, y++;
	return (*x < *y) ? -1 : (*x == *y) ? 0 : 1;
}

void intncpy (int *d, int *s, int l)
{
	while (l--) *d++ = *s++;
}
