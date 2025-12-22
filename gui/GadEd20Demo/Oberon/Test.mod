MODULE Test;

(* Erstellt mit GadEd V2.0 *)
(* Geschrieben von Michael Neumann und Thomas Patschinski *)

IMPORT s  := SYSTEM,
       es := ExecSupport,
       e  := Exec,
       df := DiskFont,
       g  := Graphics,
       in := Intuition,
       gt := GadTools,
       st := Strings,
       u  := Utility;

TYPE TagItemType = UNTRACED POINTER TO ARRAY MAX (INTEGER) OF u.TagItem;
     TagType     = UNTRACED POINTER TO ARRAY MAX (INTEGER) OF u.Tag;

CONST
      tagUnderscore    = gt.tagBase+64;
      waNewLookMenu    = u.user+30H+99;
      gtNewLookMenu    = u.user+80000H+67;
      tagCheckScaled   = u.user+80000H+68;
      tagMxScaled      = u.user+80000H+69;
      tagNumColors     = u.user+80000H+70;
      tagTitlePlace    = u.user+80000H+71;
      tagFrontPen      = u.user+80000H+72;
      tagBackPen       = u.user+80000H+73;
      tagJustification = u.user+80000H+74;
      tagFormat        = u.user+80000H+75;
      tagMaxNumberLen  = u.user+80000H+76;
      tagFrameType     = u.user+80000H+77;
      tagMaxPixelLen   = u.user+80000H+80;
      tagClipped       = u.user+80000H+85;


      (* Proc00-Requester *)
      (* Gadget Lables *)

      Proc00GadEdGadget000               * = 0;
      Proc00GadEdGadget001               * = 1;
      Proc00GadEdGadget002               * = 2;
      Proc00GadEdGadget003               * = 3;
      Proc00GadEdGadget004               * = 4;
      Proc00GadEdGadget005               * = 5;
      Proc00GadEdGadget006               * = 6;
      Proc00GadEdGadget007               * = 7;
      Proc00GadEdGadget008               * = 8;
      Proc00GadEdGadget009               * = 9;
      Proc00GadEdGadget010               * = 10;
      Proc00GadEdGadget011               * = 11;
      Proc00GadEdGadget012               * = 12;
      Proc00GadEdGadget013               * = 13;
      Proc00GadEdGadget014               * = 14;
      Proc00GadEdGadget015               * = 15;
      Proc00GadEdGadget016               * = 16;
      Proc00GadEdGadget017               * = 17;
      Proc00GadEdGadget018               * = 18;
      Proc00GadEdGadget019               * = 19;
      Proc00GadEdGadget020               * = 20;
      Proc00GadEdGadget021               * = 21;
      Proc00GadEdGadget022               * = 22;
      Proc00GadEdGadget023               * = 23;
      Proc00GadEdGadget024               * = 24;
      Proc00GadEdGadget025               * = 25;
      Proc00GadEdGadget026               * = 26;
      Proc00GadEdGadget027               * = 27;

      (* Menü Lables *)

      Proc00GadEdTitel000                * = 0;
      Proc00GadEdItem000                 * = 0;
      Proc00GadEdItem001                 * = 2;
      Proc00GadEdItem002                 * = 3;
      Proc00GadEdItem003                 * = 5;
      Proc00GadEdTitel001                * = 1;
      Proc00GadEdItem004                 * = 0;
      Proc00GadEdItem005                 * = 1;
      Proc00GadEdItem006                 * = 2;
      Proc00GadEdTitel002                * = 2;
      Proc00GadEdItem007                 * = 0;
      Proc00GadEdSub000                  * = 0;
      Proc00GadEdSub001                  * = 2;
      Proc00GadEdItem008                 * = 1;
      Proc00GadEdItem009                 * = 2;
      Proc00GadEdItem010                 * = 3;
      Proc00GadEdItem011                 * = 5;
      Proc00GadEdItem012                 * = 6;
      Proc00GadEdTitel003                * = 3;
      Proc00GadEdItem013                 * = 0;
      Proc00GadEdItem014                 * = 1;
      Proc00GadEdItem015                 * = 3;
      Proc00GadEdSub002                  * = 0;
      Proc00GadEdSub003                  * = 1;

      (* Proc01-Requester *)
      (* Gadget Lables *)

      Proc01GadEdGadget000               * = 0;
      Proc01GadEdGadget001               * = 1;
      Proc01GadEdGadget002               * = 2;
      Proc01GadEdGadget003               * = 3;
      Proc01GadEdGadget004               * = 4;
      Proc01GadEdGadget005               * = 5;
      Proc01GadEdGadget006               * = 6;
      Proc01GadEdGadget007               * = 7;
      Proc01GadEdGadget008               * = 8;
      Proc01GadEdGadget009               * = 9;
      Proc01GadEdGadget010               * = 10;
      Proc01GadEdGadget011               * = 11;
      Proc01GadEdGadget012               * = 12;
      Proc01GadEdGadget013               * = 13;
      Proc01GadEdGadget014               * = 14;
      Proc01GadEdGadget015               * = 15;
      Proc01GadEdGadget016               * = 16;
      Proc01GadEdGadget017               * = 17;
      Proc01GadEdGadget018               * = 18;
      Proc01GadEdGadget019               * = 19;
      Proc01GadEdGadget020               * = 20;
      Proc01GadEdGadget021               * = 21;
      Proc01GadEdGadget022               * = 22;
      Proc01GadEdGadget023               * = 23;
      Proc01GadEdGadget024               * = 24;
      Proc01GadEdGadget025               * = 25;
      Proc01GadEdGadget026               * = 26;
      Proc01GadEdGadget027               * = 27;

      (* Menü Lables *)

      Proc01GadEdTitel000                * = 0;
      Proc01GadEdItem000                 * = 0;
      Proc01GadEdItem001                 * = 2;
      Proc01GadEdItem002                 * = 3;
      Proc01GadEdItem003                 * = 5;
      Proc01GadEdTitel001                * = 1;
      Proc01GadEdItem004                 * = 0;
      Proc01GadEdItem005                 * = 1;
      Proc01GadEdItem006                 * = 2;
      Proc01GadEdTitel002                * = 2;
      Proc01GadEdItem007                 * = 0;
      Proc01GadEdSub000                  * = 0;
      Proc01GadEdSub001                  * = 2;
      Proc01GadEdItem008                 * = 1;
      Proc01GadEdItem009                 * = 2;
      Proc01GadEdItem010                 * = 3;
      Proc01GadEdItem011                 * = 5;
      Proc01GadEdItem012                 * = 6;
      Proc01GadEdTitel003                * = 3;
      Proc01GadEdItem013                 * = 0;
      Proc01GadEdItem014                 * = 1;
      Proc01GadEdItem015                 * = 3;
      Proc01GadEdSub002                  * = 0;
      Proc01GadEdSub003                  * = 1;

VAR
    Liste * :               ARRAY 2 OF e.List;
    ListViewList00 * :      ARRAY 2 OF e.List;
    Men * :                 in.MenuPtr;
    Menu00 * :              in.MenuPtr;
    congad:                 ARRAY 2 OF in.GadgetPtr;
    W:                      ARRAY 2 OF in.WindowPtr;
    gad:                    in.GadgetPtr;
    Vi:                     s.ADDRESS;
    Screen:                 in.ScreenPtr;
    OwnScreen:              BOOLEAN;
    SAttr:                  g.TextAttr;
    SFont:                  g.TextFontPtr;
    WFont:                  ARRAY 2 OF g.TextFontPtr;
    OffsetY:                INTEGER;
    FontXSize,
    FontYSize,
    WinLeft,
    WinTop,
    WinWidth,
    WinHeight:              INTEGER;
    G0 * :                  ARRAY 28 OF in.GadgetPtr;
    GPtrs00 * :             ARRAY 28 OF in.GadgetPtr;

