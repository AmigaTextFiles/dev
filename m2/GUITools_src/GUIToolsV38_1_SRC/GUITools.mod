(**********************************************************************
:Program.    GUITools.mod
:Contents.   Functions for creating and using GUIs
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to GUITools-Documentation
:Language.   Modula-2
:Translator. M2Amiga V4.1
:Remark.     OS 2.0 required
:Remark.     see GUITools-Documentation for detailled information
:History.    v38.1  Carsten Ziegeler  20-May-94
**********************************************************************)
IMPLEMENTATION MODULE GUITools;

  FROM SYSTEM      IMPORT ADDRESS, ADR, CAST, LONGSET, TAG, WORD;
  FROM DiskFontL   IMPORT OpenDiskFont;
  FROM ExecD       IMPORT ListPtr, MemReqSet, MemReqs, MsgPort, NodePtr, Task;
  FROM ExecL       IMPORT AllocMem, FindTask, Forbid, FreeMem, Permit, WaitPort;
  FROM GadToolsD   IMPORT NewGadgetFlagSet, NewGadgetFlags, listviewKind,
                          mxKind, genericKind, numKinds, integerKind, cycleKind,
                          stringKind, sliderKind, scrollerKind, NewMenu, nmEnd,
                          checkboxKind, GtTags, checkboxWidth, checkboxHeight,
                          mxWidth, mxHeight, buttonKind, paletteKind,
                          textKind, numberKind, NewGadget;
  FROM GraphicsD   IMPORT TextAttrPtr, TextFontPtr, TextAttr, FontFlagSet,
                          FontStyleSet, FontFlags, jam1;
  FROM GraphicsL   IMPORT OpenFont, CloseFont, SetAPen, RectFill;
  FROM IntuiMacros IMPORT MenuNum, ItemNum, SubNum, MenuItemUserData;
  FROM IntuitionD  IMPORT DrawInfoPtr, DrawInfo, Gadget, GadgetPtr, DrawPens,
                          ScreenPtr, WindowPtr, IDCMPFlagSet, IDCMPFlags,
                          WindowFlagSet, IntuiTextPtr, MenuItemPtr, GaTags,
                          IntuiMessagePtr, StringInfoPtr, WaTags, publicScreen,
                          SaTags, IntuiText, GadgetFlags, menuNull, noItem;
  FROM String      IMPORT Copy, Occurs, noOccur, Length;
  FROM UtilityD    IMPORT Tag, TagItem, TagItemPtr, tagMore, tagEnd,
                          tagFilterNOT, tagIgnore;

IMPORT GL : GadToolsL, IL : IntuitionL, UL : UtilityL, Req:GTRequester;

TYPE
  GUIWindowInfoPtr = POINTER TO GUIWindowInfo;
  GUIWindowInfo = RECORD
    next   : GUIWindowInfoPtr;
    prev   : GUIWindowInfoPtr;
    window : WindowPtr;
    gui    : GUIInfoPtr;
  END;
  ProcessPtr = POINTER TO Process; (* IMPORT DosD not needed ! *)
  Process = RECORD
    t : Task;  m : MsgPort; p : WORD; unwichtig : ARRAY[0..13] OF LONGCARD;
    windowPtr : WindowPtr;
  END;
  TAGARRAY = ARRAY[0..24] OF Tag;
  TAGARRAY2= ARRAY[0..11] OF Tag;

CONST NOTREMEMBERTAGS = TAGARRAY{Tag(gtmxActive), Tag(gtcbChecked),
                                 Tag(gtcyActive), Tag(gtslMin), Tag(gtslMax),
          Tag(gtslLevel), Tag(gtscTop), Tag(gtscVisible), Tag(gtscTotal),
          Tag(gtlvSelected), Tag(gtpaColorOffset), Tag(gtpaColor),
          Tag(sgbbRecessed), Tag(sgpiCurrentValue), Tag(sgpiMaxValue),
          Tag(gaDisabled), Tag(sgGadgetText), Tag(sgGadgetFlags),
          Tag(sgGadgetFont), Tag(sgGadgetID), Tag(sgVisualInfo),
          Tag(sgUserData), Tag(sgGadgetDesc), Tag(sgGadgetObjects), tagEnd};

      NOGADTOOLSTAGS = TAGARRAY2{Tag(sgGadgetText), Tag(sgGadgetFlags),
                                 Tag(sgpiMaxValue), Tag(sgpiCurrentValue),
                                 Tag(sgbbRecessed), Tag(sgGadgetFont),
                                 Tag(sgGadgetID), Tag(sgVisualInfo),
                                 Tag(sgUserData), Tag(sgGadgetDesc),
                                 Tag(sgGadgetObjects),
                                 tagEnd};

      REALGUISIZE = SIZE(GUIInfo) + SIZE(GUIWindowInfo);
      GUIWININFO  = SIZE(GUIInfo);
      GUIEND      = GUIWININFO + SIZE(GUIWindowInfo);

      noKeyEqu = -1;

      gadgetsSet = 0;  menuSet = 1; rememberGadTags = 2; redrawGads = 3;
      spezialGadsNoText = 4; restoreProcessWindow = 5; setProcessWindow = 6;
      refreshWF = 7; useGadDesc = 8;

      SPEZIALGADSIZE = SIZE(Gadget) + SIZE(IntuiText);

      lvNotSel = 65535;

