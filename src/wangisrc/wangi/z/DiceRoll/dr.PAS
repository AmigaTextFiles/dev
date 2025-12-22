Program dr; { Dice roll }

{ memory allocation }
{$F-,I-,R+,S+,V-,M 4,1,1,5}

Uses
	Dos;

Const
	Ver : String[31] = '$VER: Dice_Roll 1.1 (17.01.95)'#0;

Type
	tProgVars = Record
		arg_DSize,
		arg_Rolls : LongInt;
	End;

Function Get_Input(VAR v : tProgVars) : Boolean;

Var
	tmp : LongInt;
	err : Integer;

Procedure Display_Info;

Begin
	Writeln('Dice_Roll');
	Writeln('USAGE:');
	Writeln(' dr [die size] [number of rolls]');
	Writeln('eg. "dr 100 4" will roll 4 100-sided dice');
End;

Begin
	Get_Input := True;
	With v do begin
		arg_DSize := 6;
		arg_Rolls := 1;
	End;

	If ParamCount >= 1 then begin
		If (ParamStr(1) = '?') or (ParamStr(1) = '/?') Then Begin
			Get_Input := False;
			Display_Info
		End else Begin
			Val(ParamStr(1), tmp, err);
			If (err = 0) and (tmp > 1) then
				v.arg_DSize := tmp;
			If ParamCount >= 2 then begin
				Val(ParamStr(2), tmp, err);
				If (err = 0) and (tmp > 1) then
					v.arg_Rolls := tmp;
			End;
		End
	End;
End;

Procedure Display_RandomNums(VAR v : tProgVars);

Var
	Initial : Boolean;
	n       : Longint;

Begin
	Randomize;
	Initial := True;
	For n := 1 to v.arg_Rolls do begin
		If NOT Initial then
			Write(', ');
		Initial := False;
		Write(Random(v.arg_DSize)+1);
	End;
	Writeln;
End;

Procedure Main;

Var
	v : tProgVars;

Begin
	{$IfDef Amiga}
	System.BreakOn := True;
	{$EndIf}
	If Get_Input(v) Then
		Display_RandomNums(v);
End;

Begin Main End.