TYPE PensType = ARRAY 1 OF INTEGER;
CONST Pens = PensType(-1);

TYPE STagsType = ARRAY 24 OF u.Tag;
CONST STags = STagsType (
         in.saFont,NIL,
         in.saTop,0,
         in.saPens,s.ADR(Pens),
         in.saWidth,724,
         in.saHeight,564,
         in.saDepth,2,
         in.saDisplayID,000029004H,
         in.saTitle,s.ADR("Gadget Test Screen"),
         in.saFullPalette,in.LTRUE,
         in.saShowTitle,in.LTRUE,
         in.saOverscan,in.oScanText,
         u.done,NIL
      );

(* Definitionen für Fenster Proc00 Maske *)

CONST WAttr0=g.TextAttr(s.ADR("topaz-classic.font"),8,SHORTSET{},SHORTSET{});

TYPE  NewG0Type=ARRAY 28 OF gt.NewGadget;
CONST NewG0=NewG0Type(
        115, 71, 67, 12, s.ADR("Tel_. Nummer:"), s.ADR(WAttr0), 0, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,115, 83, 67, 12, s.ADR("_Haus Nummer:"), s.ADR(WAttr0), 1, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,115, 212, 234, 12, s.ADR("Copyright b_y"), s.ADR(WAttr0), 2, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,115, 224, 234, 12, s.ADR("Copyright b_y"), s.ADR(WAttr0), 3, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,15, 18, 92, 21, s.ADR("Button"), s.ADR(WAttr0), 4, LONGSET{gt.placeTextIn}, NIL,1
       ,15, 39, 92, 21, s.ADR("_Ok"), s.ADR(WAttr0), 5, LONGSET{gt.placeTextIn}, NIL,NIL
       ,107, 18, 92, 21, s.ADR("_Under"), s.ADR(WAttr0), 6, LONGSET{gt.placeTextIn}, NIL,2
       ,107, 39, 92, 21, s.ADR("Special !"), s.ADR(WAttr0), 7, LONGSET{gt.placeTextIn}, NIL,NIL
       ,217, 17, 26, 11, s.ADR("Checkbo_x"), s.ADR(WAttr0), 8, LONGSET{gt.placeTextRight,gt.highLabel}, NIL,NIL
       ,217, 28, 26, 11, s.ADR("_Gfx"), s.ADR(WAttr0), 9, LONGSET{gt.placeTextRight}, NIL,NIL
       ,217, 39, 26, 11, s.ADR("Text _Modus"), s.ADR(WAttr0), 10, LONGSET{gt.placeTextRight}, NIL,NIL
       ,217, 50, 26, 11, s.ADR("Nicht umschalten"), s.ADR(WAttr0), 11, LONGSET{gt.placeTextRight}, NIL,NIL
       ,393, 30, 227, 49, s.ADR("Info Box"), s.ADR(WAttr0), 12, LONGSET{gt.placeTextAbove,gt.highLabel}, NIL,NIL
       ,393, 90, 227, 71, s.ADR("Screen Mode:"), s.ADR(WAttr0), 13, LONGSET{gt.placeTextAbove}, NIL,NIL
       ,248, 72, 16, 8, s.ADR("3.x"), s.ADR(WAttr0), 14, LONGSET{gt.placeTextRight,gt.highLabel}, NIL,NIL
       ,230, 72, 16, 8, NIL, s.ADR(WAttr0), 15, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,89, 104, 87, 10, s.ADR("Fast Ram"), s.ADR(WAttr0), 16, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,89, 114, 87, 10, s.ADR("Chip Ram"), s.ADR(WAttr0), 17, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,61, 135, 122, 12, s.ADR("Mo_dus"), s.ADR(WAttr0), 18, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,61, 147, 122, 12, s.ADR("Mo_dus"), s.ADR(WAttr0), 19, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,83, 167, 160, 19, s.ADR("Farb_wahl"), s.ADR(WAttr0), 20, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,83, 186, 160, 19, s.ADR("Farb_wahl"), s.ADR(WAttr0), 21, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,332, 72, 24, 73, s.ADR("Q\o"), s.ADR(WAttr0), 22, LONGSET{gt.placeTextBelow,gt.highLabel}, NIL,NIL
       ,356, 72, 24, 73, s.ADR("Q\o"), s.ADR(WAttr0), 23, LONGSET{gt.placeTextBelow}, NIL,NIL
       ,311, 170, 281, 17, s.ADR("Anfang"), s.ADR(WAttr0), 24, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,311, 187, 281, 17, s.ADR("Ende"), s.ADR(WAttr0), 25, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,441, 213, 184, 11, s.ADR("Fix Text"), s.ADR(WAttr0), 26, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,441, 224, 184, 11, s.ADR("Fix Text"), s.ADR(WAttr0), 27, LONGSET{gt.placeTextLeft}, NIL,NIL
      );

TYPE  MxText0x0Type=ARRAY 5 OF s.ADDRESS;
CONST MxText0x0=MxText0x0Type (
        s.ADR("_Domino"),
        s.ADR("_Pal"),
        s.ADR("_Ntsc"),
        s.ADR("N_ichts"),
        NIL
      );

TYPE  MxText0x1Type=ARRAY 10 OF s.ADDRESS;
CONST MxText0x1=MxText0x1Type (
        s.ADR("1\o"),
        s.ADR("2\o"),
        s.ADR("4\o"),
        s.ADR("8\o"),
        s.ADR("16"),
        s.ADR("32"),
        s.ADR("64"),
        s.ADR("128"),
        s.ADR("256"),
        NIL
      );

TYPE  CyText0x0Type=ARRAY 4 OF s.ADDRESS;
CONST CyText0x0=CyText0x0Type (
        s.ADR("Pause"),
        s.ADR("Step"),
        s.ADR("Run"),
        NIL
      );

TYPE  CyText0x1Type=ARRAY 4 OF s.ADDRESS;
CONST CyText0x1=CyText0x1Type (
        s.ADR("Pause"),
        s.ADR("Step"),
        s.ADR("Run"),
        NIL
      );

TYPE  Kinds0Type=ARRAY 28 OF INTEGER;
CONST Kinds0=Kinds0Type(
        gt.integerKind
       ,gt.integerKind
       ,gt.stringKind
       ,gt.stringKind
       ,gt.buttonKind
       ,gt.buttonKind
       ,gt.buttonKind
       ,gt.buttonKind
       ,gt.checkBoxKind
       ,gt.checkBoxKind
       ,gt.checkBoxKind
       ,gt.checkBoxKind
       ,gt.listViewKind
       ,gt.listViewKind
       ,gt.mxKind
       ,gt.mxKind
       ,gt.numberKind
       ,gt.numberKind
       ,gt.cycleKind
       ,gt.cycleKind
       ,gt.paletteKind
       ,gt.paletteKind
       ,gt.scrollerKind
       ,gt.scrollerKind
       ,gt.sliderKind
       ,gt.sliderKind
       ,gt.textKind
       ,gt.textKind
      );

