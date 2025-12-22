#define __USE_SYSBASE
#include <extras/math.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/commodities.h>
#include <proto/gadtools.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/diskfont.h>
#include <intuition/intuitionbase.h>
#include <intuition/gadgetclass.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <extras/gui.h>
#include <extras/ext_text.h>
#include <clib/extras_protos.h>

float GetGUIStringScale(struct TextAttr *TA, struct GUI_String *Strings);

/****** extras.lib/OBSOLETE_GetGUIScale ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       GetGUIScale -- Find the appropriate scale for an
*                      interface.
*
*   SYNOPSIS
*       success = GetGUIScale(TAttr, Strings, &XScale, &YScale)
*
*       BOOL GetGUIScale(struct TextAttr *, struct GUI_String *,
*                        float *, float *);
*
*   FUNCTION
*       This function figures out the minimum size an interface
*       should be so that all of the Strings will fit.
*
*   INPUTS
*       TAttr - The TextAttr to be used for the strings.
*       Strings - A NULL terminated array of GUI_String containing
*                 the Strings to used in the interface and the maximum
*                 size each string can be before the interface needs
*                 to be enlarged.
*       XScale - the address of a float to contain the X scale factor.
*       YScale - the address of a float to contain the Y scale factor. 
*
*   RESULT
*       This function returns non-zero on success, and will have the X &
*       YScale values set apropriately.  Returns NULL on failure if the
*       font specified in TAttr can not be opened, and X & YScale will be
*       set to -1.
*
*   NOTES
*       requires diskfont.library to be open.
*
*       The reason this function sets X & YScale to -1 on failure is to
*       also cause CheckWindowSize() and CheckInnerWindowSize to fail.
*       This way you can simply:
*       GetGUIScale(ta,strings,&xscale,&yscale)
*       if(!CheckWindwoWidth(scr,winwidth,winheight,xscale,yscale))
*       { ... revert to topaz.8 ... 
*       }
*
*       The GUI_String specifies the maximum size a string can be before
*       the interface should be scaled horizontally.  For example, if you
*       have a BUTTON_KIND gadget that is 100 pixels wide, then you may
*       want to set the maximum size for the string in that gadget to 90.  
*       (ie.
*            struct GUI_String gs[]=
*            {
*              "Button Text", 90,
*              0,0
*            };
*       )
*
*   SEE ALSO
*       MakeGadgets()
*
******************************************************************************
*
*/

BOOL GetGUIScale(struct TextAttr *TA,
                 struct GUI_String *Strings,
                 float *XScale,
                 float *YScale)
{
  float xscale;
  *XScale=*YScale=-1;
  
  xscale=GetGUIStringScale(TA,Strings);  
  if(xscale>0)
  {
    *XScale=xscale;
    *YScale=(float)TA->ta_YSize/8.0;
    *YScale=max(1.0,*YScale);
    return(TRUE);
  }
  return(FALSE);
}



float GetGUIStringScale(struct TextAttr *TA, struct GUI_String *Strings)
{
  struct TextFont *tf;
  ULONG l=0;
  LONG newsize;  
  float increase,maxincrease=1;
  
  if(tf=OpenDiskFont(TA))
  {
    while(Strings[l].String)
    {
      newsize=gui_StrLength(SL_TextFont    ,tf,
                         SL_String      ,Strings[l].String,
                         SL_IgnoreChars ,"_",
                         TAG_DONE);
      increase=(float)newsize/(float)Strings[l].NormalSize;
      maxincrease=max(increase,maxincrease);
      l++;
    }
    CloseFont(tf);
    return(maxincrease);
  }
  return(-1.0);
}
