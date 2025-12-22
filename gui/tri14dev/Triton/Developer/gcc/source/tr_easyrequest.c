/*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1994
 *
 *  (c) 1993-1994 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts of it for
 *  creating programs for AmigaOS which use the Triton GUI creation
 *  system. All other rights reserved.
 *
 *  Triton linkable library code for GCC - (c) 1994 by Gunther Nikl
 */

#include "triton.h"

extern struct Library *TritonBase;

ULONG TR_EasyRequest(struct TR_App *app, STRPTR bodyfmt, STRPTR gadfmt, struct TagItem *taglist)
{
  register ULONG _res __asm("d0");
  register struct Library *a6 __asm("a6") = TritonBase;
  register struct TagItem *a0 __asm("a0") = taglist;
  register struct TR_App *a1 __asm("a1") = app;
  register STRPTR a2 __asm("a2") = bodyfmt;
  register STRPTR a3 __asm("a3") = gadfmt;
  __asm __volatile ("jsr a6@(-0x5a)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (a3)
  : "a0","a1","a2","a3","d0","d1", "memory");
  return _res;
}

