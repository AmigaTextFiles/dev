Program Circle;

{
      This program just draws two simple circles.  The first is
      drawn using PCQ's new (at the moment) sine and cosine
      functions.  The second is drawn directly over the top with
      the SPSin and SPCos functions from the mathtrans.library.

      I wrote this to determine whether the trig functions I had
      just written were accurate enough to be worthwhile.  Since
      these two circles come pretty close to overlapping, I
      left them in.

      To run this program without the mathtrans.library, just
      remove the MathTrans.i include, the open and close
      of the library, and lines that draw the second circle.
      That's all.

      Later Note: I replaced the older, less accurate functions
      with more traditional series-based functions, which are
      much more accurate and only a little slower.
}

{
      Changed the source to 2.0+.
      9 May 1998.
      nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Libraries/MathTrans.i"}
{$I "Include:Utils/MathTransUtils.i"}

Const
    Pi = 3.1415927;
    TwoPi = Pi * 2.0;

    Aspect = 2.0;   { To account for pixel shape }

var
    w  : WindowPtr;
    m  : MessagePtr;
    s  : ScreenPtr;
    isopen : Boolean;

procedure CleanUp(why : string; err : Integer);
begin
    if w <> nil then CloseWindow(w);
    if s <> nil then UnlockPubScreen(nil,s);
    if isopen then CloseMathTrans;
    if why <> nil then writeln(why);
    Exit(err);
end;

Procedure DoCircle(RP : RastPortPtr; CX, CY, Radius : Short);
{
    Draw a circle using 500 line segments
}
Const
    Division = TwoPi / 500.0;
var
    t : Real;
    i : Integer;
    RealRad : Real;
begin
    SetAPen(rp, 1);
    RealRad := Float(Radius);
    Move(rp, CX + Round(RealRad * Aspect), CY);
    for i := 1 to 500 do
    Draw(rp, CX + Round(Cos(Float(i) * Division) * RealRad * Aspect),
         CY + round(Sin(Float(i) * Division) * RealRad));
    Draw(rp, CX + Round(RealRad * Aspect), CY);
    SetAPen(rp, 3);
    Move(rp, CX + Round(RealRad * Aspect), CY);
    for i := 1 to 500 do
    Draw(rp, CX + Round(SPCos(Float(i) * Division) * RealRad * Aspect),
         CY + round(SPSin(Float(i) * Division) * RealRad));
    Draw(rp, CX + Round(RealRad * Aspect), CY);
end;

begin
    { Note that the startup code of all PCQ programs depends on
      Intuition, so if we got to this point Intuition must be
      open, so the run time library just uses the pointer that
      the startup code created.  Same with DOS, although we don't
      use that here. }

    isopen := OpenMathTrans;
    if not isopen then CleanUp("Could not open math library",10);

    s := LockPubScreen(nil);
    if s = nil then CleanUp("Could not get a lock on Workbench",10);

    w := OpenWindowTags(NIL,
                 WA_IDCMP,       IDCMP_CLOSEWINDOW,
                 WA_Left,        0,
                 WA_Top,         0,
                 WA_Width,       640,
                 WA_Height,      200,
                 WA_MinWidth,    50,
                 WA_MinHeight,   20,
                 WA_DepthGadget, true,
                 WA_DragBar,     true,
                 WA_CloseGadget, true,
                 WA_SizeGadget,  true,
                 WA_SmartRefresh,true,
                 WA_Activate,    true,
                 WA_Title,       "Horseshoes, handgrenades, and some trigonomentry",
                 WA_PubScreen,   s,
                 TAG_END);
    IF w = NIL THEN CleanUp("Could not open Window",10);

    DoCircle(w^.RPort, 320, 105, 92);
    m := WaitPort(w^.UserPort);
    Forbid;
    repeat
        m := GetMsg(w^.UserPort);
    until m = nil;
    Permit;
    CleanUp(nil,0);
end.