TYPE  Tags0Type=ARRAY 228 OF u.Tag;
CONST Tags0=Tags0Type(
        tagUnderscore,ORD("_"),
        gt.inNumber,4711,
        in.stringaReplaceMode,in.LTRUE,
        in.gaImmediate,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        gt.inNumber,1,
        gt.inMaxChars,7,
        in.stringaJustification,LONGSET{in.stringCenter},
        u.done,
        tagUnderscore,ORD("_"),
        gt.stString,s.ADR("Thomas Patschinski"),
        in.stringaReplaceMode,in.LTRUE,
        in.stringaJustification,LONGSET{in.stringCenter},
        gt.stMaxChars,79,
        in.gaImmediate,in.LTRUE,
        in.gaTabCycle,in.LFALSE,
        in.stringaExitHelp,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        gt.stString,s.ADR("Michael Neumann"),
        gt.stMaxChars,255,
        in.gaTabCycle,in.LFALSE,
        in.stringaExitHelp,in.LTRUE,
        u.done,
        in.gaImmediate,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        u.done,
        tagUnderscore,ORD("_"),
        u.done,
        in.gaDisabled,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        gt.cbChecked,in.LTRUE,
        tagCheckScaled,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        u.done,
        tagUnderscore,ORD("_"),
        gt.cbChecked,in.LTRUE,
        u.done,
        in.gaDisabled,in.LTRUE,
        u.done,
        gt.lvReadOnly,in.LTRUE,
        gt.lvLabels,NIL,
        in.layoutaSpacing,2,
        u.done,
        gt.lvScrollWidth,24,
        gt.lvShowSelected,NIL,
        gt.lvLabels,NIL,
        u.done,
        tagUnderscore,ORD("_"),
        gt.mxSpacing,2,
        gt.mxLabels,s.ADR(MxText0x0[0]),
        in.gaDisabled,in.LTRUE,
       tagTitlePlace,LONGSET{gt.placeTextBelow},
        u.done,
        gt.mxSpacing,2,
        gt.mxLabels,s.ADR(MxText0x1[0]),
        tagMxScaled,in.LTRUE,
        u.done,
        gt.nmBorder,in.LTRUE,
        gt.nmNumber,11893096,
        tagClipped,in.LFALSE,
        u.done,
        gt.nmBorder,in.LTRUE,
        gt.nmNumber,1904760,
        tagFrontPen,2,
        tagJustification,2,        tagMaxNumberLen,9,
        u.done,
        tagUnderscore,ORD("_"),
        gt.cyLabels,s.ADR(CyText0x0[0]),
        u.done,
        tagUnderscore,ORD("_"),
        in.gaDisabled,in.LTRUE,
        gt.cyLabels,s.ADR(CyText0x1[0]),
        u.done,
        tagUnderscore,ORD("_"),
        in.gaDisabled,in.LTRUE,
        gt.paDepth,2,
        gt.paIndicatorHeight,0,
        gt.paIndicatorWidth,0,
        u.done,
        tagUnderscore,ORD("_"),
        gt.paDepth,2,
        gt.paIndicatorHeight,0,
        gt.paIndicatorWidth,0,
        u.done,
        in.gaDisabled,in.LTRUE,
        gt.scTotal,10,
        gt.scVisible,3,
        gt.scArrows,16,
        in.pgaFreedom,2,
        in.gaRelVerify,in.LTRUE,
        in.gaImmediate,in.LTRUE,
        u.done,
        gt.scTop,9,
        gt.scTotal,11,
        gt.scArrows,16,
        in.pgaFreedom,2,
        u.done,
        gt.slLevel,3,
        gt.slMaxLevelLen,4,
        gt.slLevelFormat,s.ADR("%ld "),
        gt.slLevelPlace,2,
        tagMaxPixelLen,5,
        tagJustification,1,
        u.done,
        in.gaDisabled,in.LTRUE,
        gt.slLevel,15,
        gt.slMaxLevelLen,3,
        gt.slLevelFormat,s.ADR("%ld "),
        gt.slLevelPlace,2,
        tagJustification,2,
        u.done,
        gt.txBorder,in.LTRUE,
        gt.txText,s.ADR("GadEd Version 1.10"),
        gt.txCopyText,in.LTRUE,
        tagFrontPen,2,
        tagBackPen,1,
        u.done,
        gt.txBorder,in.LTRUE,
        gt.txText,s.ADR("<Empty>"),
        tagJustification,2,        tagClipped,in.LFALSE,
        u.done
      );

TYPE  Bevel0Type=ARRAY 48 OF INTEGER;
CONST Bevel0=Bevel0Type(
        7, 101, 179,27
       ,329, 68, 55,95
       ,7, 68, 179,30
       ,7, 132, 179,31
       ,364, 210, 264,29
       ,213, 13, 171,53
       ,7, 210, 345,29
       ,7, 165, 240,43
       ,7, 13, 203,53
       ,188, 68, 139,95
       ,250, 165, 378,43
       ,387, 13, 241,150
      );

TYPE  BevelTags0Type=ARRAY 36 OF u.Tag;
CONST BevelTags0=BevelTags0Type(
        gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
      );

TYPE  IText0Type=ARRAY 4 OF in.IntuiText;
CONST IText0=IText0Type(
        3, 2, SHORTSET{0},267, 126, s.ADR(WAttr0), s.ADR("Das ist"), NIL
       ,1, 0, SHORTSET{0,g.inversvid},283, 144, s.ADR(WAttr0), s.ADR("Intui"), NIL
       ,1, 3, SHORTSET{0},291, 153, s.ADR(WAttr0), s.ADR("Text"), NIL
       ,1, 2, SHORTSET{0},299, 135, s.ADR(WAttr0), s.ADR("ein"), NIL
      );

