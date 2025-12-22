/* RememberTest.c                                                    */
/* Illustrates the use of AllocRemember() and FreeRemember().        */
/* Compiled with Lattice C v5.02                                     */
/* Compiler invoked with: lc -b1 -cfist -L -v -w                     */

/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>

#include <proto/all.h>
#include <stdlib.h>
int CXBRK(void) {return(0);}

struct IntuitionBase *IntuitionBase;

#define SIZE_A 100L
#define SIZE_B 200L

#define FLAGS_A (MEMF_CLEAR | MEMF_PUBLIC)
#define FLAGS_B MEMF_PUBLIC

VOID methodOne(VOID), methodTwo(VOID);

VOID main(int argc, char *argv[])
{
int exitVal = RETURN_OK;

/* Open Intuition */
IntuitionBase = (struct Intuition *) OpenLibrary("intuition.library", 33L);
if (IntuitionBase)
    {
    methodOne();

    methodTwo();

    CloseLibrary((struct Library *)IntuitionBase);
    }
else
    exitVal = RETURN_FAIL;

exit(exitVal);
}


/* MethodOne
   Illustrates using AllocRemember() to allocate all memory and
   FreeRemember() to free it all.
*/
VOID methodOne(VOID)
{
CPTR memBlockA = NULL, memBlockB = NULL;
struct Remember *rememberKey = NULL;

memBlockA = (CPTR)AllocRemember(&rememberKey, SIZE_A, FLAGS_A);
if (memBlockA)
    {
    /*  The memBlockA allocation succeeded; try for memBlockB.  */
    memBlockB = (CPTR)AllocRemember(&rememberKey, SIZE_B, FLAGS_B);
    if (memBlockB)
        {
        /*  Both memory allocations succeeded.
            The program may now use this memory.
        */
        }
    }

/*
   It is not necessary to keep track of the status of each allocation.
   Intuition has kept track of all successful allocations by updating its
   linked list of Remember nodes.  The following call to FreeRemember() will
   deallocate any and all of the memory that was successfully allocated.
   The memory blocks as well as the link nodes will be deallocated because
   the "ReallyForget" parameter is TRUE.
*/

FreeRemember(&rememberKey, TRUE);

/*
   It is possible to have reached the above call to FreeRemember()
   in one of three states.  Here they are, along with their results.

   1. Both memory allocations failed.
         RememberKey is still NULL.  FreeRemember() will do nothing.
   2. The memBlockA allocation succeeded but the memBlockB allocation failed.
         FreeRemember() will free the memory block pointed to by memBlockA.
   3. Both memory allocations were successful.
         FreeRemember() will free the memory blocks pointed to by
         memBlockA and memBlockB.
*/

}


/* MethodTwo
   Illustrates using AllocRemember() to allocate all memory,
   FreeRemember() to free the link nodes, and FreeMem() to
   free the actual memory blocks.
*/
VOID methodTwo(VOID)
{
CPTR memBlockA = NULL, memBlockB = NULL;
struct Remember *rememberKey = NULL;

memBlockA = (CPTR)AllocRemember(&rememberKey, SIZE_A, FLAGS_A);
if (memBlockA)
    {
    /*  The memBlockA allocation succeeded; try for memBlockB.  */
    memBlockB = (CPTR)AllocRemember(&rememberKey, SIZE_B, FLAGS_B);
    if (memBlockB)
        {
        /*  Both memory allocations succeeded. */

        /*  For the purpose of illustration, FreeRemember()
            is called at this point, but only to free the
            link nodes.  The memory pointed to by memBlockA
            and memBlockB is retained.
        */
        FreeRemember(&rememberKey, FALSE);

        /*  Pretend that memBlockA was needed only temporarily.
            It can now be freed.  The Exec FreeMem() call must
            be used, as the link nodes are no longer available.
        */
        FreeMem((VOID *)memBlockA, SIZE_A);

        /*  The memory pointed to by memBlockB is used by the program.  */


        /*  All memory blocks allocated with AllocRemember() must be
            freed individually, now that the link nodes are gone.
        */
        FreeMem((VOID *)memBlockB, SIZE_B);

        }
    }

FreeRemember(&rememberKey, TRUE);

/*
   It is possible to have reached the above call to FreeRemember()
   in one of three states.  Here they are, along with their results.

   1. Both memory allocations failed.
         RememberKey is still NULL.  FreeRemember() will do nothing.
   2. The memBlockA allocation succeeded but the memBlockB allocation failed.
         FreeRemember() will free the memory block pointed to by memBlockA.
   3. Both memory allocations were successful.
         If this is the case, the program has already freed the link nodes
         with FreeRemember() and the memory blocks with FreeMem().
         When FreeRemember() freed the link nodes, it reset RememberKey
         to NULL.  This (second) call to FreeRemember() will do nothing.
*/

}
