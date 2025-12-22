(*
 * Shrub... HSPascal source
 *
 * ©Lee Kindness
 *
 * ToolType.pas
 *
 *)

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

Function GetArgLong(Args : ppbyte; tooltype : String; Default : LONG) : Long; 

VAR
	tmpstr : STRPTR;
	RemKey : pRemember;
	n      : LONG;
	e      : Integer;
	
begin
	RemKey := NIL;
	tmpstr := FindToolType(Args, CStrConstPtrAR(@RemKey, tooltype));
	If tmpstr <> NIL then begin
		Val(PtrToPas(tmpstr), n, e);
		if e = 0 then
			GetArgLong := n
		else
			GetArgLong := Default;
	end else
		GetArgLong := default;
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
	
CONST
	ArgPtr : ppbyte = NIL;
	ToolRead : Boolean = FALSE;
	OPT_DIR       = 0;
	OPT_LEFT      = 1;
	OPT_TOP       = 2;
	OPT_WIDTH     = 3;
	OPT_HEIGHT    = 4;
	OPT_PUB       = 5;
	OPT_STXT      = 6;
	OPT_FLD       = 7;
	OPT_SHOWICONS = 8;
	OPT_SHOWODC   = 9;
	OPT_INFOODC   = 10;
	OPT_VIEWER    = 11;
	RDA : Array[0..11] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	With Args do begin
		arg_Dir       := '';
		arg_Left      := 20;
		arg_Top       := -1;
		arg_Width     := 250;
		arg_Height    := 160;
		arg_STxt      := '  ';
		arg_Pub       := '';
		arg_Viewer    := 'SYS:Utilities/Multiview';
		arg_fld       := False;
		arg_SaveIcons := True;
		arg_ShowIcons := False;
		arg_ShowODC   := False;
		arg_InfoODC   := True;
	End;


	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
		args.arg_SaveIcons := False;
	
		RDArg := ReadArgs(CStrConstPtrAR(@RemKey, 'DIRECTORY,LEFT/K/N,'+
		'TOP/K/N,WIDTH/K/N,HEIGHT/K/N,PUBSCREEN/K,SPACETEXT/K,LINKS/S,'+
		'SHOWICONS/S,VIEWODC/S,INFOODC/S,VIEWER/K'),@RDA,NIL);
		if RDArg <> NIL then begin
			If RDA[OPT_DIR] <> 0 then
				Args.arg_Dir := PtrToPas(STRPTR(RDA[OPT_DIR]));
			
			If RDA[OPT_LEFT] <> 0 then
				Args.arg_Left := pLongInt(RDA[OPT_LEFT])^;
			
			If RDA[OPT_TOP] <> 0 then 
				Args.arg_Top := pLongInt(RDA[OPT_TOP])^;
			
			If RDA[OPT_WIDTH] <> 0 then 
				Args.arg_Width := pLongInt(RDA[OPT_WIDTH])^;
			
			If RDA[OPT_HEIGHT] <> 0 then 
				Args.arg_Height := pLongInt(RDA[OPT_HEIGHT])^;
			
			If RDA[OPT_PUB] <> 0 then
				Args.arg_Pub := PtrToPas(STRPTR(RDA[OPT_PUB]));
			
			If RDA[OPT_STXT] <> 0 then
				Args.arg_STxt := PtrToPas(STRPTR(RDA[OPT_STXT]));

			If RDA[OPT_FLD] <> 0 then 
				args.arg_fld := True 
			else 
				args.arg_fld := False;
			
			If RDA[OPT_SHOWICONS] <> 0 then
				args.arg_ShowIcons := True 
			else 
				args.arg_ShowIcons := False;
			
			If RDA[OPT_SHOWODC] <> 0 then
				args.arg_ShowODC := True 
			else 
				args.arg_ShowODC := False;
			
			If RDA[OPT_INFOODC] <> 0 then
				args.arg_InfoODC := True 
			else 
				args.arg_InfoODC := False;
				
			If RDA[OPT_VIEWER] <> 0 then
				Args.arg_Viewer := PtrToPas(STRPTR(RDA[OPT_VIEWER]));
			
			FreeArgs(RDArg);
		End;
	end else begin
		
		al := pWBStartup(WBenchMsg)^.sm_ArgList;
	
		dobj := GetDiskObject(STRPTR(al^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			Args.arg_Dir := GetArgString(ArgPtr, 'DIRECTORY', Args.arg_Dir);
			Args.arg_Left := GetArgLong(ArgPtr, 'LEFT' ,Args.arg_Left);
			Args.arg_Top := GetArgLong(ArgPtr, 'TOP' ,Args.arg_Top);
			Args.arg_Width := GetArgLong(ArgPtr, 'WIDTH' ,Args.arg_Width);
			Args.arg_Height := GetArgLong(ArgPtr, 'HEIGHT' ,Args.arg_Height);
			Args.arg_Pub := GetArgString(ArgPtr, 'PUBSCREEN', Args.arg_Pub);
			Args.arg_STxt := GetArgString(ArgPtr, 'SPACETEXT', Args.arg_STxt);
			Args.arg_fld := GetArgBool(ArgPtr, 'LINKS', Args.arg_fld);
			Args.arg_ShowIcons := GetArgBool(ArgPtr, 'SHOWICONS', Args.arg_ShowIcons);
			Args.arg_ShowODC := GetArgBool(ArgPtr, 'VIEWODC', Args.arg_ShowODC);
			Args.arg_InfoODC := GetArgBool(ArgPtr, 'INFOODC', Args.arg_InfoODC);
			Args.arg_Viewer := GetArgString(ArgPtr, 'VIEWER', Args.arg_Viewer);
			FreeDiskObject(dobj);
		end;
		if pWBStartup(WBenchMsg)^.sm_NumArgs >= 2 then begin
			al := pWBArg(LONG(al) + Sizeof(tWBArg));
			Args.arg_Dir := FExpandLock(al^.wa_Lock);
		End;
	end;
	FreeRemember(@RemKey, True);
		
	If arg.arg_Dir <> '' then begin
		StripFileNameToDir(arg.arg_Dir);
	End;
	If IconBase^.lib_Version < MININFOVER then
		Args.arg_InfoODC := False;
end;

Procedure StripFileNameToDir;
{ if given a file name will return the directory that the file is in }

Var
	l   : BPTR;
	fib : pFileInfoBlock;
	name, 
	ext : String;

Begin
	l := Lock(CStrConstPtrAR(@grk, obj), ACCESS_READ);
	if l <> NULL then begin
		fib := AllocDosObject(DOS_FIB, NIL);
		if fib <> NIL then begin
			If Examine(l, fib) then begin
				if fib^.fib_DirEntryType < 0 then { a file }
					FSplit(obj, obj, name, ext);
			End;
			FreeDosObject(DOS_FIB, fib);
		End;
		UnLock(l);
	End;
End;