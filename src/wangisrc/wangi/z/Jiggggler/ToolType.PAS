Function GetArgString(Args : ppbyte; tooltype, Default : String) : String;

VAR
	tmpstr : STRPTR;
	ts     : String;
	
begin
	ts := ts + ''#0;
	tmpstr := FindToolType(Args, @ts[1]);
	If tmpstr <> NIL then
		GetArgString := PtrToPas(tmpstr)
	else
		GetArgString := default;
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
	template: String;
	
CONST
	ArgPtr : ppbyte = NIL;
	ToolRead : Boolean = FALSE;
	OPT_DEL = 0;
	OPT_OFF = 1;
	OPT_PRI = 2;
	OPT_CXP = 3;
	OPT_HOT = 4;
	RDA : Array[0..4] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	Args.arg_Delay  := 2;
	Args.arg_HotKey := 'rawkey control alt j';
	Args.arg_CxPri  := 0;
	Args.arg_Pri    := -21;
	Args.arg_Off    := 1;
	
	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
	
		template := 'DELAY/K/N,OFFSET/K/N,PRIORITY/K/N,CX_PRIORITY/K/N,CX_POPKEY/K'#0; 
		RDArg := ReadArgs(@template[1],@RDA,NIL);
		if RDArg <> NIL then begin
			If RDA[OPT_HOT] <> 0 then
				Args.arg_HotKey := PtrToPas(STRPTR(RDA[OPT_HOT]));
				
			If RDA[OPT_CXP] <> 0 then
				Args.arg_CxPri := pLongInt(RDA[OPT_CXP])^;
				
			If RDA[OPT_PRI] <> 0 then
				Args.arg_Pri := pLongInt(RDA[OPT_PRI])^;
				
			If RDA[OPT_DEL] <> 0 then
				Args.arg_Delay := pLongInt(RDA[OPT_DEL])^;
				
			If RDA[OPT_OFF] <> 0 then
				Args.arg_Off := pLongInt(RDA[OPT_OFF])^;
			
			FreeArgs(RDArg);
		End;
	end else begin
		al := pWBStartup(WBenchMsg)^.sm_ArgList;
		dobj := GetDiskObject(STRPTR(al^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			
			Args.arg_HotKey := GetArgString(ArgPtr, 'CX_POPKEY', Args.arg_HotKey);
			Args.arg_Pri := GetArgInt(ArgPtr, 'PRIORITY'#0, Args.arg_Pri);
			Args.arg_CxPri := GetArgInt(ArgPtr, 'CX_PRIORITY'#0, Args.arg_CxPri);
			Args.arg_Delay := GetArgInt(ArgPtr, 'DELAY'#0, Args.arg_Delay);
			Args.arg_Off := GetArgInt(ArgPtr, 'OFFSET'#0, Args.arg_Off);
						
			FreeDiskObject(dobj);
		end;
	end;
	FreeRemember(@RemKey, True);
end;