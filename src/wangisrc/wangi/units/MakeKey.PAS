Program MakeKey;

Uses
	DOS, KeyFile;

Var
	ID  : LongInt;
	err : Integer;

Begin
	Val(ParamStr(3), ID, err);
	if err = 0 then
		WriteKeyFile(ParamStr(1), ParamStr(2), ID);
End. {MakeKey}

