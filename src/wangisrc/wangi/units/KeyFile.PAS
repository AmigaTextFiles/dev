Unit KeyFile;

INTERFACE

Uses
	AmigaDos, Exec;

Const
	UNREG = -1;
	
Type
	pKey = ^tKey;
	tKey = Record
		key_User : String[40];
		key_ID   : LONG;
		key_Chk  : LONG;
	End;

Procedure ReadKeyFile(VAR key : tKey; fname : String);
Procedure WriteKeyFile(fname, User : String; ID : LONG);

IMPLEMENTATION

Procedure ReadKeyFile;

Var
	f   : BPTR;
	ok, reg  : Boolean;
	len : LONG;

begin
	reg := False;
	fname := fname + #0;
	f := Open(@fname[1], MODE_OLDFILE);
	if f <> NULL then begin
		len := Read_(f,@key, Sizeof(tKey));
		If len = Sizeof(tKey) then begin
			{ Validate }
			If ((Length(key.key_User) + key.key_ID) div 2) = key.key_Chk then
				reg := True;
		End;
		ok := Close_(f);
	End;
	If NOT reg then begin
		with key do begin
			key_User := 'UNREGISTERED';
			key_ID   := UNREG;
		End;
	End;
End; {ReadKeyFile}

Procedure WriteKeyFile;

Var
	key : tKey;
	f   : BPTR;
	ok  : Boolean;
	len : LONG;

Begin
	fname := fname + #0;
	With key do begin
		key_User := 'KEYFILE-LSKKEYFILE-LSKKEYFILE-LSKKEYFILE';
		key_User := User;
		key_ID   := ID;
		key_Chk  := ((Length(key_User) + key_ID) div 2);
	End;
	f := Open(@fname[1], MODE_NEWFILE);
	If f <> NULL then begin
		len := Write_(f, @key, Sizeof(tKey));
		ok := Close_(f);
	End;
End; {WriteKeyFile}

End. {KeyFile}