TYPE  NewM0Type=ARRAY 30 OF gt.NewMenu;
CONST NewM0=NewM0Type(
        gt.title, s.ADR("Projekt"), NIL, {}, LONGSET{}, NIL, 
        gt.item,s.ADR("About"),s.ADR("A\o"),  {}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Load"),s.ADR("L\o"),  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Save"),s.ADR("S\o"),  {}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Quit"),s.ADR("Q\o"),  {}, LONGSET{}, NIL, 
        gt.title, s.ADR("Buffer"), NIL, {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Cut"),s.ADR("C\o"),  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Paste"),s.ADR("P\o"),  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Copy"),s.ADR("O\o"),  {}, LONGSET{}, NIL, 
        gt.title, s.ADR("Settings"), NIL, {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Special"),NIL,  {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("Betatester Info"),NIL, {in.menuToggle,in.checkIt,in.itemEnabled}, LONGSET{}, NIL, 
        gt.sub,gt.barLabel;NIL, {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("Extendet Features"),NIL, {in.menuToggle,in.checkIt}, LONGSET{}, NIL, 
        gt.item,s.ADR("Save Icons"),NIL,  {in.menuToggle,in.checkIt,in.checked}, LONGSET{}, NIL, 
        gt.item,s.ADR("Use ENV:"),NIL,  {in.menuToggle,in.checkIt,in.checked}, LONGSET{}, NIL, 
        gt.item,s.ADR("Fast Ram"),NIL,  {in.menuToggle,in.checkIt}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Asl Requster"),NIL,  {in.checkIt,in.checked}, LONGSET{}, NIL, 
        gt.item,s.ADR("OS 3.x"),NIL,  {in.checkIt}, LONGSET{}, NIL, 
        gt.title, s.ADR("Extendet Menu"), NIL, {gt.menuDisabled}, LONGSET{}, NIL, 
        gt.item,s.ADR("New 1"),NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("New 2"),NIL,  {}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("New 3"),NIL,  {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("New 3_1"),NIL, {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("New 3_2"),NIL, {}, LONGSET{}, NIL, 
        gt.end, NIL, NIL, {}, LONGSET{},NIL
      );

TYPE WTags0Type = ARRAY 30 OF u.Tag;
CONST WTags0 = WTags0Type (
        in.waCustomScreen,NIL,
        in.waGadgets,NIL,
        in.waLeft,0,
        in.waTop,0,
        in.waWidth,0,
        in.waHeight,0,
        in.waMinWidth,633,
        in.waMinHeight,243,
        in.waMaxWidth,633,
        in.waMaxHeight,243,
        in.waTitle,s.ADR("Gadget Test Fenster1"),
        in.waIDCMP,gt.buttonIDCMP+gt.checkBoxIDCMP+gt.integerIDCMP+gt.listViewIDCMP+gt.mxIDCMP+gt.numberIDCMP+gt.cycleIDCMP+gt.paletteIDCMP+gt.scrollerIDCMP+gt.sliderIDCMP+gt.stringIDCMP+gt.textIDCMP+LONGSET{in.newSize,in.closeWindow},
        in.waFlags,LONGSET{in.windowDrag,in.windowDepth,in.windowClose,in.activate},
        waNewLookMenu,in.LTRUE,
        u.done,NIL
     );

(* Definitionen für Fenster Proc01 Maske *)

CONST WAttr1=g.TextAttr(s.ADR("topaz-classic.font"),8,SHORTSET{},SHORTSET{});

TYPE  NewG1Type=ARRAY 28 OF gt.NewGadget;
CONST NewG1=NewG1Type(
        115, 71, 67, 12, s.ADR("Tel_. Nummer:"), s.ADR(WAttr1), 0, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,115, 83, 67, 12, s.ADR("_Haus Nummer:"), s.ADR(WAttr1), 1, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,115, 212, 234, 12, s.ADR("Copyright b_y"), s.ADR(WAttr1), 2, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,115, 224, 234, 12, s.ADR("Copyright b_y"), s.ADR(WAttr1), 3, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,15, 18, 92, 21, s.ADR("Button"), s.ADR(WAttr1), 4, LONGSET{gt.placeTextIn}, NIL,1
       ,15, 39, 92, 21, s.ADR("_Ok"), s.ADR(WAttr1), 5, LONGSET{gt.placeTextIn}, NIL,NIL
       ,107, 18, 92, 21, s.ADR("_Under"), s.ADR(WAttr1), 6, LONGSET{gt.placeTextIn}, NIL,2
       ,107, 39, 92, 21, s.ADR("Special !"), s.ADR(WAttr1), 7, LONGSET{gt.placeTextIn}, NIL,NIL
       ,217, 17, 26, 11, s.ADR("Checkbo_x"), s.ADR(WAttr1), 8, LONGSET{gt.placeTextRight,gt.highLabel}, NIL,NIL
       ,217, 28, 26, 11, s.ADR("_Gfx"), s.ADR(WAttr1), 9, LONGSET{gt.placeTextRight}, NIL,NIL
       ,217, 39, 26, 11, s.ADR("Text _Modus"), s.ADR(WAttr1), 10, LONGSET{gt.placeTextRight}, NIL,NIL
       ,217, 50, 26, 11, s.ADR("Nicht umschalten"), s.ADR(WAttr1), 11, LONGSET{gt.placeTextRight}, NIL,NIL
       ,393, 30, 227, 49, s.ADR("Info Box"), s.ADR(WAttr1), 12, LONGSET{gt.placeTextAbove,gt.highLabel}, NIL,NIL
       ,393, 90, 227, 71, s.ADR("Screen Mode:"), s.ADR(WAttr1), 13, LONGSET{gt.placeTextAbove}, NIL,NIL
       ,248, 72, 16, 8, s.ADR("3.x"), s.ADR(WAttr1), 14, LONGSET{gt.placeTextRight,gt.highLabel}, NIL,NIL
       ,230, 72, 16, 8, NIL, s.ADR(WAttr1), 15, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,89, 104, 87, 10, s.ADR("Fast Ram"), s.ADR(WAttr1), 16, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,89, 114, 87, 10, s.ADR("Chip Ram"), s.ADR(WAttr1), 17, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,61, 135, 122, 12, s.ADR("Mo_dus"), s.ADR(WAttr1), 18, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,61, 147, 122, 12, s.ADR("Mo_dus"), s.ADR(WAttr1), 19, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,83, 167, 160, 19, s.ADR("Farb_wahl"), s.ADR(WAttr1), 20, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,83, 186, 160, 19, s.ADR("Farb_wahl"), s.ADR(WAttr1), 21, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,332, 72, 24, 73, s.ADR("Q\o"), s.ADR(WAttr1), 22, LONGSET{gt.placeTextBelow,gt.highLabel}, NIL,NIL
       ,356, 72, 24, 73, s.ADR("Q\o"), s.ADR(WAttr1), 23, LONGSET{gt.placeTextBelow}, NIL,NIL
       ,311, 170, 281, 17, s.ADR("Anfang"), s.ADR(WAttr1), 24, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,311, 187, 281, 17, s.ADR("Ende"), s.ADR(WAttr1), 25, LONGSET{gt.placeTextLeft}, NIL,NIL
       ,441, 213, 184, 11, s.ADR("Fix Text"), s.ADR(WAttr1), 26, LONGSET{gt.placeTextLeft,gt.highLabel}, NIL,NIL
       ,441, 224, 184, 11, s.ADR("Fix Text"), s.ADR(WAttr1), 27, LONGSET{gt.placeTextLeft}, NIL,NIL
      );

TYPE  MxText1x0Type=ARRAY 5 OF s.ADDRESS;
CONST MxText1x0=MxText1x0Type (
        s.ADR("_Domino"),
        s.ADR("_Pal"),
        s.ADR("_Ntsc"),
        s.ADR("N_ichts"),
        NIL
      );

TYPE  MxText1x1Type=ARRAY 10 OF s.ADDRESS;
CONST MxText1x1=MxText1x1Type (
        s.ADR("1\o"),
        s.ADR("2\o"),
        s.ADR("4\o"),
        s.ADR("8\o"),
        s.ADR("16"),
        s.ADR("32"),
        s.ADR("64"),
        s.ADR("128"),
        s.ADR("256"),
        NIL
      );

TYPE  CyText1x0Type=ARRAY 4 OF s.ADDRESS;
CONST CyText1x0=CyText1x0Type (
        s.ADR("Pause"),
        s.ADR("Step"),
        s.ADR("Run"),
        NIL
      );

TYPE  CyText1x1Type=ARRAY 4 OF s.ADDRESS;
CONST CyText1x1=CyText1x1Type (
        s.ADR("Pause"),
        s.ADR("Step"),
        s.ADR("Run"),
        NIL
      );

TYPE  Kinds1Type=ARRAY 28 OF INTEGER;
CONST Kinds1=Kinds1Type(
        gt.integerKind
       ,gt.integerKind
       ,gt.stringKind
       ,gt.stringKind
       ,gt.buttonKind
       ,gt.buttonKind
       ,gt.buttonKind
       ,gt.buttonKind
       ,gt.checkBoxKind
       ,gt.checkBoxKind
       ,gt.checkBoxKind
       ,gt.checkBoxKind
       ,gt.listViewKind
       ,gt.listViewKind
       ,gt.mxKind
       ,gt.mxKind
       ,gt.numberKind
       ,gt.numberKind
       ,gt.cycleKind
       ,gt.cycleKind
       ,gt.paletteKind
       ,gt.paletteKind
       ,gt.scrollerKind
       ,gt.scrollerKind
       ,gt.sliderKind
       ,gt.sliderKind
       ,gt.textKind
       ,gt.textKind
      );

TYPE  Tags1Type=ARRAY 228 OF u.Tag;
CONST Tags1=Tags1Type(
        tagUnderscore,ORD("_"),
        gt.inNumber,4711,
        in.stringaReplaceMode,in.LTRUE,
        in.gaImmediate,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        gt.inNumber,1,
        gt.inMaxChars,7,
        in.stringaJustification,LONGSET{in.stringCenter},
        u.done,
        tagUnderscore,ORD("_"),
        gt.stString,s.ADR("Thomas Patschinski"),
        in.stringaReplaceMode,in.LTRUE,
        in.stringaJustification,LONGSET{in.stringCenter},
        gt.stMaxChars,79,
        in.gaImmediate,in.LTRUE,
        in.gaTabCycle,in.LFALSE,
        in.stringaExitHelp,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        gt.stString,s.ADR("Michael Neumann"),
        gt.stMaxChars,255,
        in.gaTabCycle,in.LFALSE,
        in.stringaExitHelp,in.LTRUE,
        u.done,
        in.gaImmediate,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        u.done,
        tagUnderscore,ORD("_"),
        u.done,
        in.gaDisabled,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        gt.cbChecked,in.LTRUE,
        tagCheckScaled,in.LTRUE,
        u.done,
        tagUnderscore,ORD("_"),
        u.done,
        tagUnderscore,ORD("_"),
        gt.cbChecked,in.LTRUE,
        u.done,
        in.gaDisabled,in.LTRUE,
        u.done,
        gt.lvReadOnly,in.LTRUE,
        gt.lvLabels,NIL,
        in.layoutaSpacing,2,
        u.done,
        gt.lvScrollWidth,24,
        gt.lvShowSelected,NIL,
        gt.lvLabels,NIL,
        u.done,
        tagUnderscore,ORD("_"),
        gt.mxSpacing,2,
        gt.mxLabels,s.ADR(MxText1x0[0]),
        in.gaDisabled,in.LTRUE,
       tagTitlePlace,LONGSET{gt.placeTextBelow},
        u.done,
        gt.mxSpacing,2,
        gt.mxLabels,s.ADR(MxText1x1[0]),
        tagMxScaled,in.LTRUE,
        u.done,
        gt.nmBorder,in.LTRUE,
        gt.nmNumber,11893096,
        tagClipped,in.LFALSE,
        u.done,
        gt.nmBorder,in.LTRUE,
        gt.nmNumber,1904760,
        tagFrontPen,2,
        tagJustification,2,        tagMaxNumberLen,9,
        u.done,
        tagUnderscore,ORD("_"),
        gt.cyLabels,s.ADR(CyText1x0[0]),
        u.done,
        tagUnderscore,ORD("_"),
        in.gaDisabled,in.LTRUE,
        gt.cyLabels,s.ADR(CyText1x1[0]),
        u.done,
        tagUnderscore,ORD("_"),
        in.gaDisabled,in.LTRUE,
        gt.paDepth,2,
        gt.paIndicatorHeight,0,
        gt.paIndicatorWidth,0,
        u.done,
        tagUnderscore,ORD("_"),
        gt.paDepth,2,
        gt.paIndicatorHeight,0,
        gt.paIndicatorWidth,0,
        u.done,
        in.gaDisabled,in.LTRUE,
        gt.scTotal,10,
        gt.scVisible,3,
        gt.scArrows,16,
        in.pgaFreedom,2,
        in.gaRelVerify,in.LTRUE,
        in.gaImmediate,in.LTRUE,
        u.done,
        gt.scTop,9,
        gt.scTotal,11,
        gt.scArrows,16,
        in.pgaFreedom,2,
        u.done,
        gt.slLevel,3,
        gt.slMaxLevelLen,4,
        gt.slLevelFormat,s.ADR("%ld "),
        gt.slLevelPlace,2,
        tagMaxPixelLen,5,
        tagJustification,1,
        u.done,
        in.gaDisabled,in.LTRUE,
        gt.slLevel,15,
        gt.slMaxLevelLen,3,
        gt.slLevelFormat,s.ADR("%ld "),
        gt.slLevelPlace,2,
        tagJustification,2,
        u.done,
        gt.txBorder,in.LTRUE,
        gt.txText,s.ADR("GadEd Version 1.10"),
        gt.txCopyText,in.LTRUE,
        tagFrontPen,2,
        tagBackPen,1,
        u.done,
        gt.txBorder,in.LTRUE,
        gt.txText,s.ADR("<Empty>"),
        tagJustification,2,        tagClipped,in.LFALSE,
        u.done
      );

TYPE  Bevel1Type=ARRAY 48 OF INTEGER;
CONST Bevel1=Bevel1Type(
        7, 101, 179,27
       ,329, 68, 55,95
       ,7, 68, 179,30
       ,7, 132, 179,31
       ,364, 210, 264,29
       ,213, 13, 171,53
       ,7, 210, 345,29
       ,7, 165, 240,43
       ,7, 13, 203,53
       ,188, 68, 139,95
       ,250, 165, 378,43
       ,387, 13, 241,150
      );

TYPE  BevelTags1Type=ARRAY 36 OF u.Tag;
CONST BevelTags1=BevelTags1Type(
        gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
       ,gt.visualInfo,NIL
        ,u.done
      );

TYPE  IText1Type=ARRAY 4 OF in.IntuiText;
CONST IText1=IText1Type(
        3, 2, SHORTSET{0},267, 126, s.ADR(WAttr1), s.ADR("Das ist"), NIL
       ,1, 0, SHORTSET{0,g.inversvid},283, 144, s.ADR(WAttr1), s.ADR("Intui"), NIL
       ,1, 3, SHORTSET{0},291, 153, s.ADR(WAttr1), s.ADR("Text"), NIL
       ,1, 2, SHORTSET{0},299, 135, s.ADR(WAttr1), s.ADR("ein"), NIL
      );

TYPE  NewM1Type=ARRAY 30 OF gt.NewMenu;
CONST NewM1=NewM1Type(
        gt.title, s.ADR("Projekt"), NIL, {}, LONGSET{}, NIL, 
        gt.item,s.ADR("About"),s.ADR("A\o"),  {}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Load"),s.ADR("L\o"),  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Save"),s.ADR("S\o"),  {}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Quit"),s.ADR("Q\o"),  {}, LONGSET{}, NIL, 
        gt.title, s.ADR("Buffer"), NIL, {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Cut"),s.ADR("C\o"),  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Paste"),s.ADR("P\o"),  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Copy"),s.ADR("O\o"),  {}, LONGSET{}, NIL, 
        gt.title, s.ADR("Settings"), NIL, {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Special"),NIL,  {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("Betatester Info"),NIL, {in.menuToggle,in.checkIt,in.itemEnabled}, LONGSET{}, NIL, 
        gt.sub,gt.barLabel;NIL, {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("Extendet Features"),NIL, {in.menuToggle,in.checkIt}, LONGSET{}, NIL, 
        gt.item,s.ADR("Save Icons"),NIL,  {in.menuToggle,in.checkIt,in.checked}, LONGSET{}, NIL, 
        gt.item,s.ADR("Use ENV:"),NIL,  {in.menuToggle,in.checkIt,in.checked}, LONGSET{}, NIL, 
        gt.item,s.ADR("Fast Ram"),NIL,  {in.menuToggle,in.checkIt}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("Asl Requster"),NIL,  {in.checkIt,in.checked}, LONGSET{}, NIL, 
        gt.item,s.ADR("OS 3.x"),NIL,  {in.checkIt}, LONGSET{}, NIL, 
        gt.title, s.ADR("Extendet Menu"), NIL, {gt.menuDisabled}, LONGSET{}, NIL, 
        gt.item,s.ADR("New 1"),NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("New 2"),NIL,  {}, LONGSET{}, NIL, 
        gt.item,gt.barLabel,NIL,  {}, LONGSET{}, NIL, 
        gt.item,s.ADR("New 3"),NIL,  {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("New 3_1"),NIL, {}, LONGSET{}, NIL, 
        gt.sub,s.ADR("New 3_2"),NIL, {}, LONGSET{}, NIL, 
        gt.end, NIL, NIL, {}, LONGSET{},NIL
      );

TYPE WTags1Type = ARRAY 30 OF u.Tag;
CONST WTags1 = WTags1Type (
        in.waCustomScreen,NIL,
        in.waGadgets,NIL,
        in.waLeft,0,
        in.waTop,0,
        in.waWidth,0,
        in.waHeight,0,
        in.waMinWidth,633,
        in.waMinHeight,243,
        in.waMaxWidth,633,
        in.waMaxHeight,243,
        in.waTitle,s.ADR("Gadget Test Fenster"),
        in.waIDCMP,gt.buttonIDCMP+gt.checkBoxIDCMP+gt.integerIDCMP+gt.listViewIDCMP+gt.mxIDCMP+gt.numberIDCMP+gt.cycleIDCMP+gt.paletteIDCMP+gt.scrollerIDCMP+gt.sliderIDCMP+gt.stringIDCMP+gt.textIDCMP+LONGSET{in.newSize,in.closeWindow},
        in.waFlags,LONGSET{in.windowDrag,in.windowDepth,in.windowClose,in.activate},
        waNewLookMenu,in.LTRUE,
        u.done,NIL
     );

PROCEDURE AddNode(VAR LVList : e.List; Name : ARRAY OF CHAR): BOOLEAN;
VAR TempNode: e.NodePtr;
    NewStr:   e.STRPTR;
BEGIN
   TempNode:=e.AllocVec(SIZE(e.Node),LONGSET{e.public,e.memClear});
   IF TempNode=NIL THEN RETURN FALSE; END;
   e.AddTail(LVList,TempNode);
   NewStr:=e.AllocVec(st.Length(Name)+1,LONGSET{e.public,e.memClear});
   IF NewStr=NIL THEN RETURN FALSE; END;
   TempNode.name := NewStr;
   e.CopyMemAPTR(s.ADR(Name),NewStr,st.Length(Name)+1);
   RETURN TRUE;
END AddNode;

PROCEDURE CalcXValue(number:INTEGER):INTEGER;
BEGIN
RETURN ((FontXSize*number)+4) DIV 8;
END CalcXValue;

PROCEDURE CalcYValue(number:INTEGER):INTEGER;
BEGIN
RETURN ((FontYSize*number)+4) DIV 8;
END CalcYValue;

PROCEDURE CalcFont(Width,Height:INTEGER);
BEGIN
   OffsetY     := 0;
   FontXSize   := Screen^.rastPort.font^.xSize;
   FontYSize   := Screen^.rastPort.font^.ySize;
   SAttr.name  := Screen^.rastPort.font^.message.node.name;
   SAttr.ySize := FontYSize;
   IF (Width>0) AND (Height>0) THEN
      IF (CalcXValue(Width) > Screen^.width) OR (CalcYValue(Height) > Screen^.height) THEN
         OffsetY     := FontYSize-8;
         SAttr.name  := s.ADR("topaz.font");
         SAttr.ySize := 8;
         FontXSize   := 8;
         FontYSize   := 8;
      END;
   END;
END CalcFont;

PROCEDURE CenterX(width:INTEGER): INTEGER;
VAR rect      : g.Rectangle;
    l,w       : INTEGER;
    ID,Result : LONGINT;
BEGIN
  ID:=g.GetVPModeID(s.ADR(Screen^.viewPort));
  Result := in.QueryOverscan(ID,rect,in.oScanText);
  l := -Screen^.leftEdge;
  w := rect.maxX - rect.minX+1;
  RETURN ((w-width) DIV 2)+l;
END CenterX;

PROCEDURE CenterY(height:INTEGER): INTEGER;
VAR rect      : g.Rectangle;
    t,h       : INTEGER;
    ID,Result : LONGINT;
BEGIN
  ID:=g.GetVPModeID(s.ADR(Screen^.viewPort));
  Result := in.QueryOverscan(ID,rect,in.oScanText);
  t := -Screen^.topEdge;
  h := rect.maxY - rect.minY+1;
  RETURN ((h-height) DIV 2)+t;
END CenterY;

PROCEDURE RefreshProc00 * ;
VAR  i         : INTEGER;
     CopyPtr   : TagItemType;
     TempPtr   : u.TagItemPtr;
     TagCount  : INTEGER;
     TempIText : in.IntuiText;
     left,top,width,height : INTEGER;
BEGIN
   TagCount:=0;
   FOR i:=0 TO 11 DO
      CopyPtr :=u.CloneTagItems(s.VAL(TagItemType,s.ADR(BevelTags0[TagCount]))^);
      IF CopyPtr#NIL THEN
         TempPtr := u.FindTagItem(gt.visualInfo,CopyPtr^);
         IF TempPtr#NIL THEN
            TempPtr^.data:=Vi;
         left   := CalcXValue(Bevel0[i*4]);
         top    := CalcYValue(Bevel0[i*4+1])+OffsetY;
         width  := CalcXValue(Bevel0[i*4+2]);
         height := CalcYValue(Bevel0[i*4+3]);
         gt.DrawBevelBoxA(W[0]^.rPort,left,top,width,height,CopyPtr^);
         END;
         u.FreeTagItems(CopyPtr^);
      END;
      WHILE BevelTags0[TagCount]#u.done DO INC(TagCount,2) END;
      INC(TagCount);
   END;
   FOR i:=0 TO 3 DO
     TempIText:=IText0[i];
     TempIText.iTextFont := s.ADR(SAttr);
     TempIText.leftEdge  := CalcXValue(TempIText.leftEdge);
     TempIText.topEdge   := CalcYValue(TempIText.topEdge)+OffsetY;
     in.PrintIText(W[0].rPort,TempIText,0,0);
   END;
END RefreshProc00;

PROCEDURE CloseProc00Mask * ;
VAR i:        INTEGER;
    TempNode: e.NodePtr;
BEGIN
   IF W[0]#NIL THEN
      in.CloseWindow(W[0]);
      W[0]:=NIL;
   END;
   IF Men#NIL THEN
      in.ClearMenuStrip(W[0]);
      gt.FreeMenus(Men);
      Men:=NIL;
   END;
   IF congad[0]#NIL THEN
      gt.FreeGadgets(congad[0]);
      congad[0]:=NIL;
   END;
   FOR i:=0 TO 1 DO
      TempNode:=e.RemHead(Liste[i]);
      WHILE TempNode#NIL DO
         IF TempNode.name#NIL THEN
            e.FreeVec(TempNode.name);
         END;
         e.FreeVec(TempNode);
         TempNode:=e.RemHead(Liste[i]);
      END;
   END;
   IF WFont[0]#NIL THEN
      g.CloseFont(WFont[0]);
      WFont[0]:=NIL;
   END;
END CloseProc00Mask;

PROCEDURE InitProc00Mask * (UserTags:ARRAY OF u.Tag): in.WindowPtr;
VAR i,TagCount : INTEGER;
    TempGadget : gt.NewGadget;
    MainList   : TagItemType;
    CopyPtr    : TagItemType;
    TempPtr    : u.TagItemPtr;
    LVCount    : INTEGER;
    UserList, TempItem : TagItemType;
BEGIN
   IF W[0]#NIL THEN RETURN NIL; END;
   WFont[0]:=df.OpenDiskFont(WAttr0);
   IF WFont[0]=NIL THEN RETURN NIL; END;
   es.NewList(Liste[0]);
   es.NewList(Liste[1]);

   IF NOT AddNode(Liste[0],"Mode:      Hires Lace") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0],"Auflösung: 800x600") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0],"Hori. Frq: 81 Hz") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0],"Vert. Frq: 57 kHz") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0]," ") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0],"Special:   Nicht ziehbar") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0],"           Kein Genlock") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[0],"           WB Like") THEN CloseProc00Mask; RETURN NIL; END;

   IF NOT AddNode(Liste[1],"DOMINO:1280x1024") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"DOMINO:1024x768") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"DOMINO:800x600") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"DOMINO:640x480") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"PAL:Hires") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"PAL:Hires Lace") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"PAL:Superhires") THEN CloseProc00Mask; RETURN NIL; END;
   IF NOT AddNode(Liste[1],"PAL:Superhires Lace") THEN CloseProc00Mask; RETURN NIL; END;

   WinLeft   := 41;
   WinTop    := 120;
   CalcFont(633,243);
   WinWidth  :=  CalcXValue(633);
   WinHeight := CalcYValue(243)+OffsetY;
   IF WinLeft + WinWidth > Screen^.width THEN
      WinLeft := Screen^.width - WinWidth;
   END;
   IF WinTop + WinHeight > Screen^.height THEN
      WinTop := Screen^.height - WinHeight;
   END;
   gad:=gt.CreateContext(congad[0]);

   IF gad=NIL THEN CloseProc00Mask; RETURN NIL; END;
   TagCount := 0;
   LVCount  := 0;
   FOR i:=0 TO 27 DO
      TempGadget:=NewG0[i];
      TempGadget.visualInfo := Vi;
      TempGadget.textAttr   := s.ADR(SAttr);
      TempGadget.leftEdge   := CalcXValue(TempGadget.leftEdge);
      TempGadget.topEdge    := CalcYValue(TempGadget.topEdge)+OffsetY;
      TempGadget.width      := CalcXValue(TempGadget.width);
      TempGadget.height     := CalcYValue(TempGadget.height);
      IF Kinds0[i]=gt.listViewKind THEN
         CopyPtr := u.CloneTagItems(s.VAL(TagItemType,s.ADR(Tags0[TagCount]))^);
         IF CopyPtr#NIL THEN
            TempPtr := u.FindTagItem(gt.lvLabels, CopyPtr^);
            IF TempPtr#NIL THEN
               TempPtr^.data:=s.ADR(Liste[LVCount]);
            END;
            gad := gt.CreateGadgetA(Kinds0[i],gad,TempGadget,CopyPtr^);
            IF gad=NIL THEN CloseProc00Mask; RETURN NIL; END;
            G0[i]:=gad;
            u.FreeTagItems(CopyPtr^);
         END;
         INC(LVCount);
      ELSE
         gad := gt.CreateGadgetA(Kinds0[i],gad,TempGadget,s.VAL(TagItemType,s.ADR(Tags0[TagCount]))^);
         IF gad=NIL THEN CloseProc00Mask; RETURN NIL; END;
         G0[i]:=gad;
      END;
      IF Kinds0[i]=gt.buttonKind THEN
         IF TempGadget.userData#NIL THEN
            INCL(gad.activation,in.toggleSelect);
         END;
         IF s.VAL(LONGINT,TempGadget.userData)>1 THEN
            INCL(gad.flags,in.selected);
         END;
      END;
      WHILE Tags0[TagCount]#u.done DO INC(TagCount,2) END;
      INC(TagCount);
   END;

   MainList:=u.CloneTagItems(s.VAL(TagItemType,s.ADR(WTags0))^);
   IF MainList=NIL THEN CloseProc00Mask; RETURN NIL; END;
   MainList[0].data:=Screen;
   MainList[1].data:=congad[0];
   MainList[2].data:=CenterX(WinWidth);
   MainList[3].data:=CenterY(WinHeight);
   MainList[4].data:=WinWidth;
   MainList[5].data:=WinHeight;

   UserList:=u.CloneTagItems(s.VAL(TagItemType,s.ADR(UserTags))^);
   IF UserList=NIL THEN
      u.FreeTagItems(MainList^);
      CloseProc00Mask;
      RETURN NIL;
   END;
   u.FilterTagChanges(UserList^,MainList^,TRUE); 
   TempItem:=MainList; i:=0;
   WHILE TempItem[i].tag#u.done DO INC(i); END;
   TempItem[i].tag  := u.more;
   TempItem[i].data := UserList;
   W[0]:=in.OpenWindowTagListA(NIL,MainList^);
   u.FreeTagItems(MainList^);
   u.FreeTagItems(UserList^);
   IF W[0]#NIL THEN
      gt.RefreshWindow(W[0],NIL);
      Men:=gt.CreateMenus(NewM0,u.done);
      IF NOT gt.LayoutMenus(Men,Vi,gtNewLookMenu,in.LTRUE,u.done) THEN 
         CloseProc00Mask;
         RETURN NIL;
      END;
      IF NOT in.SetMenuStrip(W[0],Men^) THEN CloseProc00Mask; RETURN NIL; END;
      RefreshProc00;
      RETURN W[0];
   ELSE
      RETURN NIL;
   END;
