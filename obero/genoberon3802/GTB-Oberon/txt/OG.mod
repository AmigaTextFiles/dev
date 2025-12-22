(*--------------------------------------------------------------------------
  :Program.    OG (Original Gangster;-))
  :Author.     Stefan Kurtz
  :Address.    Auf dem Niederen Esch 10, 33607 Bielefeld, Germany, Planet Earth
  :Address.    InterNet -> stkurtz@post.uni-bielefeld.de
  :Address.    Z-Netz   -> ST.KURTZ@BIONIC.ZER.DE
  :Author.     Thomas Igracki
  :Address.    Obstallee 45, 13593 Berlin, Germany
  :Address.    UseNet -> lokai@cs.tu-berlin.de
  :Address.    Z-Netz -> T.Igracki@BAMP.ZER
  :Address.    Fido   -> Thomas Igracki (2:2403/10.40)
  :Author.     Kai Bolay [kai]
  :Address.    Snail Mail:              EMail:
  :Address.    Hoffmannstraße 168       UUCP: kai@amokle.stgt.sub.org
  :Address.    D-71229 Leonberg         FIDO: 2:2407/106.3
  :Copyright.  Thomas Igracki (If you like to use it, contact me!)
  :Language.   Oberon
  :Translator. Amiga Oberon V3.01d
  :Contents.   A Oberon SourceCode generator for GadgetToolsBox.
  :Usage.      OG NAME/A,TO=AS/A,RASTER/S,UNDERMOUSE/S
  :Remark.     OS2.0 Only!
  :History.    37.1 (14.04.93): Started to convert 'OberonGen' from C to Oberon
  :History.                     OberonGen V1.0 is by Kai Bolay & Jaba
  :History.    37.2 (15.04.93): Finished converting & tested it with all GUIs i have &
  :History.                     i didn't found any differences between mine & OberonGen!
  :History.    37.3 (15.04.93): Added background-pattern support (RASTER option)
  :History.    37.4 (16.04.93): Added PubScreen Support in SetupScreen().
  :History.    37.5 (16.04.93): Added new proc. Create%sGadgets() to be able to
  :History.                     create gadgets before & w/o opening the window!
  :History.    37.6 (19.04.92): In Render() RefreshGList/Window() added
  :History.    37.7 (01.05.93): Added option to open window under the mouse.
  :History.    37.8 (01.05.93): Added a new constant, %sHotKeys, which contains all hotkeys.
  :History.         Fixed a bug which prints a lonely 'VAR'.
  :History.         Changed some LOOPs to WHILEs, changed some r/w vars to r/o vars.
  :History.    37.9 (17.05.93): The IntuiTexts now prints after the bevelboxes.
  :History.    37.10 (17.05.93):Enhanced the %sRender() Proc.
  :History.    37.11 [kai] (03.06.93): removed Gfx39 reference
  :History.                            Write DrawRast() only once
  :History.                            added offx/offy to Open%sWnd()
  :History.                            disabled OddChk when necessary
  :History.                            imported Break and NoGuru
  :History.    38.00 (stefan) (17.06.93): This is a major update.
  :History.                     Break removed
  :History.                     Full MenuSupport added:
  :History.                     (in Procedures WriteObNewMenu() &
  :History.                      WriteObMenus() )
  :History.                     Now all menuItems & subItems are
  :History.                      fitted with their labels correctly.
  :History.                     The Labels are expored with proper IDs
  :History.                     (I wonder why no one noticed the missing
  :History.                      menuLabels before - neither kai & thomas
  :History.                      nor jan)
  :History.                     I.stringCenter & I.stringRight
  :History.                      corrected to LONGSET{I.xx}
  :History.                     g.Bitmap corrected to g.BitMap
  :History.    38.01 (stefan) (18.06.93)   WriteObSetupScreen improved:
  :History.                      If "" is specified for pubScreenName,
  :History.                      default pubScreen is taken (SetupScreen());
  :History.                     FORCE-switch added for blind overwriting
  :History.                      old source
  :History.                     added offx/offy Create%sGadgets
  :History.                     underscore-const added
  :History.                     gt.RefreshWindow() enabled (WriteOberonSource)
  :History.    38.02 (stefan)   lvList exported in WriteObList()
  :History.                     lvLists are now realy linked to their gads
  :History.                     some Consts moved into PROCs
  :History.                     lvListNodes are written at a proper
  :History.                       place now - the list is initalized in
  :History.                       Create%sGadgets
  :History.                     RectFill() (RASTER) would crash
  :History.                      sometimes (e.g if window is zoomed to min)
  :History.                      Check added.
  :History.                     lvSelected-Tag added: Now the first entry
  :History.                      of a lvList is selected (if lvShowSelected)
---------------------------------------------------------------------------*)

MODULE OG;
IMPORT NoGuru, e : Exec, I : Intuition, G : Graphics, d : Dos, u : Utility,
       gt : GadTools, df : DiskFont, gtx : GadToolsBox, nf : NoFragLib,
       st : Strings, s : SYSTEM;

CONST
   tmp = "NAME/A,TO=AS/A,RASTER/S,UNDERMOUSE/S,FORCE/S";
   VERSION = '$VER: OG 38.02 (18.6.93) by Stefan Kurtz - Original Version by Thomas Igracki';

VAR
   goTagOffset, goGadOffset, goScreenOffset: INTEGER;
TYPE
   TagItemArray = UNTRACED POINTER TO ARRAY MAX(INTEGER) OF u.TagItem;
   numKindsType = ARRAY gt.numKinds OF e.STRPTR;
   BoolsArrayType = ARRAY gt.numKinds OF BOOLEAN;

VAR
   dosBase      : d.DosLibraryPtr;
   goDone       : BoolsArrayType;
   Path         : ARRAY 512 OF CHAR;
   FixUpNumPos  : LONGINT; (* Buffer to save the destination path in. *)

   RD           : d.RDArgsPtr;
   args         : STRUCT
                     name,                 (* GUI file name. *)
                     baseName: e.STRPTR;   (* Base name of the source *)
                     raster,               (* background pattern? *)
                     mouse,                (* Open window under the mouse? *)
                     force   : I.LONGBOOL; (* Write source without checking for old one *)
                  END;

   file         : d.FileHandlePtr;
   chain        : nf.MemoryChainPtr;
   error        : LONGINT;

   GuiData      : gtx.GUIDATA;
   MainConfig   : gtx.GadToolsConfig;
   Projects     : gtx.WindowList;
   ValidBits    : LONGINT;
   ObConfig     : STRUCT configFlags0,configFlags1: LONGSET END;

   GetFileInWindow,
   JoinedInWindow,
   ListViewLists,
   GetFilePresent: BOOLEAN;

(* $Debug- *)
PROCEDURE Overwrite (name: ARRAY OF CHAR): BOOLEAN; (* $CopyArrays- *)
VAR
   ez: I.EasyStruct;
BEGIN
    ez.title        := s.ADR("OG Request");
    ez.textFormat   := s.ADR('"%s" already exists!\nOverwrite?');
    ez.gadgetFormat := s.ADR('Yes|No');

    RETURN I.EasyRequest (NIL,s.ADR(ez),NIL,s.ADR(name))#0;
END Overwrite;

(* Open a file carefully. *)
PROCEDURE OpenSafe (name: ARRAY OF CHAR): d.FileHandlePtr; (* $CopyArrays- *)
VAR
   handle: d.FileHandlePtr;
