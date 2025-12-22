IMPLEMENTATION MODULE Test;

(* Erstellt mit GadEd V1.10 *)
(* Geschrieben von Michael Neumann und Thomas Patschinski *)

FROM SYSTEM      IMPORT ADR,ADDRESS,TAG,BITSET,CAST;
FROM ExecSupport IMPORT NewList;
FROM ExecD       IMPORT NodePtr,ListPtr,Node,List,MemReqs,MemReqSet;
FROM ExecL       IMPORT AddTail,FreeVec,AllocVec,RemHead;
FROM DiskFontL   IMPORT OpenDiskFont;
FROM GraphicsL   IMPORT CloseFont,GetVPModeID;
FROM GraphicsD   IMPORT TextAttr,DrawModes,DrawModeSet,FontStyleSet,
                        FontFlags,FontFlagSet,TextFontPtr,Rectangle;
FROM IntuitionL  IMPORT OpenWindowTagList,CloseWindow,PrintIText,
                        OpenScreenTagList,CloseScreen,SetMenuStrip,
                        ClearMenuStrip,QueryOverscan;
FROM IntuitionD  IMPORT WindowPtr,ScreenPtr,GadgetPtr,IDCMPFlags,
                        IDCMPFlagSet,GaTags,WindowFlags,WindowFlagSet,
                        WaTags,LayoutaTags,PgaTags,IntuiText,IntuiTextPtr,
                        SaTags,oScanText,oScanMax,oScanStandard,oScanVideo,
                        ActivationFlags,ActivationFlagSet,StringaTags,
                        MenuItemFlags,MenuItemFlagSet,GadgetFlags,GadgetFlagSet;
FROM GadToolsD   IMPORT NewGadget,GtTags,NewGadgetFlags,NewGadgetFlagSet,
                        StrPtr,buttonKind,buttonIDCMP,checkboxKind,checkboxIDCMP,
                        integerKind,integerIDCMP,listviewKind,listviewIDCMP,
                        mxKind,mxIDCMP,numberKind,numberIDCMP,cycleKind,
                        cycleIDCMP,paletteKind,paletteIDCMP,scrollerKind,
                        scrollerIDCMP,sliderKind,sliderIDCMP,stringKind,
                        stringIDCMP,textKind,textIDCMP,NewMenu,nmTitle,nmItem,
                        nmSub,nmEnd,nmBarlabel,menuDisabled,gtnmFrontPen,
                        gtnmBackPen,gtnmJustification,gtnmClipped;
FROM GadToolsL   IMPORT CreateContext,CreateGadgetA,GetVisualInfoA,
                        FreeVisualInfo,GTRefreshWindow,FreeGadgets,DrawBevelBoxA,
                        CreateMenusA,LayoutMenusA,FreeMenus;
FROM String      IMPORT Copy,Length;
FROM UtilityD    IMPORT tagDone,tagMore,Tag,TagItem,TagItemPtr;
FROM UtilityL    IMPORT CloneTagItems,FindTagItem,FilterTagChanges,FreeTagItems;

CONST
    LTRUE  = CAST(ADDRESS,TRUE);
    LFALSE = CAST(ADDRESS,FALSE);

VAR tags:	 ARRAY [0..31] OF TagItem;
    congad:     ARRAY [0..0] OF GadgetPtr;
    TagCount:   INTEGER;
    W:          ARRAY [0..0] OF WindowPtr;
    gad:        GadgetPtr;
    Vi:         ADDRESS;
    Screen:     ScreenPtr;
    OwnScreen:  BOOLEAN;
    Pens :=     INTEGER {-1};
    SFont:      TextFontPtr;
    WFont:      ARRAY [0..0] OF TextFontPtr;
    OffsetY:    INTEGER;
    G0:         ARRAY [0..27] OF GadgetPtr;

    SAttr := TextAttr {name:ADR("topaz-classic.font"),ySize:8};

