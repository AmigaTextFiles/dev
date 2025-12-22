#include <exec/types.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <string.h>

/* proto and pragma for dosPrivate5...
 * dosPrivate5 is now refered to as "InternalFault()" from now on...
 */
STRPTR InternalFault(LONG code);
#pragma libcall DOSBase InternalFault 3d2 101

/* file to which the strings are output... */
#define FILENAME "DefErrors.fault"

/* Minimum error code to test */
#define MIN_ERROR -300

/* Maximum error code to test */
#define MAX_ERROR 500

void main( void )
{
	STRPTR s2;
	
	if (DOSBase->dl_lib.lib_Version < 36)
		return;
	
	/* Alloc a string buffer */
	if( s2 = AllocVec(1024, MEMF_CLEAR) )
	{
		BPTR outfile;
		if( outfile = Open(FILENAME, MODE_NEWFILE) )
		{
			LONG n;
			STRPTR s, outs;
			/* print a header */
			FPrintf(outfile, "#\n"
			                 "# FaultStrings file created by GetDefErrors\n"
			                 "# for use with YourFault, ©Lee Kindness.\n"
			                 "#\n"
			                 "#\n");
	
			/* test all codes between MIN_ERROR and MAX_ERROR */
			for(n = MIN_ERROR; n <= MAX_ERROR; n++)
			{
				if( s = InternalFault(n))
				{
					/* valid error string... */

					/* check if the string contains any '\n' */
					if( strchr(s, '\n' ) )
					{
						STRPTR temps;
						#define FINDCHAR '\n'
						#define REPLACECHAR '^'

						
						/* copy the string... */
						strcpy(s2, s);
						/* replace all FINDCHAR */
						temps = s2;
						while(*temps != '\0')
						{
							if(*temps == FINDCHAR)
								*temps = REPLACECHAR;
							temps++;
						}
						outs = s2;
					} else
						outs = s;
					
					/* output a comment above it with number */
					/* output the actual number:string */
					/* and space the output with a comment line */
					FPrintf(outfile, "#\t(%ld)\n"
					                 "%ld:%s\n"
					                 "#\n", n, n, outs);
				}
			}
			Close(outfile);
		}
		FreeVec(s2);
	}
}