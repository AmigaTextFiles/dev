#include <clib/extras/gui_protos.h>
#include <intuition/screens.h>

/****** extras.lib/OBSOLETE_CheckWindowSize ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       CheckWindowSize - See if a window will fit on a screen.
*
*   SYNOPSIS
*       windowfits = CheckWindowSize(Scr, Width, Height,
*                                     XScale, YScale)
*
*       BOOL CheckWindowSize(struct Screen *, WORD, WORD, 
*                                    float, float);
*
*   FUNCTION
*       This function checks to see if a window will fit on a screen.
*
*   INPUTS
*       Scr - the Screen the window is destine for.
*       Width - the base width of the window.
*       Height - the base height of the window.
*       XScale - the proposed x scale of the window.
*       YScale - the proposed y scale of the window.
*
*   RESULT
*       Returns TRUE if the window will fit, and FALSE if not.
*       if the XScale or YScale is <=0 it will also fail.
*
*   SEE ALSO
*       GetGUIScale(), CheckInnerWindowSize()
*
******************************************************************************
*
*/


BOOL CheckWindowSize(struct Screen *Scr,
                     WORD Width,
                     WORD Height,
                     float XScale,
                     float YScale)
{
  if(XScale>0 && YScale>0)
    if(Width*XScale<=Scr->Width || Height*YScale<=Scr->Height)
      return(TRUE);
  return(FALSE);
}

