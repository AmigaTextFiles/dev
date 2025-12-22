Program SmallCom;

{
    This program is a simplistic terminal program, which has
basically no features, but works reasonably well.  It is an ANSI
compatible terminal to the extent that the console.device is - it
simply passes incoming data, from the keyboard or the serial device,
to the console device.

    To gain some control over the program, you might want to take a look
at the translated characters (after the call to DeadKeyConvert), and
process a few (function keys, for example) instead of sending them on
to the console.device.
}

{
    Changed the source to 2.0+.
    Added CloseWindowSafely.
    Removed BuildMenu and added GadToolsMenu instead.
    Changed the menus to MutualExclude.
    Added const for menu index.
    Added Config stuff. Can now save prefs and restart
    with prefsvalues.
    May 20 1998.
    nils.sjoholm@mailbox.swipnet.se
}

{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Exec/Devices.i"}
{$I "Include:Devices/Console.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Utils/ConsoleIO.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Devices/InputEvent.i"}
{$I "Include:Utils/DeadKeyConvert.i"}
{$I "Include:Devices/Serial.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Graphics/DisplayInfo.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:PCQUtils/Utils.i"}
{$I "Include:PCQUtils/IntuiUtils.i"}
{$I "Include:PCQUtils/Config.i"}

Type
    ParityType = (no_parity, even_parity, odd_parity);

Const
    w                   : WindowPtr = Nil;
    s                   : ScreenPtr = Nil;
    MenuStrip           : MenuPtr = Nil;
    vi                  : Address = Nil;
    SerialWrite         : IOExtSerPtr = Nil;
    SerialRead          : IOExtSerPtr = Nil;
    ConsoleWrite        : IOStdReqPtr = Nil;

    WritingConsole      : Boolean = False;
    WritingSerial       : Boolean = False;

    SerialSendBuffer    : String = Nil;
    ConsoleSendBuffer   : String = Nil;
    SerialReceiveBuffer : String = Nil;
    TranslateBuffer     : String = Nil;

    BaudRate            : Integer = 2400;
    DataBits            : Byte = 8;
    Parity              : ParityType = no_parity;
    StopBits            : Byte = 1;
    HalfDuplex          : Boolean = False;

    QuitStopDie         : Boolean = False;

    BaudRates   : Array [0..7] of Integer = (300, 1200, 2400,
                         4800, 9600, 19200,
                         38400,115200);


    nm : array [0..21] of NewMenu = (
         (NM_TITLE, "Project",     NIL,0,0,NIL),
         (NM_ITEM,  "Save Config", "S",0,0,NIL),
         (NM_ITEM,  "Quit",        "Q",0,0,NIL),
         (NM_TITLE, "Serial",      NIL,0,0,NIL),
         (NM_ITEM,  "Baud Rate",   NIL,0,0,NIL),
         (NM_SUB,   "300",         "1",CHECKIT+MENUTOGGLE, 254,NIL),
         (NM_SUB,   "1200",        "2",CHECKIT+MENUTOGGLE, 253,NIL),
         (NM_SUB,   "2400",        "3",CHECKIT+MENUTOGGLE, 251,NIL),
         (NM_SUB,   "4800",        "4",CHECKIT+MENUTOGGLE, 247,NIL),
         (NM_SUB,   "9600",        "5",CHECKIT+MENUTOGGLE, 239,NIL),
         (NM_SUB,   "19200",       "6",CHECKIT+MENUTOGGLE, 223,NIL),
         (NM_SUB,   "38400",       "7",CHECKIT+MENUTOGGLE, 191,NIL),
         (NM_SUB,   "115200",      "8",CHECKIT+MENUTOGGLE, 127,NIL),
         (NM_ITEM,  "Data Size",   NIL,0,0,NIL),
         (NM_SUB,   "7N2",         NIL,CHECKIT+MENUTOGGLE, 14,NIL),
         (NM_SUB,   "7E1",         NIL,CHECKIT+MENUTOGGLE, 13,NIL),
         (NM_SUB,   "7O1",         NIL,CHECKIT+MENUTOGGLE, 11,NIL),
         (NM_SUB,   "8N1",         NIL,CHECKIT+MENUTOGGLE, 7,NIL),
         (NM_ITEM,  "Duplex",      NIL,0,0,NIL),
         (NM_SUB,   "Half",        "H",CHECKIT+MENUTOGGLE, 2,NIL),
         (NM_SUB,   "Full",        "F",CHECKIT+MENUTOGGLE, 1,NIL),
         (NM_END,   NIL,NIL,0,0,NIL));

    Project_Menu      = 0;
    Project_Menu_Save = 0;
    Project_Menu_Quit = 1;

    Serial_Menu       = 1;
    Serial_Menu_Baud  = 0;
    Baud_Rate300      = 0;
    Baud_Rate1200     = 1;
    Baud_Rate2400     = 2;
    Baud_Rate4800     = 3;
    Baud_Rate9600     = 4;
    Baud_Rate19200    = 5;
    Baud_Rate38400    = 6;
    Baud_Rate115200   = 7;

    Serial_Menu_Data  = 1;
    Data_Size7N2      = 0;
    Data_Size7E1      = 1;
    Data_Size7O1      = 2;
    Data_Size8N1      = 3;

    Serial_Menu_Duplex = 2;
    Duplex_Half        = 0;
    Duplex_Full        = 1;

var
    IMessage    : IntuiMessage;
    Msg     : MessagePtr;
    TitleBuffer : Array [0..79] of Char;

procedure DoSaveConfig;
var
    dummy : boolean;
begin
    {
      Here we just save the current values
      Next time you start SmallCom it will
      set the menus to this values.
    }

    ConfigWriteInteger("SmallCom","BaudRate",BaudRate);
    ConfigWriteInteger("SmallCom","DataBits",DataBits);
    ConfigWriteInteger("SmallCom","Parity",integer(Parity));
    ConfigWriteInteger("SmallCom","StopBits",StopBits);
    ConfigWriteBool("SmallCom","Duplex",HalfDuplex);
    dummy := SaveConfig("SmallCom.config");
end;

procedure DoReadConfig;
var
    dummy : Boolean;
    itemtotick : Short;
begin
    dummy := OpenConfig("SmallCom.config");
    {
      Now read in the values from the config.
      If it does not exists use the default
      values.
    }

    { the default value of BaudRate is 2400 }
    BaudRate := ConfigReadInteger("SmallCom","BaudRate",BaudRate);

    { the default value of DataBits is 8 }
    DataBits := Byte(ConfigReadInteger("SmallCom","DataBits",DataBits));

    { the default value of Parity is no_parity (0) }
    Parity := ParityType(ConfigReadInteger("SmallCom","Parity",Integer(Parity)));

    { the default value of StopBits is 1 }
    StopBits := Byte(ConfigReadInteger("SmallCom","StopBits",StopBits));

    { the default value of HalfDuplex is false }
    HalfDuplex := ConfigReadBool("SmallCom","Duplex",HalfDuplex);

    {
       Now we have to scan the values for MenuCheck
    }

    case BaudRate of
       300 : itemtotick := Baud_Rate300;
      1200 : itemtotick := Baud_Rate1200;
      2400 : itemtotick := Baud_Rate2400;
      4800 : itemtotick := Baud_Rate4800;
      9600 : itemtotick := Baud_Rate9600;
     19200 : itemtotick := Baud_Rate19200;
     38400 : itemtotick := Baud_Rate38400;
    115200 : itemtotick := Baud_Rate115200;
    else itemtotick := Baud_Rate2400;
    end;

    CheckMenu(w,Serial_Menu,Serial_Menu_Baud,itemtotick);

    case DataBits of
       7 : begin
           case Parity of
              no_parity   : itemtotick := Data_Size7N2;
              even_parity : itemtotick := Data_Size7E1;
              odd_parity  : itemtotick := Data_Size7O1;
           end;
           end;
       8 : itemtotick := Data_Size8N1;
    end;
    CheckMenu(w,Serial_Menu,Serial_Menu_Data,itemtotick);

    if HalfDuplex = true then CheckMenu(w,Serial_Menu,Serial_Menu_Duplex,0)
       else CheckMenu(w,Serial_Menu,Serial_Menu_Duplex,1);
end;

Procedure MakeWindowTitle;
var
    TitlePtr : String;
    NumBuff  : Array [0..79] of Char;
    Error    : Integer;
begin
    TitlePtr := Adr(TitleBuffer);
    strcpy(TitlePtr, "SmallCom     ");
    Error := IntToStr(Adr(NumBuff), BaudRate);
    strcat(TitlePtr, Adr(NumBuff));
    NumBuff[0] := ' ';
    NumBuff[1] := Chr(DataBits + 48);
    case Parity of
      no_parity : NumBuff[2] := 'N';
      even_parity : NumBuff[2] := 'E';
      odd_parity  : NumBuff[2] := 'O';
    end;
    NumBuff[3] := Chr(StopBits + 48);
    NumBuff[4] := '\0';
    strcat(TitlePtr, Adr(NumBuff));
    SetWindowTitles(w, TitlePtr, Nil);
end;

Function CreateExtIO(ioReplyPort : MsgPortPtr; Size : Integer) : Address;
var
    Request : IOStdReqPtr;
begin
    if ioReplyPort = Nil then
    CreateExtIO := Nil;

    Request := AllocMem(Size, MEMF_CLEAR + MEMF_PUBLIC);
    if Request = Nil then
    CreateExtIO := Nil;

    with Request^.io_Message.mn_Node do begin
    ln_Type := NT_Message;
    ln_Pri := 0;
    end;
    Request^.io_Message.mn_ReplyPort := ioReplyPort;
    CreateExtIO := Request;
end;


Procedure DeleteExtIO(Request : Address; Size : Integer);
var
    Req : IOStdReqPtr;
begin
    Req := Request;
    with Req^ do begin
    io_Message.mn_Node.ln_Type := ($FF);
    io_Device := Address(-1);
    io_Unit := Address(-1);
    end;
    FreeMem(Request, Size);
end;


Procedure Die;
var
    Error : Integer;
begin
    if SerialWrite <> Nil then begin
    if CheckIO(SerialRead) = Nil then begin
        Error := AbortIO(SerialRead);
        Error := WaitIO(SerialRead);
    end;
    CloseDevice(SerialWrite);
    DeleteExtIO(SerialWrite, SizeOf(IOExtSer));
    if SerialRead <> Nil then
        DeleteExtIO(SerialRead, SizeOf(IOExtSer));
    end;

    if ConsoleWrite <> Nil then begin
    CloseDevice(ConsoleWrite);
    DeleteStdIO(ConsoleWrite);
    end;
    if MenuStrip <> nil then begin
       ClearMenuStrip(w);
       FreeMenus(MenuStrip);
    end;
    if vi <> nil then FreeVisualInfo(vi);
    if w <> Nil then CloseWindowSafely(w);
    if s <> nil then UnlockPubScreen(nil,s);
    if GadToolsBase <> nil then CloseLibrary(GadToolsBase);
    FlushConfig;
    Exit(0);
end;

Procedure SendSerial(IO : IOExtSerPtr; Data : Address; Size : Integer);
var
    Error : Short;
begin
    with IO^.IOSer do begin
    io_Data := Data;
    io_Length := Size;
    io_Command := CMD_WRITE;
    end;
    Error := DoIO(IO);
end;

Procedure QueueSerialRead;
var
    Waiting : Integer;
begin
    with SerialRead^.IOSer do begin
    io_Command := SDCMD_QUERY;
    Waiting := DoIO(SerialRead);
    Waiting := io_Actual;
    if Waiting = 0 then
        Waiting := 1
    else if Waiting > 80 then
        Waiting := 80;
    io_Length := Waiting;
    io_Command := CMD_READ;
    io_Data := SerialReceiveBuffer;
    end;
    SendIO(SerialRead);
end;


Procedure SetSerialParams;
var
    Error : Short;
begin
    with SerialWrite^ do begin
    io_ReadLen  := DataBits;
    io_BrkTime  := 750000;
    io_Baud     := BaudRate;
    io_WriteLen := DataBits;
    io_StopBits := StopBits;
    io_RBufLen  := 4000;
    io_TermArray.TermArray0 := $51040303;
    io_TermArray.TermArray1 := $03030303;
    io_CtlChar  := SER_DEFAULT_CTLCHAR;
    case parity of
      no_parity : io_SerFlags := 0;
      even_parity   : io_SerFlags := SERF_PARTY_ON;
      odd_parity    : io_SerFlags := SERF_PARTY_ON + SERF_PARTY_ODD;
    end;
    IOSer.io_Command := SDCMD_SETPARAMS;
    end;
    if CheckIO(SerialRead) = Nil then begin
    Error := AbortIO(SerialRead);
    Error := WaitIO(SerialRead);
    end;
    Error := DoIO(SerialWrite);
    if Error <> 0 then
    ConWrite(ConsoleWrite, "\nError setting serial port paramters\n",37);
    QueueSerialRead;
end;


Function OpenSerialDevice : Boolean;
var
    Error : Short;
begin
    SerialWrite := CreateExtIO(w^.UserPort, SizeOf(IOExtSer));
    if SerialWrite = Nil then
    OpenSerialDevice := False;
    SerialRead := CreateExtIO(w^.UserPort, SizeOf(IOExtSer));
    if SerialWrite = Nil then begin
    DeleteExtIO(SerialWrite, SizeOf(IOExtSer));
    SerialWrite := Nil;
    OpenSerialDevice := False;
    end;

    with SerialWrite^ do begin
    io_ReadLen  := DataBits;
    io_BrkTime  := 750000;
    io_Baud     := BaudRate;
    io_WriteLen := DataBits;
    io_StopBits := StopBits;
    io_RBufLen  := 4000;
    io_SerFlags := 0;
    io_SerFlags := 0;
    end;

    Error := OpenDevice("serial.device", 0, SerialWrite, 0);

    if Error = 0 then begin
    SerialRead^ := SerialWrite^;
    QueueSerialRead;
    SetSerialParams;
    OpenSerialDevice := True;
    end else begin
    DeleteExtIO(SerialWrite, SizeOf(IOExtSer));
    DeleteExtIO(SerialRead, SizeOf(IOExtSer));
    SerialWrite := Nil;
    OpenSerialDevice := False;
    end;
end;


Function OpenConsoleDevice : Boolean;
var
    Error : Short;
begin
    ConsoleWrite := CreateStdIO(w^.UserPort);
    if ConsoleWrite = Nil then
    OpenConsoleDevice := False;

    with ConsoleWrite^ do begin
    io_Data := w;
    io_Length := SizeOf(Window);
    end;

    Error := OpenDevice("console.device", 0, ConsoleWrite, 0);
    if Error = 0 then
    ConsoleBase := ConsoleWrite^.io_Device
    else
    DeleteStdIO(ConsoleWrite);
    OpenConsoleDevice := Error = 0;
end;


Procedure OpenEverything;
begin
    SerialSendBuffer    := AllocString(80);
    ConsoleSendBuffer   := AllocString(80);
    SerialReceiveBuffer := AllocString(80);
    TranslateBuffer := AllocString(80);
    
    GadToolsBase := OpenLibrary("gadtools.library",37);
    if GadToolsBase = nil then Die;

    s := LockPubScreen(nil);
    if s = nil then Die;

    w := OpenWindowTags(NIL,
                 WA_IDCMP,       IDCMP_CLOSEWINDOW or IDCMP_MENUPICK or IDCMP_RAWKEY,
                 WA_Left,        0,
                 WA_Top,         0,
                 WA_Width,       320,
                 WA_Height,      200,
                 WA_MinWidth,    0,
                 WA_MinHeight,   0,
                 WA_MaxWidth,    -1,
                 WA_MaxHeight,   -1,
                 WA_DepthGadget, true,
                 WA_DragBar,     true,
                 WA_CloseGadget, true,
                 WA_SizeGadget,  true,
                 WA_SmartRefresh,true,
                 WA_Activate,    true,
                 WA_SizeBBottom, true,
                 WA_PubScreen,   s,
                 TAG_END);
    IF w = NIL THEN Die;

    vi := GetVisualInfo(w^.WScreen, TAG_END);
    if vi = nil then Die;

    if OSVersion >= 39 then MenuStrip := CreateMenus(adr(nm),GTMN_FrontPen,1,TAG_END)
    else MenuStrip := CreateMenus(adr(nm),TAG_END);

    if MenuStrip = nil then Die;
    if LayoutMenus(MenuStrip,vi,TAG_END)=false then Die;

    if SetMenuStrip(w, MenuStrip) = false then Die;

    if not OpenConsoleDevice then
    Die;

    if not OpenSerialDevice then
    Die;
    DoReadConfig;
    MakeWindowTitle;
end;


Procedure ProcessIntuitionMsg;
var
    IMessage    : IntuiMessage;
    IPtr    : IntuiMessagePtr;

    Procedure ProcessMenu;
    var
    MenuNumber  : Short;
    ItemNumber  : Short;
    SubItemNumber   : Short;
    begin
    if IMessage.Code = MENUNULL then
        return;

    MenuNumber := MenuNum(IMessage.Code);
    ItemNumber := ItemNum(IMessage.Code);
    SubItemNumber := SubNum(IMessage.Code);

    case MenuNumber of
      0 : begin
          case ItemNumber of
          Project_Menu_Save : DoSaveConfig;
          Project_Menu_Quit : QuitStopDie := True;
          end;
          end;
      1 : begin
          case ItemNumber of
            Serial_Menu_Baud : BaudRate := BaudRates[SubItemNumber];
            Serial_Menu_Data : case SubItemNumber of
              Data_Size7N2 : begin
                  DataBits := 7;
                  Parity   := no_parity;
                  StopBits := 2;
                  end;
              Data_Size7E1 : begin
                  DataBits := 7;
                  Parity   := even_parity;
                  StopBits := 1;
                  end;
              Data_Size7O1 : begin
                  DataBits := 7;
                  Parity   := odd_parity;
                  StopBits := 1;
                  end;
              Data_Size8N1 : begin
                  DataBits := 8;
                  Parity   := no_parity;
                  StopBits := 1;
                  end;
            end;
            Serial_Menu_Duplex : case SubItemNumber of
              Duplex_Half : HalfDuplex := true;
              Duplex_Full : HalfDuplex := false;
            end;
          end;
          if ItemNumber < 2 then begin
              SetSerialParams;
              MakeWindowTitle;
          end;
          end;
    end;
    end;


    Procedure ProcessKeypress;
    var
    Length  : Short;
    Buffer  : Array [0..79] of Char;
    begin
    if IMessage.Code < 128 then begin
        Length := DeadKeyConvert(Adr(IMessage), TranslateBuffer, 79, Nil);
        if Length > 0 then begin
        if HalfDuplex then
            ConWrite(ConsoleWrite, TranslateBuffer, Length);
        SendSerial(SerialWrite, TranslateBuffer, Length);
        end;
    end;
    end;

begin
    IPtr := IntuiMessagePtr(Msg);
    IMessage := IPtr^;
    ReplyMsg(Msg);

    case IMessage.Class of
      IDCMP_MENUPICK    : ProcessMenu;
      IDCMP_RAWKEY      : ProcessKeypress;
      IDCMP_CLOSEWINDOW : QuitStopDie := True;
    end;
end;

Procedure ProcessSerialInput;
begin
    with SerialRead^.IOSer do begin
    if io_Actual > 0 then
        ConWrite(ConsoleWrite, SerialReceiveBuffer, io_Actual);
    end;
    QueueSerialRead;
end;

begin
    OpenEverything;
    repeat
    Msg := WaitPort(w^.UserPort);
    Msg := GetMsg(w^.UserPort);
    if Msg = MessagePtr(SerialRead) then
        ProcessSerialInput
    else
        ProcessIntuitionMsg;
    until QuitStopDie;
    Die;
end.



