/*************************************************************************
 *
 * ea
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * ea.c
 */

#include "ea.h"

char *StripFile(char *s)
{
	if( s )
	{
		char *tmp = s;
		
		for( ; (tmp = strpbrk(tmp, BRKCHARS)); )
		{
			s = ++tmp;
		}
	}    
	return( s );
}


void donum(FILEt f, long *num)
{
	if( (*num)++ == 75 )
	{
		mfputc('\n', f);
		mfputc('Z', f);
		*num = 1;
	}
}


void wtf(char c, FILEt f, long *num, long *check, long *tabs)
{
	switch( c )
	{
		case R_TAB :
			if( (*tabs) >= 10 )
			{
				donum(f, num);
				mfputc(R_TAB, f);
				donum(f, num);
				mfprintf(f, "%ld", (*tabs)-1 );
				(*tabs) = 0;
			}
			++(*tabs);
			break;

		default :
			if( *tabs )
			{
				donum(f, num);
				mfputc(R_TAB, f);
				donum(f, num);
				mfprintf(f, "%ld", (*tabs)-1 );
				(*tabs) = 0;
			}
			
			donum(f, num);
			mfputc(c, f);
			if( ((*num) % 2) )
				(*check) -= (long)c;
			else
				(*check) += (long)c;
			
			break;
	}
}

/*************************************************************************
 * main() - DaDDDaaah!
 */

int main(int argc, char **argv)
{
	long ret = EXIT_FAILURE;

	/* init */
	if( InitSystem() )
	{
		struct Args *args;
		
		if( args = GeteaArgs(argc, argv) )
		{
			FILEt source;
			
			/* Open input file */
			if( source = mfopen(args->arg_Filename, FILEOPEN_READ) )
			{
				FILEt dest = NULL;
				long check = 0;

				if( dest = mfopen(args->arg_Dest, FILEOPEN_WRITE) )
				{
					long n = 0, tabs = 0;
					int c;
					
					mfprintf(dest, IDENTIFIER "\n"
					               "ECreator:" CREATOR "\n"
					               "EInfo:For decoders - ftp://ftp.aminet.org/pub/aminet/comm/misc/ea.lha (soon)\n"
					               "EFile:%s\n"
					               "Z\n"
					               "Z", StripFile(args->arg_Filename));
					for( c = mfgetc(source);
					     c != EOF;
					     c = mfgetc(source))
					{
						switch( c )
						{
							case '\n' :
								wtf(R_NL, dest, &n, &check, &tabs);
								break;
							
							case '\r' :
								break;
							
							case '\t' :
								wtf(R_TAB, dest, &n, &check, &tabs);
								break;
							
							case ' ' :
								wtf(R_SPACE, dest, &n, &check, &tabs);
								break;
							
							case R_NL :
								wtf(ESCAPE, dest, &n, &check, &tabs);
								wtf(R_NL, dest, &n, &check, &tabs);
								break;
							
							case R_TAB :
								wtf(ESCAPE, dest, &n, &check, &tabs);
								wtf(R_TAB, dest, &n, &check, &tabs);
								break;
							
							case R_SPACE :
								wtf(ESCAPE, dest, &n, &check, &tabs);
								wtf(R_SPACE, dest, &n, &check, &tabs);
								break;
							
							default :
								wtf(c, dest, &n, &check, &tabs);
								break;
						}
					}
				}
				mfprintf(dest, "\nX\nXCheck: %ld\n", check);
				mfclose(dest);
				mfclose(source);
				
				ret = EXIT_SUCCESS;
			} else
				mprintf("Can't open %s\n", args->arg_Filename);
			
			FreeeaArgs(args);	
		}
		FreeSystem();	
	}
	return( ret );
}
