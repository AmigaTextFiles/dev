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


/****** triton.library/class_Listview ******
*
*   NAME
*	class_Listview -- A GadTools Listview gadget
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Listview
*
*   ATTRIBUTES
*	<Default>        : struct List *entries
*	                   [create, set]
*	TRAT_Flags       : ULONG flags
*	                   - Listview type (mutually exclusive):
*	                     - TRLV_READONLY     : A read-only list
*	                     - TRLV_SELECT       : You may select an entry
*	                     - TRLV_SHOWSELECTED : Show selected entry
*	                   - TRLV_NOCURSORKEYS   : Don't use arrow keys
*	                   - TRLV_NONUMPADKEYS   : Don't use keypad keys
*	                   - TRLV_FWFONT         : Use the fixed-width font
*	                   - TRLV_NOGAP (V2)     : Leave no gap below the
*	                                           list but instead at the
*	                                           end of the group.
*	                   [create, set]
*	TRAT_Value       : ULONG selected        : Currently selected entry
*	                                           (TRLV_SHOWSELECTED only)
*	                   [create, set, get]
*	TRLV_Top         : ULONG top
*	                   [create, set, get]
*	TRLV_VisibleLines: ULONG visiblelines    : Number of visible lines
*	                   [get]
*	TRAT_MinWidth    : ULONG minwidth        : Minimum width
*	                                           (Default: 10 characters)
*	                   [create, set]
*	TRAT_MinHeight   : ULONG minheight       : Minimum height
*	                                           (Default: 4 lines)
*	                   [create, set]
*
*   APPLICATION MESSAGES
*	'Select' listviews send TRMS_ACTION messages. 'ShowSelected' lists
*	send TRMS_NEWVALUE messages. trm_Data contains the ordinal number
*	of the selected entry. trm_Qualifier&IEQUALIFIER_REPEAT is set if
*	the user has double-clicked the specified listview entry.
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "listview.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define LISTVIEW object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Helping functions //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#ifdef TR_OS39

LONG __regargs __inline TR_ListViewPos(struct Gadget *gadget, struct Window *window)
{
  LONG top;

  GT_GetGadgetAttrs(gadget, window, NULL, GTLV_Top, &top, TAG_END);
  return top;
}

ULONG __regargs __inline TR_GetBetterListviewHeight(struct TROD_Listview *object, ULONG oheight)
{
  ULONG bheight;

  LISTVIEW->DispLines=(oheight-4)/LISTVIEW->FontHeight;
  bheight=LISTVIEW->FontHeight*LISTVIEW->DispLines+4;
  return bheight;
}

#else

LONG __regargs TR_ListViewPos(struct Gadget *gadget, struct Window *window)
{
  LONG top;

  if(TR_Global.trg_OSVersion<39) top=(LONG)(*(short *)(((char *)gadget)+sizeof(struct Gadget)+4));
  else GT_GetGadgetAttrs(gadget, window, NULL, GTLV_Top, &top, TAG_END);
  return top;
}

ULONG __regargs TR_GetBetterListviewHeight(struct TROD_Listview *object, ULONG oheight)
{
  ULONG bheight;

  if(TR_Global.trg_OSVersion>=39) LISTVIEW->DispLines=(oheight-4)/LISTVIEW->FontHeight;
  else LISTVIEW->DispLines=((oheight-8)/LISTVIEW->FontHeight)-1;
  bheight=LISTVIEW->FontHeight*LISTVIEW->DispLines+4;
  if(TR_Global.trg_OSVersion<39)
    if(LISTVIEW->ShowSelected) bheight+=LISTVIEW->FontHeight;
  return bheight;
}

#endif


void __regargs TR_ReadListviewPos(struct TROD_Listview *object)
{
  LISTVIEW->Top=
    TR_ListViewPos((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window);
}


BOOL __regargs TR_RethinkListview(struct TROD_Listview *object)
{
  BOOL newtop=FALSE;

  if(LISTVIEW->Value<LISTVIEW->Top)
    {
      LISTVIEW->Top=LISTVIEW->Value;
      newtop=TRUE;
    }
  else if(LISTVIEW->Value>LISTVIEW->Top+LISTVIEW->DispLines-1)
    {
      LISTVIEW->Top=LISTVIEW->Value-LISTVIEW->DispLines+1;
      newtop=TRUE;
    }

  if(DISPLAYOBJECT->Installed) if(newtop)
    GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
		      OBJECT->Project->trp_Window,NULL,GTLV_Top,LISTVIEW->Top,TAG_END);

  return newtop;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Listview,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

  if(!(LISTVIEW->MinWidth)) LISTVIEW->MinWidth=10;
  if(!(LISTVIEW->MinHeight)) LISTVIEW->MinHeight=4;
  LISTVIEW->LastEntry=0;
  LISTVIEW->LastSeconds=0;
  LISTVIEW->LastMicros=0;
  LISTVIEW->DoubleClicked=FALSE;

  DISPLAYOBJECT->XResize=TRUE;
  DISPLAYOBJECT->YResize=TRUE;

  data->project->trp_IDCMPFlags|=LISTVIEWIDCMP|ARROWIDCMP|SCROLLERIDCMP;

  LISTVIEW->ScrollWidth=max(CHECKBOX_HEIGHT,data->project->trp_TotalPropFontHeight)+5;

  if((LISTVIEW->Flags)&TRLV_FWFONT)
    {
      LISTVIEW->FontHeight=data->project->trp_FixedWidthFont->tf_YSize;
      DISPLAYOBJECT->MinHeight=
	LISTVIEW->FontHeight*LISTVIEW->MinHeight+4;
      DISPLAYOBJECT->MinWidth=
	LISTVIEW->ScrollWidth+(data->project->trp_FixedWidthFont->tf_XSize*(LISTVIEW->MinWidth+1))+1;
    }
  else
    {
      LISTVIEW->FontHeight=data->project->trp_TotalPropFontHeight;
      DISPLAYOBJECT->MinHeight=
	LISTVIEW->FontHeight*LISTVIEW->MinHeight+4;
      DISPLAYOBJECT->MinWidth=
	LISTVIEW->ScrollWidth+(data->project->trp_PropFont->tf_XSize*(LISTVIEW->MinWidth+1))+1;
    }

  return (ULONG)object;
}


TR_METHOD(Listview,INSTALL,InstallData)
{
  UWORD fillbottom;

  TRDP_DisplayObject_INSTALL(object,messageid,data,metaclass->trc_SuperClass);
  fillbottom=DISPLAYOBJECT->Top-1+TR_GetBetterListviewHeight(object,DISPLAYOBJECT->Height);
  TR_InternalAreaFill(OBJECT->Project,NULL,DISPLAYOBJECT->Left,DISPLAYOBJECT->Top,
		      DISPLAYOBJECT->Left+DISPLAYOBJECT->Width-1,fillbottom,TRBF_NONE);
  if((LISTVIEW->Flags)&TRLV_FWFONT)
    OBJECT->Project->trp_NewGadget->ng_TextAttr=OBJECT->Project->trp_FixedWidthAttr;
  DISPLAYOBJECT->PrivData=
    (ULONG)TR_CreateGadgetTags(OBJECT->Project,
			       OBJECT,
			       LISTVIEW_KIND,
			       DISPLAYOBJECT->Left,
			       DISPLAYOBJECT->Top,
			       DISPLAYOBJECT->Width,
			       DISPLAYOBJECT->Height,
			       GA_Disabled,      TR_DO_DISABLED,
			       GTLV_Labels,      LISTVIEW->Entries,
			       GTLV_Top,         LISTVIEW->Top,
			       GTLV_ReadOnly,    LISTVIEW->ReadOnly,
			       (LISTVIEW->ShowSelected)?GTLV_ShowSelected:TAG_IGNORE,NULL,
			       GTLV_Selected,    LISTVIEW->Value,
			       GTLV_ScrollWidth, LISTVIEW->ScrollWidth,
			       TAG_END);
  if((LISTVIEW->Flags)&TRLV_FWFONT)
    OBJECT->Project->trp_NewGadget->ng_TextAttr=OBJECT->Project->trp_PropAttr;
  if(DISPLAYOBJECT->PrivData) return 1L; else return NULL;
}


TR_METHOD(Listview,SETATTRIBUTE,SetAttributeData)
{
  switch(data->attribute)
    {
    case TRAT_Value:
      if(LISTVIEW->Value!=data->value)
	{
	  LISTVIEW->Value=data->value;
	  //--? if(LISTVIEW->ShowSelected) TR_RethinkListview(object);
	  if(DISPLAYOBJECT->Installed) GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
							 OBJECT->Project->trp_Window, NULL,
							 GTLV_Selected,LISTVIEW->Value,TAG_END);
	}
      return 1;

    case TRLV_Top:
      if(LISTVIEW->Top!=data->value)
	{
	  LISTVIEW->Top=data->value;
	  if(LISTVIEW->ShowSelected) TR_RethinkListview(object);
	  if(DISPLAYOBJECT->Installed) GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
							 OBJECT->Project->trp_Window, NULL,
							 GTLV_Top,LISTVIEW->Top,TAG_END);
	}
      return 1;

    case TRAT_MinWidth:
      LISTVIEW->MinWidth=data->value;
      return 1;

    case TRAT_MinHeight:
      LISTVIEW->MinHeight=data->value;
      return 1;

    case TRAT_Flags:
      LISTVIEW->Flags=data->value;
      if(LISTVIEW->Flags&TRLV_SHOWSELECTED)
	{ LISTVIEW->ShowSelected=TRUE; LISTVIEW->ReadOnly=FALSE; }
      else if(LISTVIEW->Flags&TRLV_SELECT)
	{ LISTVIEW->ShowSelected=FALSE; LISTVIEW->ReadOnly=FALSE; }
      else /* TRLV_READONLY */
	{ LISTVIEW->ShowSelected=FALSE; LISTVIEW->ReadOnly=TRUE; }
      return 1;

    case 0:
      LISTVIEW->Entries=(struct List *)(data->value);
      if((LISTVIEW->Entries) && (LISTVIEW->Entries!=(struct List *)(~0)))
	{
	  LISTVIEW->TotLines=TR_CountListEntries(LISTVIEW->Entries);
	  LISTVIEW->Value=
	    min(LISTVIEW->Value,LISTVIEW->TotLines-1);
	}
      if(DISPLAYOBJECT->Installed) GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
						     OBJECT->Project->trp_Window,NULL,
						     GTLV_Labels,LISTVIEW->Entries,
						     GTLV_Selected,LISTVIEW->Value,TAG_END);
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Listview,GETATTRIBUTE)
{
  switch((ULONG)data)
  {
    case TRAT_Value:
      return LISTVIEW->Value;
    case TRLV_Top:
      TR_ReadListviewPos(LISTVIEW);
      return LISTVIEW->Top;
    case TRLV_VisibleLines:
      return LISTVIEW->DispLines;
    default:
      return TRDP_DisplayObject_GETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
  }
}


