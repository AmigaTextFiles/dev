(*---------------------------------------------------------------------------
  :Program.    MGTools.mod
  :Contents.   Modula-2 SourceCode Generator für GadgetToolsBox 2.x
  :Author.     Frank Lömker
  :Copyright.  FreeWare
  :Language.   Modula-2
  :Translator. Turbo Modula-2 V1.40
  :Imports.    GadToolsBox [Jan van den Baard]
  :History.    1.0 [Frank] 17-Apr-95
  :History.        ModGen basiert direkt auf OG V37.11 von Thomas Igracki
  :History.        und GenOberon V1.0 von Kai Bolay und Jan van den Baard.
  :Bugs.       keine bekannt
---------------------------------------------------------------------------*)

IMPLEMENTATION MODULE MGTools;

FROM SYSTEM IMPORT ADR,ADDRESS,CAST,LONGSET,BITSET,STRING;
IMPORT
  e:=Exec, I:=Intuition, G:=Graphics, d:=Dos, u:=Utility, gt:=GadTools,
  C:=Classes, df:=DiskFont, gtx:=GadToolsBox, m:=ModeKeys, st:=String, m2:=M2Lib;

TYPE
  numKindsType = ARRAY [0..gt.NUM_KINDS-1] OF STRING;
  goKindsType = numKindsType;
  goIdcmpType = numKindsType;
  goTypesType = ARRAY  [0..3] OF STRING;
  BoolsArrayType = ARRAY [0..gt.NUM_KINDS-1] OF BOOLEAN;

CONST
  palMonitor  = CAST (LONGSET, m.PAL_MONITOR_ID);
  ntscMonitor = CAST (LONGSET, m.NTSC_MONITOR_ID);

  superLaceKeyLs = CAST (LONGSET, m.SUPERLACE_KEY);
  hiresLaceKeyLs = CAST (LONGSET, m.HIRESLACE_KEY);
  loresLaceKeyLs = CAST (LONGSET, m.LORESLACE_KEY);
  superKeyLs     = CAST (LONGSET, m.SUPER_KEY);
  hiresKeyLs     = CAST (LONGSET, m.HIRES_KEY);

VAR goKinds : goKindsType;
    goIdcmp : goIdcmpType;
    goTypes : goTypesType;
    FalseArray : BoolsArrayType;

PROCEDURE InitConsts;
BEGIN
  goKinds:=["GENERIC", "BUTTON",  "CHECKBOX",
            "INTEGER", "LISTVIEW","MX",
            "NUMBER",  "CYCLE",   "PALETTE",
            "SCROLLER","RESERVED","SLIDER",
            "STRING",  "TEXT"];
  goIdcmp:=["I.GADGETUP", "gt.BUTTONIDCMP","gt.CHECKBOXIDCMP",
            "gt.INTEGERIDCMP",      "gt.LISTVIEWIDCMP","gt.MXIDCMP",
            "LONGSET(gt.NUMBERIDCMP)","gt.CYCLEIDCMP",   "gt.PALETTEIDCMP",
            "gt.SCROLLERIDCMP",     "RESERVED",         "gt.SLIDERIDCMP",
            "gt.STRINGIDCMP",       "LONGSET(gt.TEXTIDCMP)"];
  goTypes:=["NM_END","NM_TITLE","NM_ITEM","NM_SUB"];
  FalseArray:=[FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE];
END InitConsts;

VAR goDone     : BoolsArrayType;
    FixUpNumPos: LONGINT;
    JoinedInWindow,ListViewLists: BOOLEAN;

PROCEDURE FPrintF (fh: d.FileHandlePtr;format: STRING;a1: ADDRESS);
BEGIN
  d.VFPrintf (fh,format,ADR(a1));
END FPrintF;

PROCEDURE FPrintF2 (fh:d.FileHandlePtr;format:STRING;a1,a2: ADDRESS);
BEGIN
  d.VFPrintf (fh,format,ADR(a1));
END FPrintF2;

PROCEDURE FPrintF3 (fh:d.FileHandlePtr;format:STRING;a1,a2,a3: ADDRESS);
BEGIN
  d.VFPrintf (fh,format,ADR(a1));
END FPrintF3;

PROCEDURE FPrintF4 (fh:d.FileHandlePtr;format:STRING;a1,a2,a3,a4: ADDRESS);
BEGIN
  d.VFPrintf (fh,format,ADR(a1));
END FPrintF4;

PROCEDURE FPrintF5 (fh:d.FileHandlePtr;format:STRING;a1,a2,a3,a4,a5: ADDRESS);
BEGIN
  d.VFPrintf (fh,format,ADR(a1));
END FPrintF5;

PROCEDURE FPutS (fh: d.FileHandlePtr; str : STRING);
BEGIN
  d.FPuts (fh,str);
END FPutS;

PROCEDURE FPutS2 (str : STRING);
BEGIN
  d.FPuts (file,str); d.FPuts (fdef,str);
END FPutS2;

PROCEDURE MarkNumber;
BEGIN FixUpNumPos := d.Seek (file, 0, d.OFFSET_CURRENT); FPutS (file, "0000");
END MarkNumber;

PROCEDURE FixNumber (num: INTEGER);
VAR curpos: LONGINT;
BEGIN
  curpos := d.Seek (file, FixUpNumPos, d.OFFSET_BEGINNING);
  FPrintF (file, "%4ld", num);
  d.Seek (file, curpos, d.OFFSET_BEGINNING);
END FixNumber;

PROCEDURE SeekBack (num: INTEGER); (* Seek num pos backwards *)
BEGIN d.Seek (file, -num, d.OFFSET_CURRENT);
END SeekBack;

