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


/****** triton.library/class_Cycle ******
*
*   NAME	
*	class_Cycle -- A GadTools cycle gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Cycle
*
*   ATTRIBUTES
*	<Default>        : STRPTR *entries    : Gadget etry labels
*	                   [create]
*	TRAT_Value       : ULONG number
*	                   [create, set, get]
*	TRAT_Flags       : ULONG flags (V2)
*	                   - TRCY_MX          : "Unfold" the cycle gadget to
*	                                        a mutually exclusive gadget.
*	                   - TRCY_RIGHTLABELS : Put the labels to the right
*	                                        side (TRCY_MX only).
*	                   [create]
*
*   NOTES
*	Disabling TRCY_MX-style gadgets requires OS3.0 or better.
*
*   APPLICATION MESSAGES
*	TRMS_NEWVALUE is sent when the selected entry has changed.
*	trm_Data contains the ordinal number of the new entry.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "cycle.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define CYCLE object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Cycle,NEW,NewData)
{
  ULONG ntextwidth;

  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;
  data->project->trp_IDCMPFlags|=CYCLEIDCMP|MXIDCMP;
  for(CYCLE->Number=0,CYCLE->TextWidth=0;;CYCLE->Number++)
    {
      if(CYCLE->Entries[CYCLE->Number]==NULL) break;
      ntextwidth=TR_TextWidth(data->project,CYCLE->Entries[CYCLE->Number],TRTX_NOUNDERSCORE);
      CYCLE->TextWidth=max(CYCLE->TextWidth,ntextwidth);
    }

  if(CYCLE->Flags&TRCY_MX)
    {
      CYCLE->GT_Kind=MX_KIND;
      CYCLE->GT_Labels=GTMX_Labels;
      CYCLE->GT_Active=GTMX_Active;
      CYCLE->GT_Spacing=GTMX_Spacing;
      CYCLE->Spacing=(data->project->trp_PropFont->tf_YSize)/4;
      DISPLAYOBJECT->MinWidth=CYCLE->TextWidth+8;
#ifndef TR_OS39
      if(TR_Global.trg_OSVersion>=39)
        {
#endif
          DISPLAYOBJECT->MinWidth+=max(MX_WIDTH,(data->project->trp_PropFont->tf_YSize+1));
#ifndef TR_OS39
        }
      else /* OS version < 39 */
        {
          DISPLAYOBJECT->MinWidth+=MX_WIDTH;
        }
#endif
      DISPLAYOBJECT->MinHeight=
	(CYCLE->Number*data->project->trp_PropFont->tf_YSize)
	+((CYCLE->Number-1)*((data->project->trp_PropFont->tf_YSize)/4))
	+((data->project->trp_PropFont->tf_YSize<9)?(9-data->project->trp_PropFont->tf_YSize):0);
    }
  else
    {
      CYCLE->GT_Kind=CYCLE_KIND;
      CYCLE->GT_Labels=GTCY_Labels;
      CYCLE->GT_Active=GTCY_Active;
      CYCLE->GT_Spacing=TAG_IGNORE;
      DISPLAYOBJECT->MinWidth=(data->project->trp_PropFont->tf_YSize*2)+24+CYCLE->TextWidth;
      DISPLAYOBJECT->MinHeight=(data->project->trp_PropFont->tf_YSize)+6;
      DISPLAYOBJECT->XResize=TRUE;
    }

  return (ULONG)object;
}


TR_METHOD(Cycle,INSTALL,InstallData)
{
  struct TR_Project *project;

  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  project=OBJECT->Project;
  if(CYCLE->Flags&TRCY_RIGHTLABELS) project->trp_NewGadget->ng_Flags=PLACETEXT_RIGHT;
  else project->trp_NewGadget->ng_Flags=PLACETEXT_LEFT;
  if(DISPLAYOBJECT->PrivData=(ULONG)
     TR_CreateGadgetTags(OBJECT->Project,
			 OBJECT,
			 CYCLE->GT_Kind,
			 DISPLAYOBJECT->Left+
			 ((CYCLE->Flags&TRCY_MX)?
			  ((CYCLE->Flags&TRCY_RIGHTLABELS)?0:(8+CYCLE->TextWidth)):0),
			 DISPLAYOBJECT->Top,
			 (CYCLE->Flags&TRCY_MX)?
			 max(MX_WIDTH,(project->trp_PropFont->tf_YSize+1)):(DISPLAYOBJECT->Width),
			 (CYCLE->Flags&TRCY_MX)?
			 (project->trp_PropFont->tf_YSize+1):(DISPLAYOBJECT->Height),
			 CYCLE->GT_Active,  CYCLE->Value,
			 CYCLE->GT_Labels,  (ULONG)(CYCLE->Entries),
			 CYCLE->GT_Spacing, CYCLE->Spacing,
			 GA_Disabled,           TR_DO_DISABLED,
			 (CYCLE->Flags&TRCY_MX)?GTMX_Scaled:TAG_IGNORE, TRUE,
			 TAG_END)) return 1L;
  else return NULL;
}


TR_METHOD(Cycle,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      if(CYCLE->Value!=data->value)
	{
	  CYCLE->Value=data->value;
	  if(DISPLAYOBJECT->Installed)
	    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,
			      NULL,CYCLE->GT_Active,CYCLE->Value,
			      GA_Disabled,TR_DO_DISABLED,TAG_END);
	}
      return 1;

    case 0:
      CYCLE->Entries=(STRPTR *)(data->value);
      return 1;

    case TRAT_Flags:
      CYCLE->Flags=data->value;
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Cycle,GETATTRIBUTE)
{
  switch((ULONG)data)
    {
    case TRAT_Value:
      return CYCLE->Value;
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Cycle,DISABLED_ENABLED)
{
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
		    CYCLE->GT_Active,CYCLE->Value,
		    GA_Disabled,TR_DO_DISABLED,TAG_END);
  return 1;
}


TR_METHOD(Cycle,KEYDOWN_REPEATEDKEYDOWN,EventData)
{
  struct TR_Message *m;

  CYCLE->Value+=CYCLE->Number;
  if(data->imsg->Code) CYCLE->Value--; else CYCLE->Value++;
  CYCLE->Value%=CYCLE->Number;

  if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
    {
      m->trm_ID=DISPLAYOBJECT->ID;
      m->trm_Class=TRMS_NEWVALUE;
      m->trm_Data=CYCLE->Value;
    }
  TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,CYCLE->Value);

  return TR_DIRECTMETHODCALL(Cycle,DISABLED_ENABLED);
}


TR_METHOD(Cycle,EVENT,EventData)
{
  struct TR_Message *m;

  if((data->imsg->Class&(IDCMP_GADGETUP|IDCMP_GADGETDOWN))
     &&(data->imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData)))
    {
      CYCLE->Value=data->imsg->Code;
      if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=CYCLE->Value;
	}
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,CYCLE->Value);
      return 1L;
    }
  else return NULL;
}
