/* examplegoodalloc.c
**
** An example how to correctly ask for memory and quit if can't get it.
*/

#include <stdio.h>
#include <exec/memory.h>
#include <proto/exec.h>

#define MEMBLOCK 102400

void main( void );

void main( void )
{
	UBYTE *fast, *chip;
	int i;

	if ( chip = AllocMem( MEMBLOCK, MEMF_CHIP ) )
	{
		printf( "Got %d bytes CHIP RAM at address %08X\n", MEMBLOCK, chip );
		
		if ( fast = AllocMem( MEMBLOCK, MEMF_FAST ) )
		{
			printf( "Got %d bytes of FAST RAM at address %08X\n", MEMBLOCK, fast );
			
			printf( "\nPress RETURN to start using the FAST memory..." );
			while ( getchar() != '\n' );

			for ( i = 0; i < MEMBLOCK; i++ )
				fast[i] = i;

			FreeMem( fast, MEMBLOCK );
		}
		else
		{
			printf( "\aDid NOT succeed in allocating FAST!\n" );
		}

		printf( "Press RETURN to start using the CHIP memory..." );
		while ( getchar() != '\n' );
		
		for ( i = 0; i < MEMBLOCK; i++ )
			chip[i] = i;

		FreeMem( chip, MEMBLOCK );
	}
	else
	{
		printf( "\aDid NOT succeed in allocating CHIP!\n" );
	}
}
