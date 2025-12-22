#ifndef _INLINE_IFFPARSE_H
#define _INLINE_IFFPARSE_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct IFFParseBase*  IFFParseBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME IFFParseBase
#endif

static __inline struct IFFHandle *
AllocIFF (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct IFFHandle * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct LocalContextItem *
AllocLocalItem (BASE_PAR_DECL long type,long id,long ident,long dataSize)
{
  BASE_EXT_DECL
  register struct LocalContextItem * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  register long d2 __asm("d2") = ident;
  register long d3 __asm("d3") = dataSize;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
  : "a0","a1","d0","d1","d2","d3");
  return _res;
}
static __inline void 
CloseClipboard (BASE_PAR_DECL struct ClipboardHandle *clipboard)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct ClipboardHandle *a0 __asm("a0") = clipboard;
  __asm __volatile ("jsr a6@(-0xfc)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
CloseIFF (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline LONG 
CollectionChunk (BASE_PAR_DECL struct IFFHandle *iff,long type,long id)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
CollectionChunks (BASE_PAR_DECL struct IFFHandle *iff,LONG *propArray,long nProps)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register LONG *a1 __asm("a1") = propArray;
  register long d0 __asm("d0") = nProps;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct ContextNode *
CurrentChunk (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register struct ContextNode * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
EntryHandler (BASE_PAR_DECL struct IFFHandle *iff,long type,long id,long position,struct Hook *handler,APTR object)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  register long d2 __asm("d2") = position;
  register struct Hook *a1 __asm("a1") = handler;
  register APTR a2 __asm("a2") = object;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1","d2");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline LONG 
ExitHandler (BASE_PAR_DECL struct IFFHandle *iff,long type,long id,long position,struct Hook *handler,APTR object)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  register long d2 __asm("d2") = position;
  register struct Hook *a1 __asm("a1") = handler;
  register APTR a2 __asm("a2") = object;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1","d2");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline struct CollectionItem *
FindCollection (BASE_PAR_DECL struct IFFHandle *iff,long type,long id)
{
  BASE_EXT_DECL
  register struct CollectionItem * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct LocalContextItem *
FindLocalItem (BASE_PAR_DECL struct IFFHandle *iff,long type,long id,long ident)
{
  BASE_EXT_DECL
  register struct LocalContextItem * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  register long d2 __asm("d2") = ident;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct StoredProperty *
FindProp (BASE_PAR_DECL struct IFFHandle *iff,long type,long id)
{
  BASE_EXT_DECL
  register struct StoredProperty * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct ContextNode *
FindPropContext (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register struct ContextNode * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
FreeIFF (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
FreeLocalItem (BASE_PAR_DECL struct LocalContextItem *localItem)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct LocalContextItem *a0 __asm("a0") = localItem;
  __asm __volatile ("jsr a6@(-0xcc)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline LONG 
GoodID (BASE_PAR_DECL long id)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = id;
  __asm __volatile ("jsr a6@(-0x102)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
GoodType (BASE_PAR_DECL long type)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = type;
  __asm __volatile ("jsr a6@(-0x108)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline STRPTR 
IDtoStr (BASE_PAR_DECL long id,STRPTR buf)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = id;
  register STRPTR a0 __asm("a0") = buf;
  __asm __volatile ("jsr a6@(-0x114)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
InitIFF (BASE_PAR_DECL struct IFFHandle *iff,long flags,struct Hook *streamHook)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = flags;
  register struct Hook *a1 __asm("a1") = streamHook;
  __asm __volatile ("jsr a6@(-0xe4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline void 
InitIFFasClip (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0xf0)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
InitIFFasDOS (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0xea)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline APTR 
LocalItemData (BASE_PAR_DECL struct LocalContextItem *localItem)
{
  BASE_EXT_DECL
  register APTR  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct LocalContextItem *a0 __asm("a0") = localItem;
  __asm __volatile ("jsr a6@(-0xc0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct ClipboardHandle *
OpenClipboard (BASE_PAR_DECL long unitNum)
{
  BASE_EXT_DECL
  register struct ClipboardHandle * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = unitNum;
  __asm __volatile ("jsr a6@(-0xf6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
OpenIFF (BASE_PAR_DECL struct IFFHandle *iff,long rwMode)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = rwMode;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct ContextNode *
ParentChunk (BASE_PAR_DECL struct ContextNode *contextNode)
{
  BASE_EXT_DECL
  register struct ContextNode * _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct ContextNode *a0 __asm("a0") = contextNode;
  __asm __volatile ("jsr a6@(-0xb4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
ParseIFF (BASE_PAR_DECL struct IFFHandle *iff,long control)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = control;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
PopChunk (BASE_PAR_DECL struct IFFHandle *iff)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
PropChunk (BASE_PAR_DECL struct IFFHandle *iff,long type,long id)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
PropChunks (BASE_PAR_DECL struct IFFHandle *iff,LONG *propArray,long nProps)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register LONG *a1 __asm("a1") = propArray;
  register long d0 __asm("d0") = nProps;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
PushChunk (BASE_PAR_DECL struct IFFHandle *iff,long type,long id,long size)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  register long d2 __asm("d2") = size;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
ReadChunkBytes (BASE_PAR_DECL struct IFFHandle *iff,APTR buf,long size)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register APTR a1 __asm("a1") = buf;
  register long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x3c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
ReadChunkRecords (BASE_PAR_DECL struct IFFHandle *iff,APTR buf,long bytesPerRecord,long nRecords)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register APTR a1 __asm("a1") = buf;
  register long d0 __asm("d0") = bytesPerRecord;
  register long d1 __asm("d1") = nRecords;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
SetLocalItemPurge (BASE_PAR_DECL struct LocalContextItem *localItem,struct Hook *purgeHook)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct LocalContextItem *a0 __asm("a0") = localItem;
  register struct Hook *a1 __asm("a1") = purgeHook;
  __asm __volatile ("jsr a6@(-0xc6)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline LONG 
StopChunk (BASE_PAR_DECL struct IFFHandle *iff,long type,long id)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
StopChunks (BASE_PAR_DECL struct IFFHandle *iff,LONG *propArray,long nProps)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register LONG *a1 __asm("a1") = propArray;
  register long d0 __asm("d0") = nProps;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
StopOnExit (BASE_PAR_DECL struct IFFHandle *iff,long type,long id)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register long d0 __asm("d0") = type;
  register long d1 __asm("d1") = id;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
StoreItemInContext (BASE_PAR_DECL struct IFFHandle *iff,struct LocalContextItem *localItem,struct ContextNode *contextNode)
{
  BASE_EXT_DECL
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register struct LocalContextItem *a1 __asm("a1") = localItem;
  register struct ContextNode *a2 __asm("a2") = contextNode;
  __asm __volatile ("jsr a6@(-0xde)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
}
static __inline LONG 
StoreLocalItem (BASE_PAR_DECL struct IFFHandle *iff,struct LocalContextItem *localItem,long position)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register struct LocalContextItem *a1 __asm("a1") = localItem;
  register long d0 __asm("d0") = position;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
WriteChunkBytes (BASE_PAR_DECL struct IFFHandle *iff,APTR buf,long size)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register APTR a1 __asm("a1") = buf;
  register long d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
WriteChunkRecords (BASE_PAR_DECL struct IFFHandle *iff,APTR buf,long bytesPerRecord,long nRecords)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct IFFParseBase* a6 __asm("a6") = BASE_NAME;
  register struct IFFHandle *a0 __asm("a0") = iff;
  register APTR a1 __asm("a1") = buf;
  register long d0 __asm("d0") = bytesPerRecord;
  register long d1 __asm("d1") = nRecords;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_IFFPARSE_H */
