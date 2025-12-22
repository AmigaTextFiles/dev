/* Use this utility to convert an AmigaGuide document to a normal
   document file without all the @Node, @EndNode, ... commands
*/

#include <stdio.h>
#include <string.h>

int main (int argc, char *argv[])
{
	FILE *fp;
	int state;
	char *buf,*buf2,*p,*p2;

	buf = malloc (4096);
	buf2 = malloc (4096);
	if (buf && buf2 && argc > 1)
		{
			if (fp = fopen (argv[1],"r"))
				{
					while (fgets (buf,4093,fp))
						{
							buf[strlen (buf)-1] = 0;
							if (!strnicmp (buf,"@Node",5))
								{
									puts ("----------------------------------------------------------------------------------");
									puts (buf+6);
									puts ("----------------------------------------------------------------------------------");
								}
							else if (!strnicmp (buf,"@Database",9))
								;
							else if (!strnicmp (buf,"@master",7))
								;
							else if (!strnicmp (buf,"@EndNode",8))
								;
							else if (p = strstr (buf,"@{"))
								{
									state = 0;
									p2 = buf2;
									p = buf;
									while (*p)
										{
											switch (state)
												{
													case 0 :	/* Initial state */
														if (*p == '@' && *(p+1) == '{') { p++; state = 1; }
														else *p2++ = *p;
														break;
													case 1 :	/* Waiting for first double quote */
														if (*p == '"' && *(p+1) == ' ') { *p2++ = '\''; p++; state = 2; }
														else if (*p == '"') { *p2++ = '\''; state = 2; }
														break;
													case 2 :	/* Waiting for second double quote */
														if (*p == ' ' && *(p+1) == '"') { *p2++ = '\''; p++; state = 3; }
														else if (*p == '"') { *p2++ = '\''; state = 3; }
														else *p2++ = *p;
														break;
													case 3 :	/* Waiting for '}' */
														if (*p == '}') state = 0;
														break;
												}
											p++;
										}
									*p2 = 0;
									puts (buf2);
								}
							else puts (buf);
						}
					fclose (fp);
				}
			else printf ("Error opening file!\n");
		}
	else printf ("Usage: ConvertGuide2Doc <filename>\n");
	if (buf) free (buf);
	if (buf2) free (buf2);
}
