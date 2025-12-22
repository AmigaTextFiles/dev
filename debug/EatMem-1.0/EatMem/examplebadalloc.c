/* examplebadalloc.c
**
** An example of INCORRECT memory allocations.
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

	chip = AllocMem( MEMBLOCK, MEMF_CHIP );
	printf( "Got %d bytes CHIP RAM at address %08X\n", MEMBLOCK, chip );

	fast = AllocMem( MEMBLOCK, MEMF_FAST );
	printf( "Got %d bytes of FAST RAM at address %08X\n", MEMBLOCK, fast );
			
	printf( "\nPress RETURN to start using the FAST memory..." );
	while ( getchar() != '\n' );

	for ( i = 0; i < MEMBLOCK; i++ )
		fast[i] = i;

	printf( "Press RETURN to start using the CHIP memory..." );
	while ( getchar() != '\n' );

	for ( i = 0; i < MEMBLOCK; i++ )
		chip[i] = i;

	FreeMem( fast, MEMBLOCK );
	FreeMem( chip, MEMBLOCK );
}
