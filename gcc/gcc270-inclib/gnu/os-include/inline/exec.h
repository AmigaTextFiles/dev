#ifndef _INLINE_EXEC_H
#define _INLINE_EXEC_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct ExecBase * SysBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME SysBase
#endif

BASE_EXT_DECL0

extern __inline void 
AbortIO (BASE_PAR_DECL struct IORequest *ioRequest)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  __asm __volatile ("jsr a6@(-0x1e0)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddDevice (BASE_PAR_DECL struct Device *device)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Device *a1 __asm("a1") = device;
  __asm __volatile ("jsr a6@(-0x1b0)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddHead (BASE_PAR_DECL struct List *list,struct Node *node)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  register struct Node *a1 __asm("a1") = node;
  __asm __volatile ("jsr a6@(-0xf0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddIntServer (BASE_PAR_DECL long intNumber,struct Interrupt *interrupt)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = intNumber;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0xa8)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddLibrary (BASE_PAR_DECL struct Library *library)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Library *a1 __asm("a1") = library;
  __asm __volatile ("jsr a6@(-0x18c)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddMemHandler (BASE_PAR_DECL struct Interrupt *memhand)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Interrupt *a1 __asm("a1") = memhand;
  __asm __volatile ("jsr a6@(-0x306)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddMemList (BASE_PAR_DECL unsigned long size,unsigned long attributes,long pri,APTR base,UBYTE *name)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = size;
  register unsigned long d1 __asm("d1") = attributes;
  register long d2 __asm("d2") = pri;
  register APTR a0 __asm("a0") = base;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x26a)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1","d2", "memory");
}
extern __inline void 
AddPort (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a1 __asm("a1") = port;
  __asm __volatile ("jsr a6@(-0x162)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddResource (BASE_PAR_DECL APTR resource)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = resource;
  __asm __volatile ("jsr a6@(-0x1e6)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddSemaphore (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a1 __asm("a1") = sigSem;
  __asm __volatile ("jsr a6@(-0x258)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AddTail (BASE_PAR_DECL struct List *list,struct Node *node)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  register struct Node *a1 __asm("a1") = node;
  __asm __volatile ("jsr a6@(-0xf6)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
AddTask (BASE_PAR_DECL struct Task *task,APTR initPC,APTR finalPC)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Task *a1 __asm("a1") = task;
  register APTR a2 __asm("a2") = initPC;
  register APTR a3 __asm("a3") = finalPC;
  __asm __volatile ("jsr a6@(-0x11a)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
extern __inline void 
Alert (BASE_PAR_DECL unsigned long alertNum)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d7 __asm("d7") = alertNum;
  __asm __volatile ("jsr a6@(-0x6c)"
  : /* no output */
  : "r" (a6), "r" (d7)
  : "a0","a1","d0","d1","d7", "memory");
}
extern __inline APTR 
AllocAbs (BASE_PAR_DECL unsigned long byteSize,APTR location)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = byteSize;
  register APTR a1 __asm("a1") = location;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct MemList *
AllocEntry (BASE_PAR_DECL struct MemList *entry)
{
  BASE_EXT_DECL
  register struct MemList * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MemList *a0 __asm("a0") = entry;
  __asm __volatile ("jsr a6@(-0xde)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AllocMem (BASE_PAR_DECL unsigned long byteSize,unsigned long requirements)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = byteSize;
  register unsigned long d1 __asm("d1") = requirements;
  __asm __volatile ("jsr a6@(-0xc6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AllocPooled (BASE_PAR_DECL APTR poolHeader,unsigned long memSize)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = poolHeader;
  register unsigned long d0 __asm("d0") = memSize;
  __asm __volatile ("jsr a6@(-0x2c4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BYTE 
AllocSignal (BASE_PAR_DECL long signalNum)
{
  BASE_EXT_DECL
  register BYTE  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = signalNum;
  __asm __volatile ("jsr a6@(-0x14a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
AllocTrap (BASE_PAR_DECL long trapNum)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = trapNum;
  __asm __volatile ("jsr a6@(-0x156)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AllocVec (BASE_PAR_DECL unsigned long byteSize,unsigned long requirements)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = byteSize;
  register unsigned long d1 __asm("d1") = requirements;
  __asm __volatile ("jsr a6@(-0x2ac)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
Allocate (BASE_PAR_DECL struct MemHeader *freeList,unsigned long byteSize)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MemHeader *a0 __asm("a0") = freeList;
  register unsigned long d0 __asm("d0") = byteSize;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
AttemptSemaphore (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x240)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
AttemptSemaphoreShared (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x2d0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
AvailMem (BASE_PAR_DECL unsigned long requirements)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d1 __asm("d1") = requirements;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
CacheClearE (BASE_PAR_DECL APTR address,unsigned long length,unsigned long caches)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = address;
  register unsigned long d0 __asm("d0") = length;
  register unsigned long d1 __asm("d1") = caches;
  __asm __volatile ("jsr a6@(-0x282)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CacheClearU (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x27c)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
CacheControl (BASE_PAR_DECL unsigned long cacheBits,unsigned long cacheMask)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = cacheBits;
  register unsigned long d1 __asm("d1") = cacheMask;
  __asm __volatile ("jsr a6@(-0x288)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
CachePostDMA (BASE_PAR_DECL APTR address,ULONG *length,unsigned long flags)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = address;
  register ULONG *a1 __asm("a1") = length;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0x300)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
CachePreDMA (BASE_PAR_DECL APTR address,ULONG *length,unsigned long flags)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = address;
  register ULONG *a1 __asm("a1") = length;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0x2fa)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Cause (BASE_PAR_DECL struct Interrupt *interrupt)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0xb4)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct IORequest *
CheckIO (BASE_PAR_DECL struct IORequest *ioRequest)
{
  BASE_EXT_DECL
  register struct IORequest * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  __asm __volatile ("jsr a6@(-0x1d4)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ChildFree (BASE_PAR_DECL APTR tid)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR d0 __asm("d0") = tid;
  __asm __volatile ("jsr a6@(-0x2e2)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ChildOrphan (BASE_PAR_DECL APTR tid)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR d0 __asm("d0") = tid;
  __asm __volatile ("jsr a6@(-0x2e8)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ChildStatus (BASE_PAR_DECL APTR tid)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR d0 __asm("d0") = tid;
  __asm __volatile ("jsr a6@(-0x2ee)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ChildWait (BASE_PAR_DECL APTR tid)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR d0 __asm("d0") = tid;
  __asm __volatile ("jsr a6@(-0x2f4)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CloseDevice (BASE_PAR_DECL struct IORequest *ioRequest)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  __asm __volatile ("jsr a6@(-0x1c2)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CloseLibrary (BASE_PAR_DECL struct Library *library)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Library *a1 __asm("a1") = library;
  __asm __volatile ("jsr a6@(-0x19e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ColdReboot (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x2d6)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CopyMem (BASE_PAR_DECL APTR source,APTR dest,unsigned long size)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = source;
  register APTR a1 __asm("a1") = dest;
  register unsigned long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x270)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
CopyMemQuick (BASE_PAR_DECL APTR source,APTR dest,unsigned long size)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = source;
  register APTR a1 __asm("a1") = dest;
  register unsigned long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x276)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
CreateIORequest (BASE_PAR_DECL struct MsgPort *port,unsigned long size)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  register unsigned long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x28e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct MsgPort *
CreateMsgPort (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x29a)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
CreatePool (BASE_PAR_DECL unsigned long requirements,unsigned long puddleSize,unsigned long threshSize)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = requirements;
  register unsigned long d1 __asm("d1") = puddleSize;
  register unsigned long d2 __asm("d2") = threshSize;
  __asm __volatile ("jsr a6@(-0x2b8)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline void 
Deallocate (BASE_PAR_DECL struct MemHeader *freeList,APTR memoryBlock,unsigned long byteSize)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MemHeader *a0 __asm("a0") = freeList;
  register APTR a1 __asm("a1") = memoryBlock;
  register unsigned long d0 __asm("d0") = byteSize;
  __asm __volatile ("jsr a6@(-0xc0)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
Debug (BASE_PAR_DECL unsigned long flags)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DeleteIORequest (BASE_PAR_DECL APTR iorequest)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = iorequest;
  __asm __volatile ("jsr a6@(-0x294)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DeleteMsgPort (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  __asm __volatile ("jsr a6@(-0x2a0)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DeletePool (BASE_PAR_DECL APTR poolHeader)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = poolHeader;
  __asm __volatile ("jsr a6@(-0x2be)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
Disable (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BYTE 
DoIO (BASE_PAR_DECL struct IORequest *ioRequest)
{
  BASE_EXT_DECL
  register BYTE  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  __asm __volatile ("jsr a6@(-0x1c8)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Enable (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
Enqueue (BASE_PAR_DECL struct List *list,struct Node *node)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  register struct Node *a1 __asm("a1") = node;
  __asm __volatile ("jsr a6@(-0x10e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Node *
FindName (BASE_PAR_DECL struct List *list,UBYTE *name)
{
  BASE_EXT_DECL
  register struct Node * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x114)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct MsgPort *
FindPort (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct MsgPort * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x186)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Resident *
FindResident (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct Resident * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct SignalSemaphore *
FindSemaphore (BASE_PAR_DECL UBYTE *sigSem)
{
  BASE_EXT_DECL
  register struct SignalSemaphore * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = sigSem;
  __asm __volatile ("jsr a6@(-0x252)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Task *
FindTask (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct Task * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x126)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Forbid (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeEntry (BASE_PAR_DECL struct MemList *entry)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MemList *a0 __asm("a0") = entry;
  __asm __volatile ("jsr a6@(-0xe4)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeMem (BASE_PAR_DECL APTR memoryBlock,unsigned long byteSize)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = memoryBlock;
  register unsigned long d0 __asm("d0") = byteSize;
  __asm __volatile ("jsr a6@(-0xd2)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreePooled (BASE_PAR_DECL APTR poolHeader,APTR memory,unsigned long memSize)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = poolHeader;
  register APTR a1 __asm("a1") = memory;
  register unsigned long d0 __asm("d0") = memSize;
  __asm __volatile ("jsr a6@(-0x2ca)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeSignal (BASE_PAR_DECL long signalNum)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = signalNum;
  __asm __volatile ("jsr a6@(-0x150)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeTrap (BASE_PAR_DECL long trapNum)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = trapNum;
  __asm __volatile ("jsr a6@(-0x15c)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeVec (BASE_PAR_DECL APTR memoryBlock)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = memoryBlock;
  __asm __volatile ("jsr a6@(-0x2b2)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
GetCC (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x210)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Message *
GetMsg (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct Message * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  __asm __volatile ("jsr a6@(-0x174)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
InitCode (BASE_PAR_DECL unsigned long startClass,unsigned long version)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = startClass;
  register unsigned long d1 __asm("d1") = version;
  __asm __volatile ("jsr a6@(-0x48)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
InitResident (BASE_PAR_DECL struct Resident *resident,unsigned long segList)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Resident *a1 __asm("a1") = resident;
  register unsigned long d1 __asm("d1") = segList;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
InitSemaphore (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x22e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InitStruct (BASE_PAR_DECL APTR initTable,APTR memory,unsigned long size)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = initTable;
  register APTR a2 __asm("a2") = memory;
  register unsigned long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (a2), "r" (d0)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
Insert (BASE_PAR_DECL struct List *list,struct Node *node,struct Node *pred)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  register struct Node *a1 __asm("a1") = node;
  register struct Node *a2 __asm("a2") = pred;
  __asm __volatile ("jsr a6@(-0xea)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
MakeFunctions (BASE_PAR_DECL APTR target,APTR functionArray,unsigned long funcDispBase)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = target;
  register APTR a1 __asm("a1") = functionArray;
  register unsigned long a2 __asm("a2") = funcDispBase;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline struct Library *
MakeLibrary (BASE_PAR_DECL APTR funcInit,APTR structInit,unsigned long (*libInit)(),unsigned long dataSize,unsigned long segList)
{
  BASE_EXT_DECL
  register struct Library * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = funcInit;
  register APTR a1 __asm("a1") = structInit;
  register unsigned long (*a2)() __asm("a2") = libInit;
  register unsigned long d0 __asm("d0") = dataSize;
  register unsigned long d1 __asm("d1") = segList;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
ObtainQuickVector (BASE_PAR_DECL APTR interruptCode)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = interruptCode;
  __asm __volatile ("jsr a6@(-0x312)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ObtainSemaphore (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x234)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ObtainSemaphoreList (BASE_PAR_DECL struct List *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x246)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ObtainSemaphoreShared (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x2a6)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Library *
OldOpenLibrary (BASE_PAR_DECL UBYTE *libName)
{
  BASE_EXT_DECL
  register struct Library * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = libName;
  __asm __volatile ("jsr a6@(-0x198)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BYTE 
OpenDevice (BASE_PAR_DECL UBYTE *devName,unsigned long unit,struct IORequest *ioRequest,unsigned long flags)
{
  BASE_EXT_DECL
  register BYTE  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = devName;
  register unsigned long d0 __asm("d0") = unit;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  register unsigned long d1 __asm("d1") = flags;
  __asm __volatile ("jsr a6@(-0x1bc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Library *
OpenLibrary (BASE_PAR_DECL UBYTE *libName,unsigned long version)
{
  BASE_EXT_DECL
  register struct Library * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = libName;
  register unsigned long d0 __asm("d0") = version;
  __asm __volatile ("jsr a6@(-0x228)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
OpenResource (BASE_PAR_DECL UBYTE *resName)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a1 __asm("a1") = resName;
  __asm __volatile ("jsr a6@(-0x1f2)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Permit (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x8a)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
Procure (BASE_PAR_DECL struct SignalSemaphore *sigSem,struct SemaphoreMessage *bidMsg)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  register struct SemaphoreMessage *a1 __asm("a1") = bidMsg;
  __asm __volatile ("jsr a6@(-0x21c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
PutMsg (BASE_PAR_DECL struct MsgPort *port,struct Message *message)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  register struct Message *a1 __asm("a1") = message;
  __asm __volatile ("jsr a6@(-0x16e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
RawDoFmt (BASE_PAR_DECL UBYTE *formatString,APTR dataStream,void (*putChProc)(),APTR putChData)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = formatString;
  register APTR a1 __asm("a1") = dataStream;
  register void (*a2)() __asm("a2") = putChProc;
  register APTR a3 __asm("a3") = putChData;
  __asm __volatile ("jsr a6@(-0x20a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
extern __inline void 
ReleaseSemaphore (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x23a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ReleaseSemaphoreList (BASE_PAR_DECL struct List *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = sigSem;
  __asm __volatile ("jsr a6@(-0x24c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemDevice (BASE_PAR_DECL struct Device *device)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Device *a1 __asm("a1") = device;
  __asm __volatile ("jsr a6@(-0x1b6)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Node *
RemHead (BASE_PAR_DECL struct List *list)
{
  BASE_EXT_DECL
  register struct Node * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  __asm __volatile ("jsr a6@(-0x102)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
RemIntServer (BASE_PAR_DECL long intNumber,struct Interrupt *interrupt)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = intNumber;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0xae)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemLibrary (BASE_PAR_DECL struct Library *library)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Library *a1 __asm("a1") = library;
  __asm __volatile ("jsr a6@(-0x192)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemMemHandler (BASE_PAR_DECL struct Interrupt *memhand)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Interrupt *a1 __asm("a1") = memhand;
  __asm __volatile ("jsr a6@(-0x30c)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemPort (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a1 __asm("a1") = port;
  __asm __volatile ("jsr a6@(-0x168)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemResource (BASE_PAR_DECL APTR resource)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = resource;
  __asm __volatile ("jsr a6@(-0x1ec)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemSemaphore (BASE_PAR_DECL struct SignalSemaphore *sigSem)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a1 __asm("a1") = sigSem;
  __asm __volatile ("jsr a6@(-0x25e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct Node *
RemTail (BASE_PAR_DECL struct List *list)
{
  BASE_EXT_DECL
  register struct Node * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct List *a0 __asm("a0") = list;
  __asm __volatile ("jsr a6@(-0x108)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
RemTask (BASE_PAR_DECL struct Task *task)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Task *a1 __asm("a1") = task;
  __asm __volatile ("jsr a6@(-0x120)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
Remove (BASE_PAR_DECL struct Node *node)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Node *a1 __asm("a1") = node;
  __asm __volatile ("jsr a6@(-0xfc)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ReplyMsg (BASE_PAR_DECL struct Message *message)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Message *a1 __asm("a1") = message;
  __asm __volatile ("jsr a6@(-0x17a)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SendIO (BASE_PAR_DECL struct IORequest *ioRequest)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  __asm __volatile ("jsr a6@(-0x1ce)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
SetExcept (BASE_PAR_DECL unsigned long newSignals,unsigned long signalSet)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = newSignals;
  register unsigned long d1 __asm("d1") = signalSet;
  __asm __volatile ("jsr a6@(-0x138)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
SetFunction (BASE_PAR_DECL struct Library *library,long funcOffset,unsigned long (*newFunction)())
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Library *a1 __asm("a1") = library;
  register long a0 __asm("a0") = funcOffset;
  register unsigned long (*d0)() __asm("d0") = newFunction;
  __asm __volatile ("jsr a6@(-0x1a4)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Interrupt *
SetIntVector (BASE_PAR_DECL long intNumber,struct Interrupt *interrupt)
{
  BASE_EXT_DECL
  register struct Interrupt * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = intNumber;
  register struct Interrupt *a1 __asm("a1") = interrupt;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
SetSR (BASE_PAR_DECL unsigned long newSR,unsigned long mask)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = newSR;
  register unsigned long d1 __asm("d1") = mask;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
SetSignal (BASE_PAR_DECL unsigned long newSignals,unsigned long signalSet)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = newSignals;
  register unsigned long d1 __asm("d1") = signalSet;
  __asm __volatile ("jsr a6@(-0x132)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BYTE 
SetTaskPri (BASE_PAR_DECL struct Task *task,long priority)
{
  BASE_EXT_DECL
  register BYTE  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Task *a1 __asm("a1") = task;
  register long d0 __asm("d0") = priority;
  __asm __volatile ("jsr a6@(-0x12c)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Signal (BASE_PAR_DECL struct Task *task,unsigned long signalSet)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Task *a1 __asm("a1") = task;
  register unsigned long d0 __asm("d0") = signalSet;
  __asm __volatile ("jsr a6@(-0x144)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
StackSwap (BASE_PAR_DECL struct StackSwapStruct *newStack)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct StackSwapStruct *a0 __asm("a0") = newStack;
  __asm __volatile ("jsr a6@(-0x2dc)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
SumKickData (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x264)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SumLibrary (BASE_PAR_DECL struct Library *library)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct Library *a1 __asm("a1") = library;
  __asm __volatile ("jsr a6@(-0x1aa)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
SuperState (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
Supervisor (BASE_PAR_DECL unsigned long (*userFunction)())
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long (*a2)() __asm("a2") = userFunction;
  __asm __volatile ("exg a2,a5\n\tjsr a6@(-0x1e)\n\texg a2,a5"
  : "=r" (_res)
  : "r" (a6), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
TypeOfMem (BASE_PAR_DECL APTR address)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR a1 __asm("a1") = address;
  __asm __volatile ("jsr a6@(-0x216)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
UserState (BASE_PAR_DECL APTR sysStack)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register APTR d0 __asm("d0") = sysStack;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
Vacate (BASE_PAR_DECL struct SignalSemaphore *sigSem,struct SemaphoreMessage *bidMsg)
{
  BASE_EXT_DECL
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct SignalSemaphore *a0 __asm("a0") = sigSem;
  register struct SemaphoreMessage *a1 __asm("a1") = bidMsg;
  __asm __volatile ("jsr a6@(-0x222)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
Wait (BASE_PAR_DECL unsigned long signalSet)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = signalSet;
  __asm __volatile ("jsr a6@(-0x13e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BYTE 
WaitIO (BASE_PAR_DECL struct IORequest *ioRequest)
{
  BASE_EXT_DECL
  register BYTE  _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct IORequest *a1 __asm("a1") = ioRequest;
  __asm __volatile ("jsr a6@(-0x1da)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Message *
WaitPort (BASE_PAR_DECL struct MsgPort *port)
{
  BASE_EXT_DECL
  register struct Message * _res  __asm("d0");
  register struct ExecBase *a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  __asm __volatile ("jsr a6@(-0x180)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_EXEC_H */
