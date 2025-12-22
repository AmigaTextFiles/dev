Program Play;

{
	** Dies ist eine Weiterentwicklung des play.p welches PCQ 1.2b **
	** beiliegt. Im folgenden zuerst der Kommentar vom PCQ-Autor   **
	** Patrick Quaid :					       **


	Play.p

	Play a one-shot 8SVX IFF sound file.  The command line is simply
	Play8svx filename, where the filename is any path and must be
	present.  This code was derived from Eric Jacobsen's spIFF.c.
	The differences between this and spIFF.c:
	   a) This was translated from C to Pascal
	   b) Several sound files in my collection had odd-length
		name or annotation fields.  That is, the field lengths
		in the file were odd, but the actual data was padded
		with an extra 0 byte.  So this program handles that.
	   c) I added decompression routines taken from an old IFF
		documentation disk.  I couldn't find any properly
		formatted compressed sound files, however, so I'm not
		sure if the decompression is accurate.  The program
		will certainly try to decompress files, but mine came
		out garbage.  Based on the samples I've accumulated,
		it seems that few of them are compressed anyway.

	In my distribution, I included a sample sample, as it were,
	called UseTheForce.8SVX, which obviously came from Star Wars.

	________________________________________________________________

	Nun, ich habe play.p ein wenig erweitert. Play bietet nun sowohl
	einen loop-modus als auch die Möglichkeit, es als Default-Tool
	im Icon einzutragen. Ich habe dazu auch ein paar Demo-Samples
	beigelegt. ( UsetheForce.(svx ist nicht dabei. ) Der Loop-Modus
	wird allerdings bisher nur beim Aufruf vom CLI aus unterstützt.
	Außerdem müßte der Code mal ein wenig aufgeräumt werden ...

	Bis zu einer weiter verbesserten Version wünsche ich schon mal
	viel Spaß mit play und den Samples !  =;)

							Diesel




	P.S.: Wenn ich mal viel Zeit habe, arbeite ich play in ein Include-
	      File mit mehreren Fkt. zum Nutzen von 8svx-files um. Jedem
	      andere Interessierten ist allerdings auch erlaubt, mir dabei
	      zuvor zu kommen, vorausgesetzt, er veröffentlicht es nachher
	      auf der Purity ...   =:)


}

{$I "Include:Devices/Audio.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Libraries/DOS.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Devices.i"}


type
    Voice8Header = record
	oneShotHiSamples,
	repeatHiSamples,
	samplesPreHiCycle : Integer;
	samplesPerSec : Short;
	ctOctave	: Byte;
	sCompression	: Byte;
	volume : Integer;
    end;

type
    FibTable = Array [0..15] of Byte;

const
    WB		: WBStartUpPtr = NIL;
    home	: FileLock = NIL;
    K128	: Integer = 128*1024;
    ckname	: String = Nil;
    NoMem	: String = "\nNot enough memory.\n";
    reps	: Integer = 1;
    wrt_flg	: Boolean = True;
    ioa		: IOAudioPtr = Nil;
    ebuf	: Address = Nil;
    dbuf	: Address = Nil;
    FP		: FileHandle = Nil;
    codeToDelta	: FibTable = (-34, -21, -13, -8, -5, -3, -2, -1, 0,
				1, 2, 3, 5, 8, 13, 21);

var
    VHeader	: Voice8Header;
    chan	: Char;
    s, ps	: String;
    dlen,
    elen,
    oerr,
    i		: Integer;
    chnk	: ^Integer;
    ckbuffer	: Array [0..2] of Short;
    t		: Address;
    SinglePlay  : Boolean;




Function D1Unpack(source : String; n : Integer; dest : String; x : Byte) : Byte;
var
    d : Byte;
    i, lim : Integer;
begin
    lim := n shl 1;
    for i := 0 to lim - 1 do begin
	d := Ord(Source[i shr 1]);
	if Odd(i) then
	    d := d and 15
	else
	    d := d shr 4;
	x := x + codeToDelta[d];
	dest[i] := Chr(x);
    end;
    D1Unpack := x;
