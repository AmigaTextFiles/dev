#ifndef _INLINE_ASL_H
#define _INLINE_ASL_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct AslBase*  AslBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME AslBase
#endif

static __inline APTR 
AllocAslRequest (BASE_PAR_DECL unsigned long reqType,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct AslBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = reqType;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct FileRequester *
AllocFileRequest (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct FileRequester * _res  __asm("d0");
  register struct AslBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline BOOL 
AslRequest (BASE_PAR_DECL APTR requester,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct AslBase* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = requester;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
FreeAslRequest (BASE_PAR_DECL APTR requester)
{
  BASE_EXT_DECL
  register struct AslBase* a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = requester;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
FreeFileRequest (BASE_PAR_DECL struct FileRequester *fileReq)
{
  BASE_EXT_DECL
  register struct AslBase* a6 __asm("a6") = BASE_NAME;
  register struct FileRequester *a0 __asm("a0") = fileReq;
  __asm __volatile ("jsr a6@(-0x24)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline BOOL 
RequestFile (BASE_PAR_DECL struct FileRequester *fileReq)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct AslBase* a6 __asm("a6") = BASE_NAME;
  register struct FileRequester *a0 __asm("a0") = fileReq;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_ASL_H */