TR_SIMPLEMETHOD(Listview,DISABLED_ENABLED)
{
  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
		    OBJECT->Project->trp_Window,NULL,
		    GA_Disabled,TR_DO_DISABLED,TAG_END);
  TR_ReadListviewPos(LISTVIEW);
  return 1L;
}


TR_SIMPLEMETHOD(Listview,PREGTREMOVE)
{
  TR_ReadListviewPos(LISTVIEW);
  return 1L;
}


TR_METHOD(Listview,KEYDOWN_REPEATEDKEYDOWN,EventData)
{
  BOOL sendmsg=FALSE, newval=FALSE, newtop=FALSE;
  struct TR_Message *m;

  if(!(LISTVIEW->TotLines)) return 1; /* Empty listview */

  TR_ReadListviewPos(LISTVIEW);

  if(LISTVIEW->ShowSelected)
    {
      if(data->imsg->Code)
        {
          if(LISTVIEW->Value>0)
	    {
	      LISTVIEW->Value--;
	      sendmsg=TRUE;
	      newval=TRUE;
	    }
        }
      else
        {
          if(LISTVIEW->Value<LISTVIEW->TotLines-1)
	    {
	      LISTVIEW->Value++;
	      sendmsg=TRUE;
	      newval=TRUE;
	    }
        }
      TR_RethinkListview(object);
    }
  else /* Not ShowSelected */
    {
      if(data->imsg->Code)
        {
          if(LISTVIEW->Top>0)
	    {
	      LISTVIEW->Top--;
	      newtop=TRUE;
	    }
        }
      else
        {
          if(LISTVIEW->Top+LISTVIEW->DispLines<LISTVIEW->TotLines)
	    {
	      LISTVIEW->Top++;
	      newtop=TRUE;
	    }
        }
      if(newtop) GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
				   OBJECT->Project->trp_Window,NULL,GTLV_Top,LISTVIEW->Top,TAG_END);
    }

  if(sendmsg) if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
    {
      m->trm_ID=DISPLAYOBJECT->ID;
      m->trm_Class=TRMS_NEWVALUE;
      m->trm_Data=LISTVIEW->Value;
    }
  if(newval)
    {
      GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window,NULL,
			GTLV_Selected,LISTVIEW->Value,TAG_END);
      TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,LISTVIEW->Value);
    }
  return 1L;
}


