/* FarTest.c ****************************************************************
*
*	FarTest -------	Debugging functions for programs which don't
*			have links to their environment.
*
*			FarPrint demonstration program.
*
*	Author --------	Olaf Barthel of MXM
*			Brabeckstrasse 35
*			D-3000 Hannover 71
*
*			Federal Republic of Germany.
*
*	This program truly is in the PUBLIC DOMAIN. Written on a sunny
*	September day in 1989, updated 27 January 1990.
*
*	Compiled using Aztec C 3.6a, CygnusEd Professional 2 & ARexx.
*
****************************************************************************/

#define	FARPRINT	/* turn on farprint macros */

#include "farprint.h"

	/* main(argc,argv):
	 *
	 *	This is meant to be the main demonstration
	 *	part for this program.
	 */

   VOID
main(USHORT argc, BYTE *argv[])
{
   BYTE  buffer[81] = "";
   ULONG i;

	/* Send some dummy text. */

   for (i = 0; i < 14; i++) {
      FP_PRINT2("i=%-10ld   i<<i=%-10ld", i, i << i);
   }

	/* Send the first calling argument to FarPrint. */
		
	/* Request a number and print it. */

   printf("%ld\n", FP_GET_NUMBER("FarTest1"));

	/* Request a text and print it. */

   printf("'%s'\n", FP_GET_STRING("FarTest1", &buffer[0]));
}
