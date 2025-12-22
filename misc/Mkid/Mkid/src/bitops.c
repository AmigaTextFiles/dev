/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)bitops.c	1.1 86/10/09";

#include	"bitops.h"

char *bitsset();
char *bitsclr();
char *bitsand();
char *bitsxor();
int bitstst();
int bitsany();

char *
bitsset(s1, s2, n)
	register char	*s1;
	register char	*s2;
	register int	n;
{
	while (n--)
		*s1++ |= *s2++;

	return s1;
}

char *
bitsclr(s1, s2, n)
	register char	*s1;
	register char	*s2;
	register int	n;
{
	while (n--)
		*s1++ &= ~*s2++;

	return s1;
}

char *
bitsand(s1, s2, n)
	register char	*s1;
	register char	*s2;
	register int	n;
{
	while (n--)
		*s1++ &= *s2++;

	return s1;
}

char *
bitsxor(s1, s2, n)
	register char	*s1;
	register char	*s2;
	register int	n;
{
	while (n--)
		*s1++ ^= *s2++;

	return s1;
}

int
bitstst(s1, s2, n)
	register char	*s1;
	register char	*s2;
	register int	n;
{
	while (n--)
		if (*s1++ & *s2++)
			return 1;

	return 0;
}

int
bitsany(s, n)
	register char	*s;
	register int	n;
{
	while (n--)
		if (*s++)
			return 1;

	return 0;
}
