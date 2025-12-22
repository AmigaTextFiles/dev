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


/****** triton.library/class_DragItem ******
*
*   NAME	
*	class_DragItem -- A draggable item (V6)
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_DragItem
*
*   ATTRIBUTES
*	none
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <ctype.h>
#include <dos.h>
#include <utility/hooks.h>
#include <clib/alib_protos.h>
#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "dragitem.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define DRAGITEM object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// The dispatcher //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_DEFAULTMETHOD(DragItem)
{
  struct TR_Project *project;
  ULONG left, top, width, height;

  switch(messageid)
  {
    case TROM_NEW:
      if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

      DISPLAYOBJECT->MinHeight=20;
      DISPLAYOBJECT->MinWidth=20;

      DISPLAYOBJECT->XResize=TRUE;
      DISPLAYOBJECT->YResize=TRUE;

      return (ULONG)object;

    case TROM_INSTALL:
      TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);

    case TROM_REFRESH:
      project = OBJECT->Project;
      left    = DISPLAYOBJECT->Left;
      top     = DISPLAYOBJECT->Top;
      width   = DISPLAYOBJECT->Width;
      height  = DISPLAYOBJECT->Height;

      TR_DrawBevelBox(project,left,top,width,height,TRBB_BUTTON,FALSE);
      return 1L;

    default:
      return TR_SUPERMETHOD;
  }
}