BEGIN
     handle := d.Open (name, d.oldFile);
     IF (handle#NIL) THEN
        d.OldClose (handle); IF ~Overwrite (name) THEN RETURN NIL END;
     END;
     RETURN d.Open (name, d.newFile);
END OpenSafe;

PROCEDURE FPrintF* {dosBase,-354}(fh{1}        : d.FileHandlePtr;
                                  format{2}    : ARRAY OF CHAR;
                                  arg1{3}..    : e.APTR);
PROCEDURE FPutS*   {dosBase,-342}(fh{1}        : d.FileHandlePtr;
                                  str{2}       : ARRAY OF CHAR);

PROCEDURE MarkNumber;
BEGIN     FixUpNumPos := d.Seek (file, 0, d.current); FPutS (file, "00000");
END MarkNumber;

PROCEDURE FixNumber (num: INTEGER);
VAR curpos: LONGINT;
BEGIN
     curpos := d.Seek (file, FixUpNumPos, d.beginning);
     FPrintF (file, "%5ld", num);
     s.SETREG(0,d.Seek (file, curpos, d.beginning));
END FixNumber;

PROCEDURE SeekBack (num: INTEGER); (* Seek num pos backwards *)
BEGIN     s.SETREG(0,d.Seek (file, -num, d.current));
END SeekBack;

(*
 * --- Check for the presence of GETFILE and joined LISTVIEWS.
 * --- This routine is called for each window that get's generated.
 *)
 (* $Debug= *)
PROCEDURE CheckItOut (pw: gtx.ProjectWindowPtr);
VAR eng: gtx.ExtNewGadgetPtr;
BEGIN
     JoinedInWindow := FALSE; GetFileInWindow := FALSE;

     eng := pw.gadgets.head;
     WHILE (eng.succ # NIL) & ~(GetFileInWindow & JoinedInWindow) DO
        IF (eng.kind = gt.listViewKind) & (gtx.NeedLock IN eng.flags) THEN JoinedInWindow := TRUE END;
        IF eng.kind = gt.genericKind THEN GetFileInWindow := TRUE END;
        eng := eng.succ;
     END;

END CheckItOut;
 (* $Debug- *)

(* --- Check for the presence of GETFILE at all *)
PROCEDURE CheckGetFile;
VAR eng: gtx.ExtNewGadgetPtr; pw: gtx.ProjectWindowPtr;
BEGIN
     GetFilePresent := FALSE;

     pw := Projects.head;
     WHILE (pw.succ # NIL) & ~GetFilePresent DO
        eng := pw.gadgets.head;
        WHILE (eng.succ # NIL) & ~GetFilePresent DO
           IF (eng.kind = gt.genericKind) THEN GetFilePresent := TRUE END; eng := eng.succ;
        END;
        pw := pw.succ;
     END;
END CheckGetFile;

(* --- Write placement flags. *)
PROCEDURE WriteObPlaceFlags (flags: LONGSET);
BEGIN
     FPutS (file, "LONGSET {");

     IF flags = LONGSET{} THEN FPutS (file, "}"); RETURN END;

     IF    gt.placeTextLeft  IN flags THEN FPutS (file, "gt.placeTextLeft,")
     ELSIF gt.placeTextRight IN flags THEN FPutS (file, "gt.placeTextRight,")
     ELSIF gt.placeTextAbove IN flags THEN FPutS (file, "gt.placeTextAbove,")
     ELSIF gt.placeTextBelow IN flags THEN FPutS (file, "gt.placeTextBelow,")
     ELSIF gt.placeTextIn    IN flags THEN FPutS (file, "gt.placeTextIn,")
     END;
     IF gt.highLabel IN flags THEN FPutS (file, "gt.highLabel,") END;

     SeekBack(1);
     FPutS (file, "}");
END WriteObPlaceFlags;

(* --- Write DisplayID flags. *)
PROCEDURE WriteObIDFlags (flags: LONGSET);
CONST
  palMonitor  = s.VAL (LONGSET, G.palMonitorID);
  ntscMonitor = s.VAL (LONGSET, G.ntscMonitorID);

  superLaceKeyLs = s.VAL (LONGSET, G.superLaceKey);
  hiresLaceKeyLs = s.VAL (LONGSET, G.hiresLaceKey);
  loresLaceKeyLs = s.VAL (LONGSET, G.loresLaceKey);
  superKeyLs     = s.VAL (LONGSET, G.superKey);
  hiresKeyLs     = s.VAL (LONGSET, G.hiresKey);

BEGIN
     IF    palMonitor  * flags # LONGSET{} THEN FPutS (file, "g.palMonitorID+")
     ELSIF ntscMonitor * flags # LONGSET{} THEN FPutS (file, "g.ntscMonitorID+")
                                           ELSE FPutS (file, "g.defaultMonitorID+")
     END;

     IF    superLaceKeyLs * flags # LONGSET{} THEN FPutS (file, "g.superLaceKey+")
     ELSIF hiresLaceKeyLs * flags # LONGSET{} THEN FPutS (file, "g.hiresLaceKey+")
     ELSIF loresLaceKeyLs * flags # LONGSET{} THEN FPutS (file, "g.loresLaceKey+")
     ELSIF superKeyLs     * flags # LONGSET{} THEN FPutS (file, "g.superKey+")
     ELSIF hiresKeyLs     * flags # LONGSET{} THEN FPutS (file, "g.hiresKey+")
                                              ELSE FPutS (file, "g.loresKey+")
     END;

     SeekBack(1);
     FPutS (file, ",\n");
END WriteObIDFlags;

(* --- Write the IntuiText drawmode flags. *)
PROCEDURE WriteObDrMd (drmd: SHORTSET);
BEGIN
     IF G.jam2 * drmd # SHORTSET{} THEN FPutS (file, "g.jam2") ELSE FPutS (file, "g.jam1") END;

     FPutS (file, "+SHORTSET { ");

     IF G.complement IN drmd THEN FPutS (file, "g.complement,") END;
     IF G.inversvid  IN drmd THEN FPutS (file, "g.inversvid,") END;

     SeekBack(1);
     FPutS (file, "}");
END WriteObDrMd;

(* --- Write GadTools IDCMP flags. *)
PROCEDURE WriteObGadToolsIDCMP (pw: gtx.ProjectWindowPtr);
TYPE  goIdcmpType = numKindsType;

CONST goIdcmp = goIdcmpType(
            s.ADR("LONGSET {I.gadgetUp}"), s.ADR("gt.buttonIDCMP"),  s.ADR("gt.checkBoxIDCMP"),
            s.ADR("gt.integerIDCMP"),      s.ADR("gt.listViewIDCMP"),s.ADR("gt.mxIDCMP"),
            s.ADR("gt.numberIDCMP"),       s.ADR("gt.cycleIDCMP"),   s.ADR("gt.paletteIDCMP"),
            s.ADR("gt.scrollerIDCMP"),     s.ADR("RESERVED"),        s.ADR("gt.sliderIDCMP"),
            s.ADR("gt.stringIDCMP"),       s.ADR("gt.textIDCMP"));

      FalseArray = BoolsArrayType(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,
                                  FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);
VAR eng: gtx.ExtNewGadgetPtr;
BEGIN
     goDone := FalseArray;
     eng := pw.gadgets.head;
     WHILE eng.succ # NIL DO
         IF ~goDone [eng.kind] THEN
            FPrintF (file, "%s+", goIdcmp[eng.kind]);
            goDone[eng.kind] := TRUE;
            IF eng.kind = gt.scrollerKind THEN
               IF gtx.TagInArray (gt.scArrows, s.VAL(TagItemArray,eng.tags)^) THEN
                  FPutS (file, "gt.arrowIDCMP+")
               END;
            END;
         END;
         eng := eng.succ;
     END;
END WriteObGadToolsIDCMP;

(* --- Write IDCMP flags. *)
PROCEDURE WriteObIDCMPFlags (idcmp: LONGSET; pw: gtx.ProjectWindowPtr);
BEGIN
     IF idcmp = LONGSET{} THEN FPutS (file, "LONGSET {},\n"); RETURN END;

     WriteObGadToolsIDCMP (pw);

     FPutS (file, "LONGSET {");

     IF I.gadgetUp IN idcmp THEN
        IF ~goDone[0 ] & ~goDone[1 ] &
           ~goDone[2 ] & ~goDone[3 ] &
           ~goDone[4 ] & ~goDone[7 ] &
           ~goDone[8 ] & ~goDone[9 ] &
           ~goDone[11] & ~goDone[12] THEN FPutS (file, "I.gadgetUp,");
        END;
     END;

     IF I.gadgetDown IN idcmp THEN
        IF ~goDone[4] & ~goDone[5 ] & ~goDone[9] & ~goDone[11] THEN
            FPutS (file, "I.gadgetDown,")
        END;
     END;

     IF I.intuiTicks IN idcmp THEN
        IF ~goDone[4] & ~goDone[9] THEN FPutS (file, "I.intuiTicks,") END;
     END;

     IF I.mouseMove IN idcmp THEN
        IF ~goDone[4 ] & ~goDone[9 ] & ~goDone[11] THEN
           FPutS (file, "I.mouseMove,")
        END;
     END;

     IF I.mouseButtons IN idcmp THEN
        IF ~goDone[4] & ~goDone[9] THEN FPutS (file, "I.mouseButtons,") END;
     END;

     IF I.sizeVerify    IN idcmp THEN FPutS (file, "I.sizeVerify,") END;
     IF I.newSize       IN idcmp THEN FPutS (file, "I.newSize,") END;

     IF I.reqSet        IN idcmp THEN FPutS (file, "I.reqSet,") END;
     IF I.menuPick      IN idcmp THEN FPutS (file, "I.menuPick,") END;
     IF I.closeWindow   IN idcmp THEN FPutS (file, "I.closeWindow,") END;
 
     IF I.rawKey        IN idcmp THEN FPutS (file, "I.rawKey,") END;
     IF I.reqVerify     IN idcmp THEN FPutS (file, "I.reqVerify,") END;
     IF I.reqClear      IN idcmp THEN FPutS (file, "I.reqClear,") END;
     IF I.menuVerify    IN idcmp THEN FPutS (file, "I.menuVerify") END;
     IF I.newPrefs      IN idcmp THEN FPutS (file, "I.newPrefs,") END;
     IF I.diskInserted  IN idcmp THEN FPutS (file, "I.diskInserted,") END;

     IF I.diskRemoved    IN idcmp THEN FPutS (file, "I.diskRemoved,") END;
     IF I.activeWindow   IN idcmp THEN FPutS (file, "I.activeWindow,") END;
     IF I.inactiveWindow IN idcmp THEN FPutS (file, "I.inactiveWindow,") END;
     IF I.deltaMove      IN idcmp THEN FPutS (file, "I.deltaMove,") END;
     IF I.vanillaKey     IN idcmp THEN FPutS (file, "I.vanillaKey,") END;
     IF I.idcmpUpdate    IN idcmp THEN FPutS (file, "I.idcmpUpdate,") END;

     IF I.menuHelp      IN idcmp THEN FPutS (file, "I.menuHelp,") END;
     IF I.changeWindow  IN idcmp THEN FPutS (file, "I.changeWindow,") END;
     IF I.refreshWindow IN idcmp THEN FPutS (file, "I.refreshWindow,") END;

     SeekBack(1);
     FPutS (file, "},\n");
END WriteObIDCMPFlags;

(* --- Write window flags. *)
PROCEDURE WriteObWindowFlags (flags: LONGSET);
BEGIN
    FPutS (file, "LONGSET {");

    IF I.windowSizing   IN flags THEN FPutS (file, "I.windowSizing,") END;
    IF I.windowDrag     IN flags THEN FPutS (file, "I.windowDrag,") END;
    IF I.windowDepth    IN flags THEN FPutS (file, "I.windowDepth,") END;
    IF I.windowClose    IN flags THEN FPutS (file, "I.windowClose,") END;
    IF I.sizeBRight     IN flags THEN FPutS (file, "I.sizeBRight,") END;
    IF I.sizeBBottom    IN flags THEN FPutS (file, "I.sizeBBottom,") END;
   (* IF I.smartRefresh IN flags THEN FPutS (file, "I.smartRefresh,") END; *)
    IF I.simpleRefresh  IN flags THEN FPutS (file, "I.simpleRefresh,") END;
    IF I.superBitMap    IN flags THEN FPutS (file, "I.superBitMap,") END;
    IF I.otherRefresh * flags # LONGSET{} THEN FPutS (file, "6,7,") END;
    IF I.backDrop       IN flags THEN FPutS (file, "I.backDrop,") END;
    IF I.reportMouse    IN flags THEN FPutS (file, "I.reportMouse,") END;
    IF I.gimmeZeroZero  IN flags THEN FPutS (file, "I.gimmeZeroZero,") END;
    IF I.borderless     IN flags THEN FPutS (file, "I.borderless,") END;
    IF I.activate       IN flags THEN FPutS (file, "I.activate,") END;
    IF I.rmbTrap        IN flags THEN FPutS (file, "I.rmbTrap,") END;

    SeekBack(1);
    FPutS (file, "},\n");
END WriteObWindowFlags;

(* --- Write a single NewMenu structure. *)
PROCEDURE WriteObNewMenu (menu: gtx.ExtNewMenuPtr);
TYPE  goTypesType = ARRAY  4 OF e.STRPTR;
CONST goTypes = goTypesType(s.ADR("end"), s.ADR("title"),
                            s.ADR("item"), s.ADR("sub"));
VAR flags: SET;
BEGIN
    FPrintF (file, "    gt.%s, ", goTypes[menu.newMenu.type]);
    IF menu.newMenu.label # gt.barLabel THEN
       FPrintF (file, 'y.ADR ("%s"), ', s.ADR(menu.menuTitle));
    ELSE
       FPutS (file, "gt.barLabel, NIL, {}, LONGSET {}, NIL,\n");
       RETURN;
    END;
    IF menu.newMenu.commKey # NIL THEN FPrintF (file, 'y.ADR ("%s"), ', s.ADR(menu.commKey));
                                  ELSE FPutS (file, "NIL, ");
    END;
    FPutS (file, "{");
    flags := menu.newMenu.flags;
    IF flags # SET{} THEN
        IF menu.newMenu.type = gt.title THEN
            IF gt.menuDisabled IN flags THEN FPutS (file, "gt.menuDisabled,") END;
        ELSE 
            IF gt.itemDisabled IN flags THEN FPutS (file, "gt.itemDisabled,") END;
        END;
        IF I.checkIt    IN flags THEN FPutS (file, "I.checkIt,") END;
        IF I.checked    IN flags THEN FPutS (file, "I.checked,") END;
        IF I.menuToggle IN flags THEN FPutS (file, "I.menuToggle,") END;

        SeekBack(1);
    END;

    FPrintF (file, "}, y.VAL (LONGSET, %ld), ", menu.newMenu.mutualExclude);
    IF menu.menuLabel#"" THEN
       FPrintF (file, "%s,\n",s.ADR(menu.menuLabel))
    ELSE
       FPutS (file, "NIL,\n")
    END;
END WriteObNewMenu;

(* --- Write the NewMenu structures. *)
PROCEDURE WriteObMenus ();
VAR
   pw: gtx.ProjectWindowPtr;
   menu,item,sub: gtx.ExtNewMenuPtr;
   cnt: INTEGER;
BEGIN
     pw := Projects.head;
     WHILE pw.succ # NIL DO
        IF pw.menus.head.succ # NIL THEN

            FPrintF (file, "TYPE\n  %sMArray = ARRAY ", s.ADR(pw.name));
            MarkNumber; cnt := 0;
            FPrintF (file, " OF gt.NewMenu;\n"
                           "CONST\n  %sNewMenu = %sMArray (\n", s.ADR(pw.name), s.ADR(pw.name));

            menu := pw.menus.head;
            WHILE menu.succ # NIL DO
                WriteObNewMenu(menu); INC(cnt);
                IF menu.items # NIL THEN
                   item := menu.items.head;
                   WHILE item.succ # NIL DO
                       WriteObNewMenu(item); INC(cnt);
                       IF item.items # NIL THEN 
                          sub := item.items.head;
                          WHILE sub.succ # NIL DO
                              WriteObNewMenu (sub); INC(cnt); sub := sub.succ;
                          END;
                       END;
                       item := item.succ;
                   END;
                END;
                menu := menu.succ;
            END; (* WHILE *)
            FPutS (file, "    gt.end, NIL, NIL, {}, LONGSET {}, NIL);\n\n"); INC(cnt);
            FixNumber (cnt);
        END;
        pw := pw.succ;
     END; (* WHILE *)
END WriteObMenus;

PROCEDURE GetKey (str: ARRAY OF CHAR): CHAR; (* $CopyArrays- *)
VAR p: LONGINT;
BEGIN     p := st.Occurs (str,'_'); IF p = -1 THEN RETURN '' ELSE RETURN CAP(str[p+1]) END;
END GetKey;

(* --- Write the GadgetID defines. *)
PROCEDURE WriteObID ();
VAR pw     : gtx.ProjectWindowPtr;
    eng    : gtx.ExtNewGadgetPtr;
    menu,menuItem, subItem  : gtx.ExtNewMenuPtr;
    menuID : INTEGER;

BEGIN
    menuID:=0;
    FPutS (file, "CONST\n");

    pw := Projects.head;
    WHILE pw.succ # NIL DO
         IF pw.gadgets.head.succ # NIL THEN
            FPrintF (file, '  %sHotKeys * = "',s.ADR(pw.name));
            eng := pw.gadgets.head;
            WHILE eng.succ # NIL DO
               FPrintF (file, "%lc", ORD(GetKey(eng.gadgetText)));
               eng := eng.succ;
            END;
            FPutS (file, '";\n');

            eng := pw.gadgets.head;
            WHILE eng.succ # NIL DO
               FPrintF (file, "  GD%-32s* = %ld;\n", s.ADR(eng.gadgetLabel), eng.newGadget.gadgetID);
               eng := eng.succ;
            END;
            FPutS (file, "\n");
         END;


         (*
            Achtung! Da die GTB keine MenuIDs erzeugt, tun wir das hier
            selber. Irgendwelche Aufwärtskompatibilitäten zu zukünftigen
            GTB-MenuIDs sind damit _nicht_ zu erwarten!
            Wer Lust hat, kann diese Zeilen auch in eine hübsche
            rekursive Prozedur umsetzen ;-)
            Stefan.
          *)

         IF pw.menus.head.items # NIL THEN
            FPutS(file,"\n(* menuLabels *)\n");
            menu:=pw.menus.head;
            WHILE menu.succ#NIL DO
              menuItem:=menu.items.head;
              WHILE menuItem.succ # NIL DO
                 IF menuItem.menuLabel#"" THEN
                    FPrintF (file, "  %-32s* = %ld;\n", s.ADR(menuItem.menuLabel), LONG(menuID));
                    INC(menuID);
                 ELSIF menuItem.items.head#NIL THEN
                       subItem:=menuItem.items.head;
                       WHILE subItem.succ # NIL DO
                          IF subItem.menuLabel#"" THEN
                             FPrintF (file, "  %-32s* = %ld;\n", s.ADR(subItem.menuLabel), LONG(menuID));
                             INC(menuID);
                          END;   (* IF *)
                          subItem := subItem.succ;
                       END;      (* WHILE *)
                 END;            (* IF/ELSIF *)
                 menuItem := menuItem.succ;
              END;               (* WHILE *)
            menu:=menu.succ;
            END; (* WHILE *)
            FPutS(file,"\n");
         END;                  (* IF *)

         pw := pw.succ;
    END; (* WHILE *)
END WriteObID;

(* --- Check FOR OpenFont source genertion. *)
PROCEDURE CheckFont(): BOOLEAN;
VAR
   gf: BOOLEAN;
BEGIN
    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN RETURN FALSE END;
    gf := gtx.GenOpenFont IN ObConfig.configFlags0;
    IF gf & (G.romFont IN GuiData.font.flags) THEN RETURN TRUE END;

    RETURN FALSE;
END CheckFont;

(* --- Write the necessary globals. *)
PROCEDURE WriteObGlob();
VAR
   pw: gtx.ProjectWindowPtr;
   btop: INTEGER;
BEGIN
    FPutS  (file, "CONST\n");

    pw := Projects.head;
    WHILE pw.succ # NIL DO
        btop := pw.topBorder;

        FPrintF (file, "  %sCNT = %ld;\n  %sLeft = %ld;\n  %sTop = %ld;\n",
                 s.ADR(pw.name), gtx.CountNodes (pw.gadgets),
                 s.ADR(pw.name), u.GetTagData (I.waLeft, 0, s.VAL(TagItemArray,pw.tags)^),
                 s.ADR(pw.name), u.GetTagData (I.waTop, 0, s.VAL(TagItemArray,pw.tags)^));

        IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
            FPrintF (file, "  %sWidth = ", s.ADR(pw.name));

            IF gtx.InnerWidth IN pw.tagFlags THEN
               FPrintF (file, "%ld;\n", pw.innerWidth);
            ELSE
               FPrintF (file, "%ld;\n", u.GetTagData (I.waWidth, NIL, s.VAL(TagItemArray,pw.tags)^));
            END;

            FPrintF (file, "  %sHeight = ", s.ADR(pw.name));

            IF gtx.InnerHeight IN pw.tagFlags THEN
               FPrintF (file, "%ld;\n", pw.innerHeight);
            ELSE
               FPrintF (file, "%ld;\n", u.GetTagData (I.waHeight, NIL, s.VAL(TagItemArray,pw.tags)^) - btop);
            END;
        ELSE 
            FPrintF (file, "  %sWidth = %ld;\n"
                           "  %sHeight = %ld;\n", s.ADR(pw.name), pw.innerWidth, s.ADR(pw.name), pw.innerHeight);
        END;
        pw := pw.succ;
    END; (* WHILE *)

    FPutS (file, "VAR\n  Scr-: I.ScreenPtr;\n  VisualInfo-: e.APTR;\n");

    pw := Projects.head;
    WHILE pw.succ # NIL DO
        FPrintF (file, "  %sWnd-: I.WindowPtr;\n", s.ADR(pw.name));
        IF pw.gadgets.head.succ # NIL THEN
           FPrintF (file, "  %sGList-: I.GadgetPtr;\n"
                          "  %sGadgets*: ARRAY %sCNT OF I.GadgetPtr;\n", s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name));
        END;
        IF pw.menus.head.succ # NIL THEN
           FPrintF (file, "  %sMenus-: I.MenuPtr;\n", s.ADR(pw.name));
        END;
        IF LONGSET{gtx.Zoom,gtx.DefaultZoom} * pw.tagFlags # LONGSET{} THEN
           IF ~(I.windowSizing IN pw.windowFlags) THEN
              FPrintF (file, "  %sZoom-: ARRAY 4 OF INTEGER;\n", s.ADR(pw.name));
           END;
        END;
        pw := pw.succ
    END;

    IF CheckFont() THEN FPutS (file, "  Font-: g.TextFontPtr;\n") END;

    IF GetFilePresent THEN FPutS (file, "  GetImage: I.ObjectPtr;\n") END;

    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        FPutS (file, "  Font-: g.TextAttrPtr;\n"
                     "  Attr-: g.TextAttr;\n"
                     "  FontX, FontY: INTEGER;\n"
                     "  OffX, OffY: INTEGER;\n");

        IF gtx.SysFont IN ObConfig.configFlags0 THEN
            pw := Projects.head;
            WHILE pw.succ # NIL DO
                FPrintF (file, "  %sFont-: g.TextFontPtr;\n", s.ADR(pw.name));
                pw := pw.succ;
            END;
        END;
    END;

    s.SETREG(0,d.FPutC (file, ORD('\n')));
END WriteObGlob;

(* --- Write the Cycle and Mx lables. *)
PROCEDURE WriteObLabels();
VAR
   pw: gtx.ProjectWindowPtr;
   eng: gtx.ExtNewGadgetPtr;
   i,pnum: INTEGER;
   labels: UNTRACED POINTER TO ARRAY MAX(INTEGER) OF e.STRPTR;
   cnt: INTEGER;
BEGIN
    pw := Projects.head; pnum := 0;
    WHILE pw.succ # NIL DO
        eng := pw.gadgets.head;
        WHILE eng.succ # NIL DO
            IF (eng.kind = gt.cycleKind) OR (eng.kind = gt.mxKind) THEN
                IF (eng.kind = gt.cycleKind) THEN
                   labels := s.VAL(e.APTR,u.GetTagData (gt.cyLabels, NIL, s.VAL(TagItemArray,eng.tags)^));
                ELSE
                   labels := s.VAL(e.APTR,u.GetTagData (gt.mxLabels, NIL, s.VAL(TagItemArray,eng.tags)^));
                END;
                FPrintF (file, "TYPE\n  %s%ldLArray = ARRAY ", s.ADR(eng.gadgetLabel), pnum);
                MarkNumber; cnt := 0;
                FPutS (file, " OF e.STRPTR;\nCONST\n");
                FPrintF (file, "  %s%ldLabels = %s%ldLArray (\n", s.ADR(eng.gadgetLabel), pnum, s.ADR(eng.gadgetLabel), pnum);
                FOR i := 0 TO 23 DO
                    IF labels[i] # NIL THEN
                        FPrintF (file, "    y.ADR (\"%s\"),\n", labels[i]); INC(cnt);
                    END;
                END;
                FPutS (file, "    NIL);\n\n"); INC(cnt);
                FixNumber (cnt);
            END;
            eng := eng.succ;
        END; (* WHILE *)
        pw := pw.succ; INC(pnum);
    END; (* WHILE *)
END WriteObLabels;

PROCEDURE WriteObList();
VAR
   pw: gtx.ProjectWindowPtr;
   eng: gtx.ExtNewGadgetPtr;
   list: e.ListPtr;
   pnum: INTEGER;
BEGIN
    FPutS (file, "VAR\n");

    pw := Projects.head; pnum := 0;
    WHILE pw.succ # NIL DO
        eng := pw.gadgets.head;
        WHILE eng.succ # NIL DO
            IF eng.kind = gt.listViewKind THEN
                list := s.VAL(e.APTR,u.GetTagData (gt.lvLabels, 0, s.VAL(TagItemArray,eng.tags )^));
                IF list # NIL THEN 
                    FPrintF( file, "  %s%ldList*: e.MinList;\n", s.ADR(eng.gadgetLabel), pnum);
                    IF list.head.succ # NIL THEN
                       FPrintF (file, "  %s%ldNodes: ARRAY %ld OF e.Node;\n", s.ADR(eng.gadgetLabel), pnum, gtx.CountNodes (list^));
                       ListViewLists := TRUE;
                    END;
                END;
            END;
           eng := eng.succ;
        END; (* WHILE *)
        pw := pw.succ; INC(pnum);
    END;(* WHILE *)
END WriteObList;

(* --- Write a single ListView Node. *)

PROCEDURE WriteObNode (eng: gtx.ExtNewGadgetPtr; node: e.NodePtr; num,pnum: INTEGER);
VAR
   list: e.ListPtr;
BEGIN
    list := s.VAL(e.APTR,u.GetTagData (gt.lvLabels, 0, s.VAL(TagItemArray,eng.tags)^));
    IF list # NIL THEN
        FPrintF (file, "  %s%ldNodes[%ld].succ := ", s.ADR(eng.gadgetLabel), pnum, num);

        IF node.succ # s.ADR(list.tail) THEN
           FPrintF (file, "y.ADR (%s%ldNodes[%ld]);\n", s.ADR(eng.gadgetLabel), pnum, num + 1);
        ELSE
           FPrintF (file, "y.ADR (%s%ldList.tail);\n", s.ADR(eng.gadgetLabel), pnum);
        END;

        FPrintF (file, "  %s%ldNodes[%ld].pred := ", s.ADR(eng.gadgetLabel), pnum, num);

        IF node.pred = s.ADR(list.head) THEN
           FPrintF (file, "y.ADR (%s%ldList.head);\n", s.ADR(eng.gadgetLabel), pnum);
        ELSE
           FPrintF (file, "y.ADR (%s%ldNodes[%ld]);\n", s.ADR(eng.gadgetLabel), pnum, num - 1);
        END;

        FPrintF (file, "  %s%ldNodes[%ld].type := 0;\n", s.ADR(eng.gadgetLabel), pnum, num );
        FPrintF (file, "  %s%ldNodes[%ld].pri  := 0;\n", s.ADR(eng.gadgetLabel), pnum, num );
        FPrintF (file, "  %s%ldNodes[%ld].name := y.ADR (\"%s\");\n\n", s.ADR(eng.gadgetLabel), pnum, num, node.name);
    END;
END WriteObNode;

(* --- Write a ListView List/Node initialisation *)

PROCEDURE WriteObNodes (pw: gtx.ProjectWindowPtr; pnum: INTEGER);
VAR
   eng: gtx.ExtNewGadgetPtr;
   node: e.NodePtr;
   list: e.ListPtr;
   nodenum: INTEGER;
BEGIN
    eng := pw.gadgets.head;
    WHILE eng.succ # NIL DO
        IF eng.kind = gt.listViewKind THEN
            list := s.VAL(e.APTR,u.GetTagData (gt.lvLabels, NIL, s.VAL(TagItemArray,eng.tags)^));
            IF list # NIL THEN
                IF list.head.succ # NIL THEN
                    node := list.head; nodenum := 0;
                    WHILE node.succ # NIL DO
                        WriteObNode (eng, node, nodenum, pnum);
                        node := node.succ; INC(nodenum);
                    END;
                    FPrintF (file, "  %s%ldList.head     := y.ADR (%s%ldNodes[0]);\n", s.ADR(eng.gadgetLabel[0]), pnum, s.ADR(eng.gadgetLabel[0]), pnum);
                    FPrintF (file, "  %s%ldList.tail     := NIL;\n", s.ADR(eng.gadgetLabel[0]), pnum);
                    FPrintF (file, "  %s%ldList.tailPred := y.ADR (%s%ldNodes[%ld]);\n\n", s.ADR(eng.gadgetLabel[0]), pnum, s.ADR(eng.gadgetLabel[0]), pnum, nodenum-1);
                ELSE
                    FPrintF (file, "  %s%ldList.head     := y.ADR (%s%ldList.tail);\n", s.ADR(eng.gadgetLabel[0]), pnum, s.ADR(eng.gadgetLabel[0]), pnum);
                    FPrintF (file, "  %s%ldList.tail     := NIL;\n", s.ADR(eng.gadgetLabel[0]), pnum);
                    FPrintF (file, "  %s%ldList.tailPred := y.ADR (%s%ldList.head);\n\n", s.ADR(eng.gadgetLabel[0]), pnum, s.ADR(eng.gadgetLabel[0]), pnum);
                END;
            END;
        END;
        eng := eng.succ;
    END;
END WriteObNodes;

(* --- Write the TextAttr structure *)
PROCEDURE WriteObTextAttr();
VAR
   fname: ARRAY 32 OF CHAR; pos: LONGINT;
BEGIN
    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs (fname, '.')] := 0X;

    FPrintF (file, "CONST\n  %s%ld = g.TextAttr (", s.ADR(fname), GuiData.font.ySize);
    FPrintF (file, "y.ADR (\"%s\"), %ld, y.VAL (SHORTSET, 0%02lxH), y.VAL (SHORTSET, 0%02lxH) );\n\n", s.ADR(GuiData.fontName), GuiData.font.ySize, s.VAL(SHORTINT,GuiData.font.style), s.VAL(SHORTINT,GuiData.font.flags));
END WriteObTextAttr;

(* --- Write the Window Tags. *)
PROCEDURE WriteObWindow (pw: gtx.ProjectWindowPtr);
BEGIN
    FPrintF (file, "  %sWnd := I.OpenWindowTagsA ( NIL,\n", s.ADR(pw.name));
    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
       FPutS (file, "                    I.waLeft,          wleft,\n");
       FPutS (file, "                    I.waTop,           wtop,\n");
    ELSE
       FPrintF (file, "                    I.waLeft,          %sLeft,\n", s.ADR(pw.name));
       FPrintF (file, "                    I.waTop,           %sTop,\n", s.ADR(pw.name));
    END;

    IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
        IF gtx.InnerWidth IN pw.tagFlags THEN
            FPutS (file, "                    I.waInnerWidth,    ");
        ELSE
            FPutS (file, "                    I.waWidth,         ");
        END;

        FPrintF (file, "%sWidth,\n", s.ADR(pw.name));

        IF gtx.InnerHeight IN pw.tagFlags THEN
            FPutS (file, "                    I.waInnerHeight,   ");
        ELSE
            FPutS (file, "                    I.waHeight,        ");
        END;

        FPrintF (file, "%sHeight", s.ADR(pw.name));

        IF ~(gtx.InnerHeight IN pw.tagFlags) THEN FPutS (file, " + offy") END;

        FPutS (file, ",\n");

    ELSE
        FPutS (file, "                    I.waWidth,         ww + OffX + Scr^.wBorRight,\n");
        FPutS (file, "                    I.waHeight,        wh + OffY + Scr^.wBorBottom,\n");
    END;

    FPutS (file, "                    I.waIDCMP,         ");
    WriteObIDCMPFlags (pw.idcmp+LONGSET{I.refreshWindow}, pw);

    FPutS (file, "                    I.waFlags,         ");
    WriteObWindowFlags (pw.windowFlags);

    (*
    IF pw.gadgets.head.succ # NIL THEN
         FPrintF (file, "                    I.waGadgets,       %sGList,\n", s.ADR(pw.name));
    END;
    *)

    IF ~(I.backDrop IN pw.windowFlags) THEN
        IF st.Length (pw.windowTitle) > 0 THEN
           FPrintF (file, "                    I.waTitle,         y.ADR (\"%s\"),\n", s.ADR(pw.windowTitle[0]));
        END;
    END;

    IF st.Length (pw.screenTitle) > 0 THEN
       FPrintF (file, "                    I.waScreenTitle,   y.ADR (\"%s\"),\n", s.ADR(pw.screenTitle[0]));
    END;

    IF gtx.Custom IN GuiData.flags0 THEN
        FPutS (file, "                    I.waCustomScreen,  Scr,\n");
    ELSIF gtx.Public IN GuiData.flags0 THEN
        FPutS (file, "                    I.waPubScreen,     Scr,\n");
    END;

    IF I.windowSizing IN pw.windowFlags THEN
        IF gtx.TagInArray (I.waMinWidth, s.VAL(TagItemArray,pw.tags)^) THEN
           FPrintF (file, "                    I.waMinWidth,      %ld,\n", u.GetTagData (I.waMinWidth, NIL, s.VAL(TagItemArray,pw.tags)^));
        END;
        IF gtx.TagInArray (I.waMinHeight, s.VAL(TagItemArray,pw.tags)^) THEN
           FPrintF (file, "                    I.waMinHeight,     %ld,\n", u.GetTagData (I.waMinHeight, NIL, s.VAL(TagItemArray,pw.tags)^));
        END;
        IF gtx.TagInArray (I.waMaxWidth, s.VAL(TagItemArray,pw.tags)^) THEN
           FPrintF (file, "                    I.waMaxWidth,      %ld,\n", u.GetTagData (I.waMaxWidth, NIL, s.VAL(TagItemArray,pw.tags)^));
        END;
        IF gtx.TagInArray (I.waMaxHeight, s.VAL(TagItemArray,pw.tags)^) THEN
           FPrintF (file, "                    I.waMaxHeight,     %ld,\n", u.GetTagData (I.waMaxHeight, NIL, s.VAL(TagItemArray,pw.tags)^));
        END;
    ELSE
        IF LONGSET{gtx.Zoom,gtx.DefaultZoom} * pw.tagFlags # LONGSET{} THEN
           FPrintF (file, "                    I.waZoom,          y.ADR (%sZoom),\n", s.ADR(pw.name));
        END;
    END;

    IF pw.gadgets.head.succ # NIL THEN
       FPrintF (file, '                    I.waGadgets,       %sGList,\n',s.ADR(pw.name));
    END;
    IF gtx.MouseQueue IN pw.tagFlags THEN
       FPrintF (file, "                    I.waMouseQueue,    %ld,\n", pw.mouseQueue);
    END;
    IF gtx.RptQueue IN pw.tagFlags THEN
       FPrintF (file, "                    I.waRptQueue,      %ld,\n", pw.rptQueue);
    END;
    IF gtx.AutoAdjust IN pw.tagFlags THEN
       FPutS (file, "                    I.waAutoAdjust,    I.LTRUE,\n");
    END;
    IF gtx.FallBack IN pw.tagFlags THEN
       FPutS (file, "                    I.waPubScreenFallBack, I.LTRUE,\n");
    END;

    FPutS (file,     "                    u.done);\n");
    FPrintF (file, "  IF %sWnd = NIL THEN RETURN 20 END;\n\n", s.ADR(pw.name));
END WriteObWindow;

(* --- Write the Screen Tags and screen specific data. *)
PROCEDURE WriteObSTags();
VAR
   cnt: INTEGER;
   fname: ARRAY 32 OF CHAR; pos: LONGINT;
BEGIN
    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs (fname, '.')] := 0X;

    IF GuiData.colors[0].colorIndex # -1 THEN
        FPutS (file, "TYPE\n  ColorArray = ARRAY ");
        MarkNumber;
        FPutS (file, " OF I.ColorSpec;\n");
        FPutS (file, "CONST\n  ScreenColors = ColorArray (\n");
        LOOP
          FOR cnt := 0 TO 32 DO
            IF GuiData.colors[cnt].colorIndex # -1 THEN
               FPrintF (file, "    %2ld, 0%02lxH, 0%02lxH, 0%02lxH,\n", GuiData.colors[cnt].colorIndex, GuiData.colors[cnt].red, GuiData.colors[cnt].green, GuiData.colors[cnt].blue);
            ELSE
               FPutS (file, "    -1, 000H, 000H, 000H);\n\n");
               EXIT
            END;
          END;
          EXIT
        END; (* LOOP *)
        FixNumber (cnt+1);
    END;

    FPutS (file, "TYPE\n  DriPenArray = ARRAY ");
    MarkNumber;
    FPutS (file, " OF INTEGER;\n");
    FPutS (file, "CONST\n  DriPens = DriPenArray (");

    LOOP
      FOR cnt := 0 TO gtx.MaxDriPens-1 DO
        IF GuiData.moreDriPens[cnt] # -1 THEN
           FPrintF (file, "%ld,", GuiData.moreDriPens[cnt]);
        ELSE
           EXIT
        END;
      END;
      EXIT
    END;
    FPutS (file, "-1);\n\n");
    FixNumber (cnt+1);
