/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)bsearch.c	1.1 86/10/09";

char *bsearch();

/*
	Binary search -- from Knuth (6.2.1) Algorithm B
*/
char *
bsearch(key, base, nel, width, compar)
	char		*key;
	register char	*base;
	unsigned int	nel;
	int		width;
	int		(*compar)();
{
	register char	*last;
	register char	*position;
	register int	result;
	int		width2;

	width2 = width * 2;
	last = &base[width * (nel - 1)];

	while (last >= base) {
		position = &base[width * ((last - base)/width2)];
		
		if ((result = (*compar)(key, position)) == 0)
			return position;
		if (result < 0)
			last = position - width;
		else
			base = position + width;
	}
	return (char *)0;
}
