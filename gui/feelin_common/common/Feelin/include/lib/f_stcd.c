#include <feelin/string.h>

/*

$VER: 01.00 (2006/08/27)

	This function converts integer strings such as '1234' to integer values,
	returning  the  number  of  characters  converted. If a character is not
	within the integer space ('-' | '+' | '0-9') or if  10  characters  have
	already  been parsed (plus the possible sign), the convertion stops. The
	functions handles positive (+) and negative (-) expressions.

*/

uint32 f_stcd(const char *in, int32 *lvalue)
{
	const char *k = in;
	const char *e;

	int32 dec = 0;

	bool32 minus = FALSE;

	switch (*k)
	{
		case '-':
		{
			minus = TRUE;
		}
		case '+':
		{
			k++;
		}
		break;
	}

	e = k + 10;

	for (;;)
	{
		uint8 c = *k;

		if (('0' <= c) && (c <= '9'))
		{
			dec = (dec * 10) + (c - '0');
		}
		else break;

		k++;

		if (k == e)
		{
			break;
		}
	}

	if (minus)
	{
		dec = -dec;
	}

	if (lvalue != NULL)
	{
		*lvalue = dec;
	}

	return (uint32) k - (uint32) in;
}

