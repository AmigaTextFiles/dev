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
 *  frame_prim.c - Frame Primitives
 *
 */


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////// Include our stuff //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define INTUI_V36_NAMES_ONLY
#define TR_NOSUPPORT
#define TR_THIS_IS_TRITON
#define TR_EXTERNAL_ONLY

#include "include/libraries/triton.h"
#include "include/clib/triton_protos.h"
#include "prefs/Triton.h"
#include "/internal.h"

#include "parts/define_classes.h"


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////// Frame Primitives //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL __regargs TR_ThickBorders(struct TR_Project *project)
{
  return ((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->frames_width;
}


/****** triton.library/TR_FrameBorderHeight ******
*
*   NAME	
*	TR_FrameBorderHeight -- Returns frame border height. (V6)
*
*   SYNOPSIS
*	Height = TR_FrameBorderHeight(Project, Type)
*	                              A0       D0
*
*	ULONG TR_FrameBorderHeight(struct TR_Project *, UWORD);
*
*   FUNCTION
*	Returns the thickness of the top/bottom borders of the
*	specified frame type (TRFT_#?) in a specific project
*	taking into account the user's preferences settings.
*
*   RESULT
*	Height - The height of the borders in pixels
*
*   SEE ALSO
*	TR_FrameBorderWidth(), TR_DrawFrame()
*
******/

ULONG __saveds __asm TR_FrameBorderHeight(register __a0 struct TR_Project *project, register __d0 UWORD type)
{
  if(type>=TRFT_ABSTRACT_BUTTON)
    {
      type=((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->frames_type[type-TRFT_ABSTRACT_BUTTON];
      if(type>3) type+=29;
    }

  if(type>=TRFT_XENBUTTON1) return 2; else return (ULONG)type; /* Neat shortcut ;) */
}


/****** triton.library/TR_FrameBorderWidth ******
*
*   NAME	
*	TR_FrameBorderWidth -- Returns frame border width. (V6)
*
*   SYNOPSIS
*	Width = TR_FrameBorderWidth(Project, Type)
*	                            A0       D0
*
*	ULONG TR_FrameBorderWidth(struct TR_Project *, UWORD);
*
*   FUNCTION
*	Returns the thickness of the left/right borders of the
*	specified frame type (TRFT_#?) in a specific project
*	taking into account the user's preferences settings.
*
*   RESULT
*	Width - The width of the borders in pixels
*
*   SEE ALSO
*	TR_FrameBorderHeight(), TR_DrawFrame()
*
******/

ULONG __saveds __asm TR_FrameBorderWidth(register __a0 struct TR_Project *project, register __d0 UWORD type)
{
  ULONG width=TR_FrameBorderHeight(project,type);
  if(TR_ThickBorders(project)) width=width<<1;
  return width;
}


/****** triton.library/TR_DrawFrame ******
*
*   NAME	
*	TR_DrawFrame -- Draws a frame/BevelBox. (V6)
*
*   SYNOPSIS
*	TR_DrawFrame(Project, RastPort, Left, Top, Width,
*	             A0       A1        D1    D2   D3
*	             Height, Type, Inverted)
*	             D4      D0    D5
*
*	VOID TR_DrawFrame(struct TR_Project *,
*	                  struct RastPort *, UWORD, UWORD,
*	                  UWORD, UWORD, UWORD, BOOL);
*
*   FUNCTION
*	Draws a frame into the specified RastPort (or into
*	the project's default RastPort if the supplied RastPort
*	is NULL. Set Inverted to TRUE for a recessed (basic) or
*	inverted (abstract) frame.
*
*   SEE ALSO
*	TR_FrameBorderWidth(), TR_FrameBorderHeight()
*
******/

VOID __asm TR_InternalDrawFrame(register __a0 struct TR_Project *project,
				register __a1 struct RastPort *rp, register __d1 UWORD left,
				register __d2 UWORD top, register __d3 UWORD width,
				register __d4 UWORD height, register __d0 UWORD type,
				register __d5 BOOL inverted)
{
  UWORD shinecolor,shadowcolor,backgroundcolor,realshinecolor,realshadowcolor,hshinecolor,hshadowcolor;
  BOOL raised=TRUE;
  struct TagItem dbbtags[]=
  {
    GT_VisualInfo,0,
    0,TRUE,
    GTBB_FrameType,BBFT_BUTTON,
    TAG_END
  };

  if(!rp) rp=project->trp_Window->RPort;

  if(type>=TRFT_ABSTRACT_BUTTON)
    {
      raised=((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->frames_raised[type-TRFT_ABSTRACT_BUTTON];
      type=((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->frames_type[type-TRFT_ABSTRACT_BUTTON];
      if(type>3) type+=29;
    }
  if(inverted) raised=raised?FALSE:TRUE;

  backgroundcolor = TR_GetPen(project,TRPT_SYSTEMPEN,BACKGROUNDPEN);
  realshinecolor  = TR_GetPen(project,TRPT_SYSTEMPEN,SHINEPEN);
  realshadowcolor = TR_GetPen(project,TRPT_SYSTEMPEN,SHADOWPEN);
  hshinecolor     = TR_GetPen(project,TRPT_TRITONPEN,TRTP_HALFSHINE);
  hshadowcolor    = TR_GetPen(project,TRPT_TRITONPEN,TRTP_HALFSHADOW);

  if(raised)
  {
    shinecolor=realshinecolor;
    shadowcolor=realshadowcolor;
  }
  else
  {
    shinecolor=realshadowcolor;
    shadowcolor=realshinecolor;
  }

  SetAfPt(rp,NULL,-1);
  SetDrMd(rp,JAM1);

  if(TR_ThickBorders(project))
  {
    if((type==TRFT_XENBUTTON1)||(type==TRFT_XENBUTTON2))
    {
      if(raised) SetAPen(rp,inverted?hshadowcolor:realshinecolor); else SetAPen(rp,hshadowcolor);
      Move(rp,left+width-4,top+1);
      Draw(rp,left+2,top+1);
      Draw(rp,left+2,top+height-2);
      Move(rp,left+3,top+1);
      Draw(rp,left+3,top+height-2);
      if(raised) SetAPen(rp,inverted?realshinecolor:hshadowcolor); else SetAPen(rp,realshinecolor);
      Draw(rp,left+width-4,top+height-2);
      Draw(rp,left+width-4,top+2);
      Move(rp,left+width-3,top+height-2);
      Draw(rp,left+width-3,top+1);
      SetAPen(rp,realshadowcolor);
      if(type==TRFT_XENBUTTON1)
      {
        Move(rp,left+width-1,top);
        Draw(rp,left+width-1,top+height-1);
        Move(rp,left+width-2,top);
        Draw(rp,left+width-2,top+height-1);
        Draw(rp,left+1,top+height-1);
        Draw(rp,left+1,top);
        Move(rp,left,top+height-1);
        Draw(rp,left,top);
        Draw(rp,left+width-1,top);
      }
      else
      {
        Move(rp,left+1,top);
        Draw(rp,left+width-2,top);
        Move(rp,left+1,top+height-1);
        Draw(rp,left+width-2,top+height-1);
        Move(rp,left,top+1);
        Draw(rp,left,top+height-2);
        Move(rp,left+1,top+1);
        Draw(rp,left+1,top+height-2);
        Move(rp,left+width-1,top+1);
        Draw(rp,left+width-1,top+height-2);
        Move(rp,left+width-2,top+1);
        Draw(rp,left+width-2,top+height-2);
      }
    }
    else
    {
      if(type==TRFT_NEXTBUTTON)
      {
        SetAPen(rp,raised?hshinecolor:hshadowcolor);
        Move(rp,left+width-4,top+1);
        Draw(rp,left+2,top+1);
        Draw(rp,left+2,top+height-2);
        Move(rp,left+3,top+1);
        Draw(rp,left+3,top+height-2);
        SetAPen(rp,raised?hshadowcolor:hshinecolor);
        Draw(rp,left+width-4,top+height-2);
        Draw(rp,left+width-4,top+2);
        Move(rp,left+width-3,top+height-2);
        Draw(rp,left+width-3,top+1);
        type=TRFT_BUTTON;
      }
      dbbtags[0].ti_Data=(ULONG)project->trp_VisualInfo;
      dbbtags[1].ti_Tag=raised?TAG_IGNORE:GTBB_Recessed;
      #ifdef TR_OS39
        dbbtags[2].ti_Data=type;
        DrawBevelBoxA(rp,left,top,width,height,dbbtags);
      #else
        if(TR_Global.trg_OSVersion>=39)
        {
	  dbbtags[2].ti_Data=type;
          DrawBevelBoxA(rp,left,top,width,height,dbbtags);
        }
        else
        {
          DrawBevelBoxA(rp,left,top,width,height,dbbtags);
          if(type==TRFT_ICONDROPBOX) DrawBevelBoxA(rp,left+4,top+2,width-8,height-4,dbbtags);
          else if(type==TRFT_RIDGE) DrawBevelBoxA(rp,left+2,top+1,width-4,height-2,dbbtags);
        }
      #endif

      if(type==TRFT_ICONDROPBOX)
      {
        SetAPen(rp,backgroundcolor);
        Move(rp,left+width-4,top+1);
        Draw(rp,left+width-4,top+height-2);
        Draw(rp,left+3,top+height-2);
        Draw(rp,left+3,top+1);
        Draw(rp,left+width-4,top+1);
        Move(rp,left+width-3,top+1);
        Draw(rp,left+width-3,top+height-2);
        Move(rp,left+2,top+1);
        Draw(rp,left+2,top+height-2);
      }
    }
  }
  else
  {
    if((type==TRFT_XENBUTTON1)||(type==TRFT_XENBUTTON2))
    {
      if(raised) SetAPen(rp,inverted?realshinecolor:hshadowcolor); else SetAPen(rp,realshinecolor);
      Move(rp,left+width-2,top+1);
      Draw(rp,left+width-2,top+height-2);
      Draw(rp,left+1,top+height-2);
      if(raised) SetAPen(rp,inverted?hshadowcolor:realshinecolor); else SetAPen(rp,hshadowcolor);
      Draw(rp,left+1,top+1);
      Draw(rp,left+width-2,top+1);
      SetAPen(rp,realshadowcolor);
      if(type==TRFT_XENBUTTON1)
      {
        Move(rp,left+width-1,top);
        Draw(rp,left+width-1,top+height-1);
        Draw(rp,left,top+height-1);
        Draw(rp,left,top);
        Draw(rp,left+width-1,top);
      }
      else
      {
        Move(rp,left+1,top);
        Draw(rp,left+width-2,top);
        Move(rp,left+1,top+height-1);
        Draw(rp,left+width-2,top+height-1);
        Move(rp,left,top+1);
        Draw(rp,left,top+height-2);
        Move(rp,left+width-1,top+1);
        Draw(rp,left+width-1,top+height-2);
      }
    }
    else
    {
      SetAPen(rp,shadowcolor);
      Move(rp,left+width-1,top);
      Draw(rp,left+width-1,top+height-1);
      Draw(rp,left,top+height-1);
      SetAPen(rp,shinecolor);
      Draw(rp,left,top);
      Draw(rp,left+width-1,top);
  
      if(type==TRFT_ICONDROPBOX)
      {
        Move(rp,left+width-3,top+2);
        Draw(rp,left+width-3,top+height-3);
        Draw(rp,left+2,top+height-3);
        SetAPen(rp,shadowcolor);
        Draw(rp,left+2,top+2);
        Draw(rp,left+width-3,top+2);
  
        SetAPen(rp,backgroundcolor);
        Move(rp,left+width-2,top+1);
        Draw(rp,left+width-2,top+height-2);
        Draw(rp,left+1,top+height-2);
        Draw(rp,left+1,top+1);
        Draw(rp,left+width-2,top+1);
      }
      else if(type==TRFT_RIDGE)
      {
        Move(rp,left+width-2,top+1);
        Draw(rp,left+width-2,top+height-2);
        Draw(rp,left+1,top+height-2);
        SetAPen(rp,shadowcolor);
        Draw(rp,left+1,top+1);
        Draw(rp,left+width-2,top+1);
      }
      else if(type==TRFT_NEXTBUTTON)
      {
        SetAPen(rp,raised?hshadowcolor:hshinecolor);
        Move(rp,left+width-2,top+1);
        Draw(rp,left+width-2,top+height-2);
        Draw(rp,left+1,top+height-2);
        SetAPen(rp,raised?hshinecolor:hshadowcolor);
        Draw(rp,left+1,top+1);
        Draw(rp,left+width-2,top+1);
      }
    }
  }
}

VOID __saveds __asm TR_DrawFrame(register __a0 struct TR_Project *project,
				 register __a1 struct RastPort *rp, register __d1 UWORD left,
				 register __d2 UWORD top, register __d3 UWORD width,
				 register __d4 UWORD height, register __d0 UWORD type,
				 register __d5 BOOL inverted)
{
  TR_InternalDrawFrame(project,rp,left,top,width,height,type,inverted);
}
