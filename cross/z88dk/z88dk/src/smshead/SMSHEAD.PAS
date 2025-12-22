program SMSHead;
const
	PROG_INFO = 'SMSHEAD v0.1a by Haroldo O. Pinheiro';
	PROG_DESC = 'Pads a Sega Master System ROM to 32k and writes the required header.';
	PROG_USAGE = 'Usage: SMSHEAD <sms file>';

type
	SegaHeader = record
					Signature     : array [0..7] of char;
					Unknown       : Word;
					CheckSum      : Word;
					PartNumber    : Word;
					Version       : Byte;
					CheckSumRange : Byte;
				 end;

var
	F   	: File;
	Buf 	: array[0..$7FFF] of byte;
	NumRead : Word;

	procedure WriteHeader;
		const
			SIG : String[8] = 'TMR SEGA';
		var Head: SegaHeader;
			i   : Word;
		begin
			Move(SIG[1], Head.Signature, 8);
			Head.Unknown       := $FFFF;
			Head.CheckSum      := 0;
			Head.PartNumber    := $42FF;
			Head.Version       := $20;
			Head.CheckSumRange := $4C;

			for i := 0 to $7FEF do
				Inc(Head.CheckSum, Buf[i]);

			Move(Head, Buf[$7FF0], SizeOf(Head));
		end;
Begin
	if ParamCount < 1 then
		begin
			Writeln(PROG_INFO);
			Writeln(PROG_DESC);
			Writeln(PROG_USAGE);
			Halt(1);
		end;

	{$I-}
	Assign(F, ParamStr(1));
	Reset(F, 1);
	{$I+}

	if IOResult <> 0 then
		begin
			Writeln(PROG_INFO);
			Writeln('File ', ParamStr(1), ' not found.');
			Halt(2);
		end;

	FillChar(Buf, SizeOf(Buf), 0);
	BlockRead(F, Buf, SizeOf(Buf), NumRead);

	WriteHeader;

	Seek(F, 0);
	BlockWrite(F, Buf, SizeOf(Buf));

	Close(F);

	Writeln('Done.');
End.