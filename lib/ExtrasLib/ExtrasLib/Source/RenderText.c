#include <extras/math.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <extras/ext_text.h>
#include <clib/extras_protos.h>
#include <string.h>

/****** extras.lib/gui_RenderText ******************************************
*
*   NAME
*       gui_RenderTextA -- Write text into a RastPort.
*       gui_RenderText -- varargs stub.
*
*   SYNOPSIS
*       reserved = gui_RenderTextA( RP, String, TagList)
*
*       LONG gui_RenderTextA( struct RastPort *, STRPTR, 
*                         struct TagItem *);
*
*       reserved = gui_RenderText( RP, String, Tags, ... )
*
*       LONG gui_RenderText( struct RastPort *, STRPTR, 
*                        Tag, ...);
*
*   FUNCTION
*       Writes text into a Rastport, basically an interface
*       to the graphics.library/Text() function.
*
*   INPUTS
*       RP - rastport to write to.
*       String - the string to write.
*       TagList - an array of TagItems.
*         RT_Baseline - baseline of the cursor. 
*                       default RastPort->cp_y
*         RT_XPos     - horizontal position of the cursor.
*                       default RastPort->cp_x
*         RT_MaxWidth - maximum pixel length of text, excess
*                       characters will be clipped.
*         RT_Justification - RTJ_???  (default _LEFT)
*         RT_TextFont - struct TextFont * from OpenFont()
*         RT_Strlen   - number of characters in string.
*         RT_TextLength - (ULONG *) Width in pixels of printed texted.
*
*
*   RESULT
*       Number of characters drawn.
*
*   BUGS
*       RenderText does not reset a RastPort's TextFont
*       after using RT_TextFont. 
*
*   SEE ALSO
*       mlr_rendertext.image image class.
*
******************************************************************************
*
*/


LONG gui_RenderText(struct RastPort *RP, STRPTR String, Tag Tags, ... )
{
  return(gui_RenderTextA(RP,String,(struct TagItem *)&Tags));
}

LONG gui_RenderTextA(struct RastPort *RP, STRPTR String, struct TagItem *TagList)
{
  struct TextFont *rt_textfont;
  LONG    rt_xpos, rt_baseline, rt_maxwidth, rt_justification,
          rt_strlen=0, *rt_textlength;
  struct TextExtent extent;
  LONG   len;
  
  if(RP && String)
  {
    rt_xpos         =GetTagData(RT_XPos    , RP->cp_x     , TagList);
    rt_baseline     =GetTagData(RT_Baseline, RP->cp_y     , TagList);
    rt_maxwidth     =GetTagData(RT_MaxWidth, -1           , TagList);
    rt_justification=GetTagData(RT_Justification, RTJ_LEFT, TagList);
    rt_strlen       =GetTagData(RT_Strlen, strlen(String) , TagList);
    if(rt_textfont =(struct TextFont *)GetTagData(RT_TextFont, 0, TagList))
      SetFont(RP,rt_textfont);

    if(rt_maxwidth>=0)
    {
      rt_strlen=TextFit(RP,String,rt_strlen,&extent,NULL,1,
                      rt_maxwidth,32767);
    }
    len=TextLength(RP,String,rt_strlen);
    if(rt_textlength=(ULONG *)GetTagData(RT_TextLength, 0 , TagList))
    {
      *rt_textlength=len;
    }
    switch(rt_justification)
    {
      //case RTJ_LEFT:
      //  break;
      case RTJ_CENTER:
        rt_xpos=rt_xpos-(len/2);
        break;
      case RTJ_RIGHT:
        rt_xpos-=len;
        break;
    }
    Move(RP,rt_xpos,rt_baseline);
    Text(RP,String,rt_strlen);
  }
  return(rt_strlen);
}
