#ifndef _INLINE_UTILITY_H
#define _INLINE_UTILITY_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct UtilityBase*  UtilityBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME UtilityBase
#endif

static __inline struct TagItem *
AllocateTagItems (BASE_PAR_DECL unsigned long numItems)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = numItems;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline void 
Amiga2Date (BASE_PAR_DECL unsigned long amigaTime,struct ClockData *date)
{
  BASE_EXT_DECL
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = amigaTime;
  register struct ClockData *a0 __asm("a0") = date;
  __asm __volatile ("jsr a6@(-0x78)"
  : /* no output */
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline ULONG 
CallHookPkt (BASE_PAR_DECL struct Hook *hook,APTR object,APTR paramPacket)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct Hook *a0 __asm("a0") = hook;
  register APTR a2 __asm("a2") = object;
  register APTR a1 __asm("a1") = paramPacket;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a2), "r" (a1)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a2 = *(char *)a2;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline ULONG 
CheckDate (BASE_PAR_DECL struct ClockData *date)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct ClockData *a0 __asm("a0") = date;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct TagItem *
CloneTagItems (BASE_PAR_DECL struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline ULONG 
Date2Amiga (BASE_PAR_DECL struct ClockData *date)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct ClockData *a0 __asm("a0") = date;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
FilterTagChanges (BASE_PAR_DECL struct TagItem *newTagList,struct TagItem *oldTagList,long apply)
{
  BASE_EXT_DECL
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = newTagList;
  register struct TagItem *a1 __asm("a1") = oldTagList;
  register long d0 __asm("d0") = apply;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline LONG 
FilterTagItems (BASE_PAR_DECL struct TagItem *tagList,Tag *filterArray,long logic)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  register Tag *a1 __asm("a1") = filterArray;
  register long d0 __asm("d0") = logic;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline struct TagItem *
FindTagItem (BASE_PAR_DECL Tag tagVal,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tagVal;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
FreeTagItems (BASE_PAR_DECL struct TagItem *tagList)
{
  BASE_EXT_DECL
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x4e)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline ULONG 
GetTagData (BASE_PAR_DECL Tag tagVal,unsigned long defaultVal,struct TagItem *tagList)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tagVal;
  register unsigned long d1 __asm("d1") = defaultVal;
  register struct TagItem *a0 __asm("a0") = tagList;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline void 
MapTags (BASE_PAR_DECL struct TagItem *tagList,struct TagItem *mapList,long includeMiss)
{
  BASE_EXT_DECL
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = tagList;
  register struct TagItem *a1 __asm("a1") = mapList;
  register long d0 __asm("d0") = includeMiss;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline struct TagItem *
NextTagItem (BASE_PAR_DECL struct TagItem **tagListPtr)
{
  BASE_EXT_DECL
  register struct TagItem * _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem **a0 __asm("a0") = tagListPtr;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline ULONG 
PackBoolTags (BASE_PAR_DECL unsigned long initialFlags,struct TagItem *tagList,struct TagItem *boolMap)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = initialFlags;
  register struct TagItem *a0 __asm("a0") = tagList;
  register struct TagItem *a1 __asm("a1") = boolMap;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
RefreshTagItemClones (BASE_PAR_DECL struct TagItem *cloneList,struct TagItem *origList)
{
  BASE_EXT_DECL
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register struct TagItem *a0 __asm("a0") = cloneList;
  register struct TagItem *a1 __asm("a1") = origList;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
}
static __inline LONG 
SDivMod32 (BASE_PAR_DECL long dividend,long divisor)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = dividend;
  register long d1 __asm("d1") = divisor;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
SMult32 (BASE_PAR_DECL long factor1,long factor2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = factor1;
  register long d1 __asm("d1") = factor2;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline LONG 
Stricmp (BASE_PAR_DECL UBYTE *string1,UBYTE *string2)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = string1;
  register UBYTE *a1 __asm("a1") = string2;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline LONG 
Strnicmp (BASE_PAR_DECL UBYTE *string1,UBYTE *string2,long length)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = string1;
  register UBYTE *a1 __asm("a1") = string2;
  register long d0 __asm("d0") = length;
  __asm __volatile ("jsr a6@(-0xa8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline BOOL 
TagInArray (BASE_PAR_DECL Tag tagVal,Tag *tagArray)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register Tag d0 __asm("d0") = tagVal;
  register Tag *a0 __asm("a0") = tagArray;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline UBYTE 
ToLower (BASE_PAR_DECL unsigned long character)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline UBYTE 
ToUpper (BASE_PAR_DECL unsigned long character)
{
  BASE_EXT_DECL
  register UBYTE  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = character;
  __asm __volatile ("jsr a6@(-0xae)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline ULONG 
UDivMod32 (BASE_PAR_DECL unsigned long dividend,unsigned long divisor)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = dividend;
  register unsigned long d1 __asm("d1") = divisor;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline ULONG 
UMult32 (BASE_PAR_DECL unsigned long factor1,unsigned long factor2)
{
  BASE_EXT_DECL
  register ULONG  _res  __asm("d0");
  register struct UtilityBase* a6 __asm("a6") = BASE_NAME;
  register unsigned long d0 __asm("d0") = factor1;
  register unsigned long d1 __asm("d1") = factor2;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1");
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_UTILITY_H */
