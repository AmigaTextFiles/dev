/*
** ObjectiveAmiga: NeXTSTEP NXZone emulation under AmigaOS
** See GNU:lib/libobjam/ReadMe for details
*/


#include <exec/memory.h>
#include <exec/exec.h>
#include <clib/alib_protos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <stddef.h>

#include <clib/objc_protos.h>

#include "misc.h" /* For the ANSI function emulations */


#define max(a,b) (((a)>(a))?(b):(b))
#define min(a,b) (((a)>(b))?(b):(a))


#ifdef AMIGAOS_39
#define nxCreatePool(a,b,c)  CreatePool(a,b,c)
#define nxDeletePool(a)      DeletePool(a)
#define nxAllocPooled(a,b)   AllocPooled(a,b)
#define nxFreePooled(a,b,c)  FreePooled(a,b,c)
#else
#define nxCreatePool(a,b,c)  LibCreatePool(a,b,c)
#define nxDeletePool(a)      LibDeletePool(a)
#define nxAllocPooled(a,b)   LibAllocPooled(a,b)
#define nxFreePooled(a,b,c)  LibFreePooled(a,b,c)
#endif


/* Our real zone */
struct __NXZone
{
  void *pool;
  BOOL canFree;
  char *name;
};


/* A memory block header */
struct NXBlock
{
  int size; /* Without NXBlock */
  struct __NXZone *zone;
};


/* Useful macros */
#define BLOCK2PTR(b)  ((void *)(((size_t)b)+sizeof(struct NXBlock)))
#define PTR2BLOCK(p)  ((struct NXBlock *)((size_t)p-sizeof(struct NXBlock)))
#define ZONE          ((struct __NXZone *)(zone))


NXZone *__DefaultMallocZone;


NXZone *NXCreateZone(size_t startSize, size_t granularity, int canFree)
{
  void *pool;
  NXZone *zone;

  if(!(pool=nxCreatePool(MEMF_CLEAR|MEMF_ANY, granularity, granularity))) return NULL;
  if(!(zone=(struct __NXZone *)nxAllocPooled(pool,sizeof(struct __NXZone)))) { nxDeletePool(pool); return NULL; }

  ZONE->pool=pool;
  ZONE->canFree=canFree;

  return zone;
}


NXZone *NXCreateChildZone(NXZone *parentZone, size_t startSize, size_t granularity, int canFree)
{
  return parentZone;
}


void NXMergeZone(NXZone *zone)
{
}


NXZone *NXZoneFromPtr(void *ptr)
{
  if(!ptr) return NULL;
  return (NXZone *)(((struct NXBlock *)((size_t)ptr-sizeof(struct NXBlock)))->zone);
}


void NXDestroyZone(NXZone *zone)
{
  nxDeletePool(ZONE->pool);
}


void *NXZoneMalloc(NXZone *zone, int size)
{
  struct NXBlock *block;

  if(!(block=(struct NXBlock *)nxAllocPooled(ZONE->pool,size+sizeof(struct NXBlock)))) return NULL;
  block->size=size;
  block->zone=zone;

  return BLOCK2PTR(block);
}


void *NXZoneCalloc(NXZone *zone, int numElements, int elementSize)
{
  return NXZoneMalloc(zone,numElements*elementSize);
}


void *NXZoneRealloc(NXZone *zone, void *block, int size)
{
  void *newBlock;

  if(!(newBlock=NXZoneMalloc(zone,size))) return NULL;
  CopyMem( (APTR)block,(APTR)newBlock,min(PTR2BLOCK(block)->size,size) );
  return newBlock;
}


void NXZoneFree(NXZone *zone, void *block)
{
  if(block&&zone)
    if(ZONE->canFree)
      nxFreePooled( ZONE->pool, (void *)(PTR2BLOCK(block)), PTR2BLOCK(block)->size+sizeof(struct NXBlock) );
}


void NXNameZone(NXZone *zone, const char *name)
{
  ZONE->name=(char *)name;
}


void NXZonePtrInfo(void *ptr)
{
  struct __NXZone *zone=PTR2BLOCK(ptr)->zone;

  printf("*** Memory pointer info:\n  Memory block at... %lx\n  In zone at........ %lx\n  With name......... %s\n",(int)ptr,(int)zone,(zone->name)?(zone->name):("<none>"));
}


NXZone *NXDefaultMallocZone(void)
{
  return __DefaultMallocZone;
}


int NXMallocCheck(void)
{
  return 0;
}
