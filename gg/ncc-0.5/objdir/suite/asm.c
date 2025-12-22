
void MM () { }

int main (int argc, char **argv)
{
	float f;
	int i, b, j, c;
/*	
	i = f;
	MM();
	f = i;
	MM();
	b = !f;
	MM();
	b = !i;
*/
	b = 12098;
	i = j = argc;
	MM ();
	b = i==10 || i==20 || i ==30 || i == 40;
	MM ();
	c = j==10 | j == 20 | j==30 | j==40;
	MM ();
	return b + c;
}