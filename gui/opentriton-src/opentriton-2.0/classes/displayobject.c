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


/****** triton.library/class_DisplayObject ******
*
*   NAME	
*	class_DisplayObject -- An abstract display object
*
*   SUPERCLASS
*	class_Object
*
*   SYNOPSIS
*	(TROB_DisplayObject)
*
*   ATTRIBUTES
*	<Default>              : <unused>
*	TRAT_ID                : ULONG objectid
*	                         [create, get]
*	TRAT_Disabled          : BOOL disabled
*	                         [create, set, get]
*	TRDO_QuickHelpString   : STRPTR string
*	                         [create, set, get]
*
*   OBJECT MESSAGES
*	TROM_INSTALL           : Install an object at its place in a rastport
*	TROM_REMOVE            : Remove an installed object
*	TROM_SETATTRIBUTE      : Modify an attribute
*	TROM_GETATTRIBUTE      : Query an attribute
*	TROM_HIT               : Find an object from a pair of coordinates
*	(TROM_REFRESH)         : Refresh/redraw an object's on-screen
*	                         representation
*	(TROM_EVENT)           : An IDCMP event has arrived
*	(TROM_DISABLED)        : Disable/ghost an object
*	(TROM_ENABLED)         : Enable an object again
*	(TROM_KEYDOWN)         : A key has been pressed down
*	(TROM_REPEATEDKEYDOWN) : A key is still pressed down
*	(TROM_KEYUP)           : A key has been released
*	(TROM_CANCELLED)       : A key press has been cancelled
*	(TROM_CREATECLASS)     : Create class-specific data
*	(TROM_DISPOSECLASS)    : Dispose of class-specific data
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "displayobject.def"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->O))
#define DISPLAYOBJECT object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(DisplayObject,NEW,NewData)
{
  struct TROM_SetAttributeData sadata;

  TRDP_Object_NEW(object,messageid,data,metaclass->trc_SuperClass);

  DISPLAYOBJECT->BackfillType=data->backfilltype;

  if(data->parseargs)
  {
    sadata.attribute=0;
    sadata.value=data->itemdata;
    TR_DoMethod(OBJECT,TROM_SETATTRIBUTE,(APTR)(&sadata));
    for(;;)
    {
      switch(data->firstitem->ti_Tag)
      {
        case TRAT_ID:
	  DISPLAYOBJECT->ID=data->firstitem->ti_Data;
	  break;
	case TRAT_Disabled:
	  if(data->firstitem->ti_Data) DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_DISABLED;
	  else DISPLAYOBJECT->Flags&=~TROB_DISPLAYOBJECT_DISABLED;
	  break;
	default:
	  if(data->firstitem->ti_Tag==TRGR_End) goto nomoretags;
	  if(TR_GetTagType(data->firstitem->ti_Tag)!=TRTG_OAT) goto nomoretags;
	  sadata.attribute=data->firstitem->ti_Tag;
	  sadata.value=data->firstitem->ti_Data;
	  TR_DoMethod(OBJECT,TROM_SETATTRIBUTE,(APTR)(&sadata));
	  break;
      }
      data->firstitem++;
    }
  nomoretags:
    return (ULONG)TR_AddObjectToIDList(OBJECT->Project, object);
  }

  return (ULONG)object;
}


TR_METHOD(DisplayObject,INSTALL,InstallData)
{
  DISPLAYOBJECT->Left=data->left;
  DISPLAYOBJECT->Top=data->top;
  DISPLAYOBJECT->Width=data->width;
  DISPLAYOBJECT->Height=data->height;
  DISPLAYOBJECT->Installed=TRUE;
  return 1;
}


TR_SIMPLEMETHOD(DisplayObject,REMOVE)
{
  DISPLAYOBJECT->Installed=FALSE;
  return 1;
}


TR_METHOD(DisplayObject,SETATTRIBUTE,SetAttributeData)
{
  ULONG textLength;

  switch(data->attribute)
    {
    case TRAT_Disabled:
      if(TR_DO_DISABLED!=(data->value?TRUE:FALSE))
	{
	  if(data->value) DISPLAYOBJECT->Flags|=TROB_DISPLAYOBJECT_DISABLED;
	  else DISPLAYOBJECT->Flags&=~TROB_DISPLAYOBJECT_DISABLED;
	  if(DISPLAYOBJECT->Installed)
	    TR_DoMethod((struct TROD_Object *)object,(data->value)?TROM_DISABLED:TROM_ENABLED,NULL);
	}
      return 1;

    case TRDO_QuickHelpString:
      if(DISPLAYOBJECT->QuickHelpString)
	TR_FreePooled(OBJECT->Project->trp_MemPool,
		      (APTR)(DISPLAYOBJECT->QuickHelpString),
		      TR_FirstOccurance(0,DISPLAYOBJECT->QuickHelpString)+1);
      textLength=TR_FirstOccurance(0,(STRPTR)(data->value))+1;
      if(!(DISPLAYOBJECT->QuickHelpString=
	   (STRPTR)TR_AllocPooled(OBJECT->Project->trp_MemPool,textLength)))
	return 0;
      CopyMem((APTR)(data->value),(APTR)(DISPLAYOBJECT->QuickHelpString),textLength);

    case 0:
      return 1;

    default:
      return 0;
    }
}


TR_SIMPLEMETHOD(DisplayObject,GETATTRIBUTE)
{
  switch((ULONG)data)
    {
    case TRAT_Disabled:
      return (ULONG)(TR_DO_DISABLED);

    case TRAT_ID:
      return (ULONG)(DISPLAYOBJECT->ID);

    case TRDO_QuickHelpString:
      return (ULONG)(DISPLAYOBJECT->QuickHelpString);
    }
  return 0;
}


TR_METHOD(DisplayObject,HIT,HitData)
{
  if(object->ID)
    if((data->x>=object->Left) &&
       (data->x<object->Left+object->Width) &&
       (data->y>=object->Top) &&
       (data->y<object->Top+object->Height))
      data->object=object;
  return 1;
}
