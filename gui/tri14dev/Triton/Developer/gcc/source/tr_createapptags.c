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
#include <inline/triton.h>

struct TR_App * TR_CreateAppTags(ULONG taglist,...)
  { return TR_CreateApp((struct TagItem *)&taglist); }
