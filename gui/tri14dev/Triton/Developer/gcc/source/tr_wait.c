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

ULONG TR_Wait(struct TR_App *app, ULONG otherbits)
{
  register ULONG _res __asm("d0");
  register struct Library *a6 __asm("a6") = TritonBase;
  register struct TR_App *a1 __asm("a1") = app;
  register ULONG d0 __asm("d0") = otherbits;
  __asm __volatile ("jsr a6@(-0x78)"
  : "=r" (_res)
  : "r" (a6), "r" (a1), "r" (d0)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
