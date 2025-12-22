#ifndef _INLINE__MUIB_H
#define _INLINE__MUIB_H

#ifndef _SYS_CDEFS_H_
#include <sys/cdefs.h>
#endif
#ifndef _INLINE_STUBS_H_
#include <inline/stubs.h>
#endif

__BEGIN_DECLS

#ifndef BASE_EXT_DECL
#define BASE_EXT_DECL
#define BASE_EXT_DECL0 extern struct Library *MUIBBase;
#endif
#ifndef BASE_PAR_DECL
#define BASE_PAR_DECL
#define BASE_PAR_DECL0 void
#endif
#ifndef BASE_NAME
#define BASE_NAME MUIBBase
#endif

BASE_EXT_DECL0

__inline void
MB_Close (BASE_PAR_DECL0)
{
	BASE_EXT_DECL
	register struct Library *a6 __asm("a6") = BASE_NAME;
	__asm __volatile ("jsr a6@(-0x24)"
	: /* No Output */
	: "r" (a6)
	: "d0", "d1", "a0", "a1");
}
__inline void
MB_GetA (BASE_PAR_DECL struct TagItem * TagList)
{
	BASE_EXT_DECL
	register struct Library *a6 __asm("a6") = BASE_NAME;
	register struct TagItem * a1 __asm("a1") = TagList;
	__asm __volatile ("jsr a6@(-0x2a)"
	: /* No Output */
	: "r" (a6), "r" (a1)
	: "d0", "d1", "a0", "a1");
}
void MB_Get (Tag tag1, ...)
{
 MB_GetA((struct TagItem *) &tag1);
}
__inline void
MB_GetNextCode (BASE_PAR_DECL ULONG* type, char ** code)
{
	BASE_EXT_DECL
	register struct Library *a6 __asm("a6") = BASE_NAME;
	register ULONG* a0 __asm("a0") = type;
	register char ** a1 __asm("a1") = code;
	__asm __volatile ("jsr a6@(-0x36)"
	: /* No Output */
	: "r" (a6), "r" (a0), "r" (a1)
	: "d0", "d1", "a0", "a1");
}
__inline void
MB_GetNextNotify (BASE_PAR_DECL ULONG* type, char ** code)
{
	BASE_EXT_DECL
	register struct Library *a6 __asm("a6") = BASE_NAME;
	register ULONG* a0 __asm("a0") = type;
	register char ** a1 __asm("a1") = code;
	__asm __volatile ("jsr a6@(-0x3c)"
	: /* No Output */
	: "r" (a6), "r" (a0), "r" (a1)
	: "d0", "d1", "a0", "a1");
}
__inline void
MB_GetVarInfoA (BASE_PAR_DECL ULONG varnb, struct TagItem * TagList)
{
	BASE_EXT_DECL
	register struct Library *a6 __asm("a6") = BASE_NAME;
	register ULONG d0 __asm("d0") = varnb;
	register struct TagItem * a1 __asm("a1") = TagList;
	__asm __volatile ("jsr a6@(-0x30)"
	: /* No Output */
	: "r" (a6), "r" (d0), "r" (a1)
	: "d0", "d1", "a0", "a1");
}
void MB_GetVarInfo (ULONG varnb, Tag tag1, ...)
{
 MB_GetVarInfoA(varnb, (struct TagItem *) &tag1);
}
__inline BOOL
MB_Open (BASE_PAR_DECL0)
{
	BASE_EXT_DECL
	register res __asm("d0");
	register struct Library *a6 __asm("a6") = BASE_NAME;
	__asm __volatile ("jsr a6@(-0x1e)"
	: "=r" (res)
	: "r" (a6)
	: "d0", "d1", "a0", "a1");
	return res;
}
#undef BASE_EXT_DECL
#undef BASE_EXT_DECL0
#undef BASE_PAR_DECL
#undef BASE_PAR_DECL0
#undef BASE_NAME

__END_DECLS

#endif /* _INLINE__MUIB_H */
