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

Function GetArgInt(Args : ppbyte; tooltype : String; 
						Default : LongInt) : LongInt;

VAR
	tmpstr : STRPTR;
	err : Integer;
	tmpInt : LongInt;
	
Begin
	tmpstr := FindToolType(Args, @tooltype[1]);
	If tmpstr <> NIL then begin
		Val(PtrToPas(tmpstr), tmpint, err);
		If err = 0 then
			GetArgInt := tmpint
		else
			GetArgInt := default;
	end else
		GetArgInt := default;
end;



Procedure GetToolTypes(VAR Args : tProgVars);

VAR
	dobj    : pDiskObject;
	CLIArgs : Array[1..6] of STRPTR;
	n, n2   : byte;
	Tmpstr  : STRPTR;
	RemKey  : pRemember;
	al      : pWBArg;
	
CONST
	ArgPtr : ppbyte = NIL;
	ToolRead : Boolean = FALSE;
	OPT_FROM = 0;
	OPT_PREF = 1;
	OPT_LEV  = 2;
	OPT_PRI  = 3;
	OPT_POP  = 4;
	RDA : Array[0..4] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	Args.arg_From      := 'S:Wangi.Prefs';
	Args.arg_HotKey    := 'rawkey control w';
	Args.arg_PrefEd    := 'SYS:Prefs/WangiPrefs';
	Args.arg_Pri       := -1;
	Args.arg_LevelT    := 5;
	
	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
	
		RDArg := ReadArgs(CStrConstPtrAR(@RemKey, 'FROM,PREF/K,LEVELTIME/K/N,CX_PRIORITY/K/N,CX_POPKEY/K'),@RDA,NIL);
		if RDArg <> NIL then begin
			If RDA[OPT_FROM] <> 0 then
				Args.arg_From := PtrToPas(STRPTR(RDA[OPT_FROM]));
			
			If RDA[OPT_PREF] <> 0 then
				Args.arg_PrefEd := PtrToPas(STRPTR(RDA[OPT_PREF]));
				
			If RDA[OPT_LEV] <> 0 then
				Args.arg_LevelT := pLongInt(RDA[OPT_LEV])^;
				
			If RDA[OPT_POP] <> 0 then
				Args.arg_HotKey := PtrToPas(STRPTR(RDA[OPT_POP]));
				
			If RDA[OPT_PRI] <> 0 then
				Args.arg_Pri := pLongInt(RDA[OPT_POP])^;
			
			FreeArgs(RDArg);
		End;
	end else begin
		al := pWBStartup(WBenchMsg)^.sm_ArgList;
		dobj := GetDiskObject(STRPTR(al^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			
			Args.arg_From := GetArgString(ArgPtr, 'FROM', Args.arg_From);
			Args.arg_PrefEd := GetArgString(ArgPtr, 'PREF', Args.arg_PrefEd);
			Args.arg_LevelT := GetArgInt(ArgPtr, 'LEVELTIME'#0, Args.arg_LevelT);
			Args.arg_HotKey := GetArgString(ArgPtr, 'CX_POPKEY', Args.arg_HotKey);
			Args.arg_Pri := GetArgInt(ArgPtr, 'CX_PRIORITY'#0, Args.arg_Pri);
						
			FreeDiskObject(dobj);
		end;
	end;
	FreeRemember(@RemKey, True);
end;