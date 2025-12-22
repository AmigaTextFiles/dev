/* **************************************************************************

$RCSfile: BOOPSIExample.c $

$Revision: 1.4 $
    $Date: 1994/09/30 11:43:52 $

    GUIEnvironment example: BOOPSI gadgets

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

************************************************************************** */

#include <exec/types.h>
#include <proto/exec.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>

#include "guienv.h"
#include "guienvsupport.h"

UBYTE *vers = "\0$VER: BOOPSIExample 37.6 (11.12.94)\n";

struct Library *GUIEnvBase;

struct GUIInfo *gui;
struct Window  *win;

LONG int2propmap[] = {STRINGA_LongVal, PGA_Top, 0};
LONG prop2intmap[] = {PGA_Top, STRINGA_LongVal, 0};

int loop;

VOID main(VOID)
{
  /* open GUIEnvironment.library (no error check !) */

  GUIEnvBase = OpenLibrary(GUIEnvName, 37);

  loop = 0;
  win = OpenGUIWindow( 50, 50, 150, 150, "GUIEnvironment - BOOPSIExample",
                      IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW,
                      WFLG_ACTIVATE|WFLG_SIZEGADGET|
                      WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_DRAGBAR,
                      NULL, WA_MinWidth, 250,
                            WA_MinHeight,120,
                            WA_MaxWidth, 500,
                            WA_MaxHeight,200, NULL);
  if (win)
  {
    gui = CreateGUIInfo(win, GUI_CreationFont, TopazAttr(), NULL);

    if (gui)
    {
      CreateGUIGadget(gui, 10, 20, 10, -10, GEG_BOOPSIPublicKind,
                      GEG_Class, "propgclass",
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjTop,
                                               GEG_DistNorm,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjBottom),
                      ICA_MAP, &prop2intmap,
                      PGA_Total, 100,
                      PGA_Top, 25,
                      PGA_Visible,10,
                      PGA_NewLook, TRUE, NULL);

      CreateGUIGadget(gui, 10, 10, -10, 18, GEG_BOOPSIPublicKind,
                      GEG_Class, "strgclass",
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjGadget+GEG_ObjRight,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjTop,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistNorm),
                      ICA_MAP, &int2propmap,
                      ICA_TARGET, GetGUIGadget(gui, 0, GEG_Address),
                      STRINGA_LongVal, 25,
                      STRINGA_MaxChars, 3, NULL);
      SetGUIGadget(gui, 0, ICA_TARGET, GetGUIGadget(gui, 1, GEG_Address), NULL);

      if (DrawGUI(gui, NULL) == GE_Done)
      {
        while (loop == 0)
        {
          WaitGUIMsg(gui);

          if (gui->msgClass == IDCMP_CLOSEWINDOW)
            loop = 1;
          if (gui->msgClass == IDCMP_NEWSIZE)
            /* We only get these messages if an error occurs while
               GUIEnv does the resizing, so we have to EXIT ! */
            loop = 1;

        }
      }

    }
  }

  if (win) CloseGUIWindow(win);
  if (GUIEnvBase) CloseLibrary(GUIEnvBase);
}
