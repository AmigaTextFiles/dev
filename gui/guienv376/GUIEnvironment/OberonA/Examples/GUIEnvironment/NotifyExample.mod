(****************************************************************************

$RCSfile: NotifyExample.mod $

$Revision: 1.7 $
    $Date: 1994/12/15 15:33:41 $

    GUIEnvironment example: Notify functions

    Oberon-A Oberon-2 Compiler V4.17 (Release 1.4 Update 2)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany


****************************************************************************)
MODULE NotifyExample;

(* $P- Allow non-portable code *)

(* Let's open an own hires-pal-screen with a full-sized window. All gadget-
   kinds from GADTools are displayed. The results will be printed using
   StdIO (It's the easiest way !) !*)

(* NotifyExample uses the following catalog strings 1.. : gadgets
                                                    30..: menus
                                                    50..: misc
                                                    100 : END       *)

IMPORT SYS := SYSTEM,
       E   := Exec,
       EU  := ExecUtil,
       GT  := GadTools,
       HU  := HookUtil,
       I   := Intuition,
       IO  := StdIO,
       Str := Strings,

       GUI := GUIEnv,
       GS  := GUIEnvSupport;

TYPE CycleArr    = ARRAY 5 OF E.STRPTR;
     MxArr       = ARRAY 4 OF E.STRPTR;
     ListViewArr = ARRAY 11 OF E.STRPTR;

     INTPTR   = CPOINTER TO INTEGER;

     ListViewNode = E.Node;
     ListViewNodePtr = CPOINTER TO ListViewNode;


CONST version = "$VER: NotifyExample 37.6 (15.12.94)\n";

VAR S : I.ScreenPtr;
    W : I.WindowPtr;
    G : GUI.GUIInfoPtr;  (* The most important one *)

    list   : E.MinList;        (* List for ListviewKind-Gadget *)
    entry  : ListViewNodePtr;
    i : INTEGER;

(* Variables for the entry-fields *)
    string : ARRAY 80 OF CHAR;
    longI  : LONGINT;
    cycle  : INTEGER;
    mx     : INTEGER;
    check  : BOOLEAN;
    listview : INTEGER;
    scroller : INTEGER;
    slider   : INTEGER;
    color    : INTEGER;

    cycleLabs: CycleArr;
    mxLabs   : MxArr;
    listviewLabs : ListViewArr;

    strPTR : E.STRPTR;

  (* Hook-Function, so we can use also chars which are not letters as
     key-equivalents !
     Remember, that GUIEnv sets the A4 reg for us ! *)
  PROCEDURE VanKeyHookFct(hook : E.APTR;
                          key  : LONGINT;
                          unused: E.APTR) : LONGINT;
  TYPE KEYARR = ARRAY 4 OF CHAR;
  VAR return : LONGINT;
      chars  : KEYARR;
  BEGIN
    (* MXKind gadgets do not support gadget-text, so we have to immitate
       the key-equivalent.
       We also use for the sliderKind gadget a key-equivalent with the
       + and - keys *)

    (* This type casting method is required, because it is not possible
       in the current version of Oberon-A, to do a SYS.VAL(CHAR, key) *)
    chars := SYS.VAL(KEYARR, key);
    CASE chars[3] OF
      'm' : return := 9;
    | 'M' : return := 9 + GUI.gehKeyShifted;
    | '+' : return := 8;
    | '-' : return := 8 + GUI.gehKeyShifted;
    ELSE
      return := GUI.gehKeyUnknown;
    END;
    RETURN return;
  END VanKeyHookFct;

(* Menu-Functions :
   Usually you have to set the A4 register to have access to all functions
   and variables. GUIEnv does this for us !
   If the result is TRUE, GUIEnv will stay in the waiting-loop, otherwise
   it will return ! *)

  PROCEDURE MenuAbout(hook, unused1, unused2 : E.APTR):LONGINT;
  BEGIN
    IF GUI.base.GUIRequest(G, SYS.ADR("GUIEnvironment example for version 37.6\n© 1994 C. Ziegeler"),
                           GUI.gerRTOKKind,
                           GUI.gerLocaleID, 51, NIL) = GUI.gerCancel THEN END;
    (* the return value of a okReqKind is always 0 *)
    RETURN 1;
  END MenuAbout;

  PROCEDURE MenuQuit(hook, unused1, unused2 : E.APTR):LONGINT;
  BEGIN
    IF GUI.base.GUIRequest(G, SYS.ADR("Really quit example ?"),
                           GUI.gerRTDoItKind,
                           GUI.gerLocaleID, 52, NIL) = GUI.gerYes THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END;
  END MenuQuit;

BEGIN

  GUI.OpenLib(TRUE);

  EU.NewList(list);

  cycleLabs[0] := SYS.ADR("Zero");
  cycleLabs[1] := SYS.ADR("One");
  cycleLabs[2] := SYS.ADR("Two");
  cycleLabs[3] := SYS.ADR("Three");
  cycleLabs[4] := NIL;
  mxLabs[0] := SYS.ADR("Man");
  mxLabs[1] := SYS.ADR("Woman");
  mxLabs[2] := SYS.ADR("Child");
  mxLabs[3] := NIL;
  listviewLabs[0] := SYS.ADR("Amiga 500");
  listviewLabs[1] := SYS.ADR("Amiga 500+");
  listviewLabs[2] := SYS.ADR("Amiga 600");
  listviewLabs[3] := SYS.ADR("Amiga 1000");
  listviewLabs[4] := SYS.ADR("Amiga 1200");
  listviewLabs[5] := SYS.ADR("Amiga 2000");
  listviewLabs[6] := SYS.ADR("Amiga 3000");
  listviewLabs[7] := SYS.ADR("Amiga 4000/030");
  listviewLabs[8] := SYS.ADR("Amiga 4000/040");
  listviewLabs[9] := SYS.ADR("Amiga XXXX/yyy");
  listviewLabs[10] := NIL;

  FOR i := 0 TO 9 DO     (* make the list-entries *)
    entry := E.base.AllocMem(SIZE(ListViewNode), {E.memClear});
    IF entry # NIL THEN
      entry^.name := listviewLabs[i];
      E.base.Insert(list, entry, NIL);
    END;
  END;

  (* set the values *)
  (* the string variable is set later because of localization ! *)
  longI  := 33106;
  cycle  := 2;
  mx     := 1;
  check  := TRUE;
  listview := -1;
  scroller := 1;
  slider   := 5;
  color    := 0;

  (* open screen with Topaz/8-Font! *)
  S := GUI.base.OpenGUIScreen(GS.gesHiresPalID, 2,
                              SYS.ADR("GUIEnvExample_Screen"),
                              I.saFont, GS.TopazAttr(), NIL);
  IF S # NIL THEN
    (* And now a full-sized window *)
    W := GUI.base.OpenGUIWindow(0, 0, 640, 256,
                                SYS.ADR("GUIEnvironment - NotifyExample"),
                                {I.idcmpCloseWindow, I.idcmpGadgetUp,
                                 I.idcmpGadgetDown, I.idcmpMenuPick,
                                 I.idcmpRefreshWindow, I.idcmpVanillaKey},
                                {I.wflgCloseGadget, I.wflgActivate}, S,
                                GUI.gewOuterSize, 1, NIL);
    IF W # NIL THEN
      (* create GUIInfo *)
      G := GUI.base.CreateGUIInfo(W,
                  (* The hook interface is very important ! Without it
                     GUIEnvironment passes the parameters in the registers
                     and not using the stack ! *)
                            GUI.guiHookInterface, SYS.ADR(HU.HookEntry),
                            GUI.guiVanKeyAHook, SYS.ADR(VanKeyHookFct),
                            GUI.guiCatalogFile, SYS.ADR("GUIEnvExamples.catalog"),
                            GUI.guiGadgetCatalogOffset, 1,
                            GUI.guiMenuCatalogOffset, 30, NIL);

      IF G # NIL THEN

        (* Is the locale.library installed and the catalog available,
           so change the texts for the cycle and mx gadget *)
        FOR i := 0 TO 3 DO
          cycleLabs[i] := GUI.base.GetCatStr(G, 54+i, cycleLabs[i]);
        END;
        FOR i := 0 TO 2 DO
          mxLabs[i] := GUI.base.GetCatStr(G, 58+i, mxLabs[i]);
        END;

        (* Copy text to string ! I tried to use Strings.Insert directly
           but it failt ! *)
        strPTR := GUI.base.GetCatStr(G, 68, SYS.ADR("This is a text-line !"));
        Str.Insert(string, strPTR^, 0);

        (* If this gadget receives a gadgetUp message, GUIEnv will
           call the given function. Only if this returns FALSE
           GUIEnv will send this message to our message port !! *)
        GUI.base.CreateGUIGadget(G, 500, 190, 80, 20, GT.buttonKind,
                                 GUI.gegFlags, {GT.placeTextIn},
                                 GUI.gegText, SYS.ADR("_QUIT"),
                                 GUI.gegUpAHook, SYS.ADR(MenuQuit),
                                 GUI.gegDownAHook, SYS.ADR(MenuQuit), NIL);
        GUI.base.CreateGUIGadget(G, 100, 10, 200, 13, GT.stringKind,
                                 GUI.gegText, SYS.ADR("S_tring:"),
                                 GUI.gegFlags, {GT.placeTextLeft},
                                 GUI.gegVarAddress, SYS.ADR(string),
                                 GUI.gegStartChain, 0,
                                 GT.stMaxChars, 80, NIL);
        GUI.base.CreateGUIGadget(G, 100, 30,  80, 13, GT.integerKind,
                                 GUI.gegVarAddress, SYS.ADR(longI),
                                 GUI.gegText, SYS.ADR("_Longint:"),
                                 GUI.gegEndChain, 1,
                                 GUI.gegFlags, {GT.placeTextLeft},
                                 GT.inMaxChars, 7, NIL);
        GUI.base.CreateGUIGadget(G, 100, 50,  80,15, GT.cycleKind,
                                 GUI.gegVarAddress, SYS.ADR(cycle),
                                 GUI.gegText, SYS.ADR("C_ycle It:"),
                                 GUI.gegFlags, {GT.placeTextLeft},
                                 GT.cyLabels, SYS.ADR(cycleLabs), NIL);
        GUI.base.CreateGUIGadget(G, 270, 90,  0, 0, GT.checkBoxKind,
                                 GUI.gegVarAddress, SYS.ADR(check),
                                 GUI.gegFlags, {GT.placeTextLeft},
                                 GUI.gegText, SYS.ADR("_Check it:"), NIL);
        GUI.base.CreateGUIGadget(G, 320, 30, 200, 80, GT.listViewKind,
                                 GUI.gegVarAddress, SYS.ADR(listview),
                                 GUI.gegText, SYS.ADR("Choose List_view-Entry"),
                                 GUI.gegFlags, {GT.placeTextAbove},
                                 GT.lvLabels, SYS.ADR(list),
                                 GT.lvShowSelected, NIL, NIL);
        GUI.base.CreateGUIGadget(G, 20, 130, 600, 14, GT.scrollerKind,
                                 GUI.gegText, SYS.ADR("_Scroll Me"),
                                 GUI.gegFlags, {GT.placeTextAbove},
                                 GUI.gegVarAddress, SYS.ADR(scroller),
                                 GT.scTotal, 100,
                                 I.gaImmediate, 1,
                                 I.gaRelVerify, 1,
                                 I.pgaFreedom, I.lOrientHoriz, NIL);
        GUI.base.CreateGUIGadget(G, 120, 200, 250, 35, GT.paletteKind,
                                 GUI.gegText, SYS.ADR("This is a _palette !"),
                                 GUI.gegFlags, {GT.placeTextAbove},
                                 GT.paDepth, 2,
                                 GUI.gegVarAddress, SYS.ADR(color),
                                 GT.paIndicatorWidth, 50, NIL);
        GUI.base.CreateGUIGadget(G, 20, 170, 600, 14, GT.sliderKind,
                                 GUI.gegText, SYS.ADR("Slider me with + and -"),
                                 GUI.gegFlags, {GT.placeTextAbove},
                                 GT.slMin, 0,
                                 GT.slMax, 200,
                                 GUI.gegVarAddress, SYS.ADR(slider),
                                 I.gaImmediate, 1,
                                 I.gaRelVerify, 1,
                                 I.pgaFreedom, I.lOrientHoriz, NIL);
        GUI.base.CreateGUIGadget(G, 100, 80,  80,17, GT.mxKind,
                                 GUI.gegFlags, {GT.placeTextLeft},
                                 GUI.gegVarAddress, SYS.ADR(mx),
                                 GT.mxLabels, SYS.ADR(mxLabs), NIL);
        GUI.base.CreateGUIGadget(G, 120, 68,  10,12, GT.textKind,
                                 GUI.gegText, SYS.ADR("MX:"),
                                 GUI.gegFlags, {GT.placeTextLeft},
                                 GT.txText, GUI.base.GetCatStr(G, 50, SYS.ADR("Try pressing m")), NIL);

        GUI.base.CreateGUIMenuEntry(G, GT.nmTitle, SYS.ADR("Project"), NIL);
        GUI.base.CreateGUIMenuEntry(G, GT.nmItem, SYS.ADR("About"),
                                    GUI.gemAHook, SYS.ADR(MenuAbout),
                                    GUI.gemShortCut, SYS.ADR("A\0"), NIL);
        GUI.base.CreateGUIMenuEntry(G, GT.nmItem, SYS.ADR("Quit"),
                                    GUI.gemAHook, SYS.ADR(MenuQuit),
                                    GUI.gemShortCut, SYS.ADR("Q\0"), NIL);

        IF GUI.base.DrawGUI(G, NIL) = GUI.geDone THEN (* Draw all *)

          LOOP (* Input-Loop *)
            GUI.base.WaitGUIMsg(G);
            IF    I.idcmpCloseWindow IN G^.msgClass THEN
              IF MenuQuit(NIL, NIL, NIL) = 0 THEN EXIT END;
            ELSIF (I.idcmpGadgetUp IN G^.msgClass) OR (I.idcmpGadgetDown IN G^.msgClass) THEN
              (* We are only interessed in the buttonGadget !*)
              IF G^.msgGadNbr = 0 THEN  (* ButtonGadget Quit *)
                EXIT;
              END;
            ELSIF I.idcmpMenuPick IN G^.msgClass THEN
              EXIT;
            END;
          END;

          (* update entry-gadgets *)
          GUI.base.GUIGadgetAction(G, GUI.gegGetVar, GUI.gegALLGADGETS, NIL);

          (* And now print all values *)
          (* For each string, it is necessary first to call
             strPTR := GUI.base.GetCatStr(..) and then
             IO.WriteStr(strPTR^)
             because IO.WriteStr(GUI.base.GetCatStr(..)^) causes an error *)

          IO.WriteLn;
          strPTR := GUI.base.GetCatStr(G, 61, SYS.ADR("Your input:"));
          IO.WriteStr(strPTR^);
          IO.WriteLn;
          strPTR := GUI.base.GetCatStr(G, 62, SYS.ADR("String  :"));
          IO.WriteStr(strPTR^);
          IO.WriteStr(string);
          IO.WriteLn;

          strPTR := GUI.base.GetCatStr(G, 63, SYS.ADR("Longint :"));
          IO.WriteStr(strPTR^);
          IO.WriteInt(longI);
          IO.WriteLn;

          IO.WriteStr("Cycle   :");
          IO.WriteStr(cycleLabs[cycle]^);
          IO.WriteLn;

          IO.WriteStr("MX      :");
          IO.WriteStr(mxLabs[mx]^);
          IO.WriteLn;

          IF check THEN
            strPTR := GUI.base.GetCatStr(G, 64, SYS.ADR("Checkbox:YES"));
            IO.WriteStr(strPTR^);
          ELSE
            strPTR := GUI.base.GetCatStr(G, 65, SYS.ADR("Checkbox:NO"));
            IO.WriteStr(strPTR^);
          END;
          IO.WriteLn;

          IO.WriteStr("Listview:");
          IF listview = -1 THEN
            strPTR := GUI.base.GetCatStr(G, 66, SYS.ADR("Nothing"));
            IO.WriteStr(strPTR^);
          ELSE
            IO.WriteStr(listviewLabs[9-listview]^);
            (* The list was created in reverse order ! *)
          END;
          IO.WriteLn;

          IO.WriteStr("Slider  :");
          IO.WriteInt(slider);
          IO.WriteLn;

          IO.WriteStr("Scroller:");
          IO.WriteInt(scroller);
          IO.WriteLn;

          strPTR := GUI.base.GetCatStr(G, 67, SYS.ADR("Color   :"));
          IO.WriteStr(strPTR^);
          IO.WriteInt(color);
          IO.WriteLn;

          IO.WriteLn;
        END;
      END;
    END;
  END;


  IF S # NIL THEN
    GUI.base.CloseGUIScreen(S);
    (* The closing of the window etc is done by GUIEnv !*)
  END;
  WHILE list.tailPred # SYS.ADR(list) DO    (* free list *)
    E.base.FreeMem(E.base.RemTail(list), SIZE(ListViewNode));
  END;
END NotifyExample.