TR_METHOD(Listview,EVENT,EventData)
{
  BOOL sendmsg=FALSE;
  struct IntuiMessage *imsg;
  UWORD ckeys=1,nkeys=1;
  ULONG oldval, oldtop;
  struct TR_Message *m;

  imsg=data->imsg;
  if((LISTVIEW->Flags)&TRLV_NOCURSORKEYS) ckeys=0;
  if((LISTVIEW->Flags)&TRLV_NONUMPADKEYS) nkeys=0;

  switch(imsg->Class)
    {
    case IDCMP_GADGETUP:
      if(imsg->IAddress==(APTR)(DISPLAYOBJECT->PrivData))
	{
	  LISTVIEW->Value=imsg->Code;
	  if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	    {
	      m->trm_ID=DISPLAYOBJECT->ID;
	      m->trm_Class=TRMS_NEWVALUE;
	      m->trm_Data=LISTVIEW->Value;
	      m->trm_Qualifier=0;
	      if(LISTVIEW->DoubleClicked==TRUE) LISTVIEW->DoubleClicked=FALSE;
	      else if(LISTVIEW->LastEntry==LISTVIEW->Value)
		{
		  if(DoubleClick(LISTVIEW->LastSeconds,LISTVIEW->LastMicros,imsg->Seconds,imsg->Micros))
		    {
		      m->trm_Qualifier=IEQUALIFIER_REPEAT;
		      LISTVIEW->DoubleClicked=TRUE;
		    }
		}
            }
	  LISTVIEW->LastEntry=LISTVIEW->Value;
	  LISTVIEW->LastSeconds=imsg->Seconds;
	  LISTVIEW->LastMicros=imsg->Micros;
	  TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,LISTVIEW->Value);
	  return 1L;
	}

    case IDCMP_RAWKEY:
      if(!(LISTVIEW->TotLines)) break; /* Empty listview */

      LISTVIEW->Top=
	TR_ListViewPos((struct Gadget *)DISPLAYOBJECT->PrivData,OBJECT->Project->trp_Window);

      oldval=LISTVIEW->Value;
      oldtop=LISTVIEW->Top;

      /*------------------------------------ line up -----------------------------*/
      if( ckeys*((imsg->Code==76L)&&
		 (!(imsg->Qualifier&
		    (IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT|
		     IEQUALIFIER_LALT|IEQUALIFIER_RALT|IEQUALIFIER_CONTROL))))
	  || nkeys*((imsg->Code==62L)&&(imsg->Qualifier&(IEQUALIFIER_NUMERICPAD))) )
	{
	  if(LISTVIEW->ShowSelected)
	    {
	      if(oldval>0)
		{
		  LISTVIEW->Value--;
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	    }
	  else if(oldtop>0) LISTVIEW->Top--;
	}
      /*-------------------------------- page up -------------------------------------*/
      else if( ckeys*((imsg->Code==76L)&&(imsg->Qualifier&(IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT)))
	       || nkeys*((imsg->Code==63L)&&(imsg->Qualifier&(IEQUALIFIER_NUMERICPAD))) )
	{
	  if(LISTVIEW->ShowSelected)
	    {
	      if(oldval+2>LISTVIEW->DispLines)
		{
		  LISTVIEW->Value-=(LISTVIEW->DispLines-1);
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	      else
		{
		  LISTVIEW->Value=0;
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	    }
	  else
	    {
	      if(oldtop>LISTVIEW->DispLines-1) LISTVIEW->Top-=LISTVIEW->DispLines-1;
	      else if(oldtop>0) LISTVIEW->Top=0;
	    }
	}
      /*---------------------------------------- top ----------------------------------*/
      else if( ckeys*((imsg->Code==76L)&&(imsg->Qualifier&IEQUALIFIER_CONTROL))
	       || nkeys*((imsg->Code==61L)&&(imsg->Qualifier&(IEQUALIFIER_NUMERICPAD))) )
	{
	  if(LISTVIEW->ShowSelected)
	    {
	      if(oldval!=0)
		{
		  LISTVIEW->Value=0;
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	    }
	  else if(oldtop>0) LISTVIEW->Top=0;
	}
      /*---------------------------------- line down -------------------------------------*/
      else if( ckeys*((imsg->Code==77L)&&
		      (!(imsg->Qualifier&
			 (IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT|IEQUALIFIER_LALT
			  |IEQUALIFIER_RALT|IEQUALIFIER_CONTROL))))
	       || nkeys*((imsg->Code==30L)&&(imsg->Qualifier&(IEQUALIFIER_NUMERICPAD))) )
	{
	  if(LISTVIEW->ShowSelected)
	    {
	      if(oldval<LISTVIEW->TotLines-1)
		{
		  LISTVIEW->Value++;
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	    }
	  else if(oldtop+LISTVIEW->DispLines<LISTVIEW->TotLines) LISTVIEW->Top++;
	}
      /*------------------------------------- page down -------------------------------*/
      else if( ckeys*((imsg->Code==77L)&&(imsg->Qualifier&(IEQUALIFIER_LSHIFT|IEQUALIFIER_RSHIFT)))
	       || nkeys*((imsg->Code==31L)&&(imsg->Qualifier&(IEQUALIFIER_NUMERICPAD))) )
	{
	  if(LISTVIEW->ShowSelected)
	    {
	      if(oldval+LISTVIEW->DispLines-1<(LISTVIEW->TotLines))
		{
		  LISTVIEW->Value+=(LISTVIEW->DispLines-1);
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	      else
		{
		  LISTVIEW->Value=LISTVIEW->TotLines-1;
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	    }
	  else
	    {
	      if(oldtop+2*LISTVIEW->DispLines-1<LISTVIEW->TotLines)
		LISTVIEW->Top+=LISTVIEW->DispLines-1;
	      else if(oldtop+LISTVIEW->DispLines<LISTVIEW->TotLines)
		LISTVIEW->Top=LISTVIEW->TotLines-LISTVIEW->DispLines;
	    }
	}
      /*--------------------------------------- bottom ----------------------------------*/
      else if( ckeys*((imsg->Code==77L)&&(imsg->Qualifier&IEQUALIFIER_CONTROL))
	       || nkeys*((imsg->Code==29L)&&(imsg->Qualifier&(IEQUALIFIER_NUMERICPAD))) )
	{
	  if(LISTVIEW->ShowSelected)
	    {
	      if(oldval!=LISTVIEW->TotLines-1)
		{
		  LISTVIEW->Value=LISTVIEW->TotLines-1;
		  sendmsg=TRUE;
		  TR_RethinkListview(object);
		}
	    }
	  else if(oldtop+LISTVIEW->DispLines<LISTVIEW->TotLines)
	    LISTVIEW->Top=LISTVIEW->TotLines-LISTVIEW->DispLines;
	}

      if(sendmsg) if(m=TR_CreateMsg(Self.DO.O.Project->trp_App))
	{
	  m->trm_ID=DISPLAYOBJECT->ID;
	  m->trm_Class=TRMS_NEWVALUE;
	  m->trm_Data=LISTVIEW->Value;
	}
      if(!(LISTVIEW->ShowSelected)) if(LISTVIEW->Top!=oldtop)
	{
	  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
			    OBJECT->Project->trp_Window,NULL,GTLV_Top,LISTVIEW->Top,TAG_END);
	  TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRLV_Top,LISTVIEW->Top);
	}
      if(LISTVIEW->Value!=oldval)
	{
	  GT_SetGadgetAttrs((struct Gadget *)DISPLAYOBJECT->PrivData,
			    OBJECT->Project->trp_Window,NULL,
			    GTLV_Selected,LISTVIEW->Value,TAG_END);
	  TR_SetAttribute(OBJECT->Project,DISPLAYOBJECT->ID,TRAT_Value,LISTVIEW->Value);
	}
      return NULL;
    }
  return NULL;
}


TR_SIMPLEMETHOD(Listview,GETBETTERHEIGHT)
{
  if((LISTVIEW->Flags)&TRLV_NOGAP)
    (*((ULONG *)(data)))=TR_GetBetterListviewHeight(object,(*((ULONG *)(data))));
  return NULL;
}
