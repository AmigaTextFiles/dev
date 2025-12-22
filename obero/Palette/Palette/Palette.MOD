(*---------------------------------------------------------------------------
    :Program.    Palette.mod
    :Author.     Daniel Amor
    :Address.    Ludwigstr. 124, D-70197 Stuttgart, Germany
    :Version.    1.0
    :Date.       31-May-94
    :Copyright.  PD
    :Language.   Oberon-2
    :Translator. Amiga Oberon 3.0
    :Imports.    Palette [da].
    :Contents.   Öffnet Palette-Fenster.
---------------------------------------------------------------------------*)

MODULE Palette;

(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- $TypeChk- *)

IMPORT  e    : Exec,
        I    : Intuition,
        gt   : GadTools,
        g    : Graphics,
        req  : Requests,
        u    : Utility,
        y    : SYSTEM;

CONST
  PaletteCNT        = 9;
  PaletteLeft       = 10;
  PaletteTop        = 15;
  PaletteWidth      = 338;
  PaletteHeight     = 159;
  GDPARED           = 0;
  GDPAGREEN         = 1;
  GDPABLUE          = 2;
  GDPAPALETTE       = 3;
  GDPAOK            = 4;
  GDPALOAD          = 5;
  GDPASAVE          = 6;
  GDPARESET         = 7;
  GDPACANCEL        = 8;

TYPE colourstype256  = ARRAY 769 OF LONGINT;
     colourArray     = ARRAY 31 OF INTEGER;
     colourRecord  * = RECORD
                         AGACol * : colourstype256;
                         NoAGA * :  colourArray;
                       END;

VAR msgptr         : I.IntuiMessagePtr;
    msg            : I.IntuiMessage;
    vp             : g.ViewPortPtr;
    version        : INTEGER;
    Col,Colcopy    : colourRecord;
    VisualInfo     : e.APTR;
    PaletteWnd     : I.WindowPtr;
    PaletteGList   : I.GadgetPtr;
    PaletteGadgets : ARRAY PaletteCNT OF I.GadgetPtr;
    Font           : g.TextAttrPtr;
    Attr           : g.TextAttr;
    FontX, FontY   : INTEGER;
    OffX, OffY     : INTEGER;
    depth          : LONGINT;

TYPE PaletteGTypesArray = ARRAY PaletteCNT OF INTEGER;

CONST PaletteGTypes = PaletteGTypesArray (gt.sliderKind,
                                          gt.sliderKind,
                                          gt.sliderKind,
                                          gt.paletteKind,
                                          gt.buttonKind,
                                          gt.buttonKind,
                                          gt.buttonKind,
                                          gt.buttonKind,
                                          gt.buttonKind);

TYPE PaletteNGadArray = ARRAY PaletteCNT OF gt.NewGadget;

CONST PaletteNGad = PaletteNGadArray (
    83, 8, 242, 13, y.ADR ("Red:    "), NIL, GDPARED, LONGSET {gt.placeTextLeft,gt.highLabel} ,NIL, NIL,
    83, 25, 242, 13, y.ADR ("Green:  "), NIL, GDPAGREEN, LONGSET {gt.placeTextLeft,gt.highLabel} ,NIL, NIL,
    83, 42, 242, 13, y.ADR ("Blue:   "), NIL, GDPABLUE, LONGSET {gt.placeTextLeft,gt.highLabel} ,NIL, NIL,
    11, 88, 314, 47, y.ADR ("_Palette"), NIL, GDPAPALETTE, LONGSET {gt.placeTextAbove} ,NIL, NIL,
    4, 141, 91, 14, y.ADR ("_OK"), NIL, GDPAOK, LONGSET {gt.placeTextIn} ,NIL, NIL,
    83, 58, 76, 14, y.ADR ("_Load..."), NIL, GDPALOAD, LONGSET {gt.placeTextIn} ,NIL, NIL,
    166, 58, 76, 14, y.ADR ("_Save..."), NIL, GDPASAVE, LONGSET {gt.placeTextIn} ,NIL, NIL,
    249, 58, 76, 14, y.ADR ("_Reset"), NIL, GDPARESET, LONGSET {gt.placeTextIn} ,NIL, NIL,
    243, 142, 91, 14, y.ADR ("_Cancel"), NIL, GDPACANCEL, LONGSET {gt.placeTextIn} ,NIL, NIL);

TYPE PaletteGTagsArray = ARRAY    63 OF u.Tag;

