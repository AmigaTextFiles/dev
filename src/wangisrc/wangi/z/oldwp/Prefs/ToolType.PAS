Function GetArgString(Args : ppbyte; tooltype, Default : String) : String;

VAR
	tmpstr : STRPTR;
	RemKey : pRemember;
	
begin
	RemKey := NIL;
	tmpstr := FindToolType(Args, CStrConstPtrAR(@RemKey, tooltype));
	If tmpstr <> NIL then
		GetArgString := PtrToPas(tmpstr)
	else
		GetArgString := default;
	FreeRemember(@Remkey, True);
end;

Procedure SplitFileName(full : String; VAR dpart, fpart : String);

Var	
	ext : String;
	
Begin
	FSplit(full,dpart,fpart,ext);
	fpart := fpart + ext;
End;


Procedure GetToolTypes(VAR Args : tProgVars);

VAR
	dobj    : pDiskObject;
	CLIArgs : Array[1..6] of STRPTR;
	n, n2   : byte;
	Tmpstr  : STRPTR;
	RemKey  : pRemember;
	
CONST
	ArgPtr : ppbyte = NIL;
	ToolRead : Boolean = FALSE;
	OPT_FROM = 0;
	RDA : Array[0..0] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	With Args do begin
		arg_FileName := 'S:Wangi.Prefs';
		arg_DirPart  := '';
		arg_FilePart := '';
	End;

	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
	
		RDArg := ReadArgs(CStrConstPtrAR(@RemKey, 'FROM'),@RDA,NIL);
		if RDArg <> NIL then begin
		
			If RDA[OPT_FROM] <> 0 then
				Args.arg_FILENAME := PtrToPas(STRPTR(RDA[OPT_FROM]));

			FreeArgs(RDArg);
		End;
	end else begin
		dobj := GetDiskObject(STRPTR(pWBStartup(WBenchMsg)^.sm_ArgList^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			Args.arg_FIleName := GetArgString(ArgPtr, 'FROM', Args.arg_FileName);
			FreeDiskObject(dobj);
		end;
	end;
	FreeRemember(@RemKey, True);
	With Args do
		SplitFileName(arg_FileName, arg_DirPart, arg_FilePart);
	
end;

