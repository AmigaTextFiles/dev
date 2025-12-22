Program ConsoleTest;

{
    This program demonstrates and tests the console IO routines.
It uses the a small group of routines I wrote to make it a bit easier
to port Turbo programs that do screen IO.
}

{
   Changed to use 2.0+ code.
   9 May 1998.
   nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Ports.i"}
{$I "Include:Intuition/Intuition.i" for window structures and functions }
{$I "Include:Utils/CRT.i" for ReadKey, WriteString, AttachConsole, etc. }

var
    w  : WindowPtr;
    s  : ScreenPtr;

procedure CleanUp(why : string; err : Integer);
begin
    if w <> nil then CloseWindow(w);
    if s <> nil then UnlockPubScreen(nil,s);
    if why <> nil then writeln(why);
    Exit(err);
end;

var
    ConBlock : Address;
    ch : Array [0..1] of Char;
begin
    s := LockPubScreen(nil);
    if s = nil then CleanUp("Could not get a lock on Workbench",10);

    w := OpenWindowTags(NIL,
                 WA_Left,         20,
                 WA_Top,          50,
                 WA_Width,        300,
                 WA_Height,       100,
                 WA_MinWidth,     50,
                 WA_MinHeight,    20,
                 WA_DepthGadget,  true,
                 WA_DragBar,      true,
                 WA_SizeGadget,   true,
                 WA_SmartRefresh, true,
                 WA_Activate,     true,
                 WA_Title,        "Press q to Quit",
                 WA_PubScreen,    s,
                 TAG_END);
    IF w = NIL THEN CleanUp("Could not open Window",10);

    ConBlock := AttachConsole(w);
    if ConBlock = Nil then CleanUp("Could not open console device",10);
    ch[1] := '\0'; { Just for ease of writing }
    repeat
       ch[0] := ReadKey(ConBlock);
       WriteString(ConBlock, Adr(ch));
    until ch[0] = 'q';
    DetachConsole(ConBlock);
    CleanUp(nil,0);
end.
