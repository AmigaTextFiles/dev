#include <feelin/string.h>

/*

$VER: 01.00 (2006/08/27)

	This function converts hexadecimal strings such as 'ABcd1230' to integer
	values,  returning the number of characters converted. If a character is
	not within the hexadecimal space (0-9 | a-f | A-F) or  if  8  characters
	have already been parsed, the convertion stops.

*/

uint32 f_stch(const char *in, int32 *lvalue)
{
	const char *k = in;
	const char *e = in + 8;

	int32 rc = 0;

	for (;;)
	{
		uint8 c = *k;

		if (('0' <= c) && (c <= '9'))
		{
			rc = (rc * 16) + (c - '0');
		}
		else if ((('a' <= c) && (c <= 'f')) || (('A' <= c) && (c <= 'F')))
		{
			// "c & 7" handles lower and uppercase hex alphabetics

			rc = (rc * 16) + (c & 7) + 9;
		}
		else break;

		k++;

		if (k == e)
		{
			break;
		}
	}

	if (lvalue != NULL)
	{
		*lvalue = rc;
	}

	return (uint32) k - (uint32) in;
}

