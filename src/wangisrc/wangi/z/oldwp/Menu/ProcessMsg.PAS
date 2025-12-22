Function InitWBMenus : Boolean;

Var
	node : pMyNode;
	n2   : pNode;
	ord  : LONG;
	t    : pAppMenuItem;
	
Begin
	WBMport := CreateMsgPort;
	If WBMPort <> NIL Then Begin
		NewList(@wbmlist);
		ord := 0;
		node := pMyNode(currentlist^.lh_Head);
		while node^.wi_Node.ln_Succ <> NIL do begin
			If (node^.wi_Flags and WIF_TOOLMENU)= WIF_TOOLMENU then begin
				t := AddAppMenuItemA(ord, LONG(node), node^.wi_Node.ln_Name, WBMPort, NIL);
				If t <> NIL Then Begin
					n2 := AllocVec(Sizeof(tNode), MEMF_CLEAR);
					if n2 <> NIL then begin
						n2^.ln_Name := STRPTR(t);
						AddTail(@wbmlist, n2);
					End;
				End;
			End;
			node := pMyNOde(node^.wi_Node.ln_Succ);
			inc(ord);
		End;
		InitWBMenus := True;
	End;
End;

Procedure FreeWBMenus;

Var
	node, n2 : pNode;
	Ok : Boolean;
	
Begin
	If WBMPort <> NIL Then Begin
		node := pNode(wbmlist.mlh_Head);
		while node^.ln_Succ <> NIL do begin
			n2 := node^.ln_Succ;
			Ok := RemoveAppMenuItem(pAppMenuItem(node^.ln_Name));
			FreeVec(node);
			node := n2;
		End;
	End;
End;

Function InitCx : Boolean;

Var
	nb : tNewBroker;
	r  : LONG;
	node : pMyNode;
	hkfilter,
	hksender,
	hktranslate : pCxObj;
	thk : String;

Begin
	InitCx := False;
	Cxport := CreateMsgPort;
	if Cxport <> NIL then begin
		{ watch this Pascalians ;^). if you put : }
		{ With nb do begin                        }
		{   nb_Version := NB_VERSION              }
		{ end;                                    }
		{ you will not get any messages from Cx   }
		{ because you are assigning the field     }
		{ nb_Version to the field nb_version and  }
		{ not the NB_VERSION constant             }
			
		nb.nb_Version := NB_VERSION;
		With nb do begin
			nb_Name   := @CX_NAME[1];
			nb_Title  := @CX_TITLE[1];
			nb_Descr  := @CX_DESCR[1];
			nb_Unique := 0;
			nb_Flags  := COF_SHOW_HIDE;
			nb_Pri    := V.arg_Pri;
			nb_Port   := CxPort;
			nb_ReservedChannel := 0;
		end;
		Broker := CxBroker(@nb, NIL);
		If broker <> NIL then begin
			V.arg_Hotkey := V.arg_Hotkey + #0;
			Filter := CxFilter(@V.arg_Hotkey[1]);
			if filter <> NIL then begin
				AttachCxObj(broker,filter);
				Sender := CxSender(CxPort, -1);
				If sender <> NIL then begin
					AttachCxObj(filter, sender);
					translate := CxTranslate(NIL);
					if translate <> NIL then begin
						AttachCxObj(filter, translate);
						
						{ add all hotkeys }
						node := pMyNode(currentlist^.lh_Head);
						while node^.wi_Node.ln_Succ <> NIL do begin
							thk := PtrToPas(node^.wi_HotKey);
							If thk <> '' then begin
								hkFilter := CxFilter(node^.wi_HotKey);
								if hkfilter <> NIL then begin
									AttachCxObj(broker,hkfilter);
									hksender := CxSender(CxPort, LONG(node));
									If hksender <> NIL then begin
										AttachCxObj(hkfilter, hksender);
										hktranslate := CxTranslate(NIL);
										if hktranslate <> NIL then begin
											AttachCxObj(hkfilter, hktranslate);
										End;
									End;
								End;
							End;
							node := pMyNode(node^.wi_Node.ln_Succ);
						end;						
						
						if (CxObjError(filter) = 0) then begin
							r := ActivateCxObj(broker, 1);
							InitCx := True;
						End;
					End;
				End;
			End;
		End;
	End;
End;

Procedure RemoveCx;

Var
	msg : pMessage;
	
Begin
	DeleteCxObjAll(broker);
	{ clear the port of any last minute messages }
	Msg := GetMsg(Cxport);
	While msg <> NIL do begin
		ReplyMsg(msg);
		Msg := GetMsg(Cxport);
	end;
	{ remove the port }
	DeleteMsgPort(CxPort);
end;

{ Set up Port for IPC messages from WangiPrefs }
Function InitIPC : Boolean;

