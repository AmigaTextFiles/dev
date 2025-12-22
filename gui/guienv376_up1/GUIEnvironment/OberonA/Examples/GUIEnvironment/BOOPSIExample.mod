(****************************************************************************

$RCSfile: BOOPSIExample.mod $

$Revision: 1.4 $
    $Date: 1994/09/30 11:29:40 $

    GUIEnvironment example: BOOPSI gadgets

    Oberon-A Oberon-2 Compiler V5.18 (Release 1.5)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)

<* STANDARD - *>
MODULE BOOPSIExample;

IMPORT SYS := SYSTEM,
       I   := Intuition,

       GUI := GUIEnv,
       GS  := GUIEnvSupport;

CONST version = "$VER: BOOPSIExample 37.61 (04.02.95)\n";


VAR win : I.WindowPtr;
    gui : GUI.GUIInfoPtr;

    int2propmap, prop2intmap : ARRAY 3 OF LONGINT;

BEGIN
  int2propmap[0] := I.stringaLongVal;
  int2propmap[1] := I.pgaTop;
  int2propmap[2] := 0;

  prop2intmap[0] := I.pgaTop;
  prop2intmap[1] := I.stringaLongVal;
  prop2intmap[2] := 0;

  win := GUI.OpenGUIWindow( 50, 50, 150, 150, SYS.ADR("GUIEnvironment - BOOPSIExample"),
                           {I.closeWindow, I.newSize,
                            I.refreshWindow},
                           {I.activate, I.windowSizing,
                            I.windowDepth, I.windowClose, I.windowDrag}, NIL,
                           I.waMinWidth, 250,
                           I.waMinHeight,120,
                           I.waMaxWidth, 500,
                           I.waMaxHeight,200, NIL);
  IF win # NIL THEN

    gui := GUI.CreateGUIInfo(win, GUI.guiCreationFont, GS.TopazAttr(), NIL);
    IF gui # NIL THEN

      GUI.CreateGUIGadget(gui, 10, 20, 10, -10, GUI.gegBOOPSIPublicKind,
                          GUI.gegClass, SYS.ADR("propgclass"),
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                         GUI.gegDistNorm,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom),
                          I.icaMap, SYS.ADR(prop2intmap),
                          I.pgaTotal, 100,
                          I.pgaTop, 25,
                          I.pgaVisible,10,
                          I.pgaNewLook, 1, NIL);

      GUI.CreateGUIGadget(gui, 10, 10, -10, 18, GUI.gegBOOPSIPublicKind,
                          GUI.gegClass, SYS.ADR("strgclass"),
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjGadget+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistNorm),
                          I.icaMap, SYS.ADR(int2propmap),
                          I.icaTarget, GUI.GetGUIGadget(gui, 0, GUI.gegAddress),
                          I.stringaLongVal, 25,
                          I.stringaMaxChars, 3, NIL);
      GUI.SetGUIGadget(gui, 0, I.icaTarget, GUI.GetGUIGadget(gui, 1, GUI.gegAddress), NIL);

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
      END;

    END;
  END;

  IF win # NIL THEN
    GUI.CloseGUIWindow(win);
    win := NIL;
  END;
END BOOPSIExample.
