(****************************************************************************

$RCSfile: GuideExample.mod $

$Revision: 1.8 $
    $Date: 1994/12/18 15:24:09 $

    GUIEnvironment example: Menu help function

    Oberon-A Oberon-2 Compiler V4.17 (Release 1.4 Update 2)

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

(* $P- Allow non-portable code *)

IMPORT SYS := SYSTEM,
       GT  := GadTools,
       I   := Intuition,

       GUI := GUIEnv,
       GS  := GUIEnvSupport;

CONST ver = "$VER: GuideExample 37.6 (18.12.94)\n";

VAR W : I.WindowPtr;
    G : GUI.GUIInfoPtr;


  (* The menu functions: (Amiga callback hooks !)

     As they all don't need any parameters they are called directly as if
     they could handle register parameters ! *)

  PROCEDURE MenuAbout() : LONGINT;
  BEGIN
    IF GUI.base.GUIRequest(G, SYS.ADR("GUIEnvironment example for version 37.6\n© 1994 C. Ziegeler"),
                           GUI.gerRTOKKind,
                           GUI.gerLocaleID, 51, NIL) = 0 THEN END;
    RETURN 1;
  END MenuAbout;

  PROCEDURE MenuQuit() : LONGINT;
  BEGIN
    IF GUI.base.GUIRequest(G, SYS.ADR("Really quit example ?"),
                           GUI.gerRTDoItKind,
                           GUI.gerLocaleID, 52, NIL) = GUI.gerYes THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END;
  END MenuQuit;

  PROCEDURE MenuGUIEnv() : LONGINT;
  BEGIN
    IF GUI.base.GUIRequest(G, SYS.ADR("GUIEnvironment !"), GUI.gerRTOKKind, NIL) = 0 THEN END;
    RETURN 1;
  END MenuGUIEnv;

  PROCEDURE MenuAmiga() : LONGINT;
  BEGIN
    IF GUI.base.GUIRequest(G, SYS.ADR("Amiga !"), GUI.gerRTOKKind, NIL) = 0 THEN END;
    RETURN 1;
  END MenuAmiga;

BEGIN

  GUI.OpenLib(TRUE);

  W := GUI.base.OpenGUIWindow(100, 70, 300, 100, SYS.ADR("GUIEnvironment : GuideExample"),
                              {I.idcmpCloseWindow, I.idcmpMenuPick,
                               I.idcmpMenuHelp},
                              {I.wflgCloseGadget, I.wflgActivate}, NIL,
                              I.waMenuHelp, 1, NIL);
  IF W # NIL THEN
    (* create GUIInfo *)

    G := GUI.base.CreateGUIInfo(W,
                          GUI.guiCatalogFile, SYS.ADR("GUIEnvExamples.catalog"),
                          GUI.guiMenuCatalogOffset, 101,
                          GUI.guiMenuGuide, SYS.ADR("GUIEnvExamples.guide"), NIL);
    IF G # NIL THEN

      GUI.base.CreateGUIMenuEntry(G, GT.nmTitle, SYS.ADR("Project"), NIL);
      GUI.base.CreateGUIMenuEntry(G, GT.nmItem, SYS.ADR("About"),
                                  GUI.gemAHook, SYS.ADR(MenuAbout),
                                  GUI.gemShortCut, SYS.ADR("I\0"), NIL);
      GUI.base.CreateGUIMenuEntry(G, GT.nmItem, SYS.ADR("Quit"),
                                  GUI.gemAHook, SYS.ADR(MenuQuit),
                                  GUI.gemShortCut, SYS.ADR("Q\0"), NIL);
      GUI.base.CreateGUIMenuEntry(G, GT.nmTitle, SYS.ADR("Help"), NIL);
      GUI.base.CreateGUIMenuEntry(G, GT.nmItem, SYS.ADR("GUIEnv"),
                                  GUI.gemAHook, SYS.ADR(MenuGUIEnv),
                                  GUI.gemShortCut, SYS.ADR("G\0"), NIL);
      GUI.base.CreateGUIMenuEntry(G, GT.nmItem, SYS.ADR("Amiga"),
                                  GUI.gemAHook, SYS.ADR(MenuAmiga),
                                  GUI.gemShortCut, SYS.ADR("A\0"), NIL);

      IF GUI.base.DrawGUI(G, NIL) = GUI.geDone THEN
        LOOP (* Input-Loop *)
          GUI.base.WaitGUIMsg(G);
          IF    I.idcmpCloseWindow IN G^.msgClass THEN
            EXIT;
          ELSIF I.idcmpMenuPick    IN G^.msgClass THEN
            EXIT;
          END;
        END;
      END;
    END;
  END;

  IF W # NIL THEN
    GUI.base.CloseGUIWindow(W);
    W := NIL;
  END;
END GuideExample.