END InitProc00Mask;

PROCEDURE GetProc00GPtr * (Nummer:INTEGER): in.GadgetPtr;
BEGIN
   IF (Nummer>=0) AND (Nummer<=27) THEN
      RETURN G0[Nummer];
   ELSE
      RETURN NIL;
   END;
END GetProc00GPtr;

PROCEDURE RefreshProc01 * ;
VAR  i         : INTEGER;
     CopyPtr   : TagItemType;
     TempPtr   : u.TagItemPtr;
     TagCount  : INTEGER;
     TempIText : in.IntuiText;
     left,top,width,height : INTEGER;
BEGIN
   TagCount:=0;
   FOR i:=0 TO 11 DO
      CopyPtr :=u.CloneTagItems(s.VAL(TagItemType,s.ADR(BevelTags1[TagCount]))^);
      IF CopyPtr#NIL THEN
         TempPtr := u.FindTagItem(gt.visualInfo,CopyPtr^);
         IF TempPtr#NIL THEN
            TempPtr^.data:=Vi;
         left   := CalcXValue(Bevel1[i*4]);
         top    := CalcYValue(Bevel1[i*4+1])+OffsetY;
         width  := CalcXValue(Bevel1[i*4+2]);
         height := CalcYValue(Bevel1[i*4+3]);
         gt.DrawBevelBoxA(W[1]^.rPort,left,top,width,height,CopyPtr^);
         END;
         u.FreeTagItems(CopyPtr^);
      END;
      WHILE BevelTags1[TagCount]#u.done DO INC(TagCount,2) END;
      INC(TagCount);
   END;
   FOR i:=0 TO 3 DO
     TempIText:=IText1[i];
     TempIText.iTextFont := s.ADR(SAttr);
     TempIText.leftEdge  := CalcXValue(TempIText.leftEdge);
     TempIText.topEdge   := CalcYValue(TempIText.topEdge)+OffsetY;
     in.PrintIText(W[1].rPort,TempIText,0,0);
   END;
