#include <clib/extras/gui_protos.h>
#include <intuition/screens.h>

/****** extras.lib/OBSOLETE_CheckInnerWindowSize ******************************************
*
*   OBSOLETE
*       Since OS3.5 uses Reaction/ClassAct - this code is obsolete
*
*   NAME
*       CheckInnerWindowSize - See if a window will fit on a screen.
*
*   SYNOPSIS
*       windowfits = CheckInnerWindowSize(Scr, Width, Height,
*                                     XScale, YScale)
*
*       BOOL CheckInnerWindoeSize(struct Screen *, WORD, WORD, 
*                                    float, float);
*
*   FUNCTION
*       This function checks to see if a window with the specified
*       inner dimensions will fit on a screen.
*
*   INPUTS
*       Scr - the Screen the window is destine for.
*       Width -  the base inner width of the window.
*       Height - the base inner height of the window.
*       XScale - the proposed x scale of the window.
*       YScale - the proposed y scale of the window.
*
*   RESULT
*       Returns TRUE if the window will fit, and FALSE if not.
*       if the XScale or YScale is <=0 it will also fail.
*
*   SEE ALSO
*       GetGUIScale(), CheckWindowSize()
*

******************************************************************************
*
*/

BOOL CheckInnerWindowSize(struct Screen *Scr,
                          WORD Width,
                          WORD Height,
                          float XScale,
                          float YScale)
{
  if(XScale>0 && YScale>0)
  {
    Width= Width  * XScale + Scr->WBorLeft+Scr->WBorRight;
    Height=Height * YScale + Scr->WBorTop + Scr->RastPort.TxHeight + 1 + Scr->WBorBottom;
    if(Width<=Scr->Width && Height<=Scr->Height)
      return(TRUE);
  }
  return(FALSE);
}
