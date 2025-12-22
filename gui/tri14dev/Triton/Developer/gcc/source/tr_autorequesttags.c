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

ULONG TR_AutoRequestTags(struct TR_App *app, struct TR_Project *lockproject, ULONG taglist,...)
  { return TR_AutoRequest(app, lockproject, (struct TagItem *)&taglist); }
