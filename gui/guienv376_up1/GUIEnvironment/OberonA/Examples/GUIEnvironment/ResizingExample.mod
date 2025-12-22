(****************************************************************************

$RCSfile: ResizingExample.mod $

$Revision: 1.4 $
    $Date: 1994/09/30 11:30:30 $

    GUIEnvironment example: Resizing, GUIEnvironment gadgets

    Oberon-A Oberon-2 Compiler V5.18 (Release 1.5)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)

<* STANDARD - *>

MODULE ResizingExample;

(* This example shows, how the gadget descriptions can be used for
   resizable gadgets. It also shows the GUIEnvironment gadgets in action !
   It also shows the simple to use font adaptivity *)

IMPORT SYS := SYSTEM,
       E   := Exec,
       ES  := ExecSupport,
       GT  := GadTools,
       I   := Intuition,

       GUI := GUIEnv,
       GS  := GUIEnvSupport;

CONST version = "$VER: ResizingExample 37.61 (04.02.95)\n";


VAR win : I.WindowPtr;
    gui : GUI.GUIInfoPtr;

    prg : LONGINT;             (* for the progressIndicatorKind *)
    alist,
    clist  : E.MinList;        (* Lists for ListviewKind gadget *)

    listviewCLabs, listviewALabs : ARRAY 10 OF E.LSTRPTR;


  (* Creates two exec.lists. One contains some amiga-models and the other
     some cpu-kinds ! *)
  PROCEDURE CreateLists;
  VAR entry  : E.NodePtr;
      i      : INTEGER;
  BEGIN
    listviewALabs[0] := SYS.ADR("Amiga 500");
    listviewALabs[1] := SYS.ADR("Amiga 500+");
    listviewALabs[2] := SYS.ADR("Amiga 600");
    listviewALabs[3] := SYS.ADR("Amiga 1000");
    listviewALabs[4] := SYS.ADR("Amiga 1200");
    listviewALabs[5] := SYS.ADR("Amiga 2000");
    listviewALabs[6] := SYS.ADR("Amiga 3000");
    listviewALabs[7] := SYS.ADR("Amiga 4000/030");
    listviewALabs[8] := SYS.ADR("Amiga 4000/040");
    listviewALabs[9] := SYS.ADR("Amiga XXXX/yyy");
    listviewCLabs[0] := SYS.ADR("2086");
    listviewCLabs[1] := SYS.ADR("80286");
    listviewCLabs[2] := SYS.ADR("80386");
    listviewCLabs[3] := SYS.ADR("80486");
    listviewCLabs[4] := SYS.ADR("Pentium");
    listviewCLabs[5] := SYS.ADR("68000");
    listviewCLabs[6] := SYS.ADR("68020");
    listviewCLabs[7] := SYS.ADR("68030");
    listviewCLabs[8] := SYS.ADR("68040");
    listviewCLabs[9] := SYS.ADR("68060");

    ES.NewList(alist);
    ES.NewList(clist);

    FOR i := 0 TO 9 DO     (* make the list-entries *)
      entry := E.AllocMem(SIZE(E.Node), {E.memClear});
      IF entry # NIL THEN
        entry^.name := listviewALabs[i];
        E.Insert(alist, entry, NIL);
      END;
      entry := E.AllocMem(SIZE(E.Node), {E.memClear});
      IF entry # NIL THEN
        entry^.name := listviewCLabs[i];
        E.Insert(clist, entry, NIL);
      END;
    END;
  END CreateLists;