Begin
	InitIPC := False;
	WangiPort := CreateMsgPort;
	If WangiPort <> NIL then begin
		wangiport^.mp_Node.ln_Name := CStrConstPtrAR(@grk, 'WangiPad_Port');
		wangiport^.mp_Node.ln_Pri := 0;
		AddPort(WangiPort);
		InitIPC := True;
	End;
End;

{ remove IPC port }
Procedure RemoveIPC;

Var
	Ok : Boolean;
	m  : pMessage;
	
Begin
	if WangiPort <> NIL then begin
		m := GetMsg(WangiPort);
		While m <> NIL do begin
			ReplyMsg(m);
			m := GetMsg(WangiPort);
		End;
	End;
	if WangiPort <> NIL then begin
		RemPort(WangiPort);
		DeleteMsgPort(WangiPort);
	End;
	WangiPort := NIL;
End;

{ Set up Port for notify messages from DOS }
Function InitNotify : Boolean;

Var
	ok : Boolean;

Begin
	InitNotify := False;
	NotifyPort := CreateMsgPort;
	If NotifyPort <> NIL then begin
		nr := AllocVec(Sizeof(tNotifyRequest), MEMF_CLEAR);
		if nr <> NIL then begin
			With nr^ do begin
				nr_Name        := CStrConstPtrAR(@grk, V.arg_From);
				nr_UserData    := 337;
				nr_Flags       := NRF_SEND_MESSAGE;
				nr_Msg.nr_Port := NotifyPort;
			End;
			Ok := StartNotify(nr);
			InitNotify := True;
		End;
	End;
End;

Procedure RemoveNotify;

Begin
	If notifyPort <> NIL then begin
		EndNotify(nr);
		DeleteMsgPort(NotifyPort);
		FreeVec(nr);
	End;
End;


Function InitTimer : Boolean;

Begin
	Inittimer := false;
	TimerPort := CreateMsgPort;
	If timerport <> NIL then begin
		tio := pTimeRequest(CreateIORequest(TimerPort, sizeof(ttimerequest)));
		if tio <> NIL then begin
			If OpenDevice(TIMERNAME,UNIT_VBLANK, pIORequest(tio),0) = 0 then
				InitTimer := True;
		End;
	End;
End;

Procedure CloseTimer;

Var
	e : LONG;
	
begin
	If tio <> NIL then begin
		If CheckIO(pIORequest(tio)) = NIL then begin
			AbortIO(pIORequest(tio));
			e := WaitIO(pIORequest(tio));
		End;
		CloseDevice(pIORequest(tio));
		DeleteIORequest(pIORequest(tio));
	End;
	DeleteMsgPort(TimerPort);
End;

Procedure SendTimer;

Begin
	If (CD.cd_Level = LEV_FRONT) or (CD.cd_Level = LEV_BACKM) then begin
		tio^.tr_Node.io_Command := TR_ADDREQUEST;
		tio^.tr_Node.io_Flags := 0;
		tio^.tr_Node.io_Error := 0;
		tio^.tr_Time.tv_Secs := V.arg_LevelT;
		tio^.tr_Time.tv_Micro := 0; 
		SendIO(pIORequest(tio));
	End
End;




Procedure HandleResize(w : pWindow);
	
Var
	pos, Top : LONG;
	t : Array[0..3] of tTagItem;
	
Begin
	pos := RemoveGList(w, g[G_NI], -1);
	if pos <> -1 then begin
		EraseRect(w^.RPort, 0, 0, w^.Width, w^.Height);
		CD.cd_LeftEdge := w^.LeftEdge;
		CD.cd_TopEdge := w^.TopEdge;
		CD.cd_Width := w^.Width;
		CD.cd_Height := w^.Height;
		
		pos := 0;
		if GadToolsBase^.lib_Version >= 39 then begin
			T[0].ti_Tag  := GTLV_Top;
			T[0].ti_Data := LONG(@Top);
			T[1].ti_Tag  := TAG_END;
			pos := GT_GetGadgetAttrsA(g[G_LV], w, NIL, @t);
		End;
		if pos = 0 then top := 0;
		
		FreeGadgets(g[G_NI]);
		g[G_NI] := NIL;
		G[G_CC] := CreateContext(@G[G_NI]);
		If G[G_CC] <> NIL Then begin
			G[G_LV] := MakeLVGadget(G[G_CC]);
			
			pos := AddGList(w, g[G_NI], $FFFF, -1, NIL);
			RefreshGList(g[G_NI], w, NIL, -1);
			GT_RefreshWindow(w,NIL);
			RefreshWindowFrame(w);
		End;
	End;
End;


Procedure EnableWindow(w : pWindow; key : Pointer);

Var
	edw : pEnDisWin;

