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


/****** triton.library/class_Scroller ******
*
*   NAME	
*	class_Scroller -- A GadTools scroller gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Scroller
*
*   ATTRIBUTES
*	<Default>        : ULONG flags
*	                   - TROF_HORIZ (default)
*	                   - TROF_VERT
*	                   [create]
*	TRAT_Value       : WORD top
*	                   [create, set, get]
*	TRSC_Total       : WORD total
*	                   [create, set, get]
*	TRSC_Visible     : WORD visible
*	                   [create, set, get]
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
#include "scroller.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define SCROLLER object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Scroller,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_IDCMPFlags|=(SCROLLERIDCMP|ARROWIDCMP);

  DISPLAYOBJECT->MinHeight=max(CHECKBOX_HEIGHT,data->project->trp_TotalPropFontHeight);
  DISPLAYOBJECT->MinWidth=DISPLAYOBJECT->MinHeight;
  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->YResize=TRUE;

  if(SCROLLER->Flags&TROF_VERT)
    {
      DISPLAYOBJECT->MinHeight*=4;
      DISPLAYOBJECT->MinHeight+=8;
      DISPLAYOBJECT->MinWidth+=5;
    }
  else
    {
      DISPLAYOBJECT->MinWidth*=4;
      DISPLAYOBJECT->MinWidth+=8;
    }

  return (ULONG)object;
}


TR_METHOD(Scroller,INSTALL,InstallData)
{
  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  TR_InternalAreaFill(OBJECT->Project,NULL,DISPLAYOBJECT->Left+2,DISPLAYOBJECT->Top+1,
		      DISPLAYOBJECT->Left+DISPLAYOBJECT->Width-3,
		      DISPLAYOBJECT->Top+DISPLAYOBJECT->Height-2,TRBF_NONE);
  if(DISPLAYOBJECT->PrivData=(ULONG)
     TR_CreateGadgetTags(OBJECT->Project, OBJECT, SCROLLER_KIND,
			 DISPLAYOBJECT->Left,
			 DISPLAYOBJECT->Top,
			 DISPLAYOBJECT->Width,
			 DISPLAYOBJECT->Height,
			 GTSC_Top,            SCROLLER->Value,
			 GTSC_Total,          SCROLLER->Total,
			 GTSC_Visible,        SCROLLER->Visible,
			 GTSC_Arrows,         (SCROLLER->Flags&TROF_VERT)?
			                        (DISPLAYOBJECT->MinHeight/4):
			                        (DISPLAYOBJECT->MinWidth/4),
			 PGA_Freedom,         (SCROLLER->Flags&TROF_VERT)?LORIENT_VERT:LORIENT_HORIZ,
			 GA_Disabled,         TR_DO_DISABLED,
			 TAG_END))
    return 1L;
  else
    return NULL;
}


TR_METHOD(Scroller,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      if(SCROLLER->Value!=data->value)
	{
	  SCROLLER->Value=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,
			      NULL,GTSC_Top,SCROLLER->Value,
			      GA_Disabled,TR_DO_DISABLED,GTSC_Total,SCROLLER->Total,
			      GTSC_Visible,SCROLLER->Visible,TAG_END);
	}
      return 1;

    case TRSC_Total:
      if(SCROLLER->Total!=data->value)
	{
	  SCROLLER->Total=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,
			      NULL,GTSC_Top,SCROLLER->Value,
			      GA_Disabled,TR_DO_DISABLED,GTSC_Total,SCROLLER->Total,
			      GTSC_Visible,SCROLLER->Visible,TAG_END);
	}
      return 1L;

    case TRSC_Visible:
      if(SCROLLER->Visible!=data->value)
	{
	  SCROLLER->Visible=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
			      OBJECT->Project->trp_Window,NULL,GTSC_Top,SCROLLER->Value,
			      GA_Disabled,TR_DO_DISABLED,GTSC_Total,SCROLLER->Total,
			      GTSC_Visible,SCROLLER->Visible,TAG_END);
	}
      return 1L;

    case 0:
      SCROLLER->Flags=data->value;
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Scroller,GETATTRIBUTE)
{
  switch((ULONG)data)
    {
    case TRAT_Value:
      return SCROLLER->Value;
    case TRSC_Total:
      return SCROLLER->Total;
    case TRSC_Visible:
      return SCROLLER->Visible;
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Scroller,DISABLED_ENABLED)
{
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
		    GTSC_Top,SCROLLER->Value,GA_Disabled,TR_DO_DISABLED,
		    GTSC_Total,SCROLLER->Total,GTSC_Visible,SCROLLER->Visible,TAG_END);
  return 1L;
}


TR_METHOD(Scroller,KEYDOWN_REPEATEDKEYDOWN,EventData)
{
  BOOL sendmsg=FALSE;
  struct TR_Message *m;

  if(data->imsg->Code)
    {
      if((SCROLLER->Value)>0)
        {
          SCROLLER->Value--;
          sendmsg=TRUE;
        }
    }
  else
    {
      if( (SCROLLER->Value) < (SCROLLER->Total-SCROLLER->Visible) )
	{
	  SCROLLER->Value++;
	  sendmsg=TRUE;
	}
    }

  if(sendmsg)
    {
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,SCROLLER->Value);
      if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=SCROLLER->Value;
	}
    }

  return TR_DIRECTMETHODCALL(Scroller,DISABLED_ENABLED);
}


TR_METHOD(Scroller,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class==IDCMP_MOUSEMOVE)&&(data->imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData)))
    {
      SCROLLER->Value=data->imsg->Code;
      if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=SCROLLER->Value;
	}
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,SCROLLER->Value);
      return 1L;
    }
  else return NULL;
}