BEGIN

  CreateLists;

  win := GUI.OpenGUIWindow( 50, 50, 300, 150, SYS.ADR("GUIEnvironment - ResizingExample"),
                           {I.gadgetUp, I.closeWindow,
                            I.newSize, I.refreshWindow,
                            I.vanillaKey, I.gadgetDown},
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

      (* This gadget is always 10 points away from the left, the top and
         the also the right window border. And it is also always 35 points
         away from the bottom window border *)

      GUI.CreateGUIGadget(gui, 10, 20, -10, -35, GUI.gegProgressIndicatorKind,
                          GUI.gegText, SYS.ADR("Progress"),
                          GUI.gegFlags, {GT.placeTextAbove},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom),
                          NIL);

      (* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points right of the window border.
         Its size is constant. *)
      GUI.CreateGUIGadget(gui, 10, 10, 70, 18, GT.buttonKind,
                          GUI.gegText, SYS.ADR("_Plus"),
                          GUI.gegFlags, {GT.placeTextIn},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjGadget+GUI.gegObjBottom,
                                                         GUI.gegDistNorm,
                                                         GUI.gegDistNorm),
                          NIL);

      (* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points left of the window border.
         Its size is constant. Now we need the gegObjects tag,
         because we don't refer to the previous gadget !
         To say, this gadget is 10 points left of the right window border,
         we must say it is 10+width away from the border !*)
      GUI.CreateGUIGadget(gui, -80, 10, 70, 18, GT.buttonKind,
                          GUI.gegText, SYS.ADR("_Minus"),
                          GUI.gegFlags, {GT.placeTextIn},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjGadget+GUI.gegObjBottom,
                                                         GUI.gegDistNorm,
                                                         GUI.gegDistNorm),
                          GUI.gegObjects, GS.GADOBJS(0, 0, 0, 0),
                          NIL);

      IF GUI.DrawGUI(gui, NIL) = GUI.geDone THEN
        prg := 0;
        LOOP
          GUI.WaitGUIMsg(gui);

          IF    I.closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF (I.gadgetUp   IN gui^.msgClass) OR
                (I.gadgetDown IN gui^.msgClass) THEN
            IF    gui^.msgGadNbr = 1 THEN
              IF prg < 10 THEN INC(prg) END;
              GUI.SetGUIGadget(gui, 0, GUI.gegPICurrentValue, prg * 10, NIL);
            ELSIF gui^.msgGadNbr = 2 THEN
              IF prg >  0 THEN DEC(prg) END;
              GUI.SetGUIGadget(gui, 0, GUI.gegPICurrentValue, prg * 10, NIL);
            END;
          ELSIF I.newSize     IN gui^.msgClass THEN
            (* We only get this message if GUIEnvironment can't resize ! *)
            EXIT;
          END;
        END;
      END;

      (* And now a total new GUI: *)
      IF GUI.ChangeGUI(gui, GUI.guiRemoveGadgets, 1, NIL) = 0 THEN END;

      (* We don't know the actual size of the window now, but our GUI was
        designed for the size 300/150, so we have to say this to GUIEnv.
        We don't want to resize the window, so using the preserve window
        tag tells GUIEnvironment to do so *)
      IF GUI.ChangeGUI(gui, GUI.guiCreationWidth, 300,
                            GUI.guiCreationHeight, 150,
                            GUI.guiPreserveWindow, GUI.guiPWFull, NIL) = 0 THEN END;

      (* This string gadget is for the listview gadget to display the
         selected entry ! To the left and to the right it is 20 points
         away from the window border. *)
      GUI.CreateGUIGadget(gui, 20, -45, -20, 13, GT.stringKind,
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistNorm),
                          NIL);

      (* This gadget is always 20 points away from the left and the right
         window border. And it is also always 45 points away from the
         bottom window border and 30 from the top window border. *)

      GUI.CreateGUIGadget(gui, 20, 30, -20, -45, GT.listViewKind,
                          GUI.gegText, SYS.ADR("_List"),
                          GUI.gegFlags, {GT.placeTextAbove},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom),
                          GT.lvLabels, SYS.ADR(alist),
                          GT.lvShowSelected, GUI.GetGUIGadget(gui, 0, GUI.gegAddress), (* the prev. gadget*)
                          NIL);

      (* This gadget is always 10 points below the listviewKind
         gadget and always 20 points right of the window border.
         Its size is constant. *)
      GUI.CreateGUIGadget(gui, 20, 10, 70, 18, GT.buttonKind,
                          GUI.gegText, SYS.ADR("_Amigas"),
                          GUI.gegFlags, {GT.placeTextIn},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjGadget+GUI.gegObjBottom,
                                                         GUI.gegDistNorm,
                                                         GUI.gegDistNorm),
                          NIL);

      (* This gadget is always 10 points below the listviewKind gadget
         as the previous gadget is also and always 20 points left of the
         window border. Its size is constant.
         To say this gadget is 20 points left of the right window border,
         we must say it is 20+width away from the border !*)
      GUI.CreateGUIGadget(gui, -90, 0, 70, 18, GT.buttonKind,
                          GUI.gegText, SYS.ADR("_CPUs"),
                          GUI.gegFlags, {GT.placeTextIn},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjGadget+GUI.gegObjTop,
                                                         GUI.gegDistNorm,
                                                         GUI.gegDistNorm),
                          NIL);

      (* This gadget draws a border around all gadgets which is always
         10 points away from every border *)
      GUI.CreateGUIGadget(gui, 10, 10, -10, -10, GUI.gegBorderKind,
                          GUI.gegText, SYS.ADR("Choose something"),
                          GUI.gegFlags, {GT.placeTextAbove, GT.highLabel},
                          GUI.gegDescription, GS.GADDESC(GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjLeft,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjTop,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjRight,
                                                         GUI.gegDistAbs+GUI.gegObjBorder+GUI.gegObjBottom),
                          NIL);

      IF GUI.DrawGUI(gui, NIL) = GUI.geDone THEN
        LOOP
          GUI.WaitGUIMsg(gui);

          IF    I.closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF (I.gadgetUp   IN gui^.msgClass) OR
                (I.gadgetDown IN gui^.msgClass) THEN
            IF    gui^.msgGadNbr = 2 THEN  (* Amiga-list *)
              GUI.SetGUIGadget(gui, 1, GT.lvLabels, SYS.ADR(alist), NIL);
            ELSIF gui^.msgGadNbr = 3 THEN  (* CPU-list *)
              GUI.SetGUIGadget(gui, 1, GT.lvLabels, SYS.ADR(clist), NIL);
            END;
          ELSIF I.newSize     IN gui^.msgClass THEN
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
  IF alist.tailPred # NIL THEN
    WHILE alist.tailPred # SYS.ADR(alist) DO    (* free lists *)
      E.FreeMem(E.RemTail(alist), SIZE(E.Node));
    END;
    WHILE clist.tailPred # SYS.ADR(clist) DO    (* free lists *)
      E.FreeMem(E.RemTail(clist), SIZE(E.Node));
    END;
  END;
END ResizingExample.
