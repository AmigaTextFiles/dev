
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define BUFF_SIZE 1024

void main(int argc, char **argv)
{
	if( argc == 4 )
	{
		FILE *fsrc;
		
		if( fsrc = fopen(argv[3], "ra") )
		{
			char *tmpname;
			
			if( tmpname = tmpnam(NULL) )
			{
				FILE *fdest;
				
				if( fdest = fopen(tmpname, "wb") )
				{
				
				char buffer[BUFF_SIZE];
				char *retbuf;
				
				for( retbuf = fgets(buffer, BUFF_SIZE, fsrc);
				     retbuf;
				     retbuf = fgets(buffer, BUFF_SIZE, fsrc) )
				{
					char *pos;
					
					if( pos = strstr(retbuf, argv[1]) )
					{
						char *s;
						
						//printf(" - \"%s\"", );

						for( s = retbuf;
						     s != pos;
						     s++ )
							fputc(*s, fdest);
						
						for( s = argv[2];
						     *s;
						     s++ )
							fputc(*s, fdest);
						
						for( s = pos + strlen(argv[1]);
						     *s;
						     s++ )
							fputc(*s, fdest);
						
					} else
						fputs(retbuf, fdest);
				}
				fclose(fdest);
				fclose(fsrc);
				remove(argv[3]);
				rename(tmpname, argv[3]);
				fsrc = NULL;
				}
			}
			if( fsrc )
				fclose(fsrc);
		}
	}
}
	