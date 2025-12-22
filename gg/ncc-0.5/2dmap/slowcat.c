#include <stdio.h>
#include <stdlib.h>

#define BFF 81
#define SLEEPMS 16

void do_cat (char *fn)
{
	char tmp [BFF + 1];
	FILE *f = fopen (fn, "r");
	if (!f) return;
	
	while (fgets (tmp, BFF, f)) {
		fputs (tmp, stdout);
		usleep (SLEEPMS * 1000);
	}
	
	fclose (f);
}

int main (int argc, char **argv)
{
	int i;
	for (i = 1; i < argc; i++)
		do_cat (argv [i]);
	return 0;
}

/*
	This is a very useful utility for viewing unknown code.
	do: slowcat *.c
	and understand what's going on with the code.
*/
