(**********************************************************************
:Program.    ResizingDemo.mod
:Contents.   guitools.library demonstration: Resizing, GUITools gadgets
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to GUITools-Documentation
:Language.   Modula-2
:Translator. M2Amiga V4.1
:Remark.     OS 2.0 required
:Remark.     requires guitools.library V38.1
:History.    v1.0  Carsten Ziegeler  17-Mar-94
***********************************************************************)
MODULE ResizingDemo;

(* This example shows, how the gadget descriptions can be used for
   resizable gadgets. It also shows the GUITools gadgets in action ! *)

  FROM SYSTEM     IMPORT ADR, ADDRESS, ASSEMBLE, TAG;
  FROM Arts       IMPORT Assert;
  FROM ExecD      IMPORT MemReqs, MemReqSet, Node, NodePtr, MinList;
  FROM ExecL      IMPORT AllocMem, FreeMem, RemTail, Insert;
  FROM GadToolsD  IMPORT buttonKind, listviewKind, GtTags, NewGadgetFlagSet,
                         NewGadgetFlags, stringKind;
  FROM IntuitionD IMPORT WindowPtr, WindowFlagSet, WindowFlags, IDCMPFlagSet,
                         IDCMPFlags, WaTags;

  FROM GUIToolsD  IMPORT GUIInfoPtr, GUIInfoFlagSet, GUIInfoFlags, guiSet,
                         GuiTags, preserve, bevelboxKind, SgTags, okReqKind,
                         progressIndicatorKind, distNorm, distAbs, objBorder,
                         objGadget, objTop, objBottom, objLeft, objRight;
  FROM GUIToolsL  IMPORT OpenIntWindowTags, CloseIntWindow, CreateGUIInfoTags,
                         CreateGadgetNew, SetGUI, WaitIntMsg, TopazAttr,
                         SimpleReq, ModifyGadget, RemoveGadgets, ClearWindow,
                         guitoolsBase;
  FROM GUIToolsMacros IMPORT GADDESC, GADOBJS;

CONST version = ADR('ResizingDemo 1.0 (17.03.94)\n');

TYPE ListViewArr = ARRAY[0..9] OF ADDRESS;

CONST listviewALabs = ListViewArr{ADR('Amiga 500'), ADR('Amiga 500+'),
                       ADR('Amiga 600'), ADR('Amiga 1000'),
                       ADR('Amiga 1200'), ADR('Amiga 2000'),
                       ADR('Amiga 3000'), ADR('Amiga 4000/030'),
                       ADR('Amiga 4000/040'), ADR('Amiga XXXX/yyy')};
      listviewCLabs = ListViewArr{ADR('2086'), ADR('80286'),
                       ADR('80386'), ADR('80486'),
                       ADR('Pentium'), ADR('MC 68000'),
                       ADR('MC 68020'), ADR('MC 68030'),
                       ADR('MC 68040'), ADR('MC 68060')};

