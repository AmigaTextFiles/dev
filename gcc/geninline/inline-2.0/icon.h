#ifndef _INLINE_ICON_H
#define _INLINE_ICON_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL extern struct Library * IconBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME IconBase
#endif

static __inline BOOL 
AddFreeList (BASE_PAR_DECL struct FreeList *freelist,APTR mem,unsigned long size)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct FreeList *a0 __asm("a0") = freelist;
  register APTR a1 __asm("a1") = mem;
  register unsigned long a2 __asm("a2") = size;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline UBYTE *
BumpRevision (BASE_PAR_DECL UBYTE *newname,UBYTE *oldname)
{
  BASE_EXT_DECL
  register UBYTE * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = newname;
  register UBYTE *a1 __asm("a1") = oldname;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline BOOL 
DeleteDiskObject (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline UBYTE *
FindToolType (BASE_PAR_DECL UBYTE **toolTypeArray,UBYTE *typeName)
{
  BASE_EXT_DECL
  register UBYTE * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE **a0 __asm("a0") = toolTypeArray;
  register UBYTE *a1 __asm("a1") = typeName;
  __asm __volatile ("jsr a6@(-0x60)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline void 
FreeDiskObject (BASE_PAR_DECL struct DiskObject *diskobj)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct DiskObject *a0 __asm("a0") = diskobj;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline void 
FreeFreeList (BASE_PAR_DECL struct FreeList *freelist)
{
  BASE_EXT_DECL
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct FreeList *a0 __asm("a0") = freelist;
  __asm __volatile ("jsr a6@(-0x36)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
}
static __inline struct DiskObject *
GetDefDiskObject (BASE_PAR_DECL long type)
{
  BASE_EXT_DECL
  register struct DiskObject * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register long d0 __asm("d0") = type;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1");
  return _res;
}
static __inline struct DiskObject *
GetDiskObject (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct DiskObject * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline struct DiskObject *
GetDiskObjectNew (BASE_PAR_DECL UBYTE *name)
{
  BASE_EXT_DECL
  register struct DiskObject * _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline LONG 
GetIcon (BASE_PAR_DECL UBYTE *name,struct DiskObject *icon,struct FreeList *freelist)
{
  BASE_EXT_DECL
  register LONG  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  register struct DiskObject *a1 __asm("a1") = icon;
  register struct FreeList *a2 __asm("a2") = freelist;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;  *(char *)a2 = *(char *)a2;
  return _res;
}
static __inline BOOL 
MatchToolValue (BASE_PAR_DECL UBYTE *typeString,UBYTE *value)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = typeString;
  register UBYTE *a1 __asm("a1") = value;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline BOOL 
PutDefDiskObject (BASE_PAR_DECL struct DiskObject *diskObject)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register struct DiskObject *a0 __asm("a0") = diskObject;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;
  return _res;
}
static __inline BOOL 
PutDiskObject (BASE_PAR_DECL UBYTE *name,struct DiskObject *diskobj)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  register struct DiskObject *a1 __asm("a1") = diskobj;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
static __inline BOOL 
PutIcon (BASE_PAR_DECL UBYTE *name,struct DiskObject *icon)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct Library *a6 __asm("a6") = BASE_NAME;
  register UBYTE *a0 __asm("a0") = name;
  register struct DiskObject *a1 __asm("a1") = icon;
  __asm __volatile ("jsr a6@(-0x30)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1");
  *(char *)a0 = *(char *)a0;  *(char *)a1 = *(char *)a1;
  return _res;
}
#undef BASE_EXT_DECL
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_ICON_H */
