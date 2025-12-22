(****************************************************************************

$RCSfile: NotifyExample.mod $

$Revision: 1.7 $
    $Date: 1994/12/15 15:36:12 $

    GUIEnvironment example: Notify functions

    M2Amiga Modula-2 Compiler V4.3

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
MODULE NotifyExample;

(* Let's open an own hires-pal-screen with a full-sized window. All gadget-
   kinds from GADTools are displayed. The results will be printed using
   InOut (It's the easiest way !) !*)

(* NotifyExample uses the following catalog strings 1.. : gadgets
                                                    30..: menus
                                                    50..: misc
                                                    100 : END       *)

  FROM SYSTEM     IMPORT ADDRESS, ADR, ASSEMBLE, CAST, TAG, REG;
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
                         PgaTags, SaTags;
  FROM String     IMPORT Copy;


IMPORT D : GUIEnvD,
       L : GUIEnvL,
       GS: GUIEnvSupport;

TYPE CycleArr    = ARRAY[0..4] OF ADDRESS;
     MxArr       = ARRAY[0..3] OF ADDRESS;
     ListViewArr = ARRAY[0..9] OF ADDRESS;

     STRPTR   = POINTER TO ARRAY[0..255] OF CHAR;
     INTPTR   = POINTER TO INTEGER;

     ListViewNode = Node;
     ListViewNodePtr = POINTER TO ListViewNode;

CONST listviewLabs = ListViewArr{ADR("Amiga 500"), ADR("Amiga 500+"),
                       ADR("Amiga 600"), ADR("Amiga 1000"),
                       ADR("Amiga 1200"), ADR("Amiga 2000"),
                       ADR("Amiga 3000"), ADR("Amiga 4000/030"),
                       ADR("Amiga 4000/040"), ADR("Amiga XXXX/yyy")};

      version = ADR("$VER: NotifyExample 37.6 (14.12.94)\n");

VAR S : ScreenPtr;
    W : WindowPtr;
    G : D.GUIInfoPtr;  (* The most important one *)

    buffer : ARRAY[0..22] OF LONGCARD; (* Will contain all the tags *)
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

    cycleLabs := CycleArr{ADR("ZERO"), ADR("ONE"), ADR("TWO"),
                          ADR("THREE"), NIL};
    mxLabs  := MxArr{ADR("Man"), ADR("Woman"), ADR("Child"), NIL};


  (* ATTENTION: Remember, that all these hook functions are in fact
                real Amiga callback hooks, so they all get in A0 the
                hook structure and in A1/A2 the parameters. But as
                we don't need these, the hook functions don't use
                them ! *)

  (* Hook-Function, so we can use also chars which are not letters as
     key-equivalents *)
  PROCEDURE VanKeyHookFct(charCode{10} : LONGINT) : LONGINT;
  (* We get in A2 the character (as a LONGINT) and we return gehKeyUnknown
     for unknown key equivalents and otherwise the gadget number *)
  VAR return : LONGINT;
  BEGIN
    (* MXKind gadgets do not support gadget-text, so we have to immitate
       the key-equivalent.
       We also use for the sliderKind gadget a key-equivalent with the
       + and - keys *)
    CASE CHAR(charCode) OF
      'm' : return := 9;
    | 'M' : return := 9 + D.gehKeyShifted;
    | '+' : return := 8;
    | '-' : return := 8 + D.gehKeyShifted;
    ELSE
      return := D.gehKeyUnknown;
    END;
    RETURN return;
  END VanKeyHookFct;

(* Menu-Functions :
   Usually you have to set LoadA4:=TRUE to have access to all functions
   and variables. GUIEnv does this for us !
   If the result is TRUE, GUIEnv will stay in the waiting-loop, otherwise
   it will return ! *)

  PROCEDURE MenuAbout():BOOLEAN;
  BEGIN
    IGNORE L.GUIRequestA(G, ADR("GUIEnvironment example for version 37.6\n© 1994 C. Ziegeler"),
                         D.gerRTOKKind, TAG(buffer,
                         D.gerLocaleID, 51, NIL));
    (* the return value of a gerOKKind is always 0 *)
    RETURN TRUE;
  END MenuAbout;

  PROCEDURE MenuQuit():BOOLEAN;
  BEGIN
    RETURN L.GUIRequestA(G, ADR("Really quit example ?"),
                         D.gerRTDoItKind, TAG(buffer,
                         D.gerLocaleID, 52, NIL)) # D.gerYes;
  END MenuQuit;

BEGIN

  (* Init liste / same as NewList(ADR(list)) *)
  ASSEMBLE(LEA     list(A4), A0
           MOVE.L  A0,(A0)
           ADDQ.L  #4,(A0)
           CLR.L   4(A0)
           MOVE.L  A0,8(A0)
  END);

  FOR i := 0 TO 9 DO     (* make the list-entries *)
    entry := AllocMem(SIZE(ListViewNode), MemReqSet{memClear});
    IF entry # NIL THEN
      entry^.name := listviewLabs[i];
      Insert(ADR(list), entry, NIL);
    END;
  END;

  (* set the values *)
  (* the string variable is set later because of localization ! *)
  longI  := 33106;
  cycle  := 2;
  mx     := 1;
  check  := TRUE;
  listview := 65535;
  scroller := 1;
  slider   := 5;
  color    := 0;

  (* open screen with Topaz/8-Font! *)
  S := L.OpenGUIScreenA(GS.gesHiresPalID, 2, ADR("GUIEnvExample_Screen"),
                        TAG(buffer, saFont, GS.TopazAttr(), NIL));
  IF S # NIL THEN
    (* And now a full-sized window *)
    W := L.OpenGUIWindowA(0, 0, 640, 256, ADR("GUIEnvironment - NotifyExample"),
                          IDCMPFlagSet{closeWindow, gadgetUp, gadgetDown,
                                       menuPick, refreshWindow, vanillaKey},
                          WindowFlagSet{windowClose, activate}, S,
                          TAG(buffer, D.gewOuterSize, TRUE, NIL));
    IF W # NIL THEN
      (* create GUIInfo *)
      G := L.CreateGUIInfoA(W, TAG(buffer,
                            D.guiVanKeyAHook, ADR(VanKeyHookFct),
                            D.guiCatalogFile, ADR("GUIEnvExamples.catalog"),
                            D.guiGadgetCatalogOffset, 1,
                            D.guiMenuCatalogOffset, 30, NIL));

      IF G # NIL THEN

        (* Is the locale.library installed and the catalog available,
           so change the texts for the cycle and mx gadget *)
        FOR i := 0 TO 3 DO
          cycleLabs[i] := L.GetCatStr(G, 54+i, cycleLabs[i]);
        END;
        FOR i := 0 TO 2 DO
          mxLabs[i] := L.GetCatStr(G, 58+i, mxLabs[i]);
        END;
        Copy(string, STRPTR(L.GetCatStr(G, 68, ADR("This is a text-line !")))^);

        (* If this gadget receives a gadgetUp message, GUIEnv will
           call the given function. Only if this returns FALSE
           GUIEnv will send this message to our message port !! *)
        L.CreateGUIGadgetA(G, 500, 190, 80, 20, buttonKind,
                           TAG(buffer,D.gegFlags, NewGadgetFlagSet{placetextIn},
                                      D.gegText, ADR("_QUIT"),
                                      D.gegUpAHook, ADR(MenuQuit),
                                      D.gegDownAHook, ADR(MenuQuit), NIL));
        L.CreateGUIGadgetA(G, 100, 10, 200, 13, stringKind,
                           TAG(buffer, D.gegText, ADR("S_tring:"),
                                       D.gegFlags, NewGadgetFlagSet{placetextLeft},
                                       D.gegVarAddress, ADR(string),
                                       D.gegStartChain, FALSE,
                                       gtstMaxChars, 80, NIL));
        L.CreateGUIGadgetA(G, 100, 30,  80, 13, integerKind,
                           TAG(buffer, D.gegVarAddress, ADR(longI), (* NOTIFY ! *)
                                       D.gegText, ADR("_Longint:"),
                                       D.gegFlags, NewGadgetFlagSet{placetextLeft},
                                       D.gegEndChain, TRUE,
                                       gtinMaxChars, 7, NIL));
        L.CreateGUIGadgetA(G, 100, 50,  80,15, cycleKind,
                           TAG(buffer, D.gegVarAddress, ADR(cycle), (* NOTIFY *)
                                       D.gegText, ADR("C_ycle It:"),
                                       D.gegFlags, NewGadgetFlagSet{placetextLeft},
                                       gtcyLabels, ADR(cycleLabs), NIL));
        L.CreateGUIGadgetA(G, 270, 90,  0, 0, checkboxKind,
                           TAG(buffer, D.gegVarAddress, ADR(check), (* NOTIFY *)
                                       D.gegFlags, NewGadgetFlagSet{placetextLeft},
                                       D.gegText, ADR("_Check it:"), NIL));
        L.CreateGUIGadgetA(G, 320, 30, 200, 80, listviewKind,
                           TAG(buffer, D.gegVarAddress, ADR(listview),
                                       D.gegText, ADR("Choose List_view-Entry"),
                                       D.gegFlags, NewGadgetFlagSet{placetextAbove},
                                       gtlvLabels, ADR(list),
                                       gtlvShowSelected, NIL, NIL));
        L.CreateGUIGadgetA(G, 20, 130, 600, 14, scrollerKind,
                           TAG(buffer, D.gegText, ADR("_Scroll Me"),
                                       D.gegFlags, NewGadgetFlagSet{placetextAbove},
                                       D.gegVarAddress, ADR(scroller),
                                       gtscTotal, 100,
                                       gaImmediate, TRUE,
                                       gaRelVerify, TRUE,
                                       pgaFreedom, lorientHoriz, NIL));
        L.CreateGUIGadgetA(G, 120, 200, 250, 35, paletteKind,
                           TAG(buffer, D.gegText, ADR("This is a _palette !"),
                                       D.gegFlags, NewGadgetFlagSet{placetextAbove},
                                       gtpaDepth, 2,
                                       D.gegVarAddress, ADR(color),
                                       gtpaIndicatorWidth, 50, NIL));
        L.CreateGUIGadgetA(G, 20, 170, 600, 14, sliderKind,
                           TAG(buffer, D.gegText, ADR("Slider me with + and -"),
                                       D.gegFlags, NewGadgetFlagSet{placetextAbove},
                                       gtslMin, 0,
                                       gtslMax, 200,
                                       D.gegVarAddress, ADR(slider),
                                       gaImmediate, TRUE,
                                       gaRelVerify, TRUE,
                                       pgaFreedom, lorientHoriz, NIL));
        L.CreateGUIGadgetA(G, 100, 80,  80,17, mxKind,
                           TAG(buffer, D.gegFlags, NewGadgetFlagSet{placetextLeft},
                                       D.gegVarAddress, ADR(mx), (* NOTIFY *)
                                       gtmxLabels, ADR(mxLabs), NIL));
        L.CreateGUIGadgetA(G, 120, 68,  10,12, textKind,
                           TAG(buffer, D.gegText, ADR("MX:"),
                                       D.gegFlags, NewGadgetFlagSet{placetextLeft},
                                       gttxText, L.GetCatStr(G, 50, ADR("Try pressing m")), NIL));

        L.CreateGUIMenuEntryA(G, nmTitle, ADR("Project"), NIL);
        L.CreateGUIMenuEntryA(G, nmItem, ADR("About"),
                          TAG(buffer, D.gemAHook, ADR(MenuAbout),
                                      D.gemShortCut, ADR("A\o"), NIL));
        L.CreateGUIMenuEntryA(G, nmItem, ADR("Quit"),
                          TAG(buffer, D.gemAHook, ADR(MenuQuit),
                                      D.gemShortCut, ADR("Q\o"), NIL));

        IF L.DrawGUIA(G, NIL) = D.geDone THEN (* Draw all *)

          LOOP (* Input-Loop *)
            L.WaitGUIMsg(G);
            IF    closeWindow IN G^.msgClass THEN
              IF ~MenuQuit() THEN EXIT END;
            ELSIF (gadgetUp IN G^.msgClass) OR (gadgetDown IN G^.msgClass) THEN
              (* We are only interessed in the buttonGadget !*)
              IF G^.msgGadNbr = 0 THEN  (* ButtonGadget Quit *)
                EXIT;
              END;
            ELSIF menuPick IN G^.msgClass THEN
              (* The procedurs are automatically called within WaitGUIMsg *)
              EXIT;
            END;
          END;

          (* update entry-gadgets *)
          L.GUIGadgetActionA(G, TAG(buffer, D.gegGetVar, D.gegALLGADGETS, NIL));

          (* And now print all values *)
          WriteLn;
          WriteString(STRPTR(L.GetCatStr(G, 61, ADR("Your input:")))^);
          WriteLn;
          WriteString(STRPTR(L.GetCatStr(G, 62, ADR("String  :")))^);
          WriteString(string);
          WriteLn;

          WriteString(STRPTR(L.GetCatStr(G, 63, ADR("Longint :")))^);
          WriteInt(longI, 1);
          WriteLn;

          WriteString("Cycle   :");
          WriteString(CAST(STRPTR, cycleLabs[cycle])^);
          WriteLn;

          WriteString("MX      :");
          WriteString(CAST(STRPTR, mxLabs[mx])^);
          WriteLn;

          IF check THEN
            WriteString(STRPTR(L.GetCatStr(G, 64, ADR("Checkbox:YES")))^);
          ELSE
            WriteString(STRPTR(L.GetCatStr(G, 65, ADR("Checkbox:NO")))^);
          END;
          WriteLn;

          WriteString("Listview:");
          IF listview = 65535 THEN
            WriteString(STRPTR(L.GetCatStr(G, 66, ADR("Nothing")))^);
          ELSE
            WriteString(CAST(STRPTR, listviewLabs[9-listview])^);
            (* The list was created in reverse order ! *)
          END;
          WriteLn;

          WriteString("Slider  :");
          WriteInt(slider, 1);
          WriteLn;

          WriteString("Scroller:");
          WriteInt(scroller, 1);
          WriteLn;

          WriteString(STRPTR(L.GetCatStr(G, 67, ADR("Color   :")))^);
          WriteCard(color, 1);
          WriteLn;

          WriteLn;
        END;
      END;
    END;
  END;

CLOSE
  IF S # NIL THEN
    L.CloseGUIScreen(S); (* The closing of the window etc is done by GUIEnv !*)
  END;
  IF list.tailPred # NIL THEN  (* Did we reach the InitList ? *)
    WHILE list.tailPred # ADR(list) DO    (* free list *)
      FreeMem(RemTail(ADR(list)), SIZE(ListViewNode));
    END;
  END;
END NotifyExample.
