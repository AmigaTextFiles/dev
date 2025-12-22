Program WriteClip;

{ WriteClip - schreibt Text ins dem Clipboard
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
{$I "Include:Utils/Parameters.i"}

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

{ /// ------------------------- "FUNCTION WriteClip" ------------------------- }

FUNCTION WriteClip(Unit : Byte; Buffer : String; BufferSize : Integer) : Integer;

{ Parameter:
    Unit : Unit des Clipboard.device (normalerweise 0)
    Buffer : String, der ins Clipboard geschrieben wird
    BufferSize : Größe des Buffers
}

{ Rückgabe:
    0 : Alles OK
    1 : Clipboard.device konnte nicht geöffnet werden
}

VAR err : Integer;
    MyPort : MsgPortPtr;
    MyReq  : IOClipReqPtr;
    len : Integer;

PROCEDURE Clip_Write(Buffer : Address; size : Integer);
BEGIN
 MyReq^.io_Command:=CMD_WRITE;
 MyReq^.io_Data:=Buffer;
 MyReq^.io_Length:=size;
 err:=DoIO(MyReq);
END;

Begin
 MyPort:=CreatePort(NIL,0);
 If MyPort=NIL then WriteClip:=1;

 MyReq:=CreateExtIO(MyPort,SizeOf(IOClipReq));
 If MyReq=NIL then
  Begin
   DeletePort(MyPort);
   WriteClip:=1;
  end;

 { Clipboard.device öffnen }
 err:=OpenDevice("clipboard.device",UNIT,MyReq,0);
 If err<>0 then
  Begin
   DeleteExtIO(IoStdReqPtr(MyReq));
   DeletePort(MyPort);
   WriteClip:=1;
  end;

 Clip_Write("FORM",4);
 len:=12+BufferSize;   { FTXT+CHRS+size+BufferSize }
 If Odd(BufferSize) then Inc(len);
 Clip_Write(adr(len),4);
 Clip_Write("FTXTCHRS",8);
 Clip_Write(adr(Buffersize),4);
 Clip_Write(Buffer,BufferSize);
 If Odd(BufferSize) then Clip_Write(NIL,1); { immer gerade Dateigröße }

 { fertig }
 MyReq^.io_Command:=CMD_UPDATE;
 err:=DoIO(MyReq);

 CloseDevice(MyReq);
 DeleteExtIO(IoStdReqPtr(MyReq));
 DeletePort(MyPort);
end;

{ /// ------------------------------------------------------------------------ }

{ /// -------------------------------- "Main" -------------------------------- }

BEGIN
 Str:=AllocString(100);
 GetParam(1, Str);
 If StrEq(Str,"") then
  BEGIN
   Writeln("Usage: WriteClip String");
   Exit;
  END;

 err:=WriteClip(0,Str,Strlen(Str));

 Writeln("String written to clipboard");
 FreeString(Str);
END.

{ /// ------------------------------------------------------------------------ }
