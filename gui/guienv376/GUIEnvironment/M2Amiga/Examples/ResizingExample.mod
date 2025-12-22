(****************************************************************************

$RCSfile: ResizingExample.mod $

$Revision: 1.4 $
    $Date: 1994/09/30 15:56:10 $

    GUIEnvironment example: Resizing, GUIEnvironment gadgets, Font adaptive

    M2Amiga Modula-2 Compiler V4.3

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE ResizingExample;

(* This example shows, how the gadget descriptions can be used for
   resizable gadgets. It also shows the GUIEnvironment gadgets in action !
   It also shows the simple to use font adaptivity *)

  FROM SYSTEM     IMPORT ADR, ADDRESS, ASSEMBLE, TAG;
  FROM ExecD      IMPORT MemReqs, MemReqSet, Node, NodePtr, MinList;
  FROM ExecL      IMPORT AllocMem, FreeMem, RemTail, Insert;
  FROM GadToolsD  IMPORT buttonKind, listviewKind, GtTags, NewGadgetFlagSet,
                         NewGadgetFlags, stringKind;
  FROM IntuitionD IMPORT WindowPtr, WindowFlagSet, WindowFlags, IDCMPFlagSet,
                         IDCMPFlags, WaTags;
IMPORT D:GUIEnvD,
       L:GUIEnvL;

  FROM GUIEnvSupport IMPORT GADDESC, GADOBJS, TopazAttr;

CONST version = ADR("$VER: ResizingExample 37.6 (14.12.94)\n");

TYPE ListViewArr = ARRAY[0..9] OF ADDRESS;

CONST listviewALabs = ListViewArr{ADR("Amiga 500"), ADR("Amiga 500+"),
                       ADR("Amiga 600"), ADR("Amiga 1000"),
                       ADR("Amiga 1200"), ADR("Amiga 2000"),
                       ADR("Amiga 3000"), ADR("Amiga 4000/030"),
                       ADR("Amiga 4000/040"), ADR("Amiga XXXX/yyy")};
      listviewCLabs = ListViewArr{ADR("2086"), ADR("80286"),
                       ADR("80386"), ADR("80486"),
                       ADR("Pentium"), ADR("MC 68000"),
                       ADR("MC 68020"), ADR("MC 68030"),
                       ADR("MC 68040"), ADR("MC 68060")};

VAR win : WindowPtr;
    gui : D.GUIInfoPtr;
    tagbuf : ARRAY[0..19] OF LONGCARD;

    prg : INTEGER;           (* for the progressIndicatorKind *)
    alist,
    clist  : MinList;        (* Lists for ListviewKind gadget *)

  (* Creates two exec.lists. One contains some amiga-models and the other
     some cpu-kinds ! *)
  PROCEDURE CreateLists;
  VAR entry  : NodePtr;
      i      : CARDINAL;
  BEGIN
    (* Init amiga-list & cpu-list/ same as NewList(ADR(...)) *)
    ASSEMBLE(LEA     alist(A4), A0
             MOVE.L  A0,(A0)
             ADDQ.L  #4,(A0)
             CLR.L   4(A0)
             MOVE.L  A0,8(A0)
             LEA     clist(A4), A0
             MOVE.L  A0,(A0)
             ADDQ.L  #4,(A0)
             CLR.L   4(A0)
             MOVE.L  A0,8(A0)
    END);
    FOR i := 0 TO 9 DO     (* make the list-entries *)
      entry := AllocMem(SIZE(Node), MemReqSet{memClear});
      IF entry # NIL THEN
        entry^.name := listviewALabs[i];
        Insert(ADR(alist), entry, NIL);
      END;
      entry := AllocMem(SIZE(Node), MemReqSet{memClear});
      IF entry # NIL THEN
        entry^.name := listviewCLabs[i];
        Insert(ADR(clist), entry, NIL);
      END;
    END;
  END CreateLists;

BEGIN
  CreateLists;

  win := L.OpenGUIWindowA( 50, 50, 300, 150, ADR("GUIEnvironment - ResizingExample"),
                          IDCMPFlagSet{gadgetUp, closeWindow, newSize,
                                       refreshWindow, vanillaKey, gadgetDown},
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

      (* This gadget is always 10 points away from the left, the top and
         the also the right window border. And it is also always 35 points
         away from the bottom window border *)

      L.CreateGUIGadgetA(gui, 10, 20, -10, -35, D.gegProgressIndicatorKind,
                         TAG(tagbuf, D.gegText, ADR("Progress"),
                                     D.gegFlags, NewGadgetFlagSet{placetextAbove},
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjTop,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjBottom),
                             NIL));

      (* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points right of the window border.
         Its size is constant. *)
      L.CreateGUIGadgetA(gui, 10, 10, 70, 18, buttonKind,
                         TAG(tagbuf, D.gegText, ADR("_Plus"),
                                     D.gegFlags, NewGadgetFlagSet{placetextIn},
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                           D.gegDistAbs+D.gegObjGadget+D.gegObjBottom,
                                                           D.gegDistNorm,
                                                           D.gegDistNorm),
                             NIL));

      (* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points left of the window border.
         Its size is constant. Now we need the gegObjects tag,
         because we don't refer to the previous gadget !
         To say, this gadget is 10 points left of the right window border,
         we must say it is 10+width away from the border !*)
      L.CreateGUIGadgetA(gui, -80, 10, 70, 18, buttonKind,
                         TAG(tagbuf, D.gegText, ADR("_Minus"),
                                     D.gegFlags, NewGadgetFlagSet{placetextIn},
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistAbs+D.gegObjGadget+D.gegObjBottom,
                                                               D.gegDistNorm,
                                                               D.gegDistNorm),
                                     D.gegObjects, GADOBJS(0, 0, 0, 0),
                         NIL));

      IF L.DrawGUIA(gui, NIL) = D.geDone THEN
        prg := 0;
        LOOP
          L.WaitGUIMsg(gui);

          IF    closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF gadgetUp    IN gui^.msgClass THEN
            IF    gui^.msgGadNbr = 1 THEN
              IF prg < 10 THEN INC(prg) END;
              L.SetGUIGadgetA(gui, 0, TAG(tagbuf, D.gegPICurrentValue, prg * 10, NIL));
            ELSIF gui^.msgGadNbr = 2 THEN
              IF prg >  0 THEN DEC(prg) END;
              L.SetGUIGadgetA(gui, 0, TAG(tagbuf, D.gegPICurrentValue, prg * 10, NIL));
            END;
          ELSIF newSize     IN gui^.msgClass THEN
            (* We only get this message if GUIEnvironment can't resize ! *)
            EXIT;
          END;
        END;
      END;

      (* And now a total new GUI: *)
      IGNORE L.ChangeGUIA(gui, TAG(tagbuf, D.guiRemoveGadgets, TRUE, NIL));

      (* We don't know the actual size of the window now, but our GUI was
        designed for the size 300/150, so we have to say this to GUIEnv.
        We don't want to resize the window, so using the preserve window
        tag tells GUIEnvironment to do so *)
      IGNORE L.ChangeGUIA(gui, TAG(tagbuf, D.guiCreationWidth, 300,
                                           D.guiCreationHeight, 150,
                                           D.guiPreserveWindow, D.guiPWFull, NIL));

      (* This string gadget is for the listview gadget to display the
         selected entry ! To the left and to the right it is 20 points
         away from the window border. *)
      L.CreateGUIGadgetA(gui, 20, -45, -20, 13, stringKind,
                         TAG(tagbuf, D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjBottom,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistNorm),
                         NIL));

      (* This gadget is always 20 points away from the left and the right
         window border. And it is also always 45 points away from the
         bottom window border and 30 from the top window border. *)

      L.CreateGUIGadgetA(gui, 20, 30, -20, -45, listviewKind,
                         TAG(tagbuf, D.gegText, ADR("_List"),
                                     D.gegFlags, NewGadgetFlagSet{placetextAbove},
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjTop,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistAbs+D.gegObjBorder+D.gegObjBottom),
                                     gtlvLabels, ADR(alist),
                                     gtlvShowSelected, L.GetGUIGadget(gui, 0, D.gegAddress), (* the prev. gadget*)
                         NIL));

      (* This gadget is always 10 points below the listviewKind
         gadget and always 20 points right of the window border.
         Its size is constant. *)
      L.CreateGUIGadgetA(gui, 20, 10, 70, 18, buttonKind,
                         TAG(tagbuf, D.gegText, ADR("_Amigas"),
                                     D.gegFlags, NewGadgetFlagSet{placetextIn},
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                               D.gegDistAbs+D.gegObjGadget+D.gegObjBottom,
                                                               D.gegDistNorm,
                                                               D.gegDistNorm),
                         NIL));

      (* This gadget is always 10 points below the listviewKind gadget
         as the previous gadget is also and always 20 points left of the
         window border. Its size is constant.
         To say this gadget is 20 points left of the right window border,
         we must say it is 20+width away from the border !*)
      L.CreateGUIGadgetA(gui, -90, 0, 70, 18, buttonKind,
                         TAG(tagbuf, D.gegText, ADR("_CPUs"),
                                     D.gegFlags, NewGadgetFlagSet{placetextIn},
                                     D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                               D.gegDistAbs+D.gegObjGadget+D.gegObjTop,
                                                               D.gegDistNorm,
                                                               D.gegDistNorm),
                         NIL));

      (* This gadget draws a border around all gadgets which is always
         10 points away from every border *)
      L.CreateGUIGadgetA(gui, 10, 10, -10, -10, D.gegBorderKind,
                         TAG(tagbuf,  D.gegText, ADR("Choose something"),
                                      D.gegFlags, NewGadgetFlagSet{placetextAbove, ngHighlabel},
                                      D.gegDescription, GADDESC(D.gegDistAbs+D.gegObjBorder+D.gegObjLeft,
                                                                D.gegDistAbs+D.gegObjBorder+D.gegObjTop,
                                                                D.gegDistAbs+D.gegObjBorder+D.gegObjRight,
                                                                D.gegDistAbs+D.gegObjBorder+D.gegObjBottom),
                         NIL));

      IF L.DrawGUIA(gui, NIL) = D.geDone THEN
        LOOP
          L.WaitGUIMsg(gui);

          IF    closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF gadgetUp    IN gui^.msgClass THEN
            IF    gui^.msgGadNbr = 2 THEN  (* Amiga-list *)
              L.SetGUIGadgetA(gui, 1, TAG(tagbuf, gtlvLabels, ADR(alist), NIL));
            ELSIF gui^.msgGadNbr = 3 THEN  (* CPU-list *)
              L.SetGUIGadgetA(gui, 1, TAG(tagbuf, gtlvLabels, ADR(clist), NIL));
            END;
          ELSIF newSize     IN gui^.msgClass THEN
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
  IF alist.tailPred # NIL THEN  (* Did we reach the InitList ? *)
    WHILE alist.tailPred # ADR(alist) DO    (* free lists *)
      FreeMem(RemTail(ADR(alist)), SIZE(Node));
    END;
    WHILE clist.tailPred # ADR(clist) DO    (* free lists *)
      FreeMem(RemTail(ADR(clist)), SIZE(Node));
    END;
  END;
END ResizingExample.