END RefreshProc01;

PROCEDURE CloseProc01Mask * ;
VAR i:        INTEGER;
    TempNode: e.NodePtr;
BEGIN
   IF W[1]#NIL THEN
      in.CloseWindow(W[1]);
      W[1]:=NIL;
   END;
   IF Menu00#NIL THEN
      in.ClearMenuStrip(W[1]);
      gt.FreeMenus(Menu00);
      Menu00:=NIL;
   END;
   IF congad[1]#NIL THEN
      gt.FreeGadgets(congad[1]);
      congad[1]:=NIL;
   END;
   FOR i:=0 TO 1 DO
      TempNode:=e.RemHead(ListViewList00[i]);
      WHILE TempNode#NIL DO
         IF TempNode.name#NIL THEN
            e.FreeVec(TempNode.name);
         END;
         e.FreeVec(TempNode);
         TempNode:=e.RemHead(ListViewList00[i]);
      END;
   END;
   IF WFont[1]#NIL THEN
      g.CloseFont(WFont[1]);
      WFont[1]:=NIL;
   END;
END CloseProc01Mask;

PROCEDURE InitProc01Mask * (UserTags:ARRAY OF u.Tag): in.WindowPtr;
VAR i,TagCount : INTEGER;
    TempGadget : gt.NewGadget;
    MainList   : TagItemType;
    CopyPtr    : TagItemType;
    TempPtr    : u.TagItemPtr;
    LVCount    : INTEGER;
    UserList, TempItem : TagItemType;
