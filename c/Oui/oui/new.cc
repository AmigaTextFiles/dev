// $Id: new.cc 1.3 1997/09/17 08:16:26 dlorre Exp dlorre $
#include <exec/types.h>
#include <exec/memory.h>

#include <dos/dos.h>
#include <dos/dosextens.h>

#include <intuition/intuition.h>

#include <new.h>
#include <string.h>
#include <unistd.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include <clib/alib_protos.h>
#include <mydebug.h>
#include <compiler.h>

static ULONG OxygeneSize = 20000 ;
APTR chipOxygene ;

static SignalSemaphore* MemorySemaphore ;

static Process *myproc ;

APTR anyPool=NULL, chipPool=NULL ;

static EasyStruct memFail = {
    sizeof (struct EasyStruct),
    0,
    (UBYTE *)"Memory Warning",
    (UBYTE *)"The system is running into a low memory situation.\n"
    "I have been unable to allocate %lu bytes.\n\n"
    "%lu bytes of chip memory have been given back to the system.\n"
    "I can wait until you free some more and I can reallocate it.\n"
    "Or, if you select Cancel I will not take back those bytes.\n"
    "and %s allocations might be rejected.",
    (UBYTE *)"Wait|Cancel",
};


LONG SAVEDS outmem(size_t s)
{
BOOL reply ;

    GETA4 ;

    LibFreePooled(chipPool, chipOxygene, OxygeneSize) ;
    chipOxygene = NULL ;
    reply = (BOOL)EasyRequest((Window *)myproc->pr_WindowPtr, &memFail,
        NULL, s, OxygeneSize, myproc->pr_Task.tc_Node.ln_Name) ;
    if (reply == 1) {
        while(!(chipOxygene = LibAllocPooled(chipPool, OxygeneSize))) {
            Delay(200) ;
        }

    }
    return reply ;
}

void *operator new(size_t s)
{
unsigned long *p ;

    ObtainSemaphore(MemorySemaphore) ;
    s += 4 ;
    while ((p = (unsigned long *)LibAllocPooled(anyPool, s)) == NULL) {
        if (chipOxygene) {
            if (!outmem(s)) {
                p = (unsigned long *)LibAllocPooled(anyPool, s) ;
            }
        }
        else
            return NULL ;
    }
    *p++ = s ;
    ReleaseSemaphore(MemorySemaphore) ;
    return (void *)p ;
}

void operator delete(void *p)
{
unsigned long *l = (unsigned long *)(p) ;

    ObtainSemaphore(MemorySemaphore) ;
    l-- ;
    LibFreePooled(anyPool, l, *l) ;
    ReleaseSemaphore(MemorySemaphore) ;
}

extern "C" {
int _STI_50_initpool()
{
   myproc = (Process *)FindTask(0);

    MemorySemaphore = (SignalSemaphore *)AllocMem(sizeof(SignalSemaphore), MEMF_CLEAR|MEMF_PUBLIC) ;
    if (MemorySemaphore) {
        InitSemaphore(MemorySemaphore);

        anyPool = LibCreatePool(MEMF_CLEAR|MEMF_PUBLIC, 10000, 5000) ;
        if (anyPool) {
            chipPool = LibCreatePool(MEMF_CLEAR|MEMF_CHIP, 20000, 10000) ;
            if (!chipPool) {
                LibDeletePool(anyPool) ;
                anyPool = NULL ;
                FreeMem(MemorySemaphore, sizeof(SignalSemaphore)) ;
                MemorySemaphore = NULL ;
            }
            chipOxygene = LibAllocPooled(chipPool, OxygeneSize) ;
            if (!chipOxygene) {
                LibDeletePool(anyPool) ;
                LibDeletePool(chipPool) ;
                anyPool = NULL ;
                chipPool = NULL ;
                FreeMem(MemorySemaphore, sizeof(SignalSemaphore)) ;
                MemorySemaphore = NULL ;
            }
        }
        else {
            FreeMem(MemorySemaphore, sizeof(SignalSemaphore)) ;
            MemorySemaphore = NULL ;
        }
    }
bye:
#if defined( __GNUG__ )
    if (!MemorySemaphore) exit(20) ;
#endif
    return (MemorySemaphore)?0:1 ;
}


void _STD_50_freepool()
{
    FreeMem(MemorySemaphore, sizeof(SignalSemaphore)) ;
    if (anyPool) LibDeletePool(anyPool) ;
    if (chipPool) LibDeletePool(chipPool) ;
}
}

#if defined( __GNUG__ )
ADD2INIT(_STI_50_initpool, -50);
ADD2EXIT(_STD_50_freepool, -50);
#endif
