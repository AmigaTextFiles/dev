
#include "MemGuardian.h"
#include <exec/memory.h>


int main(void)
{
    /* Start memory tracking */
    MG_Init();

    /* Allocate some bytes */
    void * ptr = MG_malloc( 128 );

    /* Free it */
    MG_free( ptr );

    /* Attempt to free() it again, "accidentally" */
    MG_free( ptr );

    /* Attempt to free() a non-existant allocation */
    MG_free( NULL );

#ifdef __cplusplus

	class TestClass { char buffer[1024]; };

    /* Dynamic creation of a C++ class (use MG_new / MG_delete for consistency) */
    TestClass * ptr2 = new TestClass();

    /* Deleting it */
    delete ptr2;

    /* Dynamic creation of a C++ array */
    char * ptr3 = new char[64];

    /* Deleting it */
    delete [] ptr3;

    /* Trying to delete non-existant allocation */
    delete (LONG*)0x666;

#endif

    /* Use Exec function */
    APTR ptr4 = MG_AllocVec( 4096, MEMF_PUBLIC );

    MG_FreeVec( ptr4 );

    /* Let's "leak" some memory, should result as warning and clean-up when exiting */
    ptr = MG_malloc( 32 );

    /* Finish memory tracking */
    MG_Exit();

    return 0;
}
