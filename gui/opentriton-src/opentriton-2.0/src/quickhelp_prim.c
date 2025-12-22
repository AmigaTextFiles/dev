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
 *  quickhelp_prim.c - QuickHelp primitives
 *
 */


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define INTUI_V36_NAMES_ONLY
#define TR_NOSUPPORT
#define TR_THIS_IS_TRITON

#include "include/libraries/triton.h"
#include "include/clib/triton_protos.h"
#include "/internal.h"

#include "parts/define_classes.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////// QuickHelp //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define TR_TICKS_UNTIL_QUICKHELP 2
#define TR_QUICKHELP_TEXTFLAGS (TRTX_NOUNDERSCORE|TRTX_MULTILINE)
//define TR_QUICKHELP_TEXTFLAGS (TRTX_NOUNDERSCORE|TRTX_HIGHLIGHT|TRTX_MULTILINE)


VOID TR_UpdateQuickHelp(struct TR_Project *project, ULONG x, ULONG y, BOOL removeNow)
{
  LONG top;
  ULONG textwidth;

  struct TagItem winTags[]=
  {
    /*  0 */  WA_Flags,         WFLG_BORDERLESS|WFLG_RMBTRAP|WFLG_SMART_REFRESH,
    /*  1 */  WA_IDCMP,         NULL,
    /*  2 */  NULL,             NULL, /* Screen */
    /*  3 */  WA_Width,         NULL,
    /*  4 */  WA_Height,        NULL,
    /*  5 */  WA_Left,          NULL,
    /*  6 */  WA_Top,           NULL,
              TAG_END
  };

  if(project->trp_TicksPassed==TR_TICKS_UNTIL_QUICKHELP)
    {
      if((!project->trp_QuickHelpWindow)
	 && (project->trp_QuickHelpObject=TR_ObjectFromPlace(project,x,y))
	 && (project->trp_QuickHelpObject->QuickHelpString))
	{
	  winTags[2].ti_Tag=project->trp_ScreenType;
	  winTags[2].ti_Data=(ULONG)(project->trp_Screen);
	  textwidth=TR_TextWidth(project,project->trp_QuickHelpObject->QuickHelpString,
				 TR_QUICKHELP_TEXTFLAGS);
	  winTags[3].ti_Data=textwidth+project->trp_TotalPropFontHeight*2;
	  winTags[4].ti_Data=
	    TR_TextHeight(project,project->trp_QuickHelpObject->QuickHelpString,TR_QUICKHELP_TEXTFLAGS)
	    + project->trp_TotalPropFontHeight;
	  winTags[5].ti_Data=project->trp_QuickHelpObject->Left
	    + project->trp_TotalPropFontHeight
	    + project->trp_Window->LeftEdge;
	  top=project->trp_QuickHelpObject->Top-winTags[4].ti_Data
	    - project->trp_TotalPropFontHeight
	    + project->trp_Window->TopEdge;
	  if(top>0)
	    winTags[6].ti_Data=top;
	  else
	    winTags[6].ti_Data=project->trp_QuickHelpObject->Top
	      + project->trp_QuickHelpObject->Height
	      + project->trp_TotalPropFontHeight
	      + project->trp_Window->TopEdge;
	  if(!(project->trp_QuickHelpWindow=OpenWindowTagList(NULL,winTags))) DisplayBeep(NULL);
	  else
	    {
//	      SetAPen(project->trp_QuickHelpWindow->RPort,project->trp_DrawInfo->dri_Pens[FILLPEN]);
//	      RectFill(project->trp_QuickHelpWindow->RPort, 0, 0,
//		       project->trp_QuickHelpWindow->Width, project->trp_QuickHelpWindow->Height);
              SetAPen(project->trp_QuickHelpWindow->RPort,project->trp_DrawInfo->dri_Pens[SHADOWPEN]);
	      Move(project->trp_QuickHelpWindow->RPort,0,project->trp_QuickHelpWindow->Height-1);
	      Draw(project->trp_QuickHelpWindow->RPort,project->trp_QuickHelpWindow->Width-1,
		   project->trp_QuickHelpWindow->Height-1);
	      Draw(project->trp_QuickHelpWindow->RPort,project->trp_QuickHelpWindow->Width-1,0);
	      SetAPen(project->trp_QuickHelpWindow->RPort,project->trp_DrawInfo->dri_Pens[SHINEPEN]);
	      Draw(project->trp_QuickHelpWindow->RPort,0,0);
	      Draw(project->trp_QuickHelpWindow->RPort,0,project->trp_QuickHelpWindow->Height-1);
	      TR_PrintText(project, project->trp_QuickHelpWindow->RPort,
			   project->trp_QuickHelpObject->QuickHelpString,
			   project->trp_TotalPropFontHeight,
			   project->trp_TotalPropFontHeight/2, // +project->trp_PropFont->tf_Baseline,
			   textwidth,
			   TR_QUICKHELP_TEXTFLAGS);
	    }
	}
    }
  else if(project->trp_QuickHelpWindow)
    {
      if((TR_ObjectFromPlace(project,x,y)!=project->trp_QuickHelpObject) || removeNow)
	{
	  CloseWindow(project->trp_QuickHelpWindow);
	  project->trp_QuickHelpWindow=NULL;
	  project->trp_QuickHelpObject=NULL;
	  project->trp_TicksPassed=0;
	}
    }
}
