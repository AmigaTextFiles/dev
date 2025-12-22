Program HotKey;

{ /// ------------------------------ "includes" ------------------------------ }

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Exec/Devices.i"}
{$I "Include:Devices/Input.i"}
{$I "Include:Devices/InputEvent.i"}
{$I "Include:Devices/KeyMap.i"}
{$I "Include:Devices/Console.i"}
{$I "Include:Devices/ConUnit.i"}
{$I "Include:Libraries/Commodities.i"}
{$I "Include:Libraries/Asl.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:Utility/TagItem.i"}

{ /// ------------------------------------------------------------------------ }

{ /// ----------------------------- "variables" ------------------------------ }

const EVT_HOTKEY : Integer = 1;

    nb : newbroker = (
    NB_VERSION,
    "KeySim",           { string to identify this broker }
    "KeySim v0.2 - 1995 Andreas Tetzl",
    "A keyboard simulator",
    NBU_UNIQUE OR NBU_NOTIFY,
    COF_SHOW_HIDE, 0, NIL, 0
);

    HotKey = "ctrl alt v";

Const
 StdInName : String = NIL;
 StdOutName : String = NIL;
 Version = "$VER: KeySim 0.2 (5.7.95)";

 KEYDELAY = 0;  { Wartezeit in Ticks nach beliebiger Taste }
 CRDELAY  = 50; { Wartezeit in Ticks nach CR (ENTER) }

Type
 Key_Struct = Record
  Code      : Byte;
  Qualifier : WORD;
 end;

VAR
    ASCII : Array[0..255] of Key_Struct;
    filename, dir : String;
    c : Byte;

    broker_mp : MsgPortPtr;
    broker,filter,sender,translate : CxObjPtr;
    cxsigflag : Integer;
    Msg : CxMsgPtr;

{ /// ------------------------------------------------------------------------ }

{ /// --------------------------- "PROCEDURE Req" ---------------------------- }

PROCEDURE Req(Txt : String);
const
    es : EasyStruct = (0,0,NIL,NIL,NIL);

VAR i : Integer;

begin
 es.es_StructSize:=SizeOf(EasyStruct);
 es.es_Flags:=0;
 es.es_Title:="Information";
 es.es_TextFormat:=Txt;
 es.es_GadgetFormat:="OK";

 i:=EasyRequestArgs(NIL,adr(es),0,NIL);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------ "PROCEDURE CleanExit" ------------------------- }

PROCEDURE CleanExit(Why : String; RC : Integer);
BEGIN
 If broker<>NIL then DeleteCxObjAll(broker);

 If broker_mp<>NIL then
  BEGIN
   Msg:=CxMsgPtr(GetMsg(broker_mp));
   While Msg<>NIL do
   BEGIN
    ReplyMsg(MessagePtr(msg));
    Msg:=CxMsgPtr(GetMsg(broker_mp));
   end;

   DeleteMsgPort(broker_mp);
  END;

 If CxBase<>NIL then CloseLibrary(CxBase);
 If Why<>NIL then Req(Why);
 Exit(RC);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ---------------------- "PROCEDURE CheckFile" --------------------------- }

FUNCTION CheckFile : Boolean;
VAR OldDir, NewDir, f : FileLock;
BEGIN
 OldDir:=NIL;
 NewDir:=Lock(dir,SHARED_LOCK);
 If NewDir<>NIL then OldDir:=CurrentDir(NewDir);

 f:=Lock(filename,SHARED_LOCK);
 If f=NIL then
  BEGIN
   If OldDir<>NIL then NewDir:=CurrentDir(OldDir);
   CheckFile:=FALSE;
  END;

 UnLock(f);
 If OldDir<>NIL then NewDir:=CurrentDir(OldDir);
 CheckFile:=TRUE;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ----------------------- "PROCEDURE FileRequest" ------------------------ }

FUNCTION FileRequest : Boolean;
VAR fr : FileRequesterPtr;
    OK : Boolean;
    TagList : Array[0..1] of TagItem;
BEGIN
 AslBase:=OpenLibrary("asl.library",37);
 If AslBase=NIL then FileRequest:=FALSE;

 TagList[0].ti_Tag:=ASL_Hail;
 TagList[0].ti_Data:=Integer("KeySim: HotKey = <ctrl alt v>");
 TagList[1].ti_Tag:=TAG_DONE;

 fr:=AllocAslRequest(ASL_FileRequest,adr(TagList));
 If fr=NIL then
  BEGIN
   CloseLibrary(AslBase);
   FileRequest:=FALSE;
  END;

 OK:=AslRequest(fr,NIL);
 If OK=FALSE then
  BEGIN
   FreeAslRequest(fr);
   CloseLibrary(AslBase);
   FileRequest:=FALSE;
  END;

 StrCpy(filename,fr^.rf_File);
 StrCpy(dir,fr^.rf_Dir);

 FreeAslRequest(fr);
 CloseLibrary(AslBase);

 FileRequest:=TRUE;
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------- "PROCEDURE WriteKey" ------------------------- }

PROCEDURE WriteKey(asc : Byte);
VAR event       : InputEvent;
    err : Integer;
    port        : MsgPortPtr;
    ioreq       : IOStdReqPtr;
BEGIN
 port := CreatePort (NIL, 0);
 ioreq := CreateStdIO (port);
 err:=OpenDevice ("input.device", 0, ioreq, 0);

 { key down }

 event.ie_Class:=IECLASS_RAWKEY;
 event.ie_Code:=ASCII[asc].Code;
 event.ie_Qualifier:=ASCII[asc].Qualifier;

 ioreq^.io_Data := adr(event);
 ioreq^.io_Command := IND_WRITEEVENT;
 ioreq^.io_Length:=sizeof(inputevent);
 err := DoIO (ioreq);

 { key up }

 event.ie_Class:=IECLASS_RAWKEY;
 event.ie_Code:=ASCII[asc].Code OR IECODE_UP_PREFIX;
 event.ie_Qualifier:=ASCII[asc].Qualifier;

 ioreq^.io_Data := adr(event);
 ioreq^.io_Command := IND_WRITEEVENT;
 ioreq^.io_Length:=sizeof(inputevent);
 err := DoIO (ioreq);

 If ioreq<>NIL then CloseDevice (ioreq);
 If ioreq<>NIL then DeleteStdIO (ioreq);
 If port<>NIL then DeletePort (port);
END;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------- "PROCEDURE KeySim" -------------------------- }