TYPE STagsType = ARRAY [0..23] OF ADDRESS;
VAR  STags := STagsType {
         CAST(ADDRESS,saTop),0,
         CAST(ADDRESS,saPens),ADR(Pens),
         CAST(ADDRESS,saWidth),724,
         CAST(ADDRESS,saHeight),564,
         CAST(ADDRESS,saDepth),2,
         CAST(ADDRESS,saDisplayID),000029004H,
         CAST(ADDRESS,saTitle),ADR("Gadget Test Screen"),
         CAST(ADDRESS,saFont),ADR(SAttr),
         CAST(ADDRESS,saFullPalette),LTRUE,
         CAST(ADDRESS,saShowTitle),LTRUE,
         CAST(ADDRESS,saOverscan),CAST(ADDRESS,oScanText),
         CAST(ADDRESS,tagDone),NIL};

(* Definitionen für Fenster Proc000*)

WAttr0 := TextAttr {name:ADR("topaz-classic.font"),ySize:8};

TYPE NewG0Type = ARRAY [0..27] OF NewGadget;
VAR  NewG0 := NewG0Type {
 NewGadget {leftEdge:115,topEdge:71,width:67,height:12,textAttr:ADR(WAttr0),gadgetText:ADR("Tel_. Nummer:"),gadgetID:0,flags:NewGadgetFlagSet{placetextLeft}},
 NewGadget {leftEdge:115,topEdge:83,width:67,height:12,textAttr:ADR(WAttr0),gadgetText:ADR("_Haus Nummer:"),gadgetID:1,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:115,topEdge:212,width:234,height:12,textAttr:ADR(WAttr0),gadgetText:ADR("Copyright b_y"),gadgetID:2,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:115,topEdge:224,width:234,height:12,textAttr:ADR(WAttr0),gadgetText:ADR("Copyright b_y"),gadgetID:3,flags:NewGadgetFlagSet{placetextLeft}},
 NewGadget {leftEdge:15,topEdge:18,width:92,height:21,textAttr:ADR(WAttr0),gadgetText:ADR("Button"),gadgetID:4,flags:NewGadgetFlagSet{placetextIn},userData:CAST(ADDRESS,1)},
 NewGadget {leftEdge:15,topEdge:39,width:92,height:21,textAttr:ADR(WAttr0),gadgetText:ADR("_Ok"),gadgetID:5,flags:NewGadgetFlagSet{placetextIn}},
 NewGadget {leftEdge:107,topEdge:18,width:92,height:21,textAttr:ADR(WAttr0),gadgetText:ADR("_Under"),gadgetID:6,flags:NewGadgetFlagSet{placetextIn},userData:CAST(ADDRESS,2)},
 NewGadget {leftEdge:107,topEdge:39,width:92,height:21,textAttr:ADR(WAttr0),gadgetText:ADR("Special !"),gadgetID:7,flags:NewGadgetFlagSet{placetextIn}},
 NewGadget {leftEdge:217,topEdge:17,width:26,height:11,textAttr:ADR(WAttr0),gadgetText:ADR("Checkbo_x"),gadgetID:8,flags:NewGadgetFlagSet{placetextRight,ngHighlabel}},
 NewGadget {leftEdge:217,topEdge:28,width:26,height:11,textAttr:ADR(WAttr0),gadgetText:ADR("_Gfx"),gadgetID:9,flags:NewGadgetFlagSet{placetextRight}},
 NewGadget {leftEdge:217,topEdge:39,width:26,height:11,textAttr:ADR(WAttr0),gadgetText:ADR("Text _Modus"),gadgetID:10,flags:NewGadgetFlagSet{placetextRight}},
 NewGadget {leftEdge:217,topEdge:50,width:26,height:11,textAttr:ADR(WAttr0),gadgetText:ADR("Nicht umschalten"),gadgetID:11,flags:NewGadgetFlagSet{placetextRight}},
 NewGadget {leftEdge:393,topEdge:30,width:227,height:49,textAttr:ADR(WAttr0),gadgetText:ADR("Info Box"),gadgetID:12,flags:NewGadgetFlagSet{placetextAbove,ngHighlabel}},
 NewGadget {leftEdge:393,topEdge:90,width:227,height:71,textAttr:ADR(WAttr0),gadgetText:ADR("Screen Mode:"),gadgetID:13,flags:NewGadgetFlagSet{placetextAbove}},
 NewGadget {leftEdge:248,topEdge:72,width:16,height:8,textAttr:ADR(WAttr0),gadgetText:ADR("3.x"),gadgetID:14,flags:NewGadgetFlagSet{placetextRight,ngHighlabel}},
 NewGadget {leftEdge:230,topEdge:72,width:16,height:8,textAttr:ADR(WAttr0),gadgetText:ADR("\o"),gadgetID:15,flags:NewGadgetFlagSet{placetextLeft}},
 NewGadget {leftEdge:89,topEdge:104,width:87,height:10,textAttr:ADR(WAttr0),gadgetText:ADR("Fast Ram"),gadgetID:16,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:89,topEdge:114,width:87,height:10,textAttr:ADR(WAttr0),gadgetText:ADR("Chip Ram"),gadgetID:17,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:61,topEdge:135,width:122,height:12,textAttr:ADR(WAttr0),gadgetText:ADR("Mo_dus"),gadgetID:18,flags:NewGadgetFlagSet{placetextLeft}},
 NewGadget {leftEdge:61,topEdge:147,width:122,height:12,textAttr:ADR(WAttr0),gadgetText:ADR("Mo_dus"),gadgetID:19,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:83,topEdge:167,width:160,height:19,textAttr:ADR(WAttr0),gadgetText:ADR("Farb_wahl"),gadgetID:20,flags:NewGadgetFlagSet{placetextLeft}},
 NewGadget {leftEdge:83,topEdge:186,width:160,height:19,textAttr:ADR(WAttr0),gadgetText:ADR("Farb_wahl"),gadgetID:21,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:332,topEdge:72,width:24,height:73,textAttr:ADR(WAttr0),gadgetText:ADR("Q\o"),gadgetID:22,flags:NewGadgetFlagSet{placetextBelow,ngHighlabel}},
 NewGadget {leftEdge:356,topEdge:72,width:24,height:73,textAttr:ADR(WAttr0),gadgetText:ADR("Q\o"),gadgetID:23,flags:NewGadgetFlagSet{placetextBelow}},
 NewGadget {leftEdge:311,topEdge:170,width:281,height:17,textAttr:ADR(WAttr0),gadgetText:ADR("Anfang"),gadgetID:24,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:311,topEdge:187,width:281,height:17,textAttr:ADR(WAttr0),gadgetText:ADR("Ende"),gadgetID:25,flags:NewGadgetFlagSet{placetextLeft}},
 NewGadget {leftEdge:441,topEdge:213,width:184,height:11,textAttr:ADR(WAttr0),gadgetText:ADR("Fix Text"),gadgetID:26,flags:NewGadgetFlagSet{placetextLeft,ngHighlabel}},
 NewGadget {leftEdge:441,topEdge:224,width:184,height:11,textAttr:ADR(WAttr0),gadgetText:ADR("Fix Text"),gadgetID:27,flags:NewGadgetFlagSet{placetextLeft}}
};

