/*************************************************************************
 *
 * deea
 *
 * Copyright ©1995 Lee Kindness and Evan Tuer
 * cs2lk@scms.rgu.ac.uk
 *
 * deea.c
 */

#include "deea.h"


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
		
		if( args = GetdeeaArgs(argc, argv) )
		{
			FILEt src;
		
			if( src = mfopen(args->arg_Filename, FILEOPEN_READ) )
			{
				char *buf;
				
				if( buf = mmalloc(BUF_SIZE) )
				{
					char *s;
					int state = NOTIN_EA;
					int section = SECTION_PRE;
					
					for( s = mfgets(buf, BUF_SIZE, src);
					     s;
					     s = mfgets(buf, BUF_SIZE, src) )
					{
						switch( state )
						{
							case NOTIN_EA :
								printf("NOTIN_EA\n");
								if( strstr(s, IDENTIFIER) == s )
								{
									state = IN_EA;
									section = SECTION_PRE;
								}
								break;
							
							case IN_EA :
								switch( section )
								{
									case SECTION_PRE :
										printf("SECTION_PRE\n");
										switch( *s )
										{
											case 'E' : 
												break;
											case 'Z' :
												section = SECTION_DATA;
												break;
											default :
												state = NOTIN_EA;
												break;
										}
										break;
									case SECTION_DATA :
										printf("SECTION_DATA\n");
										switch( *s )
										{
											case 'Z' :
												break;
											case 'X' :
												section = SECTION_POST;
												break;
											default :
												state = NOTIN_EA;
												break;
										}
										break;
									case SECTION_POST :
										printf("SECTION_POST\n");
										switch( *s )
										{
											case 'X' :
												break;
											default :
												state = NOTIN_EA;
												break;
										}
										break;
								}
								break;
						}
						mprintf("%s", s);
					}
				
					ret = EXIT_SUCCESS;
					
					mfree(buf);
				}
				
				mfclose(src);
			}
			FreedeeaArgs(args);
		}
		FreeSystem();
	}
	return( ret );
}
