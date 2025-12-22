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
 *  color_prim.c - Color Primitives
 *
 */


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define INTUI_V36_NAMES_ONLY
#define TR_NOSUPPORT
#define TR_THIS_IS_TRITON
#define TR_EXTERNAL_ONLY

#include "include/libraries/triton.h"
#include "include/clib/triton_protos.h"
#include "prefs/Triton.h"
#include "/internal.h"

#include "parts/define_classes.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Color Primitives //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/****** triton.library/TR_GetPen ******
*
*   NAME	
*	TR_GetPen -- Returns a pen number. (V6)
*
*   SYNOPSIS
*	Pen = TR_GetPen(Project, PenType, PenData)
*	                A0       D0       D1
*
*	ULONG TR_GetPen(struct TR_Project *, ULONG, ULONG);
*
*   FUNCTION
*	Returns the pen specified by PenType and PenData.
*
*   RESULT
*	Pen - The number of the requested pen
*
******/

ULONG __saveds __asm TR_GetPen(register __a0 struct TR_Project *project,
			       register __d0 ULONG pentype, register __d1 ULONG pendata)
{
  switch(pentype)
  {
    case TRPT_TRITONPEN:
      return TR_GetPen(
        project,
        ((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->pentype[pendata],
        ((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->pendata[pendata]
      );

    case TRPT_SYSTEMPEN:
      return project->trp_DrawInfo->dri_Pens[pendata];

    default: /* TRPT_GRAPHICSPEN */
      return pendata;
  }
}
