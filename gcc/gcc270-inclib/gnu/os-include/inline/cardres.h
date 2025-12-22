#ifndef _INLINE_CARDRES_H
#define _INLINE_CARDRES_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Node * CardResource;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME CardResource
#endif

BASE_EXT_DECL0

extern __inline BOOL 
BeginCardAccess (BASE_PAR_DECL struct CardHandle *handle)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  __asm __volatile ("jsr a6@(-0x18)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CardAccessSpeed (BASE_PAR_DECL struct CardHandle *handle,unsigned long nanoseconds)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  register unsigned long d0 __asm("d0") = nanoseconds;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CardChangeCount (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
CardForceChange (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CardInterface (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UBYTE 
CardMiscControl (BASE_PAR_DECL struct CardHandle *handle,unsigned long control_bits)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  register unsigned long d1 __asm("d1") = control_bits;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
CardProgramVoltage (BASE_PAR_DECL struct CardHandle *handle,unsigned long voltage)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  register unsigned long d0 __asm("d0") = voltage;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
CardResetCard (BASE_PAR_DECL struct CardHandle *handle)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
CardResetRemove (BASE_PAR_DECL struct CardHandle *handle,unsigned long flag)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  register unsigned long d0 __asm("d0") = flag;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
CopyTuple (BASE_PAR_DECL struct CardHandle *handle,UBYTE *buffer,unsigned long tuplecode,unsigned long size)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  register UBYTE *a0 __asm("a0") = buffer;
  register unsigned long d1 __asm("d1") = tuplecode;
  register unsigned long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0), "r" (d1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
DeviceTuple (BASE_PAR_DECL UBYTE *tuple_data,struct DeviceTData *storage)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = tuple_data;
  register struct DeviceTData *a1 __asm("a1") = storage;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
EndCardAccess (BASE_PAR_DECL struct CardHandle *handle)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct CardMemoryMap *
GetCardMap (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct CardMemoryMap * _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x12)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct Resident *
IfAmigaXIP (BASE_PAR_DECL struct CardHandle *handle)
{
  BASE_EXT_DECL
  register struct Resident * _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a2 __asm("a2") = handle;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline struct CardHandle *
OwnCard (BASE_PAR_DECL struct CardHandle *handle)
{
  BASE_EXT_DECL
  register struct CardHandle * _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  __asm __volatile ("jsr a6@(-0x6)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UBYTE 
ReadCardStatus (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct Node *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ReleaseCard (BASE_PAR_DECL struct CardHandle *handle,unsigned long flags)
{
  BASE_EXT_DECL
  register struct Node *a6 __asm("a6") = BASE_NAME;
  register struct CardHandle *a1 __asm("a1") = handle;
  register unsigned long d0 __asm("d0") = flags;
  __asm __volatile ("jsr a6@(-0xc)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_CARDRES_H */