VAR win : WindowPtr;
    gui : GUIInfoPtr;
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
  Assert( (guitoolsBase^.version > 38) OR
         ((guitoolsBase^.version = 38) AND (guitoolsBase^.revision > 0)),
         ADR('At least guitools.library V38.1 required !'));
  CreateLists;
  win := OpenIntWindowTags( 50, 50, 300, 150, ADR('ResizingDemo'),
                            IDCMPFlagSet{gadgetUp, closeWindow, newSize,
                                         refreshWindow, vanillaKey,
                                         gadgetDown},
                            WindowFlagSet{activate, windowSizing,
                                          windowDepth, windowClose,
                                          windowDrag}, NIL,
                            TAG(tagbuf, waMinWidth, 250,
                                        waMinHeight,120,
                                        waMaxWidth, 500,
                                        waMaxHeight,200, NIL));
  IF win # NIL THEN
    (* The doResizing flags says GUITools to self resize the gadgets, and
       the guiUseGadDesc tag says use the objective orientated way to
       define gadgets ! The guiResizableGads tag must also be set for
       resizing ! *)

    gui := CreateGUIInfoTags(win, 5, 0, TAG(tagbuf,
                   guiResizableGads, TRUE,
                   guiUseGadDesc,    TRUE,
                   guiFlags, GUIInfoFlagSet{addBorderDims, doRefresh,
                                            vanillaKeysNotify, convertKeys,
                                            doResizing, listviewNotify},
                   guiGadFont, TopazAttr(), NIL));
    IF gui # NIL THEN
      (* This gadget is always 10 points away from the left, the top and
         the also the right window border. And it is also always 35 points
         away from the bottom window border *)

      CreateGadgetNew(gui, 10, 20, -10, -35, progressIndicatorKind,
            TAG(tagbuf, sgGadgetText, ADR('Progress'),
                        sgGadgetFlags, NewGadgetFlagSet{placetextAbove},
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                              distAbs+objBorder+objTop,
                                              distAbs+objBorder+objRight,
                                              distAbs+objBorder+objBottom),
                        NIL));

      INCL(gui^.flags, addStdUnderscore);

      (* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points right of the window border.
         Its size is constant. *)
      CreateGadgetNew(gui, 10, 10, 70, 18, buttonKind,
            TAG(tagbuf, sgGadgetText, ADR('_Plus'),
                        sgGadgetFlags, NewGadgetFlagSet{placetextIn},
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                              distAbs+objGadget+objBottom,
                                              distNorm,
                                              distNorm),
                        NIL));

      (* This gadget is always 10 points below the progessIndicatorKind
         gadget and always 10 points left of the window border.
         Its size is constant. Now we need the sgGadgetObjects tag,
         because we refer not to the previous gadget !
         To say this gadget is 10 points left of the right window border,
         we must say it is 10+width away from the border !*)
      CreateGadgetNew(gui, -80, 10, 70, 18, buttonKind,
            TAG(tagbuf, sgGadgetText, ADR('_Minus'),
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objRight,
                                              distAbs+objGadget+objBottom,
                                              distNorm,
                                              distNorm),
                        sgGadgetObjects, GADOBJS(0, 0, 0, 0),
                        NIL));

      EXCL(gui^.flags, addStdUnderscore);
      IF SetGUI(gui) = guiSet THEN
        prg := 0;
        LOOP
          WaitIntMsg(gui);

          IF    closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF gadgetUp    IN gui^.msgClass THEN
            IF    gui^.gadID = 1 THEN
              IF prg < 10 THEN INC(prg) END;
              ModifyGadget(gui, 0,TAG(tagbuf, sgpiCurrentValue, prg * 10, NIL));
            ELSIF gui^.gadID = 2 THEN
              IF prg >  0 THEN DEC(prg) END;
              ModifyGadget(gui, 0,TAG(tagbuf, sgpiCurrentValue, prg * 10, NIL));
            END;
          ELSIF newSize     IN gui^.msgClass THEN
            (* This does the doResizing flag for us, but:
               The internal call to RedrawGadgets failt, so EXIT *)
            EXIT;
          END;
        END;
      END;

      (* And now a total new GUI: *)
      RemoveGadgets(gui, TRUE);
      ClearWindow(gui);

      (* We don't know the actual size of the window now, but our GUI was
        designed for the size 300/150, we have to say this to GUITools *)
      gui^.winIWidth := 300;
      gui^.winIHeight:= 150;

      (* This string gadget is for the listview gadget to display the
         selected entry ! To the left and to the right it is 20 points
         away from the window border. *)
      CreateGadgetNew(gui, 20, -45, -20, 13, stringKind,
            TAG(tagbuf, sgGadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                              distAbs+objBorder+objBottom,
                                              distAbs+objBorder+objRight,
                                              distNorm),
                        NIL));

      (* This gadget is always 20 points away from the left and the right
         twindow border. And it is also always 45 points away from the
         bottom window border and 30 from the top window border. *)

      INCL(gui^.flags, addStdUnderscore);
      CreateGadgetNew(gui, 20, 30, -20, -45, listviewKind,
            TAG(tagbuf, sgGadgetText, ADR('_List'),
                        sgGadgetFlags, NewGadgetFlagSet{placetextAbove},
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                              distAbs+objBorder+objTop,
                                              distAbs+objBorder+objRight,
                                              distAbs+objBorder+objBottom),
                        gtlvLabels, ADR(alist),
                        gtlvShowSelected, gui^.gadget, (* the prev. gadget*)
                        NIL));

      (* This gadget is always 10 points below the listviewKind
         gadget and always 20 points right of the window border.
         Its size is constant. *)
      CreateGadgetNew(gui, 20, 10, 70, 18, buttonKind,
            TAG(tagbuf, sgGadgetText, ADR('_Amigas'),
                        sgGadgetFlags, NewGadgetFlagSet{placetextIn},
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                              distAbs+objGadget+objBottom,
                                              distNorm,
                                              distNorm),
                        NIL));

      (* This gadget is always 10 points below the listviewKind gadget
         as the previous gadget is also and always 20 points left of the
         window border. Its size is constant.
         To say this gadget is 20 points left of the right window border,
         we must say it is 20+width away from the border !*)
      CreateGadgetNew(gui, -90, 0, 70, 18, buttonKind,
            TAG(tagbuf, sgGadgetText, ADR('_CPUs'),
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objRight,
                                              distAbs+objGadget+objTop,
                                              distNorm,
                                              distNorm),
                        NIL));

      (* This gadget draws a border around all gadgets which is always
         10 points away from every border *)
      CreateGadgetNew(gui, 10, 10, -10, -10, bevelboxKind,
            TAG(tagbuf, sgbbRecessed, TRUE,
                        sgGadgetDesc, GADDESC(distAbs+objBorder+objLeft,
                                              distAbs+objBorder+objTop,
                                              distAbs+objBorder+objRight,
                                              distAbs+objBorder+objBottom),
                        NIL));
      IF SetGUI(gui) = guiSet THEN
        LOOP
          WaitIntMsg(gui);

          IF    closeWindow IN gui^.msgClass THEN
            EXIT;
          ELSIF gadgetUp    IN gui^.msgClass THEN
            IF    gui^.gadID = 2 THEN  (* Amiga-list *)
              ModifyGadget(gui, 1, TAG(tagbuf, gtlvLabels, ADR(alist), NIL));
            ELSIF gui^.gadID = 3 THEN  (* CPU-list *)
              ModifyGadget(gui, 1, TAG(tagbuf, gtlvLabels, ADR(clist), NIL));
            END;
          ELSIF newSize     IN gui^.msgClass THEN
            (* This does the doResizing flag for us, but:
               The internal call to RedrawGadgets failt, so EXIT *)
            EXIT;
          END;
        END;
      END;
    ELSE
      IF SimpleReq(ADR('Unable to create gui-info-structure !'), okReqKind) = 0 THEN END;
    END;
  ELSE
    IF SimpleReq(ADR('Unable to open window !'), okReqKind) = 0 THEN END;
  END;

CLOSE
  IF win # NIL THEN
    CloseIntWindow(win);
    win := NIL;
  END;
  WHILE alist.tailPred # ADR(alist) DO    (* free lists *)
    FreeMem(RemTail(ADR(alist)), SIZE(Node));
  END;
  WHILE clist.tailPred # ADR(clist) DO    (* free lists *)
    FreeMem(RemTail(ADR(clist)), SIZE(Node));
  END;
END ResizingDemo.
