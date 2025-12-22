(**********************************************************************
:Program.    NotifyDemo.mod
:Contents.   guitools.library demonstration: Notify functions
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to documentation
:Language.   Modula-2
:Translator. M2Amiga V4.1
:Remark.     OS 2.0 required
:Remark.     requires guitools.library V38.0
:History.    v1.0  Carsten Ziegeler  17-Mar-94
***********************************************************************)
MODULE NotifyDemo;

(* Let's open an own hires-pal-screen with a full-sized window. All gadget-
   kinds from GADTools are displayed. The results will be printed using
   InOut (It's the easiest way !) !*)

  FROM SYSTEM     IMPORT ADDRESS, ADR, ASSEMBLE, CAST, TAG, SETREG, REG;
  FROM Arts       IMPORT Assert;
  FROM ExecD      IMPORT MemReqSet, MemReqs, MinList, Node;
  FROM ExecL      IMPORT AllocMem, FreeMem, RemTail, Insert;
  FROM GadToolsD  IMPORT stringKind, integerKind, mxKind, checkboxKind,
                         cycleKind, GtTags, NewGadgetFlagSet, NewGadgetFlags,
                         nmTitle, nmItem, buttonKind, textKind, listviewKind,
                         scrollerKind, sliderKind, paletteKind;
  FROM InOut      IMPORT WriteString, WriteLn, WriteInt, WriteCard;
  FROM IntuitionD IMPORT WindowPtr, ScreenPtr, WindowFlagSet, WindowFlags,
                         IDCMPFlagSet, IDCMPFlags, GaTags, lorientHoriz,
                         PgaTags;

  FROM GUIToolsD  IMPORT GUIInfoPtr, asScreen, guiSet, GUIInfoFlagSet,
                         GUIInfoFlags, hiresPalID, GuiTags, okReqKind,
                         doitReqKind, reqDo, reqOK;
  FROM GUIToolsL  IMPORT OpenIntScreen, CloseIntScreen, OpenIntWindow,
                         CreateGUIInfoTags, SetGUI, TopazAttr,
                         CreateGadgetFull, CreateGadgetText, CreateGadget,
                         UpdateEntryGadgets, MakeMenuEntry, WaitIntMsg,
                         ShowRequester, guitoolsBase, ShowRequesterP;

CONST A0 = 8; A1 = 9; D0 = 0; A4 = 12;

TYPE CycleArr    = ARRAY[0..4] OF ADDRESS;
     MxArr       = ARRAY[0..3] OF ADDRESS;
     ListViewArr = ARRAY[0..9] OF ADDRESS;

     STRPTR   = POINTER TO ARRAY[0..19] OF CHAR;
     INTPTR   = POINTER TO INTEGER;

     ListViewNode = Node;
     ListViewNodePtr = POINTER TO ListViewNode;

CONST cycleLabs = CycleArr{ADR('ZERO'), ADR('ONE'), ADR('TWO'),
                           ADR('THREE'), NIL};
      mxLabs    = MxArr{ADR('Man'), ADR('Woman'), ADR('Child'), NIL};
      listviewLabs = ListViewArr{ADR('Amiga 500'), ADR('Amiga 500+'),
                       ADR('Amiga 600'), ADR('Amiga 1000'),
                       ADR('Amiga 1200'), ADR('Amiga 2000'),
                       ADR('Amiga 3000'), ADR('Amiga 4000/030'),
                       ADR('Amiga 4000/040'), ADR('Amiga XXXX/yyy')};

      version = ADR('$VER: NotifyDemo 1.0 (17.03.94)\n');

VAR S : ScreenPtr;
    W : WindowPtr;
    G : GUIInfoPtr;  (* The most important one *)

    buffer : ARRAY[0..12] OF LONGCARD; (* Will contain all the tags *)
    list   : MinList;        (* List for ListviewKind-Gadget *)
    entry  : ListViewNodePtr;
    i : INTEGER;

(* Variables for the entry-fields *)
    string : ARRAY[0..79] OF CHAR;
    longI  : LONGINT;
    cycle  : CARDINAL;
    mx     : CARDINAL;
    check  : BOOLEAN;
    listview : CARDINAL;
    scroller : INTEGER;
    slider   : INTEGER;
    color    : CARDINAL;

  (* Hook-Function, so we can use also chars which are not letters as
     key-equivalents *)
  PROCEDURE VanKeyHookFct(char{D0} : CHAR; nbr{A0} : INTPTR;
                          shifted{A1} : INTPTR) : BOOLEAN;
  (* We get in D0 the key. This function will put in A0 the gadget-number
     that corresponds to the key and we will put in A1 if the key should
     be treated as shifted (1).
     If the key can be evaluated, the result is TRUE, otherwise FALSE.
     We don't need LoadA4:=TRUE, because no global data is used *)
  BEGIN
    (* MXKind-gadgets do not support gadget-text, so we have to immitate
       the key-equivalent.
       We also use for the sliderKind-gadget a key-equivalent with the
       + and - keys *)
    IF    char = 'm' THEN
      nbr^ := 9;
      shifted^ := 0;
      RETURN TRUE;
    ELSIF char = 'M' THEN
      nbr^ := 9;
      shifted^ := 1;
      RETURN TRUE;
    ELSIF char = '+' THEN
      nbr^ := 8;
      shifted^ := 0;
      RETURN TRUE;
    ELSIF char = '-' THEN
      nbr^ := 8;
      shifted^ := 1;
      RETURN TRUE;
    END;
    RETURN FALSE;
  END VanKeyHookFct;

(* Menu-Functions :
   Usually you have to set LoadA4:=TRUE to have access to all functions
   and variables.
   These menu functions use the a feature of guitools.library version 38.1:
   The functions get in A0 a user data pointer which is set to the GUIInfo
   structure G. This structure contains the compilerReg field which is
   set to A4 when creating the GUIInfo structure ! So we simply have to
   set A4 to the value in G^.compilerReg ! But now SaveA4:=TRUE is required
   to set A4 back when exiting ! But now this program can be reentrant !
   If the result is TRUE, GUITools will stay in the waiting-loop, otherwise
   it will return ! *)

  PROCEDURE MenuAbout(data{A0} : GUIInfoPtr):BOOLEAN;
  (*$ SaveA4:=TRUE *)
  BEGIN
    SETREG(A4, data^.compilerReg);
    ShowRequesterP(data,
                   ADR('GUITools-Demo for Version 38.0\nGUITools © C.Ziegeler'),
                   okReqKind, NIL);
    (* the return value of a okReqKind is always 0 *)
    RETURN TRUE;
  END MenuAbout;

  PROCEDURE MenuQuit(data{A0} : GUIInfoPtr):BOOLEAN;
  (*$ SaveA4:=TRUE *)
  BEGIN
    SETREG(A4, data^.compilerReg);
    RETURN ShowRequester(data, ADR('Really quit demo ?'),
                         doitReqKind, NIL) # reqDo;
  END MenuQuit;

BEGIN

  (* Init liste / same as NewList(ADR(list)) *)
  ASSEMBLE(LEA     list(A4), A0
           MOVE.L  A0,(A0)
           ADDQ.L  #4,(A0)
           CLR.L   4(A0)
           MOVE.L  A0,8(A0)
  END);
  Assert(guitoolsBase^.version>37, ADR('guitools.library V38 required !'));

  FOR i := 0 TO 9 DO     (* make the list-entries *)
    entry := AllocMem(SIZE(ListViewNode), MemReqSet{memClear});
    IF entry # NIL THEN
      entry^.name := listviewLabs[i];
      Insert(ADR(list), entry, NIL);
    END;
  END;

  (* set the values *)
  string := 'This is a text-line !';
  longI  := 33106;
  cycle  := 2;
  mx     := 1;
  check  := TRUE;
  listview := 65535;
  scroller := 1;
  slider   := 5;
  color    := 0;

  (* open screen with Topaz/8-Font! *)
  S := OpenIntScreen(hiresPalID, 2, ADR('Test_Screen'), TopazAttr());
  IF S # NIL THEN
    (* And now a full-sized window *)
    W := OpenIntWindow(0, 0, asScreen, asScreen, ADR('GUITools-Demo'),
                       IDCMPFlagSet{closeWindow, gadgetUp, gadgetDown,
                                    menuPick, refreshWindow, vanillaKey},
                       WindowFlagSet{windowClose, activate}, S);
    IF W # NIL THEN
      (* create GUIInfo *)
      G := CreateGUIInfoTags(W, 20, 20,  (* max 20 gadgets and menuitems *)
             TAG(buffer, guiFlags, GUIInfoFlagSet{stringNotify,
                                                  integerNotify,
                                                  mxNotify,
                 (* Notify for all gadgets *)     cycleNotify,
                                                  checkboxNotify,
                                                  listviewNotify,
                                                  sliderNotify,
                                                  scrollerNotify,
                                                  paletteNotify,
                 (* conect entry-gadgets *)       linkEntryGads,
                                                  cycleEntryGads,
                 (* GUITools will do refresh *)   doRefresh,
                 (* notify key-Equivalents *)     vanillaKeysNotify,
                 (* internal: key-msg to gad-Msg *)  convertKeys,
                 (* only interesting msgs *)      internMsgHandling,
                 (* use the hook-function *)      callVanillaKeyFct,
                 (* Call the function that *)     callMenuData,
                 (* the userData contains *)
                 (* add gtUnderscore-tag *)       addStdUnderscore},
                         guiVanKeyFct, ADR(VanKeyHookFct),
                         guiCompilerReg, REG(A4), NIL));
      IF G # NIL THEN
        CreateGadgetFull(G, 500, 200, 80, 20, buttonKind, ADR('_QUIT'),
                         NewGadgetFlagSet{placetextIn}, NIL);
        CreateGadgetFull(G, 100, 20, 200, 13, stringKind, ADR('S_tring:'),
                         NewGadgetFlagSet{placetextLeft}, TAG(buffer,
                           gtstString, ADR(string),
                           gtstMaxChars, 80, NIL));
        CreateGadgetText(G, 100, 40,  80, 13, integerKind, ADR('_Longint:'),
                         TAG(buffer, gtinNumber, ADR(longI), (* NOTIFY ! *)
                                     gtinMaxChars, 7, NIL));
        CreateGadgetText(G, 100, 60,  80,15, cycleKind, ADR('C_ycle It:'),
                         TAG(buffer, gtcyActive, ADR(cycle), (* NOTIFY *)
                                     gtcyLabels, ADR(cycleLabs),
                                     NIL));
        CreateGadgetText(G, 270, 100,  0, 0, checkboxKind, ADR('_Check it:'),
                         TAG(buffer, gtcbChecked, ADR(check), (* NOTIFY *)
                             NIL));
        CreateGadgetFull(G, 320, 40, 200, 80, listviewKind,
                         ADR('Choose List_view-Entry'),
                         NewGadgetFlagSet{placetextAbove},
                         TAG(buffer, gtlvSelected, ADR(listview),
                                     gtlvLabels, ADR(list),
                                     gtlvShowSelected, NIL, NIL));
        CreateGadgetText(G, 20, 140, 600, 14, scrollerKind,
                         ADR('_Scroll Me'), TAG(buffer,
                           gtscTop, ADR(scroller),
                           gtscTotal, 100,
                           gaImmediate, TRUE,
                           gaRelVerify, TRUE,
                           pgaFreedom, lorientHoriz, NIL));
        CreateGadgetText(G, 120, 210, 250, 35, paletteKind,
                         ADR('This is a _palette !'),
                         TAG(buffer, gtpaDepth, 2,
                                     gtpaColor, ADR(color),
                                     gtpaIndicatorWidth, 50, NIL));
        EXCL(G^.flags, addStdUnderscore);     (* Not possible for mxKind !
                                                 and not desired for
                                                 sliderKind ! *)
        CreateGadgetText(G, 20, 180, 600, 14, sliderKind,
                         ADR('Slider me with + and -'), TAG(buffer,
                           gtslMin, 0,
                           gtslMax, 200,
                           gtslLevel, ADR(slider),
                           gaImmediate, TRUE,
                           gaRelVerify, TRUE,
                           pgaFreedom, lorientHoriz, NIL));
        CreateGadgetFull(G, 100, 90,  80,17, mxKind, NIL,
                         NewGadgetFlagSet{placetextLeft},
                         TAG(buffer, gtmxActive, ADR(mx), (* NOTIFY *)
                                     gtmxLabels, ADR(mxLabs), NIL));
        CreateGadgetText(G, 120, 78,  10,12, textKind, ADR('MX:'),
                         TAG(buffer, gttxText, ADR('Try pressing m'), NIL));

        MakeMenuEntry(G, nmTitle, ADR('Project'), NIL);
        MakeMenuEntry(G, nmItem,  ADR('About'), ADR('A'));
        G^.menuAdr^.userData := ADR(MenuAbout);
        MakeMenuEntry(G, nmItem,  ADR('Quit'), ADR('Q'));
        G^.menuAdr^.userData := ADR(MenuQuit);

        IF SetGUI(G) = guiSet THEN (* Draw all *)

          LOOP (* Input-Loop *)
            WaitIntMsg(G);
            IF    closeWindow IN G^.msgClass THEN
              EXIT;
            ELSIF gadgetUp IN G^.msgClass THEN
              (* We are only interessed in the buttonGadget !*)
              IF G^.gadID = 0 THEN  (* ButtonGadget Quit *)
                EXIT;
              END;
            ELSIF menuPick IN G^.msgClass THEN
              (* The procedurs are automatically called within WaitIntMsg,
                 because callMenuData is set *)
              EXIT;
            END;
          END;

          UpdateEntryGadgets(G); (* update entry-gadgets *)

          (* And now print all values *)
          WriteString('\nYour input:\n');
          WriteString('String   : ');
          WriteString(string);
          WriteLn;

          WriteString('Longint  : ');
          WriteInt(longI, 1);
          WriteLn;

          WriteString('Cycle    : ');
          WriteString(CAST(STRPTR, cycleLabs[cycle])^);
          WriteLn;

          WriteString('MX       : ');
          WriteString(CAST(STRPTR, mxLabs[mx])^);
          WriteLn;

          WriteString('Check    : ');
          IF check THEN WriteString('YES') ELSE WriteString('NO') END;
          WriteLn;

          WriteString('Listview : ');
          IF listview = 65535 THEN
            WriteString('nothing\n');
          ELSE
            WriteString(CAST(STRPTR, listviewLabs[9-listview])^);
            (* The list was created in reverse order ! *)
            WriteLn;
          END;

          WriteString('Slider   : ');
          WriteInt(slider, 1);
          WriteLn;

          WriteString('Scroller : ');
          WriteInt(scroller, 1);
          WriteLn;

          WriteString('Color    : ');
          WriteCard(color, 1);
          WriteLn;

          WriteLn;
        END;
      END;
    END;
  END;

CLOSE
  IF S # NIL THEN
    CloseIntScreen(S); (* The closing of the window etc is done by GUITools !*)
  END;
  WHILE list.tailPred # ADR(list) DO    (* free list *)
    FreeMem(RemTail(ADR(list)), SIZE(ListViewNode));
  END;
END NotifyDemo.
