#ifndef _INLINE_DATATYPES_H
#define _INLINE_DATATYPES_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * DataTypesBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME DataTypesBase
#endif

BASE_EXT_DECL0

extern __inline LONG 
AddDTObject (BASE_PAR_DECL struct Window *win,struct Requester *req,Object *o,long pos)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  register struct Requester *a1 __asm("a1") = req;
  register Object *a2 __asm("a2") = o;
  register long d0 __asm("d0") = pos;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline void 
DisposeDTObject (BASE_PAR_DECL Object *o)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
DoAsyncLayout (BASE_PAR_DECL Object *o,struct gpLayout *gpl)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  register struct gpLayout *a1 __asm("a1") = gpl;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
DoDTMethodA (BASE_PAR_DECL Object *o,struct Window *win,struct Requester *req,Msg msg)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  register struct Window *a1 __asm("a1") = win;
  register struct Requester *a2 __asm("a2") = req;
  register Msg a3 __asm("a3") = msg;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define DoDTMethod(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; DoDTMethodA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
GetDTAttrsA (BASE_PAR_DECL Object *o,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  register struct TagItem *a2 __asm("a2") = attrs;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define GetDTAttrs(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; GetDTAttrsA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG *
GetDTMethods (BASE_PAR_DECL Object *object)
{
  BASE_EXT_DECL
  register ULONG * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline STRPTR 
GetDTString (BASE_PAR_DECL unsigned long id)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = id;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct DTMethods *
GetDTTriggerMethods (BASE_PAR_DECL Object *object)
{
  BASE_EXT_DECL
  register struct DTMethods * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline Object *
NewDTObjectA (BASE_PAR_DECL APTR name,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register Object * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register APTR d0 __asm("d0") = name;
  register struct TagItem *a0 __asm("a0") = attrs;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define NewDTObject(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; NewDTObjectA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct DataType *
ObtainDataTypeA (BASE_PAR_DECL unsigned long type,APTR handle,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register struct DataType * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = type;
  register APTR a0 __asm("a0") = handle;
  register struct TagItem *a1 __asm("a1") = attrs;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define ObtainDataType(a0, a1, tags...) \
  ({ struct TagItem _tags[] = { tags }; ObtainDataTypeA ((a0), (a1), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline ULONG 
PrintDTObjectA (BASE_PAR_DECL Object *o,struct Window *w,struct Requester *r,struct dtPrint *msg)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  register struct Window *a1 __asm("a1") = w;
  register struct Requester *a2 __asm("a2") = r;
  register struct dtPrint *a3 __asm("a3") = msg;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define PrintDTObject(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; PrintDTObjectA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
RefreshDTObjectA (BASE_PAR_DECL Object *o,struct Window *win,struct Requester *req,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  register struct Window *a1 __asm("a1") = win;
  register struct Requester *a2 __asm("a2") = req;
  register struct TagItem *a3 __asm("a3") = attrs;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
}
#ifndef NO_INLINE_STDARG
#define RefreshDTObjects(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; RefreshDTObjectA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline void 
ReleaseDataType (BASE_PAR_DECL struct DataType *dt)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct DataType *a0 __asm("a0") = dt;
  __asm __volatile ("jsr a6@(-0x2a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
RemoveDTObject (BASE_PAR_DECL struct Window *win,Object *o)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct Window *a0 __asm("a0") = win;
  register Object *a1 __asm("a1") = o;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
SetDTAttrsA (BASE_PAR_DECL Object *o,struct Window *win,struct Requester *req,struct TagItem *attrs)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register Object *a0 __asm("a0") = o;
  register struct Window *a1 __asm("a1") = win;
  register struct Requester *a2 __asm("a2") = req;
  register struct TagItem *a3 __asm("a3") = attrs;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define SetDTAttrs(a0, a1, a2, tags...) \
  ({ struct TagItem _tags[] = { tags }; SetDTAttrsA ((a0), (a1), (a2), _tags); })
#endif /* not NO_INLINE_STDARG */

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_DATATYPES_H */
