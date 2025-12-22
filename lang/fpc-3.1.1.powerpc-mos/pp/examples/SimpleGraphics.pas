Program SimpleGraphics;

{$MODE OBJFPC} {$H+}

(*
  Example for simple drawing routines
*)


Uses
  exec,
  agraphics,
  intuition,
  utility;


var
  window : pWindow;
  cm     : pColorMap;
  rp     : pRastPort;

const
  (*
    ObtainBestPen() returns -1 when it fails, therefore we
    initialize the pen numbers with -1 to simplify cleanup.
  *)
  pen1   : LongInt = -1;
  pen2   : LongInt = -1;


procedure draw_simple;
var
  array_ : array[0..8-1] of smallint;
begin
  array_[0] := 50;  array_[1] := 200;  { Polygon for PolyDraw }
  array_[2] := 80;  array_[3] := 180;
  array_[4] := 90;  array_[5] := 220;
  array_[6] := 50;  array_[7] := 200;

  SetAPen(rp, pen1);                    { Set foreground color }
  SetBPen(rp, pen2);                    { Set background color }

  WritePixel(rp, 30, 70);               { Plot a point }

  SetDrPt(rp, $FF00);                   { Change line pattern. Set pixels are drawn }
                                        { with APen, unset with BPen }
  GfxMove(rp, 20, 50);                     { Move cursor to given point }
  Draw(rp, 100, 80);                    { Draw a line from current to given point }

  DrawEllipse(rp, 70, 30, 15, 10);      { Draw an ellipse }

  (*
    Draw a polygon. Note that the first line is draw from the
    end of the last Move() or Draw() command
  *)

  PolyDraw(rp, sizeof(array_) div sizeof(WORD) div 2, @array_[0]);

  SetDrMd(rp, JAM1);                    { We want to use only the foreground pen }
  GfxMove(rp, 200, 80);
  GfxText(rp, 'Text in default font', 20);

  SetDrPt(rp, $FFFF);                   { Reset line pattern }
end;



procedure write_text(const s: STRPTR; x: WORD; y: WORD; mode: ULONG);
begin
  SetDrMd(rp, mode);
  GFXMove(rp, x, y);
  GfxText(rp, s, strlen(s));
end;



procedure handle_events;
var
  imsg : pIntuiMessage;
  port : pMsgPort;
  terminated : boolean;
begin
  (*
    A simple event handler. This will be exaplained ore detailed
    in the Intuition examples.
  *)
  port := window^.userPort;
  terminated := false;

  while not terminated do
  begin
    Wait(1 shl port^.mp_SigBit);
    IMsg := PIntuiMessage(GetMsg(Port));
    if Assigned(IMsg) then
    begin
      Case imsg^.IClass of
        IDCMP_CLOSEWINDOW : terminated := true;
      end; { case }
      ReplyMsg(pMessage(imsg));
    end;

  end;
end;



procedure clean_exit(const s: STRPTR);
begin
  If Assigned(s) then
    WriteLn(s);

  (* Give back allocated resources *)
  if (pen1 <> -1)  then ReleasePen(cm, pen1);
  if (pen2 <> -1)  then ReleasePen(cm, pen2);
  if Assigned(window) then
    CloseWindow(window);
end;


begin
  InitIntuitionLibrary;
  InitGraphicsLibrary;
  window := OpenWindowTags(nil,
    [
    WA_Left         ,  50,
    WA_Top          ,  70,
    WA_Width        , 400,
    WA_Height       , 350,

    WA_Title        , PtrUInt(PChar('Simple Graphics')),
    WA_Activate     , PtrUInt(True),
    WA_SmartRefresh , PtrUInt(True),
    WA_NoCareRefresh, PtrUInt(True),
    WA_GimmeZeroZero, PtrUInt(True),
    WA_CloseGadget  , PtrUInt(True),
    WA_DragBar      , PtrUInt(True),
    WA_DepthGadget  , PtrUInt(True),
    WA_IDCMP        , IDCMP_CLOSEWINDOW,
    TAG_END, TAG_END, TAG_END, TAG_END
  ]
  );

  if not Assigned(window) then
    clean_exit('Can''t open window');

  rp := window^.RPort;
  cm := pScreen(window^.WScreen)^.ViewPort.Colormap;

  (* Let's obtain two pens *)
  pen1 := ObtainBestPenA(cm, $FFFF0000, 0, 0, nil);
  pen2 := ObtainBestPenA(cm, 0 ,0, $FFFF0000, nil);

  If (pen1 < 0) or (pen2 < 0) then
    clean_exit('Can''t allocate pen');

  draw_simple;
  handle_events;

  clean_exit(nil);
end.
