/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)stoi.c	1.1 86/10/09";

#include	"radix.h"
#include	<ctype.h>

int dtoi();
int otoi();
int radix();
int stoi();
int xtoi();

/*
	Use the C lexical rules to determine an ascii number's radix.
	The radix is returned as a bit map, so that more than one radix
	may apply.  In particular, it is impossible to determine the
	radix of 0, so return all possibilities.
*/
int
radix(name)
	register char	*name;
{
	if (!isdigit(*name))
		return 0;
	if (*name != '0')
		return RADIX_DEC;
	name++;
	if (*name == 'x' || *name == 'X')
		return RADIX_HEX;
	while (*name && *name == '0')
		name++;
	return (RADIX_OCT | ((*name)?0:RADIX_DEC));
}

/*
	Convert an ascii string number to an integer.
	Determine the radix before converting.
*/
int
stoi(name)
	char		*name;
{
	switch (radix(name))
	{
	case RADIX_DEC:	return(dtoi(name));
	case RADIX_OCT:	return(otoi(&name[1]));
	case RADIX_HEX:	return(xtoi(&name[2]));
	case RADIX_DEC|RADIX_OCT: return(0);
	default:	return(-1);
	}
}

/*
	Convert an ascii octal number to an integer.
*/
int
otoi(name)
	char		*name;
{
	register int	n = 0;

	while (*name >= '0' && *name <= '7') {
		n *= 010;
		n += *name++ - '0';
	}
	if (*name == 'l' || *name == 'L')
		name++;
	return (*name ? -1 : n);
}

/*
	Convert an ascii decimal number to an integer.
*/
int
dtoi(name)
	char		*name;
{
	register int	n = 0;

	while (isdigit(*name)) {
		n *= 10;
		n += *name++ - '0';
	}
	if (*name == 'l' || *name == 'L')
		name++;
	return (*name ? -1 : n);
}

/*
	Convert an ascii hex number to an integer.
*/
int
xtoi(name)
	char		*name;
{
	register int	n = 0;

	while (isxdigit(*name)) {
		n *= 0x10;
		if (isdigit(*name))
			n += *name++ - '0';
		else if (islower(*name))
			n += 0xa + *name++ - 'a';
		else
			n += 0xA + *name++ - 'A';
	}
	if (*name == 'l' || *name == 'L')
		name++;
	return (*name ? -1 : n);
}
