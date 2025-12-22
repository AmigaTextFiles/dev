#ifndef POWERPC_MEMORYPPC_H
#define POWERPC_MEMORYPPC_H

#ifndef EXEC_MEMORY_H
MODULE  'exec/memory'
#endif
#define MEMB_WRITETHROUGH 20
#define MEMB_COPYBACK     21
#define MEMB_CACHEON      22
#define MEMB_CACHEOFF     23
#define MEMB_GUARDED      24
#define MEMB_NOTGUARDED   25
#define MEMB_BAT          26
#define MEMB_PROTECT      27
#define MEMB_WRITEPROTECT 28
#define MEMF_WRITETHROUGH (1<<20)
#define MEMF_COPYBACK     (1<<21)
#define MEMF_CACHEON      (1<<22)
#define MEMF_CACHEOFF     (1<<23)
#define MEMF_GUARDED      (1<<24)
#define MEMF_NOTGUARDED   (1<<25)
#define MEMF_BAT          (1<<26)
#define MEMF_PROTECT      (1<<27)
#define MEMF_WRITEPROTECT (1<<28)

#define MEMERR_SUCCESS   0
#endif
