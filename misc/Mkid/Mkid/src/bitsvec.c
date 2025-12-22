/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)bitsvec.c	1.1 86/10/09";

#include	<stdio.h>
#include	"bitops.h"
#include	"string.h"
#include	"extern.h"
#include	"id.h"

int vecToBits();
int bitsToVec();
char *intToStr();
int getsFF();
int strToInt();
void skipFF();

int
vecToBits(bitArray, vec, size)
	register char	*bitArray;
	register char	*vec;
	int		size;
{
	register int	i;
	int		count;

	for (count = 0; (*vec & 0xff) != 0xff; count++) {
		i = strToInt(vec, size);
		BITSET(bitArray, i);
		vec += size;
	}
	return count;
}

int
bitsToVec(vec, bitArray, bitCount, size)
	register char	*vec;
	char		*bitArray;
	int		bitCount;
	int		size;
{
	register char	*element;
	register int	i;
	int		count;

	for (count = i = 0; i < bitCount; i++) {
		if (!BITTST(bitArray, i))
			continue;
		element = intToStr(i, size);
		switch (size) {
		case 4: *vec++ = *element++;
		case 3: *vec++ = *element++;
		case 2: *vec++ = *element++;
		case 1: *vec++ = *element++;
		}
		count++;
	}
	*vec++ = 0xff;

	return count;
}

char *
intToStr(i, size)
	register int	i;
	int		size;
{
	static char	buf0[4];
	register char	*bufp = &buf0[size];

	switch (size)
	{
	case 4:	*--bufp = (i & 0xff); i >>= 8;
	case 3: *--bufp = (i & 0xff); i >>= 8;
	case 2: *--bufp = (i & 0xff); i >>= 8;
	case 1: *--bufp = (i & 0xff);
	}
	return buf0;
}

int
strToInt(bufp, size)
	register char	*bufp;
	int		size;
{
	register int	i = 0;

	bufp--;
	switch (size)
	{
	case 4: i |= (*++bufp & 0xff); i <<= 8;
	case 3: i |= (*++bufp & 0xff); i <<= 8;
	case 2: i |= (*++bufp & 0xff); i <<= 8;
	case 1: i |= (*++bufp & 0xff);
	}
	return i;
}
