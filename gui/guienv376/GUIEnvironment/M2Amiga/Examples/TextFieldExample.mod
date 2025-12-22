(****************************************************************************

$RCSfile: TextFieldExample.mod $

$Revision: 1.1 $
    $Date: 1994/12/16 16:28:28 $

    GUIEnvironment example: TextField BOOPSI gadget

    M2Amiga Modula-2 Compiler V4.3

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE TextFieldExample;


  FROM SYSTEM     IMPORT ADR, ADDRESS, CAST, TAG;
  FROM IntuitionD IMPORT WindowPtr, WindowFlagSet, WindowFlags, IDCMPFlagSet,
                         IDCMPFlags, WaTags;

  FROM GUIEnvSupport IMPORT GADDESC, GADOBJS, TopazAttr;

IMPORT D  : GUIEnvD,
       L  : GUIEnvL,
       GEC: GEClassD;

CONST version = ADR("$VER: TextFieldExample 37.6 (16.12.94)\n");

VAR win : WindowPtr;
    gui : D.GUIInfoPtr;
    tagbuf : ARRAY[0..19] OF LONGCARD;


BEGIN

  win := L.OpenGUIWindowA( 50, 50, 150, 150, ADR("GUIEnvironment - TextFieldExample"),
                          IDCMPFlagSet{closeWindow, newSize,
                                       refreshWindow},
                          WindowFlagSet{activate, windowSizing,
                                        windowDepth, windowClose,
                                        windowDrag}, NIL,
                          TAG(tagbuf, waMinWidth, 250,
                                      waMinHeight,120,
                                      waMaxWidth, 500,
                                      waMaxHeight,200, NIL));
  IF win # NIL THEN

    gui := L.CreateGUIInfoA(win, TAG(tagbuf, D.guiCreationFont, TopazAttr(), NIL));
    IF gui # NIL THEN

      L.CreateGUIGadgetA(gui, 20, 10, -20, -10, D.gegBOOPSIPrivateKind,
                         TAG(tagbuf, D.gegClass, ADR(GEC.textfieldgClass),
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjTop,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjBottom),
                                     GEC.text, ADR("This is the textfield gadget example"),
                                     GEC.border, GEC.borderDoubleBevel,
                                     NIL));

      IF L.DrawGUIA(gui, NIL) = D.geDone THEN

        LOOP
          L.WaitGUIMsg(gui);

          IF    closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF newSize     IN gui^.msgClass THEN
            (* We only get these messages if an error occurs while
               GUIEnv does the resizing, so we have to EXIT ! *)
            EXIT;
          END;
        END;
      ELSE
        IGNORE L.GUIRequestA(gui, ADR("TextField gadget © Mark Thomas required !"), D.gerOKKind, NIL);
      END;

    END;
  END;

CLOSE
  IF win # NIL THEN
    L.CloseGUIWindow(win);
    win := NIL;
  END;
END TextFieldExample.