Begin
	if pLibrary(SysBase)^.lib_Version >= 39 then begin
		SetWindowPointerA(w, NIL);
		edw := pEnDisWin(key);
		If edw <> NIL then begin
			if edw^.edw_Req <> NIL then begin
				EndRequest(edw^.edw_Req, w);
				if (edw^.edw_OldWidth <> w^.Width) or 
				   (edw^.edw_OldHeight <> w^.Height) then { resize window }
					HandleResize(w);
				FreeVec(edw^.edw_Req);
				FreeVec(edw);
			End;
		End;
	End else begin
		if ReqToolsBase <> NIL then begin
			if key <> NIL then begin
				rtUnLockWindow(w, Key);
			End;
		End;
	End;
End;

Function DisableWindow(w : pWindow) : Pointer;

Var
	t : Array[0..4] of LONG;
	req : pEnDisWin;

begin
	DisableWindow := NIL;
	if pLibrary(SysBase)^.lib_Version >= 39 then begin
		t[0] := WA_BusyPointer;
		t[1] := True_;
		t[2] := WA_PointerDelay;
		t[3] := True_;
		t[4] := TAG_END;
		SetWindowPointerA(w, @t);
		req := AllocVec(sizeof(tEnDisWin), MEMF_CLEAR);
		if req <> NIL then begin
			req^.edw_Req := AllocVec(sizeof(tRequester), MEMF_CLEAR);
			if req^.edw_req <> NIL then begin
				If Request(req^.edw_req, w) then begin
					req^.edw_OldWidth := w^.Width;
					req^.edw_OldHeight := w^.Height;
					DisableWindow := Pointer(req);
				end else begin
					FreeVec(req^.edw_Req);
					FreeVec(req);
				End;
			End;
		End;
	End else begin
		If ReqtoolsBase <> NIL then
			DisableWindow := Pointer(rtLockWindow(w));
	End;
end;

Function PutArgs(cmd : String; am : pAppMessage) : String;

Var
	FirstPart, 
	SecondPart,
	ts        : String;
	n, place  : Integer;
	buf       : STRPTR;
	wbarg     : pWBArg;
	
Begin
	place := 0;
	For n := 1 to length(cmd)-1 do begin
		if cmd[n] = '[' then begin
			if cmd[n+1] = ']' then begin 
				place := n;
			End;
		End;
	End; 
	If place > 0 then begin
		FirstPart := Copy(cmd, 1, place-1);
		Secondpart := Copy(cmd, place+2, Length(cmd)-place-1)+#0;
		If am <> NIL then begin
			wbarg := am^.am_ArgList;
			For n := 1 to am^.am_NumArgs do begin
				buf := AllocVec(255, MEMF_CLEAR);
				if buf <> NIL Then begin
					If wbarg^.wa_Lock <> NULL then begin
						If NameFromLock(wbarg^.wa_Lock, buf, 255) then begin
							If AddPart(buf, STRPTR(WBArg^.wa_Name), 255) then begin
								ts := PtrToPas(buf);
								If pos(' ', ts) <> 0 then
									ts := '"' + ts + '"';
								ts := ts + ' ';
								if Length(firstpart)+length(ts)+length(secondpart) < 256 then
								Firstpart := Firstpart + ts;
							End;
						End;
					End;
					FreeVec(buf);
				End;
				wbarg := pWBArg(LONG(wbarg)+Sizeof(tWBArg));
			End;
		End;
		FirstPArt := FirstPart + SecondPart + #0;
	End else
		FirstPart := cmd+#0;
	PutArgs := FirstPart;
End;



Function  StartCLIProgram(node : pMyNode; am : pAppMessage) : Boolean;
	
VAR
	newcd, cd,
	oldcd   : BPTR;
	t       : Array[0..14] of LONG;
	out,
	expcmd  : String;
	outfile : BPTR;
	rc,OK   : Boolean;
	pl      : pPathList;

