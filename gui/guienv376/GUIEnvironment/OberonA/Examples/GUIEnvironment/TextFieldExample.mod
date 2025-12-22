(****************************************************************************

$RCSfile: TextFieldExample.mod $

$Revision: 1.1 $
    $Date: 1994/12/16 16:49:13 $

    GUIEnvironment example: TextField BOOPSI gadget

    Oberon-A Oberon-2 Compiler V4.17 (Release 1.4 Update 2)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE TextFieldExample;

(* $P- Allow non-portable code *)

IMPORT SYS := SYSTEM,
       I   := Intuition,

       GUI := GUIEnv,
       GS  := GUIEnvSupport,
       GEC := GEClass;

CONST version = "$VER: TextFieldExample 37.6 (16.12.94)\n";

VAR win : I.WindowPtr;
    gui : GUI.GUIInfoPtr;

BEGIN
  GUI.OpenLib(TRUE);

  win := GUI.base.OpenGUIWindow( 50, 50, 150, 150, SYS.ADR("GUIEnvironment - TextFieldExample"),
                                {I.idcmpCloseWindow, I.idcmpNewSize,
                                 I.idcmpRefreshWindow},
                                {I.wflgActivate, I.wflgSizeGadget,
                                 I.wflgDepthGadget, I.wflgCloseGadget,
                                 I.wflgDragBar}, NIL,
                                I.waMinWidth, 250,
                                I.waMinHeight,120,
                                I.waMaxWidth, 500,
                                I.waMaxHeight,200, NIL);
  IF win # NIL THEN

    gui := GUI.base.CreateGUIInfo(win, GUI.guiCreationFont, GS.TopazAttr(), NIL);
    IF gui # NIL THEN

      GUI.base.CreateGUIGadget(gui, 20, 10, -20, -10, GUI.gegBOOPSIPrivateKind,
                               GUI.gegClass, SYS.ADR(GEC.textfieldgClass),
                               GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                              GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                              GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                              GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom),
                               GEC.text, SYS.ADR("This is the textfield gadget example"),
                               GEC.border, GEC.borderDoubleBevel,
                               NIL);

      IF GUI.base.DrawGUI(gui, NIL) = GUI.geDone THEN

        LOOP
          GUI.base.WaitGUIMsg(gui);

          IF    I.idcmpCloseWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF I.idcmpNewSize     IN gui^.msgClass THEN
            (* We only get these messages if an error occurs while
               GUIEnv does the resizing, so we have to EXIT ! *)
            EXIT;
          END;
        END;
      ELSE
        IF GUI.base.GUIRequest(gui, SYS.ADR("TextField gadget © Mark Thomas required !"),
                               GUI.gerOKKind, NIL) = 0 THEN END;
      END;

    END;
  END;

  IF win # NIL THEN
    GUI.base.CloseGUIWindow(win);
    win := NIL;
  END;
END TextFieldExample.
