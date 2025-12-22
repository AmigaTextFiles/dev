Program DeadKeysPlus;

{
    This program is the same as an older program called DeadKeys,
which used the DeadKeyConvert() and RawKeyConvert() functions to
get keystrokes in a very compatible way.  To that I have added
mostly useless menus, which are an example of the use of the
BuildMenu routines.  These, in turn, exercise the Intuition menu
functions.
    To make a long story short, if you are looking for an example
of DeadKeyConvert() or BuildMenu it's in here somewhere.

    Although you would certainly want the code to be more modular
and you would need to design a data structure, this is the barest
bones of a text editor.
}

{
    Changed the looks to 2.0+.
    Dynamic size of the window, will open 1 pixel below the screens
    titlebar (so you can see the cursor). Removed BuildMenu, now
    uses GadTools for menu.
    11 May 1998.
    nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Exec/Devices.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Devices/InputEvent.i"}
{$I "Include:Utils/ConsoleUtils.i"}
{$I "Include:Utils/ConsoleIO.i"}
{$I "Include:Utils/DeadKeyConvert.i"}
{$I "Include:Graphics/DisplayInfo.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:PCQUtils/Utils.i"}
{$I "Include:PCQUtils/IntuiUtils.i"}

const
    pens : array [0..0] of word = (not 0);

    nm : array [0..13] of NewMenu = (
         (NM_TITLE,"Project",NIL,0,0,NIL),
         (NM_ITEM, "New ","N",0,0,NIL),
         (NM_ITEM, "Load","L",0,0,NIL),
         (NM_ITEM, "Save","S",0,0,NIL),
         (NM_ITEM, "Quit","Q",0,0,NIL),
         (NM_TITLE,"Action",NIL,0,0,NIL),
         (NM_ITEM, "Defoliate      ","D",0,0,NIL),
         (NM_ITEM, "Repack Bearings","R",0,0,NIL),
         (NM_ITEM, "Mince          ",NIL,0,0,NIL),
         (NM_SUB,  "Slice   ","1",0,0,NIL),
         (NM_SUB,  "Dice    ","2",0,0,NIL),
         (NM_SUB,  "Julienne","3",0,0,NIL),
         (NM_ITEM, "Floss          ","F",0,0,NIL),
         (NM_END,  NIL,NIL,0,0,NIL));

var
    w  : WindowPtr;
    s  : ScreenPtr;
    MenuStrip : MenuPtr;
    vi : Address;
    Error : Short;

    IMessage    : IntuiMessagePtr;
    Buffer  : Array [0..9] of Char;
    Length  : Integer;
    Leave   : Boolean;
    WriteReq    : IOStdReqPtr;
    WritePort   : MsgPortPtr;

Procedure CleanUp(str : string; err : Integer);
begin
    if MenuStrip <> nil then begin
       ClearMenuStrip(w);
       FreeMenus(MenuStrip);
    end;
    if vi <> nil then FreeVisualInfo(vi);
    if w <> nil then CloseWindowSafely(w);
    if s <> nil then CloseScreen(s);
    CloseConsoleDevice;
    if GadToolsBase <> nil then CloseLibrary(GadToolsBase);
    Exit(err);
end;

Procedure CloseEverything;
begin
    CloseDevice(IORequestPtr(WriteReq));
    DeleteStdIO(WriteReq);
    DeletePort(WritePort);
end;

Procedure OpenEverything;
begin
    GadToolsBase := OpenLibrary("gadtools.library",37);
    if GadToolsBase = nil then CleanUp("Can't open gadtools,library",20);

    OpenConsoleDevice;
    s := OpenScreenTags(NIL,
                        SA_Pens,      integer(pens),
                        SA_Depth,     2,
                        SA_DisplayID, HIRES_KEY,
                        SA_Title,     "Press ESC or choose Quit to End the Demonstration",
                        TAG_END);
    if s = NIL then CleanUp("Could not open screen",20);

    w := OpenWindowTags(NIL,
                        WA_IDCMP,        IDCMP_MENUPICK or IDCMP_RAWKEY,
                        WA_Left,         0,
                        WA_Top,          s^.BarHeight + 1,
                        WA_Width,        s^.Width,
                        WA_Height,       s^.Height - (s^.BarHeight + 1),
                        WA_Borderless,   true,
                        WA_Backdrop,     true,
                        WA_SmartRefresh, true,
                        WA_Activate,     true,
                        WA_NewLookMenus, true,
                        WA_CustomScreen, s,
                        TAG_END);
    IF w=NIL THEN CleanUp("Could not open window",20);

    vi := GetVisualInfo(w^.WScreen, TAG_END);
    if vi = nil then CleanUp("No visual info",10);

    if OSVersion >= 39 then MenuStrip := CreateMenus(adr(nm),GTMN_FrontPen,1,TAG_END)
    else MenuStrip := CreateMenus(adr(nm),TAG_END);

    if MenuStrip = nil then CleanUp("Could not open Menus",10);
    if LayoutMenus(MenuStrip,vi,TAG_END)=false then
        CleanUp("Could not layout Menus",10);

    if SetMenuStrip(w, MenuStrip) = false then
        CleanUp("Could not set the Menus",10);

    WritePort := CreatePort(Nil, 0);
    if WritePort <> Nil then begin
        WriteReq := CreateStdIO(WritePort);
        if WriteReq <> Nil then begin
            WriteReq^.io_Data := Address(w);
            WriteReq^.io_Length := SizeOf(Window);
            Error := OpenDevice("console.device", 0,
                IORequestPtr(WriteReq), 0);
            if Error = 0 then return;
            DeleteStdIO(WriteReq);
        end else writeln("Could not allocate memory");
        DeletePort(WritePort);
    end else writeln("Could not allocate a message port");
    CleanUp(nil,10);
end;

Procedure ConvertControl;
begin
    case Ord(Buffer[0]) of
      8 : ConPutStr(WriteReq, "\b\cP");
     13 : ConPutStr(WriteReq, "\n\cL");
     127 : ConPutStr(WriteReq, "\cP");
    else
    ConPutChar(WriteReq, Buffer[0]);
    end;
end;

Procedure ConvertTwoChar;
begin
    case Buffer[1] of
      'A'..'D' : ConWrite(WriteReq, Adr(Buffer), 2);
    end;
end;

begin
    OpenEverything;
    Leave := False;
    repeat
    IMessage := IntuiMessagePtr(WaitPort(w^.UserPort));
    IMessage := IntuiMessagePtr(GetMsg(w^.UserPort));
    if IMessage^.Class = RAWKEY_f then begin
        if IMessage^.Code < 128 then begin { Key Down }
        Length := DeadKeyConvert(IMessage, Adr(Buffer), 10, Nil);
        case Length of
          -MaxInt..-1 : ConWrite(WriteReq, "DeadKeyConvert error",20);
           1 : if Buffer[0] = '\e' then
               Leave := True
            else begin
                if (Buffer[0] < ' ') or
                (Ord(Buffer[0]) > 126) then
                ConvertControl
                else begin
                Buffer[2] := Buffer[0];
                Buffer[0] := '\c';
                Buffer[1] := '@'; { Insert }
                ConWrite(WriteReq, Adr(Buffer), 3);
                end;
            end;
           2 : ConvertTwoChar;
        end;
        end;
    end else if IMessage^.Class = MENUPICK_f then begin
        if IMessage^.Code = MENUNULL then
        ConWrite(WriteReq, "\nNo item", 8)
        else begin
        Buffer[0] := Chr(MenuNum(IMessage^.Code) + Ord('0'));
        Buffer[1] := '\n';
        ConWrite(WriteReq, "\nMenu Number: ", 14);
        ConWrite(WriteReq, Adr(Buffer), 2);
        Buffer[0] := Chr(ItemNum(IMessage^.Code) + Ord('0'));
        ConWrite(WriteReq, "Item Number: ", 13);
        ConWrite(WriteReq, Adr(Buffer), 2);
        if SubNum(IMessage^.Code) <> NOSUB then begin
            Buffer[0] := Chr(SubNum(IMessage^.Code) + Ord('0'));
            ConWrite(WriteReq, "Sub Number : ", 13);
            ConWrite(WriteReq, Adr(Buffer), 2);
        end;
        if (MenuNum(IMessage^.Code) = 0) and
            (ItemNum(IMessage^.Code) = 3) then
            Leave := True;
        end;
    end else { Must be CloseWindow }
        Leave := True;
    ReplyMsg(MessagePtr(IMessage));
    until Leave;
    CloseEveryThing;
    CleanUp(nil,0);
end.


