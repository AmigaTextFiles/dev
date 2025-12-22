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

ULONG TR_GetAttribute(struct TR_Project *project, ULONG id, ULONG attribute)
{
  register ULONG _res __asm("d0");
  register struct Library *a6 __asm("a6") = TritonBase;
  register struct TR_Project *a0 __asm("a0") = project;
  register ULONG d0 __asm("d0") = id;
  register ULONG d1 __asm("d1") = attribute;
  __asm __volatile ("jsr a6@(-0x42)"
  : "=r" (_res)
  : "r" (a6), "r" (a0), "r" (d0), "r" (d1)
  : "a0","a1","d0","d1", "memory");
  return _res;
}
