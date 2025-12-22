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

ULONG TR_AutoRequest(struct TR_App *app, struct TR_Project *lockproject, struct TagItem *request_trwintags)
{
  register ULONG _res __asm("d0");
  register struct Library *a6 __asm("a6") = TritonBase;
  register struct TR_Project *a0 __asm("a0") = lockproject;
  register struct TR_App *a1 __asm("a1") = app;
  register struct TagItem *a2 __asm("a2") = request_trwintags;
  __asm __volatile ("jsr a6@(-0x54)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (a1), "r" (a2)
  : "a0","a1","a2","d0","d1", "memory");
  return _res;
}
