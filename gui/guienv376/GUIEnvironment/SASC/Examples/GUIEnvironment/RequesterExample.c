/* **************************************************************************

$RCSfile: RequesterExample.c $

$Revision: 1.3 $
    $Date: 1994/11/24 13:08:39 $

    GUIEnvironment example: Requester

    SAS/C V6.51

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

************************************************************************** */

/* This example shows all available requesters on the public screen
   usin ReqTools */

/* RequesterExample uses the following catalog strings 201.. : texts
                                                       240.. : gadgets
                                                       250   : END     */

#include <exec/types.h>
#include <proto/exec.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>
#include <string.h>

#include "guienv.h"
#include "guienvsupport.h"

UBYTE *vers = "\0$VER: RequesterExample 37.6 (11.12.94)\n";

struct Library *GUIEnvBase;

struct GUIInfo *gui;
struct Window  *win;

long choose;
char file[256], dir[256];
APTR args[5];              /* for the arguments */

VOID main(VOID)
{

  /* open GUIEnvironment.library (no error check !) */

  GUIEnvBase = OpenLibrary(GUIEnvName, 37);

  win = OpenGUIWindow( 50, 50, 300, 100, "GUIEnvironment - RequesterExample",
                      IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW,
                      WFLG_ACTIVATE|WFLG_DEPTHGADGET|WFLG_CLOSEGADGET|
                      WFLG_DRAGBAR, NULL, NULL);
  if (win)
  {
    gui = CreateGUIInfo(win, GUI_TextFont, TopazAttr(),
                             GUI_CatalogFile, "GUIEnvExamples.catalog",
                             GUI_GadgetCatalogOffset, 240, NULL);
    if (gui)
    {
      CreateGUIGadget(gui, 10, 40, 280, 20, TEXT_KIND,
                      GTTX_Text, GetCatStr(gui, 240, "Use requesters"),
                      GTTX_Border, 1, NULL);

      if (DrawGUI(gui, NULL) == GE_Done)
      {
        /* Return value not needed, ok requester */
        GUIRequest(gui, "This is the requester demo !\nEnjoy it !",
                   GER_RTOKKind, GER_LocaleID, 201, NULL);

        /* doitReqKind */
        while (GUIRequest(gui, "Do you want to see this requester again ?",
                          GER_RTDoItKind,
                          GER_LocaleID, 202, NULL) == GER_Yes)  ;

        /* Yes/no/cancel  requester */
        choose = GUIRequest(gui, "Do you want to see some asl requesters ?",
                            GER_RTYNCKind,
                            GER_LocaleID, 203, NULL);
        if (choose == GER_Yes)
        {
          /* And now the asl requesters supported by GUIEnvironment */

          strcpy(file, "guienv.library");
          strcpy(dir, "sys:libs");

          /* First a requester to choose the best library ! */
          if (GUIRequest(gui, "Choose the best library", GER_RTFileKind,
                         GER_Pattern, "#?.library",
                         GER_FileBuffer, &file,
                         GER_DirBuffer, &dir,
                         GER_LocaleID, 204, NULL) == GER_Yes)
            {
            args[0] = &dir;
            args[1] = &file;
            GUIRequest(gui, "You choice was:\ndir : %s\nfile: %s",
                       GER_RTOKKind, GER_Args, &args,
                       GER_LocaleID, 205, NULL);
            }
          else
            GUIRequest(gui, "You cancelled it ! (Sniff..)",
                       GER_RTOKKind, GER_LocaleID, 206, NULL);


          /* And now a save dir requester with no pattern gadget */
          strcpy(dir, "ram:t");
          if (GUIRequest(gui, "Choose directory to save something...",
                         GER_RTDirKind, GER_NameBuffer, &dir,
                                      GER_Pattern, NULL,
                                      GER_Save, 1,
                                      GER_LocaleID, 207, NULL) == GER_Yes)
          {
            args[0] = &dir;
            GUIRequest(gui, "You selected directory:\n%s",
                       GER_RTOKKind, GER_Args, &args,
                                   GER_LocaleID, 208, NULL);
          }
          else
            GUIRequest(gui, "You cancelled it ! (Snuff..)",
                       GER_RTOKKind, GER_LocaleID, 209, NULL);
        }
        else
        {
          if (choose = GER_No)
            GUIRequest(gui, "Click OK to quit !", GER_RTOKKind,
                       GER_LocaleID, 210, NULL);
        }

      }
    }
  }

  if (win) CloseGUIWindow(win);
  if (GUIEnvBase) CloseLibrary(GUIEnvBase);
}
