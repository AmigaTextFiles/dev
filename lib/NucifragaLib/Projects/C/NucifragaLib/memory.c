static const char rcsid[] =
	"$Id: memory.c 1.3 1995/10/31 11:05:10 JöG Exp JöG $";

/*
 *
 * memory.c
 * 
 * Handles allocation and deallocation
 * of memory. Hides the (strange C | exec) memory
 * allocation functions. It also handles
 * special cases like giving zero sizes
 * or NULL pointers, something that (ANSI C | exec)
 * don't necessarily do.
 * 
 */

/*
 * I was blind, now I can see!
 * You've made a believer out of me!
 * 
 *                 Bobby Gillespie
 *
 */

/*
 * $Log: memory.c $
 * Revision 1.3  1995/10/31  11:05:10  JöG
 * new functions for chip/public allocations
 *
 * Revision 1.2  1995/10/23  21:54:32  JöG
 * made the RCS id a string
 *
 * Revision 1.1  1995/10/18  14:43:02  JöG
 * Initial revision
 *
 * Revision 1.1  1995/07/02  21:55:13  JöG
 * Initial revision
 *
 *
 */


#include <exec/types.h>
#include <exec/memory.h>

#include <proto/exec.h>

#include "memory.h"



/*
 * This one can also allocate 0 bytes,
 * in which case NULL is returned.
 *
 */
APTR memoryalloc(LONG size)
{
	if(size>0)
		return(AllocMem(size, MEMF_ANY));
	else
		return(NULL);
}



/*
 * As memoryalloc(), but allocates
 * chip memory.
 *
 */
APTR memoryallocchip(LONG size)
{
	if(size>0)
		return(AllocMem(size, MEMF_CHIP));
	else
		return(NULL);
}



/*
 * As memoryalloc(), but allocates
 * public memory for things like messages.
 *
 */
APTR memoryallocpublic(LONG size)
{
	if(size>0)
		return(AllocMem(size, MEMF_PUBLIC));
	else
		return(NULL);
}



/*
 * This one is safe even for the case
 * memoryfree(NULL, _);
 * 
 * 1994-02-23: Removed the test;
 * ANSI guarantees that free(0) works.
 *
 * 1995-06-08: added the test again
 * for the Amiga version
 * 
 */
void memoryfree(APTR memory, LONG size)
{
#if 0
	if(memory!=NULL)
	{	while(size>0)
		{
			((char *)memory)[size-1] = '*';
			size--;
		}
	}
#endif

	if(memory)
	{	FreeMem(memory, size);
	}
}
