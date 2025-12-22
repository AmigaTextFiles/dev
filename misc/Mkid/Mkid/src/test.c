/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)scan-asm.c	1.2 86/11/06";

#include	<stdio.h>
#include	<string.h>

#define strequ(s1,s2)		(strcmp((s1),(s2)) == 0)
#define	strnequ(s1,s2, n)	(strncmp((s1), (s2), (n)) == 0)
#define	strsav(s)		(strcpy(calloc(1, strlen(s)+1), (s)))
#define	strnsav(s,n)		(strncpy(calloc(1, (n)+1), (s), (n)))

void
main(int argc,char **argv)
{
	static char	idBuf[BUFSIZ];

	strcpy(idBuf,argv[1]);

	if (strequ(idBuf, "include"))
		printf("ok\n");
	else
		printf("not ok\n");
	if (strnequ(idBuf, "if", 2)
	|| strequ(idBuf, "define")
	|| strequ(idBuf, "undef"))
		goto next;
	printf("x2\n");
next:
	;
}