end;

Procedure DUnpack(source : String; n : Integer; dest : Address);
var
    x : Byte;
begin
    x := D1Unpack(Adr(source[1]), n - 2, dest, Ord(source[0]));
end;

Procedure OpenFile;
var
    NameBuffer : Array [0..127] of char;
    Name : String;
begin
  Name := Adr(NameBuffer);


  WB := GetStartupMsg();
  IF WB <> nil THEN BEGIN
    IF WB^.sm_NumArgs > 1 THEN BEGIN

      strcpy( name, WB^.sm_ArgList^[2].wa_Name );
      home := CurrentDir( WB^.sm_ArgList^[2].wa_Lock );	{ aufs akt. Dir gehen }

    END ELSE BEGIN

      Write(" Which 8SVX-File : ");	{ Wenn direkter Aufruf, file abfragen }
      ReadLn ( name );
      If strlen(name)=0 then begin	{ war nix ?? }
	Write("No filename!\n");
	Delay(50);
	Exit(10);
      End;
      home := CurrentDir( WB^.sm_ArgList^[1].wa_Lock );	{ aufs akt. Dir gehen }

    END;

    SinglePlay := True;		{ von WB noch kein Loopmodus }

  END ELSE BEGIN

    GetParam(2, Name);				{ Loop 8svx ? }
    if strlen(Name) = 0 then begin
      SinglePlay := True;
    end else begin
      If strcmp(Name, "loop")=0 then begin
        SinglePlay := False;
        Write("\n Loop-mode - hold down left mousebutton 2 stop\n");
      end else begin
	Write("\n Usage 4 loop: play8svx filename loop\n");
        SinglePlay := True;
      end;
    end;

    GetParam(1, Name);
    if strlen(Name) = 0 then begin
	Write("Usage: Play8svx filename [loop]\n");
	Exit(10);
    end;

  END;


  FP := DOSOpen(Name, MODE_OLDFILE);
  if FP = Nil then begin
    WriteLn("Could not open ", Name);
    Delay(50);
    Exit(10);
  End;

end;

procedure CleanUp;
begin
    if ioa <> Nil then begin
	with ioa^.ioa_Request.io_Message do begin
	    if mn_ReplyPort <> Nil then
		DeletePort(mn_ReplyPort);
	end;
	FreeMem(ioa, SizeOf(IOAudio));
    end;
    if dbuf <> Nil then
	FreeMem(dbuf, dlen);
    if FP <> nil then
	DOSClose(FP);
    if home <> NIL then
	home := CurrentDir(home);
    if WB <> NIL then
	Delay(50);
end;


Function LeftMouseButton: Boolean;
Type
	bt = ^Byte;
Var
	bfe : bt;
Begin
	bfe := Address($bfe001);

	If (bfe^ MOD 128) > 64			{ bit 6 gesetzt ? }
	then  LeftMouseButton := False		{ ja -> nicht gedrückt }
	else  LeftMouseButton := True;		{ nein -> lmb gedrückt }
end;


Procedure pExit(Msg : String);
begin
    WriteLn(Msg);
    CleanUp;
    Exit(20);
end;

Procedure DoRead(Buffer : Address; Length : Integer);
var
    ReadResult : Integer;
begin
    ReadResult := DOSRead(FP, Buffer, Length);
    if ReadResult <> Length then
	pExit("Read error");
end;

Procedure WriteData(len : Integer);
var
    MBuffer : Array [0..127] of Char;
    MString : String;
begin
    MString := Adr(MBuffer);
    if Odd(len) then
	len := Succ(len);
    MBuffer[127] := '\0';
    while len > 127 do begin
	DoRead(MString, 127);
	if wrt_flg then
	    Write(MString);
	len := len - 127;
    end;
    if len > 0 then begin
	DoRead(MString, len);
	MString[len] := '\0';
	if wrt_flg then
	    WriteLn(MString);
    end;
    wrt_flg := True;
