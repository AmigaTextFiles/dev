#ifndef _INLINE_OBJC_H
#define _INLINE_OBJC_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct ObjcBase * ObjcBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME ObjcBase
#endif

BASE_EXT_DECL0

extern __inline char * 
NXCopyStringBuffer (BASE_PAR_DECL const char *buffer)
{
  BASE_EXT_DECL
  register char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char *a1 __asm("a1") = buffer;
  __asm __volatile ("jsr a6@(-0x84)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline char * 
NXCopyStringBufferFromZone (BASE_PAR_DECL const char *buffer,NXZone *zone)
{
  BASE_EXT_DECL
  register char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char *a1 __asm("a1") = buffer;
  register NXZone *a0 __asm("a0") = zone;
  __asm __volatile ("jsr a6@(-0x8a)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline NXZone * 
NXCreateChildZone (BASE_PAR_DECL NXZone *parentZone,size_t startSize,size_t granularity,int canFree)
{
  BASE_EXT_DECL
  register NXZone *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = parentZone;
  register size_t d0 __asm("d0") = startSize;
  register size_t d1 __asm("d1") = granularity;
  register int d2 __asm("d2") = canFree;
  __asm __volatile ("jsr a6@(-0x2a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline NXZone * 
NXCreateZone (BASE_PAR_DECL size_t startSize,size_t granularity,int canFree)
{
  BASE_EXT_DECL
  register NXZone *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register size_t d0 __asm("d0") = startSize;
  register size_t d1 __asm("d1") = granularity;
  register int d2 __asm("d2") = canFree;
  __asm __volatile ("jsr a6@(-0x24)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1), "r" (d2)
  : "a0","a1","d0","d1","d2", "memory");
  return _res;
}
extern __inline NXZone * 
NXDefaultMallocZone (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register NXZone *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x66)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
NXDestroyZone (BASE_PAR_DECL NXZone *zone)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  __asm __volatile ("jsr a6@(-0x3c)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline int 
NXMallocCheck (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x6c)"
  : "=r" (_res)
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
NXMergeZone (BASE_PAR_DECL NXZone *zone)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  __asm __volatile ("jsr a6@(-0x30)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
NXNameZone (BASE_PAR_DECL NXZone *zone,const char *name)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  register const char *a1 __asm("a1") = name;
  __asm __volatile ("jsr a6@(-0x5a)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline NXAtom 
NXUniqueString (BASE_PAR_DECL const char *buffer)
{
  BASE_EXT_DECL
  register NXAtom  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char *a1 __asm("a1") = buffer;
  __asm __volatile ("jsr a6@(-0x72)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline NXAtom 
NXUniqueStringNoCopy (BASE_PAR_DECL const char *buffer)
{
  BASE_EXT_DECL
  register NXAtom  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char *a1 __asm("a1") = buffer;
  __asm __volatile ("jsr a6@(-0x7e)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline NXAtom 
NXUniqueStringWithLength (BASE_PAR_DECL const char *buffer,int length)
{
  BASE_EXT_DECL
  register NXAtom  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char *a1 __asm("a1") = buffer;
  register int d0 __asm("d0") = length;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void * 
NXZoneCalloc (BASE_PAR_DECL NXZone *zone,int numElements,int elementSize)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  register int d0 __asm("d0") = numElements;
  register int d1 __asm("d1") = elementSize;
  __asm __volatile ("jsr a6@(-0x48)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
NXZoneFree (BASE_PAR_DECL NXZone *zone,void *block)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  register void *a1 __asm("a1") = block;
  __asm __volatile ("jsr a6@(-0x54)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline NXZone * 
NXZoneFromPtr (BASE_PAR_DECL void *ptr)
{
  BASE_EXT_DECL
  register NXZone *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register void *a1 __asm("a1") = ptr;
  __asm __volatile ("jsr a6@(-0x36)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void * 
NXZoneMalloc (BASE_PAR_DECL NXZone *zone,int size)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  register int d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
NXZonePtrInfo (BASE_PAR_DECL void *ptr)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register void *a1 __asm("a1") = ptr;
  __asm __volatile ("jsr a6@(-0x60)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void * 
NXZoneRealloc (BASE_PAR_DECL NXZone *zone,void *block,int size)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register NXZone *a0 __asm("a0") = zone;
  register void *a1 __asm("a1") = block;
  register int d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x4e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
__objc_archiving_fatal (BASE_PAR_DECL const char* format,int arg1)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = format;
  register int d0 __asm("d0") = arg1;
  __asm __volatile ("jsr a6@(-0xb4)"
  : /* no output */
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
__objc_print_dtable_stats (BASE_PAR_DECL0)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  __asm __volatile ("jsr a6@(-0x150)"
  : /* no output */
  : "r" (a6)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void * 
__objc_xcalloc (BASE_PAR_DECL int nelem,int size)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register int d0 __asm("d0") = nelem;
  register int d1 __asm("d1") = size;
  __asm __volatile ("jsr a6@(-0xa2)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
__objc_xfree (BASE_PAR_DECL void *mem)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register void *a0 __asm("a0") = mem;
  __asm __volatile ("jsr a6@(-0xa8)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void * 
__objc_xmalloc (BASE_PAR_DECL int size)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register int d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x90)"
  : "=r" (_res)
  : "r" (a6), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void * 
__objc_xmalloc_from_zone (BASE_PAR_DECL int size,NXZone* zone)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register int d0 __asm("d0") = size;
  register NXZone* a0 __asm("a0") = zone;
  __asm __volatile ("jsr a6@(-0x96)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void * 
__objc_xrealloc (BASE_PAR_DECL void* mem,int size)
{
  BASE_EXT_DECL
  register void *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register void* a0 __asm("a0") = mem;
  register int d0 __asm("d0") = size;
  __asm __volatile ("jsr a6@(-0x9c)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline BOOL 
__objclib_init (BASE_PAR_DECL struct __objclib_init_data *data)
{
  BASE_EXT_DECL
  register BOOL  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct __objclib_init_data *a0 __asm("a0") = data;
  __asm __volatile ("jsr a6@(-0x1e)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline id 
class_create_instance (BASE_PAR_DECL OCClass* class)
{
  BASE_EXT_DECL
  register id  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register OCClass* a1 __asm("a1") = class;
  __asm __volatile ("jsr a6@(-0xba)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline id 
class_create_instance_from_zone (BASE_PAR_DECL OCClass* class,NXZone* zone)
{
  BASE_EXT_DECL
  register id  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register OCClass* a1 __asm("a1") = class;
  register NXZone* a0 __asm("a0") = zone;
  __asm __volatile ("jsr a6@(-0xc0)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline char * 
method_get_first_argument (BASE_PAR_DECL struct objc_method* m,arglist_t argframe,const char** type)
{
  BASE_EXT_DECL
  register char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct objc_method* a1 __asm("a1") = m;
  register arglist_t a2 __asm("a2") = argframe;
  register const char** a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0x114)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a2), "r" (a0)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline char * 
method_get_next_argument (BASE_PAR_DECL arglist_t argframe,const char **type)
{
  BASE_EXT_DECL
  register char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register arglist_t a2 __asm("a2") = argframe;
  register const char **a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0x11a)"
  : "=r" (_res)
  : "r" (a6), "r" (a2), "r" (a0)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline char * 
method_get_nth_argument (BASE_PAR_DECL struct objc_method* m,arglist_t argframe,int arg,const char **type)
{
  BASE_EXT_DECL
  register char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct objc_method* a1 __asm("a1") = m;
  register arglist_t a2 __asm("a2") = argframe;
  register int d0 __asm("d0") = arg;
  register const char **a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0x120)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a2), "r" (d0), "r" (a0)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
extern __inline int 
method_get_number_of_arguments (BASE_PAR_DECL struct objc_method* m)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct objc_method* a1 __asm("a1") = m;
  __asm __volatile ("jsr a6@(-0x108)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline int 
method_get_sizeof_arguments (BASE_PAR_DECL struct objc_method* m)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct objc_method* a1 __asm("a1") = m;
  __asm __volatile ("jsr a6@(-0x10e)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline int 
objc_aligned_size (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xd8)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline int 
objc_alignof_type (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xe4)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
objc_fatal (BASE_PAR_DECL const char* msg)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = msg;
  __asm __volatile ("jsr a6@(-0xae)"
  : /* no output */
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline unsigned 
objc_get_type_qualifiers (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register unsigned  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0x126)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline int 
objc_promoted_size (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xea)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline int 
objc_sizeof_type (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register int  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xde)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline const char * 
objc_skip_argspec (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register const char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0x102)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline const char * 
objc_skip_offset (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register const char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xfc)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline const char * 
objc_skip_type_qualifiers (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register const char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xf0)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline const char * 
objc_skip_typespec (BASE_PAR_DECL const char* type)
{
  BASE_EXT_DECL
  register const char *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register const char* a0 __asm("a0") = type;
  __asm __volatile ("jsr a6@(-0xf6)"
  : "=r" (_res)
  : "r" (a6), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline id 
object_copy (BASE_PAR_DECL id object)
{
  BASE_EXT_DECL
  register id  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register id a1 __asm("a1") = object;
  __asm __volatile ("jsr a6@(-0xc6)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline id 
object_copy_from_zone (BASE_PAR_DECL id object,NXZone* zone)
{
  BASE_EXT_DECL
  register id  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register id a1 __asm("a1") = object;
  register NXZone* a0 __asm("a0") = zone;
  __asm __volatile ("jsr a6@(-0xcc)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline id 
object_dispose (BASE_PAR_DECL id object)
{
  BASE_EXT_DECL
  register id  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register id a1 __asm("a1") = object;
  __asm __volatile ("jsr a6@(-0xd2)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
sarray_at_put (BASE_PAR_DECL struct sarray *array,sidx index,void* elem)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct sarray *a1 __asm("a1") = array;
  register sidx d0 __asm("d0") = index;
  register void* a0 __asm("a0") = elem;
  __asm __volatile ("jsr a6@(-0x144)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
sarray_at_put_safe (BASE_PAR_DECL struct sarray *array,sidx index,void* elem)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct sarray *a1 __asm("a1") = array;
  register sidx d0 __asm("d0") = index;
  register void* a0 __asm("a0") = elem;
  __asm __volatile ("jsr a6@(-0x14a)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
}
extern __inline void 
sarray_free (BASE_PAR_DECL struct sarray *array)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct sarray *a1 __asm("a1") = array;
  __asm __volatile ("jsr a6@(-0x132)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
}
extern __inline struct sarray * 
sarray_lazy_copy (BASE_PAR_DECL struct sarray *oarr)
{
  BASE_EXT_DECL
  register struct sarray *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct sarray *a1 __asm("a1") = oarr;
  __asm __volatile ("jsr a6@(-0x138)"
  : "=r" (_res)
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline struct sarray * 
sarray_new (BASE_PAR_DECL int size,void *default_element)
{
  BASE_EXT_DECL
  register struct sarray *  _res  __asm("d0");
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register int d0 __asm("d0") = size;
  register void *a0 __asm("a0") = default_element;
  __asm __volatile ("jsr a6@(-0x12c)"
  : "=r" (_res)
  : "r" (a6), "r" (d0), "r" (a0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
extern __inline void 
sarray_realloc (BASE_PAR_DECL struct sarray *array,int new_size)
{
  BASE_EXT_DECL
  register struct ObjcBase *a6 __asm("a6") = BASE_NAME;
  register struct sarray *a1 __asm("a1") = array;
  register int d0 __asm("d0") = new_size;
  __asm __volatile ("jsr a6@(-0x13e)"
  : /* no output */
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
}

#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE_OBJC_H */
