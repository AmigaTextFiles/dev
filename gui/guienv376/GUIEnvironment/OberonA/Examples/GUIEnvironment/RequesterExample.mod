(****************************************************************************

$RCSfile: RequesterExample.mod $

$Revision: 1.3 $
    $Date: 1994/11/24 12:41:43 $

    GUIEnvironment example: Requester

    Oberon-A Oberon-2 Compiler V4.17 (Release 1.4 Update 2)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE RequesterExample;

(* This example shows all available requesters using ReqTools if available *)

(* RequesterExample uses the following catalog strings 201.. : texts
                                                       240.. : gadgets
                                                       250   : END     *)

(* $P- Allow non-portable code *)

IMPORT SYS := SYSTEM,
       GT  := GadTools,
       I   := Intuition,
       GUI := GUIEnv,
       GS  := GUIEnvSupport;

CONST version = "$VER: RequesterExample 37.6 (15.12.94)\n";

VAR win : I.WindowPtr;
    gui : GUI.GUIInfoPtr;

    choose : LONGINT;
    file, dir : ARRAY 256 OF CHAR;
    args : ARRAY 5 OF SYS.CPTR;    (* for the arguments *)

BEGIN

  GUI.OpenLib(TRUE);

  win := GUI.base.OpenGUIWindow( 50, 50, 300, 100, SYS.ADR("GUIEnvironment - RequesterExample"),
                                {I.idcmpCloseWindow,  I.idcmpRefreshWindow},
                                {I.wflgActivate, I.wflgDepthGadget,
                                 I.wflgCloseGadget, I.wflgDragBar}, NIL, NIL);
  IF win # NIL THEN

    gui := GUI.base.CreateGUIInfo(win, GUI.guiTextFont, GS.TopazAttr(),
                                       GUI.guiCatalogFile, SYS.ADR("GUIEnvExamples.catalog"),
                                       GUI.guiGadgetCatalogOffset, 240, NIL);
    IF gui # NIL THEN

      GUI.base.CreateGUIGadget(gui, 10, 40, 280, 20, GT.textKind,
                               GT.txText, GUI.base.GetCatStr(gui, 240, SYS.ADR("Use requesters")),
                               GT.txBorder, 1, NIL);

      IF GUI.base.DrawGUI(gui, NIL) = GUI.geDone THEN

        (* Return value not needed, ok requester *)
        IF GUI.base.GUIRequest(gui, SYS.ADR("This is the requester demo !\nEnjoy it !"),
                               GUI.gerRTOKKind,
                               GUI.gerLocaleID, 201, NIL) = 0 THEN END;

        (* doitReqKind *)
        WHILE GUI.base.GUIRequest(gui, SYS.ADR("Do you want to see this requester again ?"),
                                  GUI.gerRTDoItKind,
                                  GUI.gerLocaleID, 202, NIL) = GUI.gerYes DO
        END;

        (* Yes/no/cancel  requester *)
        choose := GUI.base.GUIRequest(gui, SYS.ADR("Do you want to see some asl requesters ?"),
                                      GUI.gerRTYNCKind,
                                      GUI.gerLocaleID, 203, NIL);
        IF choose = GUI.gerYes THEN

          (* And now the asl requesters supported by GUIEnvironment *)

          file := "guienv.library";
          dir  := "sys:libs";

          (* First a requester to choose the best library ! *)
          IF GUI.base.GUIRequest(gui, SYS.ADR("Choose the best library"),
                                 GUI.gerRTFileKind,
                                 GUI.gerPattern, SYS.ADR("#?.library"),
                                 GUI.gerFileBuffer, SYS.ADR(file),
                                 GUI.gerDirBuffer, SYS.ADR(dir),
                                 GUI.gerLocaleID, 204, NIL) = GUI.gerYes THEN
            args[0] := SYS.ADR(dir);
            args[1] := SYS.ADR(file);

            IF GUI.base.GUIRequest(gui, SYS.ADR("You choice was:\ndir : %s\nfile: %s"),
                                   GUI.gerRTOKKind, GUI.gerArgs, SYS.ADR(args),
                                                    GUI.gerLocaleID, 205, NIL) = 0 THEN END;
          ELSE
            IF GUI.base.GUIRequest(gui, SYS.ADR("You cancelled it ! (Sniff..)"),
                                   GUI.gerRTOKKind,
                                   GUI.gerLocaleID, 206, NIL) = 0 THEN END;
          END;

          (* And now a save dir requester with no pattern gadget *)
          dir := "ram:t";
          IF GUI.base.GUIRequest(gui, SYS.ADR("Choose directory to save something..."),
                                 GUI.gerRTDirKind,
                                 GUI.gerNameBuffer, SYS.ADR(dir),
                                 GUI.gerPattern, NIL,
                                 GUI.gerSave, TRUE,
                                 GUI.gerLocaleID, 207, NIL) = GUI.gerYes THEN

            args[0] := SYS.ADR(dir);
            IF GUI.base.GUIRequest(gui, SYS.ADR("You selected directory:\n%s"),
                                   GUI.gerRTOKKind, GUI.gerArgs, SYS.ADR(args),
                                                    GUI.gerLocaleID, 208, NIL) = 0 THEN END;
          ELSE
            IF GUI.base.GUIRequest(gui, SYS.ADR("You cancelled it ! (Snuff..)"),
                                   GUI.gerRTOKKind,
                                   GUI.gerLocaleID, 209, NIL) = 0 THEN END;
          END;

        ELSIF choose = GUI.gerNo  THEN
          IF GUI.base.GUIRequest(gui, SYS.ADR("Click OK to quit !"),
                                 GUI.gerRTOKKind,
                                 GUI.gerLocaleID, 210, NIL) = 0 THEN END;
        END;

      END;
    END;
  END;

  IF win # NIL THEN
    GUI.base.CloseGUIWindow(win);
    win := NIL;
  END;
END RequesterExample.