TYPE Kinds0Type = ARRAY [0..27] OF LONGCARD;
VAR  Kinds0 := Kinds0Type {
        integerKind,
        integerKind,
        stringKind,
        stringKind,
        buttonKind,
        buttonKind,
        buttonKind,
        buttonKind,
        checkboxKind,
        checkboxKind,
        checkboxKind,
        checkboxKind,
        listviewKind,
        listviewKind,
        mxKind,
        mxKind,
        numberKind,
        numberKind,
        cycleKind,
        cycleKind,
        paletteKind,
        paletteKind,
        scrollerKind,
        scrollerKind,
        sliderKind,
        sliderKind,
        textKind,
        textKind
     };

TYPE MxText0_0Type = ARRAY [0..4] OF ADDRESS;
VAR  MxText0_0 := MxText0_0Type {
        ADR("_Domino"),
        ADR("_Pal"),
        ADR("_Ntsc"),
        ADR("N_ichts"),
        NIL
     };

TYPE MxText0_1Type = ARRAY [0..9] OF ADDRESS;
VAR  MxText0_1 := MxText0_1Type {
        ADR("1\o"),
        ADR("2\o"),
        ADR("4\o"),
        ADR("8\o"),
        ADR("16"),
        ADR("32"),
        ADR("64"),
        ADR("128"),
        ADR("256"),
        NIL
     };

