IMPLEMENTATION MODULE MGgui;

(*
 *  Source generated with ModGen V1.0 (17.4.95) by Frank Lömker
 *  ModGen is based on OG V37.11 by Thomas Igracki
 *  OG is based on GenOberon V1.0 by Kai Bolay & Jan van den Baard
 *
 *  GUI generated with GadToolsBox by Jan van den Baard
 *  GUI designed by : Frank Lömker
 *)

IMPORT
  I:=Intuition, gt:=GadTools, u:=Utility, g:=Graphics, e:=Exec, C:=Classes, gf:=GetFile, gfx:=GfxMacros, m2:=M2Lib, y:=SYSTEM;

VAR
  MGGetImage: C.ObjectPtr;
  FontX, FontY: INTEGER;
  OffX, OffY: INTEGER;

TYPE From0LArray = ARRAY [0..2] OF y.STRING;
VAR From0Labels : From0LArray;
VAR
  MGIText: ARRAY [0..0] OF I.IntuiText;
TYPE MGGTypesArray = ARRAY [0..MGCNT-1] OF INTEGER;
VAR MGGTypes : MGGTypesArray;
TYPE MGNGadArray = ARRAY [0..MGCNT-1] OF gt.NewGadget;
VAR MGNGad : POINTER TO MGNGadArray;
TYPE MGGTagsArray = ARRAY [0..  77] OF y.ADDRESS;
VAR MGGTags : POINTER TO MGGTagsArray;

PROCEDURE ComputeX (value: INTEGER): INTEGER;
BEGIN
  RETURN ((FontX * value) + 4 ) DIV 8;
END ComputeX;

PROCEDURE ComputeY (value: INTEGER): INTEGER;
BEGIN
  RETURN ((FontY * value)  + 4 ) DIV 8;
END ComputeY;

