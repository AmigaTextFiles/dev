/****************************************************************************

$RCSfile: TextFieldExample.c $

$Revision: 1.1 $
    $Date: 1994/12/16 17:12:32 $

    GUIEnvironment example: TextField BOOPSI gadget

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************/

#include <exec/types.h>
#include <proto/exec.h>
#include <intuition/intuition.h>

#include "guienv.h"
#include "guienvsupport.h"
#include "geclass.h"

UBYTE *vers = "\0$VER: TextFieldExample 37.6 (16.12.94)\n";

struct Library *GUIEnvBase;

struct GUIInfo *gui;
struct Window  *win;

int loop;

VOID main(VOID)
{
  /* open GUIEnvironment.library (no error check !) */

  GUIEnvBase = OpenLibrary(GUIEnvName, 37);

  loop = 0;

  win = OpenGUIWindow( 50, 50, 150, 150, "GUIEnvironment - TextFieldExample",
                      IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW,
                      WFLG_ACTIVATE|WFLG_SIZEGADGET|
                      WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|WFLG_DRAGBAR, NULL,
                      WA_MinWidth, 250,
                      WA_MinHeight,120,
                      WA_MaxWidth, 500,
                      WA_MaxHeight,200, NULL);
  if (win)
  {
    gui = CreateGUIInfo(win, GUI_CreationFont, TopazAttr(), NULL);

    if (gui)
    {
      CreateGUIGadget(gui, 20, 10, -20, -10, GEG_BOOPSIPrivateKind,
                      GEG_Class, TEXTFIELDGCLASS,
                      GEG_Description, GADDESC(GEG_DistAbs+GEG_ObjBorder+GEG_ObjLeft,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjTop,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjRight,
                                               GEG_DistAbs+GEG_ObjBorder+GEG_ObjBottom),
                      TEXTFIELD_Text, "This is the textfield gadget example",
                      TEXTFIELD_Border, TEXTFIELD_BORDER_DOUBLEBEVEL,
                      NULL);

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
      else
        GUIRequest(gui, "TextField gadget © Mark Thomas required !",
                   GER_OKKind, NULL);


    }
  }

  if (win) CloseGUIWindow(win);
  if (GUIEnvBase) CloseLibrary(GUIEnvBase);
}
