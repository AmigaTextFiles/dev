(****************************************************************************

$RCSfile: RequesterExample.mod $

$Revision: 1.8 $
    $Date: 1994/12/16 16:33:57 $

    GUIEnvironment example: Requester

    M2Amiga Modula-2 Compiler V4.3

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE RequesterExample;

(* This example shows all available requesters using ReqTools if available *)

(* RequesterExample uses the following catalog strings 201.. : texts
                                                       240.. : gadgets
                                                       250   : END     *)

  FROM SYSTEM     IMPORT ADR, ADDRESS, TAG;
  FROM GadToolsD  IMPORT GtTags, textKind;
  FROM IntuitionD IMPORT WindowPtr, WindowFlagSet, WindowFlags, IDCMPFlagSet,
                         IDCMPFlags;
IMPORT D : GUIEnvD,
       L : GUIEnvL,
       GS: GUIEnvSupport;

CONST version = ADR("$VER: RequesterExample 37.6 (14.12.94)\n");

VAR win : WindowPtr;
    gui : D.GUIInfoPtr;

    choose : LONGINT;
    file, dir : ARRAY[0..255] OF CHAR;
    tagbuf : ARRAY[0..19] OF LONGCARD;
    args : ARRAY[0..4] OF ADDRESS; (* for the arguments *)

BEGIN

  win := L.OpenGUIWindowA( 50, 50, 300, 100, ADR("GUIEnvironment - RequesterExample"),
                          IDCMPFlagSet{closeWindow, refreshWindow},
                          WindowFlagSet{activate, windowDepth, windowClose,
                                        windowDrag}, NIL, NIL);
  IF win # NIL THEN

    gui := L.CreateGUIInfoA(win, TAG(tagbuf,
                            D.guiTextFont, GS.TopazAttr(),
                            D.guiCatalogFile, ADR("GUIEnvExamples.catalog"),
                            D.guiGadgetCatalogOffset, 240, NIL));
    IF gui # NIL THEN

      L.CreateGUIGadgetA(gui, 10, 40, 280, 20, textKind,
                         TAG(tagbuf, gttxText, L.GetCatStr(gui, 240, ADR("Use requesters")),
                                     gttxBorder, TRUE, NIL));

      IF L.DrawGUIA(gui, NIL) = D.geDone THEN

        (* Return value not needed, ok requester *)
        IGNORE L.GUIRequestA(gui, ADR("This is the requester demo !\nEnjoy it !"),
                             D.gerRTOKKind,
                             TAG(tagbuf, D.gerLocaleID, 201, NIL));

        (* doitReqKind *)
        WHILE L.GUIRequestA(gui, ADR("Do you want to see this requester again ?"),
                            D.gerRTDoItKind,
                            TAG(tagbuf, D.gerLocaleID, 202, NIL)) = D.gerYes DO
        END;

        (* Yes/no/cancel  requester *)
        choose := L.GUIRequestA(gui, ADR("Do you want to see some asl requesters ?"),
                                D.gerRTYNCKind,
                                TAG(tagbuf, D.gerLocaleID, 203, NIL));
        IF choose = D.gerYes THEN

          (* And now the asl requesters supported by GUIEnvironment *)

          file := "guienv.library";
          dir  := "sys:libs";

          (* First a requester to choose the best library ! *)
          IF L.GUIRequestA(gui, ADR("Choose the best library"),
                           D.gerRTFileKind, TAG(tagbuf,
                           D.gerPattern, ADR("#?.library"),
                           D.gerFileBuffer, ADR(file),
                           D.gerDirBuffer, ADR(dir),
                           D.gerLocaleID, 204, NIL)) = D.gerYes THEN
            args[0] := ADR(dir);
            args[1] := ADR(file);
            IGNORE L.GUIRequestA(gui, ADR("You choice was:\ndir : %s\nfile: %s"),
                                 D.gerRTOKKind, TAG(tagbuf,
                                 D.gerArgs, ADR(args),
                                 D.gerLocaleID, 205, NIL));
          ELSE
            IGNORE L.GUIRequestA(gui, ADR("You cancelled it ! (Sniff..)"),
                                 D.gerRTOKKind,
                                 TAG(tagbuf, D.gerLocaleID, 206, NIL));
          END;

          (* And now a save dir requester with no pattern gadget *)
          dir := "ram:t";
          IF L.GUIRequestA(gui, ADR("Choose directory to save something..."),
                           D.gerRTDirKind, TAG(tagbuf,
                           D.gerNameBuffer, ADR(dir),
                           D.gerPattern, NIL,
                           D.gerSave, TRUE,
                           D.gerLocaleID, 207, NIL)) = D.gerYes THEN

            args[0] := ADR(dir);
            IGNORE L.GUIRequestA(gui, ADR("You selected directory:\n%s"),
                                 D.gerRTOKKind, TAG(tagbuf,
                                 D.gerArgs, ADR(args),
                                 D.gerLocaleID, 208, NIL));
          ELSE
            IGNORE L.GUIRequestA(gui, ADR("You cancelled it ! (Snuff..)"),
                                 D.gerRTOKKind,
                                 TAG(tagbuf, D.gerLocaleID, 209, NIL));
          END;

        ELSIF choose = D.gerNo  THEN
          IGNORE L.GUIRequestA(gui, ADR("Click OK to quit !"), D.gerRTOKKind,
                               TAG(tagbuf, D.gerLocaleID, 210, NIL));
        END;

      END;
    END;
  END;

CLOSE
  IF win # NIL THEN
    L.CloseGUIWindow(win);
    win := NIL;
  END;
END RequesterExample.