PROCEDURE KeySim;
VAR FH : FileHandle;
    err : Integer;
    OldDir, NewDir : FileLock;
BEGIN
 OldDir:=NIL;
 NewDir:=Lock(dir,SHARED_LOCK);
 If NewDir<>NIL then OldDir:=CurrentDir(NewDir);

 FH:=DOSOpen(filename,MODE_OLDFILE);
 If OldDir<>NIL then NewDir:=CurrentDir(OldDir);
 If FH=NIL then
  BEGIN
   DisplayBeep(NIL);
   Return;
  END;

 err:=Seek(FH,0,OFFSET_BEGINNING);
 err:=DOSRead(FH,adr(c),1);
 While err<>0 do
  BEGIN
   Delay(KEYDELAY);
   WriteKey(c);
   If c=10 then Delay(CRDELAY);
   err:=DOSRead(FH,adr(c),1);
  END;

 DOSClose(FH);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ----------------------- "PROCEDURE CreateASCII" ------------------------ }

PROCEDURE CreateASCII;
Var port        : MsgPortPtr;
    conreq      : IOStdReqPtr;
    keys : KeyMapPtr;
    event       : InputEvent;
    buffer : String;
    i, j, err : Integer;

BEGIN
 port:=CreatePort(NIL,0);
 conreq:=CreateStdIO(port);
 err:=OpenDevice("console.device",CONU_LIBRARY,conreq,0);
 if err<>0 then CleanExit("Console",10);

 ConsoleBase:=conreq^.io_Device;

 New(keys);
 conreq^.io_Data:=keys;
 conreq^.io_Length:=SizeOf(KeyMap);
 conreq^.io_Command:=CD_ASKKEYMAP;
 err:=DoIO(conreq);
 If err<>0 then CleanExit("DoIO",err);

 Buffer:=AllocString(20);
 For i:=0 to 64 do
  BEGIN
   For j:=1 to 3 do
    BEGIN
     StrCpy(Buffer,"");
     event.ie_NextEvent:=NIL;
     event.ie_Class:=IECLASS_RAWKEY;
     event.ie_Code:=i;
     Case j of
      1 : event.ie_Qualifier:=0;
      2 : event.ie_Qualifier:=IEQUALIFIER_LSHIFT;
      3 : event.ie_Qualifier:=IEQUALIFIER_LALT;
     end;

     err:=RawKeyConvert(adr(event),Buffer,10,keys);
     If (err<>0) and (Ord(Buffer[0])>=0) and (Ord(Buffer[0])<=255) then
      BEGIN
       ASCII[Ord(Buffer[0])].Code:=event.ie_Code;
       ASCII[Ord(Buffer[0])].Qualifier:=event.ie_Qualifier;
      END;
    END;
  END;

 ASCII[10].Code:=$44;
 ASCII[10].Qualifier:=0;

 CloseDevice (conreq);
 DeleteStdIO (conreq);
 DeletePort (port);