END WriteObSTags;

(* --- Write the Oberon IntuiText structures. *)

PROCEDURE CountITexts (itxt: I.IntuiTextPtr): INTEGER;
VAR cnt: INTEGER;
BEGIN    cnt := 0; WHILE itxt # NIL DO INC(cnt); itxt := itxt.nextText; END; RETURN (cnt);
END CountITexts;

PROCEDURE WriteObIText();
VAR
   pw: gtx.ProjectWindowPtr;
   t: I.IntuiTextPtr;
   i, bleft, btop, n: INTEGER;
   fname: ARRAY 32 OF CHAR; pos: LONGINT;
BEGIN
    i := 1; n := 0;
    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs (fname, '.')] := 0X;

    pw := Projects.head;
    LOOP
        IF pw.succ = NIL THEN EXIT ELSE
           IF pw.windowText # NIL THEN FPutS (file, "VAR\n"); EXIT END;
           pw := pw.succ;
        END;
    END;

    pw := Projects.head;
    WHILE pw.succ # NIL DO
        bleft := pw.leftBorder; btop := pw.topBorder;
        t := pw.windowText;
        IF t # NIL THEN
           FPrintF (file, "  %sIText: ARRAY %ld OF I.IntuiText;\n", s.ADR(pw.name), CountITexts (t));
        END;
        pw := pw.succ;
    END;
