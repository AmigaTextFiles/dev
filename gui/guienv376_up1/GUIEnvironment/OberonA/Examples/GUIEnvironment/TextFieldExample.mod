(****************************************************************************

$RCSfile: TextFieldExample.mod $

$Revision: 1.1 $
    $Date: 1994/12/16 16:49:13 $

    GUIEnvironment example: TextField BOOPSI gadget

    Oberon-A Oberon-2 Compiler V5.18 (Release 1.5)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)

<* STANDARD - *>

MODULE TextFieldExample;

IMPORT SYS := SYSTEM,
       I   := Intuition,

       GUI := GUIEnv,
       GS  := GUIEnvSupport,
       GEC := GEClass;

CONST version = "$VER: TextFieldExample 37.61 (04.02.95)\n";

VAR win : I.WindowPtr;
    gui : GUI.GUIInfoPtr;

BEGIN
  win := GUI.OpenGUIWindow( 50, 50, 150, 150, SYS.ADR("GUIEnvironment - TextFieldExample"),
                           {I.closeWindow, I.newSize,
                            I.refreshWindow},
                           {I.activate, I.windowSizing,
                            I.windowDepth, I.windowClose,
                            I.windowDrag}, NIL,
                           I.waMinWidth, 250,
                           I.waMinHeight,120,
                           I.waMaxWidth, 500,
                           I.waMaxHeight,200, NIL);
  IF win # NIL THEN

    gui := GUI.CreateGUIInfo(win, GUI.guiCreationFont, GS.TopazAttr(), NIL);
    IF gui # NIL THEN

      GUI.CreateGUIGadget(gui, 20, 10, -20, -10, GUI.gegBOOPSIPrivateKind,
                          GUI.gegClass, SYS.ADR(GEC.textfieldgClass),
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom),
                          GEC.text, SYS.ADR("This is the textfield gadget example"),
                          GEC.border, GEC.borderDoubleBevel,
                          NIL);

      IF GUI.DrawGUI(gui, NIL) = GUI.geDone THEN

        LOOP
          GUI.WaitGUIMsg(gui);

          IF    I.closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF I.newSize     IN gui^.msgClass THEN
            (* We only get these messages if an error occurs while
               GUIEnv does the resizing, so we have to EXIT ! *)
            EXIT;
          END;
        END;
      ELSE
        IF GUI.GUIRequest(gui, SYS.ADR("TextField gadget © Mark Thomas required !"),
                          GUI.gerOKKind, NIL) = 0 THEN END;
      END;

    END;
  END;

  IF win # NIL THEN
    GUI.CloseGUIWindow(win);
    win := NIL;
  END;
END TextFieldExample.