Begin
	{ Send the ARexx command }
	SendARexxCommand(PtrToPas(node^.wi_RexxCmd),PtrToPas(node^.wi_RexxPort),am);
	rc := False;
	newcd := Lock(node^.wi_Cmd[0] ,SHARED_LOCK);
	if (newcd <> 0) and (PtrToPas(node^.wi_Cmd[1]) <> '') then begin
	
		{ subsitute args }
		expcmd := PutArgs(PtrToPas(node^.wi_Cmd[1]),am);
		
		{ if wished, allow user to alter cmd line }
		If ((node^.wi_Flags and WIF_EDITCMD) = WIF_EDITCMD) and (ReqToolsBase <> NIL) Then Begin
			t[0] := RTGS_GadFmt;
			t[1] := LONG(CStrConstPtrAR(@prk, 'Ok'));
			t[2] := TAG_END;
			t[0] := rtGetStringA(@expcmd[1], 255, 
			                   CStrConstPtrAR(@prk, 'Edit Command Line'), NIL, @t); 
		End;
							
		{ Go to program's current directory }
		oldcd := CurrentDir(newcd);
			
		{ open IO file }
		Out :=  PtrToPas(node^.wi_Output);
		If Out = '' then
			Out := 'NIL:'#0
		else 
			out := out+#0;
		
		outfile := Open(@out[1], MODE_OLDFILE);
			
		{ Copy path list }
		If gp <> NIL then
			CopyPathList(gp, pl)
		else
			pl := NIL;
			
		{ Start program }	
		t[ 0] := SYS_Asynch;
		t[ 1] := True_;
		t[ 2] := SYS_Input;
		t[ 3] := outfile;
		t[ 4] := SYS_Output;
		t[ 5] := 0;
		t[ 6] := NP_StackSize;
		t[ 7] := node^.wi_Stack;
		t[ 8] := NP_Priority;
		t[ 9] := node^.wi_Priority;
		t[10] := SYS_UserShell;
		t[11] := True_;
		if pl <> NIL then begin
			t[12] := NP_Path;
			t[13] := MKBADDR(pl);
		end else
			t[12] := TAG_END;
		t[14] := TAG_END;
		if SystemTagList(@expcmd[1],@t) = 0 then
			rc := TRUE { Program started! } 
		else begin
			{ failed, free alloc'ed resources }
			OK := Close_(outfile);
			FreePathList(pl);
		End;
				
		{ Go back to old current directory }
		newcd := CurrentDir(oldcd);
	End;
	UnLock(newcd);
	if PtrToPas(node^.wi_Cmd[1]) = '' then 
		rc := True;
	StartCLIProgram := rc;
End;

{ Start WB program }
Function StartWBProgram(node : pMyNode; msg : pAppMessage) : Boolean;

Var
	hp        : pMsgPort; { port of handler }
	wbsm      : tWBStartMsg; { message for handler }
	rc        : Boolean;
	dummyport : pMsgPort;
	m         : pMessage;
	i         : LONG;
	t         : Array[0..14] of LONG;
	pl        : pPathList;
		
Begin
	{ Send the ARexx command }
	SendARexxCommand(PtrToPas(node^.wi_RexxCmd),PtrToPas(node^.wi_RexxPort),msg);
	
	rc := False;
	
	DummyPort := CreateMsgPort;
	If DummyPort <> NIL then begin
	
		{ Build message for WBStart-Handler }
		wbsm.wbsm_Msg.mn_Node.ln_Pri:= 0;
		wbsm.wbsm_Msg.mn_ReplyPort  := DummyPort;
		wbsm.wbsm_Name              := node^.wi_Cmd[1];
		wbsm.wbsm_DirLock           := Lock(node^.wi_Cmd[0],SHARED_LOCK);
		wbsm.wbsm_Stack             := node^.wi_Stack;
		wbsm.wbsm_Prio              := node^.wi_Priority;
		if msg <> NIL then begin
			wbsm.wbsm_NumArgs         := msg^.am_NumArgs;
			wbsm.wbsm_ArgList         := msg^.am_ArgList;
		End else begin
			wbsm.wbsm_NumArgs         := 0;
			wbsm.wbsm_ArgList         := NIL;
		End;

		{ Try to send a message to the WBStart-Handler }
		Forbid;
		hp := FindPort(@WBS_PORTNAME[1]);
		If hp <> NIL then
			PutMsg(hp, pMessage(@wbsm));
		Permit;

		{ No WBStart-Handler, try to start it! }
		If hp = NIL then begin
		
			{ Copy path list }
			If gp <> NIL then
				CopyPathList(gp, pl)
			else
				pl := NIL;
			
			{ Start handler }
			t[ 0] := SYS_Input;
			t[ 1] := 0;
			t[ 2] := SYS_Output;
			t[ 3] := 0;
			t[ 4] := SYS_Asynch;
			t[ 5] := True_;
			t[ 6] := SYS_UserShell;
			t[ 7] := True_;
			t[ 8] := NP_ConsoleTask;
			t[ 9] := 0;
			t[10] := NP_WindowPtr;
			t[11] := 0;
			if pl <> NIL then begin
				t[12] := NP_Path;
				t[13] := MKBADDR(pl);
				t[14] := TAG_DONE;
			end else
				t[12] := TAG_DONE;
			If SystemTagList(@WBS_LOADNAME[1], @t) <> - 1 then begin
				{ Handler started, try to send message (Retry up to 5 seconds) }
				Ok := True;
				i := 0;
				While (i<10) and OK do begin
					{ Try to send message }
					Forbid;
					hp := FindPort(@WBS_PORTNAME[1]);
					if hp <> NIL then
						PutMsg(hp, pMessage(@wbsm));
					Permit;
					
					{ Message sent? Yes, leave loop }
					If hp <> NIL then 
						OK := False
					else 
						{ No, wait 1/2 second }
						Delay(25);
					i := i + 1;
				End;
			End;
		End;
	
		{ Could we send the message? }
		if (hp <> NIL) then Begin
			{ Get reply message }
			m := WaitPort(DummyPort);
			m := GetMsg(DummyPort);
			rc := Boolean(wbsm.wbsm_Stack); { Has tool been started? }
		End;
		{ Free lock }
		if (wbsm.wbsm_DirLock <> NULL) then
			UnLock(wbsm.wbsm_DirLock);
		{ close port }
		DeleteMsgPort(dummyport);
	End;
	StartWBProgram := rc;
End;



Procedure HandleGadget(w : pWindow; gadcode : pGadget; num : LONG);

Var
	node : pMyNode;
	n    : Integer;
	selected : Boolean;
	
Begin       
	Case gadcode^.GadgetID Of 
		G_LV  : begin
			{ flag that the currenttop is nolonger 0 }
			if num > (LVRows-1) then 
				currenttop := -1
			else
				currenttop := 0;
				
			selected := False;
			If CD.cd_Selection = SEL_DOUBLE then begin
				if num = oldLVord then begin
					If DoubleClick(oldsecs, oldmics, secs, mics) then
						{ double click }
						selected := True;
				end else
					oldlvord := num;
			end else
				selected := true;
				
			If selected then begin
				node := pMyNode(currentlist^.lh_Head);
				For n := 1 to num do begin
					node := pMyNode(node^.wi_Node.ln_Succ);
				End;
				
				Case node^.wi_Type of
					TYPE_SHELL : If NOT StartCLIProgram(node, NIL) then
						TellError(ERROR_SHELL);
					TYPE_WB : If NOT StartWBProgram(node, NIL) then
						TellError(ERROR_WB);
					TYPE_AREXX : SendARexxCommand(PtrToPas(node^.wi_RexxCmd),
					                              PtrToPas(node^.wi_RexxPort),NIL); 
				End;
			End;
		End;
	End;
	oldsecs := secs;
	oldmics := mics;
End;


Procedure RefreshTheWindow(VAR w : pWindow);

begin
	GT_BeginRefresh(w);
	GT_EndRefresh(w, True);
end;

Procedure OpenUpWindow(Var w : pWindow; VAR mask, AppMask : LONG);

Begin
	if w = NIL then begin
		opened := False;	
		w := OpenTheWindow;
		Mask := BitMask(w^.UserPort^.MP_SIGBIT);
		InitMenus(w);
		If AddAppWin(w) Then
			AppMask := BitMask(AppPort^.MP_SIGBIT);
		opened := True;
	End;
End;

Procedure HideWindow(Var w : pWindow; VAR mask, AppMask : LONG);

Begin
	If w <> NIL then begin
		opened := True;
		{ save position so the if WangiPrefs asks for we can give it }
		hidenpos[1] := w^.LeftEdge;
		hidenpos[2] := w^.TopEdge;
		hidenpos[3] := w^.Width;
		hidenpos[4] := w^.height;
		FreeMenus(w);
		RemoveAppWin;
		CloseTheWindow(w);
		w := NIL;
		mask := 0;
		AppMask := 0;
		opened := False;
	End;
End;


Procedure ProcessWindowEvents(Var w : pWindow);

CONST
	Exitflag : Boolean = False;
	
VAR 
	port               : pMsgPort;
	IDCMPMsg           : pIntuiMessage;
	CxMsg              : pCxMsg;
	ipcmsg             : pIPCMsg;
	am                 : pAppMessage;
	notifymsg          : pNotifyMessage;
	msg                : pMessage;
	MsgClass, sigre,
	WinMask, CxMask,
	WangiMask, AppMask,
	NotifyMask, TimerMask,
	WBMMask, cxtype, prev,
	ipctype, LVY, ordn,
	tmp, tmp2, 
	menunumber, y      : LONG;
	MsgCode            : Word;
	Gadcode            : pGadget;
	ez                 : pEasyStruct;
	t                  : Array[0..6] of LONG;
	nde                : pNode;
	ts                 : String;
	item               : pMenuItem;
	hide               : Boolean;
	mn                 : pMyNode;
	Key                : Pointer;
	al                 : Array[0..2] of LONG;
	CxID, mnode        : pMyNode;

begin
	SendTimer;
	currenttop := 0;
	CxMask     := BitMask(CxPort^.MP_SIGBIT);      { for CX msgs                 }
	WangiMask  := BitMask(WangiPort^.MP_SIGBIT);   { for msgs to/from WangiPrefs }
	WinMask    := BitMask(w^.UserPort^.MP_SIGBIT); { for IDCMP msgs              }
	AppMask    := BitMask(AppPort^.MP_SIGBIT);     { for appwindow msgs          }
	NotifyMask := BitMask(NotifyPort^.MP_SIGBIT);  { for DOS Notify msgs         }
	TimerMask  := BitMask(TimerPort^.MP_SIGBIT);   { for Timer device prods      }
	WBMMask    := BitMask(WBMPort^.MP_SIGBIT);     { for AppMenuItems            } 

	
	While Not exitflag Do Begin
		sigre := Wait(WinMask|AppMask|WangiMask|CxMask|WBMMask|
		              NotifyMask|TimerMask|SIGBREAKF_CTRL_C);
		
		if ((sigre and SIGBREAKF_CTRL_C)=SIGBREAKF_CTRL_C) then
			ExitFlag := True;
		
		if ((sigre and TimerMask)=TimerMask) then begin
			Msg := GetMsg(TimerPort);
			While Msg <> NIL do begin
				If opened then begin
					If CD.cd_Level = LEV_BACKM then
						WindowToback(w);
					If CD.cd_Level = LEV_FRONT then
						WindowToFront(w);
				End;
				Msg := GetMsg(TimerPort);
			End;
			SendTimer;
		End;
		
		if ((sigre and WBMMask)=WBMMask) then begin
			am := pAppMessage(GetMsg(WBMPort));
			while am <> NIL do begin
				mnode := pMyNode(am^.am_UserData);
				If mnode <> NIL then begin
					Case mnode^.wi_Type of
						TYPE_SHELL : If NOT StartCLIProgram(mnode, am) then
							TellError(ERROR_SHELL);
						TYPE_WB : If NOT StartWBProgram(mnode, am) then
							TellError(ERROR_WB);
						TYPE_AREXX : SendARexxCommand(PtrToPas(mnode^.wi_RexxCmd),
					                                PtrToPas(mnode^.wi_RexxPort),am); 
					End;
				End;
				ReplyMsg(pMessage(am));
				am := pAppMessage(GetMsg(WBMPort));
			End;
		End;
		
		if ((sigre and WinMask)=WinMask) and (winmask <> 0) then begin
			hide := false;
			IDCMPMsg  := GT_GetIMsg(w^.userPort);
			while IDCMPMsg <> NIL do begin
				MsgClass := IDCMPMsg^.Class;
				MsgCode  := IDCMPMsg^.Code;
				GadCode  := pGadget(IDCMPMsg^.IAddress);
				secs     := IDCMPMsg^.Seconds;
				mics     := IDCMPMsg^.Micros;	
				GT_ReplyIMsg(IDCMPMsg);
				Case MsgClass Of
					IDCMP_CLOSEWINDOW   : begin
						Hide := True;
					End;
					IDCMP_REFRESHWINDOW : RefreshTheWindow(w);        
					IDCMP_GADGETUP      : HandleGadget(w, gadcode, msgcode);
					IDCMP_NEWSIZE       : HandleResize(w);
					IDCMP_VANILLAKEY    : Case MsgCode of
						27  { ESC    },
						81  { Q      },
						113 { q      },
						3   { Ctrl-C } : ExitFlag := True;
						72  { H      },
						104 { h      } : Hide := True;
						Else DisplayBeep(NIL);
					End;
					IDCMP_MENUPICK : Begin
						menunumber := msgcode;
						While (menunumber <> MENUNULL) do begin
							item := ItemAddress(menustrip, menunumber);
							Case LONG(GTMENUITEM_USERDATA(item)) of
								M_PREF : Begin
									mn := AllocVec(Sizeof(tMyNode), MEMF_CLEAR);
									if mn <> NIL then begin
										With mn^ do begin
											wi_Cmd[0]   := CStrConstPtrAR(@prk, '');
											wi_Cmd[1]   := CStrConstPtrAR(@prk, V.arg_PrefEd+' '+V.arg_From);
											wi_RexxPort := CStrConstPtrAR(@prk, '');
											wi_RexxCmd  := CStrConstPtrAR(@prk, '');
											wi_OutPut   := CStrConstPtrAR(@prk, 'NIL:'); 
										End;
										If NOT StartCLIProgram(mn, NIL) then
											TellError(ERROR_LOSTPREFS);
										FreeVec(mn);
									End;
								End; 
								M_ABOUT : Begin
									key := DisableWindow(w);
									ez := AllocVec(Sizeof(tEasyStruct), MEMF_CLEAR);
									if ez <> NIL then begin
										With ez^ do begin
											es_StructSize :=  Sizeof(tEasyStruct);
											es_Title := CStrConstPtrAR(@prk, 'WangiPad Information');
											es_TextFormat := CStrConstPtrAR(@prk, 
												'WangiPad Copyright ©Lee Kindness.'#10+
												'%s'#10#10+
												'The easiest way to launch your programs.'#10+
												'Read "WangiPad.Guide" for more information'#10#10+
												'Comments to:'#10+
												' Lee Kindness'#10+
												' 8 Craigmarn Road'#10+
												' Portlethen Village'#10+
												' Aberdeen AB1 4QR'#10+
												' SCOTLAND'#10#10+
												'Registered to: %s'#10+
												'ID: %lx');
											es_GadgetFormat := CStrConstPtrAR(@prk, 'Ok');
										End;
										al[0] := LONG(@WVer[6]);
										al[1] := LONG(CStrConstPtrAR(@prk, Reg.key_User));
										al[2] := Reg.key_ID;
										y := EasyRequestArgs(w, ez, NIL, @al);
										FreeVec(ez);
									end;
									EnableWindow(w, key);
								end;
								M_HIDE : hide := true;
								M_QUIT : ExitFlag := True;
							End;
							menunumber := item^.NextSelect;
						end;	
					End;
				End;
				if NOT Hide then
					IDCMPMsg  := GT_GetIMsg(w^.userPort)
				else begin
					IDCMPMsg  := GT_GetIMsg(w^.userPort);
					While IDCMPMsg <> NIL do begin
						{ remove all messages }
						GT_ReplyIMsg(IDCMPMsg);
						IDCMPMsg  := GT_GetIMsg(w^.userPort);
					End;
					{ close/hide window }
					HideWindow(w, winmask, appmask);
				End;
			End;
		End; {WinMask}
		
		if ((sigre and AppMask)=appMask) and (appmask <> 0) then begin
			am := pAppMessage(GetMsg(AppPort));
			while am <> NIL do begin
				LVY := am^.am_MouseY;
				If LVY > G[G_LV]^.TopEdge+2 then begin
					LVY := LVY-G[G_LV]^.TopEdge+2; { pixels below LV }
					If LVY < CD.cd_Font.ta_YSize then
						LVY := CD.cd_Font.ta_YSize;
					LVY := (Round(LVY / CD.cd_Font.ta_YSize))-1; { ordinal value of item }
					If LVY <= LVRows then begin
					
						{ count num of nodes }
						ordn := -1;
						nde := currentlist^.lh_Head;
						while nde^.ln_Succ <> NIL do begin
							ordn := ordn + 1;
							nde := nde^.ln_Succ;
						end;
						If LVY > Ordn then
							LVY := Ordn;
						
						{ If GadTools > 39 then get the current top }
						If GadToolsBase^.lib_Version >=39 then begin
							t[0] := GTLV_TOP;
							t[1] := LONG(@currenttop);
							t[2] := TAG_END;
							tmp2 := GT_GetGadgetAttrsA(G[G_LV], w, NIL, @t);
							if currenttop <> -1 then begin
								LVY := LVY + currenttop;
								If LVY > Ordn then
									LVY := Ordn;
							End;
						End;
							
						If currenttop <> -1 then begin
							{ Get appropriate node }
							nde := currentlist^.lh_Head;
							For ordn := 1 to LVY do
								nde := nde^.ln_Succ;
							
							{ Highlight node }
							t[0] := GTLV_Selected;
							t[1] := LVY;
							t[2] := TAG_END;
							GT_SetGadgetAttrsA(G[G_LV], w, NIL, @t);
						
							Case pMyNode(nde)^.wi_Type of
								TYPE_SHELL : If NOT StartCLIProgram(pMyNode(nde), am) then
									TellError(ERROR_SHELL);
								TYPE_WB : If NOT StartWBProgram(pMyNode(nde), am) then
									TellError(ERROR_WB);
								TYPE_AREXX : SendARexxCommand(PtrToPas(pMyNode(nde)^.wi_RexxCmd),
						                                  PtrToPas(pMyNode(nde)^.wi_RexxPort),am); 
							End;
						End else
							{ with WB 2 we cant work out the current top... }
							TellError(ERROR_NOTWB2);
								
					End;
				End;
				
				ReplyMsg(pMessage(am));
				am := pAppMessage(GetMsg(AppPort));
			End;
		End;
		
		if ((sigre and WangiMask)=WangiMask) then begin
			ipcmsg := pIPCMsg(GetMsg(WangiPort));
			While IPCMsg <> NIL do begin
				ipctype := ipcmsg^.ipc_Type;
				ReplyMsg(pMessage(ipcmsg));
				{ wangi prefs wants us to free msg mem }
				FreeVec(ipcmsg);
				
				Case ipctype of 
					IPC_REQUESTSIZES : begin
						{ WangiPrefs wants current dims. of the window }
						ipcmsg := AllocVec(sizeof(tIPCMsg), MEMF_CLEAR);
						if ipcmsg <> NIL then begin
							ipcmsg^.ipc_Msg.mn_Length := sizeof(tIPCMsg);
							If opened then begin
								ipcmsg^.ipc_Left   := w^.LeftEdge;
								ipcmsg^.ipc_Top    := w^.TopEdge;
								ipcmsg^.ipc_Width  := w^.Width;
								ipcmsg^.ipc_Height := w^.height;
							End else begin
								ipcmsg^.ipc_Left   :=hidenpos[1]; 
								ipcmsg^.ipc_Top    :=hidenpos[2]; 
								ipcmsg^.ipc_Width  :=hidenpos[3]; 
								ipcmsg^.ipc_Height :=hidenpos[4];
							End;
						
							ipcmsg^.ipc_Type := IPC_SENDSIZES;
							
							Forbid;
							Port := FindPort(CStrConstPtrAR(@grk, 'Wangi_Prefs_Port'));
							if port <> NIL then begin
								PutMsg(port, pMessage(ipcmsg));
								{ Wangiprefs will free the memory } 
								Permit;
							End else begin
								Permit;
								FreeVec(ipcmsg);
							End;
						End;
					End;
				End;
				
				ipcmsg := pIPCMsg(GetMsg(WangiPort));
			End;
		End;
		
		if ((sigre and CxMask)=CxMask) then begin
			CxMsg := pCxMsg(GetMsg(CxPort));
			While CxMsg <> NIL do begin
				cxtype := CxMsgType(CxMsg);
				cxid := pMyNode(CxMsgID(CxMsg));
				ReplyMsg(pMessage(CxMsg));
				Case cxtype of
					CXM_COMMAND : begin
						case LONG(cxid) of       { messages from exchange }
							CXCMD_DISABLE   : prev := ActivateCxObj(broker,0);
							CXCMD_ENABLE    : prev := ActivateCxObj(broker,1);
							CXCMD_APPEAR    : OpenUpWindow(w, winmask, appmask);
							CXCMD_DISAPPEAR : HideWindow(w, winmask, appmask);
							CXCMD_KILL      : ExitFlag := True; 
						end;
					end;
					CXM_IEVENT : Begin
						If LONG(cxid) = -1 then begin
							{ hotkey pressed, show/hide window }
							If w = NIL then
								OpenUpWindow(w, winmask, appmask)
							else
								HideWindow(w, winmask, appmask);
						End else if LONG(cxid) <> 0 then begin
							ordn := 0;
							nde := CurrentList^.lh_Head;
							While (nde^.ln_Succ <> NIL) and (nde <> pNode(cxid)) do begin
								ordn := ordn + 1;
								nde := nde^.ln_Succ;
							End;
							
							If w <> NIL then begin
								{ Highlight node }
								t[0] := GTLV_Selected;
								t[1] := Ordn;
								t[2] := GTLV_MakeVisible;
								t[3] := Ordn;
								If GadToolsBase^.lib_Version < 39 then
									t[4] := GTLV_Top
								else
									t[4] := TAG_IGNORE;
								t[5] := Ordn;
								t[6] := TAG_END;
								GT_SetGadgetAttrsA(G[G_LV], w, NIL, @t);
							End;
							
							{ start prog }
							Case cxid^.wi_Type of
								TYPE_SHELL : If NOT StartCLIProgram(cxid, NIL) then
									TellError(ERROR_SHELL);
								TYPE_WB : If NOT StartWBProgram(cxid, NIL) then
									TellError(ERROR_WB);
								TYPE_AREXX : SendARexxCommand(PtrToPas(cxid^.wi_RexxCmd),
						                              PtrToPas(cxid^.wi_RexxPort),NIL); 
							End;
						End;
					End;
				end;
				CxMsg := pCxMsg(GetMsg(CxPort));
			end;
		End;
		
		if ((sigre and NotifyMask)=NotifyMask) then begin
			NotifyMsg := pNotifyMessage(GetMsg(NotifyPort));
			While NotifyMsg <> NIL do begin
				If notifymsg^.nm_NReq^.nr_UserData = 337 then begin
					{ the prefs file has been changed, update }
					HideWindow(w, winmask, appmask);
					CloseFont(CD.cd_TFont);
					FreeWBMenus;
					FreeRemember(@prk, True);
					prk := NIL;
					if ReadConfigFile(V.arg_From,LM_LOAD, prk) then begin
						RemoveCx;
						OpenUpWindow(w, winmask, appmask);
						If InitCx then
							CxMask := BitMask(CxPort^.MP_SIGBIT);
						If InitWBMenus then
							WBMMask := BitMask(WBMPort^.MP_SIGBIT);
					End;
				End;
			
				ReplyMsg(pMessage(notifymsg));
				NotifyMsg := pNotifyMessage(GetMsg(NotifyPort));
			End;
		End;
				
		
	End; {while}
end;