(* --- Check for the presence of GETFILE and joined LISTVIEWS.
   --- This routine is called for each window that get's generated. *)
PROCEDURE CheckItOut (pw: gtx.ProjectWindowPtr);
VAR eng: gtx.ExtNewGadgetPtr;
BEGIN
  JoinedInWindow := FALSE; GetFileInWindow := FALSE;
  eng := pw^.gadgets.head;
  WHILE (eng^.succ # NIL) & ~(GetFileInWindow & JoinedInWindow) DO
    IF (eng^.kind = gt.LISTVIEW_KIND) & (gtx.NeedLock IN eng^.flags) THEN JoinedInWindow := TRUE END;
    IF eng^.kind = gt.GENERIC_KIND THEN GetFileInWindow := TRUE END;
    eng := eng^.succ;
  END;
END CheckItOut;

(* --- Check for the presence of GETFILE and ListView at all *)
PROCEDURE CheckGetFile;
VAR eng: gtx.ExtNewGadgetPtr; pw: gtx.ProjectWindowPtr;
BEGIN
  GetFilePresent := FALSE; ListViewPresent := FALSE; ListViewLists:=FALSE;
  pw := Projects.head;
  WHILE (pw^.succ # NIL) & ~(GetFilePresent AND ListViewPresent) DO
    eng := pw^.gadgets.head;
    WHILE (eng^.succ # NIL) & ~(GetFilePresent AND ListViewPresent) DO
      IF eng^.kind = gt.GENERIC_KIND THEN GetFilePresent := TRUE
      ELSIF eng^.kind = gt.LISTVIEW_KIND THEN ListViewPresent := TRUE; END;
      eng := eng^.succ;
    END;
    pw := pw^.succ;
  END;
END CheckGetFile;

(* --- Write placement flags. *)
PROCEDURE WritePlaceFlags (flags: LONGSET);
BEGIN
  IF flags = {} THEN RETURN END;

  IF    gt.PLACETEXT_LEFT  <= flags THEN FPutS (file, "gt.PLACETEXT_LEFT+")
  ELSIF gt.PLACETEXT_RIGHT <= flags THEN FPutS (file, "gt.PLACETEXT_RIGHT+")
  ELSIF gt.PLACETEXT_ABOVE <= flags THEN FPutS (file, "gt.PLACETEXT_ABOVE+")
  ELSIF gt.PLACETEXT_BELOW <= flags THEN FPutS (file, "gt.PLACETEXT_BELOW+")
  ELSIF gt.PLACETEXT_IN    <= flags THEN FPutS (file, "gt.PLACETEXT_IN+")
  END;
  IF gt.NG_HIGHLABEL <= flags THEN FPutS (file, "gt.NG_HIGHLABEL+") END;

  SeekBack(1);
END WritePlaceFlags;

(* --- Write DisplayID flags. *)
PROCEDURE WriteIDFlags (flags: LONGSET);
BEGIN
  IF    palMonitor  * flags = palMonitor  THEN FPutS (file, "m.PAL_MONITOR_ID+")
  ELSIF ntscMonitor * flags = ntscMonitor THEN FPutS (file, "m.NTSC_MONITOR_ID+")
                                          ELSE FPutS (file, "m.DEFAULT_MONITOR_ID+")
  END;

  IF    superLaceKeyLs * flags = superLaceKeyLs THEN FPutS (file, "m.SUPERLACE_KEY+")
  ELSIF hiresLaceKeyLs * flags = hiresLaceKeyLs THEN FPutS (file, "m.HIRESLACE_KEY+")
  ELSIF loresLaceKeyLs * flags = loresLaceKeyLs THEN FPutS (file, "m.LORESLACE_KEY+")
  ELSIF superKeyLs     * flags = superKeyLs THEN FPutS (file, "m.SUPER_KEY+")
  ELSIF hiresKeyLs     * flags = hiresKeyLs THEN FPutS (file, "m.HIRES_KEY+")
                                            ELSE FPutS (file, "m.LORES_KEY+")
  END;

  SeekBack(1);
  FPutS (file, ",\n");
END WriteIDFlags;

(* --- Write the IntuiText drawmode flags. *)
PROCEDURE WriteDrMd (drmd: SHORTSET);
BEGIN
  IF G.JAM2*drmd # {} THEN FPutS (file, "g.JAM2") ELSE FPutS (file, "g.JAM1") END;
  IF G.COMPLEMENT <= drmd THEN FPutS (file, "+g.COMPLEMENT") END;
  IF G.INVERSVID  <= drmd THEN FPutS (file, "+g.INVERSVID") END;
END WriteDrMd;

(* --- Write GadTools IDCMP flags. *)
PROCEDURE WriteGadToolsIDCMP (pw: gtx.ProjectWindowPtr);
VAR eng: gtx.ExtNewGadgetPtr;
BEGIN
  goDone := FalseArray;
  eng := pw^.gadgets.head;
  WHILE eng^.succ # NIL DO
    IF ~goDone [eng^.kind] THEN
      FPrintF (file, ADR("%s+"), goIdcmp[eng^.kind]);
      goDone[eng^.kind] := TRUE;
      IF eng^.kind = gt.SCROLLER_KIND THEN
        IF gtx.GTX_TagInArray (LONGCARD(gt.GTSC_Arrows), CAST(u.TagPtr,eng^.tags)) THEN
          FPutS (file, "gt.ARROWIDCMP+")
        END;
      END;
    END;
    eng := eng^.succ;
  END;
END WriteGadToolsIDCMP;

(* --- Write IDCMP flags. *)
PROCEDURE WriteIDCMPFlags (idcmp: LONGSET; pw: gtx.ProjectWindowPtr);
BEGIN
  IF idcmp = {} THEN FPutS (file, "{},\n"); RETURN END;

  WriteGadToolsIDCMP (pw);

  FPutS (file, "\n                    ");

  IF I.GADGETUP <= idcmp THEN
    IF ~goDone[0 ] & ~goDone[1 ] &
       ~goDone[2 ] & ~goDone[3 ] &
       ~goDone[4 ] & ~goDone[7 ] &
       ~goDone[8 ] & ~goDone[9 ] &
       ~goDone[11] & ~goDone[12] THEN FPutS (file, "I.GADGETUP+");
    END;
  END;

  IF I.GADGETDOWN <= idcmp THEN
    IF ~goDone[4] & ~goDone[5 ] & ~goDone[9] & ~goDone[11] THEN
      FPutS (file, "I.GADGETDOWN+")
    END;
  END;

  IF I.INTUITICKS <= idcmp THEN
    IF ~goDone[4] & ~goDone[9] THEN FPutS (file, "I.INTUITICKS+") END;
  END;

  IF I.MOUSEMOVE <= idcmp THEN
    IF ~goDone[4 ] & ~goDone[9 ] & ~goDone[11] THEN
      FPutS (file, "I.MOUSEMOVE+")
    END;
  END;

  IF I.MOUSEBUTTONS <= idcmp THEN
    IF ~goDone[4] & ~goDone[9] THEN FPutS (file, "I.MOUSEBUTTONS+") END;
  END;

  IF I.SIZEVERIFY    <= idcmp THEN FPutS (file, "I.SIZEVERIFY+") END;
  IF I.NEWSIZE       <= idcmp THEN FPutS (file, "I.NEWSIZE+") END;

  IF I.REQSET        <= idcmp THEN FPutS (file, "I.REQSET+") END;
  IF I.MENUPICK      <= idcmp THEN FPutS (file, "I.MENUPICK+") END;
  IF I.CLOSEWINDOW   <= idcmp THEN FPutS (file, "I.CLOSEWINDOW+") END;

  IF I.RAWKEY        <= idcmp THEN FPutS (file, "I.RAWKEY+") END;
  IF I.REQVERIFY     <= idcmp THEN FPutS (file, "I.REQVERIFY+") END;
  IF I.REQCLEAR      <= idcmp THEN FPutS (file, "I.REQCLEAR+") END;
  IF I.MENUVERIFY    <= idcmp THEN FPutS (file, "I.MENUVERIFY+") END;
  IF I.NEWPREFS      <= idcmp THEN FPutS (file, "I.NEWPREFS+") END;
  IF I.DISKINSERTED  <= idcmp THEN FPutS (file, "I.DISKINSERTED+") END;

  IF I.DISKREMOVED    <= idcmp THEN FPutS (file, "I.DISKREMOVED+") END;
  IF I.ACTIVEWINDOW   <= idcmp THEN FPutS (file, "I.ACTIVEWINDOW+") END;
  IF I.INACTIVEWINDOW <= idcmp THEN FPutS (file, "I.INACTIVEWINDOW+") END;
  IF I.DELTAMOVE      <= idcmp THEN FPutS (file, "I.DELTAMOVE+") END;
  IF I.VANILLAKEY     <= idcmp THEN FPutS (file, "I.VANILLAKEY+") END;
  IF I.IDCMPUPDATE    <= idcmp THEN FPutS (file, "I.IDCMPUPDATE+") END;

  IF I.MENUHELP      <= idcmp THEN FPutS (file, "I.MENUHELP+") END;
  IF I.CHANGEWINDOW  <= idcmp THEN FPutS (file, "I.CHANGEWINDOW+") END;
  IF I.REFRESHWINDOW <= idcmp THEN FPutS (file, "I.REFRESHWINDOW+") END;

  SeekBack(1);
  FPutS (file, ",\n");
END WriteIDCMPFlags;

(* --- Write window flags. *)
PROCEDURE WriteWindowFlags (flags: LONGSET);
BEGIN
  IF I.WINDOWSIZING   <= flags THEN FPutS (file, "I.WINDOWSIZING+") END;
  IF I.WINDOWDRAG     <= flags THEN FPutS (file, "I.WINDOWDRAG+") END;
  IF I.WINDOWDEPTH    <= flags THEN FPutS (file, "I.WINDOWDEPTH+") END;
  IF I.WINDOWCLOSE    <= flags THEN FPutS (file, "I.WINDOWCLOSE+") END;
  IF I.SIZEBRIGHT     <= flags THEN FPutS (file, "I.SIZEBRIGHT+") END;
  IF I.SIZEBBOTTOM <= flags THEN FPutS (file, "I.SIZEBBOTTOM+") END;
(* IF I.SMART_REFRESH <= flags THEN FPutS (file, "I.SMART_REFRESH+") END; *)
  IF I.SIMPLE_REFRESH  <= flags THEN FPutS (file, "I.SIMPLE_REFRESH+") END;
  IF I.SUPER_BITMAP    <= flags THEN FPutS (file, "I.SUPER_BITMAP+") END;
  IF I.OTHER_REFRESH * flags = I.OTHER_REFRESH THEN FPutS (file, "I.SIMPLE_REFRESH+I.SUPER_BITMAP+") END;
  IF I.BACKDROP       <= flags THEN FPutS (file, "I.BACKDROP+") END;
  IF I.REPORTMOUSE    <= flags THEN FPutS (file, "I.REPORTMOUSE+") END;
  IF I.GIMMEZEROZERO  <= flags THEN FPutS (file, "I.GIMMEZEROZERO+") END;
  IF I.BORDERLESS     <= flags THEN FPutS (file, "I.BORDERLESS+") END;
  IF I.ACTIVATE       <= flags THEN FPutS (file, "I.ACTIVATE+") END;
  IF I.RMBTRAP        <= flags THEN FPutS (file, "I.RMBTRAP+") END;

  SeekBack(1);
  FPutS (file, ",\n");
END WriteWindowFlags;

(* --- Write a single NewMenu structure. *)
PROCEDURE WriteNewMenu (menu: gtx.ExtNewMenuPtr);
VAR flags: BITSET;
BEGIN
  FPrintF (file, "    [gt.%s, ", goTypes[menu^.newMenu.nm_Type]);
  IF menu^.newMenu.nm_Label # gt.NM_BARLABEL THEN
    FPrintF (file, ADR('"%s", '), ADR(menu^.menuTitle));
  ELSE
    FPutS (file, "gt.NM_BARLABEL],\n");
    RETURN;
  END;
  IF menu^.newMenu.nm_CommKey # NIL THEN
     FPrintF (file, ADR('"%s", '), ADR(menu^.commKey));
  ELSE FPutS (file, "NIL, "); END;
  flags := menu^.newMenu.nm_Flags;
  IF flags # {} THEN
    IF menu^.newMenu.nm_Type = gt.NM_TITLE THEN
      IF gt.NM_MENUDISABLED <= flags THEN FPutS (file, "gt.NM_MENUDISABLED+") END;
    ELSE
      IF gt.NM_ITEMDISABLED <= flags THEN FPutS (file, "gt.NM_ITEMDISABLED+") END;
    END;
    IF I.CHECKIT    <= flags THEN FPutS (file, "I.CHECKIT+") END;
    IF I.CHECKED    <= flags THEN FPutS (file, "I.CHECKED+") END;
    IF I.MENUTOGGLE <= flags THEN FPutS (file, "I.MENUTOGGLE+") END;
    SeekBack(1);
    FPutS (file,",");
  ELSE FPutS (file,"{},"); END;

  FPrintF (file, ADR(" %ld],\n"), menu^.newMenu.nm_MutualExclude);
END WriteNewMenu;

(* --- Write the NewMenu structures. *)
PROCEDURE WriteMenus (end:BOOLEAN);
VAR pw: gtx.ProjectWindowPtr;
    menu,item,sub: gtx.ExtNewMenuPtr;
    cnt: INTEGER;
BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    IF pw^.menus.head^.succ # NIL THEN
      IF end THEN
        FPrintF2 (file,ADR("  %sNewMenu := GetMem (SIZE(%sMArray));\n"), ADR(pw^.name), ADR(pw^.name));
        FPrintF (file,ADR("  %sNewMenu^ :=[\n"), ADR(pw^.name));
      ELSE
        FPrintF (file, ADR("TYPE %sMArray = ARRAY [0.."), ADR(pw^.name));
        MarkNumber; cnt := 0;
        FPrintF2 (file,ADR("] OF gt.NewMenu;\nVAR %sNewMenu : POINTER TO %sMArray;\n"), ADR(pw^.name), ADR(pw^.name));
      END;
      menu := pw^.menus.head;
      WHILE menu^.succ # NIL DO
        IF end THEN WriteNewMenu(menu); END; INC(cnt);
        IF menu^.items # NIL THEN
          item := menu^.items^.head;
          WHILE item^.succ # NIL DO
            IF end THEN WriteNewMenu(item); END; INC(cnt);
            IF item^.items # NIL THEN
              sub := item^.items^.head;
              WHILE sub^.succ # NIL DO
                IF end THEN WriteNewMenu (sub); END; INC(cnt);
                sub := sub^.succ;
              END;
            END;
            item := item^.succ;
          END;
        END;
        menu := menu^.succ;
      END; (* WHILE *)
      IF end THEN FPutS (file, "    [gt.NM_END,NIL] ];\n");
             ELSE FixNumber (cnt); END;
    END;
    pw := pw^.succ;
  END; (* WHILE *)
END WriteMenus;

PROCEDURE GetKey (str: (*@N*)ARRAY OF CHAR): CHAR; (*$ CopyDyn:=FALSE *)
VAR s: STRING;
BEGIN s := st.strchr (str,'_'); IF s = NIL THEN RETURN '' ELSE RETURN CAP(s^[1]) END;
END GetKey;

(* --- Write the GadgetID defines. *)
PROCEDURE WriteID ();
VAR pw : gtx.ProjectWindowPtr;
    eng: gtx.ExtNewGadgetPtr;
BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    IF pw^.gadgets.head^.succ # NIL THEN
      FPrintF (fdef, ADR('  %sHotKeys = "'),ADR(pw^.name));
      eng := pw^.gadgets.head;
      WHILE eng^.succ # NIL DO
        (*$ StackParms:=TRUE *)
        FPrintF (fdef, ADR("%lc"), ORD(GetKey(eng^.gadgetText)));
        (*$ POP StackParms *)
        eng := eng^.succ;
      END;
      FPutS (fdef, '";\n');

      eng := pw^.gadgets.head;
      WHILE eng^.succ # NIL DO
        FPrintF2 (fdef, ADR("  GD%-32s = %ld;\n"), ADR(eng^.gadgetLabel), eng^.newGadget.ng_GadgetID);
        eng := eng^.succ;
      END;
      FPutS (fdef, "\n");
    END;
    pw := pw^.succ;
  END; (* WHILE *)
END WriteID;

(* --- Check FOR OpenFont source genertion. *)
PROCEDURE CheckFont(): BOOLEAN;
BEGIN
  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN RETURN FALSE END;
  IF (GenOpenFont IN MConfig) AND
     NOT (G.FPB_ROMFONT IN GuiData.font.ta_Flags) THEN RETURN TRUE END;
  RETURN FALSE;
END CheckFont;

(* Init the Windowcoordinates. *)
PROCEDURE InitCoords;
VAR pw: gtx.ProjectWindowPtr;
    btop: LONGCARD;
BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    FPrintF4 (file, ADR("  %sLeft := %ld;\n  %sTop := %ld;\n"),
                    ADR(pw^.name), u.GetTagData (I.WA_Left,0,pw^.tags),
                    ADR(pw^.name),u.GetTagData (I.WA_Top,0,pw^.tags));
    IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
      FPrintF (file, ADR("  %sWidth := "), ADR(pw^.name));
      IF gtx.InnerWidth IN pw^.tagFlags THEN
        FPrintF (file, ADR("%ld;\n"), pw^.innerWidth);
      ELSE
        FPrintF (file, ADR("%ld;\n"), u.GetTagData (I.WA_Width, NIL, pw^.tags));
      END;

      FPrintF (file, ADR("  %sHeight := "), ADR(pw^.name));
      IF gtx.InnerHeight IN pw^.tagFlags THEN
        FPrintF (file, ADR("%ld;\n"), pw^.innerHeight);
      ELSE
        btop := pw^.topBorder;
        FPrintF (file, ADR("%ld;\n"), u.GetTagData (I.WA_Height, NIL, pw^.tags) - btop);
      END;
    ELSE
      FPrintF4 (file,ADR("  %sWidth := %ld;\n  %sHeight := %ld;\n"),ADR(pw^.name),pw^.innerWidth,ADR(pw^.name),pw^.innerHeight);
(*    btop := pw^.topBorder;
      FPrintF4 (file,ADR("  %sWidth := %ld;\n  %sHeight := %ld;\n"),
                     ADR(pw^.name), u.GetTagData (I.WA_Width, NIL, pw^.tags),
                     ADR(pw^.name),u.GetTagData (I.WA_Height, NIL, pw^.tags) - btop); *)
    END;
    pw := pw^.succ;
  END; (* WHILE *)
END InitCoords;

(* --- Write the necessary globals. *)
PROCEDURE WriteGlob (scr,win:BOOLEAN);
VAR pw: gtx.ProjectWindowPtr;
    f:d.FileHandlePtr;
BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    FPrintF2 (fdef,ADR("  %sCNT = %ld;\n"),ADR(pw^.name),gtx.GTX_CountNodes (ADR(pw^.gadgets)));
    pw := pw^.succ;
  END; (* WHILE *)

  FPutS  (fdef,"\nVAR\n");
  IF NOT win THEN
    FPutS (fdef,"  Scr: I.ScreenPtr;\n  VisualInfo: y.ADDRESS;\n");
  END;

  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    FPrintF (fdef, ADR("  %sWnd: I.WindowPtr;\n"), ADR(pw^.name));
    IF pw^.gadgets.head^.succ # NIL THEN
      FPrintF3 (fdef,ADR("  %sGList: I.GadgetPtr;\n  %sGadgets: ARRAY [0..%sCNT-1] OF I.GadgetPtr;\n"), ADR(pw^.name), ADR(pw^.name), ADR(pw^.name));
    END;
    IF pw^.menus.head^.succ # NIL THEN
      FPrintF (fdef, ADR("  %sMenus: I.MenuPtr;\n"), ADR(pw^.name));
    END;
    IF LONGSET{gtx.Zoom,gtx.DefaultZoom} * pw^.tagFlags # LONGSET{} THEN
      IF ~(I.WINDOWSIZING <= pw^.windowFlags) THEN
        FPrintF (fdef, ADR("  %sZoom: ARRAY [0..3] OF INTEGER;\n"), ADR(pw^.name));
      END;
    END;
    FPrintF4 (fdef, ADR("  %sLeft, %sTop,\n  %sWidth, %sHeight: INTEGER;\n"),
                    ADR(pw^.name), ADR(pw^.name), ADR(pw^.name), ADR(pw^.name));
    pw := pw^.succ
  END;
  IF GetFilePresent AND NOT scr THEN
    FPutS (file,"VAR\n");
    pw := Projects.head;
    WHILE pw^.succ # NIL DO
      CheckItOut (pw);
      IF GetFileInWindow THEN
        FPrintF (file, ADR("  %sGetImage: C.ObjectPtr;\n"), ADR(pw^.name));
      END;
      pw := pw^.succ;
    END;
  END;
  IF NOT win THEN
    IF scr THEN f:=fdef ELSE f:=file; END;
    IF CheckFont() THEN FPutS (fdef, "  Font: g.TextFontPtr;\n") END;

    IF (gtx.FontAdapt IN MainConfig.configFlags0) AND
       ((NOT GetFilePresent) OR scr) THEN
      FPutS (file,"VAR\n");
    END;

    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
      FPutS (fdef,"  Font: g.TextAttrPtr;\n  Attr,Topaz80: g.TextAttr;\n");
      FPutS (file,"  FontX, FontY: INTEGER;\n");
      FPutS (f,   "  OffX, OffY: INTEGER;\n");
    END;
  END;  (* IF NOT win *)
  IF NOT scr THEN
    IF (gtx.FontAdapt IN MainConfig.configFlags0) AND (SysFont IN MConfig) THEN
      pw := Projects.head;
      WHILE pw^.succ # NIL DO
        FPrintF (fdef, ADR("  %sFont: g.TextFontPtr;\n"), ADR(pw^.name));
        pw := pw^.succ;
      END;
    END;
  END;
  FPutS2 (ADR("\n"));
END WriteGlob;

PROCEDURE CountArray(arr:ARRAY OF STRING):LONGINT;
VAR nr: INTEGER;
BEGIN
  nr:= 0;
  WHILE (nr<=HIGH(arr)) AND (arr[nr]#NIL) DO
    INC (nr);
  END;
  RETURN(nr);
END CountArray;

(* --- Write the Cycle and Mx lables. *)
PROCEDURE WriteLabels (end:BOOLEAN);
VAR pw: gtx.ProjectWindowPtr;
    eng: gtx.ExtNewGadgetPtr;
    i,pnum: INTEGER;
    labels: POINTER TO ARRAY [0..23] OF STRING;
BEGIN
  pw := Projects.head; pnum := 0;
  WHILE pw^.succ # NIL DO
    eng := pw^.gadgets.head;
    WHILE eng^.succ # NIL DO
      IF (eng^.kind = gt.CYCLE_KIND) OR (eng^.kind = gt.MX_KIND) THEN
        IF (eng^.kind = gt.CYCLE_KIND) THEN
          labels := CAST(ADDRESS,u.GetTagData (gt.GTCY_Labels, NIL, eng^.tags));
        ELSE
          labels := CAST(ADDRESS,u.GetTagData (gt.GTMX_Labels, NIL, eng^.tags));
        END;
        IF NOT end THEN
          FPrintF3 (file, ADR("TYPE %s%ldLArray = ARRAY [0..%ld] OF y.STRING;\n"),
                    ADR(eng^.gadgetLabel), pnum, CountArray(labels^));
          FPrintF4 (file, ADR("VAR %s%ldLabels : %s%ldLArray;\n"), ADR(eng^.gadgetLabel), pnum, ADR(eng^.gadgetLabel), pnum);
        ELSE
          FPrintF2 (file, ADR("  %s%ldLabels := [\n"), ADR(eng^.gadgetLabel), pnum );
          FOR i := 0 TO 23 DO
            IF labels^[i]#NIL THEN
              FPrintF (file, ADR('    "%s",\n'), labels^[i]);
            END;
          END;
          FPutS (file, "    NIL];\n");
        END;
      END;
      eng := eng^.succ;
    END; (* WHILE *)
    pw := pw^.succ; INC(pnum);
  END; (* WHILE *)
END WriteLabels;

PROCEDURE WriteList;
VAR pw: gtx.ProjectWindowPtr;
    eng: gtx.ExtNewGadgetPtr;
    list: e.ListPtr;
    pnum: INTEGER;
    first:BOOLEAN;
BEGIN
  first:=TRUE;
  pw := Projects.head; pnum := 0;
  WHILE pw^.succ # NIL DO
    eng := pw^.gadgets.head;
    WHILE eng^.succ # NIL DO
      IF eng^.kind = gt.LISTVIEW_KIND THEN
        list := CAST(ADDRESS,u.GetTagData (gt.GTLV_Labels, 0, eng^.tags ));
        IF (list # NIL) AND (list^.lh_Head^.ln_Succ # NIL) THEN
          IF first THEN
            FPutS (file, "VAR\n"); first:=FALSE;
          END;
          FPrintF2 (file, ADR("  %s%ldList: e.MinList;\n"), ADR(eng^.gadgetLabel), pnum);
          FPrintF3 (file, ADR("  %s%ldNodes: ARRAY [0..%ld] OF e.Node;\n"), ADR(eng^.gadgetLabel), pnum, gtx.GTX_CountNodes (list)-1);
          ListViewLists := TRUE;
        END;
      END;
      eng := eng^.succ;
    END; (* WHILE *)
    pw := pw^.succ; INC(pnum);
  END;(* WHILE *)
END WriteList;

(* --- Write a single ListView Node. *)

PROCEDURE WriteNode (eng: gtx.ExtNewGadgetPtr; node: e.NodePtr; num,pnum: INTEGER);
VAR list: e.ListPtr;
BEGIN
  list := CAST(ADDRESS,u.GetTagData (gt.GTLV_Labels, 0, eng^.tags));
  IF list # NIL THEN
    IF node^.ln_Succ # ADR(list^.lh_Tail) THEN
      FPrintF3 (file, ADR("    [y.ADR (%s%ldNodes[%ld])"), ADR(eng^.gadgetLabel), pnum, num+1);
    ELSE
      FPrintF2 (file, ADR("    [y.ADR (%s%ldList.mlh_Tail)"), ADR(eng^.gadgetLabel), pnum);
    END;
    IF node^.ln_Pred = ADR(list^.lh_Head) THEN
      FPrintF2 (file, ADR(", y.ADR (%s%ldList.mlh_Head),\n"), ADR(eng^.gadgetLabel), pnum);
    ELSE
      FPrintF3 (file, ADR(", y.ADR (%s%ldNodes[%ld]),\n"), ADR(eng^.gadgetLabel), pnum, num-1);
    END;
    FPrintF (file, ADR('     e.NT_UNKNOWN, 0, "%s"],\n'), node^.ln_Name);
  ELSE FPutS (file,"    [],\n"); END;
END WriteNode;

(* --- Write a ListView List/Node initialisation *)

PROCEDURE WriteNodes (pw: gtx.ProjectWindowPtr; pnum: INTEGER);
VAR eng: gtx.ExtNewGadgetPtr;
    node: e.NodePtr;
    list: e.ListPtr;
    nodenum: INTEGER;
BEGIN
  eng := pw^.gadgets.head;
  WHILE eng^.succ # NIL DO
    IF eng^.kind = gt.LISTVIEW_KIND THEN
      list := CAST(ADDRESS,u.GetTagData (gt.GTLV_Labels, 0, eng^.tags));
      IF list # NIL THEN
        IF list^.lh_Head^.ln_Succ # NIL THEN
          node := list^.lh_Head; nodenum := 0;
          FPrintF2 (file, ADR("  %s%ldNodes:=[\n"),ADR(eng^.gadgetLabel), pnum);
          WHILE node^.ln_Succ # NIL DO
            WriteNode (eng, node, nodenum, pnum);
            node := node^.ln_Succ; INC(nodenum);
          END;
          SeekBack (2);
          FPutS (file," ];\n");
          FPrintF4 (file, ADR("  %s%ldList:=[y.ADR (%s%ldNodes[0]), NIL,"),ADR(eng^.gadgetLabel[0]), pnum, ADR(eng^.gadgetLabel[0]), pnum);
          FPrintF3 (file, ADR(" y.ADR (%s%ldNodes[%ld])];\n\n"), ADR(eng^.gadgetLabel[0]), pnum, nodenum-1);
(*      ELSE
          FPrintF4 (file, ADR("  %s%ldList.mlh_Head     := y.ADR (%s%ldList.tail);\n"), ADR(eng^.gadgetLabel[0]), pnum, ADR(eng^.gadgetLabel[0]), pnum);
          FPrintF2 (file, ADR("  %s%ldList.mlh_Tail     := NIL;\n"), ADR(eng^.gadgetLabel[0]), pnum);
          FPrintF4 (file, ADR("  %s%ldList.mlh_TailPred := y.ADR (%s%ldList.head);\n\n"), ADR(eng^.gadgetLabel[0]), pnum, ADR(eng^.gadgetLabel[0]), pnum);
*)      END;
      END;
    END;
    eng := eng^.succ;
  END;
END WriteNodes;

(* --- Write the TextAttr structure *)
PROCEDURE WriteTextAttr (scr,end:BOOLEAN);
VAR fname: str32;
    str:STRING;
BEGIN
  st.strcpy(fname,GuiData.fontName);
  str:=st.strchr (fname, '.'); str^[0]:=0C;
  IF scr AND NOT end THEN FPrintF2 (fdef, ADR("  %s%ld:g.TextAttr;\n\n"),
                                    ADR(fname), GuiData.font.ta_YSize);
  ELSE
    IF end THEN
      FPrintF2 (file,ADR("BEGIN\n  %s%ld:="),ADR(fname),GuiData.font.ta_YSize);
      FPrintF4 (file, ADR(' [y.ADR ("%s"), %ld, SHORTSET(0%02lxH), SHORTSET(0%02lxH) ];\n'),
                ADR(GuiData.fontName), GuiData.font.ta_YSize, CAST(SHORTINT,GuiData.font.ta_Style), CAST(SHORTINT,GuiData.font.ta_Flags));
    ELSE
      FPrintF2 (file, ADR("VAR %s%ld: g.TextAttr;\n"),ADR(fname),GuiData.font.ta_YSize);
    END;
  END;
END WriteTextAttr;

(* --- Write the Window Tags. *)
PROCEDURE WriteWindow (pw: gtx.ProjectWindowPtr);
BEGIN
  IF port IN MConfig THEN
    FPrintF (file, ADR("  %sWnd := OpenWindowTags ( NIL,\n"), ADR(pw^.name));
  ELSE
    FPrintF (file, ADR("  %sWnd := I.OpenWindowTags ( NIL,\n"), ADR(pw^.name));
  END;
  IF (gtx.FontAdapt IN MainConfig.configFlags0) OR (mouse IN MConfig) THEN
    FPutS (file, "                I.WA_Left,          wleft,\n");
    FPutS (file, "                I.WA_Top,           wtop,\n");
  ELSE
    FPrintF (file, ADR("                I.WA_Left,          %sLeft,\n"), ADR(pw^.name));
    FPrintF (file, ADR("                I.WA_Top,           %sTop,\n"), ADR(pw^.name));
  END;

  IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
    IF gtx.InnerWidth IN pw^.tagFlags THEN
      FPutS (file, "                I.WA_InnerWidth,    ");
    ELSE
      FPutS (file, "                I.WA_Width,         ");
    END;

    FPrintF (file, ADR("%sWidth,\n"), ADR(pw^.name));

    IF gtx.InnerHeight IN pw^.tagFlags THEN
      FPutS (file, "                I.WA_InnerHeight,   ");
    ELSE
      FPutS (file, "                I.WA_Height,        ");
    END;

    FPrintF (file, ADR("%sHeight"), ADR(pw^.name));
    IF ~(gtx.InnerHeight IN pw^.tagFlags) THEN FPutS (file, " + offy") END;
    FPutS (file, ",\n");

  ELSE
(*  FPutS (file, "                I.WA_Width,         ww + OffX + Scr^.WBorRight,\n");
    FPutS (file, "                I.WA_Height,        wh + OffY + Scr^.WBorBottom,\n");
*)
    FPutS (file, "                I.WA_InnerWidth,    ww,\n");
    FPutS (file, "                I.WA_InnerHeight,   wh,\n");
  END;

  FPutS (file, "                I.WA_IDCMP,         ");
  WriteIDCMPFlags (pw^.idcmp+I.REFRESHWINDOW, pw);

  FPutS (file, "                I.WA_Flags,         ");
  WriteWindowFlags (pw^.windowFlags);

  FPutS (file, "                I.WA_NewLookMenus,  TRUE,\n");

  IF ~(I.BACKDROP <= pw^.windowFlags) THEN
    IF st.strlen (pw^.windowTitle) > 0 THEN
      FPrintF (file, ADR('                I.WA_Title,         "%s",\n'), ADR(pw^.windowTitle[0]));
    END;
  END;

  IF st.strlen (pw^.screenTitle) > 0 THEN
    FPrintF (file, ADR('                I.WA_ScreenTitle,   "%s",\n'), ADR(pw^.screenTitle[0]));
  END;

  IF gtx.Custom IN GuiData.flags0 THEN
    FPutS (file, "                I.WA_CustomScreen,  Scr,\n");
  ELSIF gtx.Public IN GuiData.flags0 THEN
    FPutS (file, "                I.WA_PubScreen,     Scr,\n");
  END;

  IF I.WINDOWSIZING <= pw^.windowFlags THEN
    IF gtx.GTX_TagInArray (I.WA_MinWidth, u.TagPtr(pw^.tags)) THEN
      FPrintF (file, ADR("                I.WA_MinWidth,      %ld,\n"), u.GetTagData (I.WA_MinWidth, NIL, pw^.tags));
    END;
    IF gtx.GTX_TagInArray (I.WA_MinHeight, u.TagPtr(pw^.tags)) THEN
      FPrintF (file, ADR("                I.WA_MinHeight,     %ld,\n"), u.GetTagData (I.WA_MinHeight, NIL, pw^.tags));
    END;
    IF gtx.GTX_TagInArray (I.WA_MaxWidth, u.TagPtr(pw^.tags)) THEN
      FPrintF (file, ADR("                I.WA_MaxWidth,      %ld,\n"), u.GetTagData (I.WA_MaxWidth, NIL, pw^.tags));
    END;
    IF gtx.GTX_TagInArray (I.WA_MaxHeight, u.TagPtr(pw^.tags)) THEN
      FPrintF (file, ADR("                I.WA_MaxHeight,     %ld,\n"), u.GetTagData (I.WA_MaxHeight, NIL, pw^.tags));
    END;
  ELSE
    IF LONGSET{gtx.Zoom,gtx.DefaultZoom} * pw^.tagFlags # LONGSET{} THEN
      FPrintF (file, ADR("                I.WA_Zoom,          y.ADR (%sZoom),\n"), ADR(pw^.name));
    END;
  END;

  IF (NOT (raster IN MConfig)) AND (pw^.gadgets.head^.succ # NIL) THEN
    FPrintF (file, ADR('                I.WA_Gadgets,       %sGList,\n'),ADR(pw^.name));
  END;
  IF gtx.MouseQueue IN pw^.tagFlags THEN
    FPrintF (file, ADR("                I.WA_MouseQueue,    %ld,\n"), pw^.mouseQueue);
  END;
  IF gtx.RptQueue IN pw^.tagFlags THEN
    FPrintF (file, ADR("                I.WA_RptQueue,      %ld,\n"), pw^.rptQueue);
  END;
  IF gtx.AutoAdjust IN pw^.tagFlags THEN
    FPutS (file, "                I.WA_AutoAdjust,    TRUE,\n");
  END;
  IF gtx.FallBack IN pw^.tagFlags THEN
    FPutS (file, "                I.WA_PubScreenFallBack, TRUE,\n");
  END;

  FPutS (file, "                u.TAG_DONE);\n");
  FPrintF (file, ADR("  IF %sWnd = NIL THEN RETURN 20 END;\n\n"), ADR(pw^.name));
END WriteWindow;

(* --- Write the Screen Tags and screen specific data. *)
PROCEDURE WriteSTags (end:BOOLEAN);
VAR cnt: INTEGER;
BEGIN
  IF GuiData.colors[0].ColorIndex # -1 THEN
    IF end THEN
      FPutS (file, "  ScreenColors := [\n");
      cnt:=0;
      WHILE GuiData.colors[cnt].ColorIndex # -1 DO
        FPrintF4 (file, ADR("    [%2ld, 0%02lxH, 0%02lxH, 0%02lxH],\n"),
                  GuiData.colors[cnt].ColorIndex, GuiData.colors[cnt].Red, GuiData.colors[cnt].Green, GuiData.colors[cnt].Blue);
        INC (cnt);
      END;
      FPutS (file, "    [-1, 000H, 000H, 000H] ];\n");
    ELSE
      cnt:=0;
      WHILE (cnt<32) AND (GuiData.colors[cnt].ColorIndex#-1) DO INC (cnt); END;
      FPrintF (file, ADR("TYPE ColorArray = ARRAY [0..%ld] OF I.ColorSpec;\n"),cnt);
      FPutS (file, "VAR ScreenColors : ColorArray;\n");
    END;
  END;

  IF end THEN
    FPutS (file, "  DriPens := [");
    cnt:=0;
    WHILE (cnt<gtx.MaxDriPens) AND (GuiData.driPens[cnt] # -1) DO
      FPrintF (file, ADR("%ld,"), GuiData.driPens[cnt]);
      INC (cnt);       (*| Es fehlen: OS 3.0 Dri-Pens *)
    END;
    FPutS (file, "-1];\n");
  ELSE
    cnt:=0;
    WHILE (cnt<gtx.MaxDriPens) AND (GuiData.driPens[cnt]#-1) DO INC (cnt); END;
    FPrintF (file, ADR("TYPE DriPenArray = ARRAY [0..%ld] OF INTEGER;\n"),cnt);
    FPutS (file, "VAR DriPens : DriPenArray;\n");
  END;
END WriteSTags;

(* --- Write the Modula IntuiText structures. *)

PROCEDURE CountITexts (itxt: I.IntuiTextPtr): INTEGER;
VAR cnt: INTEGER;
BEGIN cnt:= 0; WHILE itxt # NIL DO INC(cnt); itxt := itxt^.NextText; END; RETURN (cnt);
END CountITexts;

PROCEDURE WriteIText ();
VAR pw: gtx.ProjectWindowPtr;
    t: I.IntuiTextPtr;
    i, bleft, btop, n: INTEGER;
    fname: str32;
    str:STRING;
BEGIN
  i := 1; n := 0;
  st.strcpy (fname,GuiData.fontName);
  str:=st.strchr (fname, '.'); str^[0]:=0C;

  pw := Projects.head;
  LOOP
    IF pw^.succ = NIL THEN EXIT ELSE
      IF pw^.windowText # NIL THEN FPutS (file, "VAR\n"); EXIT END;
      pw := pw^.succ;
    END;
  END;

  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    bleft := pw^.leftBorder; btop := pw^.topBorder;
    t := pw^.windowText;
    IF t # NIL THEN
      FPrintF2 (file, ADR("  %sIText: ARRAY [0..%ld] OF I.IntuiText;\n"), ADR(pw^.name), CountITexts (t)-1);
    END;
    pw := pw^.succ;
  END;
END WriteIText;

(* --- Write the NewGadget arrays. *)
PROCEDURE WriteGArray (end:BOOLEAN);
VAR pw: gtx.ProjectWindowPtr;
    g: gtx.ExtNewGadgetPtr;
    ng: gt.NewGadgetPtr;
    bleft, btop: INTEGER;
BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    bleft := pw^.leftBorder; btop := pw^.topBorder;
    IF pw^.gadgets.head^.succ # NIL THEN
      IF end THEN
        FPrintF2 (file, ADR("  %sNGad := GetMem (SIZE(%sNGadArray));\n"),
                  ADR(pw^.name), ADR(pw^.name));
        FPrintF (file, ADR("  %sNGad^ := [\n"),ADR(pw^.name));
        g := pw^.gadgets.head;
        WHILE g^.succ # NIL DO
          ng := ADR(g^.newGadget);
          FPrintF4 (file, ADR("    [%ld, %ld, %ld, %ld, "), ng^.ng_LeftEdge - bleft, ng^.ng_TopEdge - btop, ng^.ng_Width, ng^.ng_Height);
          IF (ng^.ng_GadgetText # NIL) & (st.strlen (ng^.ng_GadgetText) > 0) THEN
            FPrintF (file, ADR('"%s", NIL, '), ng^.ng_GadgetText);
          ELSE FPutS (file, "NIL, NIL, "); END;
          FPrintF (file, ADR("GD%s"), ADR(g^.gadgetLabel));
          IF ng^.ng_Flags # {} THEN
            FPutS (file,", ");
            WritePlaceFlags (ng^.ng_Flags);
          END;
          FPutS (file, "],\n");
          g := g^.succ;
        END;
        SeekBack (2);
        FPutS (file, " ];\n");
      ELSE
        FPrintF2 (file, ADR("TYPE %sNGadArray = ARRAY [0..%sCNT-1] OF gt.NewGadget;\n"),
                  ADR(pw^.name), ADR(pw^.name));
        FPrintF2 (file, ADR("VAR %sNGad : POINTER TO %sNGadArray;\n"),
                  ADR(pw^.name), ADR(pw^.name));
      END;
    END;
    pw := pw^.succ;
  END;
END WriteGArray;

PROCEDURE WriteGadHeader (pw: gtx.ProjectWindowPtr);
BEGIN
  FPrintF (file, ADR("PROCEDURE Create%sGadgets (): INTEGER;\n"), ADR(pw^.name));
  FPrintF (fdef, ADR("PROCEDURE Create%sGadgets (): INTEGER;\n"), ADR(pw^.name));

  FPutS (file, "VAR\n  ng: gt.NewGadget;\n  gad: I.GadgetPtr;\n");
  IF JoinedInWindow THEN FPutS (file, "  tmp, help: u.TagItemPtr;\n"); END;

  FPutS (file, "  lc, tc");

  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
    FPutS (file, ": INTEGER;\nBEGIN\n");
    FPrintF2 (file, ADR("  ComputeFont (%sWidth, %sHeight);\n\n"), ADR(pw^.name), ADR(pw^.name));
  ELSE
    FPutS (file, ", offx, offy: INTEGER;\nBEGIN\n");
    IF I.BACKDROP <= pw^.windowFlags THEN FPutS (file, "  offx := 0; ");
                                     ELSE FPutS (file, "  offx := Scr^.WBorLeft; ");
    END;
    FPutS (file, "offy := Scr^.WBorTop + Scr^.RastPort.TxHeight + 1;\n\n");
  END;
END WriteGadHeader;

(* --- Write the routine header. *)
PROCEDURE WriteHeader (pw: gtx.ProjectWindowPtr);
BEGIN
  FPrintF (file, ADR("PROCEDURE Open%sWindow ("),ADR(pw^.name));
  FPrintF (fdef, ADR("PROCEDURE Open%sWindow ("),ADR(pw^.name));
  IF pw^.gadgets.head^.succ # NIL THEN FPutS2 (ADR("createGads: BOOLEAN")); END;
  FPutS2 (ADR("): INTEGER;\n"));

  FPutS (file, "VAR ");
  IF pw^.gadgets.head^.succ # NIL THEN FPutS (file, "ret, "); END;

  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
    FPutS  (file, "wleft, wtop, ww, wh: INTEGER;\n");
    FPutS (file, "BEGIN\n");
    IF NOT (mouse IN MConfig) THEN
      FPrintF2 (file, ADR("  wleft := %sLeft; wtop := %sTop;\n\n"), ADR(pw^.name), ADR(pw^.name));
    END;

    FPrintF2 (file, ADR("  ComputeFont (%sWidth, %sHeight);\n\n"), ADR(pw^.name), ADR(pw^.name));
    FPrintF2 (file, ADR("  ww := ComputeX (%sWidth);\n  wh := ComputeY (%sHeight);\n\n"), ADR(pw^.name), ADR(pw^.name));

    IF mouse IN MConfig THEN
      FPutS (file, "  wleft := Scr^.MouseX - (ww DIV 2);\n  wtop  := Scr^.MouseY - (wh DIV 2);\n\n");
    ELSE
      FPutS (file, "  IF wleft + ww + OffX + Scr^.WBorRight > Scr^.Width THEN\n    wleft := Scr^.Width - ww;\n  END;\n");
      FPutS (file, "  IF wtop + wh + OffY + Scr^.WBorBottom > Scr^.Height THEN\n    wtop := Scr^.Height - wh;\n  END;\n\n");
    END;

    IF SysFont IN MConfig THEN
      FPrintF2 (file, ADR("  %sFont := df.OpenDiskFont (Font);\n  IF %sFont = NIL THEN RETURN 5 END;\n\n"), ADR(pw^.name), ADR(pw^.name));
    END;
  ELSE
    IF ~(gtx.InnerHeight IN pw^.tagFlags) THEN FPutS (file, "offy, ") END;
    IF mouse IN MConfig THEN FPutS (file, "wleft, wtop, ") END;
    SeekBack (2);
    FPutS (file, ": INTEGER;\nBEGIN\n");
    IF ~(gtx.InnerHeight IN pw^.tagFlags) THEN
       FPutS (file, "  offy := Scr^.WBorTop + Scr^.RastPort.TxHeight + 1;\n");
    END;
    IF mouse IN MConfig THEN
      FPrintF2 (file, ADR("  wleft := Scr^.MouseX - (%sWidth DIV 2);\n  wtop  := Scr^.MouseY - ((%sHeight"), ADR(pw^.name), ADR(pw^.name));
      IF ~(gtx.InnerHeight IN pw^.tagFlags) THEN FPutS (file, " + offy") END;
      FPutS (file, ") DIV 2);\n\n");
    END;
(*  IF I.BACKDROP <= pw^.windowFlags THEN FPutS (file, "  offx := 0; ");
                                     ELSE FPutS (file, "  offx := Scr^.WBorLeft; "); END; *)
  END;

  IF pw^.gadgets.head^.succ # NIL THEN
    FPrintF (file, ADR("  IF createGads THEN\n    ret := Create%sGadgets(); IF ret # 0 THEN RETURN ret END;\n  END;\n\n"),ADR(pw^.name));
  END;
END WriteHeader;

(* --- Write the gadget type array. *)
PROCEDURE WriteGTypes (end:BOOLEAN);
VAR pw: gtx.ProjectWindowPtr;
    eng: gtx.ExtNewGadgetPtr;
BEGIN
  pw := Projects.head;
  WHILE pw^.succ # NIL DO
    IF pw^.gadgets.head^.succ # NIL THEN
      IF end THEN
        FPrintF (file, ADR("  %sGTypes := [\n"),ADR(pw^.name));
        eng := pw^.gadgets.head;
        WHILE eng^.succ # NIL DO FPrintF (file, ADR("    gt.%s_KIND,\n"), goKinds[eng^.kind]); eng := eng^.succ; END;
        SeekBack (2);
        FPutS (file, " ];\n");
      ELSE
        FPrintF2 (file, ADR("TYPE %sGTypesArray = ARRAY [0..%sCNT-1] OF INTEGER;\n"),
                  ADR(pw^.name), ADR(pw^.name));
        FPrintF2 (file, ADR("VAR %sGTypes : %sGTypesArray;\n"),
                  ADR(pw^.name), ADR(pw^.name));
      END;
    END;
    pw := pw^.succ;
  END;
END WriteGTypes;

VAR TagNumbers:POINTER TO ARRAY OF LONGINT;
    TagNr:INTEGER;

PROCEDURE MarkTagNumber;
BEGIN
  TagNumbers^[TagNr]:=d.Seek (file,0,d.OFFSET_CURRENT);
  INC (TagNr);
  FPutS (file, "0000");
END MarkTagNumber;

PROCEDURE FixTagNumber (num: INTEGER);
VAR curpos: LONGINT;
BEGIN
  curpos := d.Seek (file, TagNumbers^[TagNr], d.OFFSET_BEGINNING);
  INC (TagNr);
  FPrintF (file,"%4ld",num);
  d.Seek (file, curpos, d.OFFSET_BEGINNING);
END FixTagNumber;

(* --- Write the gadget tagitem array. *)
PROCEDURE WriteGTags (end:BOOLEAN);
VAR pw: gtx.ProjectWindowPtr;
    g: gtx.ExtNewGadgetPtr;
    pnum,cnt: INTEGER;
    list: e.ListPtr;
    str: Pstr256;
    sj: BITSET;
    help:CARDINAL;
BEGIN
 IF NOT end THEN
   pw := Projects.head; pnum := 0;
   WHILE pw^.succ # NIL DO
     IF pw^.gadgets.head^.succ # NIL THEN INC (pnum); END;
     pw := pw^.succ;
   END; (* WHILE *)
   IF pnum>0 THEN
     TagNumbers:=m2.malloc (SIZE(LONGINT)*pnum);
     IF TagNumbers=NIL THEN m2._ErrorReq ("Not enought memory"," "); END;
   END;
 END;
 pw := Projects.head; pnum := 0; TagNr:=0;
 WHILE pw^.succ # NIL DO
  IF pw^.gadgets.head^.succ # NIL THEN
    g := pw^.gadgets.head;
    IF NOT end THEN
      FPrintF (file, ADR("TYPE %sGTagsArray = ARRAY [0.."),ADR(pw^.name));
      MarkTagNumber;
      FPutS (file, "] OF y.ADDRESS;\n");
      FPrintF2  (file, ADR("VAR %sGTags : POINTER TO %sGTagsArray;\n"),
                 ADR(pw^.name), ADR(pw^.name));
    ELSE
      FPrintF2  (file, ADR("  %sGTags := GetMem (SIZE(%sGTagsArray));\n"),
                 ADR(pw^.name), ADR(pw^.name));
      FPrintF (file, ADR("  %sGTags^ := [\n"),ADR(pw^.name));
      WHILE g^.succ # NIL DO
        FPutS (file, "    ");

        CASE g^.kind OF
            gt.CHECKBOX_KIND:
              IF gtx.GTX_TagInArray (gt.GTCB_Checked, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTCB_Checked), ORD(TRUE), "); INC(cnt,2);
              END;
              FPutS (file, "y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), "); INC(cnt,2);
          | gt.CYCLE_KIND:
              FPrintF2 (file, ADR("y.ADDRESS(gt.GTCY_Labels), y.ADR (%s%ldLabels[0]), "), ADR(g^.gadgetLabel[0]), pnum); INC(cnt,2);
              IF gtx.GTX_TagInArray (gt.GTCY_Active, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTCY_Active), %ld, "), u.GetTagData (gt.GTCY_Active, 0, g^.tags)); INC(cnt,2);
              END;
          | gt.INTEGER_KIND:
              IF gtx.GTX_TagInArray (LONGCARD(C.GA_TabCycle), u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.GA_TabCycle), ORD(FALSE), "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (LONGCARD(C.STRINGA_ExitHelp), u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.STRINGA_ExitHelp), ORD(TRUE), "); INC(cnt,2);
              END;
              FPrintF (file, ADR("y.ADDRESS(gt.GTIN_Number), %ld, "), u.GetTagData (gt.GTIN_Number, 0, g^.tags)); INC(cnt,2);
              FPrintF (file, ADR("y.ADDRESS(gt.GTIN_MaxChars), %ld, "), u.GetTagData (gt.GTIN_MaxChars, 5, CAST(u.TagItemPtr,g^.tags))); INC(cnt,2);
              help:=u.GetTagData (C.STRINGA_Justification, 0, g^.tags);
              sj:=BITSET(help);
              IF sj # {} THEN
                FPutS (file, "y.ADDRESS(C.STRINGA_Justification), y.ADDRESS(");
                IF I.STRINGCENTER <= sj THEN FPutS (file, "I.STRINGCENTER), ");
                                        ELSE FPutS (file, "I.STRINGRIGHT), ");
                END;
                INC(cnt,2);
              END;
          | gt.LISTVIEW_KIND:
              list := CAST(ADDRESS,u.GetTagData (gt.GTLV_Labels, NIL, g^.tags));
              IF list # NIL THEN
                IF (list^.lh_Head^.ln_Succ # NIL)
                 (*|  & (list^.head^.succ^.succ # NIL) *) THEN
                    FPrintF2 (file, ADR("y.ADDRESS(gt.GTLV_Labels), y.ADR (%s%ldList), "), ADR(g^.gadgetLabel[0]), pnum);
                    INC(cnt,2);
                END;
              END;
              IF gtx.NeedLock IN g^.flags THEN
                FPutS (file, "y.ADDRESS(gt.GTLV_ShowSelected), 1, "); INC(cnt,2);
              ELSIF gtx.GTX_TagInArray (gt.GTLV_ShowSelected,u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTLV_ShowSelected), NIL, "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTLV_ScrollWidth, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTLV_ScrollWidth), %ld, "), u.GetTagData (gt.GTLV_ScrollWidth, 0, CAST(u.TagItemPtr,g^.tags))); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTLV_ReadOnly, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTLV_ReadOnly), ORD(TRUE), "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (C.LAYOUTA_Spacing, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(C.LAYOUTA_Spacing), %ld, "), u.GetTagData (C.LAYOUTA_Spacing, 0, g^.tags)); INC(cnt,2);
              END;
          | gt.MX_KIND:
              FPrintF2 (file, ADR("y.ADDRESS(gt.GTMX_Labels), y.ADR (%s%ldLabels[0]), "), ADR(g^.gadgetLabel[0]), pnum); INC(cnt,2);
              IF gtx.GTX_TagInArray (gt.GTMX_Spacing, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTMX_Spacing), %ld, "), u.GetTagData (gt.GTMX_Spacing, 0, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTMX_Active, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTMX_Active), %ld, "), u.GetTagData (gt.GTMX_Active, 0, g^.tags)); INC(cnt,2);
              END;
              FPutS (file, "y.ADDRESS(gt.GTMX_Scaled), ORD(TRUE), "); INC(cnt,2);
          | gt.PALETTE_KIND:
              FPrintF (file, ADR("y.ADDRESS(gt.GTPA_Depth), %ld, "), u.GetTagData (gt.GTPA_Depth, 1, g^.tags)); INC(cnt,2);
              IF gtx.GTX_TagInArray (gt.GTPA_IndicatorWidth, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTPA_IndicatorWidth), %ld, "), u.GetTagData (gt.GTPA_IndicatorWidth, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTPA_IndicatorHeight, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTPA_IndicatorHeight), %ld, "), u.GetTagData (gt.GTPA_IndicatorHeight, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTPA_Color, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTPA_Color), %ld, "), u.GetTagData (gt.GTPA_Color, 1, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTPA_ColorOffset, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTPA_ColorOffset), %ld, "), u.GetTagData (gt.GTPA_ColorOffset, 0, g^.tags)); INC(cnt,2);
              END;
          | gt.SCROLLER_KIND:
              IF gtx.GTX_TagInArray (gt.GTSC_Top, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSC_Top), %ld, "), u.GetTagData (gt.GTSC_Top, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSC_Total, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSC_Total), %ld, "), u.GetTagData (gt.GTSC_Total, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSC_Visible, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSC_Visible), %ld, "), u.GetTagData (gt.GTSC_Visible, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSC_Arrows, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSC_Arrows), %ld, "), u.GetTagData (gt.GTSC_Arrows, 0, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (LONGCARD(C.PGA_Freedom), u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.PGA_Freedom), C.LORIENT_VERT, "); INC(cnt,2);
              ELSE
                FPutS (file, "y.ADDRESS(C.PGA_Freedom), C.LORIENT_HORIZ, "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (LONGCARD(C.GA_Immediate), u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.GA_Immediate), ORD(TRUE), "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (LONGCARD(C.GA_RelVerify), u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.GA_RelVerify), ORD(TRUE), "); INC(cnt,2);
              END;
          | gt.SLIDER_KIND:
              IF gtx.GTX_TagInArray (gt.GTSL_Min, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSL_Min), %ld, "), u.GetTagData (gt.GTSL_Min, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSL_Max, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSL_Max), %ld, "), u.GetTagData (gt.GTSL_Max, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSL_Level, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSL_Level), %ld, "), u.GetTagData (gt.GTSL_Level, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSL_MaxLevelLen, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTSL_MaxLevelLen), %ld, "), u.GetTagData (gt.GTSL_MaxLevelLen, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSL_LevelFormat, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR('y.ADDRESS(gt.GTSL_LevelFormat), y.ADR ("%s"), '), u.GetTagData (gt.GTSL_LevelFormat, NIL, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTSL_LevelPlace, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTSL_LevelPlace), y.ADDRESS(y.CAST(CARDINAL,"); INC(cnt,2);
                WritePlaceFlags (LONGSET(u.GetTagData (gt.GTSL_LevelPlace, NIL, g^.tags)));
                FPutS (file, ")), ");
              END;
              IF gtx.GTX_TagInArray (C.PGA_Freedom, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.PGA_Freedom), C.LORIENT_VERT, "); INC(cnt,2);
              ELSE
                FPutS (file, "y.ADDRESS(C.PGA_Freedom), C.LORIENT_HORIZ, "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (C.GA_Immediate, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.GA_Immediate), ORD(TRUE), "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (C.GA_RelVerify, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.GA_RelVerify), ORD(TRUE), "); INC(cnt,2);
              END;
          | gt.STRING_KIND:
              IF gtx.GTX_TagInArray (C.GA_TabCycle, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.GA_TabCycle), ORD(FALSE), "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (C.STRINGA_ExitHelp, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(C.STRINGA_ExitHelp), ORD(TRUE), "); INC(cnt,2);
              END;
              str := ADDRESS(u.GetTagData (gt.GTST_String, NIL, g^.tags));
              IF (str # NIL) & (st.strlen (ADDRESS(str)) > 0) THEN
                FPrintF (file, ADR('y.ADDRESS(gt.GTST_String), y.ADR ("%s"), '), str); INC(cnt,2);
              END;
              FPrintF (file, ADR("y.ADDRESS(gt.GTST_MaxChars), %ld, "), u.GetTagData (gt.GTST_MaxChars, 5, g^.tags)); INC(cnt,2);
              help:=u.GetTagData (C.STRINGA_Justification, 0, g^.tags);
              sj:=BITSET(help);
              IF sj # {} THEN
                FPutS (file, "y.ADDRESS(C.STRINGA_Justification), y.ADDRESS(");
                IF I.STRINGCENTER <= sj THEN FPutS (file, "I.STRINGCENTER), ");
                                        ELSE FPutS (file, "I.STRINGRIGHT), ");
                END;
                INC(cnt,2);
              END;
          | gt.NUMBER_KIND:
              IF gtx.GTX_TagInArray (gt.GTNM_Number, u.TagPtr(g^.tags)) THEN
                FPrintF (file, ADR("y.ADDRESS(gt.GTNM_Number), %ld, "), u.GetTagData (gt.GTNM_Number, 0, g^.tags)); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTNM_Border,u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTNM_Border), ORD(TRUE), "); INC(cnt,2);
              END;
          | gt.TEXT_KIND:
              str := ADDRESS(u.GetTagData (gt.GTTX_Text, NIL, g^.tags));
              IF (str # NIL) & (st.strlen (ADDRESS(str)) > 0) THEN
                FPrintF (file, ADR('y.ADDRESS(gt.GTTX_Text), y.ADR ("%s"), '), str); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTTX_Border, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTTX_Border), ORD(TRUE), "); INC(cnt,2);
              END;
              IF gtx.GTX_TagInArray (gt.GTTX_CopyText, u.TagPtr(g^.tags)) THEN
                FPutS (file, "y.ADDRESS(gt.GTTX_CopyText), ORD(TRUE), "); INC(cnt,2);
              END;
        ELSE
        END; (* CASE *)
        IF g^.kind # gt.GENERIC_KIND THEN
          IF gtx.GTX_TagInArray (gt.GT_Underscore, u.TagPtr(g^.tags)) THEN
            FPutS (file, "y.ADDRESS(gt.GT_Underscore), ORD ('_'), "); INC(cnt,2);
          END;
        END;

        IF gtx.GTX_TagInArray (C.GA_Disabled, u.TagPtr(g^.tags)) THEN
          FPutS (file, "y.ADDRESS(C.GA_Disabled), ORD(TRUE), "); INC(cnt,2);
        END;

        FPutS (file, "u.TAG_DONE,\n"); INC(cnt);
        g := g^.succ;
      END; (* WHILE *)
      SeekBack (2);
      FPutS (file, " ];\n");
      FixTagNumber (cnt-1);
    END;
  END;
  pw := pw^.succ; INC(pnum);
 END; (* WHILE *)
END WriteGTags;

(* --- Write the Modula Gadgets initialization. *)
PROCEDURE WriteGadgets (pw: gtx.ProjectWindowPtr);
VAR fname: str32;
    btop, bleft: INTEGER;
    str:STRING;
BEGIN
  btop := pw^.topBorder; bleft := pw^.leftBorder;

  st.strcpy (fname,GuiData.fontName);
  str:=st.strchr(fname,'.'); str^[0]:=0C;

  FPutS (file, "  lc := 0; tc := 0;\n");
  FPrintF (file, ADR("  WHILE lc < %sCNT DO\n"), ADR(pw^.name));
  FPrintF (file, ADR("    ng := %sNGad^[lc];\n"), ADR(pw^.name));

  FPutS (file, "    ng.ng_VisualInfo := VisualInfo;\n");

  IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
    FPutS (file, "    ng.ng_TextAttr   := Font;\n    ng.ng_LeftEdge   := OffX + ComputeX (ng.ng_LeftEdge);\n    ng.ng_TopEdge    := OffY + ComputeY (ng.ng_TopEdge);\n");
    FPutS (file, "    ng.ng_Width      := ComputeX (ng.ng_Width);\n    ng.ng_Height     := ComputeY (ng.ng_Height);\n\n");
  ELSE
    FPrintF2 (file, ADR("    ng.ng_TextAttr   := y.ADR (%s%ld);\n"), ADR(fname), GuiData.font.ta_YSize);
    FPutS (file, "    INC (ng.ng_LeftEdge, offx);\n    INC (ng.ng_TopEdge, offy);\n");
  END;

  IF JoinedInWindow THEN
    FPrintF (file, ADR("    help := u.CloneTagItems (y.ADR (%sGTags^[tc]));\n"), ADR(pw^.name));
    FPutS (file, "    IF help = NIL THEN RETURN 8 END;\n");
    FPrintF (file, ADR("    IF %sGTypes[lc] = gt.LISTVIEW_KIND THEN\n"), ADR(pw^.name));
    FPutS (file,"      tmp := u.FindTagItem (gt.GTLV_ShowSelected, help);\n      IF tmp # NIL THEN\n");
    FPutS (file,"        IF tmp^[0].ti_Data # 0 THEN tmp^[0].ti_Data := y.ADDRESS(gad) END;\n      END;\n");
    FPutS (file, "    END; (* IF *)\n");
    FPrintF (file,ADR("    gad := gt.CreateGadgetA (%sGTypes[lc], gad, ng, help);\n    u.FreeTagItems (help);\n"), ADR(pw^.name));
  ELSE
    FPrintF2 (file,ADR("    gad := gt.CreateGadgetA (%sGTypes[lc], gad, ng, y.ADR (%sGTags^[tc]));\n"), ADR(pw^.name), ADR(pw^.name));
  END; (* IF *)

  FPrintF (file,ADR("    IF gad = NIL THEN RETURN 2 END;\n    %sGadgets[lc] := gad;\n\n"), ADR(pw^.name));

  IF GetFileInWindow THEN
    FPrintF (file, ADR("    IF %sGTypes[lc] = gt.GENERIC_KIND THEN\n      INCL (gad^.Flags, I.GADGIMAGE+I.GADGHIMAGE);\n"),ADR(pw^.name));
    FPrintF (file, ADR("      IF u.FindTagItem (C.GA_Disabled,y.ADR (%sGTags^[tc]))#NIL THEN\n        INCL (gad^.Flags, I.GADGDISABLED);\n      END;\n"), ADR(pw^.name));
    FPrintF2 (file, ADR("      INCL (gad^.Activation, I.RELVERIFY);\n      gad^.GadgetRender := %sGetImage;\n      gad^.SelectRender := %sGetImage;\n    END; (* IF *)\n\n"),
                    ADR(pw^.name), ADR(pw^.name));
  END;

  FPrintF (file, ADR("    WHILE %sGTags^[tc] # u.TAG_DONE DO INC (tc, 2) END;\n    INC (tc);\n\n"), ADR(pw^.name));

  FPutS (file, "    INC (lc);\n  END; (* WHILE *)\n");
END WriteGadgets;

BEGIN
  InitConsts;
END MGTools.
