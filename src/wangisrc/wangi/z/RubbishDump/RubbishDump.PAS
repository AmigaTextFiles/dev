Program RubbishDump;
{$F-,I-,R-,S-,V-,M 4,1,1,15}

Uses
	Exec, AmigaDos, Icon, Workbench, Intuition, CStrConstPtr, Amiga, 
	TType, MRexx, CX, Rexx, Commodities, AppIcon, DOS;

Const
	{Version : string[32] = '$VER: Rubbish_Dump 0.1 19.01.95'#0;}
	{Version : string[32] = '$VER: RubbishDump 1.0 (22.01.95)'#0;}
	{Version : string[33] = '$VER: RubbishDump 1.1 (23.01.95)'#0;}
	Version : string[33] = '$VER: RubbishDump 1.2 (28.04.95)'#0;
	cxname  = 'Rubbish Dump';
	cxtitle = 'Rubbish Dump v1.1 ©95 Lee Kindness.';
	cxdesc  = 'Trash on Workbench... Sound too.';
	
Type
	tProgVars = Record
		arg_LeftEdge,
		arg_TopEdge,
		arg_CXPri : LONG;
		arg_Icon,
		arg_Name,
		arg_RexxPort,
		arg_RexxCmd : String;
	End;
	
(***************************************************************************)
(***************************************************************************)
Procedure GetToolTypes(VAR Args : tProgVars);

VAR
	dobj    : pDiskObject;
	Tmpstr  : STRPTR;
	RemKey  : pRemember;
	olddir  : BPTR;
	
CONST
	ArgPtr : ppbyte = NIL;
	ToolRead : Boolean = FALSE;
	OPT_LEFTEDGE   =  1;
	OPT_TOPEDGE    =  2;
	OPT_ICON       =  3;
	OPT_NAME       =  4;
	OPT_REXXPORT   =  5;
	OPT_REXXCMD    =  6;
	OPT_CXPRI      =  7;
	RDA : Array[1..10] of LONG = (0);
	RDArg : pRDArgs = NIL;
	
Begin
	With Args do begin
		arg_LeftEdge     := 0;
		arg_TopEdge      := 0;
		arg_CXPri        := -20;
		arg_Icon         := '';
		arg_Name         := 'Rubbish Dump';
		arg_RexxPort     := 'PLAY';
		arg_RexxCmd      := 'id TRASH';
	End;
	RemKEy := NIL;
	
	If CmdLinePtr.Len >= 1 then begin
		RDArg := ReadArgs(CSCPAR(@RemKey, 
		 'X=LEFTEDGE/K/N,Y=TOPEDGE/K/N,I=ICON/K,N=NAME/K,'+
		 'RP=REXXPORT/K,RC=REXXCMD/K,CX_PRIORITY/K/N'),@RDA,NIL);
		if RDArg <> NIL then begin
			With Args do begin
				If RDA[OPT_LEFTEDGE] <> 0 then
					arg_LeftEdge := pLONG(RDA[OPT_LEFTEDGE])^;
				If RDA[OPT_TOPEDGE] <> 0 then
					arg_TopEdge := pLONG(RDA[OPT_TOPEDGE])^;
				If RDA[OPT_ICON] <> 0 then
					arg_Icon := PtrToPas(STRPTR(RDA[OPT_ICON]));
				If RDA[OPT_NAME] <> 0 then
					arg_Name := PtrToPas(STRPTR(RDA[OPT_NAME]));
				If RDA[OPT_REXXPORT] <> 0 then
					arg_RexxPort := PtrToPas(STRPTR(RDA[OPT_REXXPORT]));
				If RDA[OPT_REXXCMD] <> 0 then
					arg_RexxCmd := PtrToPAs(STRPTR(RDA[OPT_REXXCMD]));
				If RDA[OPT_CXPRI] <> 0 then
					arg_CXPri := pLONG(RDA[OPT_CXPRI])^;
			End;
			FreeArgs(RDArg);
		End;
	end else begin
		dobj := GetDiskObject(STRPTR(pWBStartup(WBenchMsg)^.sm_ArgList^.wa_Name));
		if dobj <> NIL then begin
			ArgPtr := dobj^.do_ToolTypes;
			With Args do begin
				arg_LeftEdge   := GetArgInt(ArgPtr,    'LEFTEDGE', arg_LeftEdge);
				arg_TopEdge    := GetArgInt(ArgPtr,    'TOPEDGE', arg_TopEdge);
				arg_Icon       := GetArgString(ArgPtr, 'ICON', arg_Icon);
				arg_Name       := GetArgString(ArgPtr, 'NAME', arg_Name);
				arg_RexxPort   := GetArgString(ArgPtr, 'REXXPORT', arg_RexxPort);
				arg_RexxCmd    := GetArgString(ArgPtr, 'REXXCMD', arg_RexxCmd);
				arg_CXPri      := GetArgInt(ArgPtr,    'CX_PRIORITY', arg_CXPri);
			End;
			FreeDiskObject(dobj);
		end;
	end;
	With Args do begin
		If arg_LeftEdge < 1 then
			arg_LeftEdge := NO_ICON_POSITION;
		If arg_TopEdge < 1 then
			arg_TopEdge  := NO_ICON_POSITION;
	End;
	FreeRemember(@RemKey, True);	
end;

(***************************************************************************)
Function Open_Libraries : Boolean;


Begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',37));
	IconBase := OpenLibrary('icon.library',37);
	WorkbenchBase := OpenLibrary('workbench.library',37);
	CxBase := OpenLibrary('commodities.library',37);
	RexxSysBase := pRxsLib(OpenLibrary('rexxsyslib.library',0));
	If (IntuitionBase <> NIL) and (IconBase <> NIL) and 
	   (WorkbenchBase <> NIL) and (CxBase <> NIL) then
		Open_Libraries := True
	Else
		Open_Libraries := False;
End;


(***************************************************************************)
Procedure Close_Libraries;

Begin
	CloseLibrary(pLibrary(RexxSysBase));
	CloseLibrary(pLibrary(CxBase));
	CloseLibrary(pLibrary(WorkbenchBase));
	CloseLibrary(pLibrary(IconBase));
	CloseLibrary(pLibrary(IntuitionBase));
End;


(***************************************************************************)
Procedure Delete_File(filename, infotoken : STRPTR);
	
Var
	e,
	ret   : LONG;
	ok, 
	Ok2   : Boolean;
	fn,
	title,
	btext,
	gtext : String;
	l     : BPTR;
	ez    : pEasyStruct;
	a     : Array[0..1] of STRPTR;
	
begin
	e := SetIOErr(0);
	If MatchPatternNoCase(infotoken, filename) then begin
		{ info file }
		fn := PtrToPas(filename);
		Delete(fn, Length(fn)-4, 5);
		fn := fn + #0;
		filename := @fn[1];
		{ does the icon have a matching file, if so forget }
		l := Lock(filename, ACCESS_READ);
		If l <> NULL then begin
			{ has file }
			Ok := True;
		End else begin
			{ lone icon }
			Ok := DeleteDiskObject(filename);
		End;
		UnLock(l);
	End else begin	
		l := Lock(filename, ACCESS_READ);
		If l <> NULL then Begin
			UnLock(l);
			Ok := DeleteFile(filename);
		End else
			Ok := True;
		If Ok then
			Ok2 := DeleteDiskObject(filename);
	End;
	If NOT Ok then begin
		e := IoErr;
		Case e of
			ERROR_DIR_NOT_FOUND,
			ERROR_OBJECT_NOT_FOUND : ;
			ERROR_DELETE_PROTECTED : Begin
				ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
				If ez <> NIL then Begin
					title := 'Rubbish Dump'#0;
					btext := '"%s"'#10 +
					         'Is protected from deletion'#0;
					gtext := 'Delete|Don''t Delete'#0;
					With ez^ do Begin
						es_StructSize   := Sizeof(tEasyStruct);
						es_Flags        := 0;
						es_Title        := @title[1];
						es_TextFormat   := @btext[1];
						es_GadgetFormat := @gtext[1];
					End;
					a[0] := filename;
					ret := EasyRequestArgs(NIL, ez, NIL, @a);
					If ret = 1 then begin
						Ok := SetProtection(filename, 0);
						fn := PtrToPas(filename) + '.info'#0;
						Ok := SetProtection(@fn[1], 0);
						Ok := DeleteFile(filename);
						Ok := DeleteDiskObject(filename);
					End;
					FreeVec(ez);
				End;
			End;
			Else Begin
				ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
				If ez <> NIL then Begin
					title := 'Rubbish Dump'#0;
					btext := 'Can''t delete "%s"'#10 +
					         '%s'#0;
					gtext := 'Ok'#0;
					With ez^ do Begin
						es_StructSize   := Sizeof(tEasyStruct);
						es_Flags        := 0;
						es_Title        := @title[1];
						es_TextFormat   := @btext[1];
						es_GadgetFormat := @gtext[1];
					End;
					ret := Fault(e, NIL, @fn, Sizeof(fn));
					a[0] := filename;
					a[1] := @fn;
					ret := EasyRequestArgs(NIL, ez, NIL, @a);
					FreeVec(ez);
				End;
			End;
		End;
	End;
End;


(***************************************************************************)
Procedure Delete_Dir(l : BPTR; infotoken : STRPTR);
VAR
	oldcd, 
	l2      : BPTR;
	fib     : pFileInfoBlock;
	OK, ok2 : Boolean;
	s       : String[250];
	
begin
	oldcd := CurrentDir(l);
	fib := AllocDosObject(DOS_FIB, NIL);
	if fib <> NIL then begin
		OK := Examine(l, fib);
		OK := ExNext(l, fib);
		While OK do begin			
			if fib^.fib_DirEntryType > 0 then begin
				l2 := Lock(@fib^.fib_FileName, ACCESS_READ);
				Delete_Dir(l2, infotoken);
				ok2 := NameFromLock(l2, @s, Sizeof(s));
				UnLock(l2);
				If ok2 then
					Delete_File(@s, infotoken);
			End;
			if fib^.fib_DirEntryType < 0 then
				Delete_File(@fib^.fib_FileName, infotoken);
			OK := ExNext(l, fib);
		end;
		FreeDosObject(DOS_FIB, fib);
	End;
	oldcd := CurrentDir(oldcd);
End;


(***************************************************************************)
Procedure HandleAppIcon(VAR aih       : tAIHandle; 
                        VAR V         : tProgVars;
                            enabled   : Boolean;
                            infotoken : STRPTR);
Type
	pLNode = ^tLNode;
	tLNode = Record
		ln_Succ : pLNode;
		ln_Pred : pLNode;
		ln_Lock : BPTR;
		ln_Name : STRPTR;
	End;

Var
	n     : Integer;
	WBArg : pWBArg;
	ap    : pAnchorPath;
	err   : LONG;
	l     : BPTR;
	am    : pAppMessage;
	ok    : Boolean;
	s     : String;
	node  : pLNode;
	list  : tList;
	lrk   : pRemember;
	
Begin
	am := pAppMessage(GetMsg(aih.ai_MsgPort));
	While am <> NIL do begin
		If Enabled then begin
			If NOT((am^.am_NumArgs = 0) or (am^.am_ArgList = NIL)) then begin
				lrk := NIL;
				NewList(@list);
				{ copy the args, so the locks get freed }
				WBArg := am^.am_ArgList;
				For n := 1 to am^.am_NumArgs do begin
					node := AllocRemember(@lrk, SizeOf(tLNode), MEMF_CLEAR);
					If node <> NIL then begin
						node^.ln_Name := CSCPAR(@lrk, PtrToPas(STRPTR(WBArg^.wa_Name)));
						node^.ln_Lock := DupLock(WBArg^.wa_Lock);
						AddTail(@list, pNode(node));
					End;
					WBArg := Pointer(Long(WBArg) + sizeof(tWBArg));
				End;	
				
				ReplyMsg(pMessage(am));
				am := pAppMessage(GetMsg(aih.ai_MsgPort));
				
				{ delete the objects }
				node := pLNode(list.lh_Head);
				While node^.ln_Succ <> NIL do begin
					If PtrToPas(node^.ln_Name) = '' then begin
						{ dir }
						Delete_Dir(Node^.ln_Lock,infotoken);
						ok := NameFromLock(Node^.ln_Lock, @s, Sizeof(s));
						UnLock(Node^.ln_Lock);
						If ok then
							Delete_File(@s, infotoken);
					End else begin
						{ file }
						l := CurrentDir(Node^.ln_Lock);
						Delete_File(Node^.ln_Name, infotoken);
						l := CurrentDir(l);
						UnLock(Node^.ln_Lock);
					End;
					node := node^.ln_Succ;
				End;				
			
				FreeRemember(@lrk, True);
				SendARexxCommand(V.arg_RexxCmd, V.arg_RexxPort);
			End else begin
				ReplyMsg(pMessage(am));
				am := pAppMessage(GetMsg(aih.ai_MsgPort));
			End;
		End else begin
			ReplyMsg(pMessage(am));
			am := pAppMessage(GetMsg(aih.ai_MsgPort));
		End;
	End;
End;

(***************************************************************************)
Procedure HandleMsgs(VAR cxh : tCxHandle;
                     VAR aih : tAIHandle;
                     VAR V   : tProgVars);
                     
Var
	CxMask, AIMask,
	sigre,
	cxtype, cxid : LONG;
	am : pAppMessage;
	cxm : pCxMsg;
	ExitFlag,
	Enabled : Boolean;
	InfoToken : String;

Const
	InfoS : String[8] = '#?.info'#0;
	
Begin
	If ParsePatternNoCase(@infos[1], @infotoken, SizeOf(infotoken)) <> 0 Then ;
	CxMask := (1 shl cxh.cx_MsgPort^.MP_SIGBIT);
	AIMask := (1 shl aih.ai_MsgPort^.MP_SIGBIT);
	Enabled := True;
	ExitFlag := False;
	While Not ExitFlag do Begin
		sigre := Wait(CxMask|AIMask|SIGBREAKF_CTRL_C);
		
		if ((sigre and SIGBREAKF_CTRL_C)=SIGBREAKF_CTRL_C) then
			ExitFlag := True;
			
		if ((sigre and AIMask)=AIMask) then begin
			HandleAppIcon(aih, V, enabled, @infotoken);
		End; {aimask}
		
		if ((sigre and CxMask)=CxMask) then begin
			cxm := pCxMsg(GetMsg(cxh.cx_MsgPort));
			While cxm <> NIL do begin
				cxtype := CxMsgType(CxM);
				cxid := CxMsgID(CxM);
				ReplyMsg(pMessage(cxm));
				Case cxtype of
					CXM_COMMAND : begin
						case cxid of
							CXCMD_DISABLE   : Enabled := False;
							CXCMD_ENABLE    : Enabled := True;
							CXCMD_KILL      : ExitFlag := True;
							CXCMD_UNIQUE    : ExitFlag := True;
						end; {case cxid}
					end; {cxm_command}
				End; {case cxtype}
				cxm := pCxMsg(GetMsg(cxh.cx_MsgPort));
			End;
		End; {CxMask}
			
	End; {while not exitflag}
End;


(***************************************************************************)
Procedure Main;

Var
	V   : tProgVars;
	cxh : tCxHandle;
	aih : tAIHandle;

Begin
	If pLibrary(SysBase)^.lib_Version < 37 then Halt;
	
	If Open_Libraries then begin
		GetToolTypes(V);
		If InitCx(cxh, cxname, cxtitle, cxdesc, 0, NBU_UNIQUE|NBU_NOTIFY, V.arg_CXPri) then begin
			If AddAIcon(aih, V.arg_Icon, V.arg_Name, V.arg_LeftEdge, 
			            V.arg_TopEdge, 0, 0, True) Then begin
				HandleMsgs(cxh, aih, V);
				RemoveAIcon(aih);
			End;
			RemoveCx(cxh);
		End;
		Close_Libraries;
	End;
End;


(***************************************************************************)
Begin Main End.