END;

{ /// ------------------------------------------------------------------------ }

{ /// ------------------------ "PROCEDURE ProcessMsg" ------------------------ }

PROCEDURE ProcessMsg;
VAR sigrcvd, msgid, msgtype : Integer;
    returnvalue : Boolean;

begin
 returnvalue:=TRUE;
 while returnvalue do
  Begin
   sigrcvd := Wait(cxsigflag OR SIGBREAKF_CTRL_C);

   if (sigrcvd AND SIGBREAKF_CTRL_C)=SIGBREAKF_CTRL_C then
    Begin
     returnvalue := FALSE;
    end;

   Msg:=CXMsgPtr(GetMsg(broker_mp));
   While Msg<>NIL do
    Begin
     msgid := CxMsgID(msg);
     msgtype := CxMsgType(msg);
     ReplyMsg(MessagePtr(msg));

     Case MsgType of
      CXM_IEVENT : Begin
                    If msgid=EVT_HOTKEY then KeySim;
                   end;
      CXM_COMMAND : Begin
                     Case msgid of
                      CXCMD_DISABLE : If ActivateCxObj(broker, 0)=0 then;
                      CXCMD_ENABLE  : If ActivateCxObj(broker, 1)=0 then;
                      CXCMD_KILL    : returnvalue := FALSE;
                      CXCMD_UNIQUE  : returnvalue := FALSE;
                      CXCMD_APPEAR  : If FileRequest=FALSE then
                                       If CheckFile=FALSE then Req("can't open file");
                     end;
                    end;
     end;
     Msg:=CXMsgPtr(GetMsg(broker_mp));
    end;
  end;
end;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "main" -------------------------------- }

Begin
 filename:=AllocString(300);
 dir:=AllocString(300);
 GetParam(1, filename);

 If StrEq(filename,"") then
  If FileRequest=FALSE then CleanExit(NIL,10);
 If StrEq(filename,"") then CleanExit("no file",10);
 If CheckFile=FALSE then CleanExit("can't open file",10);

 CreateASCII;

 CxBase := OpenLibrary("commodities.library", 37);
 If cxBase=NIL then CleanExit("commodities",10);

 broker_mp := CreateMsgPort;

 cxsigflag := 1 shl broker_mp^.mp_SigBit;
 nb.nb_Port := broker_mp;
 nb.nb_Pri:=0;

 broker := CxBroker(adr(nb), NIL);
 
 filter := CreateCxObj(CX_FILTER, Integer(HotKey) ,0);
 AttachCxObj(broker, filter);
 
 sender := CreateCxObj(CX_SEND, Integer(broker_mp), EVT_HOTKEY);
 AttachCxObj(filter, sender);
 
 translate := CreateCxObj(CX_TRANSLATE,0,0);
 AttachCxObj(filter, translate);

 If CxObjError(filter)=0 then
  Begin
   If ActivateCxObj(broker, 1)=0 then;
   ProcessMsg;
  end;

 CleanExit(NIL,0);
end.

{ /// ------------------------------------------------------------------------ }
