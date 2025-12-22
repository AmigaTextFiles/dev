#ifndef _INLINE_ALIB_H
#define _INLINE_ALIB_H

#include <sys/cdefs.h>
#include <inline/stubs.h>

#include <exec/io.h>

__BEGIN_DECLS

extern __inline void
BeginIO (struct IORequest *iorequest)
{
  register struct IORequest *a1 __asm("a1")=iorequest;
  register struct Device    *a6 __asm("a6")=iorequest->io_Device;
  __asm __volatile ("jsr a6@(-0x1e)"
  : /* no output */
  : "r" (a6), "r" (a1)
  : "a0","a1","d0","d1","memory");
}

extern __inline void
NewList(struct List *list)
{
   LONG *p;

   list->lh_TailPred=(struct Node*)list;
   ((LONG *)list)++;
   *(LONG *)list=0;
   p=(LONG *)list; *--p=(LONG)list;
}

__END_DECLS

#endif /* _INLINE_ALIB_H */
