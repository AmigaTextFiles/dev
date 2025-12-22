/* **************************************************************************

$RCSfile: GuideExample.c $

$Revision: 1.7 $
    $Date: 1994/12/18 15:23:10 $

    GUIEnvironment example: Menu help function

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

************************************************************************** */

/* This example open's a window with a menu. If the user presses the
   help key over a menu item, the AmigaGuide is called with the
   belonging help text ! */

/* GuideExample uses the following catalog strings 101.. : menus
                                                    50.. : misc (NotifyExample)
                                                   200   : END       */

#include <exec/types.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>
#include <proto/exec.h>

#include "guienv.h"
#include "guienvsupport.h"

UBYTE *vers = "\0$VER: GuideExample 37.6 (18.12.94)\n";

struct Library *GUIEnvBase;

struct GUIInfo *G;
struct Window  *W;

int loop;

/* The menu functions: (Amiga callback hooks, as we don't need the
                        register parameters, we don't declare them !*/

LONG MenuAbout(VOID)
{
  GUIRequest(G, "GUIEnvironment example for version 37.6\n© 1994 C. Ziegeler",
             GER_RTOKKind,
             GER_LocaleID, 51, NULL);
  return 1;
}

LONG MenuQuit(VOID)
{
  if (GUIRequest(G, "Really quit example ?",
                 GER_RTDoItKind,
                 GER_LocaleID, 52, NULL) == GER_Yes)
    return 0;
  else
    return 1;
}


LONG MenuGUIEnv(VOID)
{
  GUIRequest(G, "GUIEnvironment !", GER_RTOKKind, NULL);
  return 1;
}

LONG MenuAmiga(VOID)
{
  GUIRequest(G, "Amiga !", GER_RTOKKind, NULL);
  return 1;
}

VOID main(VOID)
{
  loop = 0;
  /* open GUIEnvironment.library (no error check !) */

  GUIEnvBase = OpenLibrary(GUIEnvName, 37);

  W = OpenGUIWindow(100, 70, 300, 100, "GUIEnvironment : GuideExample",
                    IDCMP_CLOSEWINDOW|IDCMP_MENUPICK|IDCMP_MENUHELP|IDCMP_REFRESHWINDOW,
                    WFLG_CLOSEGADGET|WFLG_ACTIVATE, NULL,
                    WA_MenuHelp, TRUE, NULL);
  if (W)
  {
    /* create GUIInfo */

    G = CreateGUIInfo(W, GUI_CatalogFile, "GUIEnvExamples.catalog",
                         GUI_MenuCatalogOffset, 101,
                         GUI_MenuGuide, "GUIEnvExamples.guide", NULL);
    if (G)
    {

      CreateGUIMenuEntry(G, NM_TITLE, "Project", NULL);
      CreateGUIMenuEntry(G, NM_ITEM, "About",
                            GEM_AHook, &MenuAbout,
                            GEM_ShortCut, "I\0", NULL);
      CreateGUIMenuEntry(G, NM_ITEM, "Quit",
                            GEM_AHook, &MenuQuit,
                            GEM_ShortCut, "Q\0", NULL);
      CreateGUIMenuEntry(G, NM_TITLE, "Help", NULL);
      CreateGUIMenuEntry(G, NM_ITEM, "GUIEnv",
                            GEM_AHook, &MenuGUIEnv,
                            GEM_ShortCut, "G\0", NULL);
      CreateGUIMenuEntry(G, NM_ITEM, "Amiga",
                            GEM_AHook, &MenuAmiga,
                            GEM_ShortCut, "A\0", NULL);

      if (DrawGUI(G, NULL) == GE_Done)
      {
        while (loop == 0) /* Input-Loop */
        {
          WaitGUIMsg(G);
          if (G->msgClass == IDCMP_CLOSEWINDOW)
            loop = 1;
          if (G->msgClass == IDCMP_MENUPICK)
            loop = 1;
        }
      }
    }
  }

  if (W) CloseGUIWindow(W);
  if (GUIEnvBase) CloseLibrary(GUIEnvBase);
}
