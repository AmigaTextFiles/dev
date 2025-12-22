program Map2Sym;
const
	PROG_INFO = 'MAP2SYM v1.0 by Haroldo O. Pinheiro';
	PROG_DESC = 'Converts a z88dk map file into a Meka/Emukon-compatible symbol file.';
	PROG_USAGE = 'Usage: MAP2SYM <mapfile> <symbolfile>';

var
	SrcFile, DestFile : Text;
	S, Name, Address, Comment : String;
	Idx, Idx2, BlnkLn : Integer;
Begin
	if ParamCount < 2 then
		begin
			Writeln(PROG_INFO);
			Writeln(PROG_DESC);
			Writeln(PROG_USAGE);
			Halt(1);
		end;

	{$I-}
	Assign(SrcFile, ParamStr(1));
	Reset(SrcFile);
	if IOResult <> 0 then
		begin
			Writeln(PROG_INFO);
			Writeln('Error: file "', ParamStr(1), '" not found.');
			Halt(2);
		end;
	{$I+}

	{$I-}
	Assign(DestFile, ParamStr(2));
	Rewrite(DestFile);
	if IOResult <> 0 then
		begin
			Writeln(PROG_INFO);
			Writeln('Error: Couldn''t create file "', ParamStr(2), '"');
			Halt(3);
		end;
	{$I+}

	Writeln(DestFile, '; This file was created with ', PROG_INFO);
	Writeln(DestFile, '; Meka/Emukon symbolic information');

	BlnkLn := 0;
	while not Eof(SrcFile) and (BlnkLn < 2) do
		begin
			Readln(SrcFile, S);
			if S <> '' then
				begin
               		BlnkLn := 0;
					Idx := Pos('=', S);
					Idx2 := Pos(',', S);
					if (Idx <> 0) and (Idx2 <> 0) then
						begin
							Name    := Copy(S, 1, Idx-1);
							Address := Copy(S, Idx+2, Idx2-Idx-2);
							Comment := Copy(S, Idx2+1, Length(S));

							Writeln(DestFile, '0000:', Address, ' ', Name);
						end;
				end
			else
				Inc(BlnkLn);
		end;

	Close(DestFile);
	Close(SrcFile);
End.