PROCEDURE ComputeFont (width, height: INTEGER);
VAR x:INTEGER;
BEGIN
  Font := y.ADR (Attr);
  Font^.ta_Name := Scr^.RastPort.Font^.tf_Message.mn_Node.ln_Name;
  FontY := Scr^.RastPort.Font^.tf_YSize;
  Font^.ta_YSize := FontY;
  FontX := Scr^.RastPort.Font^.tf_XSize;
  IF g.FPB_PROPORTIONAL IN Scr^.RastPort.Font^.tf_Flags THEN
    x:=(g.TextLength (y.ADR(Scr^.RastPort),y.ADR("ABCDHKOP"),8)+7) DIV 8;
    IF x>=FontX THEN FontX:=x;
                ELSE FontX:=(FontX+x) DIV 2; END;
  END;

  OffX := Scr^.WBorLeft;
  OffY := Scr^.RastPort.TxHeight + Scr^.WBorTop + 1;

  IF (width # 0) AND (height # 0) AND
     (ComputeX (width) + OffX + Scr^.WBorRight > Scr^.Width) OR
     (ComputeY (height) + OffY + Scr^.WBorBottom > Scr^.Height) THEN
    Font := y.ADR (Topaz80);
    FontY := 8; FontX := 8;
  END;
END ComputeFont;

PROCEDURE SetupScreen (pub: y.STRING): INTEGER;
BEGIN
  Scr := I.LockPubScreen (pub);
  IF Scr = NIL THEN RETURN 1 END;

  ComputeFont (0, 0);

  VisualInfo := gt.GetVisualInfoA (Scr, NIL);
  IF VisualInfo = NIL THEN RETURN 2 END;

  IF gf.GetFileClass = NIL THEN RETURN 4 END;

  RETURN 0;
END SetupScreen;

PROCEDURE CloseDownScreen;
BEGIN
  IF VisualInfo # NIL THEN
    gt.FreeVisualInfo (VisualInfo);
    VisualInfo := NIL;
  END;
  IF Scr # NIL THEN
    I.UnlockPubScreen (NIL, Scr);
    Scr := NIL;
  END;
END CloseDownScreen;

PROCEDURE DrawRast (win: I.WindowPtr);
TYPE PattType = ARRAY [0..1] OF CARDINAL;
VAR backPatt : PattType;
BEGIN
  backPatt := [0AAAAH,05555H];
  g.SetAPen (win^.RPort, 2);
  gfx.SetAfPt (win^.RPort, y.ADR(backPatt),1);
  IF I.GIMMEZEROZERO <= win^.Flags THEN
    g.RectFill(win^.RPort,0,0,win^.GZZWidth,win^.GZZHeight);
  ELSE
    g.RectFill(win^.RPort, win^.BorderLeft,win^.BorderTop,
               win^.Width-win^.BorderLeft-1, win^.Height-win^.BorderBottom-1);
  END;
  gfx.SetAfPt (win^.RPort, NIL,0);
END DrawRast;

PROCEDURE MGRender;
VAR rp:g.RastPortPtr;
    sx,sy:INTEGER;
BEGIN
 IF MGWnd^.Height-MGWnd^.BorderBottom-1-MGWnd^.BorderTop>0 THEN
  DrawRast (MGWnd);
  rp:=MGWnd^.RPort;
  ComputeFont (MGWidth, MGHeight);

  g.SetAPen (rp,0);
  sx:=OffX+ComputeX(7); sy:=OffY+ComputeY(4);
  g.RectFill (rp, sx, sy, sx+ComputeX(302)-2, sy+ComputeY(52)-2 );
  sx:=OffX+ComputeX(338); sy:=OffY+ComputeY(23);
  g.RectFill (rp, sx, sy, sx+ComputeX(159)-2, sy+ComputeY(93)-2 );
  sx:=OffX+ComputeX(319); sy:=OffY+ComputeY(4);
  g.RectFill (rp, sx, sy, sx+ComputeX(197)-2, sy+ComputeY(121)-2 );
  sx:=OffX+ComputeX(7); sy:=OffY+ComputeY(61);
  g.RectFill (rp, sx, sy, sx+ComputeX(302)-2, sy+ComputeY(121)-2 );
  g.SetAPen (rp,1);
  gt.DrawBevelBox (rp, OffX+ComputeX(7), OffY+ComputeY(4),
                       ComputeX(302), ComputeY(52),
                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);
  gt.DrawBevelBox (rp, OffX+ComputeX(338), OffY+ComputeY(23),
                       ComputeX(159), ComputeY(93),
                   gt.GT_VisualInfo, VisualInfo, u.TAG_DONE);
  gt.DrawBevelBox (rp, OffX+ComputeX(319), OffY+ComputeY(4),
                       ComputeX(197), ComputeY(121),
                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);
  gt.DrawBevelBox (rp, OffX+ComputeX(7), OffY+ComputeY(61),
                       ComputeX(302), ComputeY(121),
                   gt.GT_VisualInfo, VisualInfo, gt.GTBB_Recessed, TRUE,u.TAG_DONE);

  MGIText := [
    [1, 0, g.JAM1,0 ,OffY + ComputeY (13) - Font^.ta_YSize DIV 2, Font,
      "Preferences", NIL] ];
  MGIText[0].LeftEdge:= OffX + ComputeX (421) - (I.IntuiTextLength (y.ADR(MGIText[0])) DIV 2);
  I.PrintIText (rp, y.ADR(MGIText[0]), 0, 0);
 END;

  I.RefreshGList (MGGList, MGWnd, NIL, -1);
  gt.GT_RefreshWindow (MGWnd, NIL);

END MGRender;

PROCEDURE CreateMGGadgets (): INTEGER;
VAR
  ng: gt.NewGadget;
  gad: I.GadgetPtr;
  lc, tc: INTEGER;
BEGIN
  ComputeFont (MGWidth, MGHeight);

  MGGetImage := C.NewObject (gf.GetFileClass,NIL,gt.GT_VisualInfo,VisualInfo,
                                   C.IA_Width,ComputeX(20),C.IA_Height,ComputeY(14),u.TAG_DONE);
  IF MGGetImage = NIL THEN RETURN 7 END;

  gad := gt.CreateContext (MGGList);
  IF gad = NIL THEN RETURN 1 END;

  lc := 0; tc := 0;
  WHILE lc < MGCNT DO
    ng := MGNGad^[lc];
    ng.ng_VisualInfo := VisualInfo;
    ng.ng_TextAttr   := Font;
    ng.ng_LeftEdge   := OffX + ComputeX (ng.ng_LeftEdge);
    ng.ng_TopEdge    := OffY + ComputeY (ng.ng_TopEdge);
    ng.ng_Width      := ComputeX (ng.ng_Width);
    ng.ng_Height     := ComputeY (ng.ng_Height);

    gad := gt.CreateGadgetA (MGGTypes[lc], gad, ng, y.ADR (MGGTags^[tc]));
    IF gad = NIL THEN RETURN 2 END;
    MGGadgets[lc] := gad;

    IF MGGTypes[lc] = gt.GENERIC_KIND THEN
      INCL (gad^.Flags, I.GADGIMAGE+I.GADGHIMAGE);
      IF u.FindTagItem (C.GA_Disabled,y.ADR (MGGTags^[tc]))#NIL THEN
        INCL (gad^.Flags, I.GADGDISABLED);
      END;
      INCL (gad^.Activation, I.RELVERIFY);
      gad^.GadgetRender := MGGetImage;
      gad^.SelectRender := MGGetImage;
    END; (* IF *)

    WHILE MGGTags^[tc] # u.TAG_DONE DO INC (tc, 2) END;
    INC (tc);

    INC (lc);
  END; (* WHILE *)

  RETURN 0;
END CreateMGGadgets;

PROCEDURE OpenMGWindow (createGads: BOOLEAN): INTEGER;
VAR ret, wleft, wtop, ww, wh: INTEGER;
BEGIN
  wleft := MGLeft; wtop := MGTop;

  ComputeFont (MGWidth, MGHeight);

  ww := ComputeX (MGWidth);
  wh := ComputeY (MGHeight);

  IF wleft + ww + OffX + Scr^.WBorRight > Scr^.Width THEN
    wleft := Scr^.Width - ww;
  END;
  IF wtop + wh + OffY + Scr^.WBorBottom > Scr^.Height THEN
    wtop := Scr^.Height - wh;
  END;

  IF createGads THEN
    ret := CreateMGGadgets(); IF ret # 0 THEN RETURN ret END;
  END;

  MGZoom[0] := MGLeft;
  MGZoom[1] := MGTop;
  MGZoom[2] := g.TextLength (y.ADR (Scr^.RastPort), y.ADR("ModGen V1.0"), 11) + 80;
  MGZoom[3] := Scr^.WBorTop + Scr^.RastPort.TxHeight + 1;

  MGWnd := I.OpenWindowTags ( NIL,
                I.WA_Left,          wleft,
                I.WA_Top,           wtop,
                I.WA_InnerWidth,    ww,
                I.WA_InnerHeight,   wh,
                I.WA_IDCMP,         gt.LISTVIEWIDCMP+gt.BUTTONIDCMP+gt.MXIDCMP+LONGSET(gt.TEXTIDCMP)+gt.CHECKBOXIDCMP+gt.STRINGIDCMP+I.GADGETUP+
                    I.CLOSEWINDOW+I.VANILLAKEY+I.REFRESHWINDOW,
                I.WA_Flags,         I.WINDOWDRAG+I.WINDOWDEPTH+I.WINDOWCLOSE+I.ACTIVATE+I.RMBTRAP,
                I.WA_NewLookMenus,  TRUE,
                I.WA_Title,         "ModGen V1.0",
                I.WA_ScreenTitle,   "ModGen V1.0 by Frank Lömker, based on OG and GenOberon",
                I.WA_PubScreen,     Scr,
                I.WA_Zoom,          y.ADR (MGZoom),
                I.WA_AutoAdjust,    TRUE,
                I.WA_PubScreenFallBack, TRUE,
                u.TAG_DONE);
  IF MGWnd = NIL THEN RETURN 20 END;

  ret:=I.AddGList (MGWnd,MGGList,-1,-1,NIL);
  MGRender;

  RETURN 0;
END OpenMGWindow;

PROCEDURE CloseMGWindow;
BEGIN
  IF MGWnd # NIL THEN
    I.CloseWindow (MGWnd);
    MGWnd := NIL;
  END;
  IF MGGList # NIL THEN
    gt.FreeGadgets (MGGList);
    MGGList := NIL;
  END;
  IF MGGetImage # NIL THEN
    C.DisposeObject (MGGetImage);
    MGGetImage := NIL;
  END;
END CloseMGWindow;

PROCEDURE GetMem (size:LONGINT):y.ADDRESS;
VAR ptr:y.ADDRESS;
BEGIN
  ptr:=m2.malloc (size);
  IF ptr=NIL THEN m2._ErrorReq ("Not enought Memory"," "); END;
  RETURN ptr;
END GetMem;

BEGIN
  Topaz80:=[y.ADR ("topaz.font"),8];
  From0Labels := [
    "_from",
    "_to",
    NIL];
  MGGTypes := [
    gt.LISTVIEW_KIND,
    gt.BUTTON_KIND,
    gt.BUTTON_KIND,
    gt.BUTTON_KIND,
    gt.MX_KIND,
    gt.TEXT_KIND,
    gt.TEXT_KIND,
    gt.CHECKBOX_KIND,
    gt.CHECKBOX_KIND,
    gt.CHECKBOX_KIND,
    gt.CHECKBOX_KIND,
    gt.BUTTON_KIND,
    gt.BUTTON_KIND,
    gt.STRING_KIND,
    gt.STRING_KIND,
    gt.GENERIC_KIND,
    gt.GENERIC_KIND,
    gt.CHECKBOX_KIND,
    gt.STRING_KIND,
    gt.GENERIC_KIND,
    gt.CHECKBOX_KIND ];
  MGNGad := GetMem (SIZE(MGNGadArray));
  MGNGad^ := [
    [16, 77, 286, 72, "Windows", NIL, GDWindows, gt.PLACETEXT_ABOVE],
    [327, 131, 84, 14, "_All", NIL, GDAll, gt.PLACETEXT_IN],
    [374, 169, 84, 14, "Quit", NIL, GDQuit, gt.PLACETEXT_IN],
    [327, 150, 84, 14, "_Selected", NIL, GDSelect, gt.PLACETEXT_IN],
    [59, 150, 17, 9, NIL, NIL, GDFrom, gt.PLACETEXT_LEFT],
    [90, 148, 212, 14, NIL, NIL, GDTfrom],
    [90, 164, 212, 14, NIL, NIL, GDTto],
    [352, 29, 26, 11, "Gen _OpenFont", NIL, GDFont, gt.PLACETEXT_RIGHT],
    [352, 43, 26, 11, "_Use SysFont", NIL, GDSys, gt.PLACETEXT_RIGHT],
    [352, 57, 26, 11, "_Raster", NIL, GDRaster, gt.PLACETEXT_RIGHT],
    [352, 71, 26, 11, "Under_mouse", NIL, GDMouse, gt.PLACETEXT_RIGHT],
    [424, 131, 84, 14, "Sa_vePref", NIL, GDSave, gt.PLACETEXT_IN],
    [424, 150, 84, 14, "A_bout", NIL, GDAbout, gt.PLACETEXT_IN],
    [72, 8, 207, 14, "Sour_ce", NIL, GDSource, gt.PLACETEXT_LEFT],
    [72, 23, 207, 14, "_Dest", NIL, GDDest, gt.PLACETEXT_LEFT],
    [282, 8, 20, 14, NIL, NIL, GDFsource],
    [282, 23, 20, 14, NIL, NIL, GDFdest],
    [352, 99, 26, 11, "_Icon", NIL, GDIcon, gt.PLACETEXT_RIGHT],
    [72, 38, 207, 14, "Scr_een", NIL, GDScreen, gt.PLACETEXT_LEFT],
    [282, 38, 20, 14, NIL, NIL, GDFscreen],
    [352, 85, 26, 11, "Share Msg_Port", NIL, GDPort, gt.PLACETEXT_RIGHT] ];
  MGGTags := GetMem (SIZE(MGGTagsArray));
  MGGTags^ := [
    u.TAG_DONE,
    y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    u.TAG_DONE,
    y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTMX_Labels), y.ADR (From0Labels[0]), y.ADDRESS(gt.GTMX_Spacing), 8, y.ADDRESS(gt.GTMX_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTTX_Border), ORD(TRUE), u.TAG_DONE,
    y.ADDRESS(gt.GTTX_Border), ORD(TRUE), u.TAG_DONE,
    y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTST_MaxChars), 256, y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTST_MaxChars), 256, y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    u.TAG_DONE,
    u.TAG_DONE,
    y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    y.ADDRESS(gt.GTST_MaxChars), 256, y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE,
    u.TAG_DONE,
    y.ADDRESS(gt.GTCB_Scaled), ORD(TRUE), y.ADDRESS(gt.GT_Underscore), ORD ('_'), u.TAG_DONE ];
  MGLeft := 48;
  MGTop := 1;
  MGWidth := 523;
  MGHeight := 186;
END MGgui.
