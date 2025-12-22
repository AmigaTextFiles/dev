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
 *  text_prim.c - Text Primitives
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
////////////////////////////////////////////////////////////////////////////////////////// Text Primitives //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

ULONG __regargs TR_SimplifyTextFlags(struct TR_Project *project, ULONG flags)
{
  if(flags&TRTX_TITLE)
    {
      flags&=(~TRTX_TITLE);
      switch(((struct TR_AppPrefs *)(project->trp_App->tra_Prefs))->frames_title)
	{
	case 1: /* Highlight */
	  flags|=TRTX_HIGHLIGHT;
	  break;
	case 2: /* Shadow */
	  flags|=TRTX_3D;
	}
    }
  return flags;
}


/****** triton.library/TR_TextWidth ******
*
*   NAME	
*	TR_TextWidth -- Returns text width. (V6)
*
*   SYNOPSIS
*	Width = TR_TextWidth(Project, Text, Flags)
*	                     A0       A2    D0
*
*	ULONG TR_TextWidth(struct TR_Project *, STRPTR, ULONG);
*
*   FUNCTION
*	Returns the width of a text string with the specified
*	TRTX_* flags in the given project.
*
*   RESULT
*	Width - The width of the text in pixels
*
*   SEE ALSO
*	TR_TextHeight(), TR_PrintText()
*
******/

ULONG __saveds __asm TR_TextWidth(register __a0 struct TR_Project *project,
				  register __a2 STRPTR text,
				  register __d0 ULONG flags)
{
  struct IntuiText itext;
  ULONG width,linewidth,start,stop;
  UBYTE underscore[2],sep;

  if(!text) return 0;

  flags=TR_SimplifyTextFlags(project,flags);
  itext.ITextFont=project->trp_PropAttr;

  if(flags&TRTX_MULTILINE)
    {
      width=0;
      for(start=0,stop=0;;stop++)
	{
	  if(text[stop]=='\n' || text[stop]=='\r' || text[stop]=='\t' || text[stop]==0)
	    {
	      if(text[start]=='%') start+=2;
	      itext.IText=&(text[start]);
	      sep=text[stop];
	      text[stop]=0;
	      linewidth=(ULONG)IntuiTextLength(&itext);
	      width=max(width,linewidth);
	      text[stop]=sep;
	      start=stop+1;
	    }
	  if(!(text[stop])) break;
	}
    }
  else
    {
      itext.IText=text;
      width=(ULONG)IntuiTextLength(&itext);

      if((!(flags&TRTX_NOUNDERSCORE))&&(TR_FirstOccurance(project->trp_Underscore,text)!=-1))
	{
	  underscore[0]=project->trp_Underscore;
	  underscore[1]=0;
	  itext.IText=underscore;
	  width-=(ULONG)IntuiTextLength(&itext);
	}

      if(flags&(TRTX_3D|TRTX_BOLD)) width++;
    }

  return width;
}


/****** triton.library/TR_TextHeight ******
*
*   NAME	
*	TR_TextWidth -- Returns text height. (V6)
*
*   SYNOPSIS
*	Height = TR_TextHeight(Project, Text, Flags)
*	                       A0       A2    D0
*
*	ULONG TR_TextHeight(struct TR_Project *, STRPTR, ULONG);
*
*   FUNCTION
*	Returns the height of a text string with the specified
*	TRTX_* flags in the given project.
*
*   RESULT
*	Height - The height of the text in pixels
*
*   SEE ALSO
*	TR_TextWidth(), TR_PrintText()
*
******/

ULONG __saveds __asm TR_TextHeight(register __a0 struct TR_Project *project,
				   register __a2 STRPTR text,
				   register __d0 ULONG flags)
{
  ULONG height;

  if(flags&TRTX_MULTILINE)
    {
      height=project->trp_TotalPropFontHeight
	+TR_NumOccurances('\n',text) /* Small space */
	*(project->trp_TotalPropFontHeight+((project->trp_PropFont->tf_YSize)/4))
	+TR_NumOccurances('\r',text) /* Normal space */
	*(project->trp_TotalPropFontHeight+((project->trp_PropFont->tf_YSize)/2))
	+TR_NumOccurances('\t',text) /* Normal space + separator + normal space */
	*(project->trp_TotalPropFontHeight
	  +((project->trp_PropFont->tf_YSize)/2)
	  +2
	  +((project->trp_PropFont->tf_YSize)/2));
    }
  else
    {
      flags=TR_SimplifyTextFlags(project,flags);
      height=project->trp_TotalPropFontHeight;
      if(flags&TRTX_3D) height++;
    }

  return height;
}


