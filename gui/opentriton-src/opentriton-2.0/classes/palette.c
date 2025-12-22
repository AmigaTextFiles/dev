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


/****** triton.library/class_Palette ******
*
*   NAME	
*	class_Palette -- A GadTools palette gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Palette
*
*   ATTRIBUTES
*	<Default>        : <unused>
*	TRAT_Value       : BOOL checked
*	                   [create, set, get]
*
*   APPLICATION MESSAGES
*	TRMS_NEWVALUE is sent when a new color has been selected. trm_Data
*	contains the pen number of the selected color.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "palette.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define PALETTE object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Palette,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_IDCMPFlags|=PALETTEIDCMP;

  DISPLAYOBJECT->MinHeight=max(CHECKBOX_HEIGHT,data->project->trp_TotalPropFontHeight);
  DISPLAYOBJECT->MinWidth=(
			       (max(CHECKBOX_WIDTH,data->project->trp_PropFont->tf_YSize)-3)
			       * (1<<min(3,data->project->trp_Screen->RastPort.BitMap->Depth))
			       ) +4;
  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->YResize=TRUE;

  return (ULONG)object;
}


TR_METHOD(Palette,INSTALL,InstallData)
{
  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  if(DISPLAYOBJECT->PrivData=(ULONG)
     TR_CreateGadgetTags(OBJECT->Project,
			 OBJECT,
			 PALETTE_KIND,
			 DISPLAYOBJECT->Left,
			 DISPLAYOBJECT->Top,
			 DISPLAYOBJECT->Width,
			 DISPLAYOBJECT->Height,
			 GTPA_Color,          PALETTE->Selected,
			 GTPA_IndicatorWidth, DISPLAYOBJECT->MinWidth/2,
			 GTPA_Depth,          OBJECT->Project->trp_Screen->RastPort.BitMap->Depth,
			 GTPA_ColorOffset,    0,
			 GA_Disabled,         TR_DO_DISABLED,
			 TAG_END))
    return 1L;
  else
    return NULL;
}


TR_METHOD(Palette,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      if(PALETTE->Selected!=data->value)
	{
	  PALETTE->Selected=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,
			      NULL,GTPA_Color,PALETTE->Selected,
			      GA_Disabled,TR_DO_DISABLED,TAG_END);
	}
      return 1L;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Palette,GETATTRIBUTE)
{
  if((ULONG)data==TRAT_Value) return PALETTE->Selected;
  return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
}


TR_SIMPLEMETHOD(Palette,DISABLED_ENABLED)
{
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
		    GTPA_Color,PALETTE->Selected,GA_Disabled,TR_DO_DISABLED,TAG_END);
  return 1L;
}


TR_METHOD(Palette,KEYDOWN_REPEATEDKEYDOWN,EventData)
{
  struct TR_Message *m;

  if(data->imsg->Code) PALETTE->Selected--; else PALETTE->Selected++;
  PALETTE->Selected%=(1<<(OBJECT->Project->trp_Screen->RastPort.BitMap->Depth));

  if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
    {
      m->trm_ID=DISPLAYOBJECT->ID;
      m->trm_Class=TRMS_NEWVALUE;
      m->trm_Data=PALETTE->Selected;
    }
  TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,PALETTE->Selected);

  return TR_DIRECTMETHODCALL(Palette,DISABLED_ENABLED);
}


TR_METHOD(Palette,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class==IDCMP_GADGETUP)&&(data->imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData)))
    {
      PALETTE->Selected=data->imsg->Code;
      if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=PALETTE->Selected;
	}
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,PALETTE->Selected);
      return 1L;
    }
  else return NULL;
}
