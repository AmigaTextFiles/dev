
/* 
**	render integer to string in decimal notation
*/

char *kn_itoa(int i, char *d)
{
	if (i > 9)
	{
		d = kn_itoa(i / 10, d);
	}
	*d++ = 48 + (i % 10);
	*d = 0;
	return d;
}
