/*******************************************************************
 *                                                                 *
 *                           LibFuncs.c                            *
 *                                                                 *
 *           Basic Shared Library Functions                        *
 *           for IPC Library Module                                *
 *                                                                 *
 *              Release  2.0 -- 1989 March 26                      *
 *                                                                 *
 *              Copyright 1988,1989 Peter Goodeve                  *
 *                                                                 *
 *  This source is freely distributable, but its functionality     *
 *  should not be modified without prior consultation with the     *
 *  author.  [Don't forget this is a SHARED library!]              *
 *                                                                 *
 *******************************************************************/

/*******************************************************************
 *                                                                 *
 *   This code has only been tested under Lattice 5.02.            *
 *   It MUST be compiled with -b0 -v options                       *
 *   (32 bit addressing & no stack check).                         *
 *   The "__asm" keyword and associated mechanisms have been used  *
 *   to allow direct passing of parameters in registers.           *
 *                                                                 *
 ******************************************************************/

/* As we're restricted to Lattice 5, use direct Exec calls: */
#include <proto/exec.h>

#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/tasks.h>



/* In this version we are using direct addressing of global data exclusively,
    so we don't bother to use the library structure for private data */

extern struct List PortList;  /* (IPCLib.c) All IPC Ports are on this list */

extern APTR SysBase; /* ...in c.o -- or LibTag if autoload */

extern UWORD libVersion;    /* in LibTables -- update as necessary */
extern UWORD libRev;

APTR   seglist=NULL;



struct library * __asm libInitFunc(
        register __a0 APTR seg, register __a6 APTR sys,
        register __d0 struct Library * libp)
{
    SysBase = sys;
    seglist=seg;
    libp->lib_Version = libVersion;
    libp->lib_Revision = libRev;

    NewList(&PortList);

    return libp;
}


struct Library * __asm libOpen(register __a6 struct Library * libp)
{
    libp->lib_OpenCnt++;
    libp->lib_Flags &= ~LIBF_DELEXP;
    return libp;
}


/* This is put first to avoid forward ref: */
APTR __asm libExpunge(register __a6 struct Library * libp)
{
    char * lib_base;    /* generic pointer to be calculated */
    if (libp->lib_OpenCnt) {
        libp->lib_Flags |= LIBF_DELEXP;
        return 0;
    }

    /******************************************************/
    /* IPC library must also check that there are no IPC Ports
    on the list before allowing Expunge */

    if (PortList.lh_Head->ln_Succ) return 0;

    /******************************************************/

    /* CAUTION!: compiler generated code MUST use either SysBase
       or AbsExecBase for access to the following! */
    Remove((struct Node *)libp);
    lib_base = ((char *)libp)-libp->lib_NegSize;
    FreeMem(lib_base, (libp->lib_NegSize + libp->lib_PosSize));
    return seglist;   /* for now */
}


APTR __asm libClose(register __a6 struct Library * libp)
{
    if (--libp->lib_OpenCnt || !(libp->lib_Flags & LIBF_DELEXP)) return 0;
    else return libExpunge(libp);
}


ULONG libExtFunc()
{
    return 0;
}


            /*********************************************/

