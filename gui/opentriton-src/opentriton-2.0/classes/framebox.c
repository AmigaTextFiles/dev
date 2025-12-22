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


/****** triton.library/class_FrameBox ******
*
*   NAME	
*	class_FrameBox -- A framing box
*
*   SUPERCLASS
*	class_DisplayObject (no attributes inherited)
*
*   SYNOPSIS
*	TROB_FrameBox
*
*   ATTRIBUTES
*	<Default>        : ULONG boxtype (V2)
*	                     If no flag is set, unnamed boxes will
*	                     be grouping and named ones framing.
*	                   - TRFB_TEXT       : A text container
*	                   - TRFB_GROUPING   : A grouping box
*	                   - TRFB_FRAMING    : A framing box.
*	                   [create]
*	TRAT_ID          : ULONG objectid (V2)
*	                   [create]
*	TRAT_Backfill    : ULONG pattern
*	                   [create, set]
*	TRAT_Text        : STRPTR label (V2)
*	                   [create]
*	<other>          : <Child object>
*	                   [create]
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <clib/alib_protos.h>
#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "framebox.def"

#include <stdio.h>
#include <ctype.h>


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define FRAMEBOX object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////// The dispatcher //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_DEFAULTMETHOD(FrameBox)
{
  struct TR_Project *project;
  struct TROM_NewData newdata;
  struct TROM_InstallData installdata;
  BOOL found_one=FALSE;
  ULONG left, top, width, height;
  ULONG borderwidth,borderheight;
  STRPTR newtext;
  ULONG textwidth;
  LONG uspos;

  switch(messageid)
    {
    case TROM_NEW:
      NEWDATA->parseargs=FALSE;
      if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

      newtext=NULL;

      for(;;)
	{
	  switch(NEWDATA->firstitem->ti_Tag)
	    {
	    case TRAT_ID:
	      DISPLAYOBJECT->ID=NEWDATA->firstitem->ti_Data;
	      break;
	    case TRAT_Backfill:
	      DISPLAYOBJECT->BackfillType=NEWDATA->firstitem->ti_Data;
	      break;
	    case TRAT_Text:
	      newtext=(STRPTR)(NEWDATA->firstitem->ti_Data);
	      break;
	    default:
	      if(found_one==TRUE) goto nomoretags;
	      else
		{
		  newdata.project=NEWDATA->project;
		  newdata.grouptype=NULL;
		  newdata.firstitem=(((struct TROM_NewData *)(data))->firstitem)+1;
		  newdata.objecttype=NEWDATA->firstitem->ti_Tag;
		  newdata.itemdata=NEWDATA->firstitem->ti_Data;
		  newdata.backfilltype=DISPLAYOBJECT->BackfillType;
		  FRAMEBOX->ChildObject=
		    (struct TROD_DisplayObject *)TR_DoMethod(NULL,TROM_NEW,(APTR)&newdata);
		  NEWDATA->firstitem=newdata.firstitem-1;
		  found_one=TRUE;
		}
	    }
	  NEWDATA->firstitem++;
	}
    nomoretags:

      if(!FRAMEBOX->ChildObject) return NULL;

      if(newtext)
	{
	  FRAMEBOX->TextLength=TR_FirstOccurance(0,newtext)+1;
	  if(!(FRAMEBOX->Text=(STRPTR)AllocVec(FRAMEBOX->TextLength, MEMF_ANY))) return NULL;
	  CopyMem((APTR)newtext,(APTR)(FRAMEBOX->Text),FRAMEBOX->TextLength);
	  FRAMEBOX->BoxType=TRFT_ABSTRACT_FRAMEBOX;
	}
      else FRAMEBOX->BoxType=TRFT_ABSTRACT_GROUPBOX;

      if(FRAMEBOX->Flags&TRFB_GROUPING) FRAMEBOX->BoxType=TRFT_ABSTRACT_GROUPBOX;
      if(FRAMEBOX->Flags&TRFB_FRAMING) FRAMEBOX->BoxType=TRFT_ABSTRACT_FRAMEBOX;

      borderwidth=TR_FrameBorderWidth(NEWDATA->project,FRAMEBOX->BoxType);
      borderheight=TR_FrameBorderHeight(NEWDATA->project,FRAMEBOX->BoxType);

      DISPLAYOBJECT->XResize   = FRAMEBOX->ChildObject->XResize;
      DISPLAYOBJECT->YResize   = FRAMEBOX->ChildObject->YResize;
      DISPLAYOBJECT->MinWidth  = FRAMEBOX->ChildObject->MinWidth  + (2*borderwidth);
      DISPLAYOBJECT->MinHeight = FRAMEBOX->ChildObject->MinHeight + (2*borderheight);

      if(FRAMEBOX->Text)
	{
	  FRAMEBOX->PixelTextLength=TR_TextWidth(NEWDATA->project,(STRPTR)(FRAMEBOX->Text),TRTX_TITLE);
	  textwidth=FRAMEBOX->PixelTextLength+((NEWDATA->project->trp_PropFont->tf_YSize)*3);
	  DISPLAYOBJECT->MinWidth=max(DISPLAYOBJECT->MinWidth,textwidth);
	  DISPLAYOBJECT->MinHeight+=(NEWDATA->project->trp_TotalPropFontHeight-borderheight);
	}

      return (ULONG)TR_AddObjectToIDList(NEWDATA->project, object);


    case TROM_SETATTRIBUTE:
      if((SETATDATA->attribute)!=TRAT_Backfill) return 0;
      DISPLAYOBJECT->BackfillType=SETATDATA->value;
      if(DISPLAYOBJECT->Installed) messageid=TROM_REFRESH;
      else return 1;


    case TROM_INSTALL:
    case TROM_REFRESH:
      TR_SUPERMETHOD;

      project = OBJECT->Project;
      left    = DISPLAYOBJECT->Left;
      top     = DISPLAYOBJECT->Top;
      width   = DISPLAYOBJECT->Width;
      height  = DISPLAYOBJECT->Height;

      borderwidth=TR_FrameBorderWidth(project,FRAMEBOX->BoxType);
      borderheight=TR_FrameBorderHeight(project,FRAMEBOX->BoxType);

      if(FRAMEBOX->BoxType==TRFT_ABSTRACT_FRAMEBOX)
	{
	  TR_InternalAreaFill(project,NULL,left+borderwidth,
			      top+((project->trp_TotalPropFontHeight-borderheight)/2)+borderheight,
			      left+width-1-borderwidth,top+height-1-borderheight,
			      DISPLAYOBJECT->BackfillType);
	  TR_DrawFrame(project,NULL,
		       left,top+((project->trp_TotalPropFontHeight-borderheight)/2),
		       width,height-((project->trp_TotalPropFontHeight-borderheight)/2),
		       FRAMEBOX->BoxType,FALSE);
	  TR_InternalAreaFill(project,NULL,left+((width-FRAMEBOX->PixelTextLength)/2)
			      -(project->trp_PropFont->tf_YSize)/2,top,
			      left+((width-FRAMEBOX->PixelTextLength)/2)+FRAMEBOX->PixelTextLength
			      +(project->trp_PropFont->tf_YSize)/2,
			      top+project->trp_TotalPropFontHeight,
			      DISPLAYOBJECT->BackfillType);
	  TR_PrintText(project,project->trp_Window->RPort,FRAMEBOX->Text,
		       left+((width-FRAMEBOX->PixelTextLength)/2),top,0,TRTX_TITLE);
	  top+=(project->trp_TotalPropFontHeight-borderheight);
	  height-=(project->trp_TotalPropFontHeight-borderheight);

	  if((messageid==TROM_INSTALL)&&
	     (uspos=TR_FirstOccurance(project->trp_Underscore,FRAMEBOX->Text)+1))
	    DISPLAYOBJECT->Shortcut=tolower(FRAMEBOX->Text[uspos]);
	}
      else
	{
	  TR_InternalAreaFill(project,NULL,
			      left+borderwidth,top+borderheight,
			      left+width-1-borderwidth,top+height-1-borderheight,
			      DISPLAYOBJECT->BackfillType);
	  TR_DrawFrame(project,NULL,left,top,width,height,FRAMEBOX->BoxType,FALSE);
	}

      installdata.left   = left+borderwidth;
      installdata.top    = top+borderheight;
      installdata.width  = width-(2*borderwidth);
      installdata.height = height-(2*borderheight);

      return TR_DoMethod((struct TROD_Object *)(FRAMEBOX->ChildObject),messageid,(APTR)&installdata);


    case TROM_CREATECLASS:
    case TROM_DISPOSECLASS:
    case TROM_KEYUP:
    case TROM_KEYDOWN:
    case TROM_KEYCANCELLED:
    case TROM_DISABLED:
    case TROM_ENABLED:
      return NULL; /* Don't forward */


    case TROM_DISPOSE:
      if(FRAMEBOX->Text) FreeVec((APTR)(FRAMEBOX->Text));
      return TR_DoMethod((struct TROD_Object *)(FRAMEBOX->ChildObject),messageid,data);


    default:
      TR_SUPERMETHOD;
      return TR_DoMethod((struct TROD_Object *)(FRAMEBOX->ChildObject),messageid,data);
    }
}
