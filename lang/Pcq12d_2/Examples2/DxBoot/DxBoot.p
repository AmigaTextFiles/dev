Program DxBoot;

{$I "include:exec/IO.i"          }	{ * Version 1.2, 22.12.1992 * }
{$I "include:exec/Memory.i"      }	{ * (C) by "Diesel" Bernd   * }
{$I "include:exec/Devices.i"     }	{ * Künnen, D-4477 Twist    * }
{$I "include:exec/ExecBase.i"    }
{$I "include:Utils/IOUtils.i"    }
{$I "include:libraries/dos.i"    }
{$I "include:utils/stringlib.i"  }
{$I "include:utils/parameters.i" }

CONST
	CMD_MOTOR   = 9;		{ ist nicht in execIO.i def., }

	CMD__Null   =  0;
	CMD__Kill   =  1;
	CMD__Read   =  2;
	CMD__Write  =  3;
	CMD__Chk    =  4;
	CMD__inst   =  5;
	CMD__Cmp    =  6;
	CMD__Type   =  7;	{ * Nummern der einzelnen * }
	CMD__Help   =  8;	{ * Dxboot-Kommandos      * }
	CMD__Test   =  9;

	on          = 1;
	off	    = 0;
	dev         : String = "trackdisk.device";

	ErrorTD_IO : String = " Error on trackdisk-IO\n";
	DosErr_Rf  : String = " Error reading file\n";
	DosErr_Wf  : String = " Error writing file\n";



Type
	BB    = Array[0..1023] Of Byte;	   { * 1 Bootblock = 1024 Bytes * }
	BBPtr = ^BB;

VAR
    comm,
    i        : Short;
    ok,
    dfx      : Integer;
    ArgStr   : String;
    Handle   : FileHandle;
    BB1,
    BB2      : BBPtr;




{ --- Zum sauberen Verlassen des Programms, egal, von wo ! --- }

Procedure Cleanexit(why : String; RT : Integer);
Begin
	IF handle <>NIL then DOSClose(handle);  { --- File schließen --- }
	IF BB1    <>NIL then FreeMem(BB1,1024); { --- ChipMem freigeben --- }

	IF why<>NIL then begin			{ --- Wenn Fehler: --- }
	  writeln(why);
	  If RT=5 then write("\nUsage : DxBoot cmd unit[0..3] <filename>\n",
	 		     "Type    DxBoot ? for help\n\n");

	  Delay(100);				{ --- 2 s warten --- }
	end;
	Exit(RT);
End;



