/* Copyright (c) 1986, Greg McGary */
/* @(#)string.h	1.1 86/10/09 */

#ifdef RINDEX
#define	strchr	index
#define	strrchr	rindex
#endif

#ifdef AMIGA
#include <dos.h>
#endif

#ifdef LATTICE
#include <string.h>	/* get the lattice one as well */
#else
extern char
	*strcpy(),
	*strncpy(),
	*strcat(),
	*strncat(),
	*strchr(),
	*strrchr(),
	*strpbrk(),
	*strtok();

extern long
	strtol();
#endif LATTICE

extern char	*calloc();

#undef strcmp

#define strequ(s1,s2)		(strcmp((s1),(s2)) == 0)
#define	strnequ(s1,s2, n)	(strncmp((s1), (s2), (n)) == 0)
#define	strsav(s)		(strcpy(calloc(1, strlen(s)+1), (s)))
#define	strnsav(s,n)		(strncpy(calloc(1, (n)+1), (s), (n)))