end;


Procedure DoPlay( data : Address; slen : Integer);
begin
      with ioa^ do begin
	ioa_Request.io_Command := CMD_WRITE;
	ioa_Request.io_Flags := ADIOF_PERVOL;
	ioa_Data := data;
	ioa_Length := slen;
	ioa_Cycles := 1;		{ 1 or from command line. }
	ioa_Period := 3579546 div VHeader.samplesPerSec;
	ioa_Volume := 64;	 	{ Always use maximum volume. }
      end;

      BeginIO(IORequestPtr(ioa));
      oerr := WaitIO(IORequestPtr(ioa));
End;



begin

    ckname := Adr(ckbuffer);
    ckname[4] := '\0';
    chan := Chr(15);
    OpenFile;
    DoRead(ckname, 4);
    if streq(ckname, "FORM") then begin
	DoRead(ckname,4);	{ Get size out of the way. }
	DoRead(ckname,4);
	if streq(ckname,"8SVX") then begin
	    DoRead(ckname,4);
	    while not streq(ckname,"BODY") do begin
		DoRead(Adr(dlen), 4);
		if streq(ckname,"VHDR") then
		    DoRead(Adr(VHeader), SizeOf(Voice8Header))
		else begin
		    chnk := Address(ckname);
		    case chnk^ of
		      $4e414d45: Write("\nName of sample: ");
		      $41555448: Write("\nAuthor: ");
		      $28432920,
		      $28632920,
		      $2843294a,
		      $2863294a: Write("\n(c) notice: ");
		      $414e4e4f: Write("\nAnnotation field:\n");
		    else
		      wrt_flg := True;
		    end;
		    WriteData(dlen);
		end;
		DoRead(ckname, 4);
	    end;
	    DoRead(Adr(dlen), 4);
	    WriteLn(dlen, ' bytes at ', VHeader.samplesPerSec, 'Hz');
	end else
	    pExit("Not an 8SVX sound file.")
    end else
	pExit("Not an IFF file.");
    ioa := AllocMem(SizeOf(IOAudio), MEMF_PUBLIC);
    if ioa = Nil then
	pExit(NoMem);
    with ioa^.ioa_Request.io_Message do begin
	mn_ReplyPort := CreatePort(Nil, 0);
	if mn_ReplyPort = nil then
	    pExit("Unable to allocate port");
    end;

    elen := dlen;
    dbuf := AllocMem(elen, MEMF_PUBLIC + MEMF_CHIP );
    if dbuf = Nil then
	pExit(NoMem);

    with ioa^ do begin
	ioa_Request.io_Message.mn_Node.ln_Pri := 10;
	ioa_Data := Adr(chan);
	ioa_Length := 1;
	ioa_AllocKey := 0;
    end;

    oerr := OpenDevice(AUDIONAME, 0, IORequestPtr(ioa), 0);
    if oerr <> 0 then
	pExit("Can't open audio device");


    if Odd(elen) then   elen := Pred(elen);
    DoRead(dbuf, elen);

    if VHeader.sCompression = 1 then begin
	t := AllocMem(elen shl 1, MEMF_CHIP + MEMF_PUBLIC);
	if t = Nil then
	    pExit("Not enough memory for decompression");
	DUnpack(dbuf, elen, t);
	FreeMem(dbuf, elen);
	dbuf := t;
	elen := elen shl 1;
    end else if VHeader.sCompression > 1 then
	pExit("Unknown compression type");


    Repeat

      ebuf := dbuf;
      i := elen DIV K128;

      While i>0 DO Begin
        DoPlay( ebuf, K128);
	Dec(i);
	Inc( Integer(ebuf), K128);
      end;

      DoPlay( ebuf, elen MOD K128);

    Until LeftMouseButton OR SinglePlay;


    if oerr <> 0 then
	WriteLn('Error ', oerr, ' playing sample');
    CloseDevice(IORequestPtr(ioa));
    CleanUp;
end.
