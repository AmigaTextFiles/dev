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


/****** triton.library/class_DropBox ******
*
*   NAME	
*	class_DropBox -- An icon drop box
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_DropBox
*
*   ATTRIBUTES
*	<Default>        : <unused>
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <clib/alib_protos.h>
#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "dropbox.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define DROPBOX object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(DropBox,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_Flags|=TRWF_APPWINDOW;

  DISPLAYOBJECT->MinWidth=84;
  DISPLAYOBJECT->MinHeight=42;
  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->YResize=TRUE;

  return (ULONG)object;
}


TR_SIMPLEMETHOD(DropBox,INSTALL_REFRESH)
{
  ULONG left,top,width,height;
  struct TR_Project *project;

  TR_SUPERMETHOD;
  project=OBJECT->Project;

  left=DISPLAYOBJECT->Left;
  top=DISPLAYOBJECT->Top;
  width=DISPLAYOBJECT->Width;
  height=DISPLAYOBJECT->Height;

  TR_InternalAreaFill(project,NULL,left+1,top+1,left+width-2,top+height-2,TRBF_NONE);

  TR_DrawFrame(project,NULL,left,top,width,height,TRFT_ABSTRACT_ICONDROPBOX,FALSE);
  return 1L;
}
