#include <stdio.h>

int main (int argc, char *argv[])
{
	long i;
	int c;
	FILE *fp;
	char *buf,*buf2;

	buf = malloc (16384);
	buf2 = malloc (16384);
	if (buf && buf2 && argc > 2)
		{
			buf2[0] = 0;
			if (fp = fopen (argv[1],"r"))
				{
					i = 0;
					while (fgets (buf,16383,fp))
						{
							i++;
							if (!strncmp (buf,"@Node",5)) strcpy (buf2,buf);
							if (strstr (buf,argv[2])) printf ("%ld : %s",i,buf2);
						}
					fclose (fp);
				}
			else printf ("Error opening file!\n");
		}
	else printf ("Usage: searchit <filename> <string>\n");
	if (buf) free (buf);
	if (buf2) free (buf2);
}
