#ifndef _INLINE_UTILITY_H
#define _INLINE_UTILITY_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct UtilityBase * UtilityBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME UtilityBase
#endif

BASE_EXT_DECL0

extern __inline BOOL 
AddNamedObject (BASE_PAR_DECL struct NamedObject *nameSpace,struct NamedObject *object)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = nameSpace;
  register struct NamedObject *a1 __asm("a1") = object;
  __asm __volatile ("jsr a6@(-0xde)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct NamedObject *
AllocNamedObjectA (BASE_PAR_DECL STRPTR name,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct NamedObject * _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = name;
  register struct TagItem *a1 __asm("a1") = tagList;
  __asm __volatile ("jsr a6@(-0xe4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
#ifndef NO_INLINE_STDARG
#define AllocNamedObject(a0, tags...) \
  ({ struct TagItem _tags[] = { tags }; AllocNamedObjectA ((a0), _tags); })
#endif /* not NO_INLINE_STDARG */
extern __inline struct TagItem *
AllocateTagItems (BASE_PAR_DECL unsigned long numTags)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = numTags;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
Amiga2Date (BASE_PAR_DECL unsigned long seconds,struct ClockData *result)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = seconds;
  register struct ClockData *a0 __asm("a0") = result;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ApplyTagChanges (BASE_PAR_DECL struct TagItem *list,struct TagItem *changeList)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = list;
  register struct TagItem *a1 __asm("a1") = changeList;
  __asm __volatile ("jsr a6@(-0xba)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
AttemptRemNamedObject (BASE_PAR_DECL struct NamedObject *object)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0xea)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CallHookPkt (BASE_PAR_DECL struct Hook *hook,APTR object,APTR paramPacket)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct Hook *a0 __asm("a0") = hook;
  register APTR a2 __asm("a2") = object;
  register APTR a1 __asm("a1") = paramPacket;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
CheckDate (BASE_PAR_DECL struct ClockData *date)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct ClockData *a0 __asm("a0") = date;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct TagItem *
CloneTagItems (BASE_PAR_DECL struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
Date2Amiga (BASE_PAR_DECL struct ClockData *date)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct ClockData *a0 __asm("a0") = date;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
FilterTagChanges (BASE_PAR_DECL struct TagItem *changeList,struct TagItem *originalList,unsigned long apply)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = changeList;
  register struct TagItem *a1 __asm("a1") = originalList;
  register unsigned long d0 __asm("d0") = apply;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
FilterTagItems (BASE_PAR_DECL struct TagItem *tagList,Tag *filterArray,unsigned long logic)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  register Tag *a1 __asm("a1") = filterArray;
  register unsigned long d0 __asm("d0") = logic;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct NamedObject *
FindNamedObject (BASE_PAR_DECL struct NamedObject *nameSpace,STRPTR name,struct NamedObject *lastObject)
{
  BASE_EXT_DECL
  register struct NamedObject * _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = nameSpace;
  register STRPTR a1 __asm("a1") = name;
  register struct NamedObject *a2 __asm("a2") = lastObject;
  __asm __volatile ("jsr a6@(-0xf0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline struct TagItem *
FindTagItem (BASE_PAR_DECL Tag tagVal,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tagVal;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
FreeNamedObject (BASE_PAR_DECL struct NamedObject *object)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0xf6)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
FreeTagItems (BASE_PAR_DECL struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline ULONG 
GetTagData (BASE_PAR_DECL Tag tagValue,unsigned long defaultVal,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tagValue;
  register unsigned long d1 __asm("d1") = defaultVal;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
GetUniqueID (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x10e)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
MapTags (BASE_PAR_DECL struct TagItem *tagList,struct TagItem *mapList,unsigned long mapType)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  register struct TagItem *a1 __asm("a1") = mapList;
  register unsigned long d0 __asm("d0") = mapType;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline STRPTR 
NamedObjectName (BASE_PAR_DECL struct NamedObject *object)
{
  BASE_EXT_DECL
  register STRPTR  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0xfc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct TagItem *
NextTagItem (BASE_PAR_DECL struct TagItem **tagListPtr)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem **a0 __asm("a0") = tagListPtr;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
PackBoolTags (BASE_PAR_DECL unsigned long initialFlags,struct TagItem *tagList,struct TagItem *boolMap)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = initialFlags;
  register struct TagItem *a0 __asm("a0") = tagList;
  register struct TagItem *a1 __asm("a1") = boolMap;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
PackStructureTags (BASE_PAR_DECL APTR pack,ULONG *packTable,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = pack;
  register ULONG *a1 __asm("a1") = packTable;
  register struct TagItem *a2 __asm("a2") = tagList;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline void 
RefreshTagItemClones (BASE_PAR_DECL struct TagItem *clone,struct TagItem *original)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = clone;
  register struct TagItem *a1 __asm("a1") = original;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
ReleaseNamedObject (BASE_PAR_DECL struct NamedObject *object)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = object;
  __asm __volatile ("jsr a6@(-0x102)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
RemNamedObject (BASE_PAR_DECL struct NamedObject *object,struct Message *message)
{
  BASE_EXT_DECL
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register struct NamedObject *a0 __asm("a0") = object;
  register struct Message *a1 __asm("a1") = message;
  __asm __volatile ("jsr a6@(-0x108)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline LONG 
SDivMod32 (BASE_PAR_DECL long dividend,long divisor)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = dividend;
  register long d1 __asm("d1") = divisor;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
SMult32 (BASE_PAR_DECL long arg1,long arg2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = arg1;
  register long d1 __asm("d1") = arg2;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
SMult64 (BASE_PAR_DECL long arg1,long arg2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = arg1;
  register long d1 __asm("d1") = arg2;
  __asm __volatile ("jsr a6@(-0xc6)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
Stricmp (BASE_PAR_DECL STRPTR string1,STRPTR string2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = string1;
  register STRPTR a1 __asm("a1") = string2;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline LONG 
Strnicmp (BASE_PAR_DECL STRPTR string1,STRPTR string2,long length)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register STRPTR a0 __asm("a0") = string1;
  register STRPTR a1 __asm("a1") = string2;
  register long d0 __asm("d0") = length;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
TagInArray (BASE_PAR_DECL Tag tagValue,Tag *tagArray)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tagValue;
  register Tag *a0 __asm("a0") = tagArray;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UBYTE 
ToLower (BASE_PAR_DECL unsigned long character)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0xb4)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline UBYTE 
ToUpper (BASE_PAR_DECL unsigned long character)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
UDivMod32 (BASE_PAR_DECL unsigned long dividend,unsigned long divisor)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = dividend;
  register unsigned long d1 __asm("d1") = divisor;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
UMult32 (BASE_PAR_DECL unsigned long arg1,unsigned long arg2)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = arg1;
  register unsigned long d1 __asm("d1") = arg2;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
UMult64 (BASE_PAR_DECL unsigned long arg1,unsigned long arg2)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = arg1;
  register unsigned long d1 __asm("d1") = arg2;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline ULONG 
UnpackStructureTags (BASE_PAR_DECL APTR pack,ULONG *packTable,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase *a6 __asm("a6") = BASE_NAME;
  register APTR a0 __asm("a0") = pack;
  register ULONG *a1 __asm("a1") = packTable;
  register struct TagItem *a2 __asm("a2") = tagList;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_UTILITY_H */
