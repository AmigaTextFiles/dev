Program ReadClip;

{ ReadClip - liest Text aus dem Clipboard
  Die Routine ist so geschrieben, daß sie leicht in
  eigene Programme eingebaut werden kann.

  PUBLIC DOMAIN

  Andreas Tetzl     A.Tetzl@saxonia.de
}

{$I "Include:Exec/Devices.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Devices/ClipBoard.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:Utils/StringLib.i"}

VAR Str : String;
    err : Integer;

{///"FUNCTION CreateExtIO"}
FUNCTION CreateExtIO( iop : MsgPortPtr; iosize : Integer) : Address;
VAR
    ExtIO : IOStdReqPtr;

Begin
  If iop = NIl then CreateExtIO := NIL;
  ExtIO := AllocMem( iosize, Memf_Public+Memf_Clear );
  If ExtIO = NIL then CreateExtIO := NIL;

  With ExtIO^.io_message do begin
    mn_node.ln_Type := NT_Message;
    mn_Length := iosize;
    mn_ReplyPort := iop;
  End;
  CreateExtIO := ExtIO;
End;
{///}

{///"PROCEDURE DeleteExtIO"}
Procedure DeleteExtIO( iorp : IOStdReqPtr );
Begin
  With iorp^ do begin
    io_Message.mn_node.ln_Type := $FF;
    io_Device := Address( -1 );         { * Verstümmeln *}
    io_Unit   := Address( -1 );
  End;
  FreeMem( iorp, iorp^.io_Message.mn_Length );  { * Speicher freigeben * }
End;
{///}

{ /// ------------------------- "FUNCTION ReadClip" ------------------------- }

FUNCTION ReadClip(Unit : Byte; Buffer : String; BufferSize : Integer) : Integer;

{ Parameter:
    Unit : Unit des Clipboard.device (normalerweise 0)
    Buffer : String, in den der Inhalt des Clipboards kopiert wird.
    BufferSize : Größe des Buffers
}

{ Rückgabe:
    0 : Alles OK
    1 : Clipboard.device konnte nicht geöffnet werden
    2 : Kein IFF-FTXT-File (kein Text im Clipboard)
    3 : Nicht genug Speicher
}

VAR err : Integer;
    MyPort : MsgPortPtr;
    MyReq  : IOClipReqPtr;
    Chunk : String;
    len, cklen : Integer;
    buf : Address;

PROCEDURE Clip_Read(Buffer : Address; size : Integer);
BEGIN
 MyReq^.io_Command:=CMD_READ;
 MyReq^.io_Data:=Buffer;
 MyReq^.io_Length:=size;
 err:=DoIO(MyReq);
END;

Begin
 StrCpy(Str,"");

 MyPort:=CreatePort(NIL,0);
 If MyPort=NIL then ReadClip:=1;

 MyReq:=CreateExtIO(MyPort,SizeOf(IOClipReq));
 If MyReq=NIL then
  Begin
   DeletePort(MyPort);
   ReadClip:=1;
  end;

 { Clipboard.device öffnen }
 err:=OpenDevice("clipboard.device",UNIT,MyReq,0);
 If err<>0 then
  Begin
   DeleteExtIO(IoStdReqPtr(MyReq));
   DeletePort(MyPort);
   ReadClip:=1;
  end;

 Chunk:=AllocString(5);

 Clip_Read(Chunk,4);  { FORM-Kennung lesen }
 Clip_Read(@len,4);   { Länge lesen }
 len:=len+8;          { gesamte Dateilänge }
 Clip_Read(Chunk,4);  { IFF-Typ lesen }
 If StrEq(Chunk,"FTXT")=FALSE then
  BEGIN
   CloseDevice(MyReq);
   DeleteExtIO(IoStdReqPtr(MyReq));
   DeletePort(MyPort);
   ReadClip:=2;
  END;

 While MyReq^.io_Offset<len do
  BEGIN
   Clip_Read(Chunk,4);  { Chunk-Kennung lesen }
   Clip_Read(@cklen,4); { Chunk-länge lesen }
   buf:=AllocMem(cklen,MEMF_ANY);
   If buf=NIL then ReadClip:=3;
   Clip_Read(buf,cklen); { Daten lesen }

   If StrEq(Chunk,"CHRS") then  { CHRS-Chunk gefunden }
    BEGIN
     If cklen<buffersize then buffersize:=cklen;
     StrnCpy(Buffer,buf,buffersize);  { Daten kopieren }
    END;

   FreeMem(buf,cklen);          { Speicher freigeben }
  END;

 CloseDevice(MyReq);
 DeleteExtIO(IoStdReqPtr(MyReq));
 DeletePort(MyPort);
end;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "Main" -------------------------------- }

BEGIN
 Str:=AllocString(100);

 err:=ReadClip(0,Str,99);

 Writeln(Str);
 FreeString(Str);
END.

{ /// ------------------------------------------------------------------------ }
