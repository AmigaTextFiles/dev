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
	al      : pWBArg;
	olddir  : BPTR;
	
CONST
	ArgPtr : ppbyte = NIL;
	ToolRead : Boolean = FALSE;
	OPT_FROM = 0;
	OPT_EDIT = 1;
	OPT_USE  = 2;
	OPT_SAVE = 3;
	OPT_PUB  = 4;
	RDA : Array[0..4] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	Args.arg_From      := 'ENV:AmigaGuide/';
	Args.arg_Edit      := True;
	Args.arg_Edit      := True;
	Args.arg_Use       := False;
	Args.arg_Save      := False;
	Args.arg_SIcons    := False;
	Args.arg_PubScreen := '';
	
	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
	
		RDArg := ReadArgs(CStrConstPtrAR(@RemKey, 'FROM,EDIT/S,USE/S,SAVE/S,PUBSCREEN/K'),@RDA,NIL);
		if RDArg <> NIL then begin
			If RDA[OPT_FROM] <> 0 then
				Args.arg_From := PtrToPas(STRPTR(RDA[OPT_FROM]));
			
			If RDA[OPT_USE] <> 0 then begin
				Args.arg_Edit := False;  
				Args.arg_Use := True;
			End;
			If RDA[OPT_SAVE] <> 0 then begin
				Args.arg_Edit := False;  
				Args.arg_Save := True;
			End;
			If RDA[OPT_EDIT] <> 0 then 
				Args.arg_Edit := True;
			If RDA[OPT_PUB] <> 0 then
				Args.arg_PubScreen := PtrToPas(STRPTR(RDA[OPT_PUB]));
			FreeArgs(RDArg);
		End;
	end else begin
		Args.arg_SIcons := True;
		al := pWBStartup(WBenchMsg)^.sm_ArgList;
		If ParamCount >= 1 then begin
			al := pWBArg(LONG(al) + Sizeof(tWBArg));
			olddir := CurrentDir(al^.wa_Lock);
			dobj := GetDiskObject(STRPTR(al^.wa_Name));
			Args.arg_From := FExpand(PtrToPas(STRPTR(al^.wa_Name)));
			olddir := CurrentDir(olddir);
		end else
			dobj := GetDiskObject(STRPTR(al^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			
			Args.arg_From := GetArgString(ArgPtr, 'FROM', Args.arg_From);
			
			tmpstr := FindToolType(ArgPtr, CStrConstPtrAR(@RemKey, 'ACTION'));
			If tmpstr <> NIL then begin
				If MatchToolValue(tmpstr ,CStrConstPtrAR(@RemKey, 'USE')) then begin
					args.arg_Use := True;
					args.arg_Edit := False;
				End;
				If MatchToolValue(tmpstr ,CStrConstPtrAR(@RemKey, 'SAVE')) then begin
					args.arg_Save := True;
					args.arg_Edit := False;
				End;
				If MatchToolValue(tmpstr ,CStrConstPtrAR(@RemKey, 'EDIT')) then begin
					args.arg_Edit := True;
				End;
			End else begin
				Args.arg_Use := GetArgBool(ArgPtr, 'USE' ,Args.arg_Use);
				Args.arg_Save := GetArgBool(ArgPtr, 'SAVE' ,Args.arg_Save);
				if (Args.arg_Use) or (Args.arg_Save) then
					Args.arg_Edit := GetArgBool(ArgPtr, 'EDIT' ,Args.arg_Edit); 
			End;
			Args.arg_PubScreen := GetArgString(ArgPtr, 'PUBSCREEN', Args.arg_PubScreen);
			
			FreeDiskObject(dobj);
		end;
	end;
	FreeRemember(@RemKey, True);
	
end;