VAR PaletteGTags: PaletteGTagsArray;

PROCEDURE ComputeX (value: INTEGER): INTEGER;

BEGIN
  RETURN ((FontX * value) + 4 ) DIV 8;
END ComputeX;

PROCEDURE ComputeY (value: INTEGER): INTEGER;

BEGIN
  RETURN ((FontY * value)  + 4 ) DIV 8;
END ComputeY;

PROCEDURE ComputeFont (width, height: INTEGER; VAR Scr: I.ScreenPtr);

BEGIN
  Font := y. ADR (Attr);
  Font^.name := Scr^.rastPort.font^.message.node.name;
  FontY := Scr^.rastPort.font^.ySize;
  Font^.ySize := FontY;
  FontX := Scr^.rastPort.font^.xSize;

  OffX := Scr^.wBorLeft;
  OffY := Scr^.rastPort.txHeight + Scr^.wBorTop + 1;

  IF (width # 0) AND (height # 0) AND
     (ComputeX (width) + OffX + Scr^.wBorRight > Scr^.width) OR
     (ComputeY (height) + OffY + Scr^.wBorBottom > Scr^.height) THEN
    Font^.name := y.ADR ("topaz.font");
    Font^.ySize := 8;
    FontY := Font^.ySize;
    FontX := Font^.ySize;
  END;
END ComputeFont;

PROCEDURE PaletteRender*;

BEGIN
  gt.DrawBevelBox(PaletteWnd^.rPort, OffX + ComputeX (4),
                  OffY + ComputeY (4),
                  ComputeX (329),
                  ComputeY (134),
                  gt.visualInfo, VisualInfo, gt.bbRecessed, I.LTRUE, u.done);
END PaletteRender;

PROCEDURE OpenPaletteWindow* (depth: LONGINT; Scr: I.ScreenPtr; colornum: INTEGER): INTEGER;

VAR
  ng: gt.NewGadget;
  gad: I.GadgetPtr;
  help: u.TagListPtr;
  lc, tc, lvc, offx, offy: INTEGER;
  wleft, wtop, ww, wh: INTEGER;
BEGIN
  VisualInfo := gt.GetVisualInfo (Scr, u.done);
 IF VisualInfo = NIL THEN RETURN 2 END;

 PaletteGTags := PaletteGTagsArray (
    gt.slMax, 255, gt.slMaxLevelLen, 4, gt.slLevelFormat, y.ADR ("%2ld"), I.pgaFreedom, I.lorientHoriz, I.gaRelVerify, I.LTRUE, u.done,
    gt.slMax, 255, gt.slMaxLevelLen, 4, gt.slLevelFormat, y.ADR ("%2ld"), I.pgaFreedom, I.lorientHoriz, I.gaRelVerify, I.LTRUE, u.done,
    gt.slMax, 255, gt.slMaxLevelLen, 4, gt.slLevelFormat, y.ADR ("%2ld"), I.pgaFreedom, I.lorientHoriz, I.gaRelVerify, I.LTRUE, u.done,
    gt.paDepth, 5, gt.paIndicatorWidth, 50, gt.paColor, 3, gt.paColorOffset, 0, gt.underscore, ORD ('_'), u.done,
    gt.underscore, ORD ('_'), u.done,
    gt.underscore, ORD ('_'), I.gaDisabled, I.LTRUE, u.done,
    gt.underscore, ORD ('_'), I.gaDisabled, I.LTRUE, u.done,
    gt.underscore, ORD ('_'), u.done,
    gt.underscore, ORD ('_'), u.done
  );
  PaletteGTags[34]:=depth;
  PaletteGTags[38]:=colornum;
  version := g.base.libNode.version;
  IF version<39 THEN
    PaletteGTags[1] :=15;
    PaletteGTags[12]:=15;
    PaletteGTags[23]:=15;
  END;

  wleft := PaletteLeft; wtop := PaletteTop;

  ComputeFont (PaletteWidth, PaletteHeight, Scr);

  ww := ComputeX (PaletteWidth);
  wh := ComputeY (PaletteHeight);

  IF wleft + ww + OffX + Scr^.wBorRight > Scr^.width THEN
    wleft := Scr^.width - ww;
  END;
  IF wtop + wh + OffY + Scr^.wBorBottom > Scr^.height THEN
    wtop := Scr^.height - wh;
  END;
  gad := gt.CreateContext (PaletteGList);
  IF gad = NIL THEN RETURN 1 END;

  lc := 0; tc := 0; lvc := 0;
  WHILE lc < PaletteCNT DO
    ng := PaletteNGad[lc];
    ng.visualInfo := VisualInfo;
    ng.textAttr   := Font;
    ng.leftEdge   := OffX + ComputeX (ng.leftEdge);
    ng.topEdge    := OffY + ComputeY (ng.topEdge);
    ng.width      := ComputeX (ng.width);
    ng.height     := ComputeY (ng.height);

    help := u.CloneTagItems (y.VAL (u.TagListPtr, y.ADR (PaletteGTags[tc])));
    IF help = NIL THEN RETURN 8 END;
    gad := gt.CreateGadgetA (PaletteGTypes[lc], gad, ng, help^ );
    u.FreeTagItems (help);
    IF gad = NIL THEN RETURN 2 END;
    PaletteGadgets[lc] := gad;

    WHILE PaletteGTags[tc] # u.done DO INC (tc, 2) END;
    INC (tc);

    INC (lc);
  END; (* WHILE *)
  PaletteWnd := I.OpenWindowTagsA ( NIL,
                    I.waLeft,          wleft,
                    I.waTop,           wtop,
                    I.waWidth,         ww + OffX + Scr^.wBorRight,
                    I.waHeight,        wh + OffY + Scr^.wBorBottom,
                    I.waIDCMP,         gt.sliderIDCMP+gt.paletteIDCMP+gt.buttonIDCMP+LONGSET {I.vanillaKey,I.refreshWindow},
                    I.waFlags,         LONGSET {I.windowDrag,I.windowDepth,I.activate,I.rmbTrap},
                    I.waGadgets,       PaletteGList,
                    I.waTitle,         y.ADR ("Edit Screen Palette"),
                    I.waCustomScreen,  Scr,
                    I.waAutoAdjust,    I.LTRUE,
                    u.done);
  IF PaletteWnd = NIL THEN RETURN 20 END;

  gt.RefreshWindow (PaletteWnd, NIL);

  PaletteRender;

  RETURN 0;
END OpenPaletteWindow;

PROCEDURE ClosePaletteWindow*;
BEGIN
  IF PaletteWnd # NIL THEN
    I.CloseWindow (PaletteWnd);
    PaletteWnd := NIL;
  END;
  IF PaletteGList # NIL THEN
    gt.FreeGadgets (PaletteGList);
    PaletteGList := NIL;
  END;
END ClosePaletteWindow;

PROCEDURE SetColors(VAR ColRec: colourRecord; VAR vp: g.ViewPortPtr; VAR numcolours: LONGINT);

BEGIN
  IF version<39 THEN
    g.LoadRGB4(vp,ColRec.NoAGA,numcolours);
  ELSE
    g.LoadRGB32(vp,ColRec.AGACol);
  END;
END SetColors;

PROCEDURE GetColour(VAR Col: colourRecord; numcolours: LONGINT; Scr: I.ScreenPtr);

VAR i,colo: LONGINT;

BEGIN
  IF version>38 THEN
    g.GetRGB32(Scr^.viewPort.colorMap,0,numcolours,Col.AGACol);
    colo := numcolours*3;
    FOR i:=0 TO colo DO Col.AGACol[colo-i+1]:=Col.AGACol[colo-i]; END;
    Col.AGACol[colo*3+1] := 0;
    Col.AGACol[0]        := 010000H*numcolours;
  ELSE
    FOR i:=0 TO numcolours-1 DO
      Col.NoAGA[i]:=g.GetRGB4(Scr^.viewPort.colorMap,i);
    END;
  END;
END GetColour;

PROCEDURE SetSlider(VAR Col: colourRecord; VAR colornum: INTEGER);

VAR blue,green,red,i : INTEGER;

BEGIN
  IF version>38 THEN
    red   := SHORT(Col.AGACol[colornum*3+1] DIV 001000000H);
    green := SHORT(Col.AGACol[colornum*3+2] DIV 001000000H);
    blue  := SHORT(Col.AGACol[colornum*3+3] DIV 001000000H);
    IF red<0   THEN red  :=256+red; END;
    IF green<0 THEN green:=256+green; END;
    IF blue<0  THEN blue :=256+blue; END;
  ELSE
    red   := y.LSH(Col.NoAGA[colornum],-8);
    green := y.LSH(y.LSH(Col.NoAGA[colornum],8),-12);
    blue  := y.LSH(y.LSH(Col.NoAGA[colornum],12),-12);
  END;
  gt.SetGadgetAttrs(PaletteGadgets[0]^,PaletteWnd,NIL,gt.slLevel,red);
  gt.SetGadgetAttrs(PaletteGadgets[1]^,PaletteWnd,NIL,gt.slLevel,green);
  gt.SetGadgetAttrs(PaletteGadgets[2]^,PaletteWnd,NIL,gt.slLevel,blue);
END SetSlider;

PROCEDURE SetColor(VAR Col: colourRecord; VAR vp: g.ViewPortPtr;
                   VAR colornum: INTEGER; coltype: INTEGER; VAR count: INTEGER);

VAR red,green,blue,colo: INTEGER;

BEGIN
  IF version>38 THEN
    colo:=colornum*3;
    Col.AGACol[colo+coltype]:=count*001000000H;
    g.SetRGB32(vp,colornum,Col.AGACol[colo+1],Col.AGACol[colo+2],Col.AGACol[colo+3]);
  ELSE
    red   := y.LSH(Col.NoAGA[colornum],-8);
    green := y.LSH(y.LSH(Col.NoAGA[colornum],8),-12);
    blue  := y.LSH(y.LSH(Col.NoAGA[colornum],12),-12);
    IF coltype=1 THEN red   := count; END;
    IF coltype=2 THEN green := count; END;
    IF coltype=3 THEN blue  := count; END;
    g.SetRGB4(vp,colornum,red,green,blue);
    red   := y.LSH(red,8);
    green := y.LSH(green,4);
    Col.NoAGA[colornum]:=red+green+blue;
  END;
END SetColor;

PROCEDURE ShowPalette*(Scr: I.ScreenPtr; VAR ColRec: colourRecord; colornum: INTEGER);

VAR quit       : BOOLEAN;
    aktgad     : I.GadgetPtr;
    nummer,info: INTEGER;
    numcolours : INTEGER;

BEGIN
  vp    := y.ADR(Scr^.viewPort);
  depth := Scr^.rastPort.bitMap.depth;
  numcolours := y.LSH(LONG(1),depth);
  req.Assert(OpenPaletteWindow(depth,Scr,colornum)=0,"Unable to open palette window!");
  GetColour(Col,numcolours,Scr);
  IF ColRec.AGACol[0]=NIL THEN
    ColRec:=Col;
  END;
  Colcopy:=Col;
  quit:=FALSE;
  SetSlider(Colcopy,colornum);
  REPEAT
    e.WaitPort(PaletteWnd.userPort);
    msgptr := gt.GetIMsg (PaletteWnd.userPort);
    IF msgptr#NIL THEN
      msg  := msgptr^;
      info := msg.code;
      gt.ReplyIMsg (msgptr);
      IF (I.gadgetUp IN msg.class) THEN
        aktgad:=msg.iAddress;
        nummer:=aktgad.gadgetID;
        IF nummer=GDPACANCEL  THEN SetColors(Col,vp,depth); quit:=TRUE; END;
        IF nummer=GDPARED     THEN SetColor(Colcopy,vp,colornum,1,info); END;
        IF nummer=GDPAGREEN   THEN SetColor(Colcopy,vp,colornum,2,info); END;
        IF nummer=GDPABLUE    THEN SetColor(Colcopy,vp,colornum,3,info); END;
        IF nummer=GDPAOK      THEN quit:=TRUE; END;
        IF nummer=GDPAPALETTE THEN colornum:=info; SetSlider(Colcopy,colornum); END;
        IF nummer=GDPARESET   THEN SetColors(ColRec,vp,depth); GetColour(Colcopy,numcolours,Scr); SetSlider(Colcopy,colornum); END;
      ELSE
        IF (I.mouseMove IN msg.class) THEN
          aktgad:=msg.iAddress;
          nummer:=aktgad.gadgetID;
          IF nummer=GDPARED     THEN SetColor(Colcopy,vp,colornum,1,info); END;
          IF nummer=GDPAGREEN   THEN SetColor(Colcopy,vp,colornum,2,info); END;
          IF nummer=GDPABLUE    THEN SetColor(Colcopy,vp,colornum,3,info); END;
        END;
      END;
    END;
  UNTIL quit;
  ClosePaletteWindow;
END ShowPalette;

END Palette.
