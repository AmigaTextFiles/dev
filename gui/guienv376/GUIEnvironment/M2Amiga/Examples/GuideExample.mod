(****************************************************************************

$RCSfile: GuideExample.mod $

$Revision: 1.8 $
    $Date: 1994/12/18 15:25:31 $

    GUIEnvironment example: Menu help function

    M2Amiga Modula-2 Compiler V4.2

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE GuideExample;

(* This example open's a window with a menu. If the user presses the
   help key over a menu item, the AmigaGuide is called with the
   belonging help text ! *)

(* GuideExample uses the following catalog strings 101.. : menus
                                                    50.. : misc (NotifyExample)
                                                   200   : END       *)

  FROM SYSTEM     IMPORT ADDRESS, ADR, CAST, TAG;
  FROM GadToolsD  IMPORT nmItem, nmTitle;
  FROM IntuitionD IMPORT WindowPtr, WindowFlagSet, WindowFlags, WaTags,
                         IDCMPFlagSet, IDCMPFlags;
IMPORT D : GUIEnvD,
       L : GUIEnvL;

CONST ver = ADR("$VER: GuideExample 37.6 (18.12.94)");

VAR W : WindowPtr;
    G : D.GUIInfoPtr;

    buffer : ARRAY[0..12] OF LONGCARD; (* Will contain all the tags *)


  (* The menu functions: *)

  PROCEDURE MenuAbout() : BOOLEAN;
  BEGIN
    IGNORE L.GUIRequestA(G, ADR("GUIEnvironment example for version 37.6\n© 1994 C. Ziegeler"),
                         D.gerRTOKKind, TAG(buffer,
                         D.gerLocaleID, 51, NIL));
    RETURN TRUE;
  END MenuAbout;

  PROCEDURE MenuQuit() : BOOLEAN;
  BEGIN
    RETURN L.GUIRequestA(G, ADR("Really quit example ?"),
                         D.gerRTDoItKind, TAG(buffer,
                         D.gerLocaleID, 52, NIL)) # D.gerYes;
  END MenuQuit;

  PROCEDURE MenuGUIEnv() : BOOLEAN;
  BEGIN
    IGNORE L.GUIRequestA(G, ADR("GUIEnvironment !"), D.gerRTOKKind, NIL);
    RETURN TRUE;
  END MenuGUIEnv;

  PROCEDURE MenuAmiga() : BOOLEAN;
  BEGIN
    IGNORE L.GUIRequestA(G, ADR("Amiga !"), D.gerRTOKKind, NIL);
    RETURN TRUE;
  END MenuAmiga;

BEGIN

  W := L.OpenGUIWindowA(100, 70, 300, 100, ADR("GUIEnvironment : GuideExample"),
                        IDCMPFlagSet{closeWindow, menuPick, menuHelp},
                        WindowFlagSet{windowClose, windowDrag, windowDepth, activate},
                        NIL, TAG(buffer, waMenuHelp, TRUE, NIL));
  IF W # NIL THEN
    (* create GUIInfo *)

    G := L.CreateGUIInfoA(W, TAG(buffer,
                          D.guiCatalogFile, ADR("GUIEnvExamples.catalog"),
                          D.guiMenuCatalogOffset, 101,
                          D.guiMenuGuide, ADR("GUIEnvExamples.guide"), NIL));
    IF G # NIL THEN

      L.CreateGUIMenuEntryA(G, nmTitle, ADR("Project"), NIL);
      L.CreateGUIMenuEntryA(G, nmItem, ADR("About"),
                            TAG(buffer, D.gemAHook, ADR(MenuAbout),
                                        D.gemShortCut, ADR("I\o"), NIL));
      L.CreateGUIMenuEntryA(G, nmItem, ADR("Quit"),
                            TAG(buffer, D.gemAHook, ADR(MenuQuit),
                                        D.gemShortCut, ADR("Q\o"), NIL));
      L.CreateGUIMenuEntryA(G, nmTitle, ADR("Help"), NIL);
      L.CreateGUIMenuEntryA(G, nmItem, ADR("GUIEnv"),
                            TAG(buffer, D.gemAHook, ADR(MenuGUIEnv),
                                        D.gemShortCut, ADR("G\o"), NIL));
      L.CreateGUIMenuEntryA(G, nmItem, ADR("Amiga"),
                            TAG(buffer, D.gemAHook, ADR(MenuAmiga),
                                        D.gemShortCut, ADR("A\o"), NIL));

      IF L.DrawGUIA(G, NIL) = D.geDone THEN
        LOOP (* Input-Loop *)
          L.WaitGUIMsg(G);
          IF    closeWindow IN G^.msgClass THEN
            EXIT;
          ELSIF menuPick    IN G^.msgClass THEN
            EXIT;
          END;
        END;
      END;
    END;
  END;

CLOSE
  IF W # NIL THEN
    L.CloseGUIWindow(W);
    W := NIL;
  END;
END GuideExample.