TYPE CycleText0_0Type = ARRAY [0..3] OF ADDRESS;
VAR  CycleText0_0 := CycleText0_0Type {
        ADR("Pause"),
        ADR("Step"),
        ADR("Run"),
        NIL
     };

TYPE CycleText0_1Type = ARRAY [0..3] OF ADDRESS;
VAR  CycleText0_1 := CycleText0_1Type {
        ADR("Pause"),
        ADR("Step"),
        ADR("Run"),
        NIL
     };

TYPE Tags0Type = ARRAY [0..181] OF ADDRESS;
VAR  Tags0 := Tags0Type {
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtinNumber),4711,
        CAST(ADDRESS,stringaReplaceMode),LTRUE,
        CAST(ADDRESS,stringaExitHelp),LTRUE,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtinNumber),1,
        CAST(ADDRESS,gtinMaxChars),7,
        CAST(ADDRESS,stringaJustification),000000200H,
        CAST(ADDRESS,gaTabCycle),LFALSE,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtstString),ADR("Thomas Patschinski"),
        CAST(ADDRESS,stringaReplaceMode),LTRUE,
        CAST(ADDRESS,stringaJustification),000000200H,
        CAST(ADDRESS,gtstMaxChars),79,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtstString),ADR("Michael Neumann"),
        CAST(ADDRESS,gtstMaxChars),255,
        tagDone,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        tagDone,
        CAST(ADDRESS,gaDisabled),LTRUE,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtcbChecked),LTRUE,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtcbChecked),LTRUE,
        tagDone,
        CAST(ADDRESS,gaDisabled),LTRUE,
        tagDone,
        CAST(ADDRESS,gtlvReadOnly),LTRUE,
        CAST(ADDRESS,gtlvLabels),ADR(ListViewList0[0]),
        CAST(ADDRESS,layoutaSpacing),2,
        tagDone,
        CAST(ADDRESS,gtlvScrollWidth),24,
        CAST(ADDRESS,gtlvShowSelected),NIL,
        CAST(ADDRESS,gtlvLabels),ADR(ListViewList0[1]),
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtmxSpacing),2,
        CAST(ADDRESS,gtmxLabels),ADR(MxText0_0),
        tagDone,
        CAST(ADDRESS,gtmxSpacing),2,
        CAST(ADDRESS,gtmxLabels),ADR(MxText0_1),
        tagDone,
        CAST(ADDRESS,gtnmBorder),LTRUE,
        CAST(ADDRESS,gtnmNumber),11893096,
        tagDone,
        CAST(ADDRESS,gtnmBorder),LTRUE,
        CAST(ADDRESS,gtnmNumber),1904760,
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtcyLabels),ADR(CycleText0_0),
        tagDone,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gaDisabled),LTRUE,
        CAST(ADDRESS,gtcyLabels),ADR(CycleText0_1),
        tagDone,
        CAST(ADDRESS,gtpaDepth),2,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gaDisabled),LTRUE,
        tagDone,
        CAST(ADDRESS,gtpaDepth),2,
        CAST(ADDRESS,gtUnderscore),ORD("_"),
        CAST(ADDRESS,gtpaIndicatorWidth),32,
        tagDone,
        CAST(ADDRESS,gaDisabled),LTRUE,
        CAST(ADDRESS,gtscTotal),10,
        CAST(ADDRESS,gtscVisible),3,
        CAST(ADDRESS,gtscArrows),16,
        CAST(ADDRESS,pgaFreedom),2,
        CAST(ADDRESS,gaRelVerify),LTRUE,
        CAST(ADDRESS,gaImmediate),LTRUE,
        tagDone,
        CAST(ADDRESS,gtscTop),9,
        CAST(ADDRESS,gtscTotal),11,
        CAST(ADDRESS,gtscArrows),16,
        CAST(ADDRESS,pgaFreedom),2,
        tagDone,
        CAST(ADDRESS,gtslLevel),3,
        CAST(ADDRESS,gtslMaxLevelLen),4,
        CAST(ADDRESS,gtslLevelFormat),ADR("%ld "),
        CAST(ADDRESS,gtslLevelPlace),CAST(ADDRESS,NewGadgetFlagSet{placetextRight}),
        tagDone,
        CAST(ADDRESS,gaDisabled),LTRUE,
        CAST(ADDRESS,gtslLevel),15,
        CAST(ADDRESS,gtslMaxLevelLen),3,
        CAST(ADDRESS,gtslLevelFormat),ADR("%ld "),
        CAST(ADDRESS,gtslLevelPlace),CAST(ADDRESS,NewGadgetFlagSet{placetextRight}),
        tagDone,
        CAST(ADDRESS,gttxBorder),LTRUE,
        CAST(ADDRESS,gttxText),ADR("GadEd Version 1.10"),
        CAST(ADDRESS,gttxCopyText),LTRUE,
        tagDone,
        CAST(ADDRESS,gttxBorder),LTRUE,
        CAST(ADDRESS,gttxText),ADR("<Empty>"),
        tagDone
     };

