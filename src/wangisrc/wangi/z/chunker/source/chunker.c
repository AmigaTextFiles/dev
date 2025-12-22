/*************************************************************************
 *
 * Chunker
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * chunker.c
 */

#include "chunker.h"


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
		
		if( args = GetChunkerArgs(argc, argv) )
		{
			FILEt source;
			
			/* Open input file */
			if( source = OS_fopen(args->arg_Filename, FILEOPEN_READ) )
			{
				char *destname;
				long num = 0;
				FILEt dest = NULL;

				if( (destname = BuildFName(args->arg_Basename, &num)) &&
				    (dest = OS_fopen(destname, FILEOPEN_WRITE)) )
				{
					register long n = 0;
					register int c;
					
					OS_printf("%s\n", destname);
					
					for( c = OS_fgetc(source);
					     c != EOF;
					     c = OS_fgetc(source), ++n)
					{
						if( n == args->arg_Size )
						{
							FreeFName(destname);
							OS_fclose(dest);
							destname = BuildFName(args->arg_Basename, &num);
							OS_printf("%s\n", destname);
							dest = OS_fopen(destname, FILEOPEN_WRITE);
							n = 0;
						}
						OS_fputc(c, dest);
					}
				}
				FreeFName(destname);
				OS_fclose(dest);
				OS_fclose(source);
				
				ret = 0;
			} else
				OS_printf("Can't open %s\n", args->arg_Filename);
			
			FreeChunkerArgs(args);
			
		} /* else arg fail */
		
		FreeSystem();	
	}
	return( ret );
}
