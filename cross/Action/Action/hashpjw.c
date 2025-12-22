/*-> (C) 1990 Allen I. Holub                                                */

#include <stdlib.h>
#include "hash.h"		/* for prototypes only */

#define NBITS_IN_UNSIGNED	(      NBITS(unsigned int)	  )
#define SEVENTY_FIVE_PERCENT 	12
#define TWELVE_PERCENT 		2
#define HIGH_BITS		( ~( (unsigned)(~0) >> TWELVE_PERCENT)  )

unsigned hash_pjw(unsigned char *name )
{
    unsigned h = 0;			/* Hash value */
    unsigned g;

	for(; *name ; ++name )
	{
	h = (h << 12) + *name ;
	if( g = h & HIGH_BITS )
	    h = (h ^ (g >> SEVENTY_FIVE_PERCENT)) & ~HIGH_BITS ;
    }
    return h;
}
