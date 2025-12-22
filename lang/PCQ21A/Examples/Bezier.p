Program Bezier;

{  This program draws Bezier curves in the slow, simple, recursive
   way.  When it first runs, you enter points in the window by
   clicking the left mouse button.  After you double click on the
   last point, the program begins drawing the curve.

   Since this is a highly recursive program, it's speed decreases
   dramatically as you enter more points.  It can handle six or
   seven points with reasonable speed, but if you enter ten you
   might want to go see a movie while it draws.  It also uses
   more stack space as you enter more points, but I hasn't blown
   a 4k stack yet.
}

{
   Changed the source to use 2.0+.
   Looks a lot better.
   Added CloseWindowSafely.
   Made the window dynamic, it will
   adjust the size after the screen size.
   8 May 1998.
   nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Interrupts.i" for Forbid and Permit }
{$I "Include:Exec/Libraries.i" for Open and Close }
{$I "Include:Exec/Ports.i" for the Message stuff }
{$I "Include:Intuition/Intuition.i" for window & screen structures and functions }
{$I "Include:Graphics/Pens.i" for drawing stuff }
{$I "Include:Graphics/Text.i" for GText }
{$I "Include:Graphics/DisplayInfo.i"}
{$I "Include:PCQUtils/IntuiUtils.i"}  { CloseWindowSafely }


type
    PointRec = Record
        X, Y : Short;
    end;
    
Const
    w  : WindowPtr   = Nil;
    s  : ScreenPtr   = Nil;

{
    This will make the new look for screen.
    SA_Pens, Integer(pens)
}
    pens : array [0..0] of word = (not 0);

{  The following definitions mean that the start-up code will
   not create an output window for this program if it is run
   from the Workbench.  Therefore this program should NOT use
   ReadLn and WriteLn. }

    StdInName : Address = Nil;
    StdOutName: Address = Nil;
Var
    m  : MessagePtr;
    rp : RastPortPtr;

    PointCount : Short;
    Points : Array [1..15] of PointRec;

    t, tprime : Real;

    LastX, LastY : Short;

Procedure CleanUpAndDie;
begin
    if w <> Nil then CloseWindowSafely(w);
    if s <> Nil then CloseScreen(s);
    Exit(0);
end;


Procedure DrawLine;
begin
    Move(rp, Points[PointCount].X, Points[PointCount].Y);
    Draw(rp, LastX, LastY);
end;

Procedure GetPoints;
var
    LastSeconds,
    LastMicros  : Integer;
    IM : IntuiMessagePtr;
    StoreMsg : IntuiMessage;
    Leave : Boolean;
    OutOfBounds : Boolean;
    BorderLeft, BorderRight,
    BorderTop, BorderBottom : Short;
    dummy : Boolean;

    Procedure AddPoint;
    begin
    Inc(PointCount);
    with Points[PointCount] do begin
        X := StoreMsg.MouseX;
        Y := StoreMsg.MouseY;
    end;
    with StoreMsg do begin
        LastX := MouseX;
        LastY := MouseY;
        LastSeconds := Seconds;
        LastMicros := Micros;
    end;
    SetAPen(rp, 2);
    SetDrMd(rp, JAM1);
    DrawEllipse(rp, LastX, LastY, 5, 3);
    SetAPen(rp, 3);
    SetDrMd(rp, COMPLEMENT);
    DrawLine;
    end;

    Function CheckForExit : Boolean;
    {   This function determines whether the user wanted to stop
    entering points.  I added the position tests because my
    doubleclick time is too long, and I was too lazy to dig
    out Preferences to change it. }
    begin
    with StoreMsg do
        CheckForExit := DoubleClick(LastSeconds, LastMicros,
                    Seconds, Micros) and
                (Abs(MouseX - Points[PointCount].X) < 5) and
                (Abs(MouseY - Points[PointCount].Y) < 3);
    end;

    Procedure ClearIt;
    {  This just clears the screen when you enter your first point }
    begin
    SetDrMd(rp, JAM1);
    SetAPen(rp, 0);
    RectFill(rp, BorderLeft, BorderTop,
             BorderRight, BorderBottom);
    SetDrMd(rp, COMPLEMENT);
    SetAPen(rp, 3);
    end;

begin
    Move(rp, 252, 20);
    GText(rp, "Enter points by pressing the left mouse button", 46);
    Move(rp, 252, 30);
    GText(rp, "Double click on the last point to begin drawing", 47);
    dummy := ModifyIDCMP(w, IDCMP_CLOSEWINDOW or IDCMP_MOUSEBUTTONS or IDCMP_MOUSEMOVE);
    SetDrMd(rp, COMPLEMENT);
    PointCount := 0;
    Leave := False;
    OutOfBounds := False;
    BorderLeft := w^.BorderLeft;
    BorderRight := (w^.Width - w^.BorderRight) -1;
    BorderTop := w^.BorderTop;
    BorderBottom := (w^.Height - w^.BorderBottom) -1;
    repeat
        IM := IntuiMessagePtr(WaitPort(w^.UserPort));
        IM := IntuiMessagePtr(GetMsg(w^.UserPort));
        StoreMsg := IM^;
        ReplyMsg(MessagePtr(IM));
        case StoreMsg.Class of
           IDCMP_MOUSEMOVE : if PointCount > 0 then begin
                 if not OutOfBounds then
                 DrawLine;
                     LastX := StoreMsg.MouseX;
                     LastY := StoreMsg.MouseY;
                 if (LastX > BorderLeft) and
                (LastX < BorderRight) and
                (LastY > BorderTop) and
                (LastY < BorderBottom) then begin
                 DrawLine;
                 OutOfBounds := False;
                 end else
                 OutOfBounds := True;
                 end;
           IDCMP_MOUSEBUTTONS : if StoreMsg.Code = SELECTUP then begin
                    if PointCount > 0 then
                    Leave := CheckForExit
                else
                    ClearIt;
                    if (not Leave) and (not OutOfBounds) then
                    AddPoint;
                    end;
           IDCMP_CLOSEWINDOW : CleanUpAndDie;
        end;
    until Leave or (PointCount > 14);
    if not Leave then
        DrawLine;
    dummy := ModifyIDCMP(w, IDCMP_CLOSEWINDOW);
    SetDrMd(rp, JAM1);
    SetAPen(rp, 1);
end;

{
   These two function just implement the de Casteljau
algorithm, which looks like:

         r            r-1         r-1
    B  = (1-t) * B    +  t * B
         i            i           i+1

   Where r and i are meant to be subscripts and superscripts.  R is
   a level number, where zero represents the data points and
   (the number of points - 1) represents the curve points.  I is
   the point numbers, starting from zero normally but in this
   program starting from 1.  t is the familiar 'parameter' running
   from 0 to 1 in arbitrary increments.
}

Function BezierX(r, i : Short) : Real;
begin
    if r = 0 then
    BezierX := Float(Points[i].X)
    else
    BezierX := tprime * BezierX(Pred(r), i) + t * BezierX(Pred(r), Succ(i));
end;

Function BezierY(r, i : Short) : Real;
begin
    if r = 0 then
    BezierY := Float(Points[i].Y)
    else
    BezierY := tprime * BezierY(Pred(r), i) + t * BezierY(Pred(r), Succ(i));
end;

Procedure DrawBezier;
var
    increment : Real;
begin
    increment := 0.01; { This could be a function of PointCount }
    t := 0.0;
    tprime := 1.0;
    Move(rp, Trunc(BezierX(Pred(PointCount), 1)),
         Trunc(BezierY(Pred(PointCount), 1)));
    t := t + increment;
    tprime := 1.0 - t;
    while t <= 1.0 do begin
    Draw(rp, Trunc(BezierX(Pred(PointCount), 1)),
         Trunc(BezierY(Pred(PointCount), 1)));
    t := t + increment;
    tprime := 1.0 - t;
    if GetMsg(w^.UserPort) <> Nil then
        CleanUpAndDie;
    end;
    t := 1.0;
    tprime := 0.0;
    Draw(rp, Trunc(BezierX(Pred(PointCount), 1)),
         Trunc(BezierY(Pred(PointCount), 1)));
end;

begin
    s := OpenScreenTags(NIL,
                        SA_Pens,      integer(pens),
                        SA_Depth,     2,
                        SA_DisplayID, HIRES_KEY,
                        SA_Title,     "Simple Bezier Curves",
                        TAG_END);
    if s = NIL then CleanUpAndDie;

    w := OpenWindowTags(NIL,
                        WA_IDCMP,       IDCMP_CLOSEWINDOW,
                        WA_Left,        0,
                        WA_Top,         s^.BarHeight+1,
                        WA_Width,       s^.Width,
                        WA_Height,      s^.Height - (s^.BarHeight +1),
                        WA_DepthGadget, true,
                        WA_DragBar,     true,
                        WA_CloseGadget, true,
                        WA_ReportMouse, true,
                        WA_SmartRefresh,true,
                        WA_Activate,    true,
                        WA_Title,       "Close the Window to Quit",
                        WA_CustomScreen,s,
                        TAG_END);
    IF w=NIL THEN CleanUpAndDie;

    rp := w^.RPort;
    GetPoints;
    DrawBezier;
    m := WaitPort(w^.UserPort);
    Forbid;
    repeat
       m := GetMsg(w^.UserPort);
    until m = nil;
    Permit;
    CleanUpAndDie;
end.
