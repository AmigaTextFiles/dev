#ifndef  CLIB_MEMMANAGER_PROTOS_H
#define  CLIB_MEMMANAGER_PROTOS_H

/*
**      $VER: memmanager_protos.h 2.11 (27.8.96)
**      by Robert Ennals
**
**      (c) 1996 Robert Ennals
**
**      These are prototypes for the memmanager library and
**      testmemmanager library (evaluation version)
**      different fds, libs and pragmas are required for
**      the two libraries.
**
*/

APTR    CreateVMem(long memsize, long memflags, long initpri, long vmemflags);
void    RemoveVMem(APTR obj);
APTR    LockVMem(APTR obj);
void    UnlockVMem(APTR obj);
void    ChangeVMemPri(APTR obj, long mempri);
long    PurgeVMem(long memflags);
void    ChangeVMemType(APTR obj, long vmemflags);
void    DefineVMemHierachy(APTR hierachy);
void    ClearVMemHierachy(APTR hierachy);
void    Publish(APTR obj);
void    Protect(APTR obj);

#endif /* CLIB_MEMMANGER_PROTOS_H */


