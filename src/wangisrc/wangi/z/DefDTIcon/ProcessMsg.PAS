Function UpperStr(S : String) : String;
Var
     X : Byte;
Begin
  For X := 1 To Length(S) Do
    S[X] := UpCase(S[X]);
  UpperStr := S;
End;

Procedure HandleApp(AppPort : pMsgPort);

	
VAR
	mes         : pAppMessage;
	strList     : pList;
	WBarg       : pWBArg;
	n           : byte;
	RemKey      : pRemember;
	node        : pStrNode;
	FName       : STRPTR;
	oldTT,oldDD,
	oldTW,oldDT : Pointer;
	olddir, dl1, 
	dl2  : BPTR;
	dobj,
	defdobj     : pDiskObject;
	OK          : Boolean;
	dt          : pDataType;
	BName, 
	IName, 
	ts, buf     : String;
	existing    : Boolean;

	
Procedure DoIt;

begin
	oldTT := defdobj^.do_ToolTypes;
	oldDD := defdobj^.do_DrawerData;
	oldTW := defdobj^.do_ToolWindow; { dont know what it is !!}
	oldDT := defdobj^.do_DefaultTool;
	
	if existing then begin
		defdobj^.do_ToolTypes := dobj^.do_ToolTypes; 
		defdobj^.do_DrawerData := dobj^.do_DrawerData;
		defdobj^.do_StackSize := dobj^.do_StackSize;
		{ make this optional as I'm uncertian to what it will be ¿? }
		If NOT V.NOTOOLWIN then
			defdobj^.do_ToolWindow := dobj^.do_ToolWindow;
		If NOT V.DEFAULTTOOL then
			defdobj^.do_DefaultTool := dobj^.do_DefaultTool;
		defdobj^.do_CurrentX := dobj^.do_CurrentX;
		defdobj^.do_CurrentY := dobj^.do_CurrentY;
	end else begin
		defdobj^.do_CurrentX := NO_ICON_POSITION;
		defdobj^.do_CurrentY := NO_ICON_POSITION;
	end;
	OK := PutDiskObject(FName,defdobj);
	if NOT OK then 
		OK := PutDiskObject(FName,dobj);
						
	if existing then begin
		defdobj^.do_ToolTypes := oldTT;
		defdobj^.do_DrawerData := oldDD;
		defdobj^.do_ToolWindow := oldTW;
		defdobj^.do_DefaultTool := oldDT;
	end;
	FreeDiskObject(defdobj);
end;

Function MakeFileName(iconname : String) : String;

Type
	strin = String[255];
	pStr = ^Strin;

Var
	s : pStr;
	
Begin
	MakeFileName := '';
	iconname := 'def_'+iconname+#0;
	s := AllocVec(256, MEMF_CLEAR);
	if s <> NIL then begin
		move(V.ICONDIR[1], s^, length(V.ICONDIR));
		if AddPart(STRPTR(s), @iconname[1], 256) then
			MakeFileName := PtrToPas(STRPTR(s));
		FreeVec(s);
	End;
End;



Begin
	OK := False;
	mes := pAppMessage(GetMsg(AppPort));
	RemKey := NIL;
	While mes <> NIL do begin
		if mes^.am_NumArgs > 0 then begin
			StrList := AllocRemember(@RemKey, sizeof(tList), MEMF_CLEAR|MEMF_PUBLIC);
			NewList(pList(StrList));
			WBArg := mes^.am_ArgList;
			For n := 0 to mes^.am_NumArgs-1 do begin
			
				node := AllocRemember(@RemKey, sizeof(tStrNode), MEMF_CLEAR|MEMF_PUBLIC);
				if node <> NIL then begin
					node^.sn_Name := PtrToPas(STRPTR(WBArg^.wa_Name));
					node^.sn_Lock := dupLock(WBArg^.wa_Lock);
					AddTail(pList(StrList),pNode(node));
				End;
				WBArg := Pointer(Long(WBArg) + sizeof(tWBArg));
			end;	
		end else StrList := NIL;

		ReplyMsg(pMessage(mes));
		
		if StrList <> NIL then begin
			node := pStrNode(StrList^.lh_Head);
			While (Node^.sn_Node.ln_Succ <> NIL) do begin
				
				OK := False;
				if node^.sn_Name = '' then begin
					dl1 := ParentDir(node^.sn_Lock);
					if dl1 = NULL then begin
						{ disk if NULL (root file system) parent }
						FName := CStrConstPtrAR(@RemKey,'disk');
					end else begin
						ok := NameFromLock(node^.sn_Lock, @ts, 256);
						unlock(node^.sn_Lock);
						node^.sn_Lock := dl1;
						FName := @ts;
					end;
				end else
					FName := CStrConstPtrAR(@RemKey,node^.sn_Name);

				olddir := CurrentDir(node^.sn_Lock);

				dl2 := lock(CStrConstPtrAR(@RemKey, PtrToPas(FName)+'.info'), SHARED_LOCK);
				if dl2 <> NULL then
					existing := True
				else
					existing := false;
				unlock(dl2);
				
				dobj := GetDiskObjectNew(FName);
				defdobj := NIL;
				
				if dobj <> NIL then begin
					if NOT((dobj^.do_Type = WBPROJECT) or (dobj^.do_Type = WBTOOL)) then begin
						if (dobj^.do_Type = WBDISK) or (dobj^.do_Type = WBDRAWER) or (dobj^.do_Type = WBKICK) then begin
							defdobj := GetDefDiskObject(dobj^.do_Type);
							if defdobj <> NIL then 
								DoIt;
						End;
					end else begin
						if (DataTypesBase <> NIL) and (NOT V.NODATATYPE) then begin
							dl2 := Lock(FName, SHARED_LOCK);
							if dl2 <> NULL then begin
								dt := ObtainDataTypeA(DTST_FILE, Pointer(dl2), NIL);
								if dt <> NIL then begin
								
									if NOT V.COARSE then begin
										if dt^.dtn_Header^.dth_ID = $62696E61 {bina} then
											BName := 'Use sys tool'
										else
											BName := PtrToPas(dt^.dtn_Header^.dth_Name);
									end else begin
										if dt^.dtn_Header^.dth_ID = $62696E61 {bina} then
											BName := 'Use sys tool'
										else
											BName := PtrToPas(IDToStr(dt^.dtn_Header^.dth_GroupID ,@buf));
									end;
								
									if BName <> 'Use sys tool' then begin
										IName := MakeFileName(BName);
										defdobj := GetDiskObject(CStrConstPtrAR(@RemKey, IName));
										if defdobj = NIL then begin
											IName := MakeFileName(PtrToPas(dt^.dtn_Header^.dth_BaseName));
											defdobj := GetDiskObject(CStrConstPtrAR(@RemKey, IName));
											if defdobj = NIL then begin
											IName := MakeFileName(PtrToPas(IDToStr(dt^.dtn_Header^.dth_GroupID ,@buf)));
												defdobj := GetDiskObject(CStrConstPtrAR(@RemKey, IName));
												if defdobj = NIL then
													defdobj := GetDefDiskObject(WBPROJECT);
											end;
										end;
									end else begin
										if NOT(V.NOTOOL) then
											defdobj := GetDefDiskObject(WBTOOL)
										else
											defdobj := NIL;
									End;
									
									if defdobj <> NIL then 
										DoIt;
									ReleaseDataType(dt);
								end;
								unlock(dl2);
							end;
						end else begin 
							defdobj := GetDefDiskObject(dobj^.do_Type);
							if defdobj <> NIL then 
								DoIt;
						end;
					end;
				end;

				if dobj <> NIL then
					FreeDiskObject(dobj);
						
				olddir := CurrentDir(olddir);
				unlock(node^.sn_Lock);
						
				If NOT OK then DisplayBeep(NIL);
				node := pStrNode(Node^.sn_Node.ln_Succ);
			end;
		end;
		
		{*********}
		
		mes := pAppMessage(GetMsg(AppPort));
	end;
	FreeRemember(@RemKey, True);
end;
 
 
Procedure ProcessMessage(VAR IDPort, AppPort : pMsgPort);

VAR 
	Disable : Boolean;
	IDSig, IDCMPSig, AppSig, sigrcvd, BitFlags : LONG;
	Finished : Boolean;
	mes : pMessage;
	
begin
	IDSig := 0;
	IDCMPSig := 0;
	AppSig := 0;
	disable := false;
	finished := false;
	
	IDSig := 1 shl IDPort^.mp_SigBit;
	AppSig := 1 shl AppPort^.mp_SigBit;
	
	BitFlags := SIGBREAKF_CTRL_C OR IDSig OR IDCMPSig OR AppSig;
	While Not Finished do begin
		sigrcvd := Wait(BitFlags);
		if ((sigrcvd and IDSig)=IDSig) then begin
			mes := GetMsg(IDPort);
			ReplyMsg(mes);	
			Finished := True;
		end;
		if ((sigrcvd and AppSig)=AppSig) then begin
			HandleApp(AppPort);
		end;
		if ((sigrcvd and SIGBREAKF_CTRL_C)=SIGBREAKF_CTRL_C) then begin
			Finished := True;
		end; 
	end;
end;
