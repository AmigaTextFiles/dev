Function GetArgString(Args : ppbyte; tooltype, Default : String) : String;

VAR
	tmpstr : STRPTR;
	
begin
	tooltype := tooltype + #0;
	tmpstr := FindToolType(Args, @tooltype[1]);
	If tmpstr <> NIL then
		GetArgString := PtrToPas(tmpstr)
	else
		GetArgString := default;
end;

Procedure GetToolTypes(VAR Args : tProgVars);

VAR
	dobj    : pDiskObject;
	RemKey  : pRemember;
	al      : pWBArg;
	
CONST
	ArgPtr : ppbyte = NIL;
	OPT_PUB = 0;
	RDA : Array[0..0] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	Args.arg_ps := '';
	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
	
		RDArg := ReadArgs(CSCPAR(@RemKey, 'PUBSCREEN/K'),@RDA,NIL);
		if RDArg <> NIL then begin
			If RDA[OPT_PUB] <> 0 then
				Args.arg_ps := PtrToPas(STRPTR(RDA[OPT_PUB]));
			FreeArgs(RDArg);
		End;
	end else begin
		al := pWBStartup(WBenchMsg)^.sm_ArgList;
		dobj := GetDiskObject(STRPTR(al^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			Args.arg_ps := GetArgString(ArgPtr, 'PUBSCREEN', Args.arg_ps);
			FreeDiskObject(dobj);
		end;
	end;
	FreeRemember(@RemKey, True);
end;