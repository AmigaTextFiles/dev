#ifndef _INLINE_NONVOLATILE_H
#define _INLINE_NONVOLATILE_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * NVBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME NVBase
#endif

BASE_EXT_DECL0

extern __inline BOOL 
DeleteNV (BASE_PAR_DECL STRPTR appName,STRPTR itemName,long killRequesters)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = appName;
  register STRPTR a1 __asm("a1") = itemName;
  register long d1 __asm("d1") = killRequesters;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
FreeNVData (BASE_PAR_DECL APTR data)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = data;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline APTR 
GetCopyNV (BASE_PAR_DECL STRPTR appName,STRPTR itemName,long killRequesters)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = appName;
  register STRPTR a1 __asm("a1") = itemName;
  register long d1 __asm("d1") = killRequesters;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct NVInfo *
GetNVInfo (BASE_PAR_DECL long killRequesters)
{
  BASE_EXT_DECL
  register struct NVInfo * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register long d1 __asm("d1") = killRequesters;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct MinList *
GetNVList (BASE_PAR_DECL STRPTR appName,long killRequesters)
{
  BASE_EXT_DECL
  register struct MinList * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = appName;
  register long d1 __asm("d1") = killRequesters;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
SetNVProtection (BASE_PAR_DECL STRPTR appName,STRPTR itemName,long mask,long killRequesters)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = appName;
  register STRPTR a1 __asm("a1") = itemName;
  register long d2 __asm("d2") = mask;
  register long d1 __asm("d1") = killRequesters;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d2), "r" (d1)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline UWORD 
StoreNV (BASE_PAR_DECL STRPTR appName,STRPTR itemName,APTR data,unsigned long length,long killRequesters)
{
  BASE_EXT_DECL
  register UWORD  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = appName;
  register STRPTR a1 __asm("a1") = itemName;
  register APTR a2 __asm("a2") = data;
  register unsigned long d0 __asm("d0") = length;
  register long d1 __asm("d1") = killRequesters;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0), "r" (d1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_NONVOLATILE_H */
