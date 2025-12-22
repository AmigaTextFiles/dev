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


/****** triton.library/class_CheckBox ******
*
*   NAME	
*	class_CheckBox -- A GadTools checkbox gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_CheckBox
*
*   ATTRIBUTES
*	<Default>        : <unused>
*	TRAT_Value       : BOOL checked
*	                   [create, set, get]
*
*   APPLICATION MESSAGES
*	TRMS_NEWVALUE is sent when the checkbox has been toggled. trm_Data
*	contains 0 for an unselected checkbox and any other value for a
*	selected checkbox.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "checkbox.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define CHECKBOX object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(CheckBox,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

#ifndef TR_OS39
  if(TR_Global.trg_OSVersion>=39)
  {
#endif
    DISPLAYOBJECT->MinHeight=max(CHECKBOX_HEIGHT,data->project->trp_TotalPropFontHeight);
    DISPLAYOBJECT->MinWidth=max(CHECKBOX_WIDTH,data->project->trp_PropFont->tf_YSize);
#ifndef TR_OS39
  }
  else
  {
    DISPLAYOBJECT->MinHeight=CHECKBOX_HEIGHT;
    DISPLAYOBJECT->MinWidth=CHECKBOX_WIDTH;
  }
#endif

  data->project->trp_IDCMPFlags|=CHECKBOXIDCMP;
  return (ULONG)object;
}


TR_SIMPLEMETHOD(CheckBox,INSTALL)
{
  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  if(DISPLAYOBJECT->PrivData=(ULONG)TR_CreateGadgetTags
     (OBJECT->Project,
      OBJECT,
      CHECKBOX_KIND,
      DISPLAYOBJECT->Left,
      DISPLAYOBJECT->Top,
      DISPLAYOBJECT->Width,
      DISPLAYOBJECT->Height,
      GTCB_Scaled,    TRUE,
      GTCB_Checked,   CHECKBOX->Checked,
      GA_Disabled,    TR_DO_DISABLED,
      TAG_END)) return 1L;
  else return NULL;
}


TR_METHOD(CheckBox,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      if(CHECKBOX->Checked!=data->value)
	{
	  CHECKBOX->Checked=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,
			      NULL,GTCB_Checked,CHECKBOX->Checked,
			      GA_Disabled,TR_DO_DISABLED,TAG_END);
	}
      return 1L;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(CheckBox,GETATTRIBUTE)
{
  switch((ULONG)data)
  {
    case TRAT_Value:
      return CHECKBOX->Checked;
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
  }
}


TR_METHOD(CheckBox,KEYDOWN_DISABLED_ENABLED,EventData)
{
  struct TR_Message *m;

  if((messageid==TROM_KEYDOWN) && (m=TR_CreateMsg(Self.DO.O.Project->trp_App)))
  {
    CHECKBOX->Checked=!(CHECKBOX->Checked);
    m->trm_ID=DISPLAYOBJECT->ID;
    m->trm_Class=TRMS_NEWVALUE;
    m->trm_Data=CHECKBOX->Checked;
  }
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
		    GTCB_Checked,CHECKBOX->Checked,GA_Disabled,TR_DO_DISABLED,
		    TAG_END);
  return 1;
}


TR_METHOD(CheckBox,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class==IDCMP_GADGETUP)&&(data->imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData)))
  {
    CHECKBOX->Checked=
      ((((struct Gadget *)(data->imsg->IAddress))->Flags)&GFLG_SELECTED)?TRUE:FALSE;
    if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
      {
	m->trm_ID=DISPLAYOBJECT->ID;
	m->trm_Class=TRMS_NEWVALUE;
	m->trm_Data=CHECKBOX->Checked;
      }
    TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,CHECKBOX->Checked);
    return 1;
  }
  else return 0;
}
