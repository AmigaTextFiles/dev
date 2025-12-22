/*************************************************************************
 *
 * DeChunker
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * dechunk.c
 */

#include "dechunk.h"


/*************************************************************************
 * main() - DaDDDaaah!
 */

int main(int argc, char **argv)
{
	long ret = 10;
	/* init */
	if( InitSystem() )
	{
		struct Args *args;
		
		if( args = GetDeChunkArgs(argc, argv) )
		{
			FILEt dest;
		
			if( dest = OS_fopen(args->arg_Filename, FILEOPEN_WRITE) )
			{
				char *srcname;
				long num = 0;
				FILEt src;
				
				while( (srcname = BuildFName(args->arg_Basename, &num)) &&
				       (src = OS_fopen(srcname, FILEOPEN_READ)) )
				{
					register int c;
									
					OS_printf("%s\n", srcname);
					
					for( c = OS_fgetc(src);
					     c != EOF;
					     c = OS_fgetc(src) )
						OS_fputc(c, dest);
				
					FreeFName(srcname);
					OS_fclose(src);
				}
			
				ret = 0;
				
				OS_fclose(dest);
			}
			FreeDeChunkArgs(args);
		}
		FreeSystem();
	}
	
	return( ret );
}