BEGIN
   IF W[1]#NIL THEN RETURN NIL; END;
   WFont[1]:=df.OpenDiskFont(WAttr1);
   IF WFont[1]=NIL THEN RETURN NIL; END;
   es.NewList(ListViewList00[0]);
   es.NewList(ListViewList00[1]);

   IF NOT AddNode(ListViewList00[0],"Mode:      Hires Lace") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0],"Auflösung: 800x600") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0],"Hori. Frq: 81 Hz") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0],"Vert. Frq: 57 kHz") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0]," ") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0],"Special:   Nicht ziehbar") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0],"           Kein Genlock") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[0],"           WB Like") THEN CloseProc01Mask; RETURN NIL; END;

   IF NOT AddNode(ListViewList00[1],"DOMINO:1280x1024") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"DOMINO:1024x768") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"DOMINO:800x600") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"DOMINO:640x480") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"PAL:Hires") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"PAL:Hires Lace") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"PAL:Superhires") THEN CloseProc01Mask; RETURN NIL; END;
   IF NOT AddNode(ListViewList00[1],"PAL:Superhires Lace") THEN CloseProc01Mask; RETURN NIL; END;

   WinLeft   := 41;
   WinTop    := 120;
   CalcFont(633,243);
   WinWidth  :=  CalcXValue(633);
   WinHeight := CalcYValue(243)+OffsetY;
   IF WinLeft + WinWidth > Screen^.width THEN
      WinLeft := Screen^.width - WinWidth;
   END;
   IF WinTop + WinHeight > Screen^.height THEN
      WinTop := Screen^.height - WinHeight;
   END;
   gad:=gt.CreateContext(congad[1]);

   IF gad=NIL THEN CloseProc01Mask; RETURN NIL; END;
   TagCount := 0;
   LVCount  := 0;
   FOR i:=0 TO 27 DO
      TempGadget:=NewG1[i];
      TempGadget.visualInfo := Vi;
      TempGadget.textAttr   := s.ADR(SAttr);
      TempGadget.leftEdge   := CalcXValue(TempGadget.leftEdge);
      TempGadget.topEdge    := CalcYValue(TempGadget.topEdge)+OffsetY;
      TempGadget.width      := CalcXValue(TempGadget.width);
      TempGadget.height     := CalcYValue(TempGadget.height);
      IF Kinds1[i]=gt.listViewKind THEN
         CopyPtr := u.CloneTagItems(s.VAL(TagItemType,s.ADR(Tags1[TagCount]))^);
         IF CopyPtr#NIL THEN
            TempPtr := u.FindTagItem(gt.lvLabels, CopyPtr^);
            IF TempPtr#NIL THEN
               TempPtr^.data:=s.ADR(ListViewList00[LVCount]);
            END;
            gad := gt.CreateGadgetA(Kinds1[i],gad,TempGadget,CopyPtr^);
            IF gad=NIL THEN CloseProc01Mask; RETURN NIL; END;
            GPtrs00[i]:=gad;
            u.FreeTagItems(CopyPtr^);
         END;
         INC(LVCount);
      ELSE
         gad := gt.CreateGadgetA(Kinds1[i],gad,TempGadget,s.VAL(TagItemType,s.ADR(Tags1[TagCount]))^);
         IF gad=NIL THEN CloseProc01Mask; RETURN NIL; END;
         GPtrs00[i]:=gad;
      END;
      IF Kinds1[i]=gt.buttonKind THEN
         IF TempGadget.userData#NIL THEN
            INCL(gad.activation,in.toggleSelect);
         END;
         IF s.VAL(LONGINT,TempGadget.userData)>1 THEN
            INCL(gad.flags,in.selected);
         END;
      END;
      WHILE Tags1[TagCount]#u.done DO INC(TagCount,2) END;
      INC(TagCount);
   END;

   MainList:=u.CloneTagItems(s.VAL(TagItemType,s.ADR(WTags1))^);
   IF MainList=NIL THEN CloseProc01Mask; RETURN NIL; END;
   MainList[0].data:=Screen;
   MainList[1].data:=congad[1];
   MainList[2].data:=CenterX(WinWidth);
   MainList[3].data:=CenterY(WinHeight);
   MainList[4].data:=WinWidth;
   MainList[5].data:=WinHeight;

   UserList:=u.CloneTagItems(s.VAL(TagItemType,s.ADR(UserTags))^);
   IF UserList=NIL THEN
      u.FreeTagItems(MainList^);
      CloseProc01Mask;
      RETURN NIL;
   END;
   u.FilterTagChanges(UserList^,MainList^,TRUE); 
   TempItem:=MainList; i:=0;
   WHILE TempItem[i].tag#u.done DO INC(i); END;
   TempItem[i].tag  := u.more;
   TempItem[i].data := UserList;
   W[1]:=in.OpenWindowTagListA(NIL,MainList^);
   u.FreeTagItems(MainList^);
   u.FreeTagItems(UserList^);
   IF W[1]#NIL THEN
      gt.RefreshWindow(W[1],NIL);
      Menu00:=gt.CreateMenus(NewM1,u.done);
      IF NOT gt.LayoutMenus(Menu00,Vi,gtNewLookMenu,in.LTRUE,u.done) THEN 
         CloseProc01Mask;
         RETURN NIL;
      END;
      IF NOT in.SetMenuStrip(W[1],Menu00^) THEN CloseProc01Mask; RETURN NIL; END;
      RefreshProc01;
      RETURN W[1];
   ELSE
      RETURN NIL;
   END;
