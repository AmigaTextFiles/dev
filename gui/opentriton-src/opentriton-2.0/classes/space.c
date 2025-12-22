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


/****** triton.library/class_Space ******
*
*   NAME	
*	class_Space -- A class of spaces with various sizes
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Space
*
*   ATTRIBUTES
*	<Default>        : ULONG spacetype
*	                   - TRST_NONE         : No space
*	                   - TRST_SMALL        : Small space
*	                   - TRST_NORMAL       : Normal space (default)
*	                   - TRST_BIG          : Big space
*	                   [create]
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "space.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define SPACE object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Space,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->YResize=TRUE;
  DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_SPACE;

  switch(data->itemdata)
    {
    case TRST_SMALL:
      DISPLAYOBJECT->MinHeight=(data->project->trp_PropFont->tf_YSize)/4;
      break;
    case TRST_BIG:
      DISPLAYOBJECT->MinHeight=data->project->trp_PropFont->tf_YSize;
      break;
    case TRST_NONE:
      DISPLAYOBJECT->MinHeight=0;
      break;
    default: /* TRST_NORMAL */
      DISPLAYOBJECT->MinHeight=(data->project->trp_PropFont->tf_YSize)/2;
    }

  DISPLAYOBJECT->MinWidth=(DISPLAYOBJECT->MinHeight*data->project->trp_AspectFixing)/16;

  if((data->grouptype)==TRGR_Horiz)
    {
      DISPLAYOBJECT->XResize=FALSE;
      DISPLAYOBJECT->MinHeight=0L;
    }

  if((data->grouptype)==TRGR_Vert)
    {
      DISPLAYOBJECT->YResize=FALSE;
      DISPLAYOBJECT->MinWidth=0L;
    }

  return (ULONG)object;
}
