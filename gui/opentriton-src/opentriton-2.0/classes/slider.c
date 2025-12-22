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


/****** triton.library/class_Slider ******
*
*   NAME	
*	class_Slider -- A GadTools slider gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Slider
*
*   ATTRIBUTES
*	<Default>        : ULONG flags
*	                   - TROF_HORIZ (default)
*	                   - TROF_VERT
*	                   [create]
*	TRAT_Value       : WORD level
*	                   [create, set, get]
*	TRSL_Min         : WORD min
*	                   [create]
*	TRSL_Max         : WORD max
*	                   [create]
*
*   APPLICATION MESSAGES
*	TRMS_NEWVALUE is sent when TRAT_Value changes. trm_Data contains
*	the new value.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "slider.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define SLIDER object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Slider,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_IDCMPFlags|=SLIDERIDCMP;

  DISPLAYOBJECT->MinHeight=max(CHECKBOX_HEIGHT,data->project->trp_TotalPropFontHeight);
  DISPLAYOBJECT->MinWidth=((DISPLAYOBJECT->MinHeight*data->project->trp_AspectFixing)/16)+5;
  if(SLIDER->Flags&TROF_VERT) DISPLAYOBJECT->YResize=TRUE;
  else DISPLAYOBJECT->XResize=TRUE;

  return (ULONG)object;
}


TR_METHOD(Slider,INSTALL,InstallData)
{
  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  TR_InternalAreaFill(OBJECT->Project,NULL,DISPLAYOBJECT->Left+2,DISPLAYOBJECT->Top+1,
		      DISPLAYOBJECT->Left+DISPLAYOBJECT->Width-3,
		      DISPLAYOBJECT->Top+DISPLAYOBJECT->Height-2,TRBF_NONE);
  if(DISPLAYOBJECT->PrivData=(ULONG)
     TR_CreateGadgetTags(OBJECT->Project,
			 OBJECT,
			 SLIDER_KIND,
			 DISPLAYOBJECT->Left,
			 DISPLAYOBJECT->Top,
			 DISPLAYOBJECT->Width,
			 DISPLAYOBJECT->Height,
			 GTSL_Level,          SLIDER->Value,
			 GTSL_Min,            SLIDER->Min,
			 GTSL_Max,            SLIDER->Max,
			 PGA_Freedom,         (SLIDER->Flags&TROF_VERT)?LORIENT_VERT:LORIENT_HORIZ,
			 GA_Disabled,         TR_DO_DISABLED,
			 TAG_END)) return 1;
  else return 0;
}


TR_METHOD(Slider,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      if(SLIDER->Value!=data->value)
	{
	  SLIDER->Value=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
			      OBJECT->Project->trp_Window,NULL,GTSL_Level,SLIDER->Value,
			      GA_Disabled,TR_DO_DISABLED,TAG_END);
	}
      return 1;

    case TRSL_Min:
      SLIDER->Min=data->value;
      return 1;

    case TRSL_Max:
      SLIDER->Max=data->value;
      return 1;

    case 0:
      SLIDER->Flags=data->value;
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Slider,GETATTRIBUTE)
{
  switch((ULONG)data)
    {
    case TRAT_Value:
      return SLIDER->Value;
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Slider,DISABLED_ENABLED)
{
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
		    OBJECT->Project->trp_Window,NULL,GTSL_Level,SLIDER->Value,
		    GA_Disabled,TR_DO_DISABLED,TAG_END);
  return 1;
}


TR_METHOD(Slider,KEYDOWN_REPEATEDKEYDOWN,EventData)
{
  BOOL sendmsg=FALSE;
  struct TR_Message *m;

  if(data->imsg->Code)
    {
      if(SLIDER->Value > SLIDER->Min)
        {
          SLIDER->Value--;
          sendmsg=TRUE;
        }
    }
  else
    {
      if(SLIDER->Value < SLIDER->Max)
        {
          SLIDER->Value++;
          sendmsg=TRUE;
        }
    }

  if(sendmsg)
    {
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,SLIDER->Value);
      if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=SLIDER->Value;
	}
    }

  return TR_DIRECTMETHODCALL(Slider,DISABLED_ENABLED);
}


TR_METHOD(Slider,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class==IDCMP_MOUSEMOVE)&&(data->imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData)))
    {
      SLIDER->Value=data->imsg->Code;
      if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=SLIDER->Value;
	}
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,SLIDER->Value);
      return 1L;
    }
  else return 0;
}
