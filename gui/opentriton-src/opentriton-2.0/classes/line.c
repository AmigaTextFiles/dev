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


/****** triton.library/class_Line ******
*
*   NAME	
*	class_Line -- A 3D line
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Line
*
*   ATTRIBUTES
*	<Default>        : ULONG flags
*	                   - TROF_HORIZ        : Horizontal line
*	                                         (Overrides group dimension)
*	                   - TROF_VERT         : Vertical line
*	                                         (Overrides group dimension)
*	                   - TROF_RAISED       : Raised line
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
#include "line.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define LINE object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Line,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  DISPLAYOBJECT->MinWidth=TR_ThickBorders(data->project)?4:2;
  DISPLAYOBJECT->MinHeight=2;

  LINE->Flags=data->itemdata;

  if(!(LINE->Flags&(TROF_VERT|TROF_HORIZ)))
    {
      if((data->grouptype)==TRGR_Horiz) LINE->Flags=TROF_VERT;
      if((data->grouptype)==TRGR_Vert) LINE->Flags=TROF_HORIZ;
    }

  if(LINE->Flags&TROF_HORIZ)
    {
      DISPLAYOBJECT->XResize=TRUE;
      DISPLAYOBJECT->MinWidth=data->project->trp_PropFont->tf_YSize;
    }
  else
    {
      DISPLAYOBJECT->YResize=TRUE;
      DISPLAYOBJECT->MinHeight=data->project->trp_PropFont->tf_YSize;
    }

  return (ULONG)object;
}


TR_SIMPLEMETHOD(Line,INSTALL_REFRESH)
{
  struct TR_Project *project;
  ULONG left,top,width,height;
  UWORD firstpen,secondpen;

  TR_SUPERMETHOD;
  project=OBJECT->Project;

  left=DISPLAYOBJECT->Left;
  top=DISPLAYOBJECT->Top;
  width=DISPLAYOBJECT->Width;
  height=DISPLAYOBJECT->Height;

  if(LINE->Flags&TROF_RAISED)
    {
      firstpen=project->trp_DrawInfo->dri_Pens[SHINEPEN];
      secondpen=project->trp_DrawInfo->dri_Pens[SHADOWPEN];
    }
  else
    {
      firstpen=project->trp_DrawInfo->dri_Pens[SHADOWPEN];
      secondpen=project->trp_DrawInfo->dri_Pens[SHINEPEN];
    }

  if(LINE->Flags&TROF_HORIZ)
    {
      SetAPen(project->trp_Window->RPort,firstpen);
      Move(project->trp_Window->RPort,left,top);
      Draw(project->trp_Window->RPort,left+width-1,top);
      SetAPen(project->trp_Window->RPort,secondpen);
      Move(project->trp_Window->RPort,left,top+1);
      Draw(project->trp_Window->RPort,left+width-1,top+1);
      //--if(LINE->Flags&TRLI_3DSIDES)
        //--{
	  Draw(project->trp_Window->RPort,left+width-1,top);
	  SetAPen(project->trp_Window->RPort,firstpen);
          Move(project->trp_Window->RPort,left,top);
          Draw(project->trp_Window->RPort,left,top+1);
	//--}
    }
  else /* Vertical */
    {
      SetAPen(project->trp_Window->RPort,firstpen);
      Move(project->trp_Window->RPort,left,top);
      Draw(project->trp_Window->RPort,left,top+height-1);
      if(TR_ThickBorders(project))
        {
          Move(project->trp_Window->RPort,left+1,top);
          Draw(project->trp_Window->RPort,left+1,top+height-1);
          SetAPen(project->trp_Window->RPort,secondpen);
          Move(project->trp_Window->RPort,left+2,top);
          Draw(project->trp_Window->RPort,left+2,top+height-1);
          Move(project->trp_Window->RPort,left+3,top);
          Draw(project->trp_Window->RPort,left+3,top+height-1);
          //--if(LINE->Flags&TRLI_3DSIDES)
	  //--{
            Draw(project->trp_Window->RPort,left+1,top+height-1);
            SetAPen(project->trp_Window->RPort,firstpen);
            Move(project->trp_Window->RPort,left+1,top);
            Draw(project->trp_Window->RPort,left+2,top);
          //--}
        }
      else
        {
          SetAPen(project->trp_Window->RPort,secondpen);
          Move(project->trp_Window->RPort,left+1,top);
          Draw(project->trp_Window->RPort,left+1,top+height-1);
          //--if(LINE->Flags&TRLI_3DSIDES)
          //--{
            Draw(project->trp_Window->RPort,left,top+height-1);
            SetAPen(project->trp_Window->RPort,firstpen);
            Move(project->trp_Window->RPort,left,top);
            Draw(project->trp_Window->RPort,left+1,top);
          //--}
        }
    }
  return 1L;
}
