Program PrinterDemo;

{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Devices.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Devices/Printer.i"}
{$I "Include:Devices/Parallel.i"}

VAR  i, OpDv, error : Integer;
     MyPort  : MsgPortPtr;
     MyReq   : IoStdReqPtr;
     Buffer : String;

     Status : Array[0..1] of Byte;


PROCEDURE PRT_Write(Buffer : Address; len : Integer);
VAR i : Integer;
BEGIN
  With MyReq^ do Begin
   io_Command:=CMD_WRITE;
   io_data:=Buffer;
   io_Length:=len;
  end;
  i:=DoIO(MyReq);
END;

Begin
  MyPort:=CreatePort(NIL,0);
  MyReq:=CreateStdIO(MyPort);
  OpDv:=OpenDevice("printer.device",0,MyReq,0);

  Buffer:=AllocString(20);

  Writeln("examining printer status ...\n");

  With MyReq^ do Begin
   io_Command:=PRD_QUERY;
   io_data:=adr(Status);
  end;
  i:=DoIO(MyReq);

  If (Status[0] AND 1)<>0 then Writeln("printer offline")
                               else Writeln("printer online");
  If (Status[0] AND 2)<>0 then Writeln("paper OK")
                               else Writeln("paper out");
  If (Status[0] AND 4)<>0 then Writeln("printer is ready")
                               else Writeln("printer is busy");

  If (Status[0] AND 4)<>0 then
   BEGIN
    Writeln("\nsending page 1 ...");
    StrCpy(Buffer,"page 1");
    PRT_Write(Buffer,StrLen(Buffer));


    Writeln("sending FORM FEED ...");
    Buffer[0]:=chr($0C);
    PRT_Write(Buffer,1);


    Writeln("sending page 2 ...\n");
    StrCpy(Buffer,"page 2");
    PRT_Write(Buffer,StrLen(Buffer));
   END;

  Writeln("\nready");

  CloseDevice(MyReq);
  DeleteStdIO(MyReq);
  DeletePort(MyPort);
end.

