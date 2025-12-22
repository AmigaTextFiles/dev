(****************************************************************************

$RCSfile: BOOPSIExample.mod $

$Revision: 1.5 $
    $Date: 1994/10/31 17:11:09 $

    GUIEnvironment example: BOOPSI gadgets

    M2Amiga Modula-2 Compiler V4.3

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE BOOPSIExample;


  FROM SYSTEM     IMPORT ADR, ADDRESS, CAST, TAG;
  FROM IntuitionD IMPORT WindowPtr, WindowFlagSet, WindowFlags, IDCMPFlagSet,
                         IDCMPFlags, WaTags, IcaTags, PgaTags, StringaTags;

  FROM GUIEnvSupport IMPORT GADDESC, GADOBJS, TopazAttr;

IMPORT D:GUIEnvD, L:GUIEnvL;


TYPE ARR=ARRAY[0..2] OF LONGCARD;

CONST version = ADR("$VER: BOOPSIExample 37.6 (14.12.94)\n");

     int2propmap = ARR{LONGCARD(stringaLongVal), LONGCARD(pgaTop), 0};
     prop2intmap = ARR{LONGCARD(pgaTop), LONGCARD(stringaLongVal), 0};


VAR win : WindowPtr;
    gui : D.GUIInfoPtr;
    tagbuf : ARRAY[0..19] OF LONGCARD;


BEGIN

  win := L.OpenGUIWindowA( 50, 50, 150, 150, ADR("GUIEnvironment - BOOPSIExample"),
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

      L.CreateGUIGadgetA(gui, 10, 20, 10, -10, D.gegBOOPSIPublicKind,
                         TAG(tagbuf, D.gegClass, ADR("propgclass"),
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjTop,
                                                               D.gegDistNorm,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjBottom),
                                     icaMap, ADR(prop2intmap),
                                     pgaTotal, 100,
                                     pgaTop, 25,
                                     pgaVisible,10,
                                     pgaNewLook, TRUE, NIL));

      L.CreateGUIGadgetA(gui, 10, 10, -10, 18, D.gegBOOPSIPublicKind,
                         TAG(tagbuf, D.gegClass, ADR("strgclass"),
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjGadget+D.gegObjRight,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjTop,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistNorm),
                                     icaMap, ADR(int2propmap),
                                     icaTarget, L.GetGUIGadget(gui, 0, D.gegAddress),
                                     stringaLongVal, 25,
                                     stringaMaxChars, 3, NIL));
      L.SetGUIGadgetA(gui, 0, TAG(tagbuf, icaTarget, L.GetGUIGadget(gui, 1, D.gegAddress), NIL));

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
      END;

    END;
  END;

CLOSE
  IF win # NIL THEN
    L.CloseGUIWindow(win);
    win := NIL;
  END;
END BOOPSIExample.