VOID __regargs TR_PrintSimpleText(struct TR_Project *project, struct RastPort *rp,
				  STRPTR text, ULONG textlength,
				  ULONG x, ULONG y, ULONG color,
				  ULONG uscorecolor, LONG underscore_pos)
{
  WORD underx1,underx2;

  Move(rp,x,y+project->trp_PropFont->tf_Baseline);
  SetAPen(rp,color);

  if(underscore_pos==-1)
  {
    Text(rp,text,textlength);
  }
  else
  {
    Text(rp,text,underscore_pos);
    underx1=rp->cp_x;
    Text(rp,text+underscore_pos+1,1);
    underx2=rp->cp_x-1;
    Text(rp,text+underscore_pos+2,textlength-underscore_pos-2);
    SetAPen(rp,uscorecolor);
    Move(rp,underx1,y+project->trp_PropFont->tf_Baseline+2);
    Draw(rp,underx2,y+project->trp_PropFont->tf_Baseline+2);
  }
}


/****** triton.library/TR_PrintText ******
*
*   NAME	
*	TR_PrintText -- Prints a line of text. (V6)
*
*   SYNOPSIS
*	TR_PrintText(Project, RastPort, Text, X, Y, Width, Flags)
*	             A0       A1        A2    D1 D2 D3     D0
*
*	VOID TR_PrintText(struct TR_Project *,
*	                  struct RastPort *, STRPTR,
*	                  ULONG, ULONG, ULONG, ULONG);
*
*   FUNCTION
*	Prints a text into the specified RastPort (or into
*	the project's default RastPort if the supplied RastPort
*	is NULL.
*
*	If you specify TRTX_MULTILINE some formatting sequences
*	may appear in the text:
*	- A <newline> (\n) will start a new line with a small
*	  space above it.
*	- A <return> (\r) will add a normal space instead.
*	- A <tab> (\t) will add a normal space, then a 3D separator
*	  line and again a normal space.
*
*	The following sequences are allowed at the beginning of
*	a line only:
*	- '%b' switches to boldface,
*	- '%3' and '%s' (V2+) to 3D text,
*	- '%h' to highlight
*	- and '%n' to normal style.
*	- '%%' inserts a '%' character.
*
*   SEE ALSO
*	TR_TextWidth()
*
******/