END WriteObIText;

(* --- Write the NewGadget arrays. *)
PROCEDURE WriteObGArray();
VAR
   pw: gtx.ProjectWindowPtr;
   g: gtx.ExtNewGadgetPtr;
   ng: gt.NewGadgetPtr;
   bleft, btop: INTEGER;
BEGIN
    pw := Projects.head;
    WHILE pw.succ # NIL DO
        bleft := pw.leftBorder; btop := pw.topBorder;
        IF pw.gadgets.head.succ # NIL THEN
            FPrintF  (file, "TYPE\n  %sNGadArray = ARRAY %sCNT OF gt.NewGadget;\n",
                        s.ADR(pw.name), s.ADR(pw.name));
            FPrintF  (file, "CONST\n  %sNGad = %sNGadArray (\n",
                        s.ADR(pw.name), s.ADR(pw.name));

            g := pw.gadgets.head;
            WHILE g.succ # NIL DO
                ng := s.ADR(g.newGadget);

                FPrintF (file, "    %ld, %ld, %ld, %ld, ", ng.leftEdge - bleft, ng.topEdge - btop, ng.width, ng.height);
                IF (ng.gadgetText # NIL) & (st.Length (ng.gadgetText^) > 0) THEN
                   FPrintF (file, "y.ADR (\"%s\"), ", ng.gadgetText);
                ELSE
                   FPutS (file, "NIL, ");
                END;
                FPrintF (file, "NIL, GD%s, ", s.ADR(g.gadgetLabel));
                WriteObPlaceFlags (ng.flags);
                FPutS (file, " ,NIL, NIL,\n");
                g := g.succ;
            END;
            SeekBack (2);
            FPutS (file, "\n  );\n\n");
        END;
        pw := pw.succ;
    END;
END WriteObGArray;

PROCEDURE WriteObGadHeader (pw: gtx.ProjectWindowPtr);
BEGIN
    FPrintF (file, "PROCEDURE Create%sGadgets* (): INTEGER;\n", s.ADR(pw.name));

    FPutS (file, "TYPE\n  TagArrayPtr = UNTRACED POINTER TO ARRAY MAX (INTEGER) OF u.TagItem;\n");

    FPutS (file, "VAR\n  ng: gt.NewGadget;\n  gad: I.GadgetPtr;\n");
    FPutS (file, "  tmp: u.TagItemPtr;\n");
    FPutS (file, "  help: TagArrayPtr;\n"
                 "  ret, lc, tc, lvc, offx, offy: INTEGER;\n");

    FPutS (file, "BEGIN\n");
    IF I.backDrop IN pw.windowFlags THEN FPutS (file, "  offx := 0; ");
                                    ELSE FPutS (file, "  offx := Scr^.wBorLeft; ");
    END;
    FPutS (file, "offy := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;\n\n");

    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
       FPrintF (file, "  ComputeFont (%sWidth, %sHeight);\n\n", s.ADR(pw.name), s.ADR(pw.name));
    END;

END WriteObGadHeader;

(* --- Write the routine header. *)
PROCEDURE WriteObHeader (pw: gtx.ProjectWindowPtr);
BEGIN
    FPrintF (file, "PROCEDURE Open%sWindow* (",s.ADR(pw.name));
    IF pw.gadgets.head.succ # NIL THEN FPutS (file, "createGads: BOOLEAN"); END;
    FPutS (file, "): INTEGER;\n");

    FPutS (file, "VAR\n  offx, offy, ret: INTEGER;\n");

    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        FPutS  (file, "  wleft, wtop, ww, wh: INTEGER;\n");
        FPutS (file, "BEGIN\n");
        IF args.mouse = d.DOSFALSE THEN
           FPrintF (file, "  wleft := %sLeft; wtop := %sTop;\n\n", s.ADR(pw.name), s.ADR(pw.name));
        END;

        FPrintF (file, "  ComputeFont (%sWidth, %sHeight);\n\n", s.ADR(pw.name), s.ADR(pw.name));
        FPrintF (file, "  ww := ComputeX (%sWidth);\n  wh := ComputeY (%sHeight);\n\n", s.ADR(pw.name), s.ADR(pw.name));

        IF args.mouse = d.DOSTRUE THEN
           FPutS (file, "  wleft := Scr.mouseX - (ww DIV 2);\n"
                        "  wtop  := Scr.mouseY - (wh DIV 2);\n");
        ELSE
           FPutS (file, "  IF wleft + ww + OffX + Scr^.wBorRight > Scr^.width THEN\n"
                        "    wleft := Scr^.width - ww;\n"
                        "  END;\n"
                        "  IF wtop + wh + OffY + Scr^.wBorBottom > Scr^.height THEN\n"
                        "    wtop := Scr^.height - wh;\n"
                        "  END;\n");
        END;

        IF gtx.SysFont IN ObConfig.configFlags0 THEN
           FPrintF (file, "\n  %sFont := df.OpenDiskFont (Font^);\n  IF %sFont = NIL THEN RETURN 5 END;\n\n", s.ADR(pw.name), s.ADR(pw.name));
        END;
    ELSE
        FPutS (file, "BEGIN\n");
        IF I.backDrop IN pw.windowFlags THEN FPutS (file, "  offx := 0; ");
                                        ELSE FPutS (file, "  offx := Scr^.wBorLeft; ");
        END;
        FPutS (file, "offy := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;\n\n");
    END;
END WriteObHeader;

(* --- Write the gadget type array. *)
PROCEDURE WriteObGTypes();
TYPE  goKindsType = numKindsType;
CONST goKinds = goKindsType(
            s.ADR("generic"), s.ADR("button"),   s.ADR("checkBox"),
            s.ADR("integer"), s.ADR("listView"), s.ADR("mx"),
            s.ADR("number"),  s.ADR("cycle"),    s.ADR("palette"),
            s.ADR("scroller"),s.ADR("reserved"), s.ADR("slider"),
            s.ADR("string"),  s.ADR("text"));

VAR
   pw: gtx.ProjectWindowPtr;
   eng: gtx.ExtNewGadgetPtr;
BEGIN
    pw := Projects.head;
    WHILE pw.succ # NIL DO
        IF pw.gadgets.head.succ # NIL THEN
            FPrintF (file, "TYPE\n  %sGTypesArray = ARRAY %sCNT OF INTEGER;\n",
                       s.ADR(pw.name), s.ADR(pw.name));
            FPrintF (file, "CONST\n  %sGTypes = %sGTypesArray (\n",
                       s.ADR(pw.name), s.ADR(pw.name));
            eng := pw.gadgets.head;
            WHILE eng.succ # NIL DO FPrintF (file, "    gt.%sKind,\n", goKinds[eng.kind]); eng := eng.succ; END;
            SeekBack (2);
            FPutS (file, "\n  );\n\n");
        END;
        pw := pw.succ;
    END;
END WriteObGTypes;

(* --- Write the gadget tagitem array. *)
PROCEDURE WriteObGTags();
CONST  underscore     = ORD("_");

VAR
   pw: gtx.ProjectWindowPtr;
   g: gtx.ExtNewGadgetPtr;
   pnum: INTEGER;
   list: e.ListPtr;
   str: e.STRPTR;
   sj: SET;
   cnt: INTEGER;
BEGIN
    pw := Projects.head; pnum := 0;
    WHILE pw.succ # NIL DO
        IF pw.gadgets.head.succ # NIL THEN

            FPrintF  (file, "TYPE\n  %sGTagsArray = ARRAY ", s.ADR(pw.name));
            MarkNumber; cnt := 0;
            FPutS (file, " OF u.Tag;\n");
            FPrintF  (file, "CONST\n  %sGTags = %sGTagsArray (\n",
                        s.ADR(pw.name), s.ADR(pw.name));

            g := pw.gadgets.head;
            WHILE g.succ # NIL DO
                FPutS (file, "    ");

                CASE g.kind OF
                    | gt.checkBoxKind:
                        IF gtx.TagInArray (gt.cbChecked, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "gt.cbChecked, I.LTRUE, "); INC(cnt,2);
                        END;
                    | gt.cycleKind:
                        FPrintF (file, "gt.cyLabels, y.ADR (%s%ldLabels[0]), ", s.ADR(g.gadgetLabel[0]), pnum); INC(cnt,2);
                        IF gtx.TagInArray (gt.cyActive, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.cyActive, %ld, ", u.GetTagData (gt.cyActive, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                    | gt.integerKind:
                        IF gtx.TagInArray (I.gaTabCycle, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.gaTabCycle, I.LFALSE, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.stringaExitHelp, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.stringaExitHelp, I.LTRUE, "); INC(cnt,2);
                        END;
                        FPrintF (file, "gt.inNumber, %ld, ", u.GetTagData (gt.inNumber, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        FPrintF (file, "gt.inMaxChars, %ld, ", u.GetTagData (gt.inMaxChars, 5, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        sj := s.VAL(SET,SHORT(u.GetTagData (I.stringaJustification, 0, s.VAL(TagItemArray,g.tags)^)));
                        IF sj # {} THEN
                            FPutS (file, "I.stringaJustification, ");
                            IF I.stringCenter IN sj THEN FPutS (file, "LONGSET{I.stringCenter}, ");
                                                    ELSE FPutS (file, "LONGSET{I.stringRight}, ");
                            END;
                            INC(cnt,2);
                        END;
                    | gt.listViewKind:
                        list := s.VAL(e.APTR,u.GetTagData (gt.lvLabels, NIL, s.VAL(TagItemArray,g.tags)^));
                        IF list # NIL THEN
                            IF (list.head.succ # NIL) & (list.head.succ.succ # NIL) THEN
                                FPutS (file, "gt.lvLabels, NIL, "); INC(cnt,2);
                                FPutS (file, "gt.lvSelected, 0, "); INC(cnt,2);

                            END;
                        END;
                        IF gtx.NeedLock IN g.flags THEN
                           FPutS (file, "gt.lvShowSelected, 1, "); INC(cnt,2);
                        ELSIF gtx.TagInArray (gt.lvShowSelected,s.VAL(TagItemArray,g.tags)^) THEN
                           FPutS (file, "gt.lvShowSelected, NIL, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.lvScrollWidth, s.VAL(TagItemArray,g.tags)^) THEN
                           FPrintF (file, "gt.lvScrollWidth, %ld, ", u.GetTagData (gt.lvScrollWidth, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.lvReadOnly, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "gt.lvReadOnly, I.LTRUE, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.layoutaSpacing, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "I.layoutaSpacing, %ld, ", u.GetTagData (I.layoutaSpacing, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;

                    | gt.mxKind:
                        FPrintF (file, "gt.mxLabels, y.ADR (%s%ldLabels[0]), ", s.ADR(g.gadgetLabel[0]), pnum); INC(cnt,2);
                        IF gtx.TagInArray (gt.mxSpacing, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.mxSpacing, %ld, ", u.GetTagData (gt.mxSpacing, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.mxActive, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.mxActive, %ld, ", u.GetTagData (gt.mxActive, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                    | gt.paletteKind:
                        FPrintF (file, "gt.paDepth, %ld, ", u.GetTagData (gt.paDepth, 1, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        IF gtx.TagInArray (gt.paIndicatorWidth, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.paIndicatorWidth, %ld, ", u.GetTagData (gt.paIndicatorWidth, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.paIndicatorHeight, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.paIndicatorHeight, %ld, ", u.GetTagData (gt.paIndicatorHeight, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.paColor, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.paColor, %ld, ", u.GetTagData (gt.paColor, 1, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.paColorOffset, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.paColorOffset, %ld, ", u.GetTagData (gt.paColorOffset, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                    | gt.scrollerKind:
                        IF gtx.TagInArray (gt.scTop, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.scTop, %ld, ", u.GetTagData (gt.scTop, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.scTotal, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.scTotal, %ld, ", u.GetTagData (gt.scTotal, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.scVisible, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.scVisible, %ld, ", u.GetTagData (gt.scVisible, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.scArrows, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.scArrows, %ld, ", u.GetTagData (gt.scArrows, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.pgaFreedom, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.pgaFreedom, I.lorientVert, "); INC(cnt,2);
                        ELSE
                            FPutS (file, "I.pgaFreedom, I.lorientHoriz, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.gaImmediate, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.gaImmediate, I.LTRUE, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.gaRelVerify, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.gaRelVerify, I.LTRUE, "); INC(cnt,2);
                        END;
                    | gt.sliderKind:
                        IF gtx.TagInArray (gt.slMin, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.slMin, %ld, ", u.GetTagData (gt.slMin, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.slMax, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.slMax, %ld, ", u.GetTagData (gt.slMax, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.slLevel, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.slLevel, %ld, ", u.GetTagData (gt.slLevel, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.slMaxLevelLen, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.slMaxLevelLen, %ld, ", u.GetTagData (gt.slMaxLevelLen, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.slLevelFormat, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.slLevelFormat, y.ADR (\"%s\"), ", u.GetTagData (gt.slLevelFormat, NIL, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.slLevelPlace, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "gt.slLevelPlace, "); INC(cnt,2);
                            WriteObPlaceFlags (s.VAL(LONGSET,u.GetTagData (gt.slLevelPlace, NIL, s.VAL(TagItemArray,g.tags)^)));
                            FPutS (file, ", ");
                        END;
                        IF gtx.TagInArray (I.pgaFreedom, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.pgaFreedom, I.lorientVert, "); INC(cnt,2);
                        ELSE
                            FPutS (file, "I.pgaFreedom, I.lorientHoriz, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.gaImmediate, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.gaImmediate, I.LTRUE, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.gaRelVerify, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.gaRelVerify, I.LTRUE, "); INC(cnt,2);
                        END;
                    | gt.stringKind:
                        IF gtx.TagInArray (I.gaTabCycle, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.gaTabCycle, I.LFALSE, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (I.stringaExitHelp, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "I.stringaExitHelp, I.LTRUE, "); INC(cnt,2);
                        END;
                        str := s.VAL(e.APTR,u.GetTagData (gt.stString, NIL, s.VAL(TagItemArray,g.tags)^));
                        IF (str # NIL) & (st.Length (str^) > 0) THEN
                           FPrintF (file, "gt.stString, y.ADR (\"%s\"), ", str); INC(cnt,2);
                        END;
                        FPrintF (file, "gt.stMaxChars, %ld, ", u.GetTagData (gt.stMaxChars, 5, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        sj := s.VAL(SET,SHORT(u.GetTagData (I.stringaJustification, 0, s.VAL(TagItemArray,g.tags)^)));
                        IF sj # {} THEN
                            FPutS (file, "I.stringaJustification, ");
                            IF I.stringCenter IN sj THEN FPutS (file, "LONGSET{I.stringCenter}, ");
                                                    ELSE FPutS (file, "LONGSET{I.stringRight}, ");
                            END;
                            INC(cnt,2);
                        END;
                    | gt.numberKind:
                        IF gtx.TagInArray (gt.nmNumber, s.VAL(TagItemArray,g.tags)^) THEN
                            FPrintF (file, "gt.nmNumber, %ld, ", u.GetTagData (gt.nmNumber, 0, s.VAL(TagItemArray,g.tags)^)); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.nmBorder, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "gt.nmBorder, I.LTRUE, "); INC(cnt,2);
                        END;
                    | gt.textKind:
                        str := s.VAL(e.APTR,u.GetTagData (gt.txText, NIL, s.VAL(TagItemArray,g.tags)^));
                        IF (str # NIL) & (st.Length (str^) > 0) THEN
                            FPrintF (file, "gt.txText, y.ADR (\"%s\"), ", str); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.txBorder, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "gt.txBorder, I.LTRUE, "); INC(cnt,2);
                        END;
                        IF gtx.TagInArray (gt.txCopyText, s.VAL(TagItemArray,g.tags)^) THEN
                            FPutS (file, "gt.txCopyText, I.LTRUE, "); INC(cnt,2);
                        END;
                ELSE
                END; (* CASE *)
                IF g.kind # gt.genericKind THEN
                    IF gtx.TagInArray (gt.underscore, s.VAL(TagItemArray,g.tags)^) THEN
                        FPrintF (file, "gt.underscore, %ld, ",LONG(underscore)); INC(cnt,2);

                    END;
                END;

                IF gtx.TagInArray (I.gaDisabled, s.VAL(TagItemArray,g.tags)^) THEN
                    FPutS (file, "I.gaDisabled, I.LTRUE, "); INC(cnt,2);
                END;

                FPutS (file, "u.done,\n"); INC(cnt);
                g := g.succ;
            END; (* WHILE *)
            SeekBack (2);
            FPutS (file, "\n  );\n\n");
            FixNumber (cnt);
        END;
        pw := pw.succ; INC(pnum);
    END; (* WHILE *)
END WriteObGTags;

(* --- Write the Oberon Gadgets initialization. *)
(* $Debug= *)
PROCEDURE WriteObGadgets (pw: gtx.ProjectWindowPtr;pnum: INTEGER);
VAR
   tmp,
   eng: gtx.ExtNewGadgetPtr;
   list: e.ListPtr;
   fname: ARRAY 32 OF CHAR; pos: LONGINT;
   btop, bleft,lvc: INTEGER;
   skipTheShit: BOOLEAN;
BEGIN
    btop := pw.topBorder; bleft := pw.leftBorder; skipTheShit := FALSE;

    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs(fname,'.')] := 0X;

    FPutS (file, "  lc := 0; tc := 0; lvc := 0;\n");
    FPrintF (file, "  WHILE lc < %sCNT DO\n", s.ADR(pw.name));
    FPrintF (file, "    ng := %sNGad[lc];\n", s.ADR(pw.name));

    FPutS (file, "    ng.visualInfo := VisualInfo;\n");

    LOOP
     IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        FPutS (file, "    ng.textAttr   := Font;\n");
        FPutS (file, "    ng.leftEdge   := OffX + ComputeX (ng.leftEdge);\n");
        FPutS (file, "    ng.topEdge    := OffY + ComputeY (ng.topEdge);\n");

        IF GetFileInWindow THEN
            tmp := pw.gadgets.head;
            LOOP
                IF tmp.kind = gt.genericKind THEN
                    FPrintF (file, "\n    IF %sGTypes[lc] # gt.genericKind THEN\n", s.ADR(pw.name));
                    FPutS (file, "      ng.width  := ComputeX (ng.width );\n");
                    FPutS (file, "      ng.height := ComputeY (ng.height);\n    END;\n\n");
                    skipTheShit := TRUE; EXIT;
                END;
                IF tmp.succ = NIL THEN EXIT ELSE tmp := tmp.succ END;
            END;
            IF skipTheShit THEN EXIT END;
        END;
        FPutS (file, "    ng.width      := ComputeX (ng.width);\n");
        FPutS (file, "    ng.height     := ComputeY (ng.height);\n\n");
     ELSE
        FPrintF (file, "    ng.textAttr   := y.ADR (%s%ld);\n", s.ADR(fname), GuiData.font.ySize);
        FPutS (file, "    INC (ng.leftEdge, offx);\n");
        FPutS (file, "    INC (ng.topEdge, offy);\n");
     END;
     EXIT
    END; (* BreakLoop *)

    WriteObNodes (pw, pnum); (* *)


    FPrintF (file, "    help := u.CloneTagItems (y.VAL (TagArrayPtr, y.ADR (%sGTags[tc]))^);\n", s.ADR(pw.name));
    FPutS (file, "    IF help = NIL THEN RETURN 8 END;\n");


    IF ListViewLists OR JoinedInWindow THEN

        tmp := pw.gadgets.head;
        LOOP
          IF tmp.succ = NIL THEN EXIT ELSE
            IF (tmp.kind = gt.listViewKind) (*& (gtx.NeedLock IN tmp.flags)*) THEN
                                            (*^^^^^^^^^^*)
                FPrintF (file, "    IF %sGTypes[lc] = gt.listViewKind THEN\n", s.ADR(pw.name));

                IF JoinedInWindow OR ListViewLists THEN
                    FPutS (file, "      tmp := u.FindTagItem (gt.lvShowSelected, help^);\n"
                                 "      IF tmp # NIL THEN\n"
                                 "         IF tmp^.data # NIL THEN tmp^.data := gad END;\n"
                                 "      END;\n");
                END;

                IF ListViewLists THEN
                    FPutS (file, "      tmp := u.FindTagItem (gt.lvLabels, help^);\n"
                                   "      IF tmp # NIL THEN\n"
                                   "        CASE lvc OF\n");

                    lvc := 0;
                    eng := pw.gadgets.head;
                    WHILE eng.succ # NIL DO
                        IF eng.kind = gt.listViewKind THEN
                            list := s.VAL(e.APTR,u.GetTagData (gt.lvLabels, NIL, s.VAL(TagItemArray,eng.tags)^));
                            IF list # NIL THEN
                                IF list.head.succ # NIL THEN
                                    FPrintF (file, "        | %ld: tmp^.data := y.ADR (%s%ldList);\n", lvc, s.ADR(eng.gadgetLabel[0]), pnum);
                                    INC(lvc);
                                END;
                            END;
                        END;
                        eng := eng.succ;
                    END;

                    FPutS (file, "        END; (* CASE *)\n"
                                 "        INC (lvc);\n"
                                 "      END; (* IF *)\n");
                END;
                FPutS (file, "    END; (* IF *)\n");
                EXIT;
            END;
            tmp := tmp.succ;
          END;
        END; (* LOOP *)
    END; (* IF *)

    FPrintF (file, "    gad := gt.CreateGadgetA (%sGTypes[lc], gad, ng, help^);\n"
                   "    u.FreeTagItems (help^);\n"
                   "    IF gad = NIL THEN RETURN 2 END;\n"
                   "    %sGadgets[lc] := gad;\n\n", s.ADR(pw.name), s.ADR(pw.name));

    IF GetFileInWindow THEN
        tmp := pw.gadgets.head;
        LOOP
          IF tmp.succ = NIL THEN EXIT ELSE
            IF tmp.kind = gt.genericKind THEN
                FPrintF (file, "    IF %sGTypes[lc] = gt.genericKind THEN\n", s.ADR(pw.name));
                FPutS (file, "      INCL (gad^.flags, I.gadgImage);\n"
                             "      INCL (gad^.flags, I.gadgHImage);\n"
                             "      INCL (gad^.activation, I.relVerify);\n"
                             "      gad^.gadgetRender := GetImage;\n"
                             "      gad^.selectRender := GetImage;\n"
                             "    END; (* IF *)\n\n");
                EXIT;
            END;
            tmp := tmp.succ;
          END;
        END;
    END;

    FPrintF (file, "    WHILE %sGTags[tc] # u.done DO INC (tc, 2) END;\n    INC (tc);\n\n", s.ADR(pw.name));

    FPutS (file, "    INC (lc);\n"
                 "  END; (* WHILE *)\n");
END WriteObGadgets; 
(* $Debug- *)

(* --- Write the Oberon cleanup routine. *)
PROCEDURE WriteObCleanup (pw: gtx.ProjectWindowPtr);
BEGIN
    FPrintF (file, "PROCEDURE Close%sWindow*;\n", s.ADR(pw.name));
    FPutS (file, "BEGIN\n");
    IF pw.menus.head.succ # NIL THEN
        FPrintF (file, "  IF %sMenus # NIL THEN\n"
                       "    IF %sWnd # NIL THEN\n"
                       "      I.ClearMenuStrip (%sWnd);\n"
                       "    END;\n"
                       "    gt.FreeMenus (%sMenus);\n"
                       "    %sMenus := NIL;\n"
                       "  END;\n", s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name));
    END;
    FPrintF (file, "  IF %sWnd # NIL THEN\n"
                   "    I.CloseWindow (%sWnd);\n"
                   "    %sWnd := NIL;\n"
                   "  END;\n", s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name));
    IF pw.gadgets.head.succ # NIL THEN
        FPrintF (file, "  IF %sGList # NIL THEN\n"
                       "    gt.FreeGadgets (%sGList);\n"
                       "    %sGList := NIL;\n"
                       "  END;\n", s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name));
    END;
    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        IF gtx.SysFont IN ObConfig.configFlags0 THEN
            FPrintF (file, "  IF %sFont # NIL THEN\n"
                           "    g.CloseFont (%sFont);\n"
                           "    %sFont := NIL;\n"
                           "  END;\n", s.ADR(pw.name), s.ADR(pw.name), s.ADR(pw.name));
        END;
    END;
    FPrintF (file, "END Close%sWindow;\n\n", s.ADR(pw.name));
END WriteObCleanup;

(* --- Write the Screen cleanup routine. *)

PROCEDURE WriteObScrCleanup();
BEGIN
    FPutS (file, "PROCEDURE CloseDownScreen*;\n");
    FPutS (file, "BEGIN\n");
    IF GetFilePresent THEN
        FPutS (file, "  IF GetImage # NIL THEN\n"
                     "    I.DisposeObject (GetImage);\n"
                     "    GetImage := NIL;\n"
                     "  END;\n");
    END;
    FPutS (file, "  IF VisualInfo # NIL THEN\n"
                 "    gt.FreeVisualInfo (VisualInfo);\n"
                 "    VisualInfo := NIL;\n"
                 "  END;\n");

    IF gtx.Custom IN GuiData.flags0 THEN
        FPutS (file, "  IF Scr # NIL THEN\n"
                     "    IF I.CloseScreen (Scr) THEN END;\n"
                     "    Scr := NIL;\n"
                     "  END;\n");
    ELSE
        FPutS (file, "  IF Scr # NIL THEN\n"
                     "    I.UnlockPubScreen (NIL, Scr);\n"
                     "    Scr := NIL;\n"
                     "  END;\n");
    END;

    IF CheckFont() THEN
        FPutS (file, "  IF Font # NIL THEN\n"
                     "    g.CloseFont (Font);\n"
                     "    Font := NIL;\n"
                     "  END;\n");
    END;
    FPutS (file, "END CloseDownScreen;\n\n");
END WriteObScrCleanup;

(* --- Write the rendering routine *)
PROCEDURE WriteObRender (pw: gtx.ProjectWindowPtr);
VAR
   box: gtx.BevelBoxPtr;
   offx, offy, bleft, btop: INTEGER;
   t: I.IntuiTextPtr;
   i: INTEGER;
   fname: ARRAY 32 OF CHAR; pos: LONGINT;
BEGIN
    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs(fname,'.')] := 0X;

    bleft := pw.leftBorder; btop := pw.topBorder;

    offx := bleft; offy := btop;

    FPrintF (file, "PROCEDURE %sRender*;\n", s.ADR(pw.name));

    IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
        FPutS (file, "VAR\n  offx, offy: INTEGER;\nBEGIN\n");
        IF ~(I.backDrop IN pw.windowFlags) THEN
            FPrintF (file, "  offx := %sWnd^.borderLeft;\n  offy := %sWnd^.borderTop;\n\n", s.ADR(pw.name), s.ADR(pw.name));
        ELSE
            FPutS (file, "  offx := 0;\n  offy := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;\n\n");
        END;

        IF pw.boxes.head.succ # NIL THEN
            s.SETREG(0,d.FPutC (file, ORD('\n')));
            box := pw.boxes.head;
            IF args.raster = d.DOSTRUE THEN
               FPrintF (file,"  DrawRast (%sWnd);\n",s.ADR(pw.name));
            END;
            WHILE box.succ # NIL DO
                IF args.raster = d.DOSTRUE THEN FPutS (file, "  FilledBBox (VisualInfo, ");
                                           ELSE FPutS (file, "  gt.DrawBevelBox (");
                END;
                FPrintF (file, "%sWnd^.rPort, offx + %ld, offy + %ld, %ld, %ld, ",
                         s.ADR(pw.name), box.left - bleft, box.top - btop, box.width, box.height);
                IF args.raster = d.DOSFALSE THEN FPutS (file, "gt.visualInfo, VisualInfo,") END;
                IF gtx.recessed IN box.flags THEN
                   IF args.raster = d.DOSFALSE THEN FPutS (file, " gt.bbRecessed, I.LTRUE, u.done);\n");
                                               ELSE FPutS (file, " TRUE);\n");
                   END;
                ELSE
                   IF args.raster = d.DOSFALSE THEN FPutS (file, " u.done);\n")
                                               ELSE FPutS (file, " FALSE);\n")
                   END;
                END;

                IF gtx.dropBox IN box.flags THEN
                    FPrintF (file, "  gt.DrawBevelBox (%sWnd^.rPort, offx + %ld, offy + %ld, %ld, %ld, gt.visualInfo, VisualInfo, gt.bbRecessed, I.LTRUE, u.done);\n",
                                     s.ADR(pw.name), box.left - bleft + 4, box.top - btop + 2, box.width- 8, box.height - 4);
                END;
                box := box.succ;
            END;
        END;

        IF pw.windowText # NIL THEN
            t := pw.windowText; i := 0;
            WHILE t # NIL DO
                FPrintF (file, "\n  %sIText[%ld] := I.IntuiText (", s.ADR(pw.name), i);
                FPrintF (file, "%ld, %ld, ", t.frontPen, t.backPen);
                WriteObDrMd (t.drawMode);
                FPrintF (file, ", %ld, %ld, y.ADR (%s%ld), ", t.leftEdge - bleft, t.topEdge - btop, s.ADR(fname), GuiData.font.ySize);
                FPrintF (file, "y.ADR (\"%s\"), NIL);\n", t.iText);

                FPrintF (file, "  %sIText[%ld].nextText := ", s.ADR(pw.name), i);
                IF t.nextText # NIL THEN
                    FPrintF (file, "y.ADR (%sIText[%ld]);\n", s.ADR(pw.name), i + 1);
                ELSE
                    FPutS (file, "NIL;\n\n");
                END;
                t := t.nextText;
                INC(i);
            END; (* WHILE *)
            FPrintF (file, "  I.PrintIText (%sWnd^.rPort, %sIText[0], offx, offy);\n", s.ADR(pw.name), s.ADR(pw.name));
        END;
    ELSE
        FPutS (file, "BEGIN\n");
        IF pw.boxes.head.succ # NIL THEN
            box := pw.boxes.head;
            IF args.raster = d.DOSTRUE THEN
               FPrintF (file,"  DrawRast (%sWnd);\n",s.ADR(pw.name));
            END;
            WHILE box.succ # NIL DO
                IF args.raster = d.DOSTRUE THEN FPutS (file, "  FilledBBox (VisualInfo, ");
                                           ELSE FPutS (file, "  gt.DrawBevelBox (");
                END;
                FPrintF (file, "%sWnd^.rPort,\n"
                               "                  OffX + ComputeX (%ld), OffY + ComputeY (%ld),\n"
                               "                  ComputeX (%ld), ComputeY (%ld),",
                    s.ADR(pw.name), box.left - offx, box.top - offy, box.width, box.height);
                IF args.raster = d.DOSFALSE THEN
                   FPutS (file,"\n                  gt.visualInfo, VisualInfo,");
                END;
                IF gtx.recessed IN box.flags THEN
                   IF args.raster = d.DOSFALSE THEN FPutS (file, " gt.bbRecessed, I.LTRUE, u.done);\n");
                                               ELSE FPutS (file, " TRUE);\n");
                   END;
                ELSE
                   IF args.raster = d.DOSFALSE THEN FPutS (file, " u.done);\n")
                                               ELSE FPutS (file, " FALSE);\n")
                   END;
                END;

                IF gtx.dropBox IN box.flags THEN
                   FPrintF (file, "  gt.DrawBevelBox(%sWnd^.rPort, OffX + ComputeX (%ld),\n"
                                     "                  OffY + ComputeY (%ld),\n"
                                     "                  ComputeX (%ld),\n"
                                     "                  ComputeY (%ld),\n"
                                     "                  gt.visualInfo, VisualInfo,\n"
                                     "                  gt.bbRecessed, I.LTRUE, u.done);\n",
                        s.ADR(pw.name), box.left - offx + 4, box.top - offy + 2, box.width - 8, box.height - 4);
                END;
                box := box.succ;
            END; (* WHILE *)
        END;
        IF pw.windowText # NIL THEN
            t := pw.windowText; i := 0;
            WHILE t # NIL DO
                FPrintF (file, "\n  %sIText[%ld].iText     := y.ADR (\"%s\");\n", s.ADR(pw.name), i, t.iText);
                FPrintF (file, "  %sIText[%ld].iTextFont := Font;\n", s.ADR(pw.name), i);
                FPrintF (file, "  %sIText[%ld].frontPen  := %ld;\n", s.ADR(pw.name), i, t.frontPen);
                FPrintF (file, "  %sIText[%ld].backPen   := %ld;\n", s.ADR(pw.name), i, t.backPen);
                FPrintF (file, "  %sIText[%ld].drawMode  := ", s.ADR(pw.name), i);
                WriteObDrMd (t.drawMode); FPutS (file, ";\n");

                FPrintF (file, "  %sIText[%ld].leftEdge  := OffX + ComputeX (%ld) - (I.IntuiTextLength (%sIText[%ld]) DIV 2);\n", s.ADR(pw.name), i,  t.leftEdge +  s.LSH(I.IntuiTextLength(t^),-1) - bleft, s.ADR(pw.name), i);
                FPrintF (file, "  %sIText[%ld].topEdge   := OffY + ComputeY (%ld) - (Font^.ySize DIV 2);\n", s.ADR(pw.name), i, t.topEdge +  s.LSH(GuiData.font.ySize,-1) - btop);

                FPrintF (file, "  %sIText[%ld].nextText  := ", s.ADR(pw.name), i);
                IF t.nextText # NIL THEN
                    FPrintF (file, "y.ADR (%sIText[%ld]);\n\n", s.ADR(pw.name), i + 1);
                ELSE
                    FPutS (file, "NIL;\n\n");
                END;
                t := t.nextText;
                INC(i);
            END; (* WHILE *)
            FPrintF (file, "  I.PrintIText (%sWnd^.rPort, %sIText[0], 0, 0);\n", s.ADR(pw.name), s.ADR(pw.name));
        END;
    END;

    IF args.raster = d.DOSTRUE THEN
       FPrintF (file,'\n  I.RefreshGList (%sGList, %sWnd, NIL, -1);\n'
                     '  gt.RefreshWindow (%sWnd, NIL);\n\n',s.ADR(pw.name),s.ADR(pw.name),s.ADR(pw.name));
    END;

    FPrintF (file, "END %sRender;\n\n", s.ADR(pw.name) );
END WriteObRender;


(* --- Write the Oberon SetupScreen() routine. *)
PROCEDURE WriteObSetupScr();
VAR
   fname: ARRAY 32 OF CHAR; pos: LONGINT;
   xsize, ysize: INTEGER;
   rp: G.RastPort;
   tf: G.TextFontPtr;
BEGIN
    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs(fname,'.')] := 0X;

    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        tf := G.OpenFont (GuiData.font);
        IF tf = NIL THEN tf := df.OpenDiskFont (GuiData.font) END;

        IF tf # NIL THEN
            G.InitRastPort (rp);
            G.SetFont (s.ADR(rp), tf);
            xsize := G.TextLength (s.ADR(rp), "abcdefghijklmnopqrstuvwxyzBCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", 62) DIV 62;
            G.CloseFont (tf);
        ELSE
            xsize := GuiData.font.ySize;
        END;

        ysize := GuiData.font.ySize;

        FPutS (file, "PROCEDURE ComputeX (value: INTEGER): INTEGER;\n"
                     "BEGIN\n");
        FPrintF(file, "  RETURN ((FontX * value) + %ld ) DIV %ld;\n", xsize DIV 2, xsize);
        FPutS (file, "END ComputeX;\n\n"
                     "PROCEDURE ComputeY (value: INTEGER): INTEGER;\n"
                     "BEGIN\n");
        FPrintF (file, "  RETURN ((FontY * value)  + %ld ) DIV %ld;\n", ysize DIV 2, ysize);
        FPutS (file, "END ComputeY;\n\n"
                     "PROCEDURE ComputeFont (width, height: INTEGER);\n"
                     "BEGIN\n"
                     "  Font := y. ADR (Attr);\n");
        IF ~(gtx.SysFont IN ObConfig.configFlags0) THEN
            FPutS (file, "  Font^.name := Scr^.rastPort.font^.message.node.name;\n"
                         "  FontY := Scr^.rastPort.font^.ySize;\n"
                         "  Font^.ySize := FontY;\n"
                         "  FontX := Scr^.rastPort.font^.xSize;\n\n");
        ELSE
            FPutS (file, "\n  e.Forbid;\n"
                         "  Font^.name := g.gfx^.defaultFont^.message.node.name;\n"
                         "  FontY := g.gfx^.defaultFont^.ySize;\n"
                         "  Font^.ySize := FontY;\n"
                         "  FontX := g.gfx^.defaultFont^.xSize;\n"
                         "  e.Permit;\n\n" );
        END;
(******        IF ((pw.windowFlags s.ADR( WFLGBACKDROP) = WFLGBACKDROP THEN
          FPutS (file, "  OffX := 0;\n");
        ELSE *******)
          FPutS (file, "  OffX := Scr^.wBorLeft;\n");
(*****        END; *******)
        FPutS (file, "  OffY := Scr^.rastPort.txHeight + Scr^.wBorTop + 1;\n\n"
                     "  IF (width # 0) AND (height # 0) AND\n"
                     "     (ComputeX (width) + OffX + Scr^.wBorRight > Scr^.width) OR\n"
                     "     (ComputeY (height) + OffY + Scr^.wBorBottom > Scr^.height) THEN\n"
                     "    Font^.name := y.ADR (\"topaz.font\");\n"
                     "    Font^.ySize := 8;\n"
                     "    FontY := Font^.ySize;\n"
                     "    FontX := Font^.ySize;\n"
                     "  END;\n"
                     "END ComputeFont;\n\n");
    END;

    FPutS (file, "PROCEDURE SetupScreen* (");
    IF gtx.Public IN GuiData.flags0 THEN FPutS (file, "pub: ARRAY OF CHAR"); END;
    FPutS (file, "): INTEGER; (* $CopyArrays- *)\nBEGIN\n");
    IF CheckFont() THEN
        FPrintF (file, "  Font := df.OpenDiskFont (%s%ld^);\n", s.ADR(fname), GuiData.font.ySize);
        FPutS (file, "  IF Font = NIL THEN RETURN 3 END;\n");
    END;

    IF gtx.Workbench IN GuiData.flags0 THEN FPutS (file, "  Scr := I.LockPubScreen (\"Workbench\");");
    ELSIF gtx.Public IN GuiData.flags0 THEN
          FPutS(file,"IF pub#\"\" THEN Scr:=I.LockPubScreen(pub) ");
          FPutS(file,"ELSE Scr:=I.LockPubScreen(NIL) END;\n");
    ELSIF gtx.Custom IN GuiData.flags0 THEN
        FPutS (file, "  Scr := I.OpenScreenTagsA (NIL,\n");
        FPrintF (file, "            I.saLeft,          %ld,\n", GuiData.left);
        FPrintF (file, "            I.saTop,           %ld,\n", GuiData.top);
        FPrintF (file, "            I.saWidth,         %ld,\n", GuiData.width);
        FPrintF (file, "            I.saHeight,        %ld,\n", GuiData.height);
        FPrintF (file, "            I.saDepth,         %ld,\n", GuiData.depth);

        IF GuiData.colors[0].colorIndex # -1 THEN
            FPutS (file, "            I.saColors,        y.ADR (ScreenColors[0]),\n");
        END;

        IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
            FPrintF (file, "            I.saFont,          y.ADR (%s%ld),\n", s.ADR(fname), GuiData.font.ySize);
        END;
        FPutS (file, "            I.saType,          LONGSET {0..3} (* I.customScreen *),\n"
                     "            I.saDisplayID,     ");
        WriteObIDFlags (s.VAL(LONGSET,GuiData.displayID));

        IF gtx.AutoScroll IN GuiData.flags0 THEN
           FPutS (file, "            I.saAutoScroll,    I.LTRUE,\n"
                        "            I.saOverscan,      g.oScanText,\n");
        END;

        FPutS (file, "            I.saPens,          y.ADR (DriPens[0]),\n");
        IF st.Length (GuiData.screenTitle) > 0 THEN
           FPrintF (file, "            I.saTitle,         y.ADR (\"%s\"),\n", s.ADR(GuiData.screenTitle));
        END;
        FPutS (file, "            u.done);\n");
    END;

    FPutS (file, "  IF Scr = NIL THEN RETURN 1 END;\n\n");

    IF gtx.FontAdapt IN MainConfig.configFlags0 THEN
        FPutS (file, "  ComputeFont (0, 0);\n\n");
    END;

    FPutS (file, "  VisualInfo := gt.GetVisualInfo (Scr, u.done);\n"
                 "  IF VisualInfo = NIL THEN RETURN 2 END;\n\n");

    IF GetFilePresent THEN
        FPutS (file, "  GetImage := I.NewObject (gf.GetFileClass, NIL, gt.visualInfo, VisualInfo, u.done);\n"
                     "  IF GetImage = NIL THEN RETURN 4 END;\n\n");
    END;

    FPutS (file, "  RETURN 0;\nEND SetupScreen;\n\n");
END WriteObSetupScr;
(* $Debug= *)

(* --- Write the Oberon Source file. *)
PROCEDURE WriteOberonSource;
VAR
   pw: gtx.ProjectWindowPtr;
   fname, ModuleName: ARRAY 32 OF CHAR; pos: LONGINT;
   fnm: e.STRPTR;
   pnum: INTEGER;
BEGIN
    (* $OddChk- *)
    COPY(GuiData.fontName,fname);
    (* $OddChk= *)
    fname[st.Occurs(fname,'.')] := 0X;

    (*
     *      Copy the base name of the source
     *      into a buffer. P.S. No checks are
     *      done if the name ends with ".mod"
     *)
    (* $OddChk- *)
    COPY(args.baseName^,Path);
    (* $OddChk= *)

    (*
     *      Get the module name and
     *      delete the ".mod" extennsion
     *      IFpresent.
     *)
    fnm := d.PathPart (Path);
    IF fnm # NIL THEN
        IF fnm[0] = '/' THEN fnm := s.VAL(e.STRPTR,s.VAL(LONGINT,fnm)+1); END;
        (* $OddChk- *)
        COPY(fnm^,ModuleName);
        (* $OddChk= *)
        pos := st.Occurs(ModuleName, '.');
        IF pos > 0 THEN ModuleName[pos] := 0X END;
    END;


    IF args.force=d.DOSFALSE THEN file:=OpenSafe(Path) ELSE file:=d.Open(Path,d.newFile) END;



    IF file # NIL THEN
       d.PrintF ("Saving Oberon Source...\n");
       s.SETREG(0,d.SetIoErr (0));
       CheckGetFile();
       FPrintF (file, "MODULE %s;\n\n", s.ADR(ModuleName));

       FPrintF (file,"(*\n *  Source generated with %s\n"
                         " *  OG is based on GenOberon V1.0 by Kai Bolay & Jan van den Baard\n"
                         " *  GenOberon is based on internal GenOberon by Kai Bolay\n"
                         " *  internal GenOberon is based on GenC by Jan van den Baard\n *\n"
                         " *  GUI Designed by : %s\n *)\n\n", s.ADR(VERSION[6]), s.ADR(MainConfig.userName));

       FPutS (file, "IMPORT\n  e: Exec, I: Intuition, gt: GadTools, g: Graphics, u: Utility, ");

       IF CheckFont() OR (gtx.SysFont IN ObConfig.configFlags0) THEN
          FPutS (file, "df: DiskFont, ");
       END;

       IF GetFilePresent THEN
          FPutS (file, "gf: GetFile, ");
       END;

       FPutS (file, "y: SYSTEM;\n\n");

       WriteObID();

       WriteObGlob();
       WriteObLabels();
       WriteObList();

       IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN WriteObTextAttr() END;

       WriteObIText();
       WriteObMenus();
       WriteObGTypes();
       WriteObGArray();
       WriteObGTags();

       IF gtx.Custom IN GuiData.flags0 THEN
          WriteObSTags();
       END;

       WriteObSetupScr();
       WriteObScrCleanup();

       IF args.raster = d.DOSTRUE THEN
          FPutS (file, "PROCEDURE DrawRast (win: I.WindowPtr);\n"
                       "TYPE\n  PattType = ARRAY 2 OF INTEGER;\n"
                       "CONST\n  backPatt = PattType(0AAAAU,05555U);\n"
                       "BEGIN\n"
                       "IF ((win.width-win.borderLeft-1) >= win.borderLeft )\n"
                       " & ((win.height-win.borderBottom-1) >= win.borderTop) THEN\n "
                       "   g.SetAPen (win.rPort, 1);\n"
                       "   g.SetAfPt (win.rPort, y.ADR(backPatt),1);\n"
                       "   g.RectFill(win.rPort, win.borderLeft,win.borderTop,\n"
                       "                         win.width-win.borderLeft-1, win.height-win.borderBottom-1);\n"
                       "   g.SetAfPt (win.rPort, NIL,0);\n"
                       "END (* if *)\n"
                       "END DrawRast;\n\n");

          FPutS (file, "PROCEDURE FilledBBox (vi: gt.VisualInfo; rp: g.RastPortPtr; l,t, w,h: INTEGER; recessed: BOOLEAN);\n"
                       "BEGIN\n"
                       "  IF recessed THEN\n"
                       "    gt.DrawBevelBox (rp, l,t, w,h, gt.visualInfo,vi, gt.bbRecessed,I.LTRUE, u.done);\n"
                       "  ELSE\n"
                       "    gt.DrawBevelBox (rp, l,t, w,h, gt.visualInfo,vi, u.done);\n"
                       "  END;\n"
                       "  g.SetAPen (rp,0); g.RectFill (rp, l+2,t+1, l+w-3,t+h-2); g.SetAPen (rp,1);\n"
                       "END FilledBBox;\n\n");
       END;


       pw := Projects.head; pnum := 0;
       WHILE pw.succ # NIL DO
           CheckItOut (pw);

           (*
           **   Both texts and boxes are supported
           **   with or without font-adapt.
           **)
           IF (pw.windowText # NIL) OR (pw.boxes.head.succ # NIL) THEN
              WriteObRender(pw);
           END;

           IF pw.gadgets.head.succ # NIL THEN
               WriteObGadHeader(pw);

               FPrintF (file, "  gad := gt.CreateContext (%sGList);\n", s.ADR(pw.name));
               FPutS (file, "  IF gad = NIL THEN RETURN 1 END;\n\n");

               WriteObGadgets(pw, pnum);

               FPrintF  (file, "\n  RETURN 0;\nEND Create%sGadgets;\n\n", s.ADR(pw.name));
           END;

           WriteObHeader(pw);
           (*
           WriteObNodes (pw, pnum);
           *)
           IF pw.gadgets.head.succ # NIL THEN
              FPrintF (file, "\n  IF createGads THEN\n"
                      "     ret := Create%sGadgets(); IF ret # 0 THEN RETURN ret END;\n"
                      "  END;\n\n",s.ADR(pw.name));
           END;



           IF pw.menus.head.succ # NIL THEN
               FPrintF (file, "  %sMenus := gt.CreateMenus (%sNewMenu, gt.mnFrontPen, 0, u.done);\n", s.ADR(pw.name), s.ADR(pw.name));
               FPrintF (file, "  IF %sMenus = NIL THEN RETURN 3 END;\n\n", s.ADR(pw.name));
               FPrintF (file, "  IF NOT gt.LayoutMenus (%sMenus, VisualInfo, ", s.ADR(pw.name));
               IF ~(gtx.FontAdapt IN MainConfig.configFlags0) THEN
                   FPrintF (file, "gt.mnTextAttr, y.ADR (%s%ld), u.done) THEN RETURN 4 END;\n\n", s.ADR(fname), GuiData.font.ySize);
               ELSE
                   FPutS (file, "u.done) THEN RETURN 4 END;\n\n");
               END;
           END;

           IF ~(I.windowSizing IN pw.windowFlags) THEN
               IF gtx.Zoom IN pw.tagFlags THEN
                   FPrintF (file, "  %sZoom[0] := %sLeft;\n  %sZoom[1] := %sTop;\n", s.ADR(pw.name), s.ADR(pw.name),  s.ADR(pw.name), s.ADR(pw.name));
               ELSIF gtx.DefaultZoom IN pw.tagFlags THEN
                   FPrintF (file, "  %sZoom[0] := 0;\n  %sZoom[1] := 0;\n", s.ADR(pw.name), s.ADR(pw.name));
               END;
               IF LONGSET{gtx.Zoom,gtx.DefaultZoom} * pw.tagFlags # LONGSET{} THEN
                  FPrintF (file, "  %sZoom[2] := g.TextLength (y.ADR (Scr^.rastPort), \"%s\", %ld) + 80;\n", s.ADR(pw.name), s.ADR(pw.windowTitle[0]), st.Length (pw.windowTitle));
                  FPrintF (file, "  %sZoom[3] := Scr^.wBorTop + Scr^.rastPort.txHeight + 1;\n\n", s.ADR(pw.name));
               END;
           END;

           WriteObWindow(pw);

           IF pw.menus.head.succ # NIL THEN
               FPrintF (file, "  IF NOT I.SetMenuStrip (%sWnd, %sMenus^) THEN RETURN 5 END;\n", s.ADR(pw.name), s.ADR(pw.name));
           END;

           (*
           **   Both texts and boxes are supported
           **   with or without font-adapt.
           **)

           IF (pw.windowText # NIL) OR (pw.boxes.head.succ # NIL) THEN
               FPrintF (file, "  %sRender;\n\n", s.ADR(pw.name));
           END;

           FPrintF (file, "  gt.RefreshWindow (%sWnd, NIL);\n\n", s.ADR(pw.name));
           FPrintF  (file, "  RETURN 0;\nEND Open%sWindow;\n\n", s.ADR(pw.name));

           WriteObCleanup(pw);
           pw := pw.succ; INC(pnum);
       END; (* WHILE *)
       FPrintF (file, "\nEND %s.\n", s.ADR(ModuleName));

       IF d.IoErr() > 0 THEN d.PrintF ("Error: write error\n"); END;
    ELSE
        d.PrintF ("Error: unable to open %s\n", s.ADR(Path));
    END;
END WriteOberonSource;

BEGIN (* main *)
    dosBase := d.base;

    chain := nf.GetMemoryChain(4096);
    IF chain # NIL THEN
        RD := d.ReadArgs(tmp, args, NIL);
        IF RD # NIL THEN
            d.PrintF ("%s.\n Based on Kai Bolay's GenOberon V1.0.\n",s.ADR(VERSION[6]));

            (* $OddChk- *)
            error := gtx.LoadGUI (chain, args.name^, gtx.rgGUI,s.ADR(GuiData),
                                                     gtx.rgConfig,s.ADR(MainConfig),
                                                     gtx.rgWindowList,s.ADR(Projects),
                                                     gtx.rgValid,s.ADR(ValidBits), u.done);
            (* $OddChk= *)
            IF error = 0 THEN
               WriteOberonSource();
            ELSE
                CASE error OF
                    | gtx.ErrorNoMem:      d.PrintF ("Error: out of memory\n");
                    | gtx.ErrorOpen:       d.PrintF ("Error: unable to open the GUI file\n");
                    | gtx.ErrorRead:       d.PrintF ("Error: read error\n");
                    | gtx.ErrorWrite:      d.PrintF ("Error: write error\n");
                    | gtx.ErrorParse:      d.PrintF ("Error: iffparse.library error\n");
                    | gtx.ErrorPacker:     d.PrintF ("Error: unable to decrunch the file\n");
                    | gtx.ErrorPPLib:      d.PrintF ("Error: the file is crunched and the powerpacker.library is not available\n");
                    | gtx.ErrorNotGUIFile: d.PrintF ("Error: not a GUI file\n");
                ELSE
                   d.PrintF ('Unknown error (%ld)!\n',error);
                END;
                error := 0;
            END;
            gtx.FreeWindows (chain, Projects);
        ELSE
            s.SETREG(0,d.PrintFault (d.IoErr(), "Error"));
        END;
    ELSE
        d.PrintF("Error: Out of memory\n");
    END;

CLOSE
    IF chain # NIL THEN nf.FreeMemoryChain (chain,TRUE) END;
    IF RD    # NIL THEN d.FreeArgs(RD) END;
    IF file  # NIL THEN d.OldClose (file); file := NIL; END;
END OG.
