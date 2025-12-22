#ifndef _INLINE_REXXSYSLIB_H
#define _INLINE_REXXSYSLIB_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct RexxSysBase*  RexxSysBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME RexxSysBase
#endif

static __inline void 
ClearRexxMsg (BASE_PAR_DECL struct RexxMsg *msgptr,unsigned long count)
{
  BASE_EXT_DECL
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register struct RexxMsg *a0 __asm("a0") = msgptr;
  register unsigned long d0 __asm("d0") = count;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline UBYTE *
CreateArgstring (BASE_PAR_DECL UBYTE *string,unsigned long length)
{
  BASE_EXT_DECL
  register UBYTE * _res  __asm("d0");
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = string;
  register unsigned long d0 __asm("d0") = length;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct RexxMsg *
CreateRexxMsg (BASE_PAR_DECL struct MsgPort *port,UBYTE *extension,UBYTE *host)
{
  BASE_EXT_DECL
  register struct RexxMsg * _res  __asm("d0");
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register struct MsgPort *a0 __asm("a0") = port;
  register UBYTE *a1 __asm("a1") = extension;
  register UBYTE *d0 __asm("d0") = host;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
DeleteArgstring (BASE_PAR_DECL UBYTE *argstring)
{
  BASE_EXT_DECL
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = argstring;
  __asm __volatile ("jsr a6@(-0x84)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
DeleteRexxMsg (BASE_PAR_DECL struct RexxMsg *packet)
{
  BASE_EXT_DECL
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register struct RexxMsg *a0 __asm("a0") = packet;
  __asm __volatile ("jsr a6@(-0x96)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline BOOL 
FillRexxMsg (BASE_PAR_DECL struct RexxMsg *msgptr,unsigned long count,unsigned long mask)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register struct RexxMsg *a0 __asm("a0") = msgptr;
  register unsigned long d0 __asm("d0") = count;
  register unsigned long d1 __asm("d1") = mask;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline BOOL 
IsRexxMsg (BASE_PAR_DECL struct RexxMsg *msgptr)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register struct RexxMsg *a0 __asm("a0") = msgptr;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline ULONG 
LengthArgstring (BASE_PAR_DECL UBYTE *argstring)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = argstring;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
LockRexxBase (BASE_PAR_DECL unsigned long resource)
{
  BASE_EXT_DECL
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = resource;
  __asm __volatile ("jsr a6@(-0x1c2)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
}
static __inline void 
UnlockRexxBase (BASE_PAR_DECL unsigned long resource)
{
  BASE_EXT_DECL
  register struct RexxSysBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = resource;
  __asm __volatile ("jsr a6@(-0x1ce)"
  : /* no output */
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_REXXSYSLIB_H */