TYPE IText0Type = ARRAY [0..3] OF IntuiText;
VAR  IText0 := IText0Type {
 IntuiText {frontPen:3,backPen:2,drawMode:DrawModeSet{dm0},leftEdge:267,topEdge:126,iText:ADR("Das ist"),iTextFont:ADR(WAttr0)},
 IntuiText {frontPen:1,backPen:0,drawMode:DrawModeSet{dm0,inversvid},leftEdge:283,topEdge:144,iText:ADR("Intui"),iTextFont:ADR(WAttr0)},
 IntuiText {frontPen:1,backPen:3,drawMode:DrawModeSet{dm0},leftEdge:291,topEdge:153,iText:ADR("Text"),iTextFont:ADR(WAttr0)},
 IntuiText {frontPen:1,backPen:2,drawMode:DrawModeSet{dm0},leftEdge:299,topEdge:135,iText:ADR("ein"),iTextFont:ADR(WAttr0)}
};

TYPE NewM0Type = ARRAY [0..29] OF NewMenu;
VAR  NewM0 := NewM0Type {
 NewMenu {type:nmTitle,label:ADR("Projekt")},
 NewMenu {type:nmItem,label:ADR("About"),commKey:ADR("A\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:nmBarlabel,itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("Load"),commKey:ADR("L\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("Save"),commKey:ADR("S\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:nmBarlabel,itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("Quit"),commKey:ADR("Q\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmTitle,label:ADR("Buffer")},
 NewMenu {type:nmItem,label:ADR("Cut"),commKey:ADR("C\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("Paste"),commKey:ADR("P\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("Copy"),commKey:ADR("O\o"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmTitle,label:ADR("Settings")},
 NewMenu {type:nmItem,label:ADR("Special"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmSub,label:ADR("Betatester Info"),itemFlags:MenuItemFlagSet{menuToggle,checkIt,itemEnabled}},
 NewMenu {type:nmSub,label:ADR("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmSub,label:ADR("Extendet Features"),itemFlags:MenuItemFlagSet{menuToggle,checkIt}},
 NewMenu {type:nmItem,label:ADR("Save Icons"),itemFlags:MenuItemFlagSet{menuToggle,checkIt,checked}},
 NewMenu {type:nmItem,label:ADR("Use ENV:"),itemFlags:MenuItemFlagSet{menuToggle,checkIt,checked}},
 NewMenu {type:nmItem,label:ADR("Fast Ram"),itemFlags:MenuItemFlagSet{menuToggle,checkIt}},
 NewMenu {type:nmItem,label:nmBarlabel,itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("Asl Requster"),itemFlags:MenuItemFlagSet{checkIt,checked}},
 NewMenu {type:nmItem,label:ADR("OS 3.x"),itemFlags:MenuItemFlagSet{checkIt}},
 NewMenu {type:nmTitle,label:ADR("Extendet Menu"),menuFlags:BITSET{menuDisabled}},
 NewMenu {type:nmItem,label:ADR("New 1"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("New 2"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:nmBarlabel,itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmItem,label:ADR("New 3"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmSub,label:ADR("New 3_1"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmSub,label:ADR("New 3_2"),itemFlags:MenuItemFlagSet{}},
 NewMenu {type:nmEnd}
};

TYPE Bevel0Type = ARRAY [0..47] OF INTEGER;
VAR  Bevel0 := Bevel0Type {
        7,101,179,27,
        329,68,55,95,
        7,68,179,30,
        7,132,179,31,
        364,210,264,29,
        213,13,171,53,
        7,210,345,29,
        7,165,240,43,
        7,13,203,53,
        188,68,139,95,
        250,165,378,43,
        387,13,241,150
     };

TYPE BevelTags0Type = ARRAY [0..35] OF Tag;
VAR  BevelTags0 := BevelTags0Type {
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone,
        CAST(LONGCARD,gtVisualInfo),NIL,
        tagDone
     };

TYPE WTags0Type = ARRAY [0..27] OF ADDRESS;
VAR  WTags0 := WTags0Type {
        CAST(ADDRESS,waCustomScreen),NIL,
        CAST(ADDRESS,waGadgets),NIL,
        CAST(ADDRESS,waLeft),0,
        CAST(ADDRESS,waTop),0,
        CAST(ADDRESS,waWidth),633,
        CAST(ADDRESS,waInnerHeight),230,
        CAST(ADDRESS,waMinWidth),633,
        CAST(ADDRESS,waMinHeight),243,
        CAST(ADDRESS,waMaxWidth),633,
        CAST(ADDRESS,waMaxHeight),243,
        CAST(ADDRESS,waTitle),ADR("Gadget Test Fenster"),
        CAST(ADDRESS,waIDCMP),CAST(ADDRESS,buttonIDCMP+checkboxIDCMP+integerIDCMP+listviewIDCMP+mxIDCMP+numberIDCMP+cycleIDCMP+paletteIDCMP+scrollerIDCMP+sliderIDCMP+stringIDCMP+textIDCMP+IDCMPFlagSet{newSize,closeWindow}),
        CAST(ADDRESS,waFlags),CAST(ADDRESS,WindowFlagSet{windowDrag,windowDepth,windowClose,activate}),
        CAST(ADDRESS,tagDone),NIL
     };

PROCEDURE AddNode(LVList : ListPtr; Name : ARRAY OF CHAR): BOOLEAN;
VAR TempNode: NodePtr;
    NewStr:     POINTER TO ARRAY [0..255] OF CHAR;
BEGIN
   TempNode:=AllocVec(SIZE(Node),MemReqSet{public,memClear});
   IF TempNode=NIL THEN RETURN FALSE; END;
   AddTail(LVList,TempNode);
   NewStr:=AllocVec(Length(Name)+1,MemReqSet{public,memClear});
   IF NewStr=NIL THEN RETURN FALSE; END;
   TempNode^.name := NewStr;
   Copy(NewStr^,Name);
   RETURN TRUE;
END AddNode;

PROCEDURE RefreshProc000;
VAR
   i : INTEGER;
BEGIN
   TagCount:=0;
   FOR i:=0 TO 11 DO
      BevelTags0[TagCount+1]:=Vi;
      DrawBevelBoxA(W[0]^.rPort,Bevel0[i*4],Bevel0[i*4+1]+OffsetY,
                    Bevel0[i*4+2],Bevel0[i*4+3],
                    ADR(BevelTags0[TagCount]));
      WHILE BevelTags0[TagCount]#tagDone DO INC(TagCount,2); END;
      INC(TagCount);
   END;

   FOR i:=0 TO 3 DO
      PrintIText(W[0]^.rPort,ADR(IText0[i]),0,0+OffsetY);
   END;
END RefreshProc000;

PROCEDURE CloseProc000Mask;
VAR i        : INTEGER;
    TempNode : NodePtr;
BEGIN
   IF W[0]#NIL THEN
      CloseWindow(W[0]);
      W[0]:=NIL;
   END;
   IF Menu0#NIL THEN
      ClearMenuStrip(W[0]);
      FreeMenus(Menu0);
      Menu0:=NIL;
   END;
   IF congad[0]#NIL THEN
      FreeGadgets(congad[0]);
      congad[0]:=NIL;
   END;
   FOR i:=0 TO 1 DO
      TempNode:=RemHead(ADR(ListViewList0[i]));
      WHILE TempNode#NIL DO
         IF TempNode^.name#NIL THEN
            FreeVec(TempNode^.name);
         END;
         FreeVec(TempNode);
         TempNode:=RemHead(ADR(ListViewList0[i]));
      END;
   END;
   IF WFont[0]#NIL THEN
      CloseFont(WFont[0]);
      WFont[0]:=NIL;
   END;
END CloseProc000Mask;

PROCEDURE InitProc000Mask(UserTags:TagItemPtr): WindowPtr;
VAR
   i:                 INTEGER;
   TempPtr:           TagItemPtr;
   MainList, UserList, TempItem : TagItemPtr;
BEGIN
   IF W[0]#NIL THEN RETURN NIL; END;
   WFont[0]:=OpenDiskFont(ADR(WAttr0));
   IF WFont[0]=NIL THEN RETURN NIL; END;

   NewList(ADR(ListViewList0[0]));
   NewList(ADR(ListViewList0[1]));

   IF NOT AddNode(ADR(ListViewList0[0]),"Mode:      Hires Lace") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0]),"Auflösung: 800x600") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0]),"Hori. Frq: 81 Hz") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0]),"Vert. Frq: 57 kHz") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0])," ") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0]),"Special:   Nicht ziehbar") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0]),"           Kein Genlock") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[0]),"           WB Like") THEN CloseProc000Mask; RETURN NIL; END;

   IF NOT AddNode(ADR(ListViewList0[1]),"DOMINO:1280x1024") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"DOMINO:1024x768") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"DOMINO:800x600") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"DOMINO:640x480") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"PAL:Hires") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"PAL:Hires Lace") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"PAL:Superhires") THEN CloseProc000Mask; RETURN NIL; END;
   IF NOT AddNode(ADR(ListViewList0[1]),"PAL:Superhires Lace") THEN CloseProc000Mask; RETURN NIL; END;

   gad:=CreateContext(congad[0]);
   IF gad=NIL THEN CloseProc000Mask; RETURN NIL; END;
   TagCount:=0;
   FOR i:=0 TO 27 DO
      WITH NewG0[i] DO
         visualInfo := Vi;
         INC(topEdge,OffsetY);
      END;
      IF Kinds0[i]=listviewKind THEN
         TempPtr:=FindTagItem(CAST(LONGCARD,gtlvShowSelected),ADR(Tags0[TagCount]));
         IF TempPtr#NIL THEN
            IF TempPtr^.data#0 THEN
               TempPtr^.data:=CAST(LONGCARD,G0[TempPtr^.data-1]);
            END;
         END;
      END;
      gad := CreateGadgetA(Kinds0[i],gad^,NewG0[i],ADR(Tags0[TagCount]));
      IF gad=NIL THEN CloseProc000Mask; RETURN NIL; END;
      G0[i]:=gad;
      IF Kinds0[i]=buttonKind THEN
         IF NewG0[i].userData#NIL THEN
            INCL(gad^.activation,toggleSelect);
         END;
         IF NewG0[i].userData>CAST(ADDRESS,1) THEN
            INCL(gad^.flags,selected);
         END;
      END;
      WHILE Tags0[TagCount]#NIL DO
         INC(TagCount,2);
      END;
      INC(TagCount);
   END;

   WTags0[1]:=Screen;
   WTags0[3]:=congad[0];
   WTags0[5]:=((Screen^.width-633) DIV 2);
   WTags0[7]:=((Screen^.height-243) DIV 2);

   MainList:=CloneTagItems(ADR(WTags0));
   IF MainList=NIL THEN CloseProc000Mask; RETURN NIL; END;
   UserList:=CloneTagItems(UserTags);
   IF UserList=NIL THEN
      FreeTagItems(MainList);
      CloseProc000Mask;
      RETURN NIL;
   END;
   FilterTagChanges(UserList,MainList,TRUE); 
   TempItem:=MainList;
   WHILE TempItem^.tag#tagDone DO INC(TempItem,SIZE(TagItem)); END;
   TempItem^.tag  := tagMore;
   TempItem^.data := CAST(LONGCARD,UserList);
   W[0]:=OpenWindowTagList(NIL,MainList);
   FreeTagItems(MainList);
   FreeTagItems(UserList);

   IF W[0]#NIL THEN
      GTRefreshWindow(W[0],NIL);
      Menu0:=CreateMenusA(ADR(NewM0),TAG(tags,tagDone));
      IF NOT LayoutMenusA(Menu0,Vi,TAG(tags,tagDone)) THEN
         CloseProc000Mask;
         RETURN NIL;
      END;
      IF NOT SetMenuStrip(W[0],Menu0) THEN CloseProc000Mask; RETURN NIL; END;
      RefreshProc000;
      RETURN W[0];
   ELSE
      CloseProc000Mask;
      RETURN NIL;
   END;
