/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)bzero.c	1.1 86/10/09";

void bzero();

void
bzero(s, n)
	register char	*s;
	register int	n;
{
	if (n) do
		*s++ = 0;
	while (--n);
}
