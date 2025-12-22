#ifndef _INLINE_EXPANSION_H
#define _INLINE_EXPANSION_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct ExpansionBase * ExpansionBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME ExpansionBase
#endif

BASE_EXT_DECL0

extern __inline BOOL 
AddBootNode (BASE_PAR_DECL long bootPri,unsigned long flags,struct DeviceNode *deviceNode,struct ConfigDev *configDev)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = bootPri;
  register unsigned long d1 __asm("d1") = flags;
  register struct DeviceNode *a0 __asm("a0") = deviceNode;
  register struct ConfigDev *a1 __asm("a1") = configDev;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
AddConfigDev (BASE_PAR_DECL struct ConfigDev *configDev)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register struct ConfigDev *a0 __asm("a0") = configDev;
  __asm __volatile ("jsr a6@(-0x1e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline BOOL 
AddDosNode (BASE_PAR_DECL long bootPri,unsigned long flags,struct DeviceNode *deviceNode)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = bootPri;
  register unsigned long d1 __asm("d1") = flags;
  register struct DeviceNode *a0 __asm("a0") = deviceNode;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
AllocBoardMem (BASE_PAR_DECL unsigned long slotSpec)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = slotSpec;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct ConfigDev *
AllocConfigDev (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ConfigDev * _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
AllocExpansionMem (BASE_PAR_DECL unsigned long numSlots,unsigned long slotAlign)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = numSlots;
  register unsigned long d1 __asm("d1") = slotAlign;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ConfigBoard (BASE_PAR_DECL APTR board,struct ConfigDev *configDev)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = board;
  register struct ConfigDev *a1 __asm("a1") = configDev;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ConfigChain (BASE_PAR_DECL APTR baseAddr)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = baseAddr;
  __asm __volatile ("jsr a6@(-0x42)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct ConfigDev *
FindConfigDev (BASE_PAR_DECL struct ConfigDev *oldConfigDev,long manufacturer,long product)
{
  BASE_EXT_DECL
  register struct ConfigDev * _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register struct ConfigDev *a0 __asm("a0") = oldConfigDev;
  register long d0 __asm("d0") = manufacturer;
  register long d1 __asm("d1") = product;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
FreeBoardMem (BASE_PAR_DECL unsigned long startSlot,unsigned long slotSpec)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = startSlot;
  register unsigned long d1 __asm("d1") = slotSpec;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeConfigDev (BASE_PAR_DECL struct ConfigDev *configDev)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register struct ConfigDev *a0 __asm("a0") = configDev;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeExpansionMem (BASE_PAR_DECL unsigned long startSlot,unsigned long numSlots)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = startSlot;
  register unsigned long d1 __asm("d1") = numSlots;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
GetCurrentBinding (BASE_PAR_DECL struct CurrentBinding *currentBinding,unsigned long bindingSize)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register struct CurrentBinding *a0 __asm("a0") = currentBinding;
  register unsigned long d0 __asm("d0") = bindingSize;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct DeviceNode *
MakeDosNode (BASE_PAR_DECL APTR parmPacket)
{
  BASE_EXT_DECL
  register struct DeviceNode * _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = parmPacket;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ObtainConfigBinding (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline UBYTE 
ReadExpansionByte (BASE_PAR_DECL APTR board,unsigned long offset)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = board;
  register unsigned long d0 __asm("d0") = offset;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
ReadExpansionRom (BASE_PAR_DECL APTR board,struct ConfigDev *configDev)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = board;
  register struct ConfigDev *a1 __asm("a1") = configDev;
  __asm __volatile ("jsr a6@(-0x66)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ReleaseConfigBinding (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemConfigDev (BASE_PAR_DECL struct ConfigDev *configDev)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register struct ConfigDev *a0 __asm("a0") = configDev;
  __asm __volatile ("jsr a6@(-0x6c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SetCurrentBinding (BASE_PAR_DECL struct CurrentBinding *currentBinding,unsigned long bindingSize)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register struct CurrentBinding *a0 __asm("a0") = currentBinding;
  register unsigned long d0 __asm("d0") = bindingSize;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
WriteExpansionByte (BASE_PAR_DECL APTR board,unsigned long offset,unsigned long byte)
{
  BASE_EXT_DECL
  register struct ExpansionBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = board;
  register unsigned long d0 __asm("d0") = offset;
  register unsigned long d1 __asm("d1") = byte;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_EXPANSION_H */