{ --- HexDump des BB`s ausgeben --- }

Procedure DumpBB;

Const
	hex  : ARRAY[0..15] OF Char =  ('0123456789ABCDEF');

Var
	BW  : Byte;
	k,j : Short;
	Buf : String;	

Begin

      k:=0;				{ --- Setup --- }
      Buf:=AllocString(70);

      Buf[48]:=' ';			{ --- Leerzeichen --- }
      Buf[49]:=' ';
      Buf[66]:=chr(10);			{ --- Return & linefeed --- }
      Buf[67]:=chr(0);			{ --- Abschlußbyte/Str.=0 --- }

      For i:=1 to 64 Do BEGIN		{ --- 64 Zeile zu 16 Bytes --- }
	For j:=0 to 15 Do Begin
	  BW:=BB1^[k];
	  Buf[j*3]:=' ';		{ --- Leerzeichen --- }
	  Buf[j*3+1]:=hex[BW DIV 16];	{ --- Byte-hälfte high ---}
	  Buf[j*3+2]:=hex[BW MOD 16];	{ --- Byte-hälfte low  --- }

	  IF ((BW > 31) AND (BW < 123)) then
	    Buf[50+j]:=chr(BW)
	  ELSE				{ --- Ggf. (A..z) --- }
	    Buf[50+j]:='.';		{ --- sonst   .   --- }

          inc(k);			{ --- k  um 1 erhöhen --- }
	End;
  	write(Buf);			{ --- Zeile ausgeben --- }
      End;
end;



Procedure InstantBB(bbm : BBPtr; v : Short);
					{ --- Trägt in bbm^ einen BB ein --- }
					{ --- je nach SYSversion 1.3/2.0 --- }
Const
	BB13 : ARRAY[0..48] OF Byte = ( $44, $4F, $53, $00, $C0, $20, $0F, $19,
					$00, $00, $03, $70, $43, $FA, $00, $18,
					$4E, $AE, $FF, $A0, $4A, $80, $67, $0A,
					$20, $40, $20, $68, $00, $16, $70, $00,
					$4E, $75, $70, $FF, $60, $FA, $64, $6F,
					$73, $2E, $6C, $69, $62, $72, $61, $72,
					$79, );

	BB20 : ARRAY[0..92] OF Byte = ( $44, $4F, $53, $00, $E3, $3D, $0E, $73,
					$00, $00, $03, $70, $43, $FA, $00, $3E,
					$70, $25, $4E, $AE, $FD, $D8, $4A, $80,
					$67, $0C, $22, $40, $08, $E9, $00, $06,
					$00, $22, $4E, $AE, $FE, $62, $43, $FA,
					$00, $18, $4E, $AE, $FF, $A0, $4A, $80,
					$67, $0A, $20, $40, $20, $68, $00, $16,
					$70, $00, $4E, $75, $70, $FF, $4E, $75,
					$64, $6F, $73, $2E, $6C, $69, $62, $72,
					$61, $72, $79, $00, $65, $78, $70, $61,
					$6E, $73, $69, $6F, $6E, $2E, $6C, $69,
					$62, $72, $61, $72, $79  );

	BBNB : ARRAY[0..2] OF Byte = ( $44, $4f, $53 );

Var
	MyExecBasePtr :	ExecBasePtr;
	j   : short;

Begin
	If v = 0 then Begin
	  MyExecBasePtr:=Address(4);
	  If MyExecBasePtr^.SoftVer < 36	{ --- Kick 1.3 ? --- }
	  then  v := 13
	  else  v := 20;
	End;

	If v = 13 then
	  for j:=0 to 48 do  bbm^[j]:=BB13[j];	{ --- 1.3-BB kopieren --- }

	If v = 20 then
	  for j:=0 to 92 do  bbm^[j]:=BB20[j];	{ --- 2.0-BB kopieren --- }

	If v = -1 then
	  for j:=0 to  2 do  bbm^[j]:=BBNB[j];	{ --- Not booting Disk --- }


	for j:=j to 1023 do  bbm^[j]:=0;	{ --- mit 0 auffüllen --- }

End;



	{ ------- Bootblock-Ein/Ausgabe ------- }

Function RWBB(unit: Integer; cmd: Short; mem: Address):Boolean;


PROCEDURE Motor(iostdr:IOStdReqPtr; switch:Integer);
Var							{ dfx-Motor an/aus }
	okm : Integer;
BEGIN
  iostdr^.io_Command:=CMD_MOTOR;			{ Motor schalten   }
  iostdr^.io_Length:=switch;				{ on/off übergeben }
  okm:=DoIO(iostdr);					{ GO ! }
END;	{ Motor }



Var
    myReq    : IOStdReqPtr;			{ zur Kommun. mit dem }
    myPort   : MsgPortPtr;			{ trackdisk.device    }


Begin
	myPort:=CreatePort(NIL,0);		{ Nachrichtenport des Laufwerks }
	myReq:=CreateStdIO(myPort);		{ Kommunikationsport einrichten }

	ok:=OpenDevice( dev, unit, myReq, 0 );	{ TrackDisk öffnen }

	IF ok=0 THEN BEGIN

	  With myReq^ do begin
	    io_Data    := mem;			{ Speicherbereich }
	    io_Offset  := 0;			{ Offset = Block 0 }
	    io_Length  := 1024;			{ 1024 bytes }
	    io_Command := CMD_CLEAR;		{ zuerst Trackbuffer löschen }
	  end;

	  ok:=DoIO(myReq);
	  If ok=0 then begin			{ wenn gelöscht, dann }

	    myReq^.io_command := cmd;		{ BB schreiben/lesen  }
	    ok:=DoIO(myReq);

	    If (ok=0) AND (cmd	=CMD__Write) then begin
	      myReq^.io_Command := CMD_UPDATE;
	      ok:=DoIO(myReq);			{ zum Schreiben "updaten" }
	    end;				{ d.h. Trackbuffer -> Disk }

	  end;

	  If comm = CMD__Test Then		{ Bootblock ausführen : }
	  Begin
{$A
_jumpIntoBBcode:

	move.l	 4,a6		; execbase in a6
	move.l	-4(a5),a1	; IOsStdReqPtr in a1
	move.l	 8(a5),a2	; ^BB in Mem

	jsr	12(a2)		; 'starte' BB

}

	  End;


	  Motor(myReq,off);			{ Motor aus & fertig }

	  CloseDevice(myReq);			{ Device schließen   }
	  DeleteStdIO(myReq);			{ IOReq entfernen    }
	  DeletePort(myPort);			{ MsgPort entfernen  }

	  If ok=0 then RWBB:=TRUE else RWBB:=False;

	End Else RWBB:=FALSE;

End;


{ --- File-Ein/Ausgabe --- }

Function FileIO(cmd: Short; hdl: FileHandle; mem: Address): Boolean;
Begin
	CASE cmd of
	Cmd__Read  :	ok:=DOSRead(hdl,mem,1024);	{ BB aus Datei }
	Cmd__Write :	ok:=DOSWrite(hdl,mem,1024);	{ BB sichern   }
	END;

	IF ok<>1024			{ Bei Fehler Flase zurück }
	then FileIO:=False
	else FileIO:=True;
End;


{ --- File je nach Bedarf öffnen, zur Ein/Ausgabe --- }

Procedure OpenFile(Mode: Integer);
begin
	GetParam(3,ArgStr);
	If strlen(ArgStr)=0 then Cleanexit(" No filename",5);

	handle:=DosOpen(ArgStr, Mode);
	If handle=NIL then CleanExit(" Could not open IO-File\n",10);
end;


{ ------ Compare Bootblocks - gibt False zurück, wenn different  ----- }

Function CMPBB( c1, c2 : BBPtr) : Boolean;
Var
	z : Short;
Begin
	For z:=0to 1023 do
	  If c1^[z] <> c2^[z]  then CMPBB := False;

	CMPBB := True;
End;



{ [1;33m--------------------  MAIN  -----------------------[0;31m }



BEGIN
  write(" [1;33mDxBoot 1.2, (C)1992 by Diesel. [3;32m\n It`s Freeware![0;31m\n\n");
  ArgStr:=AllocString(100);


  { --- Kommando holen --- }

  GetParam(1,ArgStr);
  If strlen(ArgStr)=0 then CleanExit(" No Args",5);


  { --- nach a..z konvertieren --- }

  for i:=0 to strlen(ArgStr)-1 do
    ArgStr[i]:=tolower(ArgStr[i]);


  { --- Check, ob zulässiges Kommando --- }

  comm:=Cmd__Null;

  If strcmp(ArgStr,"read")  =0	then comm:=Cmd__Read;
  If strcmp(ArgStr,"write") =0	then comm:=Cmd__Write;
  If strcmp(ArgStr,"chk")   =0	then comm:=Cmd__Chk;
  If strcmp(ArgStr,"inst")  =0	then comm:=Cmd__inst;

  If strcmp(ArgStr,"cmp")   =0	then comm:=Cmd__Cmp;
  If strcmp(ArgStr,"type")  =0	then comm:=Cmd__Type;
  If strcmp(ArgStr,"kill")  =0	then comm:=Cmd__Kill;
  If strcmp(ArgStr,"test")  =0	then comm:=Cmd__Test;
  If strcmp(ArgStr,"?")     =0	then comm:=Cmd__Help;

  If comm=Cmd__Null then cleanexit(" Not valid command",5);


  { --- unit holen / df0..df3 = 0..3 --- }

  If comm<>CMD__Help then begin
    GetParam(2,ArgStr);
    IF StrLen(ArgStr)=0 THEN CleanExit(" No Unit# [0..3]",5)
    else begin
      Case Byte(ArgStr^) of
	48 : dfx := 0;
	49 : dfx := 1;		{ 1. byte auf '0' - '3' testen }
	50 : dfx := 2;
	51 : dfx := 3;
      Else
	CleanExit(" Not valid unit number !",5);
      End;
    end;
  End;


  { --- Ggf. File zum Schreiben/Lesen öffnen --- }

  Case comm of
    Cmd__Write,
    Cmd__Cmp	: OpenFile(Mode_OldFile);
    Cmd__Read	: OpenFile(Mode_NewFile);
  End;


  { --- 1 K Chip-RAM reservieren : --- }

  BB1:=BBPtr(AllocMem(1024,Memf_Chip));
  If BB1=NIL then CleanExit(" Low on Chipmem !\n",10);


  { --- zus. 1 K RAM f. Vergleichs-BB o.ä. --- }

  New(BB2);


  { --- Kommando ausführen : --- }

  Case comm of
    CMD__Read :		{ --- BB speichern --- }
	begin
	If not (RWBB(dfx, CMD__Read, BB1))        then Cleanexit(ErrorTD_IO,10);
	If not (FileIO(CMD__Write, handle, BB1))  then CleanExit(DosErr_Wf, 10);
	end;

    CMD__Write :	{ --- install  BB from file --- }
	begin
	If not (FileIO(CMD__Read, handle, BB1))   then CleanExit(DosErr_Rf ,10);
	If not (RWBB(dfx, CMD__Write, BB1))       then Cleanexit(ErrorTD_IO,10);
	end;

    CMD__Chk :		{ --- check if Std.-BB --- }
	begin

	If not (RWBB(dfx, CMD__Read, BB1))        then Cleanexit(ErrorTD_IO,10);

	InstantBB( BB2, 13 );			{ Std.1.3-BB ? }
	If ( CMPBB( BB1, BB2 ) ) then
	Begin
	  write(" BB ok ( 1.3-BB)\n");
	  CleanExit( NIL, 0 );
	End;

	InstantBB( BB2, 20 );			{ Std.2.0-BB ? }
	If ( CMPBB( BB1, BB2 ) ) then
	begin
	  write(" BB ok ( 2.0-BB)\n");
	  CleanExit( NIL, 0 );
	End;

	InstantBB( BB2, -1 );			{ Not installed ? }
	If ( CMPBB( BB1, BB2 ) ) then
	begin
	  write(" Not installed disk\n");
	  CleanExit( NIL, 0 );
	End;

	CleanExit(" [1;33mNo Std.-BB!![0;31m\n",10);
	End;

    CMD__inst :		{ --- install Std-BB, 1.3/2.0, je nach Kick --- }
	begin
	InstantBB( BB1, 0 );
	If not (RWBB(dfx, CMD__Write, BB1))       then Cleanexit(ErrorTD_IO,10);
	End;

    CMD__Cmp :		{ --- BB vergleichen --- }
	begin
	If not (RWBB(dfx, CMD__Read, BB1))        then Cleanexit(ErrorTD_IO,10);
	If not (FileIO(CMD__Read, handle, BB2))   then CleanExit(DosErr_Rf, 10);


	If CmpBB( BB1, BB2 ) then
	Begin
	  write(" BB equal 2 file\n\n");		{ BB ok }
	  CleanExit(NIL,0);
	End Else Begin
	  CleanExit(" BB -NOT- equal 2 file\n\n",10);	{ Different ! }
	End;

	End;


    CMD__Type :		{ --- HexDump(BB) --- }
	begin
	If not (RWBB(dfx, CMD__Read, BB1))        then Cleanexit(ErrorTD_IO,10);
	DumpBB;
	end;

    CMD__Kill :		{ --- Install -> NDOS --- }
	begin
	For i:=0 to 1023 do
	  BB1^[i]:=0;

	If not (RWBB(dfx, CMD__Write, BB1))       then Cleanexit(ErrorTD_IO,10);
	end;

    CMD__Test :		{ --- BB testen - VORSICHT ! --- }
	begin
	If not (RWBB(dfx, CMD__Read, BB1))        then Cleanexit(ErrorTD_IO,10);

	{ .... exec in a6, IOreq in a1, jsr bb^ , ... }

	end;


    CMD__Help :		{ --- How 2 use it --- }
	begin
	write(	"Usage : DxBoot cmd unit[0..3] <filename>\n",
		"Available commands are:\n",
		" chk   [unit#]		2 check if Std.-BB\n",
		" read  [unit#] BBfile	2 save a BootBlock\n",
		" write [unit#] BBFile	2 install a BB\n",
		" inst  [unit#]		2 install a Std.-BB\n",
		" cmp   [unit#] BBFile	2 cmp 2 a BB-file\n",
		" type  [unit#]  	4 a hexdump\n",
		" test  [unit#]  	2 execute a bootblock (Be aware!)\n",
		" kill  [unit#]  	2 get a NDOS-Disk\n",
		" ?     [unit#]  	4 help\n\n");
	end;
  END;

  Cleanexit(NIL,0);	{ --- Bye !! --- }

END.					{ bye bye GTI ...}


