#ifndef _INLINE_AMIGAGUIDE_H
#define _INLINE_AMIGAGUIDE_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * AmigaGuideBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME AmigaGuideBase
#endif

BASE_EXT_DECL0

extern __inline APTR 
AddAmigaGuideHostA (BASE_PAR_DECL struct Hook *h,STRPTR name,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Hook *a0 __asm("a0") = h;
  register STRPTR d0 __asm("d0") = name;
  register struct TagItem *a1 __asm("a1") = attrs;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define AddAmigaGuideHost(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; AddAmigaGuideHostA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
AmigaGuideSignal (BASE_PAR_DECL APTR cl)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
CloseAmigaGuide (BASE_PAR_DECL APTR cl)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  __asm __volatile ("jsr a6@(-0x42)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ExpungeXRef (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
GetAmigaGuideAttr (BASE_PAR_DECL Tag tag,APTR cl,ULONG *storage)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tag;
  register APTR a0 __asm("a0") = cl;
  register ULONG *a1 __asm("a1") = storage;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct AmigaGuideMsg *
GetAmigaGuideMsg (BASE_PAR_DECL APTR cl)
{
  BASE_EXT_DECL
  register struct AmigaGuideMsg * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline STRPTR 
GetAmigaGuideString (BASE_PAR_DECL long id)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = id;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
LoadXRef (BASE_PAR_DECL BPTR lock,STRPTR name)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register BPTR a0 __asm("a0") = lock;
  register STRPTR a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
LockAmigaGuideBase (BASE_PAR_DECL APTR handle)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = handle;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
OpenAmigaGuideA (BASE_PAR_DECL struct NewAmigaGuide *nag,struct TagItem *tags)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct NewAmigaGuide *a0 __asm("a0") = nag;
  register struct TagItem *a1 __asm("a1") = tags;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define OpenAmigaGuide(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; OpenAmigaGuideA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline APTR 
OpenAmigaGuideAsyncA (BASE_PAR_DECL struct NewAmigaGuide *nag,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct NewAmigaGuide *a0 __asm("a0") = nag;
  register struct TagItem *d0 __asm("d0") = attrs;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define OpenAmigaGuideAsync(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; OpenAmigaGuideAsyncA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline LONG 
RemoveAmigaGuideHostA (BASE_PAR_DECL APTR hh,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = hh;
  register struct TagItem *a1 __asm("a1") = attrs;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define RemoveAmigaGuideHost(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; RemoveAmigaGuideHostA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
ReplyAmigaGuideMsg (BASE_PAR_DECL struct AmigaGuideMsg *amsg)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct AmigaGuideMsg *a0 __asm("a0") = amsg;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
SendAmigaGuideCmdA (BASE_PAR_DECL APTR cl,STRPTR cmd,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  register STRPTR d0 __asm("d0") = cmd;
  register struct TagItem *d1 __asm("d1") = attrs;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SendAmigaGuideCmd(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; SendAmigaGuideCmdA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline LONG 
SendAmigaGuideContextA (BASE_PAR_DECL APTR cl,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  register struct TagItem *d0 __asm("d0") = attrs;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SendAmigaGuideContext(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SendAmigaGuideContextA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline LONG 
SetAmigaGuideAttrsA (BASE_PAR_DECL APTR cl,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  register struct TagItem *a1 __asm("a1") = attrs;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetAmigaGuideAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetAmigaGuideAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline LONG 
SetAmigaGuideContextA (BASE_PAR_DECL APTR cl,unsigned long id,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = cl;
  register unsigned long d0 __asm("d0") = id;
  register struct TagItem *d1 __asm("d1") = attrs;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetAmigaGuideContext(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetAmigaGuideContextA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
UnlockAmigaGuideBase (BASE_PAR_DECL long key)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = key;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_AMIGAGUIDE_H */
