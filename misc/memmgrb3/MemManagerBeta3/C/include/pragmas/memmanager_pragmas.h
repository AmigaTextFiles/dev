#ifndef _INCLUDE_PRAGMA_MEMMANAGER_LIB_H
#define _INCLUDE_PRAGMA_MEMMANAGER_LIB_H

/*
**  $VER: memmanager_lib.h 3.14 (19.9.1996)
**
**  '(C) Copyright 1996 Robert Ennals
*/

#ifndef  CLIB_MEMMANAGER_PROTOS_H
#include <clib/memmanager_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(MemManagerBase, 0x1e, CreateVMem(d0,d1,d2,d3))
#pragma amicall(MemManagerBase, 0x24, RemoveVMem(a1))
#pragma amicall(MemManagerBase, 0x2a, LockVMem(a1))
#pragma amicall(MemManagerBase, 0x30, UnlockVMem(a1))
#pragma amicall(MemManagerBase, 0x36, ChangeVMemPri(a1,d0))
#pragma amicall(MemManagerBase, 0x3c, PurgeVMem(d1))
#pragma amicall(MemManagerBase, 0x42, ChangeVMemType(a1,d0))
#pragma amicall(MemManagerBase, 0x48, DefineVMemHierachy(a1))
#pragma amicall(MemManagerBase, 0x4e, ClearVMemHierachy(a1))
#pragma amicall(MemManagerBase, 0x54, Publish(a1))
#pragma amicall(MemManagerBase, 0x5a, Protect(a1))

#ifdef __cplusplus
}
#endif

#endif
