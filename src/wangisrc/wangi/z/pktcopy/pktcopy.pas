Program Pktcopy;

Uses Dos;

{$I-}

Function ExistsFile(s : String) : Boolean;

Var
	f : File;
	
Begin
	Assign(f, s);
	Reset(f);
	If IOResult = 0 Then Begin
		Close(f);
		ExistsFile := True;
	End Else
		ExistsFile := False;
End;



Procedure Main;

Var
	pathp : String;
	filep : String;
	extp  : String;
	num   : Integer;
	day   : Integer;

Const
	ARG_FROM = 1;
	ARG_To   = 2;
	days : Array[1..7] Of String = ('mo',
	                                'tu',
	                                'we',
	                                'th',
	                                'fr',
	                                'sa',
	                                'su');

Begin
	Writeln('1');
	If ParamCount = 2 Then Begin
		Writeln('2');
		If ExistsFile(ParamStr(ARG_To)) Then Begin
			Writeln('3');
			FSplit(ParamStr(ARG_To), pathp, filep, extp);
			num := -1;
			day := 1;
			Repeat
				if num < 9 Then
					inc(num)
				Else Begin
					num := 0;
					If day < 7 Then
						inc(day)
					Else
						day := 1;
				End;
				Str(num, extp);
				extp := days[day] + extp;
				Writeln(pathp + filep + extp);
			Until NOT(ExistsFile(pathp + filep + extp));
		End;
	End;
End;


Begin main end.