VAR allWindowsWithGUI : GUIWindowInfoPtr;

  PROCEDURE SetGUIError(gui : GUIInfoPtr; error : INTEGER);
  BEGIN
    WITH gui^ DO
      (* Um bei späteren Versionen Probleme zu vermeiden, ggf tagliste weg*)
      IF tagmem # NIL THEN UL.FreeTagItems(tagmem); tagmem := NIL END;
      IF firstError = guiSet THEN firstError := error END;
      gad := NIL; (* Verhindert weitere Gadget-Erstellung *)
      gadget := NIL;
    END;
  END SetGUIError;

  PROCEDURE CreateGUIInfo(window : WindowPtr;
                          maxGads, maxMenus : INTEGER) : GUIInfoPtr;
  VAR gui : GUIInfoPtr;
  BEGIN
    gui := CreateGUIInfoTags(window, maxGads, maxMenus, NIL);
    (* 37_3 Compatibility *)
    IF gui # NIL THEN gui^.menuFont := ADR(gui^.font) END;
    RETURN gui;
  END CreateGUIInfo;

  PROCEDURE CreateGUIInfoTags(window   : WindowPtr;
                              maxGads  : INTEGER;
                              maxMenus : INTEGER;
                              tags     : TagItemPtr) : GUIInfoPtr;
  VAR gui    : GUIInfoPtr;
      next   : TagItemPtr;
      info   : DrawInfoPtr;
      winInf : GUIWindowInfoPtr;
      length : LONGINT;
      error  : LONGINT;
      i      : INTEGER;
  BEGIN
    gui   := NIL;
    error := cgiNoError;

    IF window # NIL THEN

      length := REALGUISIZE;;
      INC(length, maxGads * 4);
      INC(length, maxMenus * SIZE(NewMenu));

      gui := AllocMem(length, MemReqSet{memClear, public});
      IF gui # NIL THEN

        gui^.window := window;
        WITH gui^ DO
          winIWidth := window^.width - window^.borderLeft - window^.borderRight;
          winIHeight:= window^.height- window^.borderTop  - window^.borderBottom;
          firstError := guiSet;
          screen := window^.wScreen;
          FOR i := 0 TO 25 DO
            keys[i] := noKeyEqu;
          END;
          prcwin   := CAST(ProcessPtr, FindTask(NIL))^.windowPtr;
          gadgets := ADDRESS(gui);
          INC(gadgets, GUIEND);
          newMenus := ADDRESS(gui);
          INC(newMenus, GUIEND);
          INC(newMenus, maxGads*4);
          menuFont := screen^.font;
          port     := window^.userPort;
          maxgads  := maxGads;
          maxmenus := maxMenus;
          vanKeyFctData := gui;
          menuFctData := gui;
        END;
        WITH gui^.font DO
          name  := window^.rPort^.font^.message.node.name;
          ySize := window^.rPort^.font^.ySize;
          style := window^.rPort^.font^.style;
          flags := window^.rPort^.font^.flags;
        END;

        gui^.visual   := GL.GetVisualInfoA(window^.wScreen, NIL);
        IF gui^.visual # NIL THEN

          gui^.drawinfo := IL.GetScreenDrawInfo(window^.wScreen);
          IF gui^.drawinfo # NIL THEN

            IF (maxGads > 0) THEN
              gui^.gad := GL.CreateContext(gui^.gadlist);
              WITH gui^.newgad DO
                textAttr   := ADR(gui^.font);
                visualInfo := gui^.visual;
              END;
              IF gui^.gadlist = NIL THEN
                error := cgiCreateContext;
              END;
            END;

            IF maxMenus > 0 THEN
              gui^.newMenus^[0].type := nmEnd;
            END;
          ELSE
            error := cgiNoDrawInfo;
          END;
        ELSE
          error := cgiNoVisualInfo;
        END;
      ELSE
        error := cgiNoMemory;
      END;
    ELSE
      error := cgiNoWindow;
    END;

    IF (error # cgiNoError) AND (gui # NIL) THEN
      WITH gui^ DO
        IF drawinfo # NIL THEN IL.FreeScreenDrawInfo(screen, drawinfo) END;
        IF visual # NIL THEN GL.FreeVisualInfo(visual) END;
      END;
      FreeMem(gui, length);
      gui := NIL;
    ELSE  (* gui # NIL *)
      winInf := ADDRESS(gui);
      INC(winInf, GUIWININFO);
      Forbid;
        IF allWindowsWithGUI = NIL THEN
          allWindowsWithGUI := winInf;
        ELSE
          winInf^.next := allWindowsWithGUI;
          allWindowsWithGUI^.prev := winInf;
          allWindowsWithGUI := winInf;
        END;
        winInf^.window := window;
        winInf^.gui := gui;
      Permit;
    END;

    IF tags # NIL THEN
      next := UL.NextTagItem(tags);
      WHILE next # NIL DO
        IF gui # NIL THEN
          CASE next^.tag OF
            Tag(guiResizableGads) :

               IF next^.data # 0 THEN
                 INCL(gui^.status, rememberGadTags);
                 INCL(gui^.status, refreshWF);
               ELSE
                 EXCL(gui^.status, rememberGadTags);
                 EXCL(gui^.status, refreshWF);
               END;
          | Tag(guiFlags)    : gui^.flags := CAST(GUIInfoFlagSet, next^.data);
          | Tag(guiGadFont)  : gui^.newgad.textAttr := TextAttrPtr(next^.data);
          | Tag(guiMenuFont) : gui^.menuFont := TextAttrPtr(next^.data);
          | Tag(guiVanKeyFct): gui^.vanKeyHook := CAST(VanKeyFct, next^.data);
          | Tag(guiSetProcessWindow) :

               IF next^.data # 0 THEN
                 INCL(gui^.status, setProcessWindow);
               ELSE
                 EXCL(gui^.status, setProcessWindow);
               END;
          | Tag(guiRestoreProcessWindow) :

               IF next^.data # 0 THEN
                 INCL(gui^.status, restoreProcessWindow);
               ELSE
                 EXCL(gui^.status, restoreProcessWindow);
               END;
          | Tag(guiRefreshWindowFrame) :

               IF next^.data # 0 THEN
                 INCL(gui^.status, refreshWF);
               ELSE
                 EXCL(gui^.status, refreshWF);
               END;
          | Tag(guiVanKeyFctData) : gui^.vanKeyFctData := next^.data;
          | Tag(guiMenuFctData)   : gui^.menuFctData := next^.data;
          | Tag(guiUserData)      : gui^.userData := next^.data;
          | Tag(guiCompilerReg)   : gui^.compilerReg := next^.data;
          | Tag(guiUseGadDesc) :

               IF next^.data # 0 THEN
                 INCL(gui^.status, useGadDesc);
               ELSE
                 EXCL(gui^.status, useGadDesc);
               END;
          ELSE
          END;
        END;
        IF (next^.tag = Tag(guiCreateError)) AND (next^.data # 0) THEN
          CAST(LINTPTR, next^.data)^ := error;
        END;
        next := UL.NextTagItem(tags);
      END;
    END;
    IF (gui # NIL) AND (setProcessWindow IN gui^.status) THEN
      CAST(ProcessPtr, FindTask(NIL))^.windowPtr := window;
    END;
    RETURN gui;
  END CreateGUIInfoTags;

  PROCEDURE FreeGUIInfo(gui : GUIInfoPtr);
  VAR winInf : GUIWindowInfoPtr;
  BEGIN
    IF gui # NIL THEN
      winInf := ADDRESS(gui);
      INC(winInf, GUIWININFO);
      Forbid;
        IF winInf^.prev = NIL THEN
          allWindowsWithGUI := winInf^.next;
        ELSE
          winInf^.prev^.next := winInf^.next;
        END;
        IF winInf^.next # NIL THEN
          winInf^.next^.prev := winInf^.prev;
        END;
      Permit;
      RemoveGadgets(gui, TRUE);
      RemoveMenu(gui, TRUE);
      WITH gui^ DO
        IF gadlist # NIL THEN GL.FreeGadgets(gadlist) END;
        IF restoreProcessWindow IN status THEN
          CAST(ProcessPtr, FindTask(NIL))^.windowPtr := prcwin;
        END;
        IF visual # NIL THEN GL.FreeVisualInfo(visual) END;
        IF drawinfo # NIL THEN IL.FreeScreenDrawInfo(screen, drawinfo) END;
        FreeMem(gui, REALGUISIZE + maxgads*4 + maxmenus*SIZE(NewMenu));
        IF tagmem # NIL  THEN UL.FreeTagItems(tagmem) END;
      END;
    END;
  END FreeGUIInfo;

  (* INTERNAL PROCEDURE, calculate the gadget text *)
  PROCEDURE CalcText(gui : GUIInfoPtr; Gadget : GadgetPtr);
  VAR text  : IntuiTextPtr;
      flags : NewGadgetFlagSet;
      length: LONGINT;
      ysize : INTEGER;
  BEGIN
    text := Gadget^.gadgetText;
    IF text^.iText # NIL THEN
      flags := CAST(NewGadgetFlagSet, Gadget^.specialInfo);
      WITH text^ DO
        frontPen := gui^.drawinfo^.pens^[textPen];
        backPen  := gui^.drawinfo^.pens^[backGroundPen];
        drawMode := jam1;
        leftEdge := Gadget^.leftEdge;
        topEdge  := Gadget^.topEdge;
        length   := IL.IntuiTextLength(text);
        ysize    := text^.iTextFont^.ySize;
        IF    placetextLeft IN flags THEN
          DEC(leftEdge, length+2);
          INC(topEdge, (Gadget^.height - ysize) DIV 2);
        ELSIF placetextRight IN flags THEN
          INC(leftEdge, Gadget^.width+2);
          INC(topEdge, (Gadget^.height - ysize) DIV 2);
        ELSIF placetextAbove IN flags THEN
          INC(leftEdge, (Gadget^.width - length) DIV 2);
          DEC(topEdge, 2+ysize);
        ELSIF placetextBelow IN flags THEN
          INC(leftEdge, (Gadget^.width - length) DIV 2);
          INC(topEdge, Gadget^.height+2);
        ELSIF placetextIn    IN flags THEN
          INC(leftEdge, (Gadget^.width - length) DIV 2);
          INC(topEdge, (Gadget^.height - ysize) DIV 2);
        END;
        IF ngHighlabel IN flags THEN
          frontPen := gui^.drawinfo^.pens^[highLightTextPen];
        END;
      END;
    END;
  END CalcText;

  (* INTERNAL PROCEDURE, draw guitools gadgets *)
  PROCEDURE DrawGadget(gui : GUIInfoPtr;
                       Gadget: GadgetPtr;
                       ginfo : GUIGadgetInfoPtr);
  VAR oldAPen : INTEGER;
      cut     : LONGINT;
  BEGIN
    IF    ginfo^.kind = progressIndicatorKind THEN
      DrawBox(gui, Gadget^.leftEdge, Gadget^.topEdge,
                   Gadget^.width, Gadget^.height, TRUE);
      oldAPen := gui^.window^.rPort^.fgPen;
      WITH Gadget^ DO
        IF ginfo^.v1 > 0 THEN
          cut := LONGINT(width-3) * LONGINT(ginfo^.v1S) DIV LONGINT(ginfo^.v0S);
          SetAPen(gui^.window^.rPort, gui^.drawinfo^.pens^[fillPen]);
          RectFill(gui^.window^.rPort, leftEdge + 2, topEdge + 1,
                   leftEdge + cut, topEdge + height - 2);
        END;
        IF ginfo^.v1S < ginfo^.v0S THEN
          SetAPen(gui^.window^.rPort, gui^.drawinfo^.pens^[backGroundPen]);
          cut := LONGINT(width-3) * LONGINT(ginfo^.v1S) DIV LONGINT(ginfo^.v0S);
          RectFill(gui^.window^.rPort, leftEdge + cut + 1,
                   topEdge + 1, leftEdge + width - 3, topEdge + height - 2);
        END;
      END;
      SetAPen(gui^.window^.rPort, oldAPen);
    ELSIF ginfo^.kind = bevelboxKind THEN
      DrawBox(gui, Gadget^.leftEdge, Gadget^.topEdge,
              Gadget^.width, Gadget^.height, ginfo^.v0B);
    END;
    IF (~(spezialGadsNoText IN gui^.status)) AND
       (Gadget^.gadgetText^.iText # NIL) THEN
      IL.PrintIText(gui^.window^.rPort, Gadget^.gadgetText, 0, 0);
    END;
  END DrawGadget;

  (* INTERNAL PROCEDURE, new gadget size, position ! *)
  PROCEDURE CalculateGadget(gui : GUIInfoPtr; VAR value : INTEGER;
                            dist : DistanceFlagSet; object : SHORTCARD;
                            horiz : BOOLEAN);
  VAR objLeft, objRight : INTEGER;
      info : GUIGadgetInfoPtr;
      long : LONGINT;
  BEGIN
    IF rel IN dist THEN
      IF horiz THEN
        long := LONGINT(value) * LONGINT(gui^.window^.width - gui^.window^.borderLeft - gui^.window^.borderRight) DIV LONGINT(gui^.winIWidth);
      ELSE
        long := LONGINT(value) * LONGINT(gui^.window^.height - gui^.window^.borderTop - gui^.window^.borderBottom) DIV LONGINT(gui^.winIHeight);
      END;
      value := INTEGER(long);
    END;

    IF ~((abs IN dist) AND (rel IN dist)) AND
        ((abs IN dist) OR  (rel IN dist)) THEN

      IF gadget IN dist THEN

        info := gui^.gadgets^[object]^.userData;
        IF horiz THEN
          objLeft := info^.gadDesc.leftEdge;
          objRight:= objLeft + info^.gadDesc.width;
        ELSE
          objLeft := info^.gadDesc.topEdge;
          objRight:= objLeft + info^.gadDesc.height;
        END;

      ELSE  (* border *)
        IF horiz THEN
          objLeft := gui^.window^.borderLeft;
          objRight:= gui^.window^.width - gui^.window^.borderRight;
        ELSE
          objLeft := gui^.window^.borderTop;
          objRight:= gui^.window^.height - gui^.window^.borderBottom;
        END;
      END;
      IF obLeftTop IN dist THEN INC(value, objLeft) ELSE INC(value, objRight) END;
    END;
  END CalculateGadget;

  (* INTERNAL PROCEDURE, reads gadget description *)
  PROCEDURE ConvGadDesc(gui : GUIInfoPtr; ginfo : GUIGadgetInfoPtr;
                        VAR newgad : NewGadget);
  BEGIN
    CalculateGadget(gui, newgad.leftEdge, ginfo^.description[0], ginfo^.gadfield[0], TRUE);
    CalculateGadget(gui, newgad.topEdge,  ginfo^.description[1], ginfo^.gadfield[1], FALSE);
    CalculateGadget(gui, newgad.width,    ginfo^.description[2], ginfo^.gadfield[2], TRUE);
    CalculateGadget(gui, newgad.height,   ginfo^.description[3], ginfo^.gadfield[3], FALSE);
    IF (~(abs IN ginfo^.description[0]) AND ~(rel IN ginfo^.description[0])) OR
       ( (abs IN ginfo^.description[0]) AND  (rel IN ginfo^.description[0])) THEN
      INC(newgad.topEdge, gui^.window^.borderTop);
    END;
    IF (~(abs IN ginfo^.description[1]) AND ~(rel IN ginfo^.description[1])) OR
       ( (abs IN ginfo^.description[1]) AND  (rel IN ginfo^.description[1])) THEN
      INC(newgad.leftEdge, gui^.window^.borderLeft);
    END;
    IF ~((abs IN ginfo^.description[2]) AND (rel IN ginfo^.description[2])) AND
        ((abs IN ginfo^.description[2]) OR  (rel IN ginfo^.description[2])) THEN
      DEC(newgad.width, newgad.leftEdge);
    END;
    IF ~((abs IN ginfo^.description[3]) AND (rel IN ginfo^.description[3])) AND
        ((abs IN ginfo^.description[3]) OR  (rel IN ginfo^.description[3])) THEN
      DEC(newgad.height, newgad.topEdge);
    END;
  END ConvGadDesc;

  PROCEDURE SetGUI(gui : GUIInfoPtr) : INTEGER;
  VAR Gadget : GadgetPtr;
      buffer : ARRAY[0..1] OF TagItem;
      i : INTEGER;
  BEGIN
    WITH gui^ DO
      IF (firstError = guiSet) AND (~(gadgetsSet IN status)) AND
         (gadlist # NIL) AND (gad # NIL) THEN
        IF IL.AddGList(window, gadlist, -1, -1, NIL) = 0 THEN END;
        IL.RefreshGList(gadlist, window, NIL, -1);
        GL.GTRefreshWindow(window, NIL);
        IF (activateFirstEGad IN flags) AND (firstEGad # NIL) THEN
          IF IL.ActivateGadget(firstEGad, window, NIL) THEN END;
        END;
        INCL(status, gadgetsSet);

        Gadget := spezialGad;
        WHILE Gadget # NIL DO
          DrawGadget(gui, Gadget, Gadget^.userData);
          Gadget := Gadget^.nextGadget;
        END;

        IF redrawGads IN status THEN
          FOR i := 0 TO actgad-1 DO
            IF ~(CAST(GUIGadgetInfoPtr,
                      gadgets^[i]^.userData)^.gadActive) THEN
              GadgetStatus(gui, i, FALSE);
            END;
          END;
          EXCL(status, redrawGads);
        END;
      ELSE
        SetGUIError(gui, gadgetError);
      END;
    END;
    IF (gui^.firstError = guiSet) AND (~(menuSet IN gui^.status)) AND
       (gui^.actmenu > 0) THEN
      gui^.menus := GL.CreateMenusA(ADDRESS(gui^.newMenus), NIL);
      IF gui^.menus # NIL THEN
        IF GL.LayoutMenusA(gui^.menus, gui^.visual, TAG(buffer,
                          gtmnTextAttr, gui^.menuFont, tagEnd)) THEN

          IF IL.SetMenuStrip(gui^.window, gui^.menus) THEN
            INCL(gui^.status, menuSet);
          ELSE
            SetGUIError(gui, menuSetError);
            GL.FreeMenus(gui^.menus);
            gui^.menus := NIL;
          END;

        ELSE
          SetGUIError(gui, menuLayoutError);
          GL.FreeMenus(gui^.menus);
          gui^.menus := NIL;
        END;
      ELSE
        SetGUIError(gui, menuError);
      END;
    END;
    RETURN gui^.firstError;
  END SetGUI;

  (* INTERNAL PROCEDURE, scan gadget parameters *)
  PROCEDURE ScanGadget(gui : GUIInfoPtr; ginfo : GUIGadgetInfoPtr;
                       tags:TagItemPtr; create : BOOLEAN);
  VAR tag   : TagItemPtr;
      list  : ListPtr;
      node  : NodePtr;
      i     : CARDINAL;

    PROCEDURE LoadVX(sTag : Tag; adr : CARDPTR; default : CARDINAL);
    BEGIN
      tag := UL.FindTagItem(sTag, tags);
      IF    tag # NIL THEN
        adr^ := CARDINAL(tag^.data);
      ELSIF create THEN
        adr^ := default;
      END;
    END LoadVX;

    PROCEDURE LoadLabelsV1(sTag : Tag);
    VAR labPtr : POINTER TO ADDRESS;
    BEGIN
      tag := UL.FindTagItem(sTag, tags);
      IF tag # NIL THEN
        ginfo^.v1 := 0;
        labPtr := ADDRESS(tag^.data);
        WHILE labPtr^ # NIL DO
          INC(ginfo^.v1);
          INC(labPtr, 4);
        END;
      END;
    END LoadLabelsV1;

    PROCEDURE LoadV0B(sTag : Tag);
    BEGIN
      tag := UL.FindTagItem(sTag, tags);
      IF    tag # NIL THEN
        ginfo^.v0B := tag^.data # 0;
      ELSIF create THEN
        ginfo^.v0B := FALSE;
      END;
    END LoadV0B;

    PROCEDURE LoadVXS(sTag : Tag; adr : INTPTR; default : INTEGER);
    BEGIN
      tag := UL.FindTagItem(sTag, tags);
      IF    tag # NIL THEN
        adr^ := INTEGER(tag^.data);
      ELSIF create THEN
        adr^ := default;
      END;
    END LoadVXS;

  BEGIN
    CASE ginfo^.kind OF
      mxKind       : LoadVX(Tag(gtmxActive), ADR(ginfo^.v0), 0);
                     LoadLabelsV1(Tag(gtmxLabels));
    | cycleKind    : LoadVX(Tag(gtcyActive), ADR(ginfo^.v0), 0);
                     LoadLabelsV1(Tag(gtcyLabels));
    | checkboxKind : LoadV0B(Tag(gtcbChecked));
    | sliderKind   : LoadVXS(Tag(gtslMin), ADR(ginfo^.v2S),  0);
                     LoadVXS(Tag(gtslMax), ADR(ginfo^.v1S), 15);
                     LoadVXS(Tag(gtslLevel), ADR(ginfo^.v0S), 0);
    | scrollerKind : LoadVXS(Tag(gtscTop), ADR(ginfo^.v0S), 0);
                     LoadVXS(Tag(gtscVisible), ADR(ginfo^.v1S), 2);
                     LoadVXS(Tag(gtscTotal), ADR(ginfo^.v2S), 0);
    | listviewKind : LoadVX(Tag(gtlvSelected), ADR(ginfo^.v0), lvNotSel);
                     tag := UL.FindTagItem(Tag(gtlvLabels), tags);
                     IF    tag # NIL THEN
                       IF tag^.lidata = -1 THEN
                         ginfo^.v0 := lvNotSel;
                         ginfo^.v1 := lvNotSel;
                       ELSE
                         list := ADDRESS(tag^.data);
                         IF list^.head^.succ = NIL THEN (* list empty*)
                           ginfo^.v0 := lvNotSel;
                           ginfo^.v1 := lvNotSel;
                         ELSE
                           ginfo^.v1 := 0;
                           node := list^.head;
                           WHILE node^.succ # NIL DO
                             INC(ginfo^.v1);
                             node := node^.succ;
                           END;
                         END;
                       END;
                     ELSIF create THEN
                       ginfo^.v0 := lvNotSel;
                       ginfo^.v1 := lvNotSel;
                     END;
                     IF create THEN
                       ginfo^.v2S := -1;
                       tag := UL.FindTagItem(Tag(gtlvShowSelected), tags);
                       IF (tag # NIL) AND (tag^.data # 0) THEN
                         FOR i := 0 TO gui^.actgad-1 DO
                           IF tag^.data = CAST(LONGCARD, gui^.gadgets^[i]) THEN
                             ginfo^.v2S := i;
                           END;
                         END;
                       END;
                     END;
    | paletteKind  : LoadVX(Tag(gtpaColor), ADR(ginfo^.v0), 1);
                     tag := UL.FindTagItem(Tag(gtpaDepth), tags);
                     IF    tag # NIL THEN
                       ginfo^.v1 := 1;
                       FOR i := 1 TO CARDINAL(tag^.data) DO
                         ginfo^.v1 := ginfo^.v1 * 2;
                       END;
                     ELSIF create THEN
                       ginfo^.v1 := 2;
                     END;
                     LoadVX(Tag(gtpaColorOffset), ADR(ginfo^.v2), 0);
    ELSE
      IF    ginfo^.kind = progressIndicatorKind THEN
        LoadVX(Tag(sgpiMaxValue), ADR(ginfo^.v0), 100);
        LoadVX(Tag(sgpiCurrentValue), ADR(ginfo^.v1), 0);
      ELSIF ginfo^.kind = bevelboxKind THEN
        LoadV0B(Tag(sgbbRecessed));
      END;
    END;
    tag := UL.FindTagItem(Tag(gaDisabled), tags);
    IF tag # NIL THEN
      ginfo^.gadActive := tag^.data = 0;
    ELSIF create THEN
      ginfo^.gadActive := TRUE;
    END;
  END ScanGadget;

  PROCEDURE RememberTags(ginfo : GUIGadgetInfoPtr; tags  : TagItemPtr);
  VAR nbr : LONGCARD;
      newchain: TagItemPtr;
      oldTags : TagItemPtr;
      newTags : TagItemPtr;
      next    : TagItemPtr;
      i   : CARDINAL;
  BEGIN
    IF tags # NIL THEN
      newchain := UL.CloneTagItems(tags);
      IF newchain # NIL THEN
        nbr := UL.FilterTagItems(newchain, ADR(NOTREMEMBERTAGS), tagFilterNOT);
        IF nbr > 0 THEN  (* are there any ? *)
          IF ginfo^.nbrTags = 0 THEN  (* one space for tagMore *)
            INC(nbr);
          ELSE                        (* search for double tags ! *)
            next := ginfo^.tagsC;
            FOR i := 1 TO ginfo^.nbrTags-1 DO (* without tagMore *)
              newTags := UL.FindTagItem(next^.tag, newchain);
              IF newTags # NIL THEN
                DEC(nbr);
                next^.data := newTags^.data;
                newTags^.tag := tagIgnore;
              END;
              INC(next, SIZE(TagItem));
            END;
          END;
          IF nbr > 0 THEN
            newTags := AllocMem(SIZE(TagItem) * (nbr + ginfo^.nbrTags),
                                MemReqSet{memClear});
          ELSE
            newTags := NIL;
          END;
          IF newTags # NIL THEN
            ginfo^.impTags := NIL;
            oldTags := ginfo^.tagsC;
            next    := oldTags;
            ginfo^.tagsC := newTags;
            IF ginfo^.nbrTags > 0 THEN
              FOR i := 1 TO ginfo^.nbrTags-1 DO (* copy old tags *)
                newTags^ := next^;              (* excepttagMore *)
                INC(newTags, SIZE(TagItem));
                INC(next,    SIZE(TagItem));
              END;
              FreeMem(oldTags, SIZE(TagItem) * ginfo^.nbrTags);
            END;
            INC(ginfo^.nbrTags, nbr);
            oldTags := newchain;
            next := UL.NextTagItem(oldTags);
            WHILE next # NIL DO
              newTags^ := next^;
              INC(newTags, SIZE(TagItem));
              next := UL.NextTagItem(oldTags);
            END;
            ginfo^.impTags := newTags;
          END;
        END;
        UL.FreeTagItems(newchain);
      END;
    END;
  END RememberTags;

  PROCEDURE MakeMenuEntry(gui : GUIInfoPtr; type : SHORTCARD;
                          text, key : ADDRESS);
  BEGIN
    WITH gui^ DO
      IF (actmenu < (maxmenus-1)) AND (~(menuSet IN status)) THEN
        newMenus^[actmenu].type    := type;
        newMenus^[actmenu].label   := text;
        newMenus^[actmenu].commKey := key;
        menuAdr := ADR(newMenus^[actmenu]);
        INC(actmenu);
        newMenus^[actmenu].type := nmEnd;
      ELSE
        menuAdr := NIL;
        SetGUIError(gui, tooManyMenusError);
      END;
    END;
  END MakeMenuEntry;


  PROCEDURE GadWithKey(gui : GUIInfoPtr; nbr : INTEGER; shift : BOOLEAN);
  VAR ginfo  : GUIGadgetInfoPtr;
      pointer: ADDRESS;
      buffer : ARRAY[0..2] OF TagItem;
  BEGIN
    WITH gui^ DO
      gadget := gadgets^[nbr];
      gadID  := gadget^.gadgetID;
      ginfo  := gadget^.userData;
      IF gadgDisabled IN gadget^.flags THEN
        msgClass := IDCMPFlagSet{};
        cardCode := 0;
        ginfo    := NIL;  (* don't go into CASE switch ! *)
      END;
      IF ginfo # NIL THEN
        gadNbr := ginfo^.v3;
        CASE ginfo^.kind OF
          buttonKind  : msgClass := IDCMPFlagSet{gadgetUp};
                        cardCode := 0;
        | stringKind,
          integerKind : IF IL.ActivateGadget(gadget, window, NIL) THEN END;
                       cardCode := 0;
                       msgClass := IDCMPFlagSet{gadgetDown};
        | checkboxKind:msgClass := IDCMPFlagSet{gadgetUp};
                       IF ginfo^.buffer # NIL THEN
                         ginfo^.bool^ := ~(ginfo^.bool^);
                       END;
                       ginfo^.v0B := ~ginfo^.v0B;
                       pointer := TAG(buffer, gtcbChecked, ginfo^.v0B, tagEnd);
                       GL.GTSetGadgetAttrsA(gadget, window, NIL, pointer);
                       charCode := 0C;
                       boolCode := ginfo^.v0B;
        | mxKind,
          cycleKind  : IF shift THEN
                         IF ginfo^.v0 = 0 THEN
                           ginfo^.v0 := ginfo^.v1-1;
                         ELSE
                           DEC(ginfo^.v0);
                         END;
                       ELSE
                         IF ginfo^.v0 = ginfo^.v1-1 THEN
                           ginfo^.v0 := 0;
                         ELSE
                           INC(ginfo^.v0);
                         END;
                       END;
                       IF ginfo^.card # NIL THEN
                         ginfo^.card^ := ginfo^.v0;
                       END;
                       cardCode := ginfo^.v0;
                       IF ginfo^.kind = mxKind THEN
                         msgClass := IDCMPFlagSet{gadgetDown};
                         pointer := TAG(buffer, gtmxActive, ginfo^.v0, tagEnd);
                       ELSE
                         msgClass := IDCMPFlagSet{gadgetUp};
                         pointer := TAG(buffer, gtcyActive, ginfo^.v0, tagEnd);
                       END;
                       GL.GTSetGadgetAttrsA(gadget, window, NIL, pointer);
        | sliderKind : msgClass := IDCMPFlagSet{gadgetUp};
                       IF    shift THEN
                         IF ginfo^.v0S > ginfo^.v2S  THEN
                           DEC(ginfo^.v0S);
                         END;
                       ELSIF ginfo^.v0S < ginfo^.v1S THEN
                         INC(ginfo^.v0S);
                       END;
                       IF ginfo^.int # NIL THEN
                         ginfo^.int^ := ginfo^.v0S;
                       END;
                       intCode := ginfo^.v0S;
                       pointer := TAG(buffer, gtslLevel, ginfo^.v0S, tagEnd);
                       GL.GTSetGadgetAttrsA(gadget, window, NIL, pointer);
        | paletteKind :msgClass := IDCMPFlagSet{gadgetUp};
                       IF    shift THEN
                         IF ginfo^.v0 > ginfo^.v2 THEN
                           DEC(ginfo^.v0);
                         END;
                       ELSIF ginfo^.v0 < ginfo^.v1-1 THEN
                         INC(ginfo^.v0);
                       END;
                       IF ginfo^.card # NIL THEN
                         ginfo^.card^ := ginfo^.v0;
                       END;
                       cardCode := ginfo^.v0;
                       pointer := TAG(buffer, gtpaColor, ginfo^.v0, tagEnd);
                       GL.GTSetGadgetAttrsA(gadget, window, NIL, pointer);
        | scrollerKind:msgClass := IDCMPFlagSet{gadgetUp};
                       IF    shift THEN
                         IF ginfo^.v0S > 0 THEN
                           DEC(ginfo^.v0S);
                         END;
                       ELSIF ginfo^.v0S < ginfo^.v2S THEN
                         INC(ginfo^.v0S);
                       END;
                       IF ginfo^.int # NIL THEN
                         ginfo^.int^ := ginfo^.v0S;
                       END;
                       intCode := ginfo^.v0S;
                       pointer := TAG(buffer, gtscTop, ginfo^.v0S, tagEnd);
                       GL.GTSetGadgetAttrsA(gadget, window, NIL, pointer);
        | listviewKind:msgClass := IDCMPFlagSet{gadgetUp};
                       IF ginfo^.v1 # lvNotSel THEN
                         IF shift THEN
                           IF    ginfo^.v0 = lvNotSel THEN
                             ginfo^.v0 := ginfo^.v1-1;
                           ELSIF ginfo^.v0 > 0 THEN
                             DEC(ginfo^.v0);
                           END;
                         ELSE
                           IF    ginfo^.v0 = lvNotSel THEN
                             ginfo^.v0 := 0;
                           ELSIF ginfo^.v0 < ginfo^.v1-1 THEN
                             INC(ginfo^.v0);
                           END;
                         END;
                         IF ginfo^.card # NIL THEN
                           ginfo^.card^ := ginfo^.v0;
                         END;
                         cardCode := ginfo^.v0;
                         pointer := TAG(buffer,
                                        gtlvSelected, ginfo^.v0,
                                        gtlvTop, ginfo^.v0, tagEnd);
                         GL.GTSetGadgetAttrsA(gadget, window, NIL, pointer);
                       ELSE
                         msgClass := IDCMPFlagSet{};
                         cardCode := lvNotSel;
                       END;
                       IF ginfo^.lvClearTime THEN
                         im.seconds := 0;
                         im.micros  := 0;
                       END;
        ELSE
        END;
        IF ginfo^.onlyIntern THEN msgClass := IDCMPFlagSet{} END;
        (* CreateGadget is responsible to set this flag only with gadgets
           which can really be processed internal ! *)
      END;
    END;
  END GadWithKey;

  PROCEDURE ConvKMsgToGMsg(gui : GUIInfoPtr);
  VAR nbr  : INTEGER;
      shift: INTEGER;
      key  : CHAR;
  BEGIN
    WITH gui^ DO
      IF vanillaKey IN msgClass THEN
        key := CHAR(im.code);
        nbr := ORD(UL.ToUpper(key)) - ORD('A');
        IF    (UL.ToUpper(key) >= 'A') AND (UL.ToUpper(key) <= 'Z') AND
              (keys[nbr] # noKeyEqu) THEN
          nbr := keys[nbr];
          GadWithKey(gui, nbr, key = UL.ToUpper(key));
        ELSIF (callVanillaKeyFct IN flags) AND (newVanKeyHook # NIL) AND
              (newVanKeyHook(key, ADR(nbr), ADR(shift),
                                             vanKeyFctData)) THEN
          GadWithKey(gui, nbr, shift # 0);
        END;
      END;
    END;
  END ConvKMsgToGMsg;

  PROCEDURE HandleIntMsg(gui : GUIInfoPtr);
  VAR ginfo : GUIGadgetInfoPtr;
      done  : BOOLEAN;
  BEGIN
    done := FALSE;
    WITH gui^ DO
      msgClass := im.class;
      cardCode := im.code;

      IF (gadgetUp IN msgClass) OR (gadgetDown IN msgClass) OR
         (mouseMove IN msgClass) THEN
        gadget := ADDRESS(im.iAddress);
        gadID  := gadget^.gadgetID;
        ginfo  := gadget^.userData; (* MUST BE # NIL  *)
        gadNbr := ginfo^.v3;
      END;

      IF    gadgetUp IN msgClass THEN
        CASE ginfo^.kind OF
        | integerKind : IF (ginfo^.lint # NIL) AND (autoUpdateEGads IN flags) THEN
                          ginfo^.lint^ := StringInfoPtr(gadget^.specialInfo)^.longInt;
                          done := TRUE;
                        END;
        | stringKind  : IF (ginfo^.string # NIL) AND (autoUpdateEGads IN flags) THEN
                          Copy(ginfo^.string^,
                               STRPTR(StringInfoPtr(gadget^.specialInfo)^.buffer)^);
                          done := TRUE;
                        END;
        | checkboxKind: ginfo^.v0B := ~ginfo^.v0B;
                        IF ginfo^.bool # NIL THEN
                          ginfo^.bool^ := ~(ginfo^.bool^);
                          done := TRUE;
                        END;
                        charCode := 0C;
                        boolCode := ginfo^.v0B;
        | sliderKind,
          scrollerKind : ginfo^.v0S := CAST(INTEGER, im.code);
                         IF ginfo^.int # NIL THEN
                           ginfo^.int^ := CAST(INTEGER, im.code);
                           done := TRUE;
                         END;
        | cycleKind,
          listviewKind,
          paletteKind  : ginfo^.v0  := im.code;
                         IF ginfo^.card # NIL THEN
                           ginfo^.card^ := im.code;
                           done := TRUE;
                         END;
        ELSE
        END;

        (* Activate the following entry gadget *)
        IF ((ginfo^.kind = integerKind) OR (ginfo^.kind = stringKind))
           AND (ginfo^.nextEGad # NIL) THEN
          IF im.code = 0 THEN  (* TAB wasn't used, then ...*)
            REPEAT
              IF ~(gadgDisabled IN ginfo^.nextEGad^.flags) THEN
                IF ginfo^.nextEGad # gadget THEN(* Is there only one ?*)
                  IF IL.ActivateGadget(ginfo^.nextEGad, window, NIL) THEN END;
                END;
                ginfo := NIL;
              ELSE
                ginfo := ginfo^.nextEGad^.userData;
              END;
            UNTIL ginfo = NIL;
            ginfo := gadget^.userData; (* restore ginfo *)
          END;
        END;

      ELSIF gadgetDown IN msgClass THEN
        CASE ginfo^.kind OF
        | mxKind       : ginfo^.v0 := im.code;
                         IF ginfo^.card # NIL THEN
                           ginfo^.card^ := im.code;
                           done := TRUE;
                         END;
        | sliderKind,
          scrollerKind : ginfo^.v0S := CAST(INTEGER, im.code);
                         IF ginfo^.int # NIL THEN
                           ginfo^.int^ := CAST(INTEGER, im.code);
                           done := TRUE;
                         END;
        ELSE
        END;

      ELSIF menuPick IN msgClass THEN
        IF im.code # menuNull THEN
          menuNum := MenuNum(im.code);
          itemNum := ItemNum(im.code);
          subNum  := SubNum(im.code);
          itemAdr := IL.ItemAddress(menus, im.code);
          IF callMenuData IN flags THEN
            IF (itemAdr # NIL) AND (MenuItemUserData(itemAdr) # NIL) THEN
              IF CAST(NewMenuFct, MenuItemUserData(itemAdr))(menuFctData) THEN
                msgClass := IDCMPFlagSet{};
              END;
            END;
          END;
        ELSE
          msgClass := IDCMPFlagSet{};
        END;

      ELSIF menuHelp IN msgClass THEN
        menuNum := MenuNum(im.code);
        itemNum := ItemNum(im.code);
        subNum  := SubNum(im.code);
        IF itemNum # noItem THEN
          itemAdr := IL.ItemAddress(menus, im.code);
        ELSE
          itemAdr := NIL;
        END;

      ELSIF mouseMove IN msgClass THEN
        CASE ginfo^.kind OF
        | sliderKind,
          scrollerKind : ginfo^.v0S := CAST(INTEGER, im.code);
                         IF ginfo^.int # NIL THEN
                           ginfo^.int^ := CAST(INTEGER, im.code);
                           done := TRUE;
                         END;
        ELSE
        END;

      ELSIF (vanillaKey IN msgClass) AND (convertKeys IN flags) THEN
        ConvKMsgToGMsg(gui);

      ELSIF (refreshWindow IN msgClass) AND (doRefresh IN flags) THEN
        BeginRefresh(gui);
        EndRefresh(gui, TRUE);
        msgClass := IDCMPFlagSet{};

      ELSIF (newSize IN msgClass) AND (doResizing IN flags) THEN
        DoResizing(gui);
        IF RedrawGadgets(gui, TRUE) = guiSet THEN msgClass := IDCMPFlagSet{} END;
      END;
      IF done AND ginfo^.onlyIntern THEN msgClass := IDCMPFlagSet{} END;
    END;
  END HandleIntMsg;

  PROCEDURE WaitIntMsg(gui : GUIInfoPtr);
  VAR done : BOOLEAN;
  BEGIN
    REPEAT
      done := GetIntMsg(gui);
      IF ~done AND
         ~((menuPick IN gui^.im.class) AND (gui^.im.code # menuNull)) THEN
        WaitPort(gui^.port);
      END;
    UNTIL done;
  END WaitIntMsg;

  PROCEDURE GetIntMsg(gui : GUIInfoPtr) : BOOLEAN;
  VAR intmsg : IntuiMessagePtr;
  BEGIN
    IF (menuPick IN gui^.im.class) AND (gui^.im.code # menuNull) THEN
      gui^.im.code := IL.ItemAddress(gui^.menus, gui^.im.code)^.nextSelect;
    ELSE
      gui^.im.code := menuNull;
    END;
    IF gui^.im.code = menuNull THEN
      intmsg := GL.GTGetIMsg(gui^.port);
      IF intmsg = NIL THEN RETURN FALSE END;
      gui^.im := intmsg^;
      GL.GTReplyIMsg(intmsg);
    END;
    IF ~(noHandleIntMsgCall IN gui^.flags) THEN HandleIntMsg(gui) END;
    IF gui^.msgClass = IDCMPFlagSet{} THEN RETURN FALSE END;
    RETURN TRUE;
  END GetIntMsg;

  PROCEDURE EmptyIntMsgPort(gui : GUIInfoPtr);
  VAR intmsg : IntuiMessagePtr;
  BEGIN
    Forbid;   (* no more messages *)
      REPEAT
        intmsg := GL.GTGetIMsg(gui^.port);
        IF intmsg # NIL THEN GL.GTReplyIMsg(intmsg) END;
      UNTIL intmsg = NIL;
    Permit;
  END EmptyIntMsgPort;

  PROCEDURE GadgetStatus(gui : GUIInfoPtr; nbr : INTEGER; status : BOOLEAN);
  VAR Gadget : GadgetPtr;
      buffer : ARRAY[0..1] OF TagItem;
  BEGIN
    Gadget := gui^.gadgets^[nbr];
    IF CAST(GUIGadgetInfoPtr, Gadget^.userData)^.kind = genericKind THEN
      IF status THEN
        IL.OnGadget(Gadget, gui^.window, NIL);
      ELSE
        IL.OffGadget(Gadget,gui^.window, NIL);
      END;
    ELSIF CAST(GUIGadgetInfoPtr, Gadget^.userData)^.kind <= guiToolsKinds THEN
      GL.GTSetGadgetAttrsA(Gadget, gui^.window, NIL,
                          TAG(buffer, gaDisabled, ~status, tagEnd));
    END;
    CAST(GUIGadgetInfoPtr, Gadget^.userData)^.gadActive := status;
  END GadgetStatus;

  PROCEDURE ModifyGadget(gui : GUIInfoPtr; nbr : INTEGER; tags : TagItemPtr);
  VAR Gadget : GadgetPtr;
      ginfo  : GUIGadgetInfoPtr;
  BEGIN
    WITH gui^ DO
      Gadget := gadgets^[nbr];
      ginfo  := Gadget^.userData;
      ScanGadget(gui, ginfo, tags, FALSE); (* Scan for parameters *)
      IF rememberGadTags IN status THEN
        RememberTags(ginfo, tags);
      END;
      IF ginfo^.kind > guiToolsKinds THEN
        INCL(status, spezialGadsNoText);
        DrawGadget(gui, Gadget, ginfo);
        EXCL(status, spezialGadsNoText);
      ELSE
        GL.GTSetGadgetAttrsA(Gadget, window, NIL, tags);
      END;
    END;
  END ModifyGadget;

  PROCEDURE UpdateEGad(gui : GUIInfoPtr; nbr : INTEGER);
  VAR gadg  : GadgetPtr;
      ginfo : GUIGadgetInfoPtr;
  BEGIN
    WITH gui^ DO
      gadg := gadgets^[nbr];
      ginfo := gadg^.userData;
      IF ginfo^.buffer # NIL THEN
        IF ginfo^.kind = integerKind THEN
          ginfo^.lint^ := StringInfoPtr(gadg^.specialInfo)^.longInt;
        ELSIF ginfo^.kind = stringKind THEN
          Copy(ginfo^.string^,
               STRPTR(StringInfoPtr(gadg^.specialInfo)^.buffer)^);
        END;
      END;
    END;
  END UpdateEGad;

  PROCEDURE UpdateEntryGadgets(gui : GUIInfoPtr);
  VAR i : INTEGER;
  BEGIN
    FOR i := 0 TO gui^.actgad-1 DO   UpdateEGad(gui, i)   END;
  END UpdateEntryGadgets;

  PROCEDURE VarToGad(gui : GUIInfoPtr; nbr : INTEGER);
  VAR ginfo  : GUIGadgetInfoPtr;
      tagbuf : ARRAY[0..2] OF TagItem;
  BEGIN
    ginfo := gui^.gadgets^[nbr]^.userData;
    IF ginfo^.buffer # NIL THEN
      CASE ginfo^.kind OF
        stringKind   : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtstString, ginfo^.string, tagEnd));
      | integerKind  : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtinNumber, ginfo^.lint^, tagEnd));
      | checkboxKind : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtcbChecked, ginfo^.bool^,tagEnd));
      | cycleKind    : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtcyActive, ginfo^.card^, tagEnd));
      | mxKind       : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtmxActive, ginfo^.card^, tagEnd));
      | sliderKind   : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtslLevel, ginfo^.int^, tagEnd));
      | scrollerKind : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtscTop, ginfo^.int^, tagEnd));
      | listviewKind : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtlvSelected, ginfo^.card^, tagEnd));
      | paletteKind  : ModifyGadget(gui, nbr, TAG(tagbuf,
                                    gtpaColor, ginfo^.card^, tagEnd));
      ELSE
      END;
    END;
  END VarToGad;

  PROCEDURE AllVarsToGad(gui : GUIInfoPtr);
  VAR i : INTEGER;
  BEGIN
    FOR i := 0 TO gui^.actgad-1 DO  VarToGad(gui, i)  END;
  END AllVarsToGad;

  PROCEDURE TopazAttr():TextAttrPtr;
  BEGIN
    RETURN ADR(TextAttr{name: ADR('topaz.font'), ySize: 8});
  END TopazAttr;

  PROCEDURE GetOwnFont(name : ADDRESS; size : CARDINAL;
                       font : TextAttrPtr) : TextFontPtr;
  VAR NewFont : TextFontPtr;
      OwnAttr : TextAttr;
  BEGIN
    IF font = NIL THEN font := ADR(OwnAttr) END;
    font^.name := name;
    WITH font^ DO
      ySize := size;
      style := FontStyleSet{};
      flags := FontFlagSet{romFont};
    END;
    NewFont := OpenFont(font);
    IF NewFont = NIL THEN
      font^.flags := FontFlagSet{diskFont};
      NewFont := OpenDiskFont(font);
    END;
    RETURN NewFont;
  END GetOwnFont;

  PROCEDURE RemOwnFont(font : TextFontPtr);
  BEGIN
    IF font # NIL THEN CloseFont(font) END;
  END RemOwnFont;

  PROCEDURE DoubleTags(tag1, tag2 : TagItemPtr);
  VAR tag : TagItemPtr;
      next: TagItemPtr;
  BEGIN
    next := UL.NextTagItem(tag1);
    WHILE next # NIL DO
      tag := UL.FindTagItem(next^.tag, tag2);
      IF tag # NIL THEN next^.tag := tagIgnore  END;
      next := UL.NextTagItem(tag1);
    END;
  END DoubleTags;

  PROCEDURE OpenIntWindowTags(left, top, width, height : INTEGER;
                          name: ADDRESS; idcmpFlags: IDCMPFlagSet;
                          windowFlags : WindowFlagSet;
                          screen : ScreenPtr;
                          tags : TagItemPtr):WindowPtr;
  VAR buffer : ARRAY[0..11] OF TagItem;
      pubscr : ScreenPtr;
      window : WindowPtr;
  BEGIN
    window := NIL;
    IF screen = NIL THEN
      pubscr := IL.LockPubScreen(NIL);
      screen := pubscr;
    ELSE
      pubscr := NIL;
    END;
    IF width  = asScreen THEN width  := screen^.width-left  END;
    IF height = asScreen THEN height := screen^.height-top  END;
    IF (pubscr # NIL) OR (publicScreen IN screen^.flags) THEN
      IF TAG(buffer, waTitle, name,
                     waLeft, left,
                     waTop, top,
                     waWidth, width,
                     waHeight, height,
                     waIDCMP, idcmpFlags,
                     waFlags, windowFlags,
                     waPubScreen, screen,
                     waPubScreenFallBack, TRUE,
                     tagMore, tags, tagEnd) # NIL THEN
        buffer[9].tag := tagEnd;
        IF tags # NIL THEN
          DoubleTags(ADR(buffer), tags);
          buffer[9].tag := tagMore;
        END;
      END;
    ELSE
      IF TAG(buffer, waTitle, name,
                     waLeft, left,
                     waTop, top,
                     waWidth, width,
                     waHeight, height,
                     waIDCMP, idcmpFlags,
                     waFlags, windowFlags,
                     waCustomScreen, screen,
                     tagMore, tags, tagEnd) # NIL THEN
        buffer[8].tag := tagEnd;
        IF tags # NIL THEN
          DoubleTags(ADR(buffer), tags);
          buffer[8].tag := tagMore;
        END;
      END;
    END;
    window := IL.OpenWindowTagList(NIL, ADR(buffer));
    IF pubscr # NIL THEN IL.UnlockPubScreen(NIL, pubscr) END;
    RETURN window;
  END OpenIntWindowTags;

  PROCEDURE OpenIntWindow(left, top, width, height : INTEGER;
                          name: ADDRESS;
                          idcmpFlags: IDCMPFlagSet;
                          windowFlags : WindowFlagSet;
                          screen : ScreenPtr):WindowPtr;
  VAR tags : ARRAY[0..1] OF TagItem;
  BEGIN
    RETURN OpenIntWindowTags(left, top, width, height, name,
                             idcmpFlags, windowFlags, screen,
                             TAG(tags, waScreenTitle, name, tagEnd));
  END OpenIntWindow;

  PROCEDURE CloseIntWindow(window : WindowPtr);
  VAR intmsg : IntuiMessagePtr;
      list   : GUIWindowInfoPtr;
      next   : GUIWindowInfoPtr;
  BEGIN
    IF window # NIL THEN
      IF window^.userPort # NIL THEN
        Forbid;   (* no more messages ! *)
          REPEAT
            intmsg := GL.GTGetIMsg(window^.userPort);
            IF intmsg # NIL THEN GL.GTReplyIMsg(intmsg) END;
          UNTIL intmsg = NIL;
          IL.ModifyIDCMP(window, IDCMPFlagSet{});
        Permit;
      END;
      (* Does the GUI still exist ? , handles more than one GUI/Window !*)
      Forbid;
        list := allWindowsWithGUI;
        WHILE list # NIL DO
          IF list^.window = window THEN
            next := list^.next;
            FreeGUIInfo(list^.gui); (* list isn't valid anymore ! *)
            list := next;
          ELSE
            list := list^.next;
          END;
        END;
      Permit;
      IL.CloseWindow(window);
    END;
  END CloseIntWindow;

  PROCEDURE OpenIntScreenTags(id:LONGCARD; depth:INTEGER;
                          name : ADDRESS;
                          font : TextAttrPtr;
                          tags : TagItemPtr) : ScreenPtr;
  VAR tagBuffer : ARRAY[0..7] OF TagItem;
  BEGIN
    IF TAG(tagBuffer, saPens, ADR(CARDINAL{0FFFFH}),
                      saDepth, depth,
                      saDisplayID, id,
                      saTitle, name,
                      saFont, font,
                      tagMore, tags, tagEnd) # NIL THEN
      tagBuffer[5]. tag := tagEnd;
      IF tags # NIL THEN
        DoubleTags(ADR(tagBuffer), tags);
        tagBuffer[5].tag := tagMore;
      END;
      RETURN IL.OpenScreenTagList(NIL, ADR(tagBuffer));
    ELSE
      RETURN NIL;
    END;
  END OpenIntScreenTags;

  PROCEDURE OpenIntScreen(id:LONGCARD; depth:INTEGER;
                           name : ADDRESS; font : TextAttrPtr) : ScreenPtr;
  BEGIN
    RETURN OpenIntScreenTags(id, depth, name, font, NIL);
  END OpenIntScreen;

  PROCEDURE CloseIntScreen(screen : ScreenPtr);
  BEGIN
    IF screen # NIL THEN
      Forbid;
        WHILE screen^.firstWindow # NIL DO
          CloseIntWindow(screen^.firstWindow);
        END;
        IL.CloseScreen(screen);
      Permit;
    END;
  END CloseIntScreen;

  PROCEDURE DrawBox(gui : GUIInfoPtr; left, top, width, height : INTEGER;
                    recessed : BOOLEAN);
  VAR tagbuf : ARRAY[0..2] OF TagItem;
  BEGIN
    IF ~recessed THEN
      GL.DrawBevelBoxA(gui^.window^.rPort, left, top, width, height,
                      TAG(tagbuf, gtVisualInfo, gui^.visual, tagEnd));
    ELSE
      GL.DrawBevelBoxA(gui^.window^.rPort, left, top, width, height,
                      TAG(tagbuf, gtVisualInfo, gui^.visual,
                                  gtbbRecessed, TRUE, tagEnd));
    END;
  END DrawBox;

  PROCEDURE RedrawGadgets(gui : GUIInfoPtr; setGads:BOOLEAN) : INTEGER;
  VAR ginfo : GUIGadgetInfoPtr;
      firstEGadNbr, i : INTEGER;
      tagbuf : ARRAY[0..3] OF TagItem;
      myTag  : TagItem;
      next   : TagItemPtr;
      str    : STRPTR;
  BEGIN
    myTag.data := 0;
    myTag.tag := tagEnd;
    IF (rememberGadTags IN gui^.status) AND
       (gui^.gadlist # NIL) THEN  (* are there any gadgets *)

      IF gui^.firstEGad # NIL THEN
        firstEGadNbr := CAST(GUIGadgetInfoPtr, gui^.firstEGad^.userData)^.v3;
      END;

      (* remember entry gadgets contents *)
      FOR i := 0 TO gui^.actgad-1 DO
        gui^.gadget := gui^.gadgets^[i];
        ginfo := gui^.gadget^.userData;
        IF    ginfo^.kind = stringKind  THEN
          str := STRPTR(StringInfoPtr(gui^.gadget^.specialInfo)^.buffer);
          IF str # NIL THEN
            ginfo^.v2 := StringInfoPtr(gui^.gadget^.specialInfo)^.numChars+1;
            IF ginfo^.v2 > 1 THEN
              ginfo^.v0L := CAST(LONGCARD, AllocMem(ginfo^.v2, MemReqSet{memClear}));
              IF ginfo^.v0L # 0 THEN
                Copy(CAST(STRPTR, ginfo^.v0L)^, str^);
              END;
            ELSE
              ginfo^.v2 := 0;
              ginfo^.v0L:= 0;
            END;
          ELSE
            ginfo^.v2 := 0;
            ginfo^.v0L:= 0;
          END;
        ELSIF ginfo^.kind = integerKind THEN
          ginfo^.v0I := StringInfoPtr(gui^.gadget^.specialInfo)^.longInt;
        END;
      END;

      (* Remove old gadgets *)
      IF IL.RemoveGList(gui^.window, gui^.gadlist, -1) = 0 THEN END;
      GL.FreeGadgets(gui^.gadlist);

      (* Clear window contents *)
      ClearWindow(gui);

      (* create new gadget list *)
      gui^.gadlist := NIL;
      gui^.gad := GL.CreateContext(gui^.gadlist);
      EXCL(gui^.status, gadgetsSet);
      IF gui^.gadlist # NIL THEN

        gui^.actgad := 0;
        ginfo := gui^.firstInfo;
        WHILE ginfo # NIL DO

          IF ginfo^.nbrTags = 0 THEN
            ginfo^.tagsC := ADR(myTag);
            ginfo^.impTags := ADR(myTag);
          END;
          ginfo^.impTags^.tag := tagMore;
          CASE ginfo^.kind OF
          | stringKind : next := UL.FindTagItem(Tag(gtstString), ginfo^.tagsC);
                         IF next # NIL THEN
                           next^.data := ginfo^.v0L;
                         ELSE
                           ginfo^.impTags^.data := TAG(tagbuf,
                                              gtstString, ginfo^.v0L, tagEnd);
                         END;
          | integerKind: next := UL.FindTagItem(Tag(gtinNumber), ginfo^.tagsC);
                         IF next # NIL THEN
                           next^.lidata := ginfo^.v0I;
                         ELSE
                           ginfo^.impTags^.data := TAG(tagbuf,
                                              gtinNumber, ginfo^.v0I, tagEnd);
                         END;
          | mxKind : ginfo^.impTags^.data := TAG(tagbuf,
                                                 gtmxActive, ginfo^.v0, tagEnd);
          | checkboxKind : ginfo^.impTags^.data := TAG(tagbuf,
                                           gtcbChecked, ginfo^.v0B, tagEnd);
          | cycleKind : ginfo^.impTags^.data := TAG(tagbuf,
                                          gtcyActive, ginfo^.v0, tagEnd);
          | sliderKind: ginfo^.impTags^.data := TAG(tagbuf,
                                              gtslMin, ginfo^.v2S,
                                              gtslMax, ginfo^.v1S,
                                              gtslLevel, ginfo^.v0S, tagEnd);
          | scrollerKind:ginfo^.impTags^.data := TAG(tagbuf,
                                              gtscTop, ginfo^.v0S,
                                              gtscVisible, ginfo^.v1S,
                                              gtscTotal, ginfo^.v2S, tagEnd);
          | listviewKind:ginfo^.impTags^.data := TAG(tagbuf,
                                              gtlvSelected, ginfo^.v0,tagEnd);
                         IF ginfo^.v2S # -1 THEN
                           next := UL.FindTagItem(Tag(gtlvShowSelected),
                                                  ginfo^.tagsC);
                           IF next # NIL THEN
                             next^.data := CAST(LONGCARD,
                                                gui^.gadgets^[ginfo^.v2S]);
                           END;
                         END;
          | paletteKind :ginfo^.impTags^.data := TAG(tagbuf,
                                              gtpaColorOffset, ginfo^.v2,
                                              gtpaColor, ginfo^.v0, tagEnd);
          ELSE
            ginfo^.impTags^.tag := tagEnd;
          END;

          IF ginfo^.kind > guiToolsKinds THEN
            WITH gui^.gadgets^[gui^.actgad]^ DO
              leftEdge := ginfo^.gadDesc.leftEdge;
              topEdge  := ginfo^.gadDesc.topEdge;
              width    := ginfo^.gadDesc.width;
              height   := ginfo^.gadDesc.height;
              gadgetText^.iText := ginfo^.gadDesc.gadgetText;
              gadgetText^.iTextFont := ginfo^.gadDesc.textAttr;
            END;
            CalcText(gui, gui^.gadgets^[gui^.actgad]);
            IF setGads THEN
              DrawGadget(gui, gui^.gadgets^[gui^.actgad], ginfo);
            END;
          ELSE
            gui^.gad := GL.CreateGadgetA(ginfo^.kind, gui^.gad^,
                                        ginfo^.gadDesc, ginfo^.tagsC);
            IF gui^.gad # NIL THEN   (* GUIGadgetInfo into userData entry !*)
              gui^.gadgets^[gui^.actgad] := gui^.gad;
            ELSE
              ginfo := NIL;
            END;
          END;
          IF ginfo # NIL THEN
            gui^.gadgets^[gui^.actgad]^.userData := ginfo;
            INC(gui^.actgad);
            IF ginfo^.nbrTags = 0 THEN
              ginfo^.tagsC   := NIL;
              ginfo^.impTags := NIL;
            END;
            ginfo := ginfo^.nextGadInfo;
          END;

        END;

        IF gui^.gad # NIL THEN

          IF gui^.firstEGad # NIL THEN
            (* Chain entry gadgets again *)
            gui^.firstEGad := gui^.gadgets^[firstEGadNbr];

            ginfo := gui^.firstEGad^.userData;
            WHILE ginfo # NIL DO
              IF ginfo^.nextEGad # NIL THEN
                IF ginfo^.nextEGadNbr = CAST(GUIGadgetInfoPtr,
                                             gui^.firstEGad^.userData)^.v3S THEN
                  ginfo^.nextEGad := gui^.firstEGad;
                  ginfo := NIL;
                ELSE
                  ginfo^.nextEGad := gui^.gadgets^[ginfo^.nextEGadNbr];
                  ginfo := ginfo^.nextEGad^.userData;
                END;
              ELSE
                ginfo := NIL;
              END;
            END;
          END;
          IF setGads THEN
            IF IL.AddGList(gui^.window, gui^.gadlist, -1, -1, NIL) = 0 THEN END;
            IL.RefreshGList(gui^.gadlist, gui^.window, NIL, -1);
            GL.GTRefreshWindow(gui^.window, NIL);
            FOR i := 0 TO gui^.actgad-1 DO
              IF ~(CAST(GUIGadgetInfoPtr,
                        gui^.gadgets^[i]^.userData)^.gadActive) THEN
                GadgetStatus(gui, i, FALSE);
              END;
            END;
            IF activateFirstEGad IN gui^.flags THEN
              IF IL.ActivateGadget(gui^.firstEGad, gui^.window, NIL) THEN END;
            END;
            INCL(gui^.status, gadgetsSet);
          ELSE
            INCL(gui^.status, redrawGads);
          END;

          (* delete the remember stucture for the entry gadgets contents *)
          FOR i := 0 TO gui^.actgad-1 DO
            gui^.gadget := gui^.gadgets^[i];
            ginfo := gui^.gadget^.userData;
            IF    ginfo^.kind = stringKind  THEN
              IF (ginfo^.v0L # 0) AND (ginfo^.v2 # 0) THEN
                FreeMem(CAST(ADDRESS, ginfo^.v0L), ginfo^.v2);
              END;
              ginfo^.v0L := 0;
              ginfo^.v2  := 0;
            ELSIF ginfo^.kind = integerKind THEN
              ginfo^.v0I := 0;
            END;
          END;

        ELSE
          SetGUIError(gui, gadgetError);
        END;

      ELSE
        SetGUIError(gui, rdGUIContextError);
      END;

    END;
    RETURN gui^.firstError;
  END RedrawGadgets;

  PROCEDURE RedrawMenu(gui : GUIInfoPtr) : INTEGER;
  VAR buffer : ARRAY[0..1] OF TagItem;
  BEGIN
    IF (menuSet IN gui^.status) THEN
      IL.ClearMenuStrip(gui^.window);
      GL.FreeMenus(gui^.menus);
      EXCL(gui^.status, menuSet);
      gui^.menus := GL.CreateMenusA(ADDRESS(gui^.newMenus), NIL);
      IF gui^.menus # NIL THEN
        IF GL.LayoutMenusA(gui^.menus, gui^.visual, TAG(buffer,
                            gtmnTextAttr, ADR(gui^.font), tagEnd)) THEN

          IF IL.SetMenuStrip(gui^.window, gui^.menus) THEN
            INCL(gui^.status, menuSet);
          ELSE
            SetGUIError(gui, menuSetError);
            GL.FreeMenus(gui^.menus);
            gui^.menus := NIL;
          END;
        ELSE
          SetGUIError(gui, menuLayoutError);
          GL.FreeMenus(gui^.menus);
          gui^.menus := NIL;
        END;
      ELSE
        SetGUIError(gui, menuError);
      END;
    END;
    RETURN gui^.firstError;
  END RedrawMenu;

  PROCEDURE ResizeGadget(gui : GUIInfoPtr;
                         nbr : INTEGER;
                         left, top, width, height : INTEGER);
  BEGIN
    gui^.gadget := gui^.gadgets^[nbr];
    WITH CAST(GUIGadgetInfoPtr, gui^.gadget^.userData)^ DO
      IF addBorderDims IN gui^.flags THEN
        IF left # preserve THEN INC(left, gui^.window^.borderLeft)  END;
        IF top  # preserve THEN INC(top, gui^.window^.borderTop)    END;
      END;
      IF left   # preserve THEN gadDesc.leftEdge := left   END;
      IF top    # preserve THEN gadDesc.topEdge  := top    END;
      IF width  # preserve THEN gadDesc.width    := width  END;
      IF height # preserve THEN gadDesc.height   := height END;
    END;
  END ResizeGadget;

  PROCEDURE NewGadgetFont(gui  : GUIInfoPtr;
                          nbr  : INTEGER;
                          font : TextAttrPtr);
  BEGIN
    WITH CAST(GUIGadgetInfoPtr, gui^.gadgets^[nbr]^.userData)^ DO
      gadDesc.textAttr := font;
    END;
  END NewGadgetFont;

  PROCEDURE NewGadgetText(gui  : GUIInfoPtr;
                          nbr  : INTEGER;
                          text : ADDRESS);
  BEGIN
    WITH CAST(GUIGadgetInfoPtr, gui^.gadgets^[nbr]^.userData)^ DO
      gadDesc.gadgetText := text;
    END;
  END NewGadgetText;

  PROCEDURE RemoveGadgets(gui : GUIInfoPtr; erase : BOOLEAN);
  VAR ginfo : GUIGadgetInfoPtr;
      ggad  : GadgetPtr;
      i     : INTEGER;
  BEGIN
    WITH gui^ DO

      IF (gadlist # NIL) AND (gadgetsSet IN status) THEN
        IF IL.RemoveGList(window, gadlist, -1) = 0 THEN END;
      END;

      IF erase THEN
        WHILE firstInfo # NIL DO    (* free info structures *)
          ginfo := firstInfo;
          firstInfo := firstInfo^.nextGadInfo;
          IF (ginfo^.kind = stringKind) AND (ginfo^.v0L # 0) AND (ginfo^.v2 # 0) THEN
            FreeMem(CAST(ADDRESS, ginfo^.v0L), ginfo^.v2);
          END;
          IF (ginfo^.tagsC # NIL) AND (ginfo^.nbrTags > 0) THEN
            FreeMem(ginfo^.tagsC, SIZE(TagItem) * ginfo^.nbrTags);
          END;
          FreeMem(ginfo, SIZE(GUIGadgetInfo));
        END;
        WHILE spezialGad # NIL DO  (* free guitools gadgets *)
          ggad := spezialGad;
          spezialGad := spezialGad^.nextGadget;
          FreeMem(ggad, SPEZIALGADSIZE);
        END;
        IF gadlist # NIL THEN GL.FreeGadgets(gadlist) END;
        gui^.gad := GL.CreateContext(gui^.gadlist);
        IF gadlist = NIL THEN SetGUIError(gui, gadgetError) END;
        newgad.gadgetText := NIL;
        newgad.gadgetID   := 0;
        newgad.flags      := NewGadgetFlagSet{};
        actgad  := 0;
        firstEGad := NIL;
        lastEGad  := NIL;
        FOR i := 0 TO 25 DO
          keys[i] := noKeyEqu;
        END;
      END;
      EXCL(status, gadgetsSet);
    END;
  END RemoveGadgets;

  PROCEDURE RemoveMenu(gui : GUIInfoPtr; erase : BOOLEAN);
  BEGIN
    WITH gui^ DO
      IF (menuSet IN status) AND (menus # NIL) THEN
        IL.ClearMenuStrip(window);
      END;
      IF menus # NIL THEN
        GL.FreeMenus(menus);
        menus := NIL;
      END;
      IF erase THEN
        actmenu := 0;
        newMenus^[0].type := nmEnd;
      END;
      EXCL(status, menuSet);
      im.class := IDCMPFlagSet{};  (* To avoid any problems with multi-
                                      menu selection and removing the
                                      menu in the meantime ! *)
    END;
  END RemoveMenu;

  PROCEDURE NewFontAllGadgets(gui : GUIInfoPtr;
                              font: TextAttrPtr);
  VAR i : INTEGER;
  BEGIN
    FOR i := 0 TO gui^.actgad-1 DO
      CAST(GUIGadgetInfoPtr,
           gui^.gadgets^[i]^.userData)^.gadDesc.textAttr := font;
    END;
  END NewFontAllGadgets;

  PROCEDURE ClearWindow(gui : GUIInfoPtr);
  VAR oldPen : INTEGER;
  BEGIN
    WITH gui^.window^ DO
      oldPen := rPort^.fgPen;
      SetAPen(rPort, rPort^.bgPen);
      RectFill(rPort, borderLeft, borderTop+2, width-borderRight-1,
               height-borderBottom-1);
      SetAPen(rPort, oldPen);
    END;
  END ClearWindow;

  PROCEDURE CreateSpecialGadget(gui : GUIInfoPtr;
                                left   : INTEGER;
                                top    : INTEGER;
                                width  : INTEGER;
                                height : INTEGER;
                                kind   : LONGCARD;
                                tags   : TagItemPtr);
  TYPE CHARARR4 = ARRAY[0..3] OF CHAR;
  VAR next     : TagItemPtr;
      ginfo    : GUIGadgetInfoPtr;
      text     : IntuiTextPtr;
      oldtags  : TagItemPtr;
      buffer   : ARRAY[0..5] OF LONGCARD;
      pointer : LONGCARD;
      descrip : LONGCARD;
      gadobjects  : LONGCARD;
      keyPos  : INTEGER;
      key     : ARRAY[0..1] OF CHAR;
  BEGIN
    WITH gui^ DO

      descrip := 0;
      IF actgad > 0 THEN
        gadobjects := (actgad-1)*(256*256*256+256*256+257);
      ELSE
        gadobjects := 0;
      END;
      (* gadget kind OK ? *)
      IF    (kind > guiToolsKinds) AND (kind # progressIndicatorKind) AND
            (kind # bevelboxKind) THEN
        SetGUIError(gui, noGUIToolsGadKind);
        RETURN;
      ELSIF (kind >= numKinds) AND (kind <= guiToolsKinds) AND
            (GL.gadtoolsBase^.version <= 39) THEN
        SetGUIError(gui, noGadToolsGadKind);
        RETURN;
      END;

      (* gadget creation possible, was there no error before ? *)
      IF (actgad >= maxgads) OR (gadgetsSet IN status) OR (gad = NIL) THEN
        SetGUIError(gui, tooManyGadsError);
        RETURN;
      END;

      (*Check for standard sizes *)
      IF    kind = checkboxKind THEN
        IF width  = 0 THEN width  := checkboxWidth  END;
        IF height = 0 THEN height := checkboxHeight END;
      ELSIF kind = mxKind THEN
        IF width  = 0 THEN width  := mxWidth  END;
        IF height = 0 THEN height := mxHeight END;
      ELSIF (kind = stringKind) OR (kind = integerKind) THEN
        IF height = 0 THEN height := newgad.textAttr^.ySize + 4  END;
      END;
      IF (~(useGadDesc IN status)) AND (addBorderDims IN flags) THEN
        INC(left, window^.borderLeft);
        INC(top, window^.borderTop);
      END;
      newgad.leftEdge := left;
      newgad.topEdge  := top;
      newgad.width    := width;
      newgad.height   := height;

      IF addStdUnderscore IN flags THEN  (* gtUnderscore-Tag *)
        IF tags = NIL THEN
          tags := TAG(buffer, gtUnderscore, '_', tagEnd, NIL, NIL);
        ELSE
          tags := TAG(buffer, gtUnderscore, '_', tagMore, tags, NIL);
        END;
      END;

      tagmem := UL.CloneTagItems(tags);     (* copy tag list *)
      tags   := tagmem;  (* Nur noch Kopie benutzen *)
      oldtags := tags;          (* Scan tag list: Text / Flags *)
      IF tags # NIL THEN
        next := UL.NextTagItem(oldtags);
        WHILE next # NIL DO
          CASE next^.tag OF
            Tag(sgGadgetText) : newgad.gadgetText := ADDRESS(next^.data);
          | Tag(sgGadgetFlags): newgad.flags := CAST(NewGadgetFlagSet, next^.data);
          | Tag(sgGadgetFont) : newgad.textAttr := ADDRESS(next^.data);
          | Tag(sgGadgetID)   : newgad.gadgetID := INTEGER(next^.lidata);
          | Tag(sgVisualInfo) : newgad.visualInfo := ADDRESS(next^.data);
          | Tag(sgUserData)   : newgad.userData   := ADDRESS(next^.data);
          | Tag(sgGadgetDesc) : descrip := next^.data;
          | Tag(sgGadgetObjects) : gadobjects := next^.data;
          ELSE
          END;
          next := UL.NextTagItem(oldtags);
        END;
      END;

      ginfo := AllocMem(SIZE(GUIGadgetInfo), MemReqSet{memClear});
      IF ginfo = NIL THEN
        SetGUIError(gui, memError);
        RETURN;
      END;
      (* remember pointer to first gadget *)
      IF firstInfo = NIL THEN
        firstInfo := ginfo;
      ELSE (* chain all other gadgets *)
        CAST(GUIGadgetInfoPtr,
             gadgets^[actgad-1]^.userData)^.nextGadInfo := ginfo;
      END;

      ginfo^.kind := kind;
      ginfo^.v3 := actgad;
      ginfo^.userData := newgad.userData;
      ginfo^.description := CAST(DISTFIELD, descrip);
      ginfo^.gadfield    := CAST(GADOFIELD, gadobjects);
      ginfo^.leftC  := newgad.leftEdge;
      ginfo^.topC   := newgad.topEdge;
      ginfo^.widthC := newgad.width;
      ginfo^.heightC:= newgad.height;

      IF useGadDesc IN status THEN ConvGadDesc(gui, ginfo, newgad) END;

      (* remember gadget description *)
      ginfo^.gadDesc := newgad;
    END;

    (* ------------------ GUITools-Gadgets ---------------------------- *)
    IF (kind = progressIndicatorKind) OR (kind = bevelboxKind) THEN

      WITH gui^ DO
        gadget := AllocMem(SPEZIALGADSIZE, MemReqSet{memClear});
        IF gadget = NIL THEN
          SetGUIError(gui, memError);
          RETURN;
        END;

        ScanGadget(gui, ginfo, tags, TRUE);

        ginfo^.onlyIntern := TRUE;
        gadget^.userData := ginfo;

        text := ADDRESS(gadget);
        INC(text, SIZE(Gadget));

        (* remember pointer to guitools gadgets *)
        gadget^.nextGadget := spezialGad;
        spezialGad := gadget;

        gadget^.gadgetText := text;
        text^.iText := newgad.gadgetText;
        text^.iTextFont := newgad.textAttr;
        gadget^.specialInfo  := CAST(ADDRESS, newgad.flags);
        gadget^.leftEdge := newgad.leftEdge;
        gadget^.topEdge  := newgad.topEdge;
        gadget^.width    := newgad.width;
        gadget^.height   := newgad.height;
        gadget^.gadgetID := newgad.gadgetID;

        CalcText(gui, gadget);
      END;


    (* ------------------ GadTools-Gadget ------------------------------ *)
    ELSE

      WITH gui^ DO
        IF UL.FilterTagItems(tags, ADR(NOGADTOOLSTAGS), tagFilterNOT) = 0 THEN
          tags := NIL;
        END;
        next := NIL;          (* correct TAG list for notify *)
        IF    (kind = stringKind)  AND (stringNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtstString), tags);
          IF next # NIL THEN pointer := next^.data END;
          (* With strings only search, NO CHANGE *)
        ELSIF (kind = integerKind) AND (integerNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtinNumber), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.data := LONGCARD(LINTPTR(next^.data)^);
          END;
        ELSIF (kind = checkboxKind) AND (checkboxNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtcbChecked), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.data := LONGCARD(BOOLPTR(next^.data)^);
          END;
        ELSIF (kind = mxKind) AND (mxNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtmxActive), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.data := LONGCARD(CARDPTR(next^.data)^);
          END;
        ELSIF (kind = cycleKind) AND (cycleNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtcyActive), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.data := LONGCARD(CARDPTR(next^.data)^);
          END;
        ELSIF (kind = sliderKind) AND (sliderNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtslLevel), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.lidata := LONGINT(INTPTR(next^.data)^);
          END;
        ELSIF (kind = scrollerKind) AND (scrollerNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtscTop), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.lidata := LONGINT(INTPTR(next^.data)^);
          END;
        ELSIF (kind = listviewKind) AND (listviewNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtlvSelected), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.data := LONGCARD(CARDPTR(next^.data)^);
          END;
        ELSIF (kind = paletteKind) AND (paletteNotify IN flags) THEN
          next := UL.FindTagItem(Tag(gtpaColor), tags);
          IF next # NIL THEN
            pointer := next^.data;
            next^.data := LONGCARD(CARDPTR(next^.data)^);
          END;
        END;

        gad := GL.CreateGadgetA(kind, gad^, newgad, tags);
        IF gad = NIL THEN
          SetGUIError(gui, gadgetError);
          RETURN;
        END;
        gadget := gad;
        ScanGadget(gui, ginfo, tags, TRUE);

        IF next # NIL THEN  (* restore old TAG list  *)
          next^.data := pointer;
          ginfo^.buffer := ADDRESS(next^.data); (* turn on notify *)
          ginfo^.onlyIntern := internMsgHandling IN flags;
          (* Intern only makes sense if a notify is set for this !
             (So NOT with buttonKind !) *)
        ELSE
          ginfo^.onlyIntern := FALSE;
        END;

        ginfo^.lvClearTime := lvKeyClearTime IN flags;
        gadget^.userData := ginfo;

        (* chain entry gadgets if wished *)
        IF ((kind = integerKind) OR (kind = stringKind)) AND
           (linkEntryGads IN flags) THEN
          IF firstEGad = NIL THEN firstEGad := gad  END;
          IF lastEGad # NIL THEN
            CAST(GUIGadgetInfoPtr, lastEGad^.userData)^.nextEGad := gad;
            CAST(GUIGadgetInfoPtr, lastEGad^.userData)^.nextEGadNbr := actgad;
          END;
          lastEGad := gad;
          IF cycleEntryGads IN flags THEN
            ginfo^.nextEGad := firstEGad;
            ginfo^.nextEGadNbr := CAST(GUIGadgetInfoPtr,
                                       firstEGad^.userData)^.v3;
          END;
        END;

      END;
    END;

    WITH gui^ DO

      IF kind < guiToolsKinds THEN
        IF rememberGadTags IN status THEN
          RememberTags(ginfo, tags);  (* remember tags *)
        END;

        IF (kind # textKind) AND (kind # numberKind) THEN
          (* search for key equivalents *)
          IF vanillaKeysNotify IN flags THEN
            next := UL.FindTagItem(Tag(gtUnderscore), tags);
            IF next # NIL THEN
              key[0] := CAST(CHARARR4, next^.data)[3];
              key[1] := 0C;
              IF newgad.gadgetText # NIL THEN
                keyPos := Occurs(STRPTR(newgad.gadgetText)^, 0, key, TRUE);
              ELSE
                keyPos := noOccur;
              END;
              IF keyPos # noOccur THEN
                INC(keyPos);
                key[0] := UL.ToUpper(STRPTR(newgad.gadgetText)^[keyPos]);
                IF (key[0] >= 'A') AND (key[0] <= 'Z') THEN
                  IF keys[ORD(key[0]) - ORD('A')] = noKeyEqu THEN
                    keys[ORD(key[0]) - ORD('A')] := actgad;
                  ELSE
                    SetGUIError(gui, gadKeyDefTwice);
                  END;
                ELSIF ~(allowAllVanillaKeys IN flags) THEN
                  SetGUIError(gui, gadKeyNotAllowed);
                END;
              ELSE
                SetGUIError(gui, gadKeyNotFound);
              END;
            END;
          END;
        END;
      END;

      gadgets^[actgad] := gadget; (* prepare for next gadget *)
      INC(actgad);
      INC(newgad.gadgetID);
      newgad.gadgetText := NIL;

      IF tagmem # NIL THEN UL.FreeTagItems(tagmem); tagmem := NIL END;

    END;

  END CreateSpecialGadget;

  PROCEDURE CreateGadget(gui : GUIInfoPtr;
                         left, top, width, height : INTEGER;
                         kind : LONGCARD;
                         tags : TagItemPtr);
  BEGIN
    CreateSpecialGadget(gui, left, top, width, height, kind, tags);
  END CreateGadget;

  PROCEDURE CreateGadgetText(gui : GUIInfoPtr;
                             left, top, width, height : INTEGER;
                             kind : LONGCARD;
                             text : ADDRESS;
                             tags : TagItemPtr);
  BEGIN
    gui^.newgad.gadgetText := text;
    CreateSpecialGadget(gui, left, top, width, height, kind, tags);
  END CreateGadgetText;

  PROCEDURE CreateGadgetFull(gui : GUIInfoPtr;
                             left, top, width, height : INTEGER;
                             kind : LONGCARD;
                             text : ADDRESS;
                             place: NewGadgetFlagSet;
                             tags : TagItemPtr);
  BEGIN
    WITH gui^.newgad DO
      gadgetText := text;
      flags      := place;
    END;
    CreateSpecialGadget(gui, left, top, width, height, kind, tags);
  END CreateGadgetFull;

  PROCEDURE BeginRefresh(gui : GUIInfoPtr);
  VAR spGadget : GadgetPtr;
  BEGIN
    GL.GTBeginRefresh(gui^.window);
    spGadget := gui^.spezialGad;
    WHILE spGadget # NIL DO
      DrawGadget(gui, spGadget, spGadget^.userData);
      spGadget := spGadget^.nextGadget;
    END;
  END BeginRefresh;

  PROCEDURE EndRefresh(gui : GUIInfoPtr; complete : BOOLEAN);
  BEGIN
    GL.GTEndRefresh(gui^.window, complete);
    IF refreshWF IN gui^.status THEN IL.RefreshWindowFrame(gui^.window) END;
  END EndRefresh;

  PROCEDURE ShowRequester(gui  : GUIInfoPtr; text : ADDRESS;
                          kind : LONGCARD; tags : TagItemPtr) : LONGINT;
  VAR args : Req.GTReqArgs;
  BEGIN
    IF gui # NIL THEN
      args.window := gui^.window;
    ELSE
      args.window := CAST(ProcessPtr, FindTask(NIL))^.windowPtr;
    END;
    RETURN Req.GTRequester(ADR(args), text, kind, tags);
  END ShowRequester;

  PROCEDURE SimpleReq(text : ADDRESS; kind : LONGCARD):LONGINT;
  BEGIN
    RETURN ShowRequester(NIL, text, kind, NIL);
  END SimpleReq;

  PROCEDURE SetProcessWindow(window : WindowPtr):WindowPtr;
  VAR oldwin : WindowPtr;
  BEGIN
    oldwin := CAST(ProcessPtr, FindTask(NIL))^.windowPtr;
    CAST(ProcessPtr, FindTask(NIL))^.windowPtr := window;
    RETURN oldwin;
  END SetProcessWindow;

  PROCEDURE DoResizing(gui : GUIInfoPtr);
  VAR i : INTEGER;
      ginfo : GUIGadgetInfoPtr;
  BEGIN
    IF useGadDesc IN gui^.status THEN
      FOR i := 0 TO gui^.actgad-1 DO
        ginfo := gui^.gadgets^[i]^.userData;
        WITH ginfo^ DO
          gadDesc.leftEdge := leftC; (* restore creation values *)
          gadDesc.topEdge  := topC;
          gadDesc.width  := widthC;
          gadDesc.height := heightC;
        END;
        ConvGadDesc(gui, ginfo, ginfo^.gadDesc);
        gui^.gadget := gui^.gadgets^[i];
      END;
    END;
  END DoResizing;

BEGIN
END GUITools.