END InitProc01Mask;

PROCEDURE GetProc01GPtr * (Nummer:INTEGER): in.GadgetPtr;
BEGIN
   IF (Nummer>=0) AND (Nummer<=27) THEN
      RETURN GPtrs00[Nummer];
   ELSE
      RETURN NIL;
   END;
END GetProc01GPtr;

PROCEDURE FreeTest * ;
VAR Result:    BOOLEAN;
BEGIN
   CloseProc00Mask;
   CloseProc01Mask;
   IF Vi#NIL THEN
      gt.FreeVisualInfo(Vi);
      Vi:=NIL;
   END;
   IF OwnScreen THEN
      IF Screen#NIL THEN
         Result:=in.CloseScreen(Screen);
      END;
   END;
   Screen:=NIL;
   IF SFont#NIL THEN
      g.CloseFont(SFont);
      SFont:=NIL;
   END;
END FreeTest;

PROCEDURE InitTest * (S:in.ScreenPtr;UserTags:ARRAY OF u.Tag): BOOLEAN;
VAR MainList : TagItemType;
    UserList, TempItem : TagItemType;
    i : INTEGER;
BEGIN
   IF Screen#NIL THEN RETURN TRUE; END;
   IF S=NIL THEN
      OwnScreen:=TRUE;
      SAttr.name:=s.ADR("topaz-classic.font");
      SAttr.ySize:=8;
      SFont:=df.OpenDiskFont(SAttr);
      IF SFont=NIL THEN RETURN FALSE; END;
      MainList:=u.CloneTagItems(s.VAL(TagItemType,s.ADR(STags))^);
      IF MainList=NIL THEN FreeTest; RETURN FALSE; END;
      MainList[0].data:=s.ADR(SAttr);
      UserList:=u.CloneTagItems(s.VAL(TagItemType,s.ADR(UserTags))^);
      IF UserList=NIL THEN
         u.FreeTagItems(MainList^);
         FreeTest;
         RETURN FALSE;
      END;
      u.FilterTagChanges(UserList^,MainList^,TRUE); 
      TempItem:=MainList; i:=0;
      WHILE TempItem[i].tag#u.done DO INC(i); END;
      TempItem[i].tag  := u.more;
      TempItem[i].data := UserList;
      Screen:=in.OpenScreenTagListA(NIL,MainList^);
      u.FreeTagItems(MainList^);
      u.FreeTagItems(UserList^);
      IF Screen=NIL THEN
         FreeTest;
         RETURN FALSE;
      END;
   ELSE
      OwnScreen := FALSE;
      Screen:=S;
   END;
   CalcFont(0,0);
   Vi:=gt.GetVisualInfo(Screen,u.done);
   IF Vi=NIL THEN
      FreeTest;
      RETURN FALSE;
   END;
   RETURN TRUE;
END InitTest;

END Test.