END InitProc000Mask;

PROCEDURE GetProc000GPtr(Nummer:INTEGER): GadgetPtr;
BEGIN
   IF (Nummer>=0) AND (Nummer<=27) THEN
      RETURN G0[Nummer];
   ELSE
      RETURN NIL;
   END;
END GetProc000GPtr;

PROCEDURE FreeTest;
BEGIN
   CloseProc000Mask;
   IF Vi#NIL THEN
      FreeVisualInfo(Vi);
      Vi:=NIL;
   END;
   IF OwnScreen THEN
      IF Screen#NIL THEN
         CloseScreen(Screen);
      END;
   END;
   Screen:=NIL;
   IF SFont#NIL THEN
      CloseFont(SFont);
      SFont:=NIL;
   END;
END FreeTest;

PROCEDURE InitTest(S:ScreenPtr;UserTags:TagItemPtr): BOOLEAN;
VAR MainList, UserList, TempItem : TagItemPtr;
BEGIN
   IF Screen#NIL THEN RETURN FALSE; END;
   IF S=NIL THEN
      OwnScreen:=TRUE;
      SFont:=OpenDiskFont(ADR(SAttr));
      IF SFont=NIL THEN RETURN FALSE; END;

      MainList:=CloneTagItems(ADR(STags));
      IF MainList=NIL THEN FreeTest; RETURN FALSE; END;
      UserList:=CloneTagItems(UserTags);
      IF UserList=NIL THEN
         FreeTagItems(MainList);
         FreeTest;
         RETURN FALSE;
      END;
      FilterTagChanges(UserList,MainList,TRUE); 
      TempItem:=MainList;
      WHILE TempItem^.tag#tagDone DO INC(TempItem,SIZE(TagItem)); END;
      TempItem^.tag  := tagMore;
      TempItem^.data := CAST(LONGCARD,UserList);
      Screen:=OpenScreenTagList(NIL,MainList);
      FreeTagItems(MainList);
      FreeTagItems(UserList);

      IF Screen=NIL THEN
         FreeTest;
         RETURN FALSE;
      END;
   ELSE
      OwnScreen := FALSE;
      Screen:=S;
   END;
   OffsetY:=INTEGER(Screen^.font^.ySize)-8;
   Vi:=GetVisualInfoA(Screen,NIL);
   IF Vi=NIL THEN
      FreeTest;
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END;
END InitTest;

END Test.
