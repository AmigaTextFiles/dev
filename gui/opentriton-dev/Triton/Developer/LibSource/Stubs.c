/*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
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