VOID __asm TR_InternalPrintText(register __a0 struct TR_Project *project,
				register __a1 struct RastPort *rp,
				register __a2 STRPTR text,
				register __d1 ULONG x, register __d2 ULONG y,
				register __d3 width, register __d0 ULONG flags)
{
  ULONG textlength=TR_FirstOccurance(0,text);
  LONG underscore_pos=-1;
  ULONG color,uscorecolor,start,stop,ynow;
  UBYTE sep;

  if(!rp) rp=project->trp_Window->RPort;

  flags=TR_SimplifyTextFlags(project,flags);

  if(!width) width=TR_TextWidth(project,text,flags);

  if(flags&TRTX_MULTILINE)
    {
      for(start=0,stop=0,ynow=y;;stop++)
	{
	  if(text[stop]=='\n' || text[stop]=='\r' || text[stop]=='\t' || text[stop]==0)
	    {
	      if(text[start]=='%')
		{
		  flags&=~(TRTX_3D|TRTX_BOLD|TRTX_HIGHLIGHT);
		  switch(text[start+1])
		    {
		    case '3':
		    case 's':
		      flags|=TRTX_3D;
		      break;
		    case 'b':
		      flags|=TRTX_BOLD;
		      break;
		    case 'h':
		      flags|=TRTX_HIGHLIGHT;
		      break;
		    case '%':
		      start--;
		    }
		  start+=2;
		}
	      sep=text[stop];
	      text[stop]=0;
	      TR_InternalPrintText(project,rp,&(text[start]),x,ynow,width,flags&(~TRTX_MULTILINE));
	      text[stop]=sep;
	      start=stop+1;
	      ynow+=project->trp_TotalPropFontHeight;
	      switch(sep)
		{
		case '\n':
		  ynow+=(project->trp_PropFont->tf_YSize)/4;
		  break;
		case '\r':
		  ynow+=(project->trp_PropFont->tf_YSize)/2;
		  break;
		case '\t':
		  ynow+=((project->trp_PropFont->tf_YSize)/2);

		  SetAPen(rp,project->trp_DrawInfo->dri_Pens[SHADOWPEN]);
		  Move(rp,x,ynow);
		  Draw(rp,x+width-1,ynow);
		  SetAPen(rp,project->trp_DrawInfo->dri_Pens[SHINEPEN]);
		  Move(rp,x,ynow+1);
		  Draw(rp,x+width-1,ynow+1);

		  Draw(rp,x+width-1,ynow);
		  SetAPen(rp,project->trp_DrawInfo->dri_Pens[SHADOWPEN]);
		  Move(rp,x,ynow);
		  Draw(rp,x,ynow+1);

		  ynow+=2+((project->trp_PropFont->tf_YSize)/2);
		}
	    }
	  if(!(text[stop])) break;
	}
    }
  else /* not TRTX_MULTILINE */
    {
      SetFont(rp,project->trp_PropFont);
      SetDrMd(rp,JAM1);

      if(flags&TRTX_BOLD) SetSoftStyle(rp,FSF_BOLD,FSF_BOLD);

      if(!(flags&TRTX_NOUNDERSCORE)) underscore_pos=TR_FirstOccurance(project->trp_Underscore,text);

      if(flags&TRTX_RIGHTALIGN) x=x+width-TR_TextWidth(project,text,flags);
      else if(flags&TRTX_CENTER) x=x+((width-TR_TextWidth(project,text,flags))/2);

      if(flags&TRTX_3D)
	{
	  TR_PrintSimpleText(project, rp, text, textlength, x+1, y+1,
			     TR_GetPen(project,TRPT_SYSTEMPEN,SHADOWPEN),
			     TR_GetPen(project,TRPT_SYSTEMPEN,SHADOWPEN), underscore_pos);
	  TR_PrintSimpleText(project, rp, text, textlength, x, y,
			     TR_GetPen(project,TRPT_SYSTEMPEN,HIGHLIGHTTEXTPEN),
			     TR_GetPen(project,TRPT_SYSTEMPEN,HIGHLIGHTTEXTPEN), underscore_pos);
	}
      else
	{
	  if(flags&TRTX_HIGHLIGHT)
	    {
	      color=TR_GetPen(project,TRPT_SYSTEMPEN,HIGHLIGHTTEXTPEN);
	      uscorecolor=TR_GetPen(project,TRPT_TRITONPEN,TRTP_HIGHUSCORE);
	    }
	  else if(flags&TRTX_SELECTED)
	    {
	      color=TR_GetPen(project,TRPT_SYSTEMPEN,FILLTEXTPEN);
	      uscorecolor=color;
	    }
	  else
	    {
	      color=TR_GetPen(project,TRPT_SYSTEMPEN,TEXTPEN);
	      uscorecolor=TR_GetPen(project,TRPT_TRITONPEN,TRTP_NORMUSCORE);
	    }
	  TR_PrintSimpleText(project, rp, text, textlength, x, y, color, uscorecolor, underscore_pos);
	}
    }
}


VOID __saveds __asm TR_PrintText(register __a0 struct TR_Project *project,
				 register __a1 struct RastPort *rp,
				 register __a2 STRPTR text,
				 register __d1 ULONG x, register __d2 ULONG y,
				 register __d3 ULONG width, register __d0 ULONG flags)
{
  TR_InternalPrintText(project,rp,text,x,y,width,flags);
}
