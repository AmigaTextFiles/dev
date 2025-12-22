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


/****** triton.library/class_Image ******
*
*   NAME	
*	class_Image -- An image (V2)
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Image
*
*   ATTRIBUTES
*	<Default>        : <Image>
*	                   [create]
*	TRAT_Flags       : ULONG flags
*	                   - TRIM_BOOPSI : <Default> is a pointer to a
*	                                   struct IClass BOOPSI image class.
*	                   [create]
*	TRAT_MinWidth    : Minimum image width in pixels. Defaults to
*	                   the image button height.
*	                   [create, set]
*	TRAT_MinHeight   : Minimum image height in pixels. Defaults to
*	                   the image button height.
*	                   [create, set]
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
#include "image.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define IMAGE object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Image,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  if(!(DISPLAYOBJECT->MinHeight)) DISPLAYOBJECT->MinHeight=(data->project->trp_PropFont->tf_YSize)+6;
  if(!(DISPLAYOBJECT->MinWidth)) DISPLAYOBJECT->MinWidth=(data->project->trp_PropFont->tf_YSize)+6;
  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->YResize=TRUE;

  return (ULONG)object;
}


TR_SIMPLEMETHOD(Image,REFRESH)
{
  DrawImageState(OBJECT->Project->trp_Window->RPort,
		 IMAGE->Image,
		 DISPLAYOBJECT->Left,
		 DISPLAYOBJECT->Top,
		 IDS_NORMAL,
		 OBJECT->Project->trp_DrawInfo);
  return 1L;
}


TR_METHOD(Image,INSTALL,InstallData)
{
  struct Image *image;

  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  if(!(image=(struct Image *)NewObject(IMAGE->IClass,NULL,
				       IA_Height,      DISPLAYOBJECT->Height,
				       IA_Width,       DISPLAYOBJECT->Width,
				       SYSIA_DrawInfo, OBJECT->Project->trp_DrawInfo,
				       TAG_END))) return NULL;
  IMAGE->Image=image;

  return TR_DIRECTMETHODCALL(Image,REFRESH);
}


TR_METHOD(Image,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_MinWidth:
      DISPLAYOBJECT->MinWidth=data->value;
      return 1;
    case TRAT_MinHeight:
      DISPLAYOBJECT->MinHeight=data->value;
      return 1;
    case 0:
      IMAGE->IClass=(struct IClass *)(data->value);
      return 1;
    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Image,REMOVE)
{
  if(IMAGE->Image) DisposeObject((Object *)(IMAGE->Image));
  return 1L;
}
