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


/****** triton.library/class_Text ******
*
*   NAME	
*	class_Text -- A line of text / A value
*
*   SUPERCLASS
*	class_DisplayObject
*
*   SYNOPSIS
*	TROB_Text
*
*   ATTRIBUTES
*	<Default>        : <unused>
*	TRAT_Text        : STRPTR text
*	                   [create, set]
*	TRAT_Value       : ULONG number
*	                   [create, set]
*	TRAT_MinWidth    : ULONG number_of_average_chars
*	                   [create]
*	TRAT_Flags       : ULONG flags
*	                   - TRTX_NOUNDERSCORE    : Don't interpret underscores
*	                   - TRTX_HIGHLIGHT       : Highlight text
*	                   - TRTX_3D              : Highlight with shadows
*	                   - TRTX_BOLD            : Bold text
*	                   - TRTX_TITLE           : Use this for titles (e.g.
*	                                            of separator bars).
*	                   - TRTX_RIGHTALIGN (V6) : Align text to the right border
*	                   - TRTX_CENTER (V6)     : Center text
*	                   - TRTX_CLIPPED (V4)    : Text is resizable in X
*	                                            direction. Text which
*	                                            exceeds the available
*	                                            space will be truncated.
*	                   - TRTX_MULTILINE (V6)  : See TR_PrintText() autodoc
*	                                            clip for details
*	                   [create]
*
*   NOTES
*	TRTX_CLIPPED is mutually exclusive with TRTX_MULTILINE and TRTX_RIGHTALIGN.
*	Non-clipped texts (and especially multi-line texts) should not be changed.
*	Clipping is not possible when TRAT_MinWidth is specified.
*
*   SEE ALSO
*	TR_PrintText()
*
******/


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_THIS_IS_TRITON

#include <libraries/triton.h>
#include <clib/triton_protos.h>
#include "/internal.h"
#include "text.def"

#include <stdio.h>
#include <ctype.h>


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////// Object data //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define OBJECT (&(object->DO.O))
#define DISPLAYOBJECT (&(object->DO))
#define TEXT object


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////// A private definition //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TRTX_ISTEXT 0x00020000L


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////// Methods //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

TR_METHOD(Text,NEW,NewData)
{
  if(!TRDP_DisplayObject_NEW(object,messageid,data,metaclass->trc_SuperClass)) return NULL;

  if(!DISPLAYOBJECT->MinWidth)
    {
      if(DISPLAYOBJECT->Flags&TRTX_CLIPPED)
	{
	  DISPLAYOBJECT->MinWidth=2*data->project->trp_PropFont->tf_XSize;
	  DISPLAYOBJECT->XResize=TRUE;
	}
      else
	DISPLAYOBJECT->MinWidth=TR_TextWidth(data->project,(STRPTR)(DISPLAYOBJECT->PrivData),
					     DISPLAYOBJECT->Flags);
    }

  DISPLAYOBJECT->MinHeight=TR_TextHeight(data->project,(STRPTR)(DISPLAYOBJECT->PrivData),
					 DISPLAYOBJECT->Flags);

  return (ULONG)object;
}


TR_SIMPLEMETHOD(Text,INSTALL_REFRESH)
{
  struct TR_Project *project;
  UBYTE remdchar;
  ULONG rempos, left;

  TR_SUPERMETHOD;
  project=OBJECT->Project;
  left=DISPLAYOBJECT->Left;

  TR_InternalAreaFill(OBJECT->Project,NULL,left,DISPLAYOBJECT->Top,
		      left+DISPLAYOBJECT->Width-1,
		      DISPLAYOBJECT->Top+DISPLAYOBJECT->Height-1,DISPLAYOBJECT->BackfillType);

  if(DISPLAYOBJECT->Flags&TRTX_CLIPPED)
    {
      /* Cut string to fit */
      rempos=TR_FirstOccurance(0,(STRPTR)(DISPLAYOBJECT->PrivData));
      remdchar=0;
      while((TR_TextWidth(project,(STRPTR)(DISPLAYOBJECT->PrivData),DISPLAYOBJECT->Flags)
	     > DISPLAYOBJECT->Width) && rempos>0 )
	{
	  ((STRPTR)(DISPLAYOBJECT->PrivData))[rempos]=remdchar;
	  rempos--;
	  remdchar=((STRPTR)(DISPLAYOBJECT->PrivData))[rempos];
	  ((STRPTR)(DISPLAYOBJECT->PrivData))[rempos]=0;
	}
    }
  TR_PrintText(project, project->trp_Window->RPort, (STRPTR)(DISPLAYOBJECT->PrivData),
	       left, DISPLAYOBJECT->Top, DISPLAYOBJECT->Width, DISPLAYOBJECT->Flags);
  /* Restore original string */
  if(DISPLAYOBJECT->Flags&TRTX_CLIPPED) ((STRPTR)(DISPLAYOBJECT->PrivData))[rempos]=remdchar;
  return 1L;
}


TR_METHOD(Text,SETATTRIBUTE,SetAttributeData)
{
  STRPTR oldstring,newstring,setstring;
  UBYTE lineoftext[20];
  ULONG oldlength,newlength;
  LONG uspos;

  switch(data->attribute)
    {
    case TRAT_Value:
      if(DISPLAYOBJECT->Flags&TRTX_ISTEXT) return 0;
      TR_SPrintF(lineoftext,"%ld",data->value);
      setstring=lineoftext;
      /* Continue with the TRAT_Text statements below... */

    case TRAT_Text:
      if(data->attribute==TRAT_Text)
	{
	  /* Once a text, always a text... (sad but true) */
	  DISPLAYOBJECT->Flags|=TRTX_ISTEXT;
	  setstring=(STRPTR)(data->value);
	}

      newlength=TR_FirstOccurance(0,setstring)+1;
      oldstring=(STRPTR)(DISPLAYOBJECT->PrivData);
      oldlength=TEXT->TextLength;

      if(!(newstring=(STRPTR)TR_AllocPooled(OBJECT->Project->trp_MemPool,newlength))) return 0;

      DISPLAYOBJECT->PrivData=(ULONG)newstring;
      TEXT->TextLength=newlength;
      CopyMem((APTR)setstring,(APTR)newstring,newlength);
      if(oldstring) TR_FreePooled(OBJECT->Project->trp_MemPool,(APTR)oldstring,oldlength);
      if((uspos=
	  TR_FirstOccurance(OBJECT->Project->trp_Underscore,(STRPTR)(DISPLAYOBJECT->PrivData))+1))
	DISPLAYOBJECT->Shortcut=tolower(((STRPTR)(DISPLAYOBJECT->PrivData))[uspos]);
      if(DISPLAYOBJECT->Installed) TR_DIRECTMETHODCALL(Text,INSTALL_REFRESH);
      return 1;

    case TRAT_MinWidth:
      DISPLAYOBJECT->MinWidth=data->value * OBJECT->Project->trp_PropFont->tf_XSize;
      return 1;

    case TRAT_Flags:
      DISPLAYOBJECT->Flags|=data->value;
      return 1;

    default:
      return TRDP_DisplayObject_SETATTRIBUTE(object,messageid,data,metaclass->trc_SuperClass);
    }
}


TR_SIMPLEMETHOD(Text,DISPOSE)
{
  if(DISPLAYOBJECT->PrivData)
    TR_FreePooled(OBJECT->Project->trp_MemPool,(APTR)(DISPLAYOBJECT->PrivData),TEXT->TextLength);
  return 1L;
}
