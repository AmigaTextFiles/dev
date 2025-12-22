/*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1996
 *
 *  (c) 1993-1996 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 */


#include "triton_lib.h"


struct TR_App * __stdargs TR_CreateAppTags(ULONG taglist,...)
  { return TR_CreateApp((struct TagItem *)&taglist); }

struct TR_Project * __stdargs TR_OpenProjectTags(struct TR_App *app, ULONG taglist,...)
  { return TR_OpenProject(app, (struct TagItem *)&taglist); }

ULONG TR_EasyRequestTags(struct TR_App *app, STRPTR bodyfmt, STRPTR gadfmt, ULONG taglist,...)
  { return TR_EasyRequest(app, bodyfmt, gadfmt, (struct TagItem *)&taglist); }

ULONG TR_AutoRequestTags(struct TR_App *app, struct TR_Project *lockproject, ULONG taglist,...)
  { return TR_AutoRequest(app, lockproject, (struct TagItem *)&taglist); }

BOOL TR_AddClassTags(struct TR_App *app, ULONG tag, ULONG superTag, TR_Method defaultMethod, ULONG datasize,
		     ULONG taglist,...)
  { return TR_AddClass(app, tag, superTag, defaultMethod, datasize, (struct TagItem *)&taglist); }
