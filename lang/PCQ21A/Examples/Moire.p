Program Moire;

    { This program just draws a Moire pattern in a window.
      It uses a surprising breadth of functions, so it shows
      off a bit of what PCQ can do.  And it works to boot. }

{
      Will now open a default screen (can be any size) with
      the new look. The window get it's size depending on
      the screen size.
      14 May 1998
      nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Graphics/DisplayInfo.i"}

const
    pens : array [0..0] of word = (not 0);
var
    w  : WindowPtr;
    s  : ScreenPtr;
    m  : MessagePtr;

Procedure DoDrawing(RP : RastPortPtr);
var
    x  : Short;
    Pen : Byte;
    Stop : Short;
begin
    Pen := 1;
    while true do begin
    with w^ do begin
        x := 0;
        while x < Pred(Width - BorderRight - BorderLeft) do begin
        Stop := Pred(Width - BorderRight);
        SetAPen(RP, Pen);
        Move(RP, Succ(x + BorderLeft), BorderTop);
        Draw(RP, Stop - x, Pred(Height - BorderBottom));
        Pen := (Pen + 1) mod 4;
        Inc(x);
        end;
        m := GetMsg(UserPort);
        if m <> Nil then
        return;
        x := 0;
        while x < Pred(Height - BorderBottom - BorderTop) do begin
        Stop := Pred(Height - BorderBottom);
        SetAPen(RP, Pen);
        Move(RP, Pred(Width - BorderRight), Succ(x + BorderTop));
        Draw(RP, Succ(BorderLeft), Stop - x);
        Pen := (Pen + 1) mod 4;
        Inc(x);
        end;
        m := GetMsg(UserPort);
        if m <> Nil then
        return;
    end;
    end;
end;

begin
    { Note that the startup code of all PCQ programs depends on
      Intuition, so if we got to this point Intuition must be
      open, so the run time library just uses the pointer that
      the startup code created.  Same with DOS, although we don't
      use that here. }

    s := OpenScreenTags(NIL,
                        SA_Pens,      integer(pens),
                        SA_Depth,     2,
                        SA_DisplayID, HIRES_KEY,
                        SA_Title,     "Close the Window to End This Demonstration",
                        TAG_END);
    if s <> NIL then begin

    w := OpenWindowTags(NIL,
                        WA_IDCMP,        IDCMP_CLOSEWINDOW,
                        WA_Left,         20,
                        WA_Top,          50,
                        WA_Width,        336,
                        WA_Height,       100,
                        WA_MinWidth,     50,
                        WA_MinHeight,    20,
                        WA_MaxWidth,     -1,
                        WA_MaxHeight,    -1,
                        WA_DepthGadget,  true,
                        WA_DragBar,      true,
                        WA_CloseGadget,  true,
                        WA_SizeGadget,   true,
                        WA_SmartRefresh, true,
                        WA_Activate,     true,
                        WA_Title,        "Feel Free to Re-Size the Window",
                        WA_CustomScreen, s,
                        TAG_END);
    IF w <> NIL THEN begin

        DoDrawing(w^.RPort);
        Forbid;
        repeat
            m := GetMsg(w^.UserPort);
        until m = nil;
        CloseWindow(w);
        Permit;
        end else
        writeln('Could not open the window');
        CloseScreen(s);
    end else
        writeln('Could not open the screen.');
end.

