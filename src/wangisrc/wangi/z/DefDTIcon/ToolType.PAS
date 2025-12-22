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

Function GetArgBool(Args : ppbyte; tooltype : String; 
						default : Boolean) : Boolean; 

VAR
	tmpstr : STRPTR;
	RemKey : pRemember;
	
begin
	RemKey := NIL;
	tmpstr := FindToolType(Args, CStrConstPtrAR(@RemKey, tooltype));
	If tmpstr <> NIL then begin
		GetArgBool := True;
	end else
		GetArgBool := Default;
	FreeRemember(@RemKey, True);
end;

Procedure GetToolTypes(VAR Args : tProgVars);

VAR
	dobj    : pDiskObject;
	CLIArgs : Array[1..6] of STRPTR;
	n, n2   : byte;
	Tmpstr  : STRPTR;
	RemKey  : pRemember;
	
CONST
	ArgPtr : ppbyte = NIL;
	RDA    : Array[0..6] of LONG = (0);
	RDArg  : pRDArgs = NIL;
	OPT_TEXT        = 0;
	OPT_COARSE      = 1;
	OPT_NODATATYPE  = 2;
	OPT_NOTOOLWIN   = 3;
	OPT_DEFAULTTOOL = 4;
	OPT_NOTOOL      = 5;
	OPT_ICONDIR     = 6;
	
Begin

	Args.TEXT        := 'Default Icon';
	Args.NOTOOL      := False;
	Args.ICONDIR     := 'DEVS:Icons';
	Args.COARSE      := False;
	Args.NODATATYPE  := False;
	Args.NOTOOLWIN   := False;
	Args.DEFAULTTOOL := False;
	
	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
		RDArg := ReadArgs(CStrConstPtrAR(@RemKey, 'TEXT/K,COARSE/S,NODATATYPE/S,'+
		                                          'NOTOOLWIN/S,DEFAULTTOOL/S,'+
		                                          'NOTOOL/S,ICONDIR/K'),@RDA,NIL);
		if RDArg <> NIL then begin
			If RDA[OPT_TEXT] <> 0 then
				Args.TEXT := PtrToPas(STRPTR(RDA[OPT_TEXT]));
				
			If RDA[OPT_ICONDIR] <> 0 then
				Args.ICONDIR := PtrToPas(STRPTR(RDA[OPT_ICONDIR]));
			
			If RDA[OPT_COARSE] <> 0 then 
				args.COARSE := True;
			
			If RDA[OPT_NODATATYPE] <> 0 then
				args.NODATATYPE := True;
			
			If RDA[OPT_NOTOOLWIN] <> 0 then
				args.NOTOOLWIN := True;
			
			If RDA[OPT_DEFAULTTOOL] <> 0 then
				args.DEFAULTTOOL := True;
				
			If RDA[OPT_NOTOOL] <> 0 then
				args.NOTOOL := True;
				
			FreeArgs(RDArg);
		End;
	end else begin
		dobj := GetDiskObject(CStrConstPtrAR(@RemKey, Paramstr(0)));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			If ArgPtr <> NIL then begin
				Args.TEXT := GetArgString(ArgPtr, 'TEXT', Args.TEXT);
				Args.ICONDIR := GetArgString(ArgPtr, 'ICONDIR', Args.ICONDIR);
				Args.COARSE := GetArgBool(ArgPtr, 'COARSE' ,Args.COARSE);
				Args.NODATATYPE := GetArgBool(ArgPtr, 'NODATATYPE' ,Args.NODATATYPE);
				Args.NOTOOLWIN := GetArgBool(ArgPtr, 'NOTOOLWIN' ,Args.NOTOOLWIN);
				Args.NOTOOL := GetArgBool(ArgPtr, 'NOTOOL' ,Args.NOTOOL);
				Args.DEFAULTTOOL := GetArgBool(ArgPtr, 'DEFAULTTOOL' ,Args.DEFAULTTOOL);
			End;
			FreeDiskObject(dobj);
		End;
	end;
	FreeRemember(@RemKey, True);
	Args.ICONDIR := Args.ICONDIR + #0;
end;