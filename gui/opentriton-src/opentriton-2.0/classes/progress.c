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


/****** triton.library/class_Progress ******
*
*   NAME	
*	class_Progress -- A progress indicator
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Progress
*
*   ATTRIBUTES
*	<Default>        : ULONG maximum
*	                   [create, set]
*	TRAT_Flags       : ULONG orientation
*	                   - TROF_HORIZ (default)
*	                   - TROF_VERT
*	                   [create, set]
*	TRAT_Value       : ULONG current
*	                   [create, set, get]
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "progress.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define PROGRESS object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Progress,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

  if(!(DISPLAYOBJECT->YResize)) DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->MinHeight=max(CHECKBOX_HEIGHT,data->project->trp_TotalPropFontHeight);
  DISPLAYOBJECT->MinWidth=(DISPLAYOBJECT->MinHeight*data->project->trp_AspectFixing)/16;

  return (ULONG)object;
}


TR_SIMPLEMETHOD(Progress,INSTALL_REFRESH)
{
  ULONG left,top,width,height,sep;
  struct TR_Project *project;
  ULONG borderwidth,borderheight;

  TR_SUPERMETHOD;
  project=OBJECT->Project;
  borderwidth=TR_FrameBorderWidth(project,TRFT_ABSTRACT_PROGRESS);
  borderheight=TR_FrameBorderHeight(project,TRFT_ABSTRACT_PROGRESS);

  left=DISPLAYOBJECT->Left;
  top=DISPLAYOBJECT->Top;
  width=DISPLAYOBJECT->Width;
  height=DISPLAYOBJECT->Height;

  if(PROGRESS->Value<0) PROGRESS->Value=0;
  if(PROGRESS->Value>DISPLAYOBJECT->PrivData) PROGRESS->Value=DISPLAYOBJECT->PrivData;

  TR_DrawFrame(project,NULL,left,top,width,height,TRFT_ABSTRACT_PROGRESS,FALSE);
  SetAfPt(project->trp_Window->RPort, NULL, -1);
  SetDrMd(project->trp_Window->RPort, JAM1);

  if(DISPLAYOBJECT->XResize)
    {
      sep=left+(((width+1-(2*borderwidth))*PROGRESS->Value)/DISPLAYOBJECT->PrivData);
      if(sep>left+1)
        {
          SetAPen(project->trp_Window->RPort, project->trp_DrawInfo->dri_Pens[FILLPEN]);
          RectFill(project->trp_Window->RPort, left+borderwidth, top+borderheight,
		   sep+borderwidth-2, top+height-1-borderheight);
        }
      if(sep<left+width-1-borderwidth)
        {
          SetAPen(project->trp_Window->RPort, project->trp_DrawInfo->dri_Pens[BACKGROUNDPEN]);
          RectFill(project->trp_Window->RPort, max(sep+borderwidth-1,left+borderwidth),
		   top+borderheight, left+width-1-borderwidth, top+height-1-borderheight);
        }
    }
  else
    {
      sep=top-borderheight+(((height-1)*PROGRESS->Value)/DISPLAYOBJECT->PrivData);
      if(sep>top)
        {
          SetAPen(project->trp_Window->RPort, project->trp_DrawInfo->dri_Pens[FILLPEN]);
          RectFill(project->trp_Window->RPort, left+borderwidth, top+borderheight,
		   left+width-1-borderwidth, sep);
        }
      if(sep<top+height-2)
        {
          SetAPen(project->trp_Window->RPort, project->trp_DrawInfo->dri_Pens[BACKGROUNDPEN]);
          RectFill(project->trp_Window->RPort, left+borderwidth, max(sep,top)+1,
		   left+width-1-borderwidth, top+height-borderheight);
        }
    }
  return 1L;
}


TR_METHOD(Progress,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      PROGRESS->Value=data->value;
      break;
    case TRAT_Flags:
      if((data->value)&TROF_VERT) DISPLAYOBJECT->YResize=TRUE;
      break;
    case 0:
      DISPLAYOBJECT->PrivData=data->value;
      break;
    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
  if(DISPLAYOBJECT->Installed) return TR_DIRECTMETHODCALL(Progress,INSTALL_REFRESH);
  else return 1;
}


TR_SIMPLEMETHOD(Progress,GETATTRIBUTE)
{
  switch((ULONG)data)
    {
    case TRAT_Value:
      return PROGRESS->Value;
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}
