#ifndef _INLINE_COMMODITIES_H
#define _INLINE_COMMODITIES_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library * CxBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME CxBase
#endif

BASE_EXT_DECL0

extern __inline LONG 
ActivateCxObj (BASE_PAR_DECL CxObj *co,long istrue)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  register long d0 __asm("d0") = istrue;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
AddIEvents (BASE_PAR_DECL struct InputEvent *events)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct InputEvent *a0 __asm("a0") = events;
  __asm __volatile ("jsr a6@(-0xb4)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
AttachCxObj (BASE_PAR_DECL CxObj *headObj,CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = headObj;
  register CxObj *a1 __asm("a1") = co;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ClearCxObjError (BASE_PAR_DECL CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  __asm __volatile ("jsr a6@(-0x48)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline CxObj *
CreateCxObj (BASE_PAR_DECL unsigned long type,long arg1,long arg2)
{
  BASE_EXT_DECL
  register CxObj * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = type;
  register long a0 __asm("a0") = arg1;
  register long a1 __asm("a1") = arg2;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline CxObj *
CxBroker (BASE_PAR_DECL struct NewBroker *nb,LONG *error)
{
  BASE_EXT_DECL
  register CxObj * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct NewBroker *a0 __asm("a0") = nb;
  register LONG *d0 __asm("d0") = error;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline APTR 
CxMsgData (BASE_PAR_DECL CxMsg *cxm)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxMsg *a0 __asm("a0") = cxm;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
CxMsgID (BASE_PAR_DECL CxMsg *cxm)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxMsg *a0 __asm("a0") = cxm;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CxMsgType (BASE_PAR_DECL CxMsg *cxm)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxMsg *a0 __asm("a0") = cxm;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
CxObjError (BASE_PAR_DECL CxObj *co)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CxObjType (BASE_PAR_DECL CxObj *co)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
DeleteCxObj (BASE_PAR_DECL CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DeleteCxObjAll (BASE_PAR_DECL CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DisposeCxMsg (BASE_PAR_DECL CxMsg *cxm)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxMsg *a0 __asm("a0") = cxm;
  __asm __volatile ("jsr a6@(-0xa8)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
DivertCxMsg (BASE_PAR_DECL CxMsg *cxm,CxObj *headObj,CxObj *returnObj)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxMsg *a0 __asm("a0") = cxm;
  register CxObj *a1 __asm("a1") = headObj;
  register CxObj *a2 __asm("a2") = returnObj;
  __asm __volatile ("jsr a6@(-0x9c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline void 
EnqueueCxObj (BASE_PAR_DECL CxObj *headObj,CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = headObj;
  register CxObj *a1 __asm("a1") = co;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
InsertCxObj (BASE_PAR_DECL CxObj *headObj,CxObj *co,CxObj *pred)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = headObj;
  register CxObj *a1 __asm("a1") = co;
  register CxObj *a2 __asm("a2") = pred;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
}
extern __inline BOOL 
InvertKeyMap (BASE_PAR_DECL unsigned long ansiCode,struct InputEvent *event,struct KeyMap *km)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = ansiCode;
  register struct InputEvent *a0 __asm("a0") = event;
  register struct KeyMap *a1 __asm("a1") = km;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
MatchIX (BASE_PAR_DECL struct InputEvent *event,IX *ix)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct InputEvent *a0 __asm("a0") = event;
  register IX *a1 __asm("a1") = ix;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
ParseIX (BASE_PAR_DECL STRPTR description,IX *ix)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = description;
  register IX *a1 __asm("a1") = ix;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
RemoveCxObj (BASE_PAR_DECL CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  __asm __volatile ("jsr a6@(-0x66)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RouteCxMsg (BASE_PAR_DECL CxMsg *cxm,CxObj *co)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxMsg *a0 __asm("a0") = cxm;
  register CxObj *a1 __asm("a1") = co;
  __asm __volatile ("jsr a6@(-0xa2)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
SetCxObjPri (BASE_PAR_DECL CxObj *co,long pri)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = co;
  register long d0 __asm("d0") = pri;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
SetFilter (BASE_PAR_DECL CxObj *filter,STRPTR text)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = filter;
  register STRPTR a1 __asm("a1") = text;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SetFilterIX (BASE_PAR_DECL CxObj *filter,IX *ix)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = filter;
  register IX *a1 __asm("a1") = ix;
  __asm __volatile ("jsr a6@(-0x7e)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
SetTranslate (BASE_PAR_DECL CxObj *translator,struct InputEvent *events)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register CxObj *a0 __asm("a0") = translator;
  register struct InputEvent *a1 __asm("a1") = events;
  __asm __volatile ("jsr a6@(-0x72)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_COMMODITIES_H */
