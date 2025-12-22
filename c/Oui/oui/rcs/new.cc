head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@// @;


1.3
date	97.09.17.08.16.26;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.21.14;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.10;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.3
log
@sem is private
@
text
@// $Id: new.cc 1.2 1997/07/14 04:21:14 dlorre Exp dlorre $
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
@


1.2
log
@semaphore for memory
@
text
@d1 1
a1 1
// $Id$
a24 1
static char MemorySemName[50] ;
d98 22
a119 22
   strcpy(MemorySemName, "OUI Mem SemaphoreXXXXXXXX") ;
   mktemp(MemorySemName) ;

//   Forbid();
    if (!FindSemaphore((UBYTE *)MemorySemName)) {
        MemorySemaphore = (SignalSemaphore *)AllocMem(sizeof(SignalSemaphore), MEMF_CLEAR|MEMF_PUBLIC) ;
        MemorySemaphore->ss_Link.ln_Pri = 0;
        MemorySemaphore->ss_Link.ln_Name = MemorySemName ;
        AddSemaphore(MemorySemaphore);
    }
    else {
//        Permit();
        goto bye ;
    }
//    Permit();

    anyPool = LibCreatePool(MEMF_CLEAR|MEMF_PUBLIC, 10000, 5000) ;
    if (anyPool) {
        chipPool = LibCreatePool(MEMF_CLEAR|MEMF_CHIP, 20000, 10000) ;
        if (!chipPool) {
            LibDeletePool(anyPool) ;
            anyPool = NULL ;
d121 3
a123 6
        chipOxygene = LibAllocPooled(chipPool, OxygeneSize) ;
        if (!chipOxygene) {
            LibDeletePool(anyPool) ;
            LibDeletePool(chipPool) ;
            anyPool = NULL ;
            chipPool = NULL ;
d128 1
a128 1
    if (!chipPool) exit(20) ;
d130 1
a130 1
    return (chipPool)?0:1 ;
a135 7
//    Forbid();
    if (MemorySemaphore = (SignalSemaphore *)
    FindSemaphore((UBYTE *)MemorySemName)) {
        RemSemaphore(MemorySemaphore);
        ObtainSemaphore(MemorySemaphore);
        ReleaseSemaphore(MemorySemaphore);
    }
a136 1
//    Permit();
@


1.1
log
@Initial revision
@
text
@d1 1
d9 2
a10 1
#include <stdio.h>
d12 1
d14 6
a19 14
#include "new.h"

#include <cxxproto/exec.h>
#include <cxxproto/intuition.h>

extern "C" {
APTR __stdargs LibAllocPooled( APTR poolHeader, unsigned long memSize );
APTR __stdargs LibCreatePool( unsigned long memFlags, unsigned long puddleSize,
        unsigned long threshSize );
void __stdargs LibDeletePool( APTR poolHeader );
void __stdargs LibFreePooled( APTR poolHeader, APTR memory, unsigned long memSize );
void kprintf(STRPTR format, ...) ;
}

d21 2
d24 2
d31 1
a31 1
EasyStruct memFail = {
d34 8
a41 3
    "Memory Warning",
    "Allocation of %lu bytes in memory failed.\nPlease free some memory and try again.",
    "Retry|Cancel",
d45 1
a45 1
BOOL __saveds outmem(size_t s)
d49 12
a60 1
    reply = (BOOL)EasyRequest((Window *)myproc->pr_WindowPtr, &memFail, NULL, s) ;
d68 1
d71 6
a76 1
        if (!outmem(s))
d80 1
d86 1
a86 1
unsigned long *l = (unsigned long *)p ;
d88 4
a91 1
    LibFreePooled(anyPool, --l, *l) ;
d94 1
d97 18
a114 1
    myproc = (Process *)FindTask(0);
d122 7
d130 4
d140 9
d152 1
d